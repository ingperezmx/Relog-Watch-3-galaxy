#!/usr/bin/env bash
# Script de instalación automatizada de Rolex Skeleton para Samsung Galaxy Watch 3 (Tizen OS)

DEVICE_IP="${1:-192.168.100.77:26101}"
SDB_PATH="sdb"

if ! command -v sdb &>/dev/null; then
    FALLBACK_SDB="C:/Users/user/.gemini/antigravity/brain/4e029f08-114e-4ce8-90a1-d16963cf9144/scratch/sdb/data/tools/sdb.exe"
    if [ -f "$FALLBACK_SDB" ]; then
        SDB_PATH="$FALLBACK_SDB"
    fi
fi

echo "=========================================================="
echo "   Instalador Nativo Rolex Skeleton Mechanical Tourbillon "
echo "   Samsung Galaxy Watch 3 (SM-R840, Tizen OS 5.5)         "
echo "=========================================================="

echo "[1/6] Conectando a $DEVICE_IP..."
for i in {1..6}; do
    "$SDB_PATH" connect "$DEVICE_IP"
    sleep 0.8
    if "$SDB_PATH" devices | grep -q "$DEVICE_IP.*device"; then
        echo "¡Conectado exitosamente al reloj!"
        break
    fi
done

if ! "$SDB_PATH" devices | grep -q "$DEVICE_IP.*device"; then
    echo "AVISO: No se pudo conectar de inmediato. Enciende la pantalla del reloj y reintenta."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/tizen-native-rolex-skeleton"
TARGET_DIR="/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist/com.samsung.watchface-noblesse-a1"

echo "[2/6] Creando directorio en el reloj ($TARGET_DIR)..."
"$SDB_PATH" shell "mkdir -p $TARGET_DIR"

echo "[3/6] Transfiriendo archivos de carátula Rolex Skeleton..."
"$SDB_PATH" push "$SOURCE_DIR/"* "$TARGET_DIR/"
"$SDB_PATH" shell "chmod -R 777 $TARGET_DIR"

echo "[4/6] Instalando miniatura en /opt/usr/media/watchface_icons/..."
"$SDB_PATH" shell "mkdir -p /opt/usr/media/watchface_icons"
"$SDB_PATH" push "$SCRIPT_DIR/watchface_icons/rolex_skeleton.png" "/opt/usr/media/watchface_icons/rolex_skeleton.png"
"$SDB_PATH" shell "chmod 777 /opt/usr/media/watchface_icons/rolex_skeleton.png"

echo "[5/6] Configurando 'Rolex Skeleton' en base de datos del reloj..."
SQL="UPDATE clock_order_info SET label='Rolex Skeleton', iconpath='/opt/usr/media/watchface_icons/rolex_skeleton.png', rorder=8, corder=8 WHERE pkgid='com.samsung.watchface-noblesse-a1';"
"$SDB_PATH" shell "echo \"$SQL\" | sqlite3 /opt/dbspace/.clock_list_order.db"

echo "[6/6] Activando Rolex Skeleton como carátula actual..."
"$SDB_PATH" push "$SOURCE_DIR/com.samsung.watchface-noblesse-a1_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
"$SDB_PATH" shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

echo "Recargando el servicio de pantalla de inicio..."
"$SDB_PATH" shell "pkgcmd -k -n com.samsung.watchface"
"$SDB_PATH" shell "app_launcher -s com.samsung.w-home"

echo ""
echo "¡Rolex Skeleton instalada y activada exitosamente en el Galaxy Watch 3!"
