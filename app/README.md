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

  **Es la perilla que más pesa de todas.** Medido con `bin/sim_cansancio.dart`
  (7 peligros, 2 jefes): con Energía 20 baja las victorias de 9,4 % a 0,5 %, y
  con Energía 25 de 42,8 % a 6,5 %. Cuesta unos **6 puntos de Energía**, no 2 —
  por eso los tres caminos que lo traen puesto arrancan con 29, 30 y 28 cuando
  el juego base arranca con 23.

## Los seis caminos

`lib/modos/dificultad.dart`, y de ahí salen tanto la app como la tabla del
reglamento impreso: `bin/export_libro.dart` los exporta a
`imprenta/datos/juego_templo_es.json` y el librillo arma su tabla con esas
filas. **No hay una segunda tabla escrita a mano en ningún lado** — la de acá
abajo es la salida de `bin/sim_dificultad.dart`, que se regenera con un
comando.

```
camino             win%   salto   turnos  elim  jefes      (bot codicioso)
aprendiz           56,8     —      28,7    7,8   0,6
novato             43,7   -13,0    28,3    7,6   0,9
guardian           36,4    -7,3    27,2    7,6   0,8
maestro            29,8    -6,6    28,1    9,9   1,0
sombraDeShifu      27,1    -2,7    29,1   10,3   1,6
shifu              16,0   -11,1    27,3    9,6   1,0

                                                          (bot meditador)
aprendiz           52,5 · novato 41,8 · guardian 33,7
maestro            30,9 · sombraDeShifu 23,9 · shifu 15,3
```

| Camino | Energía | Peligros/fase | Jefes | Cansancio |
|---|--:|--:|--:|---|
| Aprendiz | 25 | 10 | 1 | — |
| Novato | 24 | 10 | 2 | — |
| Guardián | 23 | 10 | 2 | — |
| Maestro | 29 | 10 | 3 | al cerrar fase |
| Sombra de Shifu | 30 | 10 | 5 | al rebarajar |
| Shifu | 28 | 10 | 5 | al rebarajar |

**Los dos escalones finos.** Guardián/Maestro miden 2,8 puntos con el bot
meditador y Maestro/Sombra miden 2,7 con el codicioso. Siguen siendo escalones
—el orden aguanta con las dos políticas— pero son los más angostos de la tabla:
si se toca cualquiera de esos tres presets hay que remedir, y por eso
`test/escalera_test.dart` corre 2000 partidas y no 400. Con 400 el ruido da
vuelta el orden.

**La escalera es el invariante, no los números.** Cada camino gana entre tres y
trece puntos menos que el anterior, y el orden se mantiene también con un bot que
medita al doble de seguido (`--politicas` del simulador). `test/escalera_test.dart`
lo defiende: si alguien mueve un preset y aplana un escalón, el test se pone
rojo. Antes no existía esa red, y por eso la tabla llegó a tener cuatro caminos
que medían todos 0,1 % sin que nadie se enterara.

Tres cosas que no se leen solas en esa tabla:

**Más peligros por fase es un mazo más fuerte, no un juego más difícil.** Cada
peligro ganado es una técnica que te llevás, así que recortarlos empobrece el
mazo que llega a los Campeones. Los seis caminos enfrentan el mazo entero:
`peligrosPorFase` dejó de usarse como escalón porque, medido, mueve menos que
un solo punto de Energía y a cambio acorta la partida.

**De Maestro para arriba la dificultad cambia de forma.** Hasta ahí el juego
aprieta sacándote Energía y poniéndote Campeones; de ahí en adelante te
devuelve Energía —29, 30 y 28, contra los 23 de Guardián— y te pone a pelear
contra tu propio mazo, que se ensucia de Cansancio mientras jugás. El quiebre
está en el medio de la escalera y no arriba del todo a pedido del dueño del
juego, que reportó que hasta Sombra de Shifu «fue todo muy fácil»: llegar al
techo sin haber jugado nunca con el mazo sucio es llegar sin haber aprendido lo
que importa. Maestro usa el disparo suave (`finDeFase`, tres fatigas en toda la
partida); los dos de arriba usan `alRebarajar`, que dispara bastante más
seguido.

**La Energía es, de lejos, la palanca más brusca que queda.** Un punto vale
entre siete y diez puntos de victoria; un jefe de más o de menos vale unos dos,
y un peligro por fase, menos todavía. No es una preferencia de diseño: es que
`peligrosPorFase` y `cantidadJefes` ya están casi en su techo (10 y 5) y no
queda recorrido. Cualquier escalón nuevo va a salir de la Energía o del
Cansancio.

**Sombra de Shifu es una mesa que se jugó de verdad**, no una estimación: el
autor la ganó una vez de tres, y el bot la mide en 27,1 %. Shifu es esa misma
mesa con dos de Energía menos. Arriba de ahí no queda nada: 10 peligros son
todas las cartas de la fase, 5 son todos los jefes y 30 es el borde del tablero
impreso.

**Guardián se mueve moviendo el juego base.** El chequeo 13 de `bin/check.dart`
exige que el preset Guardián sea la identidad sobre `Config()`, así que bajarlo
a 23 de Energía obligó a tocar en el mismo commit los valores por defecto del
constructor, **`Config.fromJson`, que tiene su propia copia de los defaults**,
`assets/config.json` (chequeo 12) y la clave del override de `/admin`, que pasó
a `v4`. Sin lo último, una máquina que hubiera exportado config alguna vez se
queda midiendo el juego anterior sin que nada avise.

### Palancas que miden bien y palancas que mienten

El bot de `lib/bot.dart` es codicioso de un paso y **casi nunca medita** —le
hacen falta a la vez `postCombate`, haber *perdido* el combate, más de 8 de
Energía y una carta basura en el descarte—. Eso hace que algunas perillas no se
puedan calibrar con él:

- **Miden bien:** `energiaInicial`, `peligrosPorFase`, `cantidadJefes`,
  `modoCansancio` y `disparoCansancio`.
- **Mienten:** `costeMeditar` y `cartasPorMeditacion` —el bot ni los lee, su
  umbral es el literal 8— y `meditarSoloAlPerder`, que lo hace meditar cinco
  veces por combate hasta fundirse la Energía. **No usarlas como escalón:** una
  palanca que no se puede validar deja creyendo que un camino está en 25 %
  cuando para una persona está en 10 %.
- **Descartadas por medición:** `costeRoboExtra` a 2 saca 17 puntos de una sola
  vez (27,1 % → 10,3 %), y hace que el bot deje de comprar cartas fuera de los
  jefes. Y `peligroPerdidoSaleDelJuego = false` sale al revés de lo que parece:
  **afloja** (27,1 % → 29,0 %), porque el peligro que vuelve es otra chance de
  llevarse su técnica.

Aprendiz traía `cartasGratisExtra = 1` y `meditarSoloAlPerder = false`. Las dos
se sacaron: la primera lo dejaba en **99 %**, que no es un camino sino un paseo,
y encima es el camino de la versión gratis, o sea la vidriera del juego.

El bot juega peor que una persona: estos números son un **piso**, no la
experiencia real. La zona sana declarada para un solitario de este tipo es
25–45 % (`lib/ui_sim.dart`), y ahí es donde cae Guardián, que es la identidad
sobre `Config()`.

```bash
cd app && dart run bin/sim_dificultad.dart --politicas
```

---

## Monetización: gratis el primer camino, el resto se compra

Una compra única, no consumible: `guardian_templo_completo`. Todo vive en
`lib/tienda/`.

| Gratis | Comprado |
|---|---|
| Sólo el camino **Aprendiz** | Los seis caminos |
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
