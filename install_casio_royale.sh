#!/bin/bash
# Script de instalación automatizada de Casio Royale AE-1200 para Samsung Galaxy Watch 3 (Tizen OS)

DEVICE_IP="${1:-192.168.100.77:26101}"
SDB_PATH="${2:-sdb}"

echo "=========================================================="
echo "   Instalador Nativo Casio Royale AE-1200                 "
echo "   Samsung Galaxy Watch 3 (SM-R840, Tizen OS 5.5)         "
echo "=========================================================="

echo "[1/5] Conectando a $DEVICE_IP..."
$SDB_PATH connect $DEVICE_IP

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/tizen-native-casio-royale"
TARGET_DIR="/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist/com.samsung.watchface-noblesse-u3"

echo "[2/5] Creando directorio en el reloj ($TARGET_DIR)..."
$SDB_PATH shell "mkdir -p $TARGET_DIR"

echo "[3/5] Transfiriendo archivos de carátula..."
$SDB_PATH push "$SOURCE_DIR/"* "$TARGET_DIR/"
$SDB_PATH shell "chmod -R 777 $TARGET_DIR"

echo "[4/5] Activando Casio Royale AE-1200 en result.xml..."
$SDB_PATH push "$SOURCE_DIR/com.samsung.watchface-noblesse-u3_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
$SDB_PATH shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

echo "[5/5] Recargando el servicio de pantalla de inicio..."
$SDB_PATH shell "pkgcmd -k -n com.samsung.watchface"
$SDB_PATH shell "app_launcher -s com.samsung.w-home"

echo ""
echo "¡Casio Royale AE-1200 instalado exitosamente!"
