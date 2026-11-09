# Port Nativo: Carátula MoveToBeActive (Estilo Garmin Vivomove) para Galaxy Watch 3

Se ha adaptado e instalado exitosamente la carátula de código abierto **MoveToBeActive** (original de Garmin Connect IQ / Monkey C por *fevieira27*) al motor nativo **Samsung Noblesse XML** del **Samsung Galaxy Watch 3** (`SM-R840`, Tizen OS `5.5.0.2`, pantalla AMOLED de 360×360 px).

---

## 1. Vista Previa del Renderizado en Pantalla (360×360 px)

![MoveToBeActive Galaxy Watch 3](file:///C:/Users/user/.gemini/antigravity/brain/4e029f08-114e-4ce8-90a1-d16963cf9144/mtba_composed_preview.png)

---

## 2. Elementos Visuales y Funcionales Adaptados

### Dial y Marcadores Perimetrales
- **Fondo:** Negro puro AMOLED (`#000000`) de consumo cero.
- **Minutería:** 60 marcas radiales anti-alias.
- **Acentos Horarios Vivomove:** Índices en color verde lima brillante (`#AAFF00`) en las horas 1, 2, 4, 5, 7, 8, 10 y 11.
- **Tipografía Geométrica:** Numerales cardinales `12`, `3`, `6` y `9` en gris platino claro (`#D7D7D7`).
- **Logo Superior:** Insignia oficial de `GARMIN` con el distintivo triángulo cian/azul (`#00C4FF`).

### Manecillas Analógicas Nativas
- **Horaria (Hour):** Bastón blanco con bisel oscuro de alto contraste y punta triangular biselada ($L = 96\text{ px}$, $W = 8.4\text{ px}$), sincronizada mediante rotación continua `<rotation source="hour0-11.minute"/>`.
- **Minutero (Minute):** Bastón en verde lima Vivomove (`#AAFF00`) con punta afilada ($L = 142\text{ px}$, $W = 7.2\text{ px}$), sincronizado mediante rotación suave `<rotation source="minute.second"/>`.
- **Segundero (Second):** Aguja fina blanca con contrapeso circular perimetral ($L = 158\text{ px}$), animada en tiempo real con latido mecánico de 1 segundo (`animation="tick"`).
- **Eje Central (Arbor/Pivot):** Tapa circular pulida con borde plateado y núcleo en acento verde lima.

### Complicaciones y Sensores en Tiempo Real
1. **Columna Izquierda:**
   - **Calorías:** Icono de llama extraído del paquete de recursos original + valor dinámico de Samsung Health (`pedometer.activeCalorie`). Toque interactivo abre Samsung Health.
   - **Distancia:** Icono de geolocalización / ruta + distancia calculada (`pedometer.distance`). Toque interactivo abre Samsung Health.
   - **Pasos:** Icono de huellas + conteo dinámico (`pedometer.step`) en color verde lima. Toque interactivo abre el podómetro.
2. **Columna Derecha:**
   - **Frecuencia Cardíaca:** Icono de corazón carmesí + pulso en tiempo real (`heartrate.recent` bpm). Toque interactivo abre el monitor de ritmo cardíaco.
   - **Batería:** Icono de batería horizontal + porcentaje dinámico (`battery.percent%`) en verde lima. Toque interactivo abre el gestor de batería.
   - **Notificaciones:** Icono de mensaje + contador dinámico de mensajes no leídos (`notification.count`). Toque interactivo abre las notificaciones.
3. **Zona Inferior:**
   - **Clima:** Icono de condición meteorológica (sol, nubes, lluvia) + temperatura actual dinámica (`weather.currentTemperature°`). Toque interactivo abre el reporte del clima.
   - **Ciudad:** Nombre de la localidad en gris tenue (`weather.cityName`).
   - **Fecha Completa:** Día de la semana y fecha (`EEE, MMM d`) en verde lima brillante (`#AAFF00`). Toque interactivo abre la agenda de eventos.

### Modo Siempre Encendido (AOD / Ambient Mode)
- Cumple rigurosamente con la norma de protección AMOLED y OPR reducido (< 15%).
- Fondo negro con las marcas de 12 horas y numerales 12-3-6-9.
- Manecillas simplificadas con rotación por minuto para máximo ahorro de batería.
- Indicador esencial de batería y fecha.

---

## 3. Selector de Carátulas (Carrusel Triple Activo)

El reloj ahora dispone de **tres carátulas nativas activas** en su carrusel de selección:

1. **MoveToBeActive (`com.samsung.watchface-noblesse-a7`):** Estilo analógico Garmin Vivomove con suite completa de métricas de salud y clima.
2. **Terminal (`com.samsung.watchface-noblesse-u1`):** Estilo consola hacker a 28 px con temperatura `[temp]`, hora `[time]`, fecha `[date]`, batería `[batt]` y ritmo cardíaco `[hr]`.
3. **Concentric (`com.samsung.watchface-noblesse-u6`):** Estilo Google Pixel Watch con doble disco concéntrico de minutos y segundos en barrido fluido a 60 fps.

> [!TIP]
> **Cómo cambiar entre carátulas en cualquier momento:**
> Mantén pulsada la pantalla del reloj durante 2 segundos. Se abrirá el selector interactivo mostrando la miniatura de cada una; simplemente gira el bisel físico o desliza el dedo hacia los lados para elegir la que desees en cada momento.

---

## 4. Repositorio GitHub Sincronizado

Todos los archivos fuente, imágenes de alta resolución optimizadas, definiciones XML y configuraciones han sido versionados en el repositorio del usuario:

- **Repositorio:** [ingperezmx/Reloj-Galaxy-Watch-3-Tizen](https://github.com/ingperezmx/Reloj-Galaxy-Watch-3-Tizen)
- **Directorio nuevo:** [`tizen-native-movetobeactive`](https://github.com/ingperezmx/Reloj-Galaxy-Watch-3-Tizen/tree/main/tizen-native-movetobeactive)
- **Commit:** `356cb89` (*feat(watchface): Port MoveToBeActive (Garmin Vivomove style) native watchface for Galaxy Watch 3*)
