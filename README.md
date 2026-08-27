# El Guardián del Templo

Solitario deck-builder inspirado en *Friday*, con estética dibujada a mano de papel y madera.
Sos el novato a cargo del Templo del Loto Torcido mientras el maestro está de viaje: cada peligro
que superás se da vuelta y se convierte en una técnica de tu mazo.

El repositorio tiene las dos caras del juego: la **app en Flutter** (iOS, Android y web) y el
**print & play** completo — cartas, tablero, fichas, reglamento y cómic listos para imprimir en A4.

## El mapa

| Carpeta | Qué hay |
|---|---|
| `app/` | La app Flutter. El motor (`lib/engine.dart`, `lib/mecanica.dart`, `lib/models.dart`, `lib/modos/`) es **Dart puro y no importa Flutter**, para que los scripts de `bin/` puedan usarlo. |
| `cuento/` | El cuento en cinco tomos y la imprenta del libro ilustrado. Es paralelo al juego: no lo toca ni depende de él. Ver `cuento/libro/README.md`. |
| `Assets/` | El arte original: ilustraciones desnudas de peligros y técnicas, marco, medallones, íconos, jefes y las piezas de la caja. |
| `imprenta/` | La herramienta de imposición: convierte las cartas en pliegos A4 y arma los PDF. Sin dependencias, JavaScript a mano. |
| `imprenta/librillo/` | El reglamento y el cómic en A5, con imposición de cuadernillo. |
| `bin/` | El pipeline de imagen en Python + Pillow: `imprimir.py` prepara todo para imprenta, `componer.py` rearma una carta desde cero. |
| `csv/` | Los datos de las cartas, por idioma. |
| `print/` | **Generado** (ver abajo). No está en el repositorio. |

## Cómo se levanta

```bash
node imprenta/servidor.mjs 8123
```

Abre `http://localhost:8123` con cuatro puertas: la Imprenta, el reglamento, el cómic y el juego.
Los librillos **necesitan el servidor** — con doble clic no funcionan, porque usan `fetch` y
`@font-face`.

La app, aparte:

```bash
cd app && flutter run
```

## Lo que no está en el repositorio, y cómo recuperarlo

`print/`, `imprenta/muestras/` y los PDF de `Assets/Imprimir/` están ignorados a propósito: los
regenera la propia herramienta y versionarlos duplicaría más de 150 MB en cada re-exportación
del arte.

```bash
python3 bin/imprimir.py
```

Reconstruye `print/` entero —las 60 cartas verticales, los 5 jefes, las piezas sueltas, las 23
viñetas del cómic y el `manifiesto.json` que lee la Imprenta— desde `app/assets/` y `Assets/`.
Necesita **Pillow** (`pip3 install Pillow`).

Los PDF salen del navegador, desde la Imprenta y desde los dos librillos. Al imprimir: escala
100 %, márgenes ninguno, y **verificá la regla de control de 100 mm** — el modo «Márgenes:
predeterminado» de Chrome escala para entrar sin avisar.

## Verificación

```bash
node imprenta/pruebas.mjs
```

74 verificaciones de geometría, imposición y contenido, sin navegador ni dependencias.

```bash
cd app && flutter analyze && flutter test && dart run bin/check.dart
```

`check.dart` valida los invariantes del contenido: que las 50 cartas estén completas, que no falte
arte, que `config.json` coincida con `Config()` y que el modo Guardián sea la identidad.

Lo que las pruebas sin navegador no pueden cubrir es la maquetación real de los librillos; para eso
están `librillo/?doc=reglamento&prueba=1` y `?doc=comic&prueba=1`, que corren las invariantes más
una medición real dentro de la página.

## Para leer antes de tocar nada

- [`PRODUCCION.md`](PRODUCCION.md) — troqueles, sangrados, materiales y la lista de impresión.
- [`DISENO_CARTAS.md`](DISENO_CARTAS.md) — la retícula de la carta y la tabla tipográfica normativa.
- [`imprenta/LEEME.md`](imprenta/LEEME.md) — cómo funciona la imposición y qué no cubre.
- [`PROMPT_CARTA.md`](PROMPT_CARTA.md) — para regenerar arte de cartas de forma consistente.
