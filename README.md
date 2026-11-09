# Relog Watch 3 Galaxy — Concentric Watch Face (Wear OS & Tizen 5.5 Port)

<img src='https://play-lh.googleusercontent.com/Qp-fN1rU6bimstpohGY03DlDPMRdYapLK0CXH-utB6HJQhtCLxBERs47vjFP4rvVU-w=w832-h470' style="width:600px;" />

Este repositorio contiene:
1. El proyecto original **Concentric Watch Face** (diseño del Google Pixel Watch en *Watch Face Format* en [`res/raw/watchface.xml`](res/raw/watchface.xml)).
2. **Port nativo para Tizen OS 5.5 (`SM-R840` Samsung Galaxy Watch 3)** en la carpeta [`tizen-concentric/`](tizen-concentric/) y empaquetado como [`Concentric.wgt`](Concentric.wgt).

## Características del Port para Tizen (`tizen-concentric/`)
- **Rotación concéntrica en tiempo real:** Usa las texturas originales (`index_minutes_0.png`, `index_seconds_0.png`, `minute_border.png`, `minute_border_pill.png`) y las tipografías `Inter Medium` / `Roboto`.
- **Soporte para el bisel físico giratorio (`rotarydetent`):** Al girar el bisel del Galaxy Watch 3 cambias entre los 15 colores oficiales de Pixel Concentric (*Cloud, Snow, Watermelon, Tangerine Red, Gold, Sunshine, Mint, Peppermint, Lime, Turquoise, Ocean, Azure, Aquamarine, Lavender, Rose*).
- **Toque en pantalla:** Tocar el lado izquierdo alterna entre formato **12h / 24h**; tocar el lado derecho cambia el color de acento.
- **Modo Always-On Display (`ambientmodechanged`):** Cambia automáticamente al borde tipo cápsula (`minute_border_pill.png`) y oculta el segundero para ahorrar batería.

## Datos del Reloj (`SM-R840`)
- **Modelo:** `SM-R840` (Galaxy Watch 3 - F79D, Tizen `5.5.0.2`)
- **DUID del dispositivo:** `1.0#XLCEfI4yHeUrkqGn3qVNGXVytss=`

## Cómo firmar e instalar `Concentric.wgt` en el Galaxy Watch 3
Los relojes comerciales de Samsung requieren que el paquete `.wgt` esté firmado con un certificado de **Samsung Certificate Extension** (`samsung_tizen_dev_public.pem`) vinculado al DUID `1.0#XLCEfI4yHeUrkqGn3qVNGXVytss=`:

1. Genera un perfil de certificado Samsung (`author.p12` + `distributor.p12` con el DUID `1.0#XLCEfI4yHeUrkqGn3qVNGXVytss=`) desde **Tizen Certificate Manager** o **Galaxy Watch Studio**.
2. Empaqueta y firma con Tizen CLI:
   ```bash
   tizen package -t wgt -s <TuPerfilSamsung> -- ./tizen-concentric
   ```
3. Instala por Wi-Fi con SDB:
   ```bash
   sdb connect 192.168.100.77:26101
   sdb install ./tizen-concentric/Concentric.wgt
   ```
