#!/bin/bash
# Script para desplegar las 5 carátulas legendarias en Samsung Galaxy Watch 3

DEVICE_IP="${1:-192.168.100.77:26101}"
SDB_PATH="${2:-sdb}"

echo "=========================================================="
echo " Desplegando Carrusel Quíntuple de Carátulas en Galaxy Watch"
echo "  1. Casio Royale AE-1200 (noblesse-u3) -> 'Casio Royale'"
echo "  2. G-Shock GA-100       (noblesse-a8) -> 'G-Shock GA-100'"
echo "  3. MoveToBeActive Garmin(noblesse-a7) -> 'MoveToBeActive'"
echo "  4. Terminal Linux 34px  (noblesse-u1) -> 'Terminal Linux'"
echo "  5. Concentric Pixel Quad(noblesse-u6) -> 'Concentric Pixel'"
echo "=========================================================="

echo "[1/8] Conectando a $DEVICE_IP..."
$SDB_PATH connect $DEVICE_IP

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_REMOTE="/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist"

echo "[2/8] Instalando Casio Royale AE-1200 (slot noblesse-u3)..."
CASIO_LOCAL="$SCRIPT_DIR/tizen-native-casio-royale"
CASIO_REMOTE="$BASE_REMOTE/com.samsung.watchface-noblesse-u3"
$SDB_PATH shell "mkdir -p $CASIO_REMOTE"
$SDB_PATH push "$CASIO_LOCAL/"* "$CASIO_REMOTE/"
$SDB_PATH shell "chmod -R 777 $CASIO_REMOTE"

echo "[3/8] Instalando G-Shock GA-100 TacBlack (slot noblesse-a8)..."
GA_LOCAL="$SCRIPT_DIR/tizen-native-ga100-tacblack"
GA_REMOTE="$BASE_REMOTE/com.samsung.watchface-noblesse-a8"
$SDB_PATH shell "mkdir -p $GA_REMOTE"
$SDB_PATH push "$GA_LOCAL/"* "$GA_REMOTE/"
$SDB_PATH shell "chmod -R 777 $GA_REMOTE"

echo "[4/8] Instalando MoveToBeActive (slot noblesse-a7)..."
MTBA_LOCAL="$SCRIPT_DIR/tizen-native-movetobeactive"
MTBA_REMOTE="$BASE_REMOTE/com.samsung.watchface-noblesse-a7"
$SDB_PATH shell "mkdir -p $MTBA_REMOTE"
$SDB_PATH push "$MTBA_LOCAL/"* "$MTBA_REMOTE/"
$SDB_PATH shell "chmod -R 777 $MTBA_REMOTE"

echo "[5/8] Instalando Terminal Watchface (slot noblesse-u1)..."
TERM_LOCAL="$SCRIPT_DIR/tizen-native-terminal"
TERM_REMOTE="$BASE_REMOTE/com.samsung.watchface-noblesse-u1"
$SDB_PATH shell "mkdir -p $TERM_REMOTE"
$SDB_PATH push "$TERM_LOCAL/"* "$TERM_REMOTE/"
$SDB_PATH shell "chmod -R 777 $TERM_REMOTE"

echo "[6/8] Instalando Concentric Watchface (slot noblesse-u6)..."
CONC_LOCAL="$SCRIPT_DIR/tizen-native-concentric"
CONC_REMOTE="$BASE_REMOTE/com.samsung.watchface-noblesse-u6"
$SDB_PATH shell "mkdir -p $CONC_REMOTE"
$SDB_PATH push "$CONC_LOCAL/"* "$CONC_REMOTE/"
$SDB_PATH shell "chmod -R 777 $CONC_REMOTE"

echo "[7/8] Configurando Casio Royale como carátula inicial activa..."
$SDB_PATH push "$CASIO_LOCAL/com.samsung.watchface-noblesse-u3_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
$SDB_PATH shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

echo "[8/8] Reiniciando servicios de reloj..."
$SDB_PATH shell "pkgcmd -k -n com.samsung.watchface"
$SDB_PATH shell "app_launcher -s com.samsung.w-home"

echo ""
echo "¡Las 5 carátulas están listas con sus nombres personalizados!"
echo "Mantén pulsada la pantalla 2 segundos para rotar entre ellas con el bisel físico."
