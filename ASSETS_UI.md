# Arte de interfaz — El Guardián del Templo

Todo lo de este documento va en **`app/assets/ui/`**. La carpeta ya existe y ya
está declarada en `pubspec.yaml`.

> **No los pongas en `app/assets/cartas/`.** Esa carpeta tiene un contrato: el
> chequeo 11 de `bin/check.dart` rechaza cualquier imagen que no mida
> 1024×1620. Es la carpeta de las cartas del juego, nada más.

La app **ya funciona sin estos archivos**: cada pieza tiene un respaldo dibujado
por código. A medida que dejes un PNG, esa pieza pasa sola al arte. No hace
falta que estén todos ni que estén en orden.

Para verificar que quedaron bien:

```bash
cd app && dart run bin/check.dart
```

El chequeo 14 te dice cuáles faltan y cuáles llegaron con la medida equivocada.

---

## Reglas que valen para TODOS los prompts

Copiá estas cuatro líneas al final de cada prompt:

1. **Fondo transparente de verdad** en todo lo que diga "con alfa". Los
   generadores meten fondo blanco por defecto aunque les pidas transparencia:
   revisá el canal alfa antes de guardar.
2. **Sin texto, sin letras, sin números, sin logos, sin marcas de agua.** Todo
   el texto lo dibuja la app — si viene horneado en la imagen, no hay versión
   en inglés.
3. **Iluminación plana y pareja**, sin sombra proyectada con dirección. Explico
   por qué más abajo, en la sección de 9-slice.
4. **Mismo trazo, misma paleta y misma edad de madera que las cartas** que ya
   generamos: acuarela con línea de tinta, papel crema, madera cálida gastada.

Paleta del juego, por si el generador la acepta:
papel `#F7F1E1`, madera `#C4915A`, madera oscura `#8A5F33`, tinta `#4A3728`,
oro `#F2C14E`, rojo `#D2554D`, naranja `#E8863C`, verde `#A8C489`.

---

## Lo importante: cómo funciona el estirado (9-slice)

Ocho de estas piezas se estiran para adaptarse a cualquier pantalla. No se
estiran enteras: **las cuatro esquinas quedan intactas y sólo se estira el
centro y las bandas**. Esto es lo que permite que el mismo marco sirva en un
iPhone SE y en un iPad.

```
┌───────┬───────────────┬───────┐
│esquina│  se estira →  │esquina│   Las esquinas NUNCA se deforman.
├───────┼───────────────┼───────┤
│   ↕   │   se estira   │   ↕   │   Las bandas se estiran en UN eje.
├───────┼───────────────┼───────┤
│esquina│  se estira →  │esquina│
└───────┴───────────────┴───────┘
```

De ahí salen tres reglas concretas para dibujar:

- **Todo el detalle va en las esquinas.** Nudos, clavos, ensambles, desgaste,
  herrajes: adentro de los cuadrados de esquina. Ahí nada se deforma.
- **Las bandas tienen que ser uniformes a lo largo.** Veta paralela al borde,
  sin nudos, sin diagonales, sin nada que se repita a un intervalo fijo. Si hay
  un nudo en la banda superior, se va a estirar hasta verse como una mancha.
- **El borde interno tiene que ser recto** dentro de las bandas. Un filo
  ondulado a mano cambia de frecuencia con el tamaño de pantalla y se nota. Que
  sea irregular sólo en las esquinas.

Y por eso la regla de la iluminación plana: si la pieza tiene una sombra que
insinúa "la luz viene de arriba a la izquierda", esa sombra se contradice
cuando la banda derecha se estira al doble.

---

## Las piezas

### 1. `marco_pantalla.png` — 1200 × 1800, con alfa

**La pieza más importante.** Es el marco de madera que rodea la pantalla entera,
en todas las pantallas del juego.

- El **centro tiene que ser alfa 0 plano y uniforme**: es el hueco por el que se
  ve el juego. Nada de degradado ni viñeta ahí — se estira y se ve como bandas.
- Banda de madera de **grosor constante, 110 px en los cuatro lados**.
- Esquinas de **300 × 300 px**: ahí va todo el detalle.

> Marco de madera tallada a mano que rodea el borde de una pantalla vertical, estilo ilustración infantil con línea de tinta y acuarela. La madera es cálida y gastada, color miel oscuro, con veta visible. Las cuatro esquinas tienen ensambles de carpintería, un clavo de bronce y pequeñas tallas de nube china. Los cuatro lados son tablas rectas de grosor uniforme, con veta paralela al borde, lisas y sin nudos. El centro está COMPLETAMENTE VACÍO Y TRANSPARENTE, es sólo un hueco rectangular con bordes internos rectos. Iluminación plana y pareja, sin sombras proyectadas. Fondo transparente. Formato vertical 1200x1800 px. Sin texto, sin letras, sin números, sin logos, sin marcas de agua.

### 2. `cartel_colgante.png` — 1024 × 384, con alfa

El cartel que lleva el título de cada pantalla. Cuelga de dos cuerdas. **El
texto lo dibuja la app en el centro**, así que el centro tiene que estar libre.

> Cartel de madera colgado de dos cuerdas trenzadas, estilo ilustración infantil con línea de tinta y acuarela. La tabla es horizontal, de madera clara cálida, con las esquinas redondeadas y talladas, y dos anillas de bronce arriba de donde salen las cuerdas. La superficie de la tabla está VACÍA, lisa y clara, lista para escribir encima. El detalle tallado está sólo en los extremos izquierdo y derecho. Iluminación plana, sin sombras proyectadas. Fondo transparente. Formato horizontal 1024x384 px. Sin texto, sin letras, sin números, sin logos, sin marcas de agua.

### 3. `panel_papel.png` — 600 × 600, con alfa

El panel de papel donde va casi toda la información del juego.

> Hoja de papel de arroz color crema, cuadrada, vista de frente, estilo ilustración con línea de tinta suave. Los cuatro bordes están apenas rasgados a mano y hay una fibra de papel visible. Las cuatro esquinas tienen un refuerzo mínimo. El centro está completamente vacío y liso, color crema parejo. Iluminación plana, sin sombras proyectadas. Fondo transparente. Formato cuadrado 600x600 px. Sin texto, sin letras, sin números, sin logos, sin marcas de agua.

### 4. `boton_madera.png` — 512 × 200, con alfa

Botón secundario. Se estira a distintos anchos según el largo del texto.

> Botón rectangular de madera con esquinas redondeadas, estilo ilustración infantil con línea de tinta y acuarela. Madera cálida color miel, con un bisel tallado alrededor y un remache de bronce en cada extremo. La superficie central es lisa y clara, completamente vacía. Los bordes superior e inferior son rectos y uniformes. Iluminación plana, sin sombras proyectadas. Fondo transparente. Formato horizontal 512x200 px. Sin texto, sin letras, sin números, sin logos, sin marcas de agua.

### 5. `boton_dorado.png` — 512 × 200, con alfa

**El botón principal**: JUGAR y EMPEZAR. Tiene que ser el objeto más llamativo
de la pantalla.

> Botón rectangular dorado con esquinas redondeadas, estilo ilustración infantil con línea de tinta y acuarela. Oro cálido y brillante como latón pulido, con un borde tallado más oscuro y un remache ornamentado en cada extremo. La superficie central es lisa, dorada y completamente vacía. Los bordes superior e inferior son rectos y uniformes. Iluminación plana, sin sombras proyectadas. Fondo transparente. Formato horizontal 512x200 px. Sin texto, sin letras, sin números, sin logos, sin marcas de agua.

### 6. `placa_nombre.png` — 512 × 160, con alfa

La placa con el nombre del personaje, debajo del retrato.

> Placa de madera clara con forma de pergamino corto, estilo ilustración infantil con línea de tinta y acuarela. Los extremos izquierdo y derecho están enrollados como un rollo de papel. El centro es una superficie lisa color crema, completamente vacía. Iluminación plana, sin sombras proyectadas. Fondo transparente. Formato horizontal 512x160 px. Sin texto, sin letras, sin números, sin logos, sin marcas de agua.

### 7. `marco_retrato.png` — 768 × 900, con alfa

**El marco donde va tu personaje.** El centro tiene que ser transparente: el
retrato se dibuja por detrás.

> Marco de madera vertical para un retrato, estilo ilustración infantil con línea de tinta y acuarela. Madera cálida gastada con veta visible, ensambles de carpintería en las cuatro esquinas y un pequeño adorno tallado de flor de loto en el borde superior. El centro está COMPLETAMENTE VACÍO Y TRANSPARENTE, un hueco rectangular con bordes internos rectos. Iluminación plana, sin sombras proyectadas. Fondo transparente. Formato vertical 768x900 px. Sin texto, sin letras, sin números, sin logos, sin marcas de agua.

### 8. `barra_inferior.png` — 1200 × 300, con alfa

La barra de accesos del pie. **Sólo se ve la parte de arriba**: la mitad
inferior queda fuera de pantalla, así que ahí no pongas detalle.

> Tabla de madera horizontal ancha vista de frente, como el estante de un templo, estilo ilustración infantil con línea de tinta y acuarela. Madera cálida gastada. El canto superior tiene un moldeado tallado y dos esquinas con ensamble. La superficie es lisa y completamente vacía. Iluminación plana, sin sombras proyectadas. Fondo transparente. Formato horizontal 1200x300 px. Sin texto, sin letras, sin números, sin logos, sin marcas de agua.

---

## Piezas que NO se estiran (más fáciles)

### 9. `fondo_patio.jpg` — 1536 × 2304, sin alfa

El fondo que se ve **detrás del marco**, a sangre completa. Se recorta bastante
en pantallas angostas, así que lo importante va en el centro.

> El patio de un templo de montaña al amanecer, visto desde el suelo, estilo ilustración infantil en acuarela con línea de tinta. Losas de piedra gastadas, un árbol de bambú a un lado, un farol de papel colgando, escalones de piedra que suben, montañas con niebla al fondo, cielo cálido de amanecer. SIN PERSONAJES, sin figuras humanas. Composición tranquila, tonos cálidos apagados, la zona central despejada y sin detalle importante. Formato vertical 1536x2304 px. Sin texto, sin letras, sin números, sin logos, sin marcas de agua.

### 10. `fondo_papel.jpg` — 1024 × 1024, sin alfa

Textura de papel que va encima del fondo crema, a opacidad muy baja. Tiene que
ser **muy sutil**: si se nota, molesta al leer.

> Textura de papel de arroz color crema, plana, vista de frente, escaneada. Fibras finas visibles, grano muy suave y parejo, sin manchas, sin arrugas marcadas, sin bordes. Muy poco contraste, casi liso. Formato cuadrado 1024x1024 px, teselable. Sin texto, sin letras, sin números, sin logos, sin marcas de agua.

### 11. `retrato_novato.png` — 768 × 900, sin alfa

**Acá va el personaje que ya tenés.** Sólo hay que ajustarlo a 768 × 900 px
(proporción 0.853, algo más alto que ancho). Se recorta con `BoxFit.cover`, así
que la cara conviene que esté en el tercio superior.

Si querés generar una variante para cuando el jugador tiene la racha activa,
podés dejar `retrato_novato_racha.png` con la misma medida.

### 12. `boton_volver.png` — 192 × 192, con alfa

El disco de volver, arriba a la izquierda.

> Disco circular de madera tallada con una flecha apuntando a la izquierda grabada en el centro, estilo ilustración infantil con línea de tinta y acuarela. Madera cálida gastada, borde biselado. Iluminación plana, sin sombras proyectadas. Fondo transparente. Formato cuadrado 192x192 px. Sin texto, sin letras, sin números, sin logos, sin marcas de agua.

### 13. `insignia_logro.png` y `insignia_bloqueada.png` — 512 × 512, con alfa

Las medallas de la galería de logros. **La misma silueta en las dos**: una
dorada y viva, la otra apagada.

> `insignia_logro.png`:

> Medalla circular de bronce dorado con una cinta corta abajo, estilo ilustración infantil con línea de tinta y acuarela. Borde con muescas como una moneda antigua, y un anillo interior liso. El centro está VACÍO y liso, listo para poner un símbolo encima. Dorada, cálida y brillante. Iluminación plana, sin sombras proyectadas. Fondo transparente. Formato cuadrado 512x512 px. Sin texto, sin letras, sin números, sin logos, sin marcas de agua.

> `insignia_bloqueada.png`: el mismo prompt, cambiando "Dorada, cálida y
> brillante" por **"De piedra gris apagada, sin brillo, como una talla sin
> terminar"**. Tiene que ser reconociblemente la misma medalla.

---

## Resumen para pegar en la carpeta

| archivo | medida | alfa |
|---|---|---|
| `marco_pantalla.png` | 1200 × 1800 | sí |
| `cartel_colgante.png` | 1024 × 384 | sí |
| `panel_papel.png` | 600 × 600 | sí |
| `boton_madera.png` | 512 × 200 | sí |
| `boton_dorado.png` | 512 × 200 | sí |
| `placa_nombre.png` | 512 × 160 | sí |
| `marco_retrato.png` | 768 × 900 | sí |
| `barra_inferior.png` | 1200 × 300 | sí |
| `fondo_patio.jpg` | 1536 × 2304 | no |
| `fondo_papel.jpg` | 1024 × 1024 | no |
| `retrato_novato.png` | 768 × 900 | no |
| `boton_volver.png` | 192 × 192 | sí |
| `insignia_logro.png` | 512 × 512 | sí |
| `insignia_bloqueada.png` | 512 × 512 | sí |

**Las medidas son exactas.** Un píxel de más y el estirado queda corrido sin que
nada falle visiblemente — por eso existe el chequeo 14. Si el generador te
entrega otra medida, redimensioná antes de guardar.

**No hagas variantes `@2x` ni `@3x`.** Los cortes del 9-slice se expresan en
píxeles del archivo, así que una variante de otra resolución los corre por un
factor de 2 o 3, en silencio. Un archivo por pieza y listo.

**Peso**: que la carpeta entera quede por debajo de ~4 MB. Los JPG a calidad 85
y los PNG pasados por `pngquant` o `oxipng`.
