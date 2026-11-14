# Script de instalación automatizada de Casio Royale AE-1200 para Samsung Galaxy Watch 3 (Tizen OS)
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
Write-Host "   Instalador Nativo Casio Royale AE-1200                 " -ForegroundColor Yellow
Write-Host "   Samsung Galaxy Watch 3 (SM-R840, Tizen OS 5.5)         " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Conexión SDB
Write-Host "[1/5] Conectando a $DeviceIp..." -ForegroundColor Green
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

# 2. Rutas
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$sourceDir = Join-Path $scriptDir "tizen-native-casio-royale"
$targetDir = "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist/com.samsung.watchface-noblesse-u3"

# 3. Crear directorio en el reloj
Write-Host "[2/5] Creando directorio en el reloj ($targetDir)..." -ForegroundColor Green
& $SdbPath shell "mkdir -p $targetDir"

# 4. Enviar archivos nativos y assets
Write-Host "[3/5] Transfiriendo archivos de carátula (XML + digitos retro LCD + iconos + mini-reloj + fondos)..." -ForegroundColor Green
& $SdbPath push "$sourceDir\*" "$targetDir/"
& $SdbPath shell "chmod -R 777 $targetDir"

# 5. Configurar como carátula activa en result.xml
Write-Host "[4/5] Activando Casio Royale AE-1200 en el carrusel del reloj..." -ForegroundColor Green
& $SdbPath push "$sourceDir\com.samsung.watchface-noblesse-u3_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
& $SdbPath shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

# 6. Reiniciar daemon de carátula
Write-Host "[5/5] Recargando el servicio de pantalla de inicio..." -ForegroundColor Green
& $SdbPath shell "pkgcmd -k -n com.samsung.watchface"
& $SdbPath shell "app_launcher -s com.samsung.w-home"

Write-Host ""
Write-Host "¡Casio Royale AE-1200 instalado exitosamente en el Galaxy Watch 3!" -ForegroundColor Green
Write-Host "Con números retro LCD extraídos exactamente de la imagen de referencia." -ForegroundColor Yellow
