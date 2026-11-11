#!/bin/bash
# Script para desplegar las 4 carátulas (G-Shock GA-100, MoveToBeActive, Terminal y Concentric) en Galaxy Watch 3

DEVICE_IP="${1:-192.168.100.77:26101}"
SDB_PATH="${2:-sdb}"

echo "=========================================================="
echo " Desplegando Carrusel Cuádruple de Carátulas en Galaxy Watch"
echo "  1. G-Shock GA-100 TacBlack (noblesse-a8)               "
echo "  2. MoveToBeActive Garmin   (noblesse-a7)               "
echo "  3. Terminal Linux CLI 28px (noblesse-u1)               "
echo "  4. Concentric Pixel Quad   (noblesse-u6)               "
echo "=========================================================="

echo "[1/7] Conectando a $DEVICE_IP..."
$SDB_PATH connect $DEVICE_IP

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_REMOTE="/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist"

echo "[2/7] Instalando G-Shock GA-100 TacBlack (slot noblesse-a8)..."
GA_LOCAL="$SCRIPT_DIR/tizen-native-ga100-tacblack"
GA_REMOTE="$BASE_REMOTE/com.samsung.watchface-noblesse-a8"
$SDB_PATH shell "mkdir -p $GA_REMOTE"
$SDB_PATH push "$GA_LOCAL/"* "$GA_REMOTE/"
$SDB_PATH shell "chmod -R 777 $GA_REMOTE"

echo "[3/7] Instalando MoveToBeActive (slot noblesse-a7)..."
MTBA_LOCAL="$SCRIPT_DIR/tizen-native-movetobeactive"
MTBA_REMOTE="$BASE_REMOTE/com.samsung.watchface-noblesse-a7"
$SDB_PATH shell "mkdir -p $MTBA_REMOTE"
$SDB_PATH push "$MTBA_LOCAL/"* "$MTBA_REMOTE/"
$SDB_PATH shell "chmod -R 777 $MTBA_REMOTE"

echo "[4/7] Instalando Terminal Watchface (slot noblesse-u1)..."
TERM_LOCAL="$SCRIPT_DIR/tizen-native-terminal"
TERM_REMOTE="$BASE_REMOTE/com.samsung.watchface-noblesse-u1"
$SDB_PATH shell "mkdir -p $TERM_REMOTE"
$SDB_PATH push "$TERM_LOCAL/"* "$TERM_REMOTE/"
$SDB_PATH shell "chmod -R 777 $TERM_REMOTE"

echo "[5/7] Verificando Concentric Watchface (slot noblesse-u6)..."
CONC_LOCAL="$SCRIPT_DIR/tizen-native-concentric"
CONC_REMOTE="$BASE_REMOTE/com.samsung.watchface-noblesse-u6"
$SDB_PATH shell "mkdir -p $CONC_REMOTE"
$SDB_PATH push "$CONC_LOCAL/"* "$CONC_REMOTE/"
$SDB_PATH shell "chmod -R 777 $CONC_REMOTE"

echo "[6/7] Configurando G-Shock GA-100 TacBlack como carátula inicial activa..."
$SDB_PATH push "$GA_LOCAL/com.samsung.watchface-noblesse-a8_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
$SDB_PATH shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

echo "[7/7] Reiniciando servicios de reloj..."
$SDB_PATH shell "pkgcmd -k -n com.samsung.watchface"
$SDB_PATH shell "app_launcher -s com.samsung.w-home"

echo ""
echo "¡Las 4 carátulas están listas y disponibles en tu reloj!"
echo "Mantén pulsada la pantalla para alternar entre ellas con el bisel giratorio."
