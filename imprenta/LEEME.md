# La Imprenta

Reparte las cartas en pliegos listos para guillotina, con sus dorsos alineados.

## Uso

Un solo proceso sirve todo. **Desde la raíz del proyecto**, no desde `app/`:

```bash
node imprenta/servidor.mjs
```

Y abrís `http://127.0.0.1:8123/`. Hay dos puertas: **la imprenta**, que carga
el arte sola, y **el juego**, que necesita `cd app && flutter build web` una
vez. Se corta con `Ctrl+C`. Si el puerto está ocupado, pasale otro:
`node imprenta/servidor.mjs 9000`.

También funciona con doble clic, sin servidor:

```bash
open imprenta/index.html
```

Ahí sí hay que arrastrar la carpeta `print/` a la página: en `file://` el
navegador no deja que la página lea el disco sola.

Antes de cualquiera de las dos, el arte:

```bash
python3 bin/imprimir.py
```

Con los valores por defecto (A4, margen 5 mm, corte compartido) salen **19
hojas**: 7 de frentes + 7 de dorsos, 1 de jefes + 1 de sus dorsos, 1 de tapa,
1 de tablero y 1 de fichas. En A3 son 11.

## Antes de tirar todo el mazo

Cuatro cosas, en orden. La primera es la que arruina tiradas enteras.

1. **Imprimí al 100 %.** Nada de «ajustar a página» ni «fit to printable
   area»: escalan al 96 % sin avisar y no se nota mirando.
2. **Medí la regla** que sale al pie de cada hoja con una regla de verdad. Si
   no da 100 mm, imprimiste con escala y hay que empezar de nuevo.
3. **Probá una hoja** de frentes y una de dorsos antes que el resto. Miralas
   juntas a contraluz: las cruces de las cuatro esquinas tienen que coincidir.
4. **Cortá dos cartas** y medilas: 57 × 89 mm.

## Corte compartido o calle

Por defecto las cartas van **pegadas**: entran más por hoja y cada línea se
corta una sola vez. El costo aparece cuando la guillotina se desvía medio
milímetro — no te deja tu propio sangrado, te deja una tira del dibujo de la
carta vecina, y como son dibujos distintos se ve.

Con **calle de 6 mm** cada carta lleva su sangrado completo por los cuatro
lados, así que el mismo error de corte deja crema propio y no se nota. Entran
menos por hoja y hay que cortar dos veces por lado.

Con guillotina de imprenta, corte compartido. Con guillotina de palanca casera,
probá una hoja de cada una y decidí con la carta en la mano.

## Por qué el dorso no está espejado

Porque no hace falta. El dorso es **uno solo** y se repite en todas las
celdas: invertir el orden de columnas no cambiaría un solo píxel.

Lo que hace que el dorso caiga sobre el frente al dar vuelta la hoja es que la
grilla esté **centrada en horizontal**, y de eso se ocupa `mejorGrilla` — los
márgenes izquierdo y derecho salen exactamente iguales, y hay una prueba que
lo verifica.

Si algún día hay dorsos distintos por mazo, esa suposición se cae y hay que
espejar de verdad. Está anotado en `pliegos.js`.

## Qué hay en cada archivo

| Archivo | Qué hace |
|---|---|
| `index.html` | La página: controles y resumen |
| `app.js` | Carga la carpeta, arma la config, dispara la generación |
| `pdf.js` | Escritor de PDF, sin dependencias |
| `imposicion.js` | Grilla óptima, ventanas de recorte, marcas |
| `pliegos.js` | Arma cada entregable a partir del manifiesto |
| `pruebas.mjs` | 74 verificaciones sin navegador |
| `servidor.mjs` | El servidor. Sirve la herramienta, los librillos y el juego |
| `datos/*.json` | Lo genera `app/bin/export_libro.dart`. No se edita a mano |
| `librillo/index.html` | La página imprimible del reglamento y del cómic |
| `librillo/librillo.js` | Orden de cuadernillo, A5 → A4, creep, modo pila |
| `librillo/paginador.js` | Reparte los bloques en páginas de alto fijo |
| `librillo/referencias.js` | Tokens `{n:…}` y remisiones `{ref:…}` |
| `librillo/contenido_es.js` | La prosa. Sin un solo número escrito a mano |
| `librillo/render.js` | Bloque → HTML. Lo único que toca el DOM |

## Detalles que no son obvios

**Los JPEG no se recomprimen.** Los archivos de `print/` son baseline de 3
componentes, así que sus bytes entran al PDF tal cual como stream
`/DCTDecode`. Por eso el escritor de PDF es propio: cualquier librería que
pase por canvas agregaría una segunda generación de pérdida.

**Los PNG tampoco.** El IDAT de un PNG *es* un stream zlib de scanlines
filtradas, que es justo lo que `/FlateDecode` espera con `/Predictor 15`. Se
copia igual de crudo.

**Cada diseño se embebe una sola vez.** Las ocho copias de Puño Torpe son ocho
referencias al mismo objeto. Por eso los 7 pliegos de dorsos pesan 0,6 MB: es
un dorso reusado 63 veces.

**El recorte se hace con clipping path.** Cada imagen se dibuja completa —con
su sangrado— y una ventana decide cuánto se ve: en el interior de la grilla se
recorta a la caja de corte, en el perímetro se agranda para dejar el sangrado.
Sale gratis en tamaño de archivo porque es una operación vectorial.

**Cada pieza elige su propia orientación de hoja.** El tablero es apaisado y
la grilla de naipes elige vertical: usar la orientación de las cartas lo
achicaría de 270 a 200 mm sin ninguna razón.

**Hay un solo marcador.** `PRODUCCION.md` pedía además una pista de Jefe, para
el daño acumulado en el Enfrentamiento Final — pero esa mecánica no existe en
el motor: cada combate contra un jefe se resuelve de una sola vez, y si perdés
el jefe queda intacto. Lo único que persiste entre combates es la Energía.

**El plegado del tablero no se automatiza.** Para meter 270 mm en los 64 de la
caja hacen falta cinco paneles, o sea un acordeón; y como el tablero tiene
once columnas de círculos, ningún reparto cae limpio entre casillas. Por eso
el selector arranca en «sin plegar» y el aviso dice qué entra y qué no: vale
más guardarlo aparte que doblarlo por la mitad de un número.

## Pruebas

```bash
node imprenta/pruebas.mjs             # veredicto
node imprenta/pruebas.mjs --guardar   # y deja los PDF en imprenta/muestras/
```

Verifican lo que no se ve mirando el PDF en pantalla: que la grilla quede
simétrica, que el conteo de naipes cierre contra el manifiesto, que los
offsets del xref apunten a donde dicen, y que los bytes de las imágenes
lleguen intactos.

## El tablero y las fichas de Energía

Salen del arte de `Assets/Imprimir/`, y `bin/imprimir.py` los normaliza antes
de que la web los vea:

- **La ficha** viene con canal alfa, que para imprimir no sirve —el fondo es el
  papel—, así que se aplana sobre el crema del juego. Después se centra en un
  cuadrado: como se corta redonda, lo que importa es que el disco quede justo
  en el medio, o el círculo de corte le muerde un borde. El crema que sobra es
  el sangrado.
- **El tablero** viene renderizado como una hoja apoyada sobre un fondo gris
  oscuro. Ese gris es del render y no de la pieza: impreso saldría como un
  marco sucio. Se detecta por el color de la esquina y se recorta.

En la web se eligen el ancho del tablero, el plegado, y el diámetro y la
cantidad de fichas. Las fichas van separadas y no pegadas: se cortan redondas,
así que no hay borde compartido que aprovechar y necesitan lugar para la
tijera.

## Los librillos: reglamento y cómic

Se abren en `librillo/?doc=reglamento` y `librillo/?doc=comic`, y **necesitan el
servidor**: con doble clic sobre el archivo no funcionan, porque usan `fetch`
para los datos y `@font-face` para las tipografías, y `file://` bloquea las dos.

**No salen de acá como PDF, y es a propósito.** `pdf.js` sólo embebe las catorce
fuentes base de PDF —nada de Patrick Hand ni de Atkinson— y su tabla de anchos
es aproximada para las letras. Darle tipografía de verdad significa incrustación
TrueType más un motor de párrafos: unas dos mil líneas dentro del archivo más
delicado del repo, el que existe justamente para *no* tocar bytes. Y aun así
saldría sin kerning y con una silabación castellana hecha a mano. El PDF lo hace
el navegador con **Imprimir → Guardar como PDF**.

**Pero el navegador no pagina.** Ahí es donde esta clase de herramienta se rompe:
`orphans`/`widows` lo respeta casi sólo Chrome, `break-inside: avoid` diverge en
cuanto el bloque es alto, y —lo peor— la cantidad de páginas cambia con el
reflow, así que el orden de cuadernillo no se puede calcular. Acá paginamos
nosotros contra un medidor oculto del ancho exacto de la columna, y al navegador
sólo le pedimos cortar entre hojas de alto fijo que llenan la página exacta.

**Los números de página se resuelven en dos pasadas.** La primera dibuja cada
remisión como un hueco de ancho reservado para tres dígitos, con cifras
tabulares; la segunda mete el número real. Como el ancho ya estaba reservado, la
sustitución no puede mover un corte de línea, y el paginador verifica que el
total no cambió.

**El reglamento no tiene números escritos.** `contenido_es.js` escribe
`{n:config.energiaInicial}` y lo resuelve contra `datos/juego_templo_es.json`,
que genera `app/bin/export_libro.dart` desde el motor. Si rebalanceás el juego:

```
cd app && dart run bin/export_libro.dart
```

Las pruebas fallan si el JSON quedó más viejo que `dificultad.dart`,
`reglas_texto.dart` o los textos del cómic.

**Dos armados.** *Cuadernillo* (por defecto) para doblar al medio y abrochar
sobre el pliegue, con compensación de empuje: 28 páginas de 80 g corren las
hojas de adentro unos 3 mm hacia afuera y sin corregirlo el canto queda
escalonado. *Pila* imprime a una sola cara para cortar y apilar: no necesita
dúplex, que es de lo que depende que el cuadernillo salga bien.

**Lo que las pruebas no pueden ver** es la maquetación real del navegador — no
hay headless sin dependencias. Para eso está `librillo/?prueba=1`, que revisa
desbordes dentro de la propia página y muestra un cartel verde o rojo.

## Lo que no cubre

La **tapa sola**, para probar el diseño. Una caja rígida de dos piezas necesita
además el forro completo de 188 × 232 mm con solapas de 15 mm, los cuatro
laterales y el fondo (`PRODUCCION.md` §4). Eso es armado de troquel, y el arte
de los laterales todavía no existe.

Los **modos de Cansancio «Sin descanso» y «Ya venías cansado»** que describe el
reglamento (los dos disparos a la vez, y las diez fatigas barajadas en el mazo
inicial) **no existen en el motor**: son reglas de mesa. Lo mismo con los tres
niveles altos —Vigilia, El Séptimo Día y Shifu—, que viven en
`librillo/contenido_es.js` y no en `modos/dificultad.dart`.

El reglamento los presenta **sin salvedades**, como niveles del juego, porque es
el documento con el que se juega y no un borrador. La contrapartida es que sus
números no pasaron por `bin/sim.dart`: si el balance de esos tres se ajusta
jugando, hay que editarlos a mano en `NIVELES_DE_PAPEL`, y ninguna prueba va a
avisar si quedan desalineados con el motor. Los cuatro niveles de la app sí
salen del JSON exportado y no se pueden desincronizar.
