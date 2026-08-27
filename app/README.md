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

## Los ocho caminos

`lib/modos/dificultad.dart`, y de ahí salen tanto la app como la tabla del
reglamento impreso: `bin/export_libro.dart` los exporta a
`imprenta/datos/juego_templo_es.json` y el librillo arma su tabla con esas
filas. **No hay una segunda tabla escrita a mano en ningún lado.**

| Camino | Energía | Peligros/fase | Jefes | Carta extra | Cansancio |
|---|--:|--:|--:|--:|---|
| Aprendiz | 26 | 10 | 1 | 1 | — |
| Novato | 22 | 9 | 2 | 1 | — |
| Guardián | 20 | 7 | 2 | 1 | — |
| Maestro | 18 | 6 | 3 | 2 | — |
| Gran Maestro | 20 | 8 | 3 | 2 | al cerrar cada fase |
| Anciano del Templo | 22 | 8 | 3 | 2 | al rebarajar |
| Sombra de Shifu | 26 | 9 | 4 | 2 | las dos cosas |
| Shifu | 30 | 10 | 5 | 2 | las dos cosas |

Tres cosas que no se leen solas en esa tabla:

**Más peligros por fase es un mazo más fuerte, no un juego más difícil.** Cada
peligro ganado es una técnica que te llevás, así que Aprendiz con 10 llega al
Mediodía con tres cartas buenas más que Guardián con 7.

**De Gran Maestro para arriba la dificultad cambia de forma.** Hasta ahí el
juego aprieta sacándote recursos; de ahí en adelante te los devuelve —más
Energía, más peligros— y te pone a pelear contra tu propio mazo, que se ensucia
de Cansancio mientras jugás. Por eso Maestro es el nivel más magro de la tabla
y no el más difícil.

**En los cuatro altos el Cansancio no es opcional.** `Dificultad.traeCansancio`
lo marca, el preset lo prende, y `OpcionesPartida.aplicar()` deja que el
interruptor lo **sume** pero nunca que lo saque: apagarlo ahí sería jugar otro
nivel con el nombre de éste. La pantalla de Modos lo muestra prendido, con el
motivo escrito debajo en vez de un candado, porque no hay nada que comprar.

**Shifu se aparta del reglamento viejo, a propósito.** El papel pedía las diez
fatigas barajadas en el mazo inicial; el motor reparte el Cansancio por
disparos y no por mazo de arranque, y forzarlo pedía una preparación de partida
distinta para un solo nivel. Se juega con los dos disparos a la vez: llega a
las mismas diez cartas, repartidas a lo largo del día. **El librillo impreso se
cambió para decir lo mismo**, así que el nivel Shifu es uno solo en la caja y
en la app.

**Los cuatro altos están medidos y son casi invencibles.** Con el bot de
`lib/bot.dart`, 2000 partidas por camino:

| | aprendiz | novato | guardián | maestro | granMaestro | anciano | sombra | shifu |
|---|--:|--:|--:|--:|--:|--:|--:|--:|
| victorias | 72,5 % | 23,9 % | 9,4 % | 0,9 % | 0,1 % | 0,3 % | 0,1 % | 0,1 % |

O sea que **arriba de Maestro la escalera deja de ser una escalera**: los cuatro
dan lo mismo, y ese mismo es «casi nunca». Es consistente con lo que promete el
reglamento —«Shifu: el día imposible, nadie lo superó todavía»— pero significa
que Gran Maestro, Anciano y Sombra no se distinguen por el resultado, sólo por
la forma de perder. Si alguna vez se quiere una progresión real ahí arriba, hay
que aflojar los tres del medio; es una decisión de diseño, no un bug.

El bot es codicioso y juega peor que una persona, así que estos números son un
piso, no la experiencia real.

---

## Monetización: gratis el primer camino, el resto se compra

Una compra única, no consumible: `guardian_templo_completo`. Todo vive en
`lib/tienda/`.

| Gratis | Comprado |
|---|---|
| Sólo el camino **Aprendiz** | Los ocho caminos |
| Jefes en **Auto** | El selector de jefes, hasta cinco |
| Sin Encargos ni Cansancio | Los dos modos opcionales |
| Un aviso de pantalla completa en cada cambio de fase | Ningún aviso |

**Los tres avisos son tres y no más:** alba→mediodía, mediodía→ocaso y
ocaso→jefes. Salen en el `onTerminar` del cómic del interludio
(`lib/ui_game.dart`), o sea después del corte de capítulo y cuando el jugador
acaba de tocar «seguir». No hay aviso en victoria ni en derrota.

`Anuncios.mostrarEnFase()` **nunca deja la partida esperando**: si el jugador
compró, si no hay aviso cargado, si el SDK falla o si tarda más de cuatro
segundos, vuelve enseguida y el juego sigue. Un aviso que no aparece es plata
perdida; una partida colgada es un jugador perdido.

### El gate tiene dos puertas, y la que cuenta es la segunda

La primera son los controles bloqueados en la pantalla de modos. La segunda es
`AppState._apretarOpcionesSiNoCompro()`, que corre en `cargar()` y en cada
`guardarOpciones()`. Sin ella, unas opciones guardadas por una versión anterior
al bloqueo —Maestro, tres jefes, los dos modos— abrirían el juego entero sin
pagar y sin tocar un solo control. `test/tienda_test.dart` lo cubre.

### Restaurar la compra no es opcional

`shared_preferences` no sobrevive a una desinstalación. Sin el botón de
Ajustes, quien reinstale pierde lo que pagó. Google y Apple además lo exigen
para aprobar la app.

### Hoy anda con identificadores de prueba

`lib/tienda/ids.dart` tiene `kIdsDePrueba = true`: los avisos son los de prueba
públicos de Google —dicen «Test Ad»— y la compra se resuelve local, sin hablar
con ninguna tienda. Anda entero sin cuenta de AdMob ni de las tiendas.

Para producción, ese archivo tiene la lista de los cinco pasos. Dos de ellos son
archivos nativos y no leen Dart: el App ID va **repetido** en
`android/app/src/main/AndroidManifest.xml` y en `ios/Runner/Info.plist`. Si no
coincide con el de `ids.dart`, el SDK tira una excepción y la app se cae al
arrancar.

**Antes de publicar** faltan, y son tuyos: el keystore de release (hoy
`android/app/build.gradle.kts` firma con las debug keys y tiene el TODO puesto),
el formulario de consentimiento UMP para Europa, y decidir si la app se declara
dirigida a menores —el juego apunta al mismo público que el libro, «a partir de
9 años», y eso cambia qué avisos se pueden servir.

`google_mobile_ads` está **clavado en 8.0.0**. La 9.1.0 no compila en iOS: pide
un header privado que el SDK 13.7 no expone. Está explicado en `pubspec.yaml`.

## Persistencia

`lib/preferencias.dart` guarda todo con `shared_preferences` (que ya es un archivo
de configuración: NSUserDefaults en iOS, XML en Android, localStorage en web).
**No hace falta login ni servidor**: el estado son dos objetos chicos.

Se guardan progreso, config de Balance, idioma, tema, si ya se vieron el cómic y
el tutorial, y si el jugador compró el juego completo.

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
