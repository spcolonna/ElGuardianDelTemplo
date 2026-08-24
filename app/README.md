# El Guardián del Templo — prototipo web

Simulador jugable del juego de mesa solitario, en Flutter web. Sirve para probar
jugabilidad, ciclo de juego y balance antes de imprimir las cartas.

## Correr

```bash
cd app && flutter run -d chrome
```

En móvil (hay proyectos `android/` e `ios/`, orientación bloqueada en vertical):

```bash
cd app && flutter run
```

Simulación headless del balance:

```bash
cd app && dart run bin/sim.dart
```

Impacto del modo Cansancio sobre el balance:

```bash
cd app && dart run bin/sim_cansancio.dart
```

Chequeos del motor (auto-revelado, fases, Energía 0, racha diaria, modos):

```bash
cd app && dart run bin/check.dart
```

Exportar los CSV de producción de un tema:

```bash
cd app && dart run bin/export_csv.dart --tema=templo
```

## Idiomas

Español e inglés, con **dos capas separadas**:

- `lib/l10n.dart` — textos de la interfaz. **Balance** y **Simulador** quedan sólo
  en español a propósito: son herramientas internas de playtesting.
- `lib/temas/templo/textos_es.dart` y `textos_en.dart` — el contenido del juego:
  los 70 nombres y sabores de carta, las 23 viñetas y los 12 encargos. El inglés
  es una **adaptación**, no una traducción literal.

Los prompts de arte van siempre en inglés y viven en `lib/temas/templo/arte.dart`:
no son para el jugador sino para el generador de imágenes, así que no se traducen.

Por defecto sigue el idioma del sistema; se puede fijar en la pantalla de Reglas.
`bin/check.dart` falla si a algún idioma le falta una clave.

## Tutorial

`lib/tutorial.dart` + `lib/ui_tutorial.dart`. **Es una partida de verdad**: corre el
mismo `Juego` con `barajar: false` y un mazo trucado, así que cada dinámica aparece
cuando el guion la explica y no puede desincronizarse del juego real.

Se muestra una vez, después del cómic de apertura. Se puede repetir desde Reglas.

## Splash y logo

`lib/ui_splash.dart` dibuja el **Loto Torcido** con `CustomPaint` — sin imagen, para
que funcione desde el primer día y sirva de referencia al ilustrador. La animación
dura 2,2 s y a los 1,1 s **el pétalo torcido se cae**, que es la firma del juego.
El prompt del logo está en `../PROMPT_CARTA.md` y en el plan.

## Pantallas

- **Jugar** — mesa completa: revelar peligro, robar, resolver, meditar, bitácora.
- **Progreso** — timeline de misiones diarias sobre calendario real y el logro de la semana.
- **Balance** — sliders de reglas, edición en vivo de las 55 cartas, y los interruptores de modos. Exportar/importar JSON.
- **Simulador** — un bot juega N partidas y reporta % de victorias, turnos y en qué fase muere el jugador.
- **Reglas** — hoja de reglas que se regenera con los valores actuales, más el
  selector de idioma y el botón para repetir el tutorial.

## Arquitectura: mecánica separada del tema

La propiedad central del proyecto es que **el tema no puede mover el balance**.

| Archivo | Qué contiene |
|---|---|
| `lib/mecanica.dart` | **Sólo números**: poder, daño, cartas gratis, efectos, copias. Fuente única de balance |
| `lib/temas/tema.dart` | El contrato de un tema |
| `lib/temas/templo.dart` | **Sólo textos**: nombres, sabores, prompts de arte, cómic y paleta |
| `lib/data.dart` | Ensambla `Contenido` combinando ambos |

`models.dart`, `engine.dart` y `bot.dart` no saben que existen los temas: reciben
siempre el mismo `Contenido`.

**Para crear una expansión estética:** copiá `lib/temas/templo.dart`, cambiá los
textos, sumalo a `lib/temas/temas.dart`. La verificación de que salió bien es que
`bin/sim.dart` siga dando exactamente los mismos porcentajes.

`temas/` es Dart puro (los colores van como int ARGB, no como `Color`) para que
los scripts headless puedan importarlo sin arrastrar Flutter.

## Modos alternativos

Los dos están **apagados por defecto** y no tocan el juego base.

- **Encargos de Shifu** — cada día real trae una nota con una condición ("no medites",
  "terminá con 10+ de Energía"). Cumplirla da un beneficio para el día siguiente.
  El encargo se elige determinísticamente por fecha. Ver `lib/modos/encargos.dart`.
- **Mazo de Cansancio** — entra una carta de fatiga a tu mazo al terminar cada fase
  (o al rebarajar, configurable), como las cartas de envejecimiento de *Friday*.
  Ver `lib/modos/cansancio.dart`.

  **Es un modo duro:** con Energía 20 baja las victorias de 14% a ~5%. Para jugarlo
  conviene subir la Energía inicial a 25, que lo deja en ~32%.

## Persistencia

`lib/preferencias.dart` guarda todo con `shared_preferences` (que ya es un archivo
de configuración: NSUserDefaults en iOS, XML en Android, localStorage en web).
**No hace falta login ni servidor**: el estado son dos objetos chicos.

Se guardan progreso, config de Balance, idioma, tema, y si ya se vieron el cómic y
el tutorial.

Contrapartida asumida: desinstalar la app borra el progreso, y la racha usa el
reloj del dispositivo.

## Progresión diaria

`lib/progreso.dart` — el día se completa **ganando** una partida en esa fecha real.
Perder no penaliza: podés reintentar. Si pasa un día de calendario sin ganar, la
cadena se corta. Siete días seguidos dan el logro, que se mantiene mientras la
cadena siga viva.

Persiste con `shared_preferences`. **Usa el reloj del navegador**, así que cambiando
la fecha del sistema se saltea la espera: para playtesting alcanza, para publicar no.

## Cómic

Seis secuencias: apertura, 3 interludios y 2 finales. Los textos y los bocetos viven
en el tema; las ilustraciones van en `assets/comic/`. Mientras un PNG no exista, la
app muestra un placeholder con el nombre de archivo que falta. La lista completa
está en `../ASSETS.md`.
