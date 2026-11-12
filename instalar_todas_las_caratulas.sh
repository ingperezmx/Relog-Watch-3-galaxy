#!/bin/bash
# Script para desplegar las 9 carátulas legendarias en Samsung Galaxy Watch 3
DEVICE_IP="${1:-192.168.100.77:26101}"
SDB_BIN="sdb"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_REMOTE="/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist"

echo "Conectando a $DEVICE_IP..."
$SDB_BIN connect "$DEVICE_IP"
sleep 1

deploy_watchface() {
    local name="$1"
    local local_dir="$2"
    local slot="$3"
    echo "Instalando $name ($slot)..."
    $SDB_BIN shell "mkdir -p $BASE_REMOTE/$slot"
    $SDB_BIN push "$SCRIPT_DIR/$local_dir/"* "$BASE_REMOTE/$slot/"
    $SDB_BIN shell "chmod -R 777 $BASE_REMOTE/$slot"
}

deploy_watchface "Casio Royale" "tizen-native-casio-royale" "com.samsung.watchface-noblesse-u3"
deploy_watchface "Pac-Man Arcade" "tizen-native-pacman-arcade" "com.samsung.watchface-noblesse-a8"
deploy_watchface "MoveToBeActive" "tizen-native-movetobeactive" "com.samsung.watchface-noblesse-a7"
deploy_watchface "Terminal Linux" "tizen-native-terminal" "com.samsung.watchface-noblesse-u1"
deploy_watchface "Concentric Pixel" "tizen-native-concentric" "com.samsung.watchface-noblesse-u6"
deploy_watchface "Odyssey Digital" "tizen-native-odyssey-digital" "com.samsung.watchface-noblesse-a4"
deploy_watchface "Casio Classic" "tizen-native-casio-classic" "com.samsung.watchface-noblesse-a5"
deploy_watchface "Hublot Skeleton" "tizen-native-rolex-skeleton" "com.samsung.watchface-noblesse-a1"
deploy_watchface "ICU Pulse" "tizen-native-icu-pulse" "com.samsung.watchface-noblesse-a2"

echo "Instalando miniaturas..."
$SDB_BIN shell "mkdir -p /opt/usr/media/watchface_icons"
$SDB_BIN push "$SCRIPT_DIR/watchface_icons/"* "/opt/usr/media/watchface_icons/"
$SDB_BIN shell "chmod -R 777 /opt/usr/media/watchface_icons"

echo "Actualizando base de datos del carrusel..."
$SDB_BIN shell "sqlite3 /opt/dbspace/.clock_list_order.db \"UPDATE clock_order_info SET label='Casio Royale', iconpath='/opt/usr/media/watchface_icons/casio_royale.png', rorder=1, corder=1 WHERE pkgid='com.samsung.watchface-noblesse-u3';\""
$SDB_BIN shell "sqlite3 /opt/dbspace/.clock_list_order.db \"UPDATE clock_order_info SET label='Pac-Man Arcade', iconpath='/opt/usr/media/watchface_icons/pacman_arcade.png', rorder=2, corder=2, view='analog' WHERE pkgid='com.samsung.watchface-noblesse-a8';\""
$SDB_BIN shell "sqlite3 /opt/dbspace/.clock_list_order.db \"UPDATE clock_order_info SET label='MoveToBeActive', iconpath='/opt/usr/media/watchface_icons/movetobeactive.png', rorder=3, corder=3 WHERE pkgid='com.samsung.watchface-noblesse-a7';\""
$SDB_BIN shell "sqlite3 /opt/dbspace/.clock_list_order.db \"UPDATE clock_order_info SET label='Terminal Linux', iconpath='/opt/usr/media/watchface_icons/terminal_linux.png', rorder=4, corder=4 WHERE pkgid='com.samsung.watchface-noblesse-u1';\""
$SDB_BIN shell "sqlite3 /opt/dbspace/.clock_list_order.db \"UPDATE clock_order_info SET label='Concentric Pixel', iconpath='/opt/usr/media/watchface_icons/concentric_pixel.png', rorder=5, corder=5 WHERE pkgid='com.samsung.watchface-noblesse-u6';\""
$SDB_BIN shell "sqlite3 /opt/dbspace/.clock_list_order.db \"UPDATE clock_order_info SET label='Odyssey Digital', iconpath='/opt/usr/media/watchface_icons/odyssey_digital.png', rorder=6, corder=6 WHERE pkgid='com.samsung.watchface-noblesse-a4';\""
$SDB_BIN shell "sqlite3 /opt/dbspace/.clock_list_order.db \"UPDATE clock_order_info SET label='Casio Classic', iconpath='/opt/usr/media/watchface_icons/casio_classic.png', rorder=7, corder=7 WHERE pkgid='com.samsung.watchface-noblesse-a5';\""
$SDB_BIN shell "sqlite3 /opt/dbspace/.clock_list_order.db \"UPDATE clock_order_info SET label='Hublot Skeleton', iconpath='/opt/usr/media/watchface_icons/rolex_skeleton.png', rorder=8, corder=8, view='analog' WHERE pkgid='com.samsung.watchface-noblesse-a1';\""
$SDB_BIN shell "sqlite3 /opt/dbspace/.clock_list_order.db \"UPDATE clock_order_info SET label='ICU Pulse', iconpath='/opt/usr/media/watchface_icons/icu_pulse.png', rorder=9, corder=9, view='digital' WHERE pkgid='com.samsung.watchface-noblesse-a2';\""

echo "Activando Hublot Skeleton..."
$SDB_BIN push "$SCRIPT_DIR/tizen-native-rolex-skeleton/com.samsung.watchface-noblesse-a1_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

echo "Reiniciando interfaz..."
$SDB_BIN shell "pkgcmd -k -n com.samsung.watchface"
$SDB_BIN shell "app_launcher -s com.samsung.w-home"

echo "¡Todas las carátulas desplegadas exitosamente!"
