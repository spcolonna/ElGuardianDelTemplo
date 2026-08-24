# 🃏 DISEÑO DE CARTAS — El Guardián del Templo

Todo lo necesario para producir el juego físico: qué cartas hay, cómo se ven, en qué formato, y cómo generar el arte con IA sin que quede un desastre.

Los datos exactos de cada carta están en `csv/templo/` (ver sección 9).

---

## 1. Inventario de cartas

| Tipo | Cantidad | Qué es |
|---|---|---|
| **Técnica inicial** | 20 cartas (5 diseños) | Tu mazo de arranque. Es malo a propósito |
| **Carta partida (peligro + técnica)** | 30 cartas (10 Alba + 10 Mediodía + 10 Ocaso) | Una sola carta: arriba el peligro, abajo la técnica que ganás al vencerlo |
| **Jefe** | 5 cartas | Los Campeones del Torneo. Se juegan 2 por partida |
| **Ayuda de jugador** | 1–2 | Resumen del turno. Muy recomendable |
| **TOTAL A IMPRIMIR** | **55 cartas**, a una sola cara | |

Las ilustraciones sí son 60 + 5: cada carta partida lleva **dos** viñetas chicas (una por mitad).

### 1.1 La carta partida: peligro arriba, técnica abajo

Cada carta de peligro es **una sola carta, dividida al medio, con las dos mitades en la misma cara**: arriba el peligro, abajo la técnica que ganás al vencerlo. No hay impresión a doble cara ni cartas de recompensa aparte.

Esto tiene tres consecuencias buenísimas para producir el juego:

| | Con carta partida |
|---|---|
| **Cartas a imprimir** | **55** en total (20 iniciales + 30 peligros/técnicas + 5 jefes) |
| **Impresión** | **A una sola cara.** No hay que registrar frente contra dorso: el problema más caro y más frustrante de imprimir cartas en casa simplemente no existe |
| **Reverso** | Uno solo y uniforme por mazo. Prolijo |
| **La recompensa se ve** | **Sí.** Mientras peleás contra el peligro estás mirando, en la misma carta, la técnica que vas a ganar |

> ✅ La app ya se comporta así: durante el combate muestra *"Recompensa: Puño del Bambú (2)"*. Está bien y coincide con el juego físico.

Que la recompensa sea visible **no es un detalle cosmético, es una decisión de diseño**: saber qué estás peleando por ganar es lo que te permite decidir cuánta Energía vale la pena invertir en ese combate. Un peligro barato que da una técnica excelente merece que pagues robos; uno caro que da basura conviene rendirlo.

### 1.2 Cómo funciona en la mesa

1. El mazo de peligros está boca abajo. Das vuelta la carta superior y la ponés **con la mitad de peligro hacia arriba**.
2. Peleás. Desde ahí ves las dos mitades: contra qué peleás y qué ganás.
3. **Si ganás:** la carta pasa a tu pila de descarte. A partir de ese momento **solo cuenta la mitad de técnica**; la mitad de peligro se ignora para siempre.
4. **Si perdés:** la carta se va del juego entera.

### 1.3 La orientación de las dos mitades

Hay dos formas de imprimir la carta partida, y conviene que confirmes cuál usa tu copia de *Friday* antes de maquetar:

| Variante | Cómo se lee | Ventaja |
|---|---|---|
| **A — Mitades encontradas (180°)** | La mitad de técnica está impresa cabeza abajo. Para usarla como técnica girás la carta media vuelta y esa mitad queda arriba | Cuando la carta está en tu mano, la mitad "activa" queda siempre arriba y en abanico se lee sola. Es la más limpia de usar |
| **B — Ambas mitades derechas** | Las dos se leen en la misma dirección, una encima de la otra | Más simple de maquetar, pero en abanico se te tapa la mitad de abajo |

**Recomendación: variante A.** Durante un combate las cartas se juegan superpuestas, y con las mitades encontradas siempre podés poner hacia arriba la mitad que te importa. Si tu copia usa la B, cambiar la plantilla después es cuestión de rotar un grupo.

## 2. Formato físico

| Ítem | Valor |
|---|---|
| **Tamaño de corte** | **57 × 89 mm** (bridge) · los jefes, **112 × 70 mm** |
| **Sangrado** | 3 mm por lado → **63 × 95 mm** · jefes **118 × 76 mm** |
| **Margen de seguridad** | 4 mm hacia adentro del corte. Nada importante afuera de eso |
| **Resolución** | 300 dpi |
| **En píxeles (con sangrado)** | **744 × 1122 px** · jefes **1394 × 898 px** |
| **Esquinas** | Redondeadas, radio 3 mm |
| **Modo de color** | CMYK para imprenta, sRGB para print & play |
| **Gramaje sugerido** | 300 g/m² con acabado lino, o papel común + funda |

Este bloque decía 63 × 88 mm y 815 × 1110 px, que es lo que se había planeado y **no** lo que el pipeline produce. Los números de arriba son los que emite `bin/imprimir.py` y los que verifica `imprenta/pruebas.mjs`; si alguna vez discrepan, manda el código.

**Print & play:** lo arma `imprenta/` — 9 cartas por hoja A4 (3 × 3) y 4 jefes por hoja, con marcas de corte. Imprimí siempre **al 100%, sin "ajustar a página"** — es el error clásico que te deja las cartas 3 mm más chicas.

---

## 3. Anatomía de las cartas

### 3.1 Carta partida (peligro + técnica)

Es la carta clave del juego: 30 de las 65. Cada mitad tiene **57 × 44,5 mm**, así que el espacio es poco y hay que ser disciplinado. La mitad inferior va rotada 180° (variante A).

```
┌─────────────────────────────┐  ─┐
│ ███ ALBA ███          🃏 3  │   │  MITAD PELIGRO
│  Bandido con Palo Podrido   │   │
│  ┌──────┐                   │   │  banda de color = fase
│  │ ilus │    [ 2 ]  PODER   │   │  🃏 = cartas gratis
│  │ 20mm │    💔 1   DAÑO    │   │
│  └──────┘                   │   │
├━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┤  ─┤ ← línea divisoria clara
│                      ˙ǝʇuɐɔ │   │  MITAD TÉCNICA
│   OQWV8 |ǝp oɥund           │   │  (impresa a 180°)
│  ┌──────┐                   │   │
│  │ ilus │    [ 2 ]  PODER   │   │
│  └──────┘    ⚡+1 si ganás   │   │
│ ███ TÉCNICA ███             │   │
└─────────────────────────────┘  ─┘
```

*(la mitad de abajo se muestra invertida a propósito: así se ve en la carta real)*

**Reglas de maquetado, en orden de importancia:**

1. **La línea divisoria tiene que gritar.** Es lo que evita que el jugador sume el número equivocado. Usá una línea gruesa, un cambio de fondo (peligro sobre color, técnica sobre hueso) o las dos cosas. No la insinúes.
2. **Los dos números de Poder van en la misma esquina relativa** — la esquina exterior de cada mitad. Así, gires como gires la carta, el número que importa queda arriba a la izquierda y se lee en abanico.
3. **Colores opuestos entre mitades.** La mitad de peligro lleva el color de su fase; la de técnica, el azul de combate. De un vistazo sabés qué mitad estás mirando.
4. **La ilustración es chica: ~20 × 20 mm por mitad.** No hay lugar para escenas. Un personaje o un objeto, centrado, fondo simple. Esto también abarata el arte: son 60 viñetas chicas, no 60 ilustraciones grandes.
5. **El texto de sabor puede caerse.** Si no entra con 7 pt legibles, sacalo. Los números primero; el chiste, si sobra lugar.

### 3.2 Carta de Técnica inicial

Las 5 del mazo de arranque no tienen mitad de peligro (nunca fueron un peligro). Dos caminos:

- **Recomendado:** usan **toda la carta** con la técnica en grande. Se distinguen al toque de las ganadas, que es temáticamente correcto: son las que traías de antes.
- **Alternativa:** mantienen el formato partido con la mitad superior en blanco o con el dorso del templo, para que todas las cartas del mazo de combate se vean iguales.

### 3.3 Carta de Jefe

```
┌─────────────────────────────┐
│ ███ CAMPEÓN DEL TORNEO ███  │
│                             │
│      ILUSTRACIÓN GRANDE     │ ← ~55%, es el clímax del juego
│                             │
├─────────────────────────────┤
│   El Monje Caído            │
│   PODER 20   💔 5   🃏 7    │
├─────────────────────────────┤
│ "Ex alumno estrella..."     │
└─────────────────────────────┘
```

Las cartas de jefe **son físicamente más grandes: 112 × 70 mm apaisadas**, contra los 57 × 89 del resto. Es 55 % más de superficie y otro troquel.

Se probó primero con el mismo naipe de 57 × 89 y el dibujo apaisado, confiando en que el giro de 90° sobre la mesa alcanzara. Impreso no alcanza: en la mano son una carta más. El cambio de clima lo tiene que dar el tamaño.

La medida no es tarot (70 × 120) porque el arte existente tiene proporción 1,582 y el tarot pide 1,714: llegar al tarot obliga a recortar la cenefa dorada o a dejar franjas de crema. 112 × 70 respeta la proporción del arte al milímetro. El costo es que no hay funda comercial de esa medida.

---

## 4. Estética

### 4.1 Paleta

| Uso | Color | Hex |
|---|---|---|
| Alba | Verde claro | `#7BC67E` |
| Mediodía | Dorado | `#E0B14A` |
| Ocaso | Rojo oscuro | `#C85450` |
| Jefes | Violeta | `#9B6BD6` |
| Técnicas de combate | Azul | `#6FA8DC` |
| Acento / marca | Naranja templo | `#D97B29` |
| Tinta / texto | Casi negro | `#1A1A1F` |
| Papel / fondo claro | Hueso | `#F4EFE6` |

**Decisión importante:** ¿cartas de fondo claro o fondo oscuro? La app es oscura, pero **para imprimir conviene fondo claro** — gasta muchísima menos tinta, se lee mejor bajo luz de mesa, y el print & play casero queda decente. Sugerencia: **fondo hueso con banda de color por fase**, y reservá los fondos oscuros para los jefes.

### 4.2 Tipografía

**La tabla de abajo es normativa.** Salió de imprimir el juego y no poder leerlo: medido sobre `alba1.jpg`, el texto de sabor rondaba los **5 pt** impresos. El piso real es 7 pt — abajo de eso una carta deja de leerse a la distancia a la que se juega, que es medio metro y con la carta en abanico.

Las dos fuentes ya están en el repo, en `app/fonts/`, y son las mismas que usa la app:

| Uso | Fuente | Cuerpo | px a 300 dpi | Interlínea |
|---|---|---|---|---|
| Nombre de carta | **Patrick Hand SC**, versalitas | **12 pt** | 50 | 14 pt |
| Texto de efecto (la regla) | **Atkinson Hyperlegible Bold** | **8,5 pt** | 35 | 10,5 pt |
| Texto de sabor / lore | **Atkinson Hyperlegible** | **7,5 pt** | 31 | 9,5 pt |
| Número de Poder | Atkinson Hyperlegible Bold | 28 pt | 117 | — |
| Daño y cartas gratis | Atkinson Hyperlegible Bold | 15 pt | 62 | — |
| Nombre de fase (ALBA…) | Atkinson Hyperlegible Bold | 8 pt | 33 | — |

**Regla dura: nada por debajo de 7 pt.** Si un texto no entra a 7 pt, se acorta el **texto**, no el cuerpo. Es la única forma de que la regla se sostenga: bajar medio punto "sólo en esta carta" es cómo se llega a los 5 pt.

Atkinson Hyperlegible no es una elección estética: está diseñada para legibilidad, con letras que no se confunden entre sí (I / l / 1, O / 0). En un cuerpo de 7,5 pt eso es exactamente lo que hace falta.

**Cuánto espacio se lleva.** Cada mitad de la carta partida mide 57 × 44,5 mm. El bloque de texto ocupa **15 mm, o sea el 34 %**: nombre 5 mm, efecto 4 mm, sabor de dos líneas 6 mm. Quedan **29,5 mm de ilustración limpia**.

Para que el dibujo no se pierda, el bloque va sobre un **velo crema al 88 % con el borde superior difuminado 2 mm**, nunca sobre una banda opaca. Una banda maciza resuelve la legibilidad tapando el dibujo, que es justo lo que no se quiere.

En los jefes de 112 × 70 sobra lugar: nombre a 16 pt y el párrafo de lore a 9,5 pt.

**Nada de emoji.** Los CSV escriben los efectos con 🃏, ⚡ y 👊 porque nacieron para la pantalla. Ninguna de las dos tipografías tiene esos glifos, así que impresos salen como cuadraditos vacíos; y aun con una fuente de emoji, un pictograma a 8,5 pt es justamente lo que no se lee. En la carta van con todas las letras: «Roba 2 · +1 Energía».

### 4.3 Iconografía

Set mínimo de 6 íconos. Tienen que funcionar en **blanco y negro a 4 mm** — probalos imprimiendo antes de comprometerte.

| Ícono | Significa |
|---|---|
| Puño | Poder |
| Corazón roto | Daño si perdés |
| Abanico de cartas | Cartas gratis |
| Rayo | Energía (+ / −) |
| Flecha sobre carta | Robar |
| Flor de loto | Meditar / reducir peligro |

### 4.4 Estilo de ilustración

Caricatura, línea gruesa, expresiva, humor físico. El protagonista es torpe y el juego se ríe de él todo el tiempo — el arte tiene que sostener ese tono. Nada realista ni épico en serio.

**Regla de oro para 55 cartas:** elegí un estilo que puedas repetir. Tinta suelta + acuarela plana es la apuesta más segura: perdona errores, se ve artesanal, y los generadores de IA lo hacen bien y consistente.

---

## 5. Reversos

| Mazo | Reverso |
|---|---|
| Peligros Alba | Loto sobre fondo verde, sol asomando |
| Peligros Mediodía | Loto sobre fondo dorado, sol alto |
| Peligros Ocaso | Loto sobre fondo rojo oscuro, sol poniéndose |
| Jefes | Loto negro sobre violeta, marco recargado |
| Combate | Loto azul, patrón simple |

**Importante:** las cartas partidas empiezan en un mazo de peligro y terminan en tu mazo de combate. O sea que **su reverso las delata**: en tu mazo de combate vas a tener cartas con reverso verde, dorado y rojo mezcladas con las azules iniciales. Dos salidas:

- **Aceptarlo** (lo más simple, y hasta queda lindo: se ve de qué fase venís aprendiendo).
- **Un reverso único para las 30 cartas partidas**, sin color de fase. Perdés poder separar los tres mazos de peligro por el dorso, así que necesitás guardarlos en bolsitas o separadores.

Un solo dibujo de loto reutilizado con distinto color de fondo y distinta posición del sol: **cuenta el paso del día** y te ahorra cuatro ilustraciones.

---

## 6. Componentes que no son cartas

| Componente | Nota |
|---|---|
| **Marcador de Energía** | 20 fichas, o mejor: **un track de 0–25 impreso** en la ayuda de jugador con 1 ficha. Menos piezas que perder |
| **Ayuda de jugador** | 1 carta tamaño tarot o A6 con el turno paso a paso, los íconos, y la regla de "0 no te mata" |
| **Caja / bolsa** | Con 55–85 cartas entra en una caja chica tipo *Love Letter* |

---

## 7. Generar el arte con IA — cómo hacerlo bien

### 7.1 La regla número uno

**Pedile al generador SOLO la ilustración. Nunca la carta entera.**

Los generadores de imagen escriben texto mal (letras rotas, palabras inventadas), no respetan márgenes de corte y no mantienen la tipografía consistente. Si le pedís "una carta de juego de mesa con el nombre y el poder", vas a obtener algo que parece una carta pero es inservible para imprimir.

**El flujo correcto:**
1. Generás **solo la ilustración**, sin texto ni marco.
2. Armás **una plantilla** de carta (marco, banda de color, tipografías, cajas de texto).
3. **Componés** las 55 cartas automáticamente combinando plantilla + CSV + ilustraciones.

### 7.2 Herramientas de composición

| Herramienta | Por qué |
|---|---|
| **nanDECK** (gratis, Windows) | **La mejor opción acá: lee CSV directamente.** Apuntás `cartas_mecanica.csv` + `cartas_tema.csv`, definís la plantilla una vez, y te genera las 55 cartas y el PDF listo para imprimir. Cambiás un número en el CSV y regenerás todo |
| **Dextrous.io** (gratis, web) | Más moderno y visual, también toma tablas |
| **Component Studio** | Pago, integrado con The Game Crafter si querés imprimir allá |
| **Figma + plugin de datos** | Si te sentís más cómodo diseñando visual |

### 7.3 Formato a pedirle al generador

- **Relación de aspecto: 1:1 (cuadrada).** Cada viñeta va en un recuadro de ~20 × 20 mm dentro de su mitad de carta
- **Resolución:** mínimo 1024 px de lado. A 20 mm y 300 dpi necesitás 236 px, así que sobra de lejos: generá grande y reducí
- **Encuadre: un solo sujeto, centrado, grande.** A 20 mm cualquier escena con dos o tres elementos se convierte en una mancha. Un personaje, un objeto, una acción
- **Fondo:** liso o casi liso — vas a recortarla en círculo o cuadrado con esquinas redondeadas
- **Negativos siempre:** `no text, no letters, no watermark, no border, no frame, no UI, no logo`

### 7.4 Consistencia entre 55 imágenes

Este es el problema real, no la calidad individual.

1. Generá **una sola imagen** hasta que el estilo te convenza. Esa es tu **ancla de estilo**.
2. Usá esa imagen como **referencia de estilo** (image-to-image, `--sref` en Midjourney, "style reference" en la mayoría) para todas las demás.
3. Fijá la **misma semilla** y el mismo bloque de texto de estilo en todos los prompts.
4. Mantené el **mismo encuadre** por tipo: peligros en plano medio, técnicas en plano entero con el personaje en acción, jefes en contrapicado.

### 7.5 Prompt base (copiar y pegar, en inglés)

```
[SUJETO], cartoon illustration for a board game card,
loose ink linework with flat watercolor washes,
warm muted palette, cream paper texture,
simple uncluttered background, centered composition,
expressive and slightly comedic, shaolin temple setting,
square 1:1 composition, single subject centered and large
--no text, letters, watermark, border, frame, UI, logo
```

### 7.6 Tres prompts listos para probar viabilidad

Generá estos tres. Si los tres salen consistentes entre sí, el estilo es viable para las 55.

**1. Peligro fácil — *Mosquito del Templo***
```
a single oversized mosquito buzzing around a clumsy young monk who
is swatting at the air and missing badly, cartoon illustration for a
board game card, loose ink linework with flat watercolor washes,
warm muted palette, cream paper texture, simple uncluttered
background, centered composition, expressive and slightly comedic,
shaolin temple setting, square 1:1 composition, single subject centered and large
--no text, letters, watermark, border, frame, UI, logo
```

**2. Técnica avanzada — *Puño del Tigre***
```
a young monk throwing a powerful straight punch, a ghostly tiger
head roaring superimposed over his fist, dynamic action pose,
cartoon illustration for a board game card, loose ink linework with
flat watercolor washes, warm muted palette, cream paper texture,
simple uncluttered background, centered composition, expressive and
slightly comedic, shaolin temple setting, square 1:1 composition, single subject centered and large
--no text, letters, watermark, border, frame, UI, logo
```

**3. Jefe — *El Dragón de Papel***
```
a giant chinese parade dragon puppet looming menacingly over a tiny
monk, low angle shot, clearly made of paper and bamboo despite
looking fearsome, cartoon illustration for a board game card, loose
ink linework with flat watercolor washes, warm muted palette, cream
paper texture, simple uncluttered background, dramatic composition,
expressive and slightly comedic, shaolin temple setting, square 1:1
composition, single subject centered and large
--no text, letters, watermark, border, frame, UI, logo
```

### 7.7 Test de viabilidad completo (una tarde)

1. Generá los 3 prompts de arriba. ¿Se parecen entre sí? Si no, cambiá de estilo o de generador.
2. Armá **una** plantilla de carta en nanDECK o Figma.
3. Componé **3 cartas** completas: un peligro, una técnica y un jefe.
4. Imprimilas al 100% en A4, cortalas, metelas en fundas.
5. Miralas a 40 cm de distancia, con luz de mesa. **¿Se leen los números? ¿Distinguís el mazo por el color?**

Si eso funciona, el resto es volumen.

---

## 8. Costo aproximado (referencia, no presupuesto)

| Vía | Nota |
|---|---|
| **Print & play casero** | Papel + fundas + tiempo. Casi gratis. **Con la carta partida esto es realmente viable**: imprimís a una cara, cortás y enfundás con una carta de Magic atrás para darle cuerpo |
| **Imprenta local, 55 cartas** | Pedí "cartas de 63×88 mm, 300 g, laminado mate, frente a color y dorso común". Al ser a una cara sale más barato |
| **The Game Crafter / MakePlayingCards** | Copia única desde el exterior. Cómodo, pero el envío a Latinoamérica pesa más que el producto |

---

## 9. Los CSV — un archivo por tipo de carta

En `csv/<tema>/` hay un CSV por tipo de carta (hoy `csv/templo/`). Cada fila es una carta y cada columna un atributo que **va impreso en la carta** o que hace falta para producirla.

**Principio: la carta se lee con número + ícono, no con párrafos.** En 44 mm no entra una explicación, y aunque entrara nadie la lee dos veces. Qué significa cada número lo explica **la carta de referencia** que va en el manual, una sola vez. Por eso en estos CSV no hay textos de reglas: el `3` de cartas gratis es solo un `3`, y que cada carta extra cueste 1 de Energía es una constante del juego que no se repite en 30 cartas.

| Archivo | Filas | Columnas |
|---|---|---|
| `cartas_iniciales.csv` | 5 (= 20 cartas físicas) | 9 |
| `cartas_peligro_tecnica.csv` | 30 | 15 |
| `cartas_jefes.csv` | 5 | 9 |
| `reverso_cartas.csv` | 5 | 7 |

**55 cartas, 70 ilustraciones de frente + 5 reversos.**

### 9.1 `cartas_peligro_tecnica.csv`

| Columna | Ejemplo | Va impreso |
|---|---|---|
| `mazo` | `Alba` | sí, como banda |
| `color_banda_hex` | `#7BC67E` | sí |
| `peligro_nombre` | `Mosquito del Templo` | sí |
| `peligro_poder` | `1` | sí, número grande |
| `peligro_dano` | `1` | sí, junto al ícono 💔 |
| `peligro_cartas_gratis` | `2` | sí, junto al ícono 🃏 |
| `peligro_arte_prompt` | *(prompt completo en inglés)* | no, es para producir |
| `tecnica_nombre` | `Garra Inicial` | sí |
| `tecnica_poder` | `2` | sí, número grande |
| `tecnica_efecto` | `+1 ⚡ si ganás` · `+2 🃏` · `—` | sí |
| `tecnica_texto_sabor` | *"Tu primer movimiento que parece intencional."* | sí, si entra |
| `tecnica_arte_prompt` | *(prompt completo en inglés)* | no |
| `arte_px` | `283` | 24 mm @300 dpi |
| `carta_ancho_px` / `carta_alto_px` | `815` / `1110` | 69 × 94 mm con sangrado |

### 9.2 `cartas_iniciales.csv`

Igual que la mitad de técnica, más **`copias_a_imprimir`**: 8 Puño Torpe, 4 Postura del Flamenco, 3, 3 y 2. Cinco diseños, veinte cartas.

### 9.3 `cartas_jefes.csv`

`nombre`, `poder`, `dano`, `cartas_gratis`, `texto_lore`, `arte_prompt`, dimensiones. No tienen mitad de técnica: los jefes no dan recompensa. El `arte_px` es `473` (40 mm) en vez de 283 — la ilustración de jefe es más grande porque es el clímax de la partida.

### 9.4 `reverso_cartas.csv`

Un reverso por mazo. La columna `mazo` es la que ata este archivo con los otros: la fila `Alba` de acá es el reverso de las filas `Alba` de `cartas_peligro_tecnica.csv`.

| `mazo` | `que_cartas_lleva` | Diseño |
|---|---|---|
| Alba | Las 10 peligro/técnica del Alba | Loto tallado, sol asomando bajo |
| Mediodía | Las 10 del Mediodía | Mismo loto, sol alto y pleno |
| Ocaso | Las 10 del Ocaso | Mismo loto, sol hundiéndose, sombras largas |
| Jefes | Las 5 de Campeón | Loto negro, marco recargado, sin sol |
| Combate | Las 20 técnicas iniciales | Loto simple, sobrio, sin sol |

Un mismo loto reutilizado con distinto color y distinta posición del sol: cuenta el paso del día y te ahorra cuatro ilustraciones. Acá el `arte_px` es la carta entera (815 × 1110), porque el reverso sangra hasta el borde.

### 9.5 Los íconos que hay que definir

Como las cartas no llevan texto explicativo, **los íconos cargan todo el peso**. Son cinco y tienen que funcionar en blanco y negro a 4 mm:

| Ícono | Significa | Dónde aparece |
|---|---|---|
| 👊 | Poder | Las dos mitades y los jefes |
| 💔 | Energía que perdés si no lo vencés | Mitad de peligro y jefes |
| 🃏 | Cartas que robás gratis · robar | Mitad de peligro, jefes y efectos |
| ⚡ | Energía | Efectos de técnica |
| ☯️ | Meditar | Solo en la carta de referencia |

*(los emoji son marcadores de posición: hay que dibujar los cinco íconos definitivos)*

### 9.6 Regenerar los CSV

```bash
cd app && dart run bin/export_csv.dart --tema=templo
```

Los prompts están en `app/lib/temas/templo.dart`: un sujeto en inglés por carta, más un sufijo de estilo común. **Cambiando esa única línea de estilo cambiás las 70 ilustraciones de golpe.**

Los números salen de `app/lib/mecanica.dart`, que es lo mismo que corre la emulación: los CSV y el juego que estás probando no se pueden desincronizar.

**Para una expansión estética** (el payaso y la carpa, por ejemplo): copiás `app/lib/temas/templo.dart`, cambiás nombres, sabores, prompts, cómic y paleta sin tocar un solo número, lo sumás a `temas.dart`, y `--tema=circo` te escribe los CSV de la expansión en `csv/circo/`. El balance queda garantizado idéntico porque los números no viven en el tema.

> **Limitación honesta:** el flujo es de una sola dirección. Si editás un CSV a mano, el cambio no vuelve a la app. Para tocar balance y probarlo, usá la pantalla **Balance** y después regenerá los CSV.

## 10. Checklist antes de mandar a imprimir

- [ ] Confirmaste contra tu copia de *Friday* si las mitades van encontradas (180°) o derechas
- [ ] La línea divisoria entre mitades se distingue de un vistazo, sin dudar
- [ ] Los dos números de Poder quedan en la esquina exterior de cada mitad
- [ ] El balance está cerrado (winrate en el simulador entre 25% y 45%)
- [ ] Los números se leen a 40 cm en una carta impresa de prueba
- [ ] Probaste una carta partida en abanico con otras 4: ¿se lee el Poder de la mitad activa?
- [ ] Los íconos se distinguen en blanco y negro a 4 mm
- [ ] Todas las cartas tienen 3 mm de sangrado y nada importante a menos de 4 mm del corte
- [ ] Los colores por mazo se distinguen bajo luz cálida de mesa
- [ ] Hay una ayuda de jugador con el turno paso a paso
- [ ] Alguien que no sos vos jugó una partida completa **sin que le expliques nada**
