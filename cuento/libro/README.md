# El libro

La maqueta impresa del cuento. Lee los cinco `.md` de `cuento/` y el arte de
`Assets/`, y no escribe sobre ninguno de los dos.

**El juego no se toca.** Nada de acá modifica `app/`, `imprenta/`, `bin/`,
`csv/` ni `Assets/`. Lo único que se escribe es `cuento/libro/img/` y
`cuento/libro/datos/`, que son derivados y se regeneran con un comando.

---

## Cómo se usa

Una sola vez, o cuando cambie el arte:

```bash
python3 cuento/libro/preparar_arte.py
```

Cada vez que corregís la prosa o la dirección de arte:

```bash
node cuento/libro/parser.mjs && node cuento/libro/verificar.mjs
```

Y para verlo:

```bash
node imprenta/servidor.mjs
```

- Interior — <http://127.0.0.1:8123/cuento/libro/?doc=tomo1&densidad=aire>
- Tapa — <http://127.0.0.1:8123/cuento/libro/tapa.html?doc=tomo1&paginas=80>

### Parámetros del interior

| | |
|---|---|
| `doc` | `tomo1`…`tomo5`, `completo` |
| `densidad` | `compacto` · `normal` · `aire`. Cambia la cantidad de páginas y por lo tanto el precio de tapa |
| `prueba=1` | marca en rojo las páginas que desbordan |
| `hoja=0.3` | hoja de contacto: todas las páginas reducidas en una grilla, para mirar el ritmo del libro de un vistazo. `desde` y `cuantas` acotan el tramo |

### Parámetros de la tapa

| | |
|---|---|
| `doc` | decide si lleva faja con el título del tomo |
| `paginas` | el número que dice el interior abajo a la izquierda. **De acá sale el ancho del lomo** |
| `papel` | `amazon` (0,0572 mm por hoja) · `local` (0,08 mm, obra 90 g — confirmalo con tu imprenta) |
| `guias=1` | marca los dobleces y la línea de corte |
| `esc=0.55` | vista reducida, para ver el forro entero en pantalla |

---

## Cómo salen los PDF

No hay generador de PDF: lo hace el navegador, que es el único que sabe cortar
las líneas de este texto exactamente como se ven en pantalla.

**Interior** — Imprimir (⌘P) desde la vista sin `hoja`:

- Destino: **Guardar como PDF**
- Tamaño de papel: **personalizado 139,7 × 215,9 mm** (5,5 × 8,5 pulgadas)
- Márgenes: **Ninguno**
- Escala: **100 %** — nunca «ajustar a página»
- **Gráficos de fondo: activados** (sin esto el papel sale blanco y las bandas
  a sangre desaparecen)

**Tapa** — lo mismo, con el tamaño de papel que dice la barra de arriba
(`289,8 × 222,3 mm` para 80 páginas) y sin `esc` ni `guias`.

Si el PDF sale con el doble de páginas, es que el navegador imprimió con
márgenes: volvé a Márgenes → Ninguno y Escala → 100 %. El total de páginas del
PDF tiene que dar exactamente el número que muestra la barra de arriba.

Antes de mandar una tirada de verdad: imprimí las primeras ocho páginas en una
hoja A4 al 100 %, sin ajustar, y medí con una regla que el ancho de la página
dé 139,7 mm. Es el mismo control que `PRODUCCION.md` usa para las cartas.

---

## Qué hace cada archivo

| | |
|---|---|
| `preparar_arte.py` | Parte el tríptico del templo, amplía la tapa y recorta las viñetas de personaje. Escribe sólo en `img/` |
| `parser.mjs` | Los `.md` → bloques tipados en `datos/*.json` |
| `maqueta.json` | **La dirección de arte.** Qué ilustración va en qué sección, de qué tamaño y en qué punto del texto |
| `paginador.js` | Reparte los bloques en páginas. Copia adaptada de `imprenta/librillo/paginador.js` |
| `render.js` | Bloque → HTML, y las funciones de medición que el paginador le pide al navegador |
| `libro.css` | La grilla, la escala tipográfica y las seis disposiciones de página |
| `index.html` | Carga, prepara, pagina en dos pasadas y dibuja |
| `tapa.html` · `tapa.css` | El forro completo, con el lomo calculado |
| `verificar.mjs` | Los chequeos automáticos |
| `COMERCIAL.md` | Páginas medidas, costos de impresión y precios |

---

## La dirección de arte vive en `maqueta.json`

En el markdown está la prosa y nada más. Dónde va cada dibujo, de qué tamaño y
en qué punto del texto está acá, para que puedas seguir corrigiendo el cuento
sin pensar en la maqueta y ajustar la maqueta sin tocar el cuento.

Las claves son títulos de sección. `UNO/ALBA` pisa a `ALBA`, que sirve para
darle a cada uno de los cinco días su propia apertura.

### La imagen se ancla al texto, no a un porcentaje

La forma buena de ubicar una ilustración es decir **después de qué frase** entra:

```json
"La ampolla": {
  "vinetas": [
    { "src": "Assets/Cansancio/5.jpeg",
      "tras": "del tamaño de una lenteja, y era blanca",
      "ancho": 58, "lado": "izq" }
  ]
}
```

`tras` busca el párrafo que contiene ese texto y mete la imagen justo después.
Así la ilustración aparece cuando el texto acaba de nombrar lo que muestra, que
es la única regla que importa.

`pos` —una fracción de la sección, `0` pegada al título y `1` al final— sigue
existiendo para lo que no necesita precisión. Pero **una fracción no sabe leer**:
en el 12 % de una sección puede haber perfectamente el medio de una
conversación, y así fue como el primer armado del Tomo I terminó con dibujos
cortando diálogos por la mitad.

Con cualquiera de los dos, el parser corrige el lugar solo:

- una **figura** ocupa el ancho de la caja y parte la lectura, así que nunca
  queda entre dos réplicas: se corre hasta el final de la tanda hablada;
- una **viñeta** va flotada al margen y el texto la rodea, así que sí puede
  quedarse adentro de un diálogo;
- si el texto de un `tras` ya no existe porque reescribiste el párrafo, **el
  parser falla y te dice cuál**, en vez de mover la imagen a cualquier lado en
  silencio.

### Y el cansancio se gana con el texto

Las diez imágenes de `Assets/Cansancio/` no se ponen porque quede lindo. **El
texto tiene que nombrar la lesión primero**: la ampolla, el hombro dormido, el
nudillo partido. Puesta sin eso, la imagen no se entiende y contradice el
cierre del tomo, que dice cuántas fatigas lleva acumuladas. La biblia tiene el
reparto: el Tomo I lleva cero, el II una, el III dos, el IV tres y el V cuatro.

| Campo | Qué hace |
|---|---|
| `fondo` | Imagen de apertura de fase. `null` la saca |
| `figuras` | Reemplaza las que declaró el markdown — para mudar una ilustración a la sección donde queda mejor |
| `quitar` | Saca una sola |
| `modo` · `modos` | `estampa` (ancho de caja) · `sangre` (banda que cruza la página) · `sobre` (banda arriba y el texto en un panel encima) |
| `anclas` | `[{src, tras}]`. Ancla una figura a la frase después de la cual entra |
| `posiciones` | Dónde cae cada figura, por fracción. `0` pegada al título, `1` al final |
| `tira` · `posTira` | Varias viñetas verticales en fila, con su nombre debajo |
| `vinetas` | `{src, ancho en mm, lado}` más `tras` o `pos`. Dibujos chicos flotados al margen |

**Regla que el verificador hace cumplir: una ilustración aparece una sola vez
en el libro.** Si el markdown declara `patio.jpeg` seis veces, el parser se
queda con la primera y descarta el resto.

---

## Los tomos terminados no se regeneran

`cuento/libro/final/` le gana a `cuento/libro/datos/`.

`datos/` es borrador: lo escribe `parser.mjs` cada vez que corre. `final/` son
los tomos ya acomodados a mano, y el parser **no los toca**: cuando encuentra
uno ahí, avisa `CONGELADO` y sigue de largo. `index.html` carga de `final/`
primero y cae a `datos/` si no está.

Por eso `datos/` está en el `.gitignore` y `final/` no. Un tomo que pasó por tus
manos tiene que estar en git; uno que sale de un script, no.

Para volver a generar un tomo congelado, sacalo de `final/`. Para congelar uno,
copiá su JSON de `datos/` a `final/`.

---

## Los chequeos

`verificar.mjs` corre cinco cosas:

1. Todas las rutas de imagen **existen** en disco.
2. **Ninguna ilustración se repite** dentro del mismo volumen.
3. **Resolución.** Calcula los dpi reales de cada colocación. Menos de 180 es
   un fallo; entre 180 y 300, un aviso.
4. **Nada de jerga de juego** llegó a la página: mazo de cartas, carta de
   peligro, poder N, daño N. (Un mazo de madera para tocar la campana sí puede
   aparecer: es un mazo de verdad.)
5. Las dos pasadas de paginación dan el mismo número de páginas — eso lo dice
   `index.html` en la barra de arriba.

### Sobre la resolución

El arte mide 1200 px (peligros y técnicas) y 1376 px (jefes y escenarios). El
formato de 5,5 × 8,5 pulgadas se eligió por eso: la caja de texto mide 104,7 mm
y una ilustración de 1200 px entra a ancho completo **a 291 dpi**.

Las bandas a sangre conservan la proporción del arte y ocupan 146 mm de ancho,
lo que las deja entre 186 y 239 dpi. Amazon avisa por debajo de 300 pero
imprime; son fondos de acuarela sin línea fina y a esa densidad se ven bien.

Lo que **no** se puede hacer es recortar una imagen apaisada a página entera
con `object-fit: cover`: ahí el alto manda, los 768 px se estiran sobre 222 mm
y quedan 88 dpi. Se probó, se vio, y por eso las bandas son bandas.

## Las páginas del cómic

`app/assets/comic/` tiene veintitrés viñetas grandes que siguen la historia
escena por escena. Se leen desde ahí, sin copiarlas ni tocarlas, y son la mejor
resolución que tiene el libro: 1536 px o más, o sea 267 dpi a sangre y entre
350 y 400 dpi a ancho de caja.

Van veinte. **Tres quedan afuera a propósito:**

| Archivo | Por qué no entra |
|---|---|
| `07_entrenamiento.png` | Tiene cartas del juego flotando alrededor de Guang. En el libro el juego no existe |
| `31_golpean_el_porton.png` | Dice «¡THUD!» tres veces. Es onomatopeya inglesa en un libro en castellano |
| `50`, `51`, `52` | Son la rama de derrota. El libro tiene un solo final y es el otro |

El resto está colocado en `maqueta.json`. Las que abren fase van como banner de
apertura (`fondo`); las que ilustran una escena van como `estampa` a ancho de
caja, y tres van a `sangre` porque merecen la página entera: el templo del
prólogo, el patio destrozado del martes a la mañana y Shifu volviendo el sábado.

## La tapa sale de la caja del juego

**El arte de tapa es `Assets/Imprimir/TapaCajaConLogo.png`**, la misma
ilustración que va en la caja del juego de mesa. Es una decisión, no un
provisorio: el libro y el juego son la misma cosa contada de dos maneras y
tienen que reconocerse desde la mesa de una librería. Vale para los tomos
sueltos y para el volumen que los junta.

`ampliar_tapa()` en `preparar_arte.py` es quien la prepara. El original es más
apaisado que la página (0,640 contra 0,644), así que **recorta de arriba** —el
cielo tiene menos información que el piso— y amplía a 1726 × 2681 px, que son
5,5 × 8,5 pulgadas más 3,175 mm de sangrado a 300 dpi.

El PNG original está versionado en git. `img/tapa.jpeg` **no**: es derivado y se
rehace con `python3 cuento/libro/preparar_arte.py`. Si algún día cambia la tapa
de la caja, el libro la hereda solo.

Sobre el forro, `tapa.html` agrega la faja con la bajada: los tomos llevan
«Libro Uno — El Dragón de Papel» y los suyos; **el volumen lleva «Espíritu de
sacrificio», sin número**, que para eso está `SIN_NUMERO`.
