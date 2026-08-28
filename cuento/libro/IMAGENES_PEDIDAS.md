# Imágenes pedidas

Acá viven los pedidos de arte del libro. La regla es de `~/.claude`: **si no hay
arte que encaje, se pide, no se fuerza.** Meter el recorte menos malo en una
página es peor que dejar la página sin imagen.

Cómo funciona:

1. Elegís de esta lista lo que te sirva y lo generás.
2. Guardás el archivo con el nombre que dice la fila, en la carpeta que dice.
3. Me avisás cuál generaste. Yo lo agrego a `maqueta.json`, corro el parser y
   lo verifico.

**Nada de esto se aplica solo.** Los Tomos I, II y III están congelados en
`final/` y no los toco hasta que digas.

---

## Estilo, para pegar arriba de todos los prompts

Todo el arte del libro tiene que parecer del mismo lápiz. Este bloque va antes
del pedido concreto:

> Children's adventure comic illustration, warm hand-painted look, expressive
> cartoon faces with real weight and anatomy, confident inked outlines, textured
> paper feel. Setting: a small, poor, half-broken mountain temple in ancient
> China. Warm ochre, terracotta and deep green palette, strong directional
> light. No text, no speech bubbles, no logos, no watermark, no borders.

Y lo que **nunca** puede aparecer en una imagen del libro:

- **Cartas de juego.** Ni una, ni de refilón. Quien lea esto no sabe que existe
  un juego de mesa y no se tiene que enterar. Es lo que dejó afuera
  `50_derrota_patio.png` y `07_entrenamiento.png`, que si no eran perfectas.
- Texto de cualquier tipo adentro del dibujo.
- Guang de espaldas cuando la escena habla de su cara o de sus manos.

Personajes, para que salgan iguales a los que ya hay:

| Quién | Cómo es |
|---|---|
| **Guang Lu** | 16 años, flaco, pelo corto revuelto, túnica de ceremonias que le queda grande. En el Tomo IV está roto: pómulo abierto, costilla del lado izquierdo, nudillo del medio de la derecha partido, zapatillas prestadas que le quedan grandes |
| **Mei** | gata gris de templo, flaca, una cicatriz vieja sobre un ojo, mira siempre con el ojo bueno |
| **Tao** | 17, flaco, pelo atado, cara de burla que en el Tomo IV se le cae |
| **Los soldados del Gobernador** | uniforme gris con una franja roja al frente, cuero, casco simple |
| **Wu, Bo y el flaco** | tres tipos flacos, ropa gastada, sin armadura. Bo es el que cocina |

Resolución: **1200 px de ancho como mínimo** para viñeta o estampa, **1800 px**
para banda a sangre. Con menos, `verificar.mjs` la rechaza por dpi.

---

## 1 · Tomo IV — las que faltan

El Tomo IV quedó en 66 páginas y tiene seis secciones enteras sin una sola
imagen. Ordenadas por lo que más le falta a la página.

### 1.1 · El balde de agua fría — ALBA · La estera

- **Ancla:** «Después se lo tiró entero por la cabeza.»
- **Tamaño:** estampa (ancho de caja) · `cuento/libro/img/guang_balde.jpeg`
- **Por qué:** es el mejor golpe cómico del alba y hoy la escena entera es texto.

> Prompt: A skinny teenage boy standing barefoot in the middle of a stone temple
> courtyard at dawn, in sleeping clothes, absolutely drenched, an empty wooden
> bucket still upside down over his head, hair plastered to his face, eyes wide
> open in shock, steam rising off his shoulders in the cold air. Winter mountain
> light, blue-grey shadows and one warm sliver of sunrise.

### 1.2 · La forma de dieciocho movimientos — MEDIODÍA · ¿Sirve esto?

- **Ancla:** «Estaban todos ahí.»
- **Tamaño:** **tira de cinco viñetas** · `cuento/libro/img/forma_1.jpeg` …
  `forma_5.jpeg` (cinco archivos, mismo encuadre, mismo fondo)
- **Por qué:** es el hallazgo del tomo —que la forma aburrida contenía toda la
  semana— y una tira es la única manera de que se vea en vez de explicarse. Es
  el pedido que más le cambia el libro.

> Prompt: Five sequential poses of the same skinny teenage boy performing a
> kung-fu form, seen from the same angle, same distance, same plain warm
> background, like frames of a training manual. Pose 1: hands low, feet
> together, calm. Pose 2: open palm rising like a bird's wing. Pose 3: wrist
> turning inward while the elbow drops, forearm closed. Pose 4: low diagonal
> lunge, weight forward. Pose 5: full turn on the back foot, one hand open.
> Simple full-body figures, no background detail.

### 1.3 · El demonio rojo y el chico sentado — OCASO · El chiquito rojo

- **Ancla:** «Con el bicho dando vueltas alrededor a los alaridos»
- **Tamaño:** estampa · `cuento/libro/img/demonio_ira.jpeg`
- **Por qué:** la escala invertida —una furia enorme del tamaño de un perro
  contra un chico sentado— es la imagen del capítulo y se explica sola.

> Prompt: A skinny teenage boy sitting cross-legged on the stone floor of a dark
> temple courtyard at night, eyes closed, completely still. Circling him, a
> small red demon the size of a dog, bright crimson, teeth bared, neck veins
> bulging, steam pouring off it, mid-scream, swiping at the air. The boy is calm
> and the little demon is enormous with rage: the scale is the joke. Night, cold
> blue stone, the demon is the only source of warm light.

### 1.4 · La campana — La mañana del viernes

- **Ancla:** «y por primera vez desde que Shifu se había ido, la tocó.»
- **Tamaño:** estampa · `cuento/libro/img/guang_campana.jpeg`
- **Por qué:** la campana no suena en cuatro días y ese silencio abre los cuatro
  tomos. Acá se cobra, y es la última página del tomo.

> Prompt: A battered teenage boy swinging a wooden mallet against a big old
> bronze temple bell, seen from the side, morning light coming in low and gold.
> Bruised cheek, bandaged knuckle, oversized robe. His whole body is in the
> swing. Behind him, far below, a mountain road with tiny figures starting to
> climb.

### 1.5 · La cuña — Prólogo · El portón

- **Ancla:** «Ahí se quedó todo el día.»
- **Tamaño:** viñeta 30 mm, lado derecho · `cuento/libro/img/cuna_columna.jpeg`
- **Por qué:** es un objeto que va a importar el sábado, cuando sea lo primero
  que Shifu mire al entrar. Una viñeta chica lo deja plantado sin subrayarlo.

> Prompt: Close-up still life: a single hand-cut wooden wedge leaning against the
> base of a cracked stone column, inside a temple gate. The column is split on a
> diagonal at waist height with a long splinter still attached. Dust, worn stone,
> soft afternoon light. No people.

### 1.6 · El hombro que vuelve — MEDIODÍA · El hombro

- **Ancla:** «Le dolió. Llegó.»
- **Tamaño:** viñeta 32 mm, lado izquierdo · `cuento/libro/img/guang_hombro.jpeg`
- **Por qué:** es la única escena del libro en la que a Guang se le va un dolor
  en vez de sumársele, y hoy pasa entera sin imagen.

> Prompt: A skinny teenage boy sitting cross-legged against a sun-warmed temple
> wall, eyes shut, face wet, raising his left arm straight over his head for the
> first time in days. Half pain, half relief. Afternoon shade, warm wall behind.

---

## 2 · Arte que ya existe y no se está usando

Nada que generar. Sólo decidir.

| Archivo | Qué es | Dónde lo pondría |
|---|---|---|
| ~~`cuento/libro/img/tao_culpable.jpeg`~~ | recorte de Tao con cara de culpa | **Ya puesto.** Tomo IV · La bolsa de monedas, tras «Menos de lo que pensás». Es exactamente esa cara y estaba sin usar |
| ~~`cuento/libro/img/guang_de_espaldas.jpeg`~~ | Guang de espaldas | **Ya puesto.** Tomo IV · La mañana del viernes, tras «Bajó los ciento ocho escalones». Acá sí sirve de espaldas: es alguien bajando. Quedó huérfano cuando lo sacaste de «La mano» |
| `app/assets/comic/31_golpean_el_porton.png` | golpean el portón | **Tomo V**, la llegada del viernes. Limpia, sin cartas |
| `app/assets/comic/51_shifu_ve_el_desastre.png` | Shifu ve el desastre | **Tomo V**, el sábado. Limpia |
| `app/assets/comic/52_la_pregunta.png` | la pregunta | **Tomo V**, el cierre. Limpia |
| `cuento/libro/img/shifu_bajando.jpeg` · `shifu_entero.jpeg` | recortes de Shifu | **Tomo V**, cuando vuelve |
| `app/assets/comic/07_entrenamiento.png` · `50_derrota_patio.png` | dos páginas buenas | **Inutilizables.** Se ven cartas del juego |

Las dos primeras ya están puestas: son Tomo IV, que no está congelado. Las tres
páginas de historieta y los recortes de Shifu esperan al Tomo V.

---

## 3 · Sugerencias para los tomos congelados

**No los toco.** Van acá por si alguna te convence.

Y si alguna te convence, conviene juntar todos los cambios de ese tomo en una
sola pasada: descongelar, agregar, regenerar y volver a congelar una vez, en vez
de tres veces.

Hay un motivo extra para mirar el Tomo II: quedó en **66 páginas**, y Amazon no
imprime a color por debajo de 72. Tres o cuatro imágenes lo cruzan.

### Tomo III · La mano — *la que dejó un hueco*

Cuando sacaste `guang_de_espaldas` de esa sección quedó sin ninguna imagen, y es
la sección donde nace el hilo de la mano izquierda, que después paga el Tomo IV
entero. Merece una y la de antes no servía.

- **Ancla:** «Barrió con la izquierda. Le salió horrible. Tardó el doble»
- **Tamaño:** viñeta 30 mm

> Prompt: Close-up of a teenage boy's left hand gripping the worn wooden handle
> of a broom, awkwardly, knuckles white, the grip clearly wrong and clearly
> being forced. His right hand hangs at the edge of the frame, half-open,
> unable to close. Warm light, worn wood, stone floor below.

### Tomo III · Los nombres

- **Ancla:** «Esa mañana preguntó igual, porque el flaco estaba usando su cuenco.»
- **Tamaño:** estampa

> Prompt: Three thin, tired men in worn clothes sitting in a row on the floor of
> a temple corridor at dawn, eating rice from mismatched bowls, looking out at
> the mountain. Not menacing, not heroic: just men who decided to stay
> somewhere. Grey morning light from the courtyard.

### Tomo II · El inventario

- **Ancla:** la lista de lo que quedó roto tras el primer día
- **Tamaño:** viñeta 34 mm

> Prompt: A broken temple gate: one leaf hanging off a single hinge pin, the
> other closing badly, a stone column split diagonally at waist height with a
> long splinter still attached. Early morning, nobody there.

### Tomo II · La mañana del miércoles

- **Ancla:** «En el escalón cuarenta y dos había bagazo de caña de azúcar»
- **Tamaño:** viñeta 28 mm

> Prompt: Close-up of a worn stone step with fresh chewed sugarcane pulp spat on
> it, a broom's bristles entering the frame. Nobody sitting there. Morning
> light, moss in the cracks.

### Tomo I · La primera mañana

- **Ancla:** el primer barrido de los ciento ocho escalones
- **Tamaño:** banda a sangre (1800 px)

> Prompt: A long stone staircase of a hundred and eight steps climbing a misty
> mountain, seen from below, a very small boy with a broom near the bottom.
> Dawn, cold blue mist in the valley, the temple roof just visible at the top.

---

## 4 · Lo que no pido

Para que se entienda el criterio, y para no volver a discutirlo:

- **Nada para las escenas de diálogo puro.** Una figura no puede cortar una
  tanda hablada; es regla de la maqueta.
- **Nada de `Assets/Cansancio/` que el texto no haya nombrado.** Una imagen de
  fatiga que no nombró el párrafo anterior no se entiende y además le miente al
  recuento del cierre del tomo.
- **Nada de hojas de personaje enteras.** `Assets/kai.jpeg` y las de su clase son
  fichas de producción, con rótulos en inglés y varias poses en la misma imagen.
  Al libro entran recortadas, una pose por viñeta, y de eso se ocupa
  `preparar_arte.py`.
