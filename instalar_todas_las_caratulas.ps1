# Script para desplegar las 5 carátulas legendarias en Samsung Galaxy Watch 3
param(
    [string]$DeviceIp = "192.168.100.77:26101",
    [string]$SdbPath = "sdb"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Desplegando Carrusel Quíntuple de Carátulas en Galaxy Watch" -ForegroundColor Yellow
Write-Host "  1. Casio Royale AE-1200 (noblesse-u3) -> 'Casio Royale'" -ForegroundColor White
Write-Host "  2. G-Shock GA-100       (noblesse-a8) -> 'G-Shock GA-100'" -ForegroundColor White
Write-Host "  3. MoveToBeActive Garmin(noblesse-a7) -> 'MoveToBeActive'" -ForegroundColor White
Write-Host "  4. Terminal Linux 34px  (noblesse-u1) -> 'Terminal Linux'" -ForegroundColor White
Write-Host "  5. Concentric Pixel Quad(noblesse-u6) -> 'Concentric Pixel'" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Conexión SDB con reintentos automáticos
Write-Host "[1/8] Conectando a $DeviceIp..." -ForegroundColor Green
$connected = $false
for ($i = 1; $i -le 5; $i++) {
    Write-Host "Intento $i de 5: Conectando a $DeviceIp (despierta la pantalla del reloj si está en reposo)..." -ForegroundColor Yellow
    $res = & $SdbPath connect $DeviceIp 2>&1 | Out-String
    Start-Sleep -Seconds 1
    $devs = & $SdbPath devices 2>&1 | Out-String
    if ($devs -match "$DeviceIp\s+device") {
        Write-Host "¡Conectado exitosamente al Galaxy Watch 3!" -ForegroundColor Green
        $connected = $true
        break
    }
    Start-Sleep -Seconds 1
}

if (-not $connected) {
    Write-Host "AVISO: No se pudo conectar de inmediato. Asegúrate de encender la pantalla del reloj o verificar su IP en Ajustes > Conexiones > Wi-Fi." -ForegroundColor Red
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$baseRemote = "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist"

# 2. Desplegar Casio Royale AE-1200
Write-Host "[2/8] Instalando Casio Royale AE-1200 (slot noblesse-u3)..." -ForegroundColor Green
$casioLocal = Join-Path $scriptDir "tizen-native-casio-royale"
$casioRemote = "$baseRemote/com.samsung.watchface-noblesse-u3"
& $SdbPath shell "mkdir -p $casioRemote"
& $SdbPath push "$casioLocal\*" "$casioRemote/"
& $SdbPath shell "chmod -R 777 $casioRemote"

# 3. Desplegar G-Shock GA-100 TacBlack
Write-Host "[3/8] Instalando G-Shock GA-100 TacBlack (slot noblesse-a8)..." -ForegroundColor Green
$gaLocal = Join-Path $scriptDir "tizen-native-ga100-tacblack"
$gaRemote = "$baseRemote/com.samsung.watchface-noblesse-a8"
& $SdbPath shell "mkdir -p $gaRemote"
& $SdbPath push "$gaLocal\*" "$gaRemote/"
& $SdbPath shell "chmod -R 777 $gaRemote"

# 4. Desplegar MoveToBeActive
Write-Host "[4/8] Instalando MoveToBeActive (slot noblesse-a7)..." -ForegroundColor Green
$mtbaLocal = Join-Path $scriptDir "tizen-native-movetobeactive"
$mtbaRemote = "$baseRemote/com.samsung.watchface-noblesse-a7"
& $SdbPath shell "mkdir -p $mtbaRemote"
& $SdbPath push "$mtbaLocal\*" "$mtbaRemote/"
& $SdbPath shell "chmod -R 777 $mtbaRemote"

# 5. Desplegar Terminal
Write-Host "[5/8] Instalando Terminal Watchface (slot noblesse-u1)..." -ForegroundColor Green
$termLocal = Join-Path $scriptDir "tizen-native-terminal"
$termRemote = "$baseRemote/com.samsung.watchface-noblesse-u1"
& $SdbPath shell "mkdir -p $termRemote"
& $SdbPath push "$termLocal\*" "$termRemote/"
& $SdbPath shell "chmod -R 777 $termRemote"

# 6. Desplegar Concentric
Write-Host "[6/8] Instalando Concentric Watchface (slot noblesse-u6)..." -ForegroundColor Green
$concLocal = Join-Path $scriptDir "tizen-native-concentric"
$concRemote = "$baseRemote/com.samsung.watchface-noblesse-u6"
& $SdbPath shell "mkdir -p $concRemote"
& $SdbPath push "$concLocal\*" "$concRemote/"
& $SdbPath shell "chmod -R 777 $concRemote"

# 7. Desplegar iconos de previsualización para el carrusel
Write-Host "[7/10] Instalando miniaturas personalizadas en /opt/usr/media/watchface_icons/..." -ForegroundColor Green
$iconsLocal = Join-Path $scriptDir "watchface_icons"
& $SdbPath shell "mkdir -p /opt/usr/media/watchface_icons"
& $SdbPath push "$iconsLocal\*" "/opt/usr/media/watchface_icons/"
& $SdbPath shell "chmod -R 777 /opt/usr/media/watchface_icons"

# 8. Actualizar base de datos del carrusel (.clock_list_order.db)
Write-Host "[8/10] Configurando nombres reales e iconos en el carrusel del reloj..." -ForegroundColor Green
$sqlContent = @"
UPDATE clock_order_info SET label='Casio Royale', iconpath='/opt/usr/media/watchface_icons/casio_royale.png', rorder=1, corder=1 WHERE pkgid='com.samsung.watchface-noblesse-u3';
UPDATE clock_order_info SET label='G-Shock GA-100', iconpath='/opt/usr/media/watchface_icons/gshock_ga100.png', rorder=2, corder=2 WHERE pkgid='com.samsung.watchface-noblesse-a8';
UPDATE clock_order_info SET label='MoveToBeActive', iconpath='/opt/usr/media/watchface_icons/movetobeactive.png', rorder=3, corder=3 WHERE pkgid='com.samsung.watchface-noblesse-a7';
UPDATE clock_order_info SET label='Terminal Linux', iconpath='/opt/usr/media/watchface_icons/terminal_linux.png', rorder=4, corder=4 WHERE pkgid='com.samsung.watchface-noblesse-u1';
UPDATE clock_order_info SET label='Concentric Pixel', iconpath='/opt/usr/media/watchface_icons/concentric_pixel.png', rorder=5, corder=5 WHERE pkgid='com.samsung.watchface-noblesse-u6';
"@
$tempSql = Join-Path $env:TEMP "update_carousel.sql"
Set-Content -Path $tempSql -Value $sqlContent -Encoding UTF8
& $SdbPath push $tempSql "/opt/usr/home/owner/media/update_carousel.sql"
& $SdbPath shell "cat /opt/usr/home/owner/media/update_carousel.sql | sqlite3 /opt/dbspace/.clock_list_order.db"

# 9. Activar Casio Royale por defecto
Write-Host "[9/10] Configurando Casio Royale como carátula inicial activa..." -ForegroundColor Green
& $SdbPath push "$casioLocal\com.samsung.watchface-noblesse-u3_result.xml" "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
& $SdbPath shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"

# 10. Reiniciar servicios de carátula
Write-Host "[10/10] Reiniciando servicios de reloj..." -ForegroundColor Green
& $SdbPath shell "pkgcmd -k -n com.samsung.watchface"
& $SdbPath shell "app_launcher -s com.samsung.w-home"

Write-Host ""
Write-Host "¡Las 5 carátulas están listas con sus nombres personalizados y miniaturas reales!" -ForegroundColor Green
Write-Host "Mantén pulsada la pantalla 2 segundos para rotar entre ellas con el bisel físico." -ForegroundColor Yellow
