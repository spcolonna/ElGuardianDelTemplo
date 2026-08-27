# El Guardián del Templo — Biblia del cuento

Documento de referencia para los cinco tomos. Acá viven las decisiones; en los tomos, la historia.

> **Esto es paralelo al juego.** El cuento no modifica una sola línea del motor, las cartas, la
> Imprenta, los librillos ni el cómic de la caja. Lee el arte y los datos; no escribe nada.
> Las divergencias con el juego están listadas al final y son deliberadas.

---

## 1. Qué es esto

Un cuento en cinco tomos sobre un chico de dieciséis años que se queda solo a cargo de un templo
durante cinco días, y sobre todas las veces que estuvo a punto de irse.

Es gracioso. Los enemigos son un mosquito engreído, una tetera volcada y un dragón de papel maché.
También es hondo, y las dos cosas no se contradicen: **lo ridículo es la puerta, no el chiste.**
Así funciona el kung fu — repetís mil veces un movimiento estúpido hasta que un día te salva.

Lo que sostiene a Guang no es el talento, ni la fe, ni una profecía. Es la terquedad.

---

## 2. El elenco

### Guang Lu — "Guang"
Dieciséis años. Flaco, desgarbado, la túnica naranja le queda holgada, pantalón corto oscuro,
sandalias, el pelo parado y las orejas grandes. Barre los ciento ocho escalones todas las mañanas
y todas las mañanas se vuelven a ensuciar.

No es el elegido. Nadie le dijo nunca que fuera especial, y él tampoco se lo cree. Empieza el tomo I
sin saber cerrar bien el puño. Su virtud no es el coraje: es que no se le ocurre irse hasta que ya
es tarde para irse.

*Arte:* `Assets/UI/character.png` · `Assets/Main.jpeg` · `Assets/MazoInicial/1.jpeg`

> El nombre se usa desde la primera página. En orden chino sería Lu Guang —el apellido va primero—
> pero el cuento lo escribe al modo occidental porque suena mejor dicho en voz alta.

### Shifu
Viejo, bajo, cejas enormes. Su superpoder es la desaprobación silenciosa. Se va en el prólogo y
vuelve al final del tomo V. Está ausente los cinco tomos y presente en todos: cada cosa que Guang
hace, la hace calculando qué diría Shifu.

Contó las galletas.

*Arte:* `Assets/shifu.jpeg`

### Mei
La gata guardiana. Naranja, gorda, vive en las tejas, juzga todo. Es el mejor luchador del templo y
lo sabe. Cuatro registros: desprecio total, desprecio con los ojos cerrados, **terror con el pelo
parado**, y satisfacción petulante.

Mei no habla. Mei mira. La única vez que se asusta de verdad es un acontecimiento, y hay que
guardarla para cuando importe.

*Arte:* `Assets/mei.jpeg`

### Tao
El compañero de entrenamiento. Más canchero que Guang, mejor que Guang, y consciente de las dos
cosas. Coleta despeinada, caña de azúcar en la boca, faja verde, bastón al hombro.

Su arco está dibujado en su propia hoja de modelo, en este orden:

| Tomo | Registro | Qué pasa |
|---|---|---|
| II | **Se burla** | Está ahí todo el día haciendo comentarios. Le duele más que los golpes. |
| III | **Advierte en serio** | Por una vez baja la caña de azúcar y dice algo verdadero. |
| IV | **Se vende** | Los mercenarios pagan. Se va. |
| IV | **Culpable al irse** | No mira atrás, y por eso sabemos que le importa. |
| V | **Vuelve** | Y Guang lo perdona, que es más difícil que pegarle. |

*Arte:* `Assets/kai.jpeg` (la hoja dice KAI; el personaje se llama Tao)

### Pinto
Buhonero. Flaco, sonrisa enorme, el abrigo forrado de espadas de juguete de madera pintadas de
colores. Le vende basura a todos los bandidos de la montaña y les jura que es acero de Damasco.

Aparece cuando el cuento necesita respirar. Nunca pelea. Siempre sabe algo.

*Arte:* `Assets/vendedor.jpeg`

---

## 3. Los cinco Campeones

Vienen en orden ascendente de poder, y ese orden es el del cuento. Cada uno **quiere el templo por
una razón propia**, y cada uno le muestra a Guang una parte de sí mismo que no había visto.

| # | Campeón | Poder · Daño | Por qué quiere el templo | Qué le revela a Guang |
|---|---|---|---|---|
| I | **El Dragón de Papel** | 16 · 6 | Es una compañía de teatro ambulante que cobra protección. Necesitan el templo de galpón. | Que el miedo siempre es más grande que el monstruo. Y que él también parece poco. |
| II | **El Señor de los Mercenarios** | 18 · 5 | Negocio. Es el punto más alto de la montaña: sede ideal. | Que hay cosas que se compran y una que no. |
| III | **El Monje Caído** | 20 · 5 | Fue el alumno estrella. Cree que el templo le corresponde. | Que no ser el elegido no es lo mismo que no servir. |
| IV | **Tu Propio Reflejo** | 22 · 4 | No quiere el templo. Quiere que Guang lo suelte. | Que la voz que le dice que abandone tiene razón, y aun así. |
| V | **El Gran Maestro del Loto Negro** | 24 · 4 | Absorber el Loto Torcido como sede del Torneo. No viene a pelear: viene a ofrecerle un puesto. | Cuánto vale el templo, que no es lo mismo que cuánto cuesta. |

Fijate el daño: **baja** mientras el poder sube. El primero es un bruto que asusta y pega fuerte
pero está hueco. El último casi no necesita lastimarte.

*Arte:* `Assets/Jefes/jefe5.jpeg` (Dragón de Papel), `jefe3.jpeg` (Mercenarios), `jefe1.jpeg`
(Monje Caído), `jefe2.jpeg` (Reflejo), `jefe4.jpeg` (Loto Negro).

---

## 4. La estructura

**Shifu se va cinco días. Un Campeón por día. Cada día es un tomo.**
Cada tomo tiene Alba, Mediodía, Ocaso y Noche. El Alba/Mediodía/Ocaso del juego se usa como métrica
del relato, cinco veces.

El reparto sale exacto, y ésa es la señal de que la estructura es la correcta:

| | Cuánto hay | Por tomo |
|---|---:|---|
| Peligros (con su técnica) | 30 | **6** — 2 del Alba, 2 del Mediodía, 2 del Ocaso |
| Campeones | 5 | **1**, cada noche |
| Cansancio | 10 | **0 · 1 · 2 · 3 · 4** — la fatiga se acumula |
| Mazo inicial | 5 | los cinco en el prólogo |

Las diez fatigas suman exactamente 0+1+2+3+4. El cuerpo de Guang se rompe al mismo ritmo que sube
la dificultad.

---

## 5. Las cuatro reglas del relato

**1 · La regla del eco.** Toda técnica que Guang aprende **se usa después, nombrada**. Ninguna se
aprende para nada. El Campeón de cada noche cae con técnicas de ese mismo día. Es la regla que hace
que las cartas se sientan una historia y no un catálogo.

**2 · El absurdo es la puerta.** La araña en el tazón, Mei sentada justo donde hay que barrer, las
galletas de la alacena. Lo ridículo entra primero y deja algo hondo al salir. Nunca al revés: no se
pone un chiste encima de una escena seria para aliviarla.

**3 · La duda escala.** En cada tomo Guang considera abandonar, y **cada vez la razón es mejor**.
En el I es pereza. En el V es sensatez pura, y le ofrecen una salida buena. Que se quede tiene que
costar más cada vez.

**4 · Ninguna carta se usa dos veces.** Las 30 están repartidas y verificadas.

### Alcance de cada escena
No todas las cartas pesan igual. Las que mueven la trama o entregan una técnica que se usa después
son **escena completa** con diálogo e introspección. El resto entra en **montaje**: un párrafo, un
remate, sigue. Todas aparecen; no todas ocupan lo mismo.

---

## 6. Formato de escena

```markdown
### La araña en el tazón de arroz
**Peligro** `Assets/Peligros/9.jpeg` — Araña en el Tazón de Arroz
**Técnica** `Assets/Skills/9.jpeg` — Reflejo
**Escenario** `Assets/UI/patio.jpeg`

Prosa corrida, con la introspección adentro.

> **GUANG** — El diálogo va acá.
> **MEI** — *(desprecio total)*
```

Las escenas **no llevan número** y las etiquetas **no llevan estadísticas**. Nada de
`(poder 1 · daño 1)`: eso es del juego y el libro no lo dice en ninguna parte.

Las tres líneas de `**Peligro**` / `**Técnica**` / `**Escenario**` son **andamiaje de
producción**. Dicen de dónde sale el arte de esa escena y mueren en el parser: en la página
impresa la ilustración entra sola, sin epígrafe, como en cualquier libro para chicos.

**Convención de arte.** `Assets/Peligros/N.jpeg` y `Assets/Skills/N.jpeg` corresponden a la fila N
del CSV (verificado). Escenarios disponibles: `Assets/UI/patio.jpeg`, `Assets/UI/escalera.jpeg`,
`Assets/UI/background.jpeg`. Fatigas: `Assets/Cansancio/N.jpeg`. Mazo inicial:
`Assets/MazoInicial/1..5.jpeg`, en el orden del CSV.

> **Las hojas de personaje no son ilustraciones.** `mei.jpeg`, `kai.jpeg`, `shifu.jpeg`,
> `vendedor.jpeg` y `Main.jpeg` son fichas de producción, con varias poses y rótulos en inglés.
> No pueden entrar al libro enteras. `cuento/libro/preparar_arte.py` recorta cada pose por
> separado y las deja en `cuento/libro/img/` como viñetas de 25 a 50 mm.

---

## 6 bis. Las reglas de la prosa

Salieron de las correcciones de lectura y valen para los cinco tomos.

1. **Ninguna palabra del juego en el cuerpo.** Nada de mazo de cartas, carta de peligro,
   poder, daño, Energía, robar, copias. Quien lea esto no sabe que existe un juego, y no se
   tiene que enterar. (Un mazo de madera para tocar la campana sí: es un mazo de verdad.)
2. **El narrador no le habla al lector ni le anticipa lo que va a pasar.** El lugar se
   describe cuando la escena llega, no antes «para que lo conozcas». En *Harry Potter* nadie
   dice «esto es Hogwarts, acá le van a pasar cosas»: se descubre narrando.
3. **Nada de contar el tiempo con números.** «Un rato después», «al poco tiempo», «el sol no
   se había movido tanto cuando». Los minutos y las horas obligan al lector a llevar la
   cuenta. Lo mismo con las distancias.
   Excepciones ganadas: la campana de las cuatro y media (es un motivo que abre el libro y
   cierra el tomo V), los segundos que funcionan como golpe cómico, y el centímetro del
   mosquito.
4. **Guang no sabe lo que no puede saber.** Ningún personaje anuncia cuántos Campeones hay ni
   en qué orden vienen. La información está repartida y nadie tiene el cuadro completo.
5. **El Reflejo no es un jefe más débil.** No entra en ninguna escalera de fuerza y no se lo
   presenta como a los otros.
6. **Cada tomo tiene su mañana y su noche completas.** No se corta seco entre el último
   peligro del ocaso y la llegada del Campeón: el cansancio se acumula y se narra.

---

## 6 ter. Las reglas de la maqueta

El libro impreso se arma en `cuento/libro/` — ver su `README.md`. Lo que importa acá:

- **Formato 5,5 × 8,5 pulgadas.** Se eligió por el arte: la caja de texto mide 104,7 mm y una
  ilustración de 1200 px entra a ancho completo a 291 dpi, sin ampliar un píxel.
- **Una ilustración aparece una sola vez en todo el volumen.** El parser deduplica.
- **La dirección de arte vive en `cuento/libro/maqueta.json`, no en el markdown.** Los `.md`
  son prosa y nada más, para poder seguir corrigiéndolos sin pensar en páginas.
- **Las imágenes apaisadas no se recortan a página entera.** Conservan su proporción y cruzan
  la página como banda. Recortarlas a `cover` en una página vertical las baja a 88 dpi.
- **Dos ediciones, la misma maqueta:** los tomos sueltos en densidad `aire` (Amazon no imprime
  a color por debajo de 72 páginas) y el volumen en `normal`.

### Las tres reglas que salieron de armar el Tomo I

Se aprendieron acomodando el Tomo I a mano, imagen por imagen, después de que la primera versión
automática saliera mal. Valen para los cinco.

1. **La imagen entra donde el texto acaba de nombrar lo que la imagen muestra.** No a un tercio de
   la sección, no «repartidas parejo»: después de esa frase. En `maqueta.json` eso se escribe
   `"tras": "fragmento del párrafo"`. Repartir por porcentaje es lo que puso dibujos en el medio
   de las conversaciones.
2. **Ninguna figura corta un diálogo.** Una tanda hablada se lee de un tirón. Una viñeta chica al
   margen sí puede quedarse adentro, porque el texto la rodea y no interrumpe.
3. **El cansancio se gana con el texto.** Una imagen de `Assets/Cansancio/` sólo entra si el
   párrafo anterior nombró la lesión — la ampolla, el hombro dormido, el nudillo partido. Sin eso
   no se entiende y además contradice el cierre del tomo, que declara cuántas fatigas lleva
   acumuladas. **El Tomo I no lleva ninguna**, y por eso las que se le habían puesto se sacaron
   todas.

### La tapa es la de la caja

El arte de tapa de todos los libros —tomos sueltos y volumen— es
`Assets/Imprimir/TapaCajaConLogo.png`, el mismo de la caja del juego de mesa. El
libro y el juego se tienen que reconocer a primera vista. El volumen no lleva
número de tomo en la faja: lleva la bajada **«Espíritu de sacrificio»**.

### Los tomos terminados se congelan

Un tomo revisado a mano se guarda en `cuento/libro/final/` y el parser deja de regenerarlo: avisa
`CONGELADO` y sigue. `cuento/libro/datos/` es borrador y se pisa en cada corrida. El volumen se
arma leyendo de `final/`, así que hereda el acomodado a mano en vez de rehacerlo.

---

## 7. El mapa: las 30 cartas, tomo por tomo

Cada peligro y su técnica son **la misma escena**: lo enfrentás, lo aprendés.

### Tomo I — El Dragón de Papel

| Fase | # | Peligro | P·D | Técnica | Poder | Efecto |
|---|--:|---|:--:|---|:--:|---|
| Alba | 1 | Mosquito del Templo | 1·1 | **Garra Inicial** | 2 | — |
| Alba | 3 | Jarra de Té Volcada | 1·1 | **Equilibrio** | 1 | +1 🃏 |
| Mediodía | 12 | Mercenario con Espada de Juguete | 3·2 | **Ala de Grulla** | 2 | +1 ⚡ si ganás |
| Mediodía | 18 | Puente Colgante Roto | 3·3 | **Vuelo del Bambú** | 4 | −1 ⚡ |
| Ocaso | 22 | Asesino Silencioso | 7·3 | **Vuelo de Grulla** | 4 | +2 ⚡ si ganás |
| Ocaso | 28 | Incendio en la Cocina del Templo | 6·4 | **Agua Sagrada** | 5 | +2 ⚡ |

**Fatiga:** ninguna. Todavía es un chico entero.

### Tomo II — El Señor de los Mercenarios

| Fase | # | Peligro | P·D | Técnica | Poder | Efecto |
|---|--:|---|:--:|---|:--:|---|
| Alba | 2 | Bandido con Palo Podrido | 2·1 | **Puño del Bambú** | 2 | +1 ⚡ si ganás |
| Alba | 6 | Compañero Burlón | 2·1 | **Mirada Fija** | 1 | +2 🃏 |
| Mediodía | 11 | Tres Bandidos Hambrientos | 4·2 | **Puño del Tigre** | 4 | −1 ⚡ |
| Mediodía | 15 | Soldado del Gobernador Corrupto | 5·2 | **Zancada de Leopardo** | 3 | +1 🃏 |
| Ocaso | 21 | Líder de los Bandidos | 6·3 | **Rugido del Tigre** | 5 | −2 ⚡ |
| Ocaso | 26 | Ejército de Mercenarios | 9·4 | **Patada del Tigre** | 6 | −2 ⚡ |

**Fatiga (1):** Ampolla `Assets/Cansancio/5.jpeg`

### Tomo III — El Monje Caído

| Fase | # | Peligro | P·D | Técnica | Poder | Efecto |
|---|--:|---|:--:|---|:--:|---|
| Alba | 5 | Gato Guardián del Templo | 1·1 | **Rascada Felina** | 2 | — |
| Alba | 7 | Piedra en el Zapato | 1·1 | **Paso Firme** | 2 | — |
| Mediodía | 16 | Tentación de la Alacena | 3·2 | **Disciplina** | 2 | +2 ⚡ |
| Mediodía | 17 | Maestro Falso de la Calle | 4·2 | **Escama de Dragón** | 3 | +1 🃏 · +1 ⚡ |
| Ocaso | 23 | Demonio del Orgullo | 6·3 | **Humildad** | 4 | — |
| Ocaso | 30 | Prueba del Gran Maestro (en sueños) | 8·3 | **Iluminación** | 5 | +2 🃏 · +1 ⚡ |

**Fatiga (2):** Hombro Dormido `Assets/Cansancio/4.jpeg` · Nudillo Partido `Assets/Cansancio/6.jpeg`

**Deuda del Tomo II:** Guang cortó el puente, así que los bandidos subieron por
el barranco —eso el Tomo II ya lo contesta—, **pero nunca preguntó por qué Tao
subió por ahí ni por qué Tao no le dijo que el puente no estaba**. Queda
planteado a propósito, con el humo en forma de signo de interrogación, y se
paga acá. La respuesta tiene que decir algo sobre Tao.

### Tomo IV — Tu Propio Reflejo

| Fase | # | Peligro | P·D | Técnica | Poder | Efecto |
|---|--:|---|:--:|---|:--:|---|
| Alba | 4 | Siesta Tentadora | 2·2 | **Despertar Brusco** | 3 | −1 ⚡ |
| Alba | 9 | Araña en el Tazón de Arroz | 1·1 | **Reflejo** | 1 | +1 ⚡ |
| Mediodía | 13 | Duda: "¿Sirve esto?" | 3·2 | **Fe Renovada** | 3 | — |
| Mediodía | 19 | Compañero Traidor | 4·2 | **Lealtad** | 3 | — |
| Ocaso | 24 | Demonio de la Pereza | 5·4 | **Determinación** | 5 | −1 ⚡ |
| Ocaso | 27 | Demonio de la Ira | 7·4 | **Serenidad** | 4 | +3 ⚡ |

**Fatiga (3):** Piernas de Trapo `Assets/Cansancio/3.jpeg` · Calambre `Assets/Cansancio/7.jpeg` · Ganas de Renunciar `Assets/Cansancio/10.jpeg`

### Tomo V — El Gran Maestro del Loto Negro

| Fase | # | Peligro | P·D | Técnica | Poder | Efecto |
|---|--:|---|:--:|---|:--:|---|
| Alba | 8 | Soga de Saltar Rota | 2·2 | **Salto del Novato** | 3 | — |
| Alba | 10 | Viento Frío de la Mañana | 2·1 | **Resistencia** | 2 | — |
| Mediodía | 14 | Ira Incontrolable | 4·3 | **Colmillo de Serpiente** | 3 | −1 👊 al peligro |
| Mediodía | 20 | Tormenta de Arena Repentina | 5·3 | **Resistencia del Desierto** | 4 | — |
| Ocaso | 25 | Maestro del Templo Rival | 8·3 | **Puño del Dragón** | 5 | +1 🃏 · +2 ⚡ |
| Ocaso | 29 | Traición del Discípulo Favorito | 7·3 | **Perdón** | 4 | — |

**Fatiga (4):** Bostezo `Assets/Cansancio/1.jpeg` · Vista Nublada `Assets/Cansancio/2.jpeg` · Zumbido en el Oído `Assets/Cansancio/8.jpeg` · Espalda Vieja `Assets/Cansancio/9.jpeg`

---

## 8. Verificación del reparto

- Peligros usados: **30** · distintos: **30** · sin huecos ni repetidos ✅
- Tomo I: 6 peligros (2 Alba · 2 Mediodía · 2 Ocaso), 0 fatiga(s)
- Tomo II: 6 peligros (2 Alba · 2 Mediodía · 2 Ocaso), 1 fatiga(s)
- Tomo III: 6 peligros (2 Alba · 2 Mediodía · 2 Ocaso), 2 fatiga(s)
- Tomo IV: 6 peligros (2 Alba · 2 Mediodía · 2 Ocaso), 3 fatiga(s)
- Tomo V: 6 peligros (2 Alba · 2 Mediodía · 2 Ocaso), 4 fatiga(s)
- Fatigas usadas: **10** · distintas: **10** · sin huecos ni repetidos ✅

Comprobado por script contra el CSV, no a mano.

---

## 9. Divergencias con el juego, declaradas

El cuento y el juego son dos obras sobre el mismo mundo. **Ninguna corrige a la otra.**

| | El juego (queda así) | El cuento |
|---|---|---|
| Ausencia de Shifu | siete días | **cinco días**, uno por Campeón |
| El protagonista | "el Novato", sin nombre | **Guang Lu**, "Guang" |
| Los Campeones | todos la misma noche | **uno por noche**, con motivo propio |
| Tao al irse | sin remordimiento | **culpable**, y vuelve en el tomo V |
| Pinto | no existe | buhonero recurrente |
| Sabores vacíos | Puño del Bambú, Colmillo de Serpiente y Puño Torpe siguen sin texto | los tres tienen escena |

El cómic de la caja —un día, con páginas de ALTO, para leer mientras jugás— y este cuento de cinco
tomos son piezas separadas con propósitos separados.

---

## 10. Las tres cartas sin texto

El juego tiene tres cartas con el sabor vacío. El cuento les da una escena, que es mejor que una
línea suelta:

| Carta | Tomo | Dónde |
|---|---|---|
| **Puño Torpe** (mazo inicial, 8 copias) | Prólogo | Es lo único que Guang sabe hacer el día 1. Ocho veces lo mismo. |
| **Puño del Bambú** (de Bandido con Palo Podrido) | II | La primera técnica que aprende de un enemigo que quiso lastimarlo en serio. |
| **Colmillo de Serpiente** (de Ira Incontrolable) | V | Lo aprende enojado, y por eso le sale. Es la única técnica que le da vergüenza. |
