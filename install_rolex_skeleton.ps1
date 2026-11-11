# Script de instalación automatizada de Rolex Skeleton para Samsung Galaxy Watch 3 (Tizen OS)
param(
    [string]$DeviceIp = "192.168.100.77:26101",
    [string]$SdbPath = "sdb"
)

# Auto-detectar sdb.exe si no está en PATH
if (-not (Get-Command $SdbPath -ErrorAction SilentlyContinue)) {
    $fallbackSdb = "C:\Users\user\.gemini\antigravity\brain\4e029f08-114e-4ce8-90a1-d16963cf9144\scratch\sdb\data\tools\sdb.exe"
    if (Test-Path $fallbackSdb) {
        $SdbPath = $fallbackSdb
    }
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Instalador Nativo Hublot Big Bang Skeleton Animated   " -ForegroundColor Yellow
Write-Host "   Samsung Galaxy Watch 3 (SM-R840, Tizen OS 5.5)         " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Conexión SDB
Write-Host "[1/6] Conectando a $DeviceIp..." -ForegroundColor Green
$connected = $false
for ($i = 1; $i -le 6; $i++) {
    Write-Host "Intento $i de 6..." -ForegroundColor Yellow
    & $SdbPath connect $DeviceIp
    Start-Sleep -Milliseconds 800
    $devs = & $SdbPath devices
    if ($devs -match "$DeviceIp\s+device") {
        $connected = $true
        Write-Host "¡Conectado exitosamente al reloj!" -ForegroundColor Green
        break
    }
}

if (-not $connected) {
    Write-Host "AVISO: No se pudo conectar de inmediato. Enciende la pantalla del reloj y reintenta." -ForegroundColor Red
    exit 1
}

# 2. Rutas
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$sourceDir = Join-Path $scriptDir "tizen-native-rolex-skeleton"
$targetDir = "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist/com.samsung.watchface-noblesse-a1"

# 3. Crear directorio en el reloj
Write-Host "[2/6] Creando directorio en el reloj ($targetDir)..." -ForegroundColor Green
& $SdbPath shell "mkdir -p $targetDir"

# 4. Enviar archivos nativos y texturas
Write-Host "[3/6] Transfiriendo archivos de carátula Rolex Skeleton (XML + engranajes móviles + manecillas)..." -ForegroundColor Green
& $SdbPath push "$sourceDir\*" "$targetDir/"
& $SdbPath shell "chmod -R 777 $targetDir"

# 5. Instalar miniatura del selector
Write-Host "[4/6] Instalando miniatura en /opt/usr/media/watchface_icons/..." -ForegroundColor Green
$iconPath = Join-Path $scriptDir "watchface_icons\rolex_skeleton.png"
& $SdbPath shell "mkdir -p /opt/usr/media/watchface_icons"
& $SdbPath push $iconPath "/opt/usr/media/watchface_icons/rolex_skeleton.png"
& $SdbPath shell "chmod 777 /opt/usr/media/watchface_icons/rolex_skeleton.png"

# 6. Actualizar nombre en base de datos
Write-Host "[5/6] Configurando 'Hublot Skeleton' en base de datos del reloj..." -ForegroundColor Green
$sql = "UPDATE clock_order_info SET label='Hublot Skeleton', iconpath='/opt/usr/media/watchface_icons/rolex_skeleton.png', rorder=8, corder=8 WHERE pkgid='com.samsung.watchface-noblesse-a1';`n"
$tempSql = Join-Path $env:TEMP "rolex_skeleton_db.sql"
[System.IO.File]::WriteAllText($tempSql, $sql, [System.Text.Encoding]::ASCII)
& $SdbPath push $tempSql "/opt/usr/home/owner/media/rolex_skeleton_db.sql"
& $SdbPath shell "cat /opt/usr/home/owner/media/rolex_skeleton_db.sql | sqlite3 /opt/dbspace/.clock_list_order.db"

# 7. Configurar como carátula activa en result.xml
Write-Host "[6/6] Activando Hublot Skeleton como carátula actual..." -ForegroundColor Green
& $SdbPath push "$sourceDir\com.samsung.watchface-noblesse-a1_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
& $SdbPath shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

# 8. Reiniciar servicios
Write-Host "Recargando el servicio de pantalla de inicio..." -ForegroundColor Green
& $SdbPath shell "pkgcmd -k -n com.samsung.watchface"
& $SdbPath shell "app_launcher -s com.samsung.w-home"

Write-Host ""
Write-Host "¡Hublot Big Bang Skeleton instalada y activada exitosamente en el Galaxy Watch 3!" -ForegroundColor Green
Write-Host "Maquinaria mecánica ultra densa con engranajes móviles reales a 60 fps y AOD con manecillas luminiscentes puras." -ForegroundColor Yellow
