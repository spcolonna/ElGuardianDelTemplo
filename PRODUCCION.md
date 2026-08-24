# 📦 PRODUCCIÓN FÍSICA — El Guardián del Templo

Todo lo necesario para llevar el juego de la app a una caja: medidas de impresión, componentes de mesa, caja, y los prompts del arte que falta.

Complementa a [DISENO_CARTAS.md](DISENO_CARTAS.md), que explica *por qué* cada carta es como es. Acá están los números.

---

## 1. Cartas de desafío (y técnicas iniciales)

| Ítem | Valor |
|---|---|
| **Corte (trim)** | **57 × 89 mm** — bridge estándar |
| **Sangrado** | 3 mm por lado → **63 × 95 mm** |
| **Zona segura** | 3 mm hacia adentro del corte → 51 × 83 mm |
| **Resolución** | 300 dpi |
| **Archivo con sangrado** | **744 × 1122 px** |
| **Caja de corte dentro del archivo** | 673 × 1051 px, centrada (offset 35, 35) |
| **Radio de esquina** | 3 mm |
| **Color** | sRGB para print & play · CMYK (FOGRA39) para imprenta |
| **Gramaje** | 300 g/m² con acabado lino |
| **Impresión** | **Una sola cara** + reverso común. No hay registro frente/dorso que cuidar |

**Por qué bridge y no póker.** El arte está renderizado a 1024 × 1620 px, o sea proporción 0,6321. Bridge es 0,6404: 0,2 % de diferencia, imperceptible. Póker es 0,7159 y obligaría a recomponer las 40 imágenes o a recortarles el 12 % del alto. Además bridge tiene fundas estándar y baratas (Mayday 57,5 × 89).

A 57 mm de ancho, los 1024 px del original dan **456 dpi**: se baja a 300, nunca se estira.

### 1.1 El sangrado hay que generarlo

⚠️ **El arte de `app/assets/cartas/` no tiene sangrado.** La cenefa dorada llega casi al borde del JPG: quedan ~15 px de crema (≈0,8 mm) por fuera. Toda imprenta pide 3 mm y corta con ±0,5 mm de tolerancia. Mandado tal cual, la guillotina se come la cenefa de un lado sí y del otro no, y se nota en las 55 cartas.

Lo resuelve [`bin/imprimir.py`](bin/imprimir.py):

```bash
python3 bin/imprimir.py
```

Por cada JPG: detecta orientación, escala el arte **para que entre entero** en la caja de corte (no recorta nada), lo centra, y genera los 3 mm de sangrado **espejando la tira del borde**. El espejo continúa la textura de papel, así que el empalme no se ve ni buscándolo; un relleno de color plano sí se notaría.

Deja los PNG y un `print/LISTA_DE_TIRADA.txt` con cuántas copias pedir de cada diseño.

**Verificado**: los 40 diseños salen a 744 × 1122 (o 1122 × 744 los jefes), a 300 dpi, con la cenefa dorada íntegra dentro de la línea de corte.

### 1.2 Inventario a imprimir

| Mazo | Cartas | Diseños | Nota |
|---|---|---|---|
| Técnicas iniciales | **20** | 5 | 8 Puño Torpe · 4 Postura Flamenco · 3 Patada Descuidada · 3 Respiración Agitada · 2 Duda Existencial |
| Desafíos (peligro + técnica) | **30** | 30 | 10 Alba · 10 Mediodía · 10 Ocaso. Peligro arriba, técnica invertida 180° abajo |
| Jefes | **5** | 5 | apaisadas, ver §2 |
| **Juego base** | **55** | **40** | ✅ el arte existe |
| Castigo (modo Cansancio) | 10 | 10 | ⚠️ arte pendiente, ver §6.1 |
| Pistas de Energía y de Jefe | 2 | 2 | ⚠️ maquetado pendiente, ver §3 |
| **Total con todo** | **67** | **52** | |

Grosor: **18 mm** el juego base sin fundas, **29 mm** enfundado. Con castigo y pistas: 22 / 35 mm.

### 1.3 Una advertencia sobre el arte existente

En algunas cartas hay elementos a menos de 3 mm del corte —la palabra de fase ("ALBA") y el medallón inferior de la mitad de técnica—. Están **dentro** de la línea de corte, así que sobreviven la tolerancia de ±0,5 mm, pero sin margen de sobra. Si en algún momento se recomponen las cartas, moverlos 2 mm hacia adentro.

---

## 2. Cartas de jefe final

| Ítem | Valor |
|---|---|
| **Corte** | **112 × 70 mm** — troquel propio, apaisado |
| **Sangrado** | 3 mm → **118 × 76 mm** |
| **Archivo** | **1394 × 898 px** a 300 dpi |
| **Dorso** | `reverso_jefe.jpg`, el mismo mandala girado 90° a 118 × 76 mm |
| **En A4** | 4 por hoja → 2 hojas de frentes y 2 de dorsos |

**Por qué 112 × 70 y no el tarot de 70 × 120.** El arte de jefe es 1620 × 1024, o sea proporción 1,582; el tarot pide 1,714. Como la cenefa dorada ya viene pegada al borde de la imagen, recortar para llegar al tarot se come la cenefa a izquierda y derecha, y dejar franjas de crema deja el marco flotando dentro de la carta. 112 × 70 respeta la proporción del arte al milímetro: no se deforma, no se recorta y no hay que regenerar nada. El costo es que no existe funda comercial de esa medida.

**Por qué ya no comparten troquel con el resto.** Hasta la primera tirada física los cinco jefes eran el mismo naipe de 57 × 89 con el dibujo apaisado, apostando a que el giro de 90° sobre la mesa bastara para que se sintieran distintos. Impreso no basta: en la mano son una carta más. 112 × 70 es **55 % más de superficie**, y la diferencia se nota antes de leer el nombre.

El precio, dicho de frente: dos troqueles en vez de uno, dos mínimos de tirada si vas a imprenta, y un dorso extra que hay que imprimir aparte.

Los cinco:

| Carta | Poder | Daño | Cartas gratis |
|---|---:|---:|---:|
| El Monje Caído | 20 | 5 | 7 |
| Tu Propio Reflejo | 22 | 4 | 8 |
| El Señor de los Mercenarios | 18 | 5 | 7 |
| El Gran Maestro del Templo del Loto Negro | 24 | 4 | 9 |
| El Dragón de Papel | 16 | 6 | 6 |

---

## 3. Contador de Energía

**Un solo marcador.** La versión anterior de este documento pedía dos pistas —una de Energía y otra para "el daño acumulado en el Enfrentamiento Final"—. **Esa segunda mecánica no existe**: verificado en el motor, `resolver()` compara la suma de la mesa contra el Poder del jefe y decide de una sola vez. Si ganás, `jefeActual++`; si perdés, pagás el Daño en Energía y el jefe **queda intacto**. No hay ningún campo que acumule daño en todo `app/lib/`. Lo único que persiste entre combates es la Energía.

También pedía una serpentina de 27 casillas de 17 × 20 mm dentro de una carta de 57 × 89. **No entra**: eso da 153 × 60 mm de contenido en una pieza de 57 × 89, en ninguna orientación.

Lo que hay de verdad:

| Componente | Archivo | Medida | Detalle |
|---|---|---|---|
| **Tablero de Energía** | `Assets/Imprimir/TableroEnergia.png` | ancho a elección, 270 mm por defecto | Casillas **0 → 30**, once columnas |
| **Ficha de Energía** | `Assets/Imprimir/Ficha.png` | 20 mm de diámetro por defecto | Moneda dorada con un rayo; se corta redonda |

Las dos son **arte generado, no vectores**: `bin/imprimir.py` las normaliza —aplana el alfa de la ficha sobre el crema, la encuadra en un cuadrado para que el corte redondo no le muerda un borde, y le saca al tablero el fondo oscuro del render— y `imprenta/` elige su medida en mm según la hoja.

**Por qué llega a 30 y no a 26.** El motor sólo necesita 26, que es la Energía inicial del preset *Aprendiz*. Los cuatro de más son para el **Modo Libre**: el jugador elige con cuánta Energía arranca, y el tablero tiene que cubrir el rango entero que se puede pedir. Ojo con esto: si alguna vez se sube la Energía máxima por encima de 30, el tablero se queda corto.

**El tablero de 270 mm no entra en la caja**, que tiene 64 mm de interior. Se guarda aparte. Plegarlo tampoco cierra bien: para meterlo harían falta cinco paneles, y con once columnas de círculos ningún reparto cae limpio entre casillas — cualquier pliegue parte un número al medio. Por eso el plegado es opcional y arranca en «sin plegar».

---

## 4. La caja

| Ítem | Valor |
|---|---|
| **Externa** | **72 × 116 × 40 mm** |
| **Interna** | 64 × 108 × 35 mm |
| **Tipo** | Rígida de dos piezas (tapa y base), cartón gris de 2 mm forrado |
| **Insert** | Cartón de 1,5 mm: pozo de cartas 62 × 91 × 35 mm + pozo de accesorios 62 × 15 × 35 mm |
| **Reglamento** | Folleto 62 × 88 mm cerrado, 12 páginas, apoyado sobre el mazo |
| **Peso estimado** | ≈ 195 g |

Entra el mazo completo **enfundado** (35 mm de pila en 35 mm de pozo) y los dos cubos van al pozo del extremo. Sin fundas sobran 13 mm: se compensa con un separador de cartón, o se deja el lugar para el mazo de Castigo.

Es una caja de bolsillo de campera. Para góndola conviene además una **faja de cartón** (*belly band*) de 30 mm de alto que la cruce, con el logo y el "1 jugador · 25 min": suma presencia sin tocar el troquel.

### Arte de la tapa

| Pieza | Archivo |
|---|---|
| Tapa sola (para probar el diseño) | 78 × 122 mm con sangrado → **921 × 1441 px** a 300 dpi |
| Forro completo de tapa (para imprenta) | 188 × 232 mm con sangrado → **2220 × 2740 px**, solapas de 15 mm |

Los cuatro lados y el fondo **no llevan ilustración generada**: van en crema `#F7F1E1` con la cenefa dorada de las cartas, el lockup horizontal del logo en el lomo largo, y en el fondo la contratapa (foto de componentes, iconos de 1 jugador / 25 min / 14+, y el código de barras en un recuadro blanco de 38 × 22 mm).

---

## 5. Reverso de carta

**Un único diseño para las 65.** La carta de peligro *se muda a tu mazo de combate* cuando la ganás: si el dorso llevara el color de la fase, en tu propio mazo boca abajo sabrías cuál es cuál. Un dorso por fase no es una decisión estética, es una fuga de información.

**Simetría radial.** La mitad de técnica se lee girando la carta 180°, así que el dorso tiene que verse idéntico girado 180°. Lo resuelve un mandala centrado.

**Dos archivos, un solo diseño.** Desde que los jefes tienen troquel propio hacen falta dos piezas: `reverso.jpg` a 63 × 95 mm para los 60 naipes verticales, y `reverso_jefe.jpg` a 118 × 76 mm para los cinco jefes. Es el mismo mandala, **girado 90° antes de encuadrar** — sin girarlo primero, llevar una imagen vertical a una caja apaisada le come el 57 % del alto y se pierde la cenefa. Girado, el recorte es del 3 % y no se nota.

Prompt en §6.2.

---

## 6. Los prompts del arte que falta

Todos viven en [`app/lib/temas/templo/arte.dart`](app/lib/temas/templo/arte.dart), junto al resto del arte del tema. Los sujetos de las cartas están en `sujetosTemplo`; los sufijos de estilo, arriba del mapa.

### 6.1 Las 10 cartas de castigo

Son **gemelas de las cinco cartas iniciales**: 57 × 89 mm, carta entera a sangre, cenefa dorada, nombre arriba, frase de sabor abajo, medallón de Poder en la esquina superior izquierda. Lo único que cambia es el color del medallón: **gris pizarra `#6B6259`** en vez del azul de las técnicas, para que se lean como basura de un vistazo incluso en abanico.

No hay enemigo en la viñeta. El sujeto es siempre el propio novato: el chiste del mazo entero es que la traición viene de adentro.

**Cómo se arma cada prompt:** sujeto + `sufijoCastigoTemplo`. Copiá el bloque de estilo una vez y andá cambiando la primera línea.

```
BLOQUE DE ESTILO (va al final de los diez):

ilustración de carta de juego de mesa COMPLETA, escena a sangre que llena la carta
entera, línea de tinta suelta y gruesa con manchas de acuarela planas, paleta cálida
apagada y DESATURADA, textura de papel crema, ambientación de templo shaolin, tono de
comedia física. El sujeto es el propio monje novato flaco de túnica naranja: no hay
enemigo, el cuerpo se le rebeló solo. Cenefa dorada ornamentada tipo grecas de templo
enmarcando la carta a 4 mm del borde, con esquinas decoradas. En la esquina superior
izquierda, un medallón circular GRIS PIZARRA (#6B6259) con borde de tinta, vacío,
reservado para el número. Franja libre de detalle en el borde superior y en el inferior
para el nombre y la frase. NADA de fotorrealismo, ni 3D, ni brillos metálicos.
FORMATO: imagen VERTICAL de 1024x1620 px, que es la carta completa.
Sin texto, sin letras, sin números, sin marcas de agua.
```

| # | Archivo | Nombre | Poder | Frase de sabor |
|---|---|---|---:|---|
| 1 | `cans_bostezo` | Bostezo | 0 | *Se contagia. Hasta el bandido bostezó.* |
| 2 | `cans_vista` | Vista Nublada | 0 | *Son dos bandidos. O uno. Difícil.* |
| 3 | `cans_piernas` | Piernas de Trapo | −1 | *Están ahí abajo, pero no contestan.* |
| 4 | `cans_hombro` | Hombro Dormido | 0 | *Se despertó antes que vos y volvió a dormirse.* |
| 5 | `cans_ampolla` | Ampolla | 0 | *Chiquita. Insoportable.* |
| 6 | `cans_nudillo` | Nudillo Partido | −1 | *Shifu diría que es carácter. Shifu no está.* |
| 7 | `cans_calambre` | Calambre | 0 | *Justo ahora. Justo ahí.* |
| 8 | `cans_zumbido` | Zumbido en el Oído | 0 | *El mosquito del Alba tuvo la última palabra.* |
| 9 | `cans_espalda` | Espalda Vieja | −1 | *Tenés dieciséis años y la espalda de Shifu.* |
| 10 | `cans_renunciar` | Ganas de Renunciar | −1 | *El puesto de fideos del pueblo también necesita gente.* |

> El Poder que se imprime es `poderCansancio + ajuste`. Con el valor por defecto del modo (`poderCansancio = -1`) las cuatro de −1 quedan en **−2** y el resto en **−1**. Confirmá el valor en Ajustes → Balance antes de maquetar.

**Los diez sujetos**, uno por prompt:

1. **Bostezo** — un monje novato en plena postura de combate arruinada por un bostezo enorme e incontenible, con los ojos cerrados y lagrimeando, mientras un bandido chiquito frente a él también bosteza contagiado
2. **Vista Nublada** — primer plano de un monje novato bizqueando y frotándose los ojos, con dos siluetas borrosas y superpuestas del mismo bandido flotando delante de él
3. **Piernas de Trapo** — un monje novato de torso firme y decidido cuyas piernas se doblaron como trapos mojados y se enroscaron solas en el piso, mirándolas con incredulidad
4. **Hombro Dormido** — un monje novato intentando levantar un brazo que le cuelga muerto del hombro, sosteniéndoselo con la otra mano, con pequeñas zetas de sueño saliéndole del hombro dormido
5. **Ampolla** — un monje novato gigante encogido de dolor señalando con horror una ampolla diminuta y brillante en el talón, con líneas de dolor rojas irradiando desde ese punto
6. **Nudillo Partido** — primer plano del puño de un monje novato con un nudillo partido y vendado con un trapo sucio, temblando, mientras él aprieta los dientes
7. **Calambre** — un monje novato congelado en el aire a mitad de una patada perfecta, con la cara deformada por un calambre y un rayo de dolor cruzándole el muslo
8. **Zumbido en el Oído** — un monje novato con la cabeza torcida golpeándose la oreja con la palma abierta, con espirales de zumbido saliendo del oído y un mosquito engreído alejándose volando al fondo
9. **Espalda Vieja** — un monje novato adolescente doblado en noventa grados con las dos manos en la zona lumbar, caminando como un anciano, con la columna dibujada como una rama a punto de quebrarse
10. **Ganas de Renunciar** — un monje novato sentado en el escalón del templo con la mirada perdida, soñando con un puesto de fideos humeante que flota sobre su cabeza como una nube de pensamiento

### 6.2 Reverso de carta

```
Diseñá el REVERSO de una carta de juego de mesa. Imagen VERTICAL de 744 × 1122 px.

COMPOSICIÓN: mandala perfectamente simétrico y centrado, que se vea idéntico girado
90°, 180° y 270°. Sin arriba ni abajo, sin personajes, sin escena.

CENTRO: un muñeco de entrenamiento de madera (poste vertical con dos brazos
horizontales) visto de frente, con un cinturón de tela atado al medio y las dos puntas
colgando, sobre un disco de acuarela rojo terracota.

ALREDEDOR: una corona de hojas de bambú y flores de loto estilizadas, en grabado en
madera, repetida en simetría de ocho ejes. Después, una cenefa geométrica dorada tipo
grecas de templo que enmarca la carta entera a 4 mm del borde.

ESTILO: línea de tinta suelta y gruesa con manchas de acuarela planas, colores planos,
textura de papel crema visible. NADA de fotorrealismo, ni 3D, ni brillos metálicos, ni
degradados.

PALETA EXACTA: papel #F7F1E1 · tinta #4A3728 · rojo terracota #B2403C ·
oro #F2C14E con borde #C99A2E · madera #C4915A y #8A5F33.

El diseño llega hasta el borde del lienzo (es el sangrado). Sin texto, sin letras, sin
números, sin marcas de agua, sin logo.
```

### 6.3 Logo

Ya existe el **isotipo** (`app/assets/ui/logo.jpeg`, 1024 × 1024: el muñeco de madera con el cinturón sobre el disco rojo). Lo que falta es el **logotipo** —el título lletreado— y el lockup que junta a los dos. Se construye sobre el isotipo, no lo reemplaza.

```
Diseñá el LOGOTIPO de un juego de mesa llamado "EL GUARDIÁN DEL TEMPLO".
Imagen CUADRADA de 2048 × 2048 px, fondo TRANSPARENTE.

COMPOSICIÓN VERTICAL, tres bloques centrados:
1. Arriba, un emblema circular: un muñeco de entrenamiento de madera (poste vertical
   con dos brazos horizontales) con un cinturón de tela atado al medio y las puntas
   colgando, sobre un disco de acuarela rojo terracota, todo rodeado por un círculo de
   tinta trazado a mano, irregular, de un solo trazo.
2. Debajo, "EL GUARDIÁN" en letras chicas, sobre una banda horizontal de acuarela roja.
3. Debajo, "DEL TEMPLO" en letras MUY grandes, ocupando todo el ancho del logo.

TIPOGRAFÍA: lletreada a mano con pincel, mayúsculas, trazos gruesos e irregulares,
ligeramente desprolija y con humor, nunca rígida ni geométrica. Cada letra apenas
distinta de la anterior, como escrita con tinta china sobre papel. El acento de
"GUARDIÁN" bien marcado. NO usar tipografías falsamente orientales de palotes quebrados.

COLOR: letras en tinta marrón oscuro #4A3728 con un contorno crema #F7F1E1 de 6 px que
las despega de cualquier fondo. "DEL TEMPLO" lleva además una sombra plana dorada
#C99A2E desplazada 8 px abajo a la derecha.

ESTILO: línea de tinta suelta, acuarela plana, textura de papel. NADA de 3D, ni metal,
ni relieve, ni degradados, ni efectos de brillo.

El logo tiene que leerse a 40 mm de ancho impreso y en blanco y negro.
```

Tres entregables: **lockup vertical** (tapa de caja, splash de la app), **lockup horizontal** (web, faja, banner) y el **isotipo suelto**, que ya está.

### 6.4 Tapa de la caja

```
Diseñá la TAPA de la caja de un juego de mesa. Imagen VERTICAL de 921 × 1441 px.

ESCENA: un monje novato flaco y torpe, de túnica naranja, plantado solo en el patio de
un templo shaolin en ruinas al atardecer, en una postura de combate que es apenas
demasiado tensa para ser buena. Es chico y está abajo, en el tercio inferior. Frente a
él, ocupando el fondo, se alzan enormes y en penumbra las siluetas de cinco
adversarios: un monje encapuchado, una figura idéntica al propio novato, un mercenario
corpulento, un maestro de túnica lujosa y un dragón de papel. Son sombras con contorno
de tinta, no personajes detallados.

LUZ: sol bajo de ocaso detrás del templo, cielo de acuarela roja y dorada, largas
sombras cruzando el patio hacia el espectador.

COMPOSICIÓN: el TERCIO SUPERIOR queda DESPEJADO —cielo liso— para colocar el logotipo
encima. Nada importante ni ningún detalle en esa zona.

ESTILO: ilustración de caricatura, línea de tinta suelta y gruesa, manchas de acuarela
planas, paleta cálida apagada, textura de papel crema. Tono de comedia: el chiste es
que el chico está claramente en problemas y aun así se plantó. NADA de fotorrealismo,
ni 3D, ni pintura digital realista, ni brillos metálicos.

PALETA EXACTA: papel #F7F1E1 · tinta #4A3728 · rojo ocaso #B2403C · dorado #BE8A22 ·
verde #4F9E63 · violeta de los jefes #7048A8 · naranja #E8863C.

La imagen llega hasta el borde del lienzo (sangrado). Sin texto, sin letras, sin
números, sin logos, sin marcas de agua.
```

---

## 7. Paleta oficial

La misma que usa la app (`app/lib/ui_kit.dart` y `app/lib/temas/templo/arte.dart`). Usala tal cual en todo lo impreso.

| Rol | Hex | Dónde |
|---|---|---|
| Papel | `#F7F1E1` | fondo de todo |
| Papel claro | `#FDF8EC` | paneles |
| Tinta | `#4A3728` | texto y línea |
| Madera | `#C4915A` | cubo de Energía |
| Madera oscura | `#8A5F33` | sombras de madera |
| Oro | `#F2C14E` / borde `#C99A2E` | cenefas |
| Naranja | `#E8863C` | túnica del novato |
| **Alba** | `#4F9E63` | fase 1 |
| **Mediodía** | `#BE8A22` | fase 2 |
| **Ocaso** | `#B2403C` | fase 3 · casilla 0 de la pista |
| **Jefes** | `#7048A8` | Enfrentamiento Final · cubo de Jefe |
| Castigo | `#6B6259` | medallón de las cartas de Cansancio |

---

## 8. Checklist antes de mandar a imprimir

1. `python3 bin/imprimir.py` y revisar que salgan **50 diseños** sin error: 45 verticales y 5 jefes.
2. `node imprenta/pruebas.mjs` en verde. Ahí adentro está el chequeo que importa: que las piezas que no son naipes **no se cuelen en el conteo del mazo**. Ya pasó una vez.
3. Abrir tres JPG (un Alba, un jefe, una inicial) y confirmar **744 × 1122** los verticales, **1394 × 898** los jefes, y **300 dpi** en los metadatos.
4. Superponer la caja de corte (674 × 1052 centrada en 35, 35) y verificar que la cenefa dorada queda **entera adentro** y que hay papel continuo en los 3 mm de sangrado.
5. Imprimir una hoja A4 al **100 %, sin "ajustar a página"**, cortar dos cartas y medirlas con regla: **57 × 89 mm** las normales, **112 × 70 mm** los jefes. Es el control que caza el 99 % de los desastres de imprenta.
6. Poner un jefe al lado de una carta normal. Si no salta a la vista que son piezas distintas, algo se imprimió con escala.
7. Meter dos cartas en una funda Mayday 57,5 × 89 para confirmar el calce. Para los jefes **no hay funda comercial**: van sin funda o con una recortada.
8. Armar el mazo entero de prueba y medir la pila: tiene que dar ≈ 18 mm sin fundas.
9. Convertir a **CMYK (FOGRA39)** recién al final, y mirar los rojos: `#B2403C` es el que más se apaga al pasar de RGB.
