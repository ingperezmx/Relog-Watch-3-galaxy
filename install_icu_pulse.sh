#!/bin/bash
# Script de instalación automatizada de ICU Pulse para Samsung Galaxy Watch 3
DEVICE_IP="${1:-192.168.100.77:26101}"
SDB_BIN="sdb"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/tizen-native-icu-pulse"
TARGET_DIR="/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist/com.samsung.watchface-noblesse-a2"

echo "Conectando a $DEVICE_IP..."
$SDB_BIN connect "$DEVICE_IP"
sleep 1

echo "Creando directorio..."
$SDB_BIN shell "mkdir -p $TARGET_DIR"

echo "Copiando archivos de ICU Pulse..."
$SDB_BIN push "$SOURCE_DIR/"* "$TARGET_DIR/"
$SDB_BIN shell "chmod -R 777 $TARGET_DIR"

echo "Instalando icono..."
$SDB_BIN shell "mkdir -p /opt/usr/media/watchface_icons"
$SDB_BIN push "$SCRIPT_DIR/watchface_icons/icu_pulse.png" "/opt/usr/media/watchface_icons/icu_pulse.png"

echo "Actualizando base de datos del reloj..."
$SDB_BIN shell "sqlite3 /opt/dbspace/.clock_list_order.db \"UPDATE clock_order_info SET label='ICU Pulse', iconpath='/opt/usr/media/watchface_icons/icu_pulse.png', view='digital' WHERE pkgid='com.samsung.watchface-noblesse-a2';\""

echo "Activando carátula..."
$SDB_BIN push "$SOURCE_DIR/com.samsung.watchface-noblesse-a2_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

echo "Reiniciando interfaz..."
$SDB_BIN shell "pkgcmd -k -n com.samsung.watchface"
$SDB_BIN shell "app_launcher -s com.samsung.w-home"

echo "¡ICU Pulse instalada y activada!"
