# Script de instalación individual de Concentric Watchface para Samsung Galaxy Watch 3 (Tizen OS)
param(
    [string]$DeviceIp = "192.168.100.77:26101",
    [string]$SdbPath = "sdb"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Instalador Nativo Concentric Pixel (Pixel Watch Port)  " -ForegroundColor Yellow
Write-Host "   Samsung Galaxy Watch 3 (SM-R840, Tizen OS 5.5)         " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Conexión SDB
Write-Host "[1/6] Conectando a $DeviceIp..." -ForegroundColor Green
& $SdbPath connect $DeviceIp

# 2. Rutas
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$sourceDir = Join-Path $scriptDir "tizen-native-concentric"
$targetDir = "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist/com.samsung.watchface-noblesse-u6"

# 3. Crear directorio en el reloj
Write-Host "[2/6] Creando directorio en el reloj ($targetDir)..." -ForegroundColor Green
& $SdbPath shell "mkdir -p $targetDir"

# 4. Enviar archivos nativos y texturas concéntricas
Write-Host "[3/6] Transfiriendo archivos de carátula Concentric (XML + ruedas de rotación + cápsula)..." -ForegroundColor Green
& $SdbPath push "$sourceDir\*" "$targetDir/"
& $SdbPath shell "chmod -R 777 $targetDir"

# 5. Instalar miniatura del selector
Write-Host "[4/6] Instalando miniatura en /opt/usr/media/watchface_icons/..." -ForegroundColor Green
$iconPath = Join-Path $scriptDir "watchface_icons\concentric_pixel.png"
& $SdbPath shell "mkdir -p /opt/usr/media/watchface_icons"
& $SdbPath push $iconPath "/opt/usr/media/watchface_icons/concentric_pixel.png"
& $SdbPath shell "chmod 777 /opt/usr/media/watchface_icons/concentric_pixel.png"

# 6. Actualizar nombre en base de datos
Write-Host "[5/6] Configurando 'Concentric Pixel' en base de datos del reloj..." -ForegroundColor Green
$sql = "UPDATE clock_order_info SET label='Concentric Pixel', iconpath='/opt/usr/media/watchface_icons/concentric_pixel.png', rorder=5, corder=5 WHERE pkgid='com.samsung.watchface-noblesse-u6';"
$tempSql = Join-Path $env:TEMP "concentric_db.sql"
[System.IO.File]::WriteAllText($tempSql, $sql, [System.Text.Encoding]::ASCII)
& $SdbPath push $tempSql "/opt/usr/home/owner/media/concentric_db.sql"
& $SdbPath shell "cat /opt/usr/home/owner/media/concentric_db.sql | sqlite3 /opt/dbspace/.clock_list_order.db"

# 7. Configurar como carátula activa en result.xml
Write-Host "[6/6] Activando Concentric Watchface en el reloj..." -ForegroundColor Green
& $SdbPath push "$sourceDir\com.samsung.watchface-noblesse-u6_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
& $SdbPath shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

# 8. Reiniciar daemon de carátula
Write-Host "Recargando el servicio de pantalla de inicio..." -ForegroundColor Green
& $SdbPath shell "pkgcmd -k -n com.samsung.watchface"
& $SdbPath shell "app_launcher -s com.samsung.w-home"

Write-Host ""
Write-Host "¡Concentric Pixel instalada y activada exitosamente en el Galaxy Watch 3!" -ForegroundColor Green
Write-Host "Doble disco concéntrico con barrido fluido de 60 fps y 4 complicaciones activas." -ForegroundColor Yellow
