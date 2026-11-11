# Script para desplegar las 4 carátulas (G-Shock GA-100, MoveToBeActive, Terminal y Concentric) en Galaxy Watch 3
param(
    [string]$DeviceIp = "192.168.100.77:26101",
    [string]$SdbPath = "sdb"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Desplegando Carrusel Cuádruple de Carátulas en Galaxy Watch" -ForegroundColor Yellow
Write-Host "  1. G-Shock GA-100 TacBlack (noblesse-a8)               " -ForegroundColor White
Write-Host "  2. MoveToBeActive Garmin   (noblesse-a7)               " -ForegroundColor White
Write-Host "  3. Terminal Linux CLI 28px (noblesse-u1)               " -ForegroundColor White
Write-Host "  4. Concentric Pixel Quad   (noblesse-u6)               " -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Conexión
Write-Host "[1/7] Conectando a $DeviceIp..." -ForegroundColor Green
& $SdbPath connect $DeviceIp

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$baseRemote = "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist"

# 2. Desplegar G-Shock GA-100 TacBlack
Write-Host "[2/7] Instalando G-Shock GA-100 TacBlack (slot noblesse-a8)..." -ForegroundColor Green
$gaLocal = Join-Path $scriptDir "tizen-native-ga100-tacblack"
$gaRemote = "$baseRemote/com.samsung.watchface-noblesse-a8"
& $SdbPath shell "mkdir -p $gaRemote"
& $SdbPath push "$gaLocal\*" "$gaRemote/"
& $SdbPath shell "chmod -R 777 $gaRemote"

# 3. Desplegar MoveToBeActive
Write-Host "[3/7] Instalando MoveToBeActive (slot noblesse-a7)..." -ForegroundColor Green
$mtbaLocal = Join-Path $scriptDir "tizen-native-movetobeactive"
$mtbaRemote = "$baseRemote/com.samsung.watchface-noblesse-a7"
& $SdbPath shell "mkdir -p $mtbaRemote"
& $SdbPath push "$mtbaLocal\*" "$mtbaRemote/"
& $SdbPath shell "chmod -R 777 $mtbaRemote"

# 4. Desplegar Terminal
Write-Host "[4/7] Instalando Terminal Watchface (slot noblesse-u1)..." -ForegroundColor Green
$termLocal = Join-Path $scriptDir "tizen-native-terminal"
$termRemote = "$baseRemote/com.samsung.watchface-noblesse-u1"
& $SdbPath shell "mkdir -p $termRemote"
& $SdbPath push "$termLocal\*" "$termRemote/"
& $SdbPath shell "chmod -R 777 $termRemote"

# 5. Desplegar Concentric
Write-Host "[5/7] Verificando Concentric Watchface (slot noblesse-u6)..." -ForegroundColor Green
$concLocal = Join-Path $scriptDir "tizen-native-concentric"
$concRemote = "$baseRemote/com.samsung.watchface-noblesse-u6"
& $SdbPath shell "mkdir -p $concRemote"
& $SdbPath push "$concLocal\*" "$concRemote/"
& $SdbPath shell "chmod -R 777 $concRemote"

# 6. Activar G-Shock GA-100 como carátula inicial activa
Write-Host "[6/7] Configurando G-Shock GA-100 TacBlack como carátula inicial activa..." -ForegroundColor Green
& $SdbPath push "$gaLocal\com.samsung.watchface-noblesse-a8_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
& $SdbPath shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

# 7. Reiniciar servicios
Write-Host "[7/7] Reiniciando servicios de reloj..." -ForegroundColor Green
& $SdbPath shell "pkgcmd -k -n com.samsung.watchface"
& $SdbPath shell "app_launcher -s com.samsung.w-home"

Write-Host ""
Write-Host "¡Las 4 carátulas están listas y disponibles en tu reloj!" -ForegroundColor Green
Write-Host "Mantén pulsada la pantalla durante 2 segundos para alternar libremente entre ellas con el bisel giratorio." -ForegroundColor Yellow
