#!/bin/bash
# Script de instalación automatizada de Casio Classic para Samsung Galaxy Watch 3 (Tizen OS)

DEVICE_IP="${1:-192.168.100.77:26101}"
SDB="${2:-sdb}"

echo -e "\033[36m==========================================================\033[0m"
echo -e "\033[33m   Instalador Nativo Casio Classic (A158W / F-91W Port)   \033[0m"
echo -e "\033[36m   Samsung Galaxy Watch 3 (SM-R840, Tizen OS 5.5)         \033[0m"
echo -e "\033[36m==========================================================\033[0m"

echo -e "\033[32m[1/6] Conectando a $DEVICE_IP...\033[0m"
$SDB connect "$DEVICE_IP"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/tizen-native-casio-classic"
TARGET_DIR="/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist/com.samsung.watchface-noblesse-a5"

echo -e "\033[32m[2/6] Creando directorio en el reloj ($TARGET_DIR)...\033[0m"
$SDB shell "mkdir -p $TARGET_DIR"

echo -e "\033[32m[3/6] Transfiriendo archivos de carátula (XML + fondo LCD + AOD)...\033[0m"
$SDB push "$SOURCE_DIR"/* "$TARGET_DIR/"
$SDB shell "chmod -R 777 $TARGET_DIR"

echo -e "\033[32m[4/6] Instalando miniatura en /opt/usr/media/watchface_icons/...\033[0m"
$SDB shell "mkdir -p /opt/usr/media/watchface_icons"
$SDB push "$SCRIPT_DIR/watchface_icons/casio_classic.png" "/opt/usr/media/watchface_icons/casio_classic.png"
$SDB shell "chmod 777 /opt/usr/media/watchface_icons/casio_classic.png"

echo -e "\033[32m[5/6] Configurando 'Casio Classic' en base de datos del reloj...\033[0m"
$SDB shell "sqlite3 /opt/dbspace/.clock_list_order.db \"UPDATE clock_order_info SET label='Casio Classic', iconpath='/opt/usr/media/watchface_icons/casio_classic.png', rorder=7, corder=7 WHERE pkgid='com.samsung.watchface-noblesse-a5';\""

echo -e "\033[32m[6/6] Activando Casio Classic en result.xml...\033[0m"
$SDB push "$SOURCE_DIR/com.samsung.watchface-noblesse-a5_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
$SDB shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

echo -e "\033[32mRecargando el servicio de pantalla de inicio...\033[0m"
$SDB shell "pkgcmd -k -n com.samsung.watchface"
$SDB shell "app_launcher -s com.samsung.w-home"

echo ""
echo -e "\033[32m¡Casio Classic (A158W) instalada y activada exitosamente en el Galaxy Watch 3!\033[0m"
echo -e "\033[33mEstilo vintage digital legendario con pantalla LCD verde, cronómetro y batería activa.\033[0m"
