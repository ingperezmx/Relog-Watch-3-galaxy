# Script de instalación integral de TODAS las 9 carátulas nativas para Samsung Galaxy Watch 3 (Tizen OS 5.5)
param(
    [string]$DeviceIp = "192.168.100.77:26101",
    [string]$SdbPath = "sdb",
    [string]$ActiveSlot = "com.samsung.watchface-noblesse-a5" # Casio Classic por defecto
)

# Auto-detectar sdb.exe si no está en PATH
if (-not (Get-Command $SdbPath -ErrorAction SilentlyContinue)) {
    $fallbackSdb = "C:\Users\user\.gemini\antigravity\brain\4e029f08-114e-4ce8-90a1-d16963cf9144\scratch\sdb\data\tools\sdb.exe"
    if (Test-Path $fallbackSdb) {
        $SdbPath = $fallbackSdb
    }
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Instalador Completo de 9 Carátulas Nativas Galaxy Watch 3   " -ForegroundColor Yellow
Write-Host "   Samsung Galaxy Watch 3 (SM-R840, Tizen OS 5.5)         " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Conexión SDB
Write-Host "[1/6] Conectando a $DeviceIp..." -ForegroundColor Green
$connected = $false
for ($i = 1; $i -le 8; $i++) {
    Write-Host "Intento $i de 8..." -ForegroundColor Yellow
    & $SdbPath connect $DeviceIp
    Start-Sleep -Milliseconds 900
    $devs = & $SdbPath devices
    if ($devs -match "$DeviceIp\s+device") {
        $connected = $true
        Write-Host "¡Conectado exitosamente al reloj!" -ForegroundColor Green
        break
    }
}

if (-not $connected) {
    Write-Host "ERROR: No se pudo conectar al reloj en $DeviceIp. Enciende la pantalla y reintenta." -ForegroundColor Red
    exit 1
}

$repoDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# 2. Instalar todas las miniaturas en /opt/usr/media/watchface_icons/
Write-Host "[2/6] Transfiriendo miniaturas de alta resolución a /opt/usr/media/watchface_icons/..." -ForegroundColor Green
& $SdbPath shell "mkdir -p /opt/usr/media/watchface_icons"
$iconsDir = Join-Path $repoDir "watchface_icons"
& $SdbPath push "$iconsDir\*" "/opt/usr/media/watchface_icons/"
& $SdbPath shell "chmod -R 777 /opt/usr/media/watchface_icons"

# 3. Lista de las 9 carátulas a desplegar
$watchfaces = @(
    @{ name = "Hublot Big Bang Skeleton"; dir = "tizen-native-rolex-skeleton"; pkg = "com.samsung.watchface-noblesse-a1"; order = 1; icon = "rolex_skeleton.png" },
    @{ name = "ICU Pulse Animated ECG"; dir = "tizen-native-icu-pulse"; pkg = "com.samsung.watchface-noblesse-a2"; order = 2; icon = "icu_pulse.png" },
    @{ name = "Casio Classic Vintage 205 Gold"; dir = "tizen-native-casio-classic"; pkg = "com.samsung.watchface-noblesse-a5"; order = 3; icon = "casio_classic.png" },
    @{ name = "Casio Royale WorldTime"; dir = "tizen-native-casio-royale"; pkg = "com.samsung.watchface-noblesse-u3"; order = 4; icon = "casio_royale.png" },
    @{ name = "Pac-Man Arcade Animated"; dir = "tizen-native-pacman-arcade"; pkg = "com.samsung.watchface-noblesse-a8"; order = 5; icon = "pacman_arcade.png" },
    @{ name = "Odyssey Digital OLED"; dir = "tizen-native-odyssey-digital"; pkg = "com.samsung.watchface-noblesse-a4"; order = 6; icon = "odyssey_digital.png" },
    @{ name = "Concentric Pixel Watch"; dir = "tizen-native-concentric"; pkg = "com.samsung.watchface-noblesse-u6"; order = 7; icon = "concentric_pixel.png" },
    @{ name = "MoveToBeActive Fitness"; dir = "tizen-native-movetobeactive"; pkg = "com.samsung.watchface-noblesse-a7"; order = 8; icon = "movetobeactive.png" },
    @{ name = "Linux Terminal Hacker"; dir = "tizen-native-terminal"; pkg = "com.samsung.watchface-noblesse-u1"; order = 9; icon = "terminal_linux.png" }
)

# 4. Transferir cada carátula
Write-Host "[3/6] Transfiriendo las 9 carátulas nativas con texturas completas..." -ForegroundColor Green
$baseWatchlist = "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/watchlist"

foreach ($wf in $watchfaces) {
    Write-Host " -> Instalando $($wf.name) en $($wf.pkg)..." -ForegroundColor Cyan
    $sourceDir = Join-Path $repoDir $wf.dir
    $targetDir = "$baseWatchlist/$($wf.pkg)"
    
    & $SdbPath shell "mkdir -p $targetDir"
    & $SdbPath push "$sourceDir\*" "$targetDir/"
    & $SdbPath shell "chmod -R 777 $targetDir"
}

# 5. Configurar orden, nombres e iconos en la base de datos SQLite del reloj
Write-Host "[4/6] Actualizando catálogo y orden de las 9 carátulas en la base de datos del reloj..." -ForegroundColor Green
$sql = ""
foreach ($wf in $watchfaces) {
    $icon = "/opt/usr/media/watchface_icons/$($wf.icon)"
    $sql += "UPDATE clock_order_info SET label='$($wf.name)', iconpath='$icon', rorder=$($wf.order), corder=$($wf.order) WHERE pkgid='$($wf.pkg)';`n"
}

$tempSql = Join-Path $env:TEMP "install_all_db.sql"
[System.IO.File]::WriteAllText($tempSql, $sql, [System.Text.Encoding]::ASCII)
& $SdbPath push $tempSql "/opt/usr/home/owner/media/install_all_db.sql"
& $SdbPath shell "cat /opt/usr/home/owner/media/install_all_db.sql | sqlite3 /opt/dbspace/.clock_list_order.db"

# 6. Activar la carátula seleccionada
Write-Host "[5/6] Configurando carátula activa ($ActiveSlot)..." -ForegroundColor Green
$activeWf = $watchfaces | Where-Object { $_.pkg -eq $ActiveSlot }
if ($activeWf) {
    $resultXml = Join-Path (Join-Path $repoDir $activeWf.dir) "$($activeWf.pkg)_result.xml"
    if (Test-Path $resultXml) {
        & $SdbPath push $resultXml "/opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
        & $SdbPath shell "chmod 777 /opt/usr/home/owner/apps_rw/.shared/com.samsung.watchface/data/result.xml"
        Write-Host "Carátula activa fijada a: $($activeWf.name)" -ForegroundColor Yellow
    }
}

# 7. Reiniciar servicios de reloj
Write-Host "[6/6] Reiniciando servicios gráficos de Tizen para aplicar cambios..." -ForegroundColor Green
& $SdbPath shell "pkgcmd -k -n com.samsung.watchface"
& $SdbPath shell "app_launcher -s com.samsung.w-home"

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host " ¡ÉXITO! Las 9 carátulas nativas están instaladas en el reloj:" -ForegroundColor Green
foreach ($wf in $watchfaces) {
    Write-Host "  [$($wf.order)] $($wf.name) -> Slot: $($wf.pkg)" -ForegroundColor White
}
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "Puedes cambiar entre ellas simplemente manteniendo presionada la pantalla del reloj o girando el bisel." -ForegroundColor Yellow
