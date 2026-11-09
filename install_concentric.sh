#!/bin/bash
# Script de instalación individual de Concentric Watchface para Samsung Galaxy Watch 3 (Tizen OS)

DEVICE_IP="${1:-192.168.100.77:26101}"
SDB="${2:-sdb}"

echo -e "\033[36m==========================================================\033[0m"
echo -e "\033[33m   Instalador Nativo Concentric (Google Pixel Watch)      \033[0m"
echo -e "\033[36m   Samsung Galaxy Watch 3 (SM-R840, Tizen OS 5.5)         \033[0m"
echo -e "\033[36m==========================================================\033[0m"

echo -e "\033[32m[1/5] Conectando a $DEVICE_IP...\033[0m"
$SDB connect "$DEVICE_IP"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/tizen-native-concentric"
TARGET_DIR="/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist/com.samsung.watchface-noblesse-u6"

echo -e "\033[32m[2/5] Creando directorio en el reloj ($TARGET_DIR)...\033[0m"
$SDB shell "mkdir -p $TARGET_DIR"

echo -e "\033[32m[3/5] Transfiriendo archivos de carátula Concentric (XML + ruedas de rotación + cápsula)...\033[0m"
$SDB push "$SOURCE_DIR"/* "$TARGET_DIR/"
$SDB shell "chmod -R 777 $TARGET_DIR"

echo -e "\033[32m[4/5] Activando Concentric Watchface en result.xml...\033[0m"
$SDB push "$SOURCE_DIR/com.samsung.watchface-noblesse-u6_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
$SDB shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

echo -e "\033[32m[5/5] Recargando el servicio de pantalla de inicio...\033[0m"
$SDB shell "pkgcmd -k -n com.samsung.watchface"
$SDB shell "app_launcher -s com.samsung.w-home"

echo ""
echo -e "\033[32m¡Concentric Watchface instalado y activado exitosamente en el Galaxy Watch 3!\033[0m"
echo -e "\033[33mDoble disco concéntrico con barrido fluido de 60 fps y 4 complicaciones activas.\033[0m"
