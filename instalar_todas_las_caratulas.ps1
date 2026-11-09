# Script para desplegar las 3 carátulas (MoveToBeActive, Terminal y Concentric) en Galaxy Watch 3
param(
    [string]$DeviceIp = "192.168.100.77:26101",
    [string]$SdbPath = "sdb"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Desplegando Carrusel Triple de Carátulas en Galaxy Watch " -ForegroundColor Yellow
Write-Host "  1. MoveToBeActive (noblesse-a7)                        " -ForegroundColor White
Write-Host "  2. Terminal 28px  (noblesse-u1)                        " -ForegroundColor White
Write-Host "  3. Concentric     (noblesse-u6)                        " -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Conexión
Write-Host "[1/6] Conectando a $DeviceIp..." -ForegroundColor Green
& $SdbPath connect $DeviceIp

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$baseRemote = "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist"

# 2. Desplegar MoveToBeActive
Write-Host "[2/6] Instalando MoveToBeActive (slot noblesse-a7)..." -ForegroundColor Green
$mtbaLocal = Join-Path $scriptDir "tizen-native-movetobeactive"
$mtbaRemote = "$baseRemote/com.samsung.watchface-noblesse-a7"
& $SdbPath shell "mkdir -p $mtbaRemote"
& $SdbPath push "$mtbaLocal\*" "$mtbaRemote/"
& $SdbPath shell "chmod -R 777 $mtbaRemote"

# 3. Desplegar Terminal
Write-Host "[3/6] Instalando Terminal Watchface (slot noblesse-u1)..." -ForegroundColor Green
$termLocal = Join-Path $scriptDir "tizen-native-terminal"
$termRemote = "$baseRemote/com.samsung.watchface-noblesse-u1"
& $SdbPath shell "mkdir -p $termRemote"
& $SdbPath push "$termLocal\*" "$termRemote/"
& $SdbPath shell "chmod -R 777 $termRemote"

# 4. Desplegar Concentric
Write-Host "[4/6] Verificando Concentric Watchface (slot noblesse-u6)..." -ForegroundColor Green
$concLocal = Join-Path $scriptDir "tizen-native-concentric"
$concRemote = "$baseRemote/com.samsung.watchface-noblesse-u6"
& $SdbPath shell "mkdir -p $concRemote"
& $SdbPath push "$concLocal\*" "$concRemote/"
& $SdbPath shell "chmod -R 777 $concRemote"

# 5. Activar MoveToBeActive por defecto
Write-Host "[5/6] Configurando MoveToBeActive como carátula inicial activa..." -ForegroundColor Green
& $SdbPath push "$mtbaLocal\com.samsung.watchface-noblesse-a7_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
& $SdbPath shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

# 6. Reiniciar servicios
Write-Host "[6/6] Reiniciando servicios de reloj..." -ForegroundColor Green
& $SdbPath shell "pkgcmd -k -n com.samsung.watchface"
& $SdbPath shell "app_launcher -s com.samsung.w-home"

Write-Host ""
Write-Host "¡Las 3 carátulas están listas y disponibles en tu reloj!" -ForegroundColor Green
Write-Host "Mantén pulsada la pantalla durante 2 segundos para alternar libremente entre ellas con el bisel giratorio." -ForegroundColor Yellow
