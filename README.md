# Relog Watch 3 Galaxy — Colección de Carátulas Nativas (Tizen 5.5 / SM-R840)

Este repositorio contiene la colección de carátulas nativas optimizadas para el **Samsung Galaxy Watch 3 (`SM-R840`, Tizen OS 5.5.0.2)**, incluyendo scripts de instalación automatizada vía SDB (Wi-Fi).

---

## 🌟 Carátulas Disponibles

### 1. MoveToBeActive (Estilo Garmin Vivomove)
- **Directorio:** [`tizen-native-movetobeactive/`](tizen-native-movetobeactive/)
- **Slot Nativo:** `com.samsung.watchface-noblesse-a7`
- **Características:**
  - Manecilla horaria blanca con punta biselada y minutero en acento verde lima (`#AAFF00`).
  - Segundero mecánico con animación de latido (`animation="tick"`).
  - Dial con 60 marcas e índices horarios verdes en 1, 2, 4, 5, 7, 8, 10 y 11; numerales cardinales `12`, `3`, `6` y `9`.
  - Logotipo oficial de `GARMIN` con triángulo cian/azul (`#00C4FF`).
  - Suite de complicaciones: Pasos, Calorías, Distancia, Ritmo Cardíaco, Batería, Notificaciones, Clima (icono + temperatura), Ciudad y Fecha completa.
  - Modo Always-On Display (AOD) optimizado para bajo consumo AMOLED.

### 2. Terminal Watchface
- **Directorio:** [`tizen-native-terminal/`](tizen-native-terminal/)
- **Slot Nativo:** `com.samsung.watchface-noblesse-u1`
- **Características:**
  - Estilo consola minimalista a **28 px**.
  - 5 líneas de telemetría: Fecha (`[date]`), Hora (`[time]`), Batería (`[batt]`), Clima (`[temp]`) y Ritmo Cardíaco (`[hr]`).
  - Toque interactivo en cada línea para abrir su aplicación correspondiente en el reloj.

### 3. Concentric (Google Pixel Watch)
- **Directorio:** [`tizen-native-concentric/`](tizen-native-concentric/)
- **Slot Nativo:** `com.samsung.watchface-noblesse-u6`
- **Características:**
  - Discos concéntricos de minutos y segundos en barrido fluido a 60 fps.
  - Complicaciones circulares integradas (batería, pasos, calorías y clima).
  - Proyecto web original en [`tizen-concentric/`](tizen-concentric/) y paquete empaquetado [`Concentric.wgt`](Concentric.wgt).

---

## 🚀 Instalación Automatizada en el Reloj

### Opción A: Instalar solo MoveToBeActive
- **En Windows (PowerShell):**
  ```powershell
  .\install_movetobeactive.ps1 -DeviceIp "192.168.100.77:26101"
  ```
- **En Linux / macOS / Git Bash:**
  ```bash
  chmod +x install_movetobeactive.sh
  ./install_movetobeactive.sh 192.168.100.77:26101
  ```

### Opción B: Desplegar el Carrusel Triple Completo (MoveToBeActive + Terminal + Concentric)
- **En Windows (PowerShell):**
  ```powershell
  .\instalar_todas_las_caratulas.ps1 -DeviceIp "192.168.100.77:26101"
  ```
- **En Linux / macOS / Git Bash:**
  ```bash
  chmod +x instalar_todas_las_caratulas.sh
  ./instalar_todas_las_caratulas.sh 192.168.100.77:26101
  ```

---

## 🔄 Cómo cambiar entre carátulas en el reloj
Mantén presionada la pantalla del reloj durante 2 segundos para abrir el carrusel selector y gira el bisel físico para elegir entre **MoveToBeActive**, **Terminal** o **Concentric**.
