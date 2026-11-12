#!/bin/bash
# Script de instalación automatizada de Pac-Man Arcade Chase para Samsung Galaxy Watch 3
DEVICE_IP="${1:-192.168.100.77:26101}"
SDB_BIN="sdb"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/tizen-native-pacman-arcade"
TARGET_DIR="/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist/com.samsung.watchface-noblesse-a8"

echo "Conectando a $DEVICE_IP..."
$SDB_BIN connect "$DEVICE_IP"
sleep 1

echo "Creando directorio..."
$SDB_BIN shell "mkdir -p $TARGET_DIR"

echo "Copiando archivos de Pac-Man Arcade..."
$SDB_BIN push "$SOURCE_DIR/"* "$TARGET_DIR/"
$SDB_BIN shell "chmod -R 777 $TARGET_DIR"

echo "Instalando icono..."
$SDB_BIN shell "mkdir -p /opt/usr/media/watchface_icons"
$SDB_BIN push "$SCRIPT_DIR/watchface_icons/pacman_arcade.png" "/opt/usr/media/watchface_icons/pacman_arcade.png"

echo "Actualizando base de datos del reloj..."
$SDB_BIN shell "sqlite3 /opt/dbspace/.clock_list_order.db \"UPDATE clock_order_info SET label='Pac-Man Arcade', iconpath='/opt/usr/media/watchface_icons/pacman_arcade.png', view='analog' WHERE pkgid='com.samsung.watchface-noblesse-a8';\""

echo "Activando carátula..."
$SDB_BIN push "$SOURCE_DIR/com.samsung.watchface-noblesse-a8_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

echo "Reiniciando interfaz..."
$SDB_BIN shell "pkgcmd -k -n com.samsung.watchface"
$SDB_BIN shell "app_launcher -s com.samsung.w-home"

echo "¡Pac-Man Arcade instalada y activada!"
