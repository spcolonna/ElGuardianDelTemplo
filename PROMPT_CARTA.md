# Prompt para diseñar una carta

Para pegar en ChatGPT (o cualquier generador de imágenes) y ver el diseño de la carta completa.

> ⚠️ **Esto es para MIRAR el diseño, no para imprimir.** Ningún generador escribe texto sin errores ni respeta los píxeles al milímetro. Sirve para decidir estética, jerarquía y proporciones. Cuando el diseño te cierre, la carta final se compone en nanDECK/Figma con los CSV, y al generador solo le pedís las ilustraciones sueltas (esos prompts ya están en los CSV).

---

## PROMPT (copiar desde acá)

```
Diseñá UNA carta de juego de mesa, completa y lista para ver. Imagen vertical de
815 × 1110 px.

ESTILO GENERAL
Juego de mesa de cartas, temática templo shaolin, tono de comedia. NO fotorrealista,
NO 3D, NO estilo videojuego, NO brillos ni degradados metálicos. Ilustración de
caricatura: línea de tinta suelta y gruesa, manchas de acuarela planas, paleta cálida
apagada, textura de papel crema. Diseño limpio, plano y legible, estilo de juego de
mesa moderno impreso. El protagonista es un monje novato flaco y torpe, y el juego se
ríe de él.

PALETA EXACTA
- Fondo de la carta: #F4EFE6 (papel hueso)
- Tinta y números: #1A1A1F
- Rojo Ocaso (banda superior): #C85450
- Azul técnica (banda inferior): #6FA8DC
- Amarillo del ícono de energía: #D9A21B

ESTRUCTURA: LA CARTA ESTÁ PARTIDA AL MEDIO
Una línea negra horizontal gruesa (12 px) cruza la carta entera exactamente en
y = 555, con un pequeño círculo negro sobre ella en el centro. Divide la carta en dos
mitades iguales de 520 px.
La MITAD DE ARRIBA se lee normal. La MITAD DE ABAJO está impresa ROTADA 180 GRADOS
(al revés): su texto y sus números se leen recién cuando girás la carta media vuelta.
Esto es a propósito y tiene que verse claramente en la imagen.

MITAD SUPERIOR — EL PELIGRO (y 35 a 555)
- y 35–87: banda horizontal roja #C85450 de lado a lado, con la palabra "OCASO" en
  mayúsculas, centrada, blanca, con mucho espaciado entre letras.
- y 87–163: fila de números.
  · A la IZQUIERDA, en la esquina: un círculo de 88 px de diámetro con borde rojo
    grueso y fondo hueso, con el número "8" adentro, negro y muy grande. Es el número
    más importante de la mitad.
  · A la DERECHA: un ícono de corazón roto rojo seguido del número "3", y al lado un
    ícono de dos cartas de naipe superpuestas seguido del número "4". Números grandes
    y negros.
- y 163–238: el nombre "Prueba del Gran Maestro" centrado, en serif negra con carácter,
  y debajo "(en sueños)" más chico y en cursiva gris.
- y 238–503: un recuadro cuadrado de 265 × 265 px centrado horizontalmente, con la
  ILUSTRACIÓN del peligro: una visión onírica de un viejo gran maestro flotando entre
  niebla arremolinada, ojos brillando en blanco, imponente pero un poco absurdo.
  Un solo sujeto, centrado y grande, fondo simple.

MITAD INFERIOR — LA TÉCNICA (y 555 a 1075, TODO ROTADO 180°)
Leída con la carta dada vuelta, de su borde hacia el centro:
- banda horizontal azul #6FA8DC de lado a lado con la palabra "TÉCNICA" en mayúsculas
  espaciadas, en azul muy oscuro.
- fila de números: a la izquierda un círculo de 88 px con borde azul y el número "5"
  negro y grande. A la derecha "+2" seguido del ícono de dos cartas, y "+1" seguido de
  un ícono de rayo amarillo.
- el nombre "Iluminación" centrado, en la misma serif, negra y grande.
- un recuadro cuadrado de 265 × 265 px centrado con la ILUSTRACIÓN de la técnica: el
  mismo monje novato despertándose empapado en sudor, con un halo de luz suave detrás
  de la cabeza, entre aliviado y confundido.
- al final, el texto de sabor:
  "Te despertaste empapado. Pero iluminado."

TIPOGRAFÍA — los cuerpos son obligatorios, no sugerencias
- Nombre de carta: 12 pt (50 px a 300 dpi), versalitas, hecho a mano tipo
  Patrick Hand SC.
- Texto de efecto (la regla del juego): 8,5 pt (35 px), sans muy legible en
  negrita, tipo Atkinson Hyperlegible Bold.
- Texto de sabor: 7,5 pt (31 px). NO en gris claro y NO "chica": marrón tinta
  #4A3728 sobre crema.
- Número de Poder: 28 pt (117 px) dentro del medallón.
- Daño y cartas gratis: 15 pt (62 px).
- Nombre de fase: 8 pt (33 px).

NADA POR DEBAJO DE 7 PT. La primera tirada impresa tenía el texto de sabor a
unos 5 pt y no se leía sentado a la mesa. Si un texto no entra a 7 pt, se
acorta el texto, no el cuerpo.

El bloque de texto ocupa 15 mm de los 44,5 de cada mitad —el 34 %— y va sobre
un velo crema al 88 % con el borde de arriba difuminado, para que la
ilustración se siga viendo por debajo. Nunca sobre una banda opaca.

Sin emoji: los efectos van escritos ("Roba 2 · +1 Energía"), no con 🃏 ni ⚡.

REGLAS DE COMPOSICIÓN
- Todo el contenido dentro de un margen de 47 px respecto del borde de la carta.
- Esquinas redondeadas.
- Los dos círculos de número van en la esquina EXTERIOR de su mitad (arriba a la
  izquierda de cada mitad, según cómo se lee esa mitad).
- Fondo plano color papel: sin texturas ruidosas, sin marcos ornamentados recargados,
  sin bordes dorados.
- NO agregues ningún texto que yo no haya pedido: ni reglas, ni descripciones, ni
  logos, ni números de carta, ni marcas de agua.
```

---

## Datos de esta carta (fila real del CSV)

De `csv/cartas_peligro_tecnica.csv`, la carta más completa que hay: es la única con dos efectos en la técnica más texto de sabor.

| Columna | Valor |
|---|---|
| `mazo` | Ocaso |
| `color_banda_hex` | `#C85450` |
| `peligro_nombre` | Prueba del Gran Maestro (en sueños) |
| `peligro_poder` | 8 |
| `peligro_dano` | 3 |
| `peligro_cartas_gratis` | 4 |
| `tecnica_nombre` | Iluminación |
| `tecnica_poder` | 5 |
| `tecnica_efecto` | +2 🃏 · +1 ⚡ |
| `tecnica_texto_sabor` | "Te despertaste empapado. Pero iluminado." |
| `arte_px` | 265 |

---

## Mapa de zonas (para maquetar de verdad)

Medidas verificadas sobre `mockup_carta.svg`. Carta 815 × 1110 px con sangrado; corte 744 × 1039; zona segura 651 × 946 (margen de 47 px desde el corte).

### Mitad de peligro — y 35 → 555

| Zona | y | Alto | Contenido |
|---|---|---|---|
| A | 35–87 | 52 | Banda de fase, color del mazo, nombre del mazo centrado |
| B | 87–163 | 76 | Poder (círculo Ø88 a la izquierda) · Daño 💔 y Cartas gratis 🃏 a la derecha |
| C | 163–238 | 75 | Nombre del peligro (hasta 2 líneas) |
| D | 238–503 | 265 | Ilustración 265 × 265, centrada en x = 407 |
| — | 503–555 | 52 | Aire antes del divisor |

### Divisor — y 549 → 561

Barra negra de 12 px de lado a lado + círculo central Ø56. **Es el elemento más importante de la carta:** es lo único que evita que el jugador sume el número equivocado. Va por encima de todo lo demás.

### Mitad de técnica — y 555 → 1075, rotada 180° sobre el punto (407.5, 815)

| Zona | y | Alto | Contenido |
|---|---|---|---|
| E | 555–607 | 52 | Texto de sabor (queda contra el borde inferior de la carta) |
| D | 607–872 | 265 | Ilustración 265 × 265 |
| C | 872–930 | 58 | Nombre de la técnica |
| B | 930–1023 | 93 | Poder (círculo Ø88) · efectos a la derecha |
| A | 1023–1075 | 52 | Banda azul "TÉCNICA" |

**Truco de maquetado:** dibujá la mitad de técnica derecha y al final aplicale `rotate(180)` sobre el centro de su propia mitad. Nunca la posiciones a ojo.

---

## Qué mirar cuando salga la imagen

1. **¿Se distingue de un vistazo dónde termina una mitad y empieza la otra?** Si dudás, engrosá el divisor o cambiá el fondo de una mitad.
2. **¿Los dos números grandes se ven sin buscarlos?** Son lo que el jugador lee cincuenta veces por partida.
3. **¿Los tres íconos (💔 🃏 ⚡) se distinguen entre sí a ese tamaño?** Si no, hay que rediseñarlos antes de dibujar las 70 ilustraciones.
4. **¿La ilustración de 265 px alcanza para que se entienda el chiste?** Si no, hay que simplificar los sujetos de `app/lib/arte.dart`.
