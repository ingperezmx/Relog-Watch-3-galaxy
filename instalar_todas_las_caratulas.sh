#!/usr/bin/env bash
# Script para desplegar las 8 carátulas legendarias en Samsung Galaxy Watch 3

DEVICE_IP="${1:-192.168.100.77:26101}"
SDB_PATH="sdb"

if ! command -v sdb &>/dev/null; then
    FALLBACK_SDB="C:/Users/user/.gemini/antigravity/brain/4e029f08-114e-4ce8-90a1-d16963cf9144/scratch/sdb/data/tools/sdb.exe"
    if [ -f "$FALLBACK_SDB" ]; then
        SDB_PATH="$FALLBACK_SDB"
    fi
fi

echo "=========================================================="
echo " Desplegando Carrusel Óctuple de Carátulas en Galaxy Watch"
echo "  1. Casio Royale AE-1200 (noblesse-u3) -> 'Casio Royale'"
echo "  2. G-Shock GA-100       (noblesse-a8) -> 'G-Shock GA-100'"
echo "  3. MoveToBeActive Garmin(noblesse-a7) -> 'MoveToBeActive'"
echo "  4. Terminal Linux 34px  (noblesse-u1) -> 'Terminal Linux'"
echo "  5. Concentric Pixel Quad(noblesse-u6) -> 'Concentric Pixel'"
echo "  6. Odyssey Digital      (noblesse-a4) -> 'Odyssey Digital'"
echo "  7. Casio Classic A158W  (noblesse-a5) -> 'Casio Classic'"
echo "  8. Rolex Skeleton Tourb (noblesse-a1) -> 'Rolex Skeleton'"
echo "=========================================================="

ensure_sdb() {
    if ! "$SDB_PATH" devices | grep -q "$DEVICE_IP.*device"; then
        echo "Reconectando con el reloj..."
        for k in {1..5}; do
            "$SDB_PATH" connect "$DEVICE_IP" &>/dev/null
            sleep 0.7
            if "$SDB_PATH" devices | grep -q "$DEVICE_IP.*device"; then break; fi
        done
    fi
}

echo "[1/10] Conectando a $DEVICE_IP..."
ensure_sdb

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_REMOTE="/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist"

echo "[2/11] Instalando Casio Royale AE-1200..."
ensure_sdb
"$SDB_PATH" shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-u3"
"$SDB_PATH" push "$SCRIPT_DIR/tizen-native-casio-royale/"* "$BASE_REMOTE/com.samsung.watchface-noblesse-u3/"
"$SDB_PATH" shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-u3"

echo "[3/11] Instalando G-Shock GA-100..."
ensure_sdb
"$SDB_PATH" shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-a8"
"$SDB_PATH" push "$SCRIPT_DIR/tizen-native-ga100-tacblack/"* "$BASE_REMOTE/com.samsung.watchface-noblesse-a8/"
"$SDB_PATH" shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-a8"

echo "[4/11] Instalando MoveToBeActive..."
ensure_sdb
"$SDB_PATH" shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-a7"
"$SDB_PATH" push "$SCRIPT_DIR/tizen-native-movetobeactive/"* "$BASE_REMOTE/com.samsung.watchface-noblesse-a7/"
"$SDB_PATH" shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-a7"

echo "[5/11] Instalando Terminal..."
ensure_sdb
"$SDB_PATH" shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-u1"
"$SDB_PATH" push "$SCRIPT_DIR/tizen-native-terminal/"* "$BASE_REMOTE/com.samsung.watchface-noblesse-u1/"
"$SDB_PATH" shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-u1"

echo "[6/11] Instalando Concentric..."
ensure_sdb
"$SDB_PATH" shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-u6"
"$SDB_PATH" push "$SCRIPT_DIR/tizen-native-concentric/"* "$BASE_REMOTE/com.samsung.watchface-noblesse-u6/"
"$SDB_PATH" shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-u6"

echo "[7/11] Instalando Odyssey Digital..."
ensure_sdb
"$SDB_PATH" shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-a4"
"$SDB_PATH" push "$SCRIPT_DIR/tizen-native-odyssey-digital/"* "$BASE_REMOTE/com.samsung.watchface-noblesse-a4/"
"$SDB_PATH" shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-a4"

echo "[8/11] Instalando Casio Classic A158W..."
ensure_sdb
"$SDB_PATH" shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-a5"
"$SDB_PATH" push "$SCRIPT_DIR/tizen-native-casio-classic/"* "$BASE_REMOTE/com.samsung.watchface-noblesse-a5/"
"$SDB_PATH" shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-a5"

echo "[9/11] Instalando Rolex Skeleton..."
ensure_sdb
"$SDB_PATH" shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-a1"
"$SDB_PATH" push "$SCRIPT_DIR/tizen-native-rolex-skeleton/"* "$BASE_REMOTE/com.samsung.watchface-noblesse-a1/"
"$SDB_PATH" shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-a1"

echo "[10/13] Instalando miniaturas personalizadas..."
ensure_sdb
"$SDB_PATH" shell "mkdir -p /opt/usr/media/watchface_icons"
"$SDB_PATH" push "$SCRIPT_DIR/watchface_icons/"* "/opt/usr/media/watchface_icons/"
"$SDB_PATH" shell "chmod -R 777 /opt/usr/media/watchface_icons"

echo "[11/13] Configurando nombres reales e iconos en el carrusel del reloj..."
ensure_sdb
SQL="
UPDATE clock_order_info SET label='Casio Royale', iconpath='/opt/usr/media/watchface_icons/casio_royale.png', rorder=1, corder=1 WHERE pkgid='com.samsung.watchface-noblesse-u3';
UPDATE clock_order_info SET label='G-Shock GA-100', iconpath='/opt/usr/media/watchface_icons/gshock_ga100.png', rorder=2, corder=2 WHERE pkgid='com.samsung.watchface-noblesse-a8';
UPDATE clock_order_info SET label='MoveToBeActive', iconpath='/opt/usr/media/watchface_icons/movetobeactive.png', rorder=3, corder=3 WHERE pkgid='com.samsung.watchface-noblesse-a7';
UPDATE clock_order_info SET label='Terminal Linux', iconpath='/opt/usr/media/watchface_icons/terminal_linux.png', rorder=4, corder=4 WHERE pkgid='com.samsung.watchface-noblesse-u1';
UPDATE clock_order_info SET label='Concentric Pixel', iconpath='/opt/usr/media/watchface_icons/concentric_pixel.png', rorder=5, corder=5 WHERE pkgid='com.samsung.watchface-noblesse-u6';
UPDATE clock_order_info SET label='Odyssey Digital', iconpath='/opt/usr/media/watchface_icons/odyssey_digital.png', rorder=6, corder=6 WHERE pkgid='com.samsung.watchface-noblesse-a4';
UPDATE clock_order_info SET label='Casio Classic', iconpath='/opt/usr/media/watchface_icons/casio_classic.png', rorder=7, corder=7 WHERE pkgid='com.samsung.watchface-noblesse-a5';
UPDATE clock_order_info SET label='Rolex Skeleton', iconpath='/opt/usr/media/watchface_icons/rolex_skeleton.png', rorder=8, corder=8 WHERE pkgid='com.samsung.watchface-noblesse-a1';
"
"$SDB_PATH" shell "echo \"$SQL\" | sqlite3 /opt/dbspace/.clock_list_order.db"

echo "[12/13] Configurando Rolex Skeleton como carátula inicial activa..."
ensure_sdb
"$SDB_PATH" push "$SCRIPT_DIR/tizen-native-rolex-skeleton/com.samsung.watchface-noblesse-a1_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
"$SDB_PATH" shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

echo "[13/13] Reiniciando servicios de reloj..."
ensure_sdb
"$SDB_PATH" shell "pkgcmd -k -n com.samsung.watchface"
"$SDB_PATH" shell "app_launcher -s com.samsung.w-home"

echo ""
echo "¡Las 8 carátulas están listas con sus nombres personalizados y miniaturas reales!"
