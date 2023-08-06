#!/usr/bin/env bash

#==================
# Verificando existencia de dependencias

# Lista de dependências necessárias
dependencies=("adb" "pv")

# Verifica cada dependência na lista
for dependency in "${dependencies[@]}"; do
    if ! command -v "$dependency" &>/dev/null; then
        echo "$dependency is required. ABORTED."
        exit 1
    fi
done

#==================
# Funçao de encerramento

# Função chamada ao pressionar Ctrl + C
function ctrl_c() {
    clear
    echo "[+] (Ctrl + C ) Detectado, Tentativa de saida ..."
    sleep 2s
    echo "[+] Encerrando serviços, Aguarde..."
    echo "[+] Obrigado por usar este programa =)."
    rm -rf .android
    exit 1
}

# Define a função de tratamento de interrupção
trap ctrl_c INT

#==================
# Verifica se a variavel esta vazia

# Verifica se há um IP fornecido como segundo argumento
if [ -z "$2" ]; then
    echo "Formas de uso:
    (./connect.sh -ip IP)
    " | pv -qL 10
    exit 1
fi

#==================
# Variaveis

# Define as variáveis IP e PORT
IP="${2}"
PORT="5555"

#==================
# Cerebro do script

# Função para conectar ao dispositivo
function _connect() {
    while true; do
        OUTPUT=$(adb connect "${IP}:${PORT}")
        if [[ $OUTPUT == *connected* ]]; then
            echo "[!] SUCESSO!! Conectado a ${IP}:${PORT}"
            echo "[+] Pegando shell"
            sleep 1s
            adb shell 2> /dev/null || adb devices
            exit 1
        fi
        echo "[*] Conectando..."
        sleep .25
    done
}

#==================
# Função ajuda

# Função para mostrar informações de uso
function help() {
    echo "Formas de uso:
    (./connect.sh -ip IP)
    " | pv -qL 10
}

#==================
# Verificando parametro informado

# Verifica o primeiro argumento para determinar a ação
case "${1}" in
    "-ip"|"-IP") _connect;;
    *) help;;
esac
