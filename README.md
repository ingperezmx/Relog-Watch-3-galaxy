# Relog Watch 3 Galaxy — Colección de Carátulas Nativas (Tizen 5.5 / SM-R840)

![Galaxy Watch 3 Showcase](assets/showcase_triple_watchfaces.png)

Colección completa de carátulas nativas optimizadas para la pantalla circular AMOLED de **360×360 px** del **Samsung Galaxy Watch 3 (`SM-R840`, Tizen OS 5.5.0.2)**, con scripts de instalación automática vía Wi-Fi (SDB).

---

## 📸 Muestra Visual de las Carátulas

| **MoveToBeActive (Garmin Vivomove)** | **Terminal Watchface (28px CLI)** | **Concentric (Google Pixel)** |
|:---:|:---:|:---:|
| ![MoveToBeActive](assets/movetobeactive_preview.png) | ![Terminal](assets/terminal_preview.png) | ![Concentric](assets/concentric_preview.png) |
| *Analógico híbrido con suite de salud y clima* | *Consola minimalista hacker a 28 px* | *Doble disco concéntrico fluido a 60 fps* |

---

## 🌟 Características Detalladas

### 1. MoveToBeActive (Estilo Garmin Vivomove)
- **Directorio:** [`tizen-native-movetobeactive/`](tizen-native-movetobeactive/)
- **Slot Nativo:** `com.samsung.watchface-noblesse-a7`
- **Dial:** Fondo negro puro AMOLED (`#000000`), 60 marcas de minutos con índices horarios en verde lima Vivomove (`#AAFF00`) en horas 1, 2, 4, 5, 7, 8, 10 y 11; numerales `12`, `3`, `6` y `9`.
- **Manecillas:** Horaria blanca biselada, minutero verde lima y segundero mecánico con animación de latido (`animation="tick"`).
- **Branding:** Logotipo oficial de `GARMIN` con triángulo cian/azul (`#00C4FF`).
- **Métricas en Vivo:**
  - **Izquierda:** Calorías (`pedometer.activeCalorie`), Distancia (`pedometer.distance`), Pasos (`pedometer.step`).
  - **Derecha:** Ritmo Cardíaco (`heartrate.recent` bpm), Batería (`battery.percent%`), Notificaciones (`notification.count`).
  - **Inferior:** Clima (icono dinámico + `weather.currentTemperature°`), Ciudad (`weather.cityName`), Fecha completa interactiva (`EEE, MMM d`).
- **Modo Always-On Display (AOD):** Consumo ultra bajo (< 15% OPR) con manecillas atenuadas e indicadores esenciales.

---

### 2. Terminal Watchface
- **Directorio:** [`tizen-native-terminal/`](tizen-native-terminal/)
- **Slot Nativo:** `com.samsung.watchface-noblesse-u1`
- **Diseño:** Fuente monoespaciada a **28 px** (`A1T0232`), con etiquetas alineadas a 6 caracteres:
  - `[date]` — Fecha interactiva (abre Calendario).
  - `[time]` — Hora digital en formato 12h/24h con segundos parpadeantes (abre Alarma).
  - `[batt]` — Nivel y estado de batería (abre Estado de Batería).
  - `[temp]` — Temperatura meteorológica actual (abre Clima).
  - `[hr]  ` — Frecuencia cardíaca en tiempo real (abre Ritmo Cardíaco).

---

### 3. Concentric (Google Pixel Watch)
- **Directorio:** [`tizen-native-concentric/`](tizen-native-concentric/)
- **Slot Nativo:** `com.samsung.watchface-noblesse-u6`
- **Diseño:**
  - Anillo exterior de segundos con barrido fluido continuo a 60 fps (`second.millisecond`).
  - Anillo interior de minutos con rotación suave.
  - Cápsula central con hora digital en gran tamaño (92 px).
  - 4 complicaciones en los cuadrantes: batería, pasos, calorías activas y clima.

---

## 🚀 Instalación en el Reloj vía SDB (Wi-Fi)

Asegúrate de que la depuración SDB esté activada en el reloj y conectado a la misma red Wi-Fi:

### Opción 1: Desplegar el Carrusel Triple Completo (Recomendado)
Instala las tres carátulas de una sola vez y permite alternar entre ellas con el bisel giratorio:
- **En Windows (PowerShell):**
  ```powershell
  .\instalar_todas_las_caratulas.ps1 -DeviceIp "192.168.100.77:26101"
  ```
- **En Linux / macOS / Git Bash:**
  ```bash
  chmod +x instalar_todas_las_caratulas.sh
  ./instalar_todas_las_caratulas.sh 192.168.100.77:26101
  ```

### Opción 2: Instalar solo MoveToBeActive
- **En Windows (PowerShell):**
  ```powershell
  .\install_movetobeactive.ps1 -DeviceIp "192.168.100.77:26101"
  ```
- **En Linux / macOS / Git Bash:**
  ```bash
  chmod +x install_movetobeactive.sh
  ./install_movetobeactive.sh 192.168.100.77:26101
  ```

---

## 🔄 Cómo cambiar entre carátulas en el reloj
Mantén presionada la pantalla del reloj durante **2 segundos**. Se abrirá el carrusel selector con las miniaturas de cada carátula. Gira el **bisel físico** o desliza el dedo hacia los lados para elegir la que desees en cada momento.
