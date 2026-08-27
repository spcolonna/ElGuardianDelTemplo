# Costos y precios

Todo lo de acá sale de páginas medidas, no estimadas: los números vienen de
`index.html`, que dice cuántas páginas da cada documento en cada densidad.

| Documento | compacto | normal | aire |
|---|---:|---:|---:|
| **Tomo I** (terminado) | 68 | **72** | 80 |
| **Tomo II** (terminado) | 54 | 58 | **66** |
| **Volumen** (hoy: I + II) | 118 | **126** | 142 |
| **Volumen** (los cinco, proyectado) | — | ~350 | — |

> El volumen contiene hoy el **Tomo I y el Tomo II**: los dos pasaron la
> revisión del autor. Los tres que faltan entran igual, uno por uno, a medida
> que la pasen. Con los cinco terminados va a quedar cerca de 350 páginas.

---

## 1. El corte de las 72 páginas

**Amazon no imprime a color por debajo de 72 páginas.**

El **Tomo I** da 72 en densidad normal. Entra, pero **entra justo**: no hay un
solo renglón de margen. Si en una corrección se caen dos páginas, el tomo deja
de poder imprimirse a color. Para venderlo suelto conviene `aire`, que da 80 y
deja ocho páginas de colchón por veinte centavos de dólar.

El **Tomo II** da 66 en `aire` y **suelto sigue sin llegar**. Le faltan seis
páginas, que son unas 900 palabras. La noche del Señor de los Mercenarios sigue
siendo la mitad de larga que la noche del dragón en el Tomo I, y ahí es donde
tiene que crecer: es el clímax del día y es donde está la tentación, que es el
tema del tomo. Eso sale de escribir, no de apretar la maqueta.

Ese corte **no afecta al volumen**: con los dos tomos adentro da 126 páginas en
`normal`, muy por encima del piso. O sea que el Tomo II ya se puede imprimir a
color **dentro del volumen**, aunque todavía no se pueda imprimir solo.

**Los tomos sueltos se maquetan en `aire`. El volumen, en `normal`.**

---

## 2. Amazon

Amazon cobra la impresión como **fijo + por página** y paga el **60 %** del
precio de tapa menos ese costo. Tinta estándar a color, tapa blanda:

- **Amazon.com:** US$ 1,00 + US$ 0,0255 por página
- **Amazon.es / .de / .fr / .it:** € 0,75 + € 0,024 por página

| | Páginas | Impresión | Precio mínimo | **Sugerido** | Te queda |
|---|---:|---:|---:|---:|---:|
| Tomo suelto · EE. UU. | 80 | US$ 3,04 | US$ 5,07 | **US$ 9,99** | US$ 2,95 |
| Tomo suelto · España | 80 | € 2,67 | € 4,45 | **€ 9,99** | € 3,09 |
| Volumen completo · EE. UU. | 350 | US$ 9,93 | US$ 16,55 | **US$ 26,99** | US$ 6,26 |
| Volumen completo · España | 350 | € 9,15 | € 15,25 | **€ 24,99** | € 5,27 |

Tres cosas que conviene tener claras antes de fijar el precio:

**En Europa el precio de tapa incluye IVA y la regalía se calcula sin él.** El
libro paga 4 % en España, así que de € 24,99 Amazon toma € 24,03 como base. Es
la diferencia entre creer que te quedan € 5,84 y que te queden € 5,27.

**Los cuatro tomos pagos suman US$ 39,96 y el volumen completo sale US$ 26,99.**
Eso es a propósito. El tomo suelto es la puerta; el volumen es la compra que
querés que hagan.

**El tomo I gratis no existe en Amazon.** El mínimo que deja poner es US$ 0,99.
Gratis de verdad se consigue de dos maneras: los cinco días de promoción de KDP
Select, o el *price match* (Amazon iguala el precio si el mismo libro está
gratis en otro lado, y a veces tarda semanas). **Lo razonable es que el gancho
gratuito viva fuera de Amazon** —el PDF que vendés/regalás vos— y que en Amazon
el tomo I esté a US$ 0,99.

---

## 3. Kindle — todavía no, y por qué

La edición Kindle necesita su propio pipeline: texto refluido, tapa cuadrada
aparte, y las imágenes comprimidas. Ese último punto es el que puede salir caro
y conviene saberlo desde ahora:

En la franja del 70 % de regalía, Amazon **cobra la entrega del archivo a
US$ 0,15 por megabyte**. Este libro tiene 91 ilustraciones. Sin comprimir pesan
unos 60 MB, y el costo de entrega —US$ 9— se come la regalía entera y sobra.

Hay que bajarlas a unos 140 KB cada una (~13 MB de libro, US$ 1,95 de entrega).
La alternativa es la franja del 35 %, que no cobra entrega: a US$ 9,99 deja
US$ 3,50 contra los US$ 5,04 de la franja del 70 % con las imágenes ya livianas.

---

## 4. Impresión propia y venta directa

Los precios de una imprenta argentina se mueven todos los meses. En vez de
inventar un número que va a estar mal la semana que viene, acá va **la ficha
para pedir presupuesto** y **la regla para convertirlo en precio**.

### La ficha (copiala tal cual en el mail a la imprenta)

> Libro de tapa blanda, **14 × 21,5 cm cerrado**.
>
> - **Interior:** 80 páginas (o 350), **color en todas las páginas**, ilustrado.
>   Papel obra 90 g o similar.
> - **Tapa:** cartulina 300 g, **couché**, impresa a color sólo por fuera,
>   **laminado mate**.
> - **Encuadernación:** fresada (PUR o hot-melt). Para las 80 páginas, cotizar
>   también **abrochado a caballo**, que suele salir bastante menos.
> - **Sangrado** 3 mm en los cuatro lados. Archivos PDF separados: interior y
>   tapa (tapa en una sola pieza, contratapa + lomo + tapa).
> - Cotizar a **50, 100 y 300 ejemplares**.
>
> Consulta: ¿qué grosor por hoja tiene el papel que van a usar? Lo necesito
> para calcular el lomo.

Ese último dato no es un detalle: `tapa.html` calcula el ancho del lomo con
`páginas × grosor`. Si la imprenta usa un papel más grueso que el supuesto, la
tapa sale corrida y no hay forma de arreglarlo después de imprimir. Pasale el
número al parámetro `papel=local` de `tapa.html` o ajustá la constante.

### La regla de precio

| Canal | Cuenta |
|---|---|
| **Venta directa** | costo por ejemplar **× 3** |
| **Mercado Libre** | (costo × 3) **+ 14 % de comisión** + envío |

El × 3 no es codicia: cubre el ejemplar, el que se regala, el que sale mal, y
el trabajo. Con × 2 se empata; con × 2 y un ejemplar arruinado cada veinte, se
pierde.

En Mercado Libre la comisión ronda el 13-14 % según categoría y hay costo de
envío en las publicaciones por encima del umbral de envío gratis. O lo sumás al
precio de lista o lo cobrás aparte, pero no se puede ignorar.

### El embudo que tenías pensado

Funciona, con un ajuste: **el tomo I gratis conviene que sea digital.** Un
cuadernillo impreso regalado cuesta plata cada vez que se regala; un PDF cuesta
una sola vez y se puede mandar mil veces.

```
GRATIS      Tomo I en PDF          → el gancho, sin costo marginal
PAGO        Tomos II a V en PDF    → para el que se copó
PAGO        Volumen completo PDF   → mejor precio que los cuatro sueltos
PAPEL       Tomo I y volumen completo, en Amazon y en venta directa
```

Y una advertencia sobre Mercado Libre: **no está pensado para entregar
archivos.** Se puede publicar un producto digital, pero la entrega la tenés que
resolver vos por fuera (mail, link) y las reclamaciones por «no me llegó» las
maneja una plataforma que asume que hubo un envío físico. Para lo digital,
conviene un canal propio; para Mercado Libre, el libro impreso.

---

## 5. Ancho de lomo, para tener a mano

`tapa.html?doc=…&paginas=N` lo calcula solo, pero por si hace falta el número:

| Páginas | Lomo (papel Amazon, 0,0572 mm/hoja) | ¿Entra el título? |
|---:|---:|---|
| 80 | 4,6 mm | no — va liso |
| 72 | 4,1 mm | no — va liso |
| 126 | 7,2 mm | no — va liso |
| 350 | 20,0 mm | sí, cómodo |

Por debajo de 9 mm el lomo va sin texto: `tapa.html` lo detecta y lo oculta
solo. Amazon directamente rechaza el texto de lomo en libros de menos de 100
páginas.
