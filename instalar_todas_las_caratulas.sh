#!/bin/bash
# Script para desplegar las 7 carátulas legendarias en Samsung Galaxy Watch 3
DEVICE_IP="${1:-192.168.100.77:26101}"
SDB="${2:-sdb}"

echo -e "\033[36m==========================================================\033[0m"
echo -e "\033[33m Desplegando Carrusel Séptuple de Carátulas en Galaxy Watch\033[0m"
echo -e "\033[37m  1. Casio Royale AE-1200 (noblesse-u3) -> 'Casio Royale'\033[0m"
echo -e "\033[37m  2. G-Shock GA-100       (noblesse-a8) -> 'G-Shock GA-100'\033[0m"
echo -e "\033[37m  3. MoveToBeActive Garmin(noblesse-a7) -> 'MoveToBeActive'\033[0m"
echo -e "\033[37m  4. Terminal Linux 34px  (noblesse-u1) -> 'Terminal Linux'\033[0m"
echo -e "\033[37m  5. Concentric Pixel Quad(noblesse-u6) -> 'Concentric Pixel'\033[0m"
echo -e "\033[37m  6. Odyssey Digital      (noblesse-a4) -> 'Odyssey Digital'\033[0m"
echo -e "\033[37m  7. Casio Classic A158W  (noblesse-a5) -> 'Casio Classic'\033[0m"
echo -e "\033[36m==========================================================\033[0m"

echo -e "\033[32m[1/9] Conectando a $DEVICE_IP...\033[0m"
$SDB connect "$DEVICE_IP"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_REMOTE="/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist"

# 1. Casio Royale
$SDB shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-u3"
$SDB push "$SCRIPT_DIR/tizen-native-casio-royale"/* "$BASE_REMOTE/com.samsung.watchface-noblesse-u3/"
$SDB shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-u3"

# 2. GA-100
$SDB shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-a8"
$SDB push "$SCRIPT_DIR/tizen-native-ga100-tacblack"/* "$BASE_REMOTE/com.samsung.watchface-noblesse-a8/"
$SDB shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-a8"

# 3. MoveToBeActive
$SDB shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-a7"
$SDB push "$SCRIPT_DIR/tizen-native-movetobeactive"/* "$BASE_REMOTE/com.samsung.watchface-noblesse-a7/"
$SDB shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-a7"

# 4. Terminal
$SDB shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-u1"
$SDB push "$SCRIPT_DIR/tizen-native-terminal"/* "$BASE_REMOTE/com.samsung.watchface-noblesse-u1/"
$SDB shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-u1"

# 5. Concentric
$SDB shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-u6"
$SDB push "$SCRIPT_DIR/tizen-native-concentric"/* "$BASE_REMOTE/com.samsung.watchface-noblesse-u6/"
$SDB shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-u6"

# 6. Odyssey Digital
$SDB shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-a4"
$SDB push "$SCRIPT_DIR/tizen-native-odyssey-digital"/* "$BASE_REMOTE/com.samsung.watchface-noblesse-a4/"
$SDB shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-a4"

# 7. Casio Classic
$SDB shell "mkdir -p $BASE_REMOTE/com.samsung.watchface-noblesse-a5"
$SDB push "$SCRIPT_DIR/tizen-native-casio-classic"/* "$BASE_REMOTE/com.samsung.watchface-noblesse-a5/"
$SDB shell "chmod -R 777 $BASE_REMOTE/com.samsung.watchface-noblesse-a5"

# Miniaturas del selector
$SDB shell "mkdir -p /opt/usr/media/watchface_icons"
$SDB push "$SCRIPT_DIR/watchface_icons"/* "/opt/usr/media/watchface_icons/"
$SDB shell "chmod -R 777 /opt/usr/media/watchface_icons"

# Base de datos
$SDB shell "sqlite3 /opt/dbspace/.clock_list_order.db \"
UPDATE clock_order_info SET label='Casio Royale', iconpath='/opt/usr/media/watchface_icons/casio_royale.png', rorder=1, corder=1 WHERE pkgid='com.samsung.watchface-noblesse-u3';
UPDATE clock_order_info SET label='G-Shock GA-100', iconpath='/opt/usr/media/watchface_icons/gshock_ga100.png', rorder=2, corder=2 WHERE pkgid='com.samsung.watchface-noblesse-a8';
UPDATE clock_order_info SET label='MoveToBeActive', iconpath='/opt/usr/media/watchface_icons/movetobeactive.png', rorder=3, corder=3 WHERE pkgid='com.samsung.watchface-noblesse-a7';
UPDATE clock_order_info SET label='Terminal Linux', iconpath='/opt/usr/media/watchface_icons/terminal_linux.png', rorder=4, corder=4 WHERE pkgid='com.samsung.watchface-noblesse-u1';
UPDATE clock_order_info SET label='Concentric Pixel', iconpath='/opt/usr/media/watchface_icons/concentric_pixel.png', rorder=5, corder=5 WHERE pkgid='com.samsung.watchface-noblesse-u6';
UPDATE clock_order_info SET label='Odyssey Digital', iconpath='/opt/usr/media/watchface_icons/odyssey_digital.png', rorder=6, corder=6 WHERE pkgid='com.samsung.watchface-noblesse-a4';
UPDATE clock_order_info SET label='Casio Classic', iconpath='/opt/usr/media/watchface_icons/casio_classic.png', rorder=7, corder=7 WHERE pkgid='com.samsung.watchface-noblesse-a5';
\""

# Activar Casio Classic
$SDB push "$SCRIPT_DIR/tizen-native-casio-classic/com.samsung.watchface-noblesse-a5_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
$SDB shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

# Reiniciar servicios
$SDB shell "pkgcmd -k -n com.samsung.watchface"
$SDB shell "app_launcher -s com.samsung.w-home"

echo ""
echo -e "\033[32m¡Las 7 carátulas están listas con sus nombres personalizados y miniaturas reales!\033[0m"
