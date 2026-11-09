#!/bin/bash
# Script para desplegar las 3 carátulas (MoveToBeActive, Terminal y Concentric) en Galaxy Watch 3

DEVICE_IP="${1:-192.168.100.77:26101}"
SDB="${2:-sdb}"

echo -e "\033[36m==========================================================\033[0m"
echo -e "\033[33m Desplegando Carrusel Triple de Carátulas en Galaxy Watch \033[0m"
echo -e "\033[37m  1. MoveToBeActive (noblesse-a7)                        \033[0m"
echo -e "\033[37m  2. Terminal 28px  (noblesse-u1)                        \033[0m"
echo -e "\033[37m  3. Concentric     (noblesse-u6)                        \033[0m"
echo -e "\033[36m==========================================================\033[0m"

echo -e "\033[32m[1/6] Conectando a $DEVICE_IP...\033[0m"
$SDB connect "$DEVICE_IP"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_REMOTE="/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist"

echo -e "\033[32m[2/6] Instalando MoveToBeActive (slot noblesse-a7)...\033[0m"
MTBA_LOCAL="$SCRIPT_DIR/tizen-native-movetobeactive"
MTBA_REMOTE="$BASE_REMOTE/com.samsung.watchface-noblesse-a7"
$SDB shell "mkdir -p $MTBA_REMOTE"
$SDB push "$MTBA_LOCAL"/* "$MTBA_REMOTE/"
$SDB shell "chmod -R 777 $MTBA_REMOTE"

echo -e "\033[32m[3/6] Instalando Terminal Watchface (slot noblesse-u1)...\033[0m"
TERM_LOCAL="$SCRIPT_DIR/tizen-native-terminal"
TERM_REMOTE="$BASE_REMOTE/com.samsung.watchface-noblesse-u1"
$SDB shell "mkdir -p $TERM_REMOTE"
$SDB push "$TERM_LOCAL"/* "$TERM_REMOTE/"
$SDB shell "chmod -R 777 $TERM_REMOTE"

echo -e "\033[32m[4/6] Verificando Concentric Watchface (slot noblesse-u6)...\033[0m"
CONC_LOCAL="$SCRIPT_DIR/tizen-native-concentric"
CONC_REMOTE="$BASE_REMOTE/com.samsung.watchface-noblesse-u6"
$SDB shell "mkdir -p $CONC_REMOTE"
$SDB push "$CONC_LOCAL"/* "$CONC_REMOTE/"
$SDB shell "chmod -R 777 $CONC_REMOTE"

echo -e "\033[32m[5/6] Configurando MoveToBeActive como carátula inicial activa...\033[0m"
$SDB push "$MTBA_LOCAL/com.samsung.watchface-noblesse-a7_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
$SDB shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

echo -e "\033[32m[6/6] Reiniciando servicios de reloj...\033[0m"
$SDB shell "pkgcmd -k -n com.samsung.watchface"
$SDB shell "app_launcher -s com.samsung.w-home"

echo ""
echo -e "\033[32m¡Las 3 carátulas están listas y disponibles en tu reloj!\033[0m"
echo -e "\033[33mMantén pulsada la pantalla durante 2 segundos para alternar libremente entre ellas con el bisel giratorio.\033[0m"
