# Script para desplegar las 8 carátulas legendarias en Samsung Galaxy Watch 3
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
Write-Host " Desplegando Carrusel Óctuple de Carátulas en Galaxy Watch" -ForegroundColor Yellow
Write-Host "  1. Casio Royale AE-1200 (noblesse-u3) -> 'Casio Royale'" -ForegroundColor White
Write-Host "  2. G-Shock GA-100       (noblesse-a8) -> 'G-Shock GA-100'" -ForegroundColor White
Write-Host "  3. MoveToBeActive Garmin(noblesse-a7) -> 'MoveToBeActive'" -ForegroundColor White
Write-Host "  4. Terminal Linux 34px  (noblesse-u1) -> 'Terminal Linux'" -ForegroundColor White
Write-Host "  5. Concentric Pixel Quad(noblesse-u6) -> 'Concentric Pixel'" -ForegroundColor White
Write-Host "  6. Odyssey Digital      (noblesse-a4) -> 'Odyssey Digital'" -ForegroundColor White
Write-Host "  7. Casio Classic A158W  (noblesse-a5) -> 'Casio Classic'" -ForegroundColor White
Write-Host "  8. Hublot Big Bang Skel (noblesse-a1) -> 'Hublot Skeleton'" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan

function Ensure-SdbConnection {
    $devs = & $SdbPath devices 2>&1 | Out-String
    if ($devs -notmatch "$DeviceIp\s+device") {
        Write-Host "Reconectando con el reloj..." -ForegroundColor Yellow
        for ($k = 1; $k -le 5; $k++) {
            & $SdbPath connect $DeviceIp | Out-Null
            Start-Sleep -Milliseconds 700
            $devs = & $SdbPath devices 2>&1 | Out-String
            if ($devs -match "$DeviceIp\s+device") { break }
        }
    }
}

# 1. Conexión SDB inicial
Write-Host "[1/10] Conectando a $DeviceIp..." -ForegroundColor Green
Ensure-SdbConnection

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$baseRemote = "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist"

# 2. Desplegar Casio Royale AE-1200
Ensure-SdbConnection
Write-Host "[2/11] Instalando Casio Royale AE-1200 (slot noblesse-u3)..." -ForegroundColor Green
$casioLocal = Join-Path $scriptDir "tizen-native-casio-royale"
$casioRemote = "$baseRemote/com.samsung.watchface-noblesse-u3"
& $SdbPath shell "mkdir -p $casioRemote"
& $SdbPath push "$casioLocal\*" "$casioRemote/"
& $SdbPath shell "chmod -R 777 $casioRemote"

# 3. Desplegar G-Shock GA-100 TacBlack
Ensure-SdbConnection
Write-Host "[3/11] Instalando G-Shock GA-100 TacBlack (slot noblesse-a8)..." -ForegroundColor Green
$gaLocal = Join-Path $scriptDir "tizen-native-ga100-tacblack"
$gaRemote = "$baseRemote/com.samsung.watchface-noblesse-a8"
& $SdbPath shell "mkdir -p $gaRemote"
& $SdbPath push "$gaLocal\*" "$gaRemote/"
& $SdbPath shell "chmod -R 777 $gaRemote"

# 4. Desplegar MoveToBeActive
Ensure-SdbConnection
Write-Host "[4/11] Instalando MoveToBeActive (slot noblesse-a7)..." -ForegroundColor Green
$mtbaLocal = Join-Path $scriptDir "tizen-native-movetobeactive"
$mtbaRemote = "$baseRemote/com.samsung.watchface-noblesse-a7"
& $SdbPath shell "mkdir -p $mtbaRemote"
& $SdbPath push "$mtbaLocal\*" "$mtbaRemote/"
& $SdbPath shell "chmod -R 777 $mtbaRemote"

# 5. Desplegar Terminal
Ensure-SdbConnection
Write-Host "[5/11] Instalando Terminal Watchface (slot noblesse-u1)..." -ForegroundColor Green
$termLocal = Join-Path $scriptDir "tizen-native-terminal"
$termRemote = "$baseRemote/com.samsung.watchface-noblesse-u1"
& $SdbPath shell "mkdir -p $termRemote"
& $SdbPath push "$termLocal\*" "$termRemote/"
& $SdbPath shell "chmod -R 777 $termRemote"

# 6. Desplegar Concentric
Ensure-SdbConnection
Write-Host "[6/11] Instalando Concentric Watchface (slot noblesse-u6)..." -ForegroundColor Green
$concLocal = Join-Path $scriptDir "tizen-native-concentric"
$concRemote = "$baseRemote/com.samsung.watchface-noblesse-u6"
& $SdbPath shell "mkdir -p $concRemote"
& $SdbPath push "$concLocal\*" "$concRemote/"
& $SdbPath shell "chmod -R 777 $concRemote"

# 7. Desplegar Odyssey Digital
Ensure-SdbConnection
Write-Host "[7/11] Instalando Odyssey Digital (slot noblesse-a4)..." -ForegroundColor Green
$odyLocal = Join-Path $scriptDir "tizen-native-odyssey-digital"
$odyRemote = "$baseRemote/com.samsung.watchface-noblesse-a4"
& $SdbPath shell "mkdir -p $odyRemote"
& $SdbPath push "$odyLocal\*" "$odyRemote/"
& $SdbPath shell "chmod -R 777 $odyRemote"

# 8. Desplegar Casio Classic A158W
Ensure-SdbConnection
Write-Host "[8/11] Instalando Casio Classic A158W (slot noblesse-a5)..." -ForegroundColor Green
$classicLocal = Join-Path $scriptDir "tizen-native-casio-classic"
$classicRemote = "$baseRemote/com.samsung.watchface-noblesse-a5"
& $SdbPath shell "mkdir -p $classicRemote"
& $SdbPath push "$classicLocal\*" "$classicRemote/"
& $SdbPath shell "chmod -R 777 $classicRemote"

# 9. Desplegar Rolex Skeleton
Ensure-SdbConnection
Write-Host "[9/11] Instalando Rolex Skeleton (slot noblesse-a1)..." -ForegroundColor Green
$rolexLocal = Join-Path $scriptDir "tizen-native-rolex-skeleton"
$rolexRemote = "$baseRemote/com.samsung.watchface-noblesse-a1"
& $SdbPath shell "mkdir -p $rolexRemote"
& $SdbPath push "$rolexLocal\*" "$rolexRemote/"
& $SdbPath shell "chmod -R 777 $rolexRemote"

# 10. Desplegar iconos de previsualización para el carrusel
Ensure-SdbConnection
Write-Host "[10/13] Instalando miniaturas personalizadas en /opt/usr/media/watchface_icons/..." -ForegroundColor Green
$iconsLocal = Join-Path $scriptDir "watchface_icons"
& $SdbPath shell "mkdir -p /opt/usr/media/watchface_icons"
& $SdbPath push "$iconsLocal\*" "/opt/usr/media/watchface_icons/"
& $SdbPath shell "chmod -R 777 /opt/usr/media/watchface_icons"

# 11. Actualizar base de datos del carrusel (.clock_list_order.db)
Ensure-SdbConnection
Write-Host "[11/13] Configurando nombres reales e iconos en el carrusel del reloj..." -ForegroundColor Green
$sqlContent = @"
UPDATE clock_order_info SET label='Casio Royale', iconpath='/opt/usr/media/watchface_icons/casio_royale.png', rorder=1, corder=1 WHERE pkgid='com.samsung.watchface-noblesse-u3';
UPDATE clock_order_info SET label='G-Shock GA-100', iconpath='/opt/usr/media/watchface_icons/gshock_ga100.png', rorder=2, corder=2 WHERE pkgid='com.samsung.watchface-noblesse-a8';
UPDATE clock_order_info SET label='MoveToBeActive', iconpath='/opt/usr/media/watchface_icons/movetobeactive.png', rorder=3, corder=3 WHERE pkgid='com.samsung.watchface-noblesse-a7';
UPDATE clock_order_info SET label='Terminal Linux', iconpath='/opt/usr/media/watchface_icons/terminal_linux.png', rorder=4, corder=4 WHERE pkgid='com.samsung.watchface-noblesse-u1';
UPDATE clock_order_info SET label='Concentric Pixel', iconpath='/opt/usr/media/watchface_icons/concentric_pixel.png', rorder=5, corder=5 WHERE pkgid='com.samsung.watchface-noblesse-u6';
UPDATE clock_order_info SET label='Odyssey Digital', iconpath='/opt/usr/media/watchface_icons/odyssey_digital.png', rorder=6, corder=6 WHERE pkgid='com.samsung.watchface-noblesse-a4';
UPDATE clock_order_info SET label='Casio Classic', iconpath='/opt/usr/media/watchface_icons/casio_classic.png', rorder=7, corder=7 WHERE pkgid='com.samsung.watchface-noblesse-a5';
UPDATE clock_order_info SET label='Hublot Skeleton', iconpath='/opt/usr/media/watchface_icons/rolex_skeleton.png', rorder=8, corder=8 WHERE pkgid='com.samsung.watchface-noblesse-a1';
"@
$tempSql = Join-Path $env:TEMP "update_carousel.sql"
[System.IO.File]::WriteAllText($tempSql, $sqlContent, [System.Text.Encoding]::ASCII)
& $SdbPath push $tempSql "/opt/usr/home/owner/media/update_carousel.sql"
& $SdbPath shell "cat /opt/usr/home/owner/media/update_carousel.sql | sqlite3 /opt/dbspace/.clock_list_order.db"

# 12. Activar Rolex Skeleton por defecto
Ensure-SdbConnection
Write-Host "[12/13] Configurando Rolex Skeleton como carátula inicial activa..." -ForegroundColor Green
& $SdbPath push "$rolexLocal\com.samsung.watchface-noblesse-a1_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
& $SdbPath shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

# 13. Reiniciar servicios de carátula
Ensure-SdbConnection
Write-Host "[13/13] Reiniciando servicios de reloj..." -ForegroundColor Green
& $SdbPath shell "pkgcmd -k -n com.samsung.watchface"
& $SdbPath shell "app_launcher -s com.samsung.w-home"

Write-Host ""
Write-Host "¡Las 8 carátulas están listas con sus nombres personalizados y miniaturas reales!" -ForegroundColor Green
Write-Host "Mantén pulsada la pantalla 2 segundos para rotar entre las 8 carátulas con el bisel físico." -ForegroundColor Yellow
