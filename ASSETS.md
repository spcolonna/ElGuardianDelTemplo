# 🎨 ASSETS — El Guardián del Templo

## Cómo se usa este documento

El orden importa. **No se empieza por las viñetas.**

1. **Fichas primero** (secciones 2, 3 y 4). Cada personaje, escenario y objeto se diseña **una sola vez, aislado, sobre fondo neutro**. Esa imagen es la ficha, y es la única fuente de verdad de cómo se ve esa cosa.
2. **Escenas después** (sección 6). Cada viñeta se genera **pasando las fichas como referencia de imagen** y describiendo sólo la puesta en escena: quién está, qué hace, desde dónde se mira y con qué luz.

El motivo es concreto: si en cada viñeta volvés a describir el templo con palabras, vas a obtener veintitrés templos distintos. Si describís el templo una vez y después lo pasás como referencia, es siempre el mismo templo.

Por eso los prompts de escena de la sección 6 **no vuelven a describir a los personajes**: los nombran por su ID. Toda la descripción vive en la ficha.

> Ojo: esto es para el **cómic**. El arte de las cartas (sección 8) es otro trabajo, con prompts propios que ya están en `csv/templo/es/`.

---

## 1. Especificaciones técnicas

| Ítem | Valor |
|---|---|
| **Formato** | PNG (o WebP) |
| **Fichas de personaje/objeto** | 1024 × 1024 px, fondo neutro plano, sin sombra proyectada |
| **Fichas de escenario** | 1920 × 1080 px |
| **Viñetas de cómic** | 1920 × 1080 px (16:9 exacto — la app recorta con `BoxFit.cover`) |
| **Peso máximo por viñeta** | 400 KB |
| **Texto dentro de la imagen** | **Ninguno.** Los diálogos y la narración los pone la app, para poder editarlos y traducirlos sin volver a dibujar |
| **Zona segura** | Dejar el 10% inferior sin información crítica |
| **Dónde van** | `app/assets/comic/` con el nombre exacto de la sección 6 |

### Paleta

| Uso | Hex |
|---|---|
| Alba | `#7BC67E` |
| Mediodía | `#E0B14A` |
| Ocaso | `#C85450` |
| Jefes / noche | `#9B6BD6` |
| Cartas de combate | `#6FA8DC` |
| Acento templo | `#D97B29` |
| Tinta | `#1A1A1F` |
| Papel | `#F4EFE6` |

### Estilo (va en todos los prompts)

```
cartoon illustration, loose ink linework with flat watercolor washes, warm muted
palette, cream paper texture, expressive and slightly comedic, shaolin temple
setting, no realistic rendering, no 3d, no glossy highlights
--no text, letters, watermark, logo, signature
```

Caricatura, línea gruesa, humor físico. El protagonista es torpe y el juego se ríe de él todo el tiempo: el arte tiene que sostener eso.

---

## 2. Catálogo de personajes

Cada ficha se entrega como **hoja de modelo**: el personaje de frente, de perfil y de espaldas, más una fila de expresiones. Sobre fondo neutro, sin escena.

---

### PER-01 · El Novato — protagonista
**Archivo:** `ficha_per01_novato.png` · **Aparece en 17 de 23 viñetas**

Flaco y desgarbado, 16 años, orejas grandes, pelo corto y desprolijo. Túnica de lino gastado color hueso que le queda holgada, pantalón corto atado con cordel, **cinturón blanco mal atado** (siempre torcido: es su marca). Sandalias de tela. Manos y pies grandes para su cuerpo.

**Expresiones necesarias:** confusión, pánico contenido, determinación cansada, culpa (galletas), orgullo tímido.

> **Su desgaste es la historia.** Ver sección 5: hacen falta cuatro versiones de la ficha, una por estado.

```
character model sheet of a scrawny clumsy teenage shaolin novice monk, big ears,
messy short hair, loose cream linen tunic too big for him, short trousers tied
with a cord, white belt tied crooked, cloth sandals, oversized hands and feet,
front view side view and back view in a row, plus a row of facial expressions:
confused, panicked, tired but determined, guilty, shyly proud,
neutral flat background, [ESTILO]
```

---

### PER-02 · Maestro Shifu
**Archivo:** `ficha_per02_shifu.png` · **Viñetas:** 02, 41, 51, 52

Viejo y bajo, apenas le llega al pecho al Novato. Barba fina y muy larga, **cejas enormes y blancas** que le tapan los ojos. Túnica ocre bien puesta. Su superpoder es la desaprobación silenciosa: **la cara casi no cambia nunca**, y eso es el chiste.

**Expresiones necesarias:** neutra (la que más se usa), casi-orgullo, decepción sin gesto.
**Siempre con:** OBJ-04 (bolso y sombrero) cuando entra o sale.

```
character model sheet of a very old very short shaolin grandmaster, thin extremely
long white beard, enormous bushy white eyebrows covering his eyes, neat ochre
robe, calm unreadable face, front side and back view, plus expressions: neutral,
faint approval, silent disappointment, neutral flat background, [ESTILO]
```

---

### PER-03 · Mei, la gata guardiana
**Archivo:** `ficha_per03_mei.png` · **Viñetas:** 02, 11, 31, 40, 42

Gata gorda y atigrada naranja, **una oreja mordida**, cara redonda. Vive en las tejas. Juzga. Es el mejor luchador del templo y todos lo saben menos ella, que ya lo sabe.

**Expresiones necesarias:** desprecio absoluto, desprecio con los ojos cerrados, erizada de miedo (una sola vez, viñeta 31), satisfacción.
**También es la carta** *Gato Guardián del Templo*: la misma ficha sirve.

```
character model sheet of a fat orange tabby cat with one torn ear and a round
face, sitting and standing poses, plus expressions: total contempt, contempt with
eyes closed, terrified and puffed up, smug satisfaction, neutral flat background,
[ESTILO]
```

---

### PER-04 · Tao, el compañero
**Archivo:** `ficha_per04_tao.png` · **Viñetas:** 12, 21

Dos años mayor que el Novato y más atlético. Pelo atado, sonrisa torcida, **siempre masticando algo**. Túnica igual pero mejor puesta y **cinturón verde**. Se apoya en las cosas en vez de estar parado.

**Arco:** se burla en el Alba → advierte al Mediodía → **te traiciona en el Ocaso** (se vende a los soldados). También es las cartas *Compañero Burlón* y *Compañero Traidor*.
**Expresiones necesarias:** burla, advertencia genuina, culpa mientras se va sin mirar atrás.

```
character model sheet of a cocky athletic teenage shaolin student, tied-back hair,
crooked smirk, chewing on something, well-worn tunic with a green belt, leaning
posture, front side and back view, plus expressions: mocking, genuine warning,
guilty while walking away, neutral flat background, [ESTILO]
```

---

### PER-05 · Bandido
**Archivo:** `ficha_per05_bandido.png` · **Viñetas:** 05 (y el grupo del camino)

Sucio, flaco, ropa remendada de colores apagados, pañuelo en la cabeza. **Arma un palo podrido que se le está desarmando en la mano.** Más patético que amenazante. Hace falta que funcione **repetido en grupo**, así que el diseño tiene que leerse en silueta.

```
character model sheet of a scruffy skinny bandit in patched drab clothes and a
head scarf, holding a rotten wooden stick that is visibly falling apart, more
pathetic than threatening, front and side view, plus a group of three of them
together, neutral flat background, [ESTILO]
```

---

### PER-06 · Mercenario
**Archivo:** `ficha_per06_mercenario.png` · **Viñetas:** 05

Corpulento, armadura de cuero remachada, barba descuidada, cara de aburrido. Está ahí por la plata. Es el mismo tipo que en las cartas lleva la espada de juguete.

```
character model sheet of a burly bored mercenary in studded leather armour, unkempt
beard, relaxed intimidating posture, front and side view, neutral flat background,
[ESTILO]
```

---

### PER-07 · El Vendedor Ambulante
**Archivo:** `ficha_per07_vendedor.png` · **Viñetas:** 05

Flaquísimo, sonrisa enorme y permanente, **abrigo largo abierto con espadas de juguete de colores colgando por dentro** (OBJ-08). Alivio cómico puro. Camina inclinado hacia adelante.

```
character model sheet of a very skinny street peddler with a huge permanent grin,
long open coat with brightly painted wooden toy swords hanging inside it, leaning
forward as he walks, front and side view, neutral flat background, [ESTILO]
```

---

### PER-08 · Soldado del Gobernador
**Archivo:** `ficha_per08_soldado.png` · **Viñetas:** 12, 21

Armadura lacada oscura con **el escudo del Gobernador en el peto** (diseñar ese escudo: sirve para la carta también). Casco con ala. Cara de funcionario, no de guerrero. Tiene que funcionar repetido: en la viñeta 12 suben varios.

```
character model sheet of a soldier in dark lacquered armour with a governor's crest
on the breastplate, brimmed helmet, bureaucratic rather than warlike face, front
and side view, plus three of them walking in a row, neutral flat background,
[ESTILO]
```

---

### PER-09 · Demonio de la Pereza
**Archivo:** `ficha_per09_pereza.png` · **Viñetas:** 06

Chiquito, del tamaño de un gato, gordito y morado apagado. **Abraza una almohada** y bosteza. Se le trepa al hombro al Novato. Deforme y adorable, no aterrador.

```
character model sheet of a small chubby dull-purple demon the size of a cat,
hugging a pillow and yawning enormously, sitting on someone's shoulder, cute
rather than scary, front and side view, neutral flat background, [ESTILO]
```

---

### PER-10 · Los demonios internos (set de 3)
**Archivo:** `ficha_per10_demonios.png` · **Viñetas:** 30

**Son versiones caricaturescas del propio Novato**, eso es lo importante: mismo cuerpo flaco, misma túnica, pero deformados.
- **Orgullo:** corona de papel torcida, pecho inflado.
- **Pereza:** el mismo PER-09.
- **Ira:** rojo, hirviendo, dientes apretados, demasiado chico para lo enojado que está.

En la viñeta 30 se están **deshaciendo en humo**: hace falta también ese estado.

```
character model sheet of three small demons that are distorted versions of the same
scrawny novice monk: one with a crooked paper crown and puffed chest, one chubby
and yawning with a pillow, one bright red and furious with clenched teeth, plus a
version of each dissolving into smoke, neutral flat background, [ESTILO]
```

---

### PER-11 · Los Campeones del Torneo
**Archivos:** `ficha_per11_campeon_1.png` … `_5.png` · **Viñetas:** 08, 32, 40

En el cómic aparecen **a contraluz y en silueta** (08 y 32), así que para las viñetas alcanza con que **dos siluetas enormes** se distingan entre sí. Para las cartas hacen falta los cinco diseños:

| # | Diseño |
|---|---|
| 1 | **El Monje Caído** — misma túnica del templo pero negra y rota, cara de rencor, sostiene una galleta como reliquia |
| 2 | **La Sombra del Bosque** — silueta ambigua de ramas y tela, nunca se le ve la cara |
| 3 | **El Señor de los Mercenarios** — enorme, armadura cara y sucia, moscas alrededor |
| 4 | **El Gran Maestro del Loto Negro** — impecable, seda, séquito con toallas y bebidas |
| 5 | **El Dragón de Papel** — dragón de desfile gigante, se nota que es papel y bambú |

Para el cómic conviene usar **el 1 y el 3**: son los que mejor se leen en silueta.

---

## 3. Catálogo de escenarios

Cada escenario se diseña **vacío, sin personajes**, y se entrega en sus **iluminaciones** (sección 7). Después los personajes se componen encima.

| ID | Archivo | Qué es | Viñetas | Iluminaciones |
|---|---|---|---|---|
| **LOC-01** | `ficha_loc01_montana.png` | Plano general: el templo en la cima, escalinata larga serpenteando, niebla baja | 01 | alba |
| **LOC-02** | `ficha_loc02_porton.png` | El portón de madera con **el loto tallado y torcido** (OBJ-09) arriba. Vista desde adentro y desde afuera | 02, 05, 08, 12, 31, 32, 51 | las 5 |
| **LOC-03** | `ficha_loc03_escalinata.png` | La escalinata de piedra. Vista desde arriba (se ve quién sube) y desde abajo | 02, 21, 41 | alba, ocaso |
| **LOC-04** | `ficha_loc04_patio.png` | **El escenario principal.** Patio de piedra, poste de entrenamiento (OBJ-05), escoba apoyada, tejas alrededor | 07, 10, 20, 22, 30, 32, 40, 41, 50 | las 5 |
| **LOC-05** | `ficha_loc05_interior.png` | Interior: mesa baja de madera, altar al fondo, ventana enrejada | 03, 04 | alba |
| **LOC-06** | `ficha_loc06_alacena.png` | La alacena de madera con puertas, y **el frasco de galletas** (OBJ-01) adentro | 06, 42, 52 | interior cálido |

```
empty establishing shot of [DESCRIPCIÓN DEL ESCENARIO], no characters, no people,
wide composition, [ILUMINACIÓN], [ESTILO]
```

---

## 4. Catálogo de objetos

Se diseñan aislados sobre fondo neutro. Son los que tienen que verse **idénticos** cada vez que aparecen.

| ID | Archivo | Qué es | Viñetas |
|---|---|---|---|
| **OBJ-01** | `ficha_obj01_galletas.png` | **El frasco de galletas.** El MacGuffin del juego: reconocible al instante, siempre igual. Frasco de cerámica panzón con tapa de madera | 06, 42, 52 |
| **OBJ-02** | `ficha_obj02_nota.png` | **La nota de Shifu.** Papel de arroz amarillento, caligrafía impecable en columnas. Se necesita entera y en detalle del pie | 03, 04 |
| **OBJ-03** | `ficha_obj03_te.png` | Taza y tetera de barro, humeando | 03 |
| **OBJ-04** | `ficha_obj04_equipaje.png` | El sombrero de paja y el bolso de viaje de Shifu. Son los que hacen que 41 y 51 rimen con 02 | 02, 41, 51 |
| **OBJ-05** | `ficha_obj05_poste.png` | Poste de entrenamiento envuelto en cuerda. **Progresivamente más golpeado** a lo largo del juego | 07, 20 |
| **OBJ-06** | `ficha_obj06_cartas.png` | Cartas de técnica sueltas, con el reverso del loto. Flotando (07) y desparramadas (50) | 07, 50 |
| **OBJ-07** | `ficha_obj07_monedas.png` | Bolsa de monedas con cordel | 21 |
| **OBJ-08** | `ficha_obj08_espadas.png` | Espadas de juguete de madera pintada, colores chillones | 05 |
| **OBJ-09** | `ficha_obj09_loto.png` | **El loto tallado y torcido** del portón. Es el logo del juego: un loto simétrico con un pétalo doblado | 01, 02, y todos los reversos |
| **OBJ-10** | `ficha_obj10_destrozos.png` | Set de destrozo: jarras rotas, palo partido, plumas en el aire | 10 |

```
isolated object study of [DESCRIPCIÓN], centred, neutral flat background, no
scene, no characters, [ESTILO]
```

---

## 5. Los cuatro estados del Novato

**Esto es lo que cuenta la historia sin una sola palabra.** Hace falta la ficha PER-01 en cuatro versiones, y cada viñeta indica cuál usar.

| Estado | Cómo se ve | Viñetas |
|---|---|---|
| **A · Limpio** | Túnica impecable, pelo peinado (mal, pero peinado). Intacto | 01–08 |
| **B · Golpeado** | Despeinado, un moretón en el pómulo, túnica con polvo | 10, 11, 12 |
| **C · Gastado** | Manos vendadas, túnica sucia y con un desgarro, ojeras | 20, 21, 22, 30 |
| **D · Destrozado** | Túnica rota en varios lados, vendas deshechas, agotado — **pero de pie** | 32, 40, 42, 50, 52 |

El cinturón blanco arranca torcido en A y **termina igual de torcido en D**. Es el detalle que dice que sigue siendo el mismo pibe.

---

## 6. Las 23 viñetas — shot list

Ahora sí. Cada fila dice **qué fichas usar como referencia** y el prompt describe sólo la puesta en escena.

**Cómo se genera cada una:**
```
[fichas de la columna "Usa"] como imágenes de referencia
+
"[ENCUADRE]. [QUIÉN HACE QUÉ]. [ILUMINACIÓN]. [ESTILO]"
```

### 6.1 Apertura (8 viñetas)

| # | Archivo | Usa | Escena |
|---|---|---|---|
| 1 | `01_templo_amanecer.png` | LOC-01, OBJ-09 | Plano general del templo en la cima. Niebla baja, escalinata serpenteando. **Sin personajes.** Luz de alba |
| 2 | `02_shifu_se_va.png` | LOC-03, PER-02, PER-01(A), PER-03, OBJ-04 | Shifu de espaldas bajando la escalinata con bolso y sombrero. El Novato lo saluda desde arriba. Mei mira desde una teja. Luz de alba |
| 3 | `03_la_nota.png` | LOC-05, OBJ-02, OBJ-03, PER-01(A) | Primer plano de la nota sobre la mesa baja, junto a la taza humeante. El Novato la lee de costado, entrando en cuadro |
| 4 | `04_posdata.png` | OBJ-02, PER-01(A) | Detalle del pie de la nota sostenida por dos manos. Arriba, la cara del Novato con una ceja levantada, confusión total |
| 5 | `05_llegan_los_problemas.png` | LOC-02, PER-05, PER-06, PER-07, OBJ-08 | Contrapicado desde el portón hacia el camino. Tres bandidos, un mercenario y el Vendedor Ambulante subiendo en fila. Luz de mañana |
| 6 | `06_tentaciones.png` | LOC-06, OBJ-01, PER-01(A), PER-09 | El Novato frente a la alacena abierta, el frasco iluminado como un tesoro. El Demonio de la Pereza bostezando en su hombro |
| 7 | `07_entrenamiento.png` | LOC-04, PER-01(A), OBJ-05, OBJ-06 | Montaje en tres tiempos dentro del mismo cuadro: golpea el poste, se cae, se levanta. Cartas de técnica flotando alrededor |
| 8 | `08_campeones.png` | LOC-02, PER-11(1 y 3), PER-01(A) | Dos siluetas enormes a contraluz en el portón. El Novato chiquito, de espaldas, en guardia. Atardecer rojo |

### 6.2 Interludio: fin del Alba (3 viñetas)

| # | Archivo | Usa | Escena |
|---|---|---|---|
| 10 | `10_fin_alba.png` | LOC-04, PER-01(**B**), OBJ-10 | El patio hecho un desastre: jarras rotas, palo partido, plumas en el aire. El Novato de pie en el medio, entero. Sol subiendo |
| 11 | `11_mei_juzga.png` | LOC-04, PER-03, PER-01(B) | Mei sentada en una teja mirando al Novato con desprecio absoluto. Él le devuelve la mirada desde abajo |
| 12 | `12_llega_tao.png` | LOC-02, PER-04, PER-08 | Tao apoyado en el portón masticando algo. Detrás, en el camino, soldados con armadura subiendo. Luz de mediodía |

### 6.3 Interludio: fin del Mediodía (3 viñetas)

| # | Archivo | Usa | Escena |
|---|---|---|---|
| 20 | `20_fin_mediodia.png` | LOC-04, PER-01(**C**), OBJ-05 | Sol alto, sombras cortas. Gente retirándose derrotada de fondo. El Novato apoyado en el poste, agotado, manos vendadas |
| 21 | `21_traicion_tao.png` | LOC-03, PER-04, PER-08, PER-01(C), OBJ-07 | Tao bajando la escalinata con la bolsa de monedas, sin mirar atrás. Un soldado le palmea el hombro. El Novato lo ve desde arriba. Atardecer |
| 22 | `22_cae_la_noche.png` | LOC-04 | El sol hundiéndose detrás de la montaña, el patio en penumbra. Sombras alargadas que no corresponden a ningún objeto real. **Sin personajes** |

### 6.4 Interludio: fin del Ocaso (3 viñetas)

| # | Archivo | Usa | Escena |
|---|---|---|---|
| 30 | `30_fin_ocaso.png` | LOC-04, PER-01(C), PER-10(disolviéndose) | El Novato solo en el patio de madrugada, rodeado de los tres demonios deshaciéndose en humo. Tiembla, pero está de pie |
| 31 | `31_golpean_el_porton.png` | LOC-02, PER-03 | Primer plano del portón vibrando por tres golpes. Polvo cayendo de las vigas. Mei erizada, saliendo del cuadro |
| 32 | `32_los_campeones.png` | LOC-04, PER-11(1 y 3), PER-01(**D**) | Los dos Campeones entrando al patio, enormes, a contraluz. El Novato en guardia en el centro, chiquito y decidido |

### 6.5 Final: victoria (3 viñetas)

| # | Archivo | Usa | Escena |
|---|---|---|---|
| 40 | `40_victoria_campeones.png` | LOC-04, PER-11, PER-01(D), PER-03 | Los Campeones tirados en el patio, aturdidos. El Novato de pie en el medio, respirando fuerte. Mei sentada en el pecho de uno |
| 41 | `41_vuelve_shifu.png` | LOC-03, LOC-04, PER-02, OBJ-04 | Shifu subiendo la escalinata, **encuadre espejo de la viñeta 02**. El patio recién barrido detrás. Séptimo atardecer |
| 42 | `42_las_galletas.png` | LOC-06, PER-02, OBJ-01, PER-01(D), PER-03 | Shifu de espaldas frente a la alacena, contando galletas con un dedo. El Novato mira a Mei; Mei mira decididamente a otro lado |

### 6.6 Final: derrota (3 viñetas)

| # | Archivo | Usa | Escena |
|---|---|---|---|
| 50 | `50_derrota_patio.png` | LOC-04, PER-01(D), OBJ-06 | El Novato de rodillas en el patio vacío, cabeza gacha, las cartas desparramadas por el piso. Amanece gris |
| 51 | `51_shifu_ve_el_desastre.png` | LOC-02, PER-02, OBJ-04 | Shifu parado en el portón con el bolso todavía al hombro, mirando el desastre. Cara completamente inexpresiva |
| 52 | `52_la_pregunta.png` | LOC-06, PER-02, OBJ-01, PER-01(D) | Primerísimo plano de Shifu abriendo la alacena vacía. El reflejo del Novato en el vidrio del frasco, chiquito y culpable |

**Rimas visuales a respetar:** 02 ↔ 41 (Shifu baja / Shifu sube, mismo encuadre espejado) y 06 ↔ 42 ↔ 52 (la alacena, tres veces, cada vez peor).

---

## 7. Iluminaciones

Los escenarios se entregan en estas cinco, porque el paso del día **es** la estructura del juego.

| Momento | Luz | Color dominante |
|---|---|---|
| **Alba** | Rasante desde el horizonte, niebla baja, sombras larguísimas | `#7BC67E` frío verdoso |
| **Mediodía** | Cenital dura, sombras cortas y marcadas | `#E0B14A` dorado |
| **Ocaso** | Rasante desde el otro lado, naranja saturado | `#C85450` rojo |
| **Noche** | Luna fría, todo en penumbra, contrastes altos | `#9B6BD6` violeta |
| **Interior** | Cálida, de lámpara de aceite, muy suave | `#D97B29` ámbar |

---

## 8. Bloque 2 — arte de cartas

Otro trabajo, con sus propios prompts **ya escritos** en `csv/templo/es/` (columnas `arte_prompt`). Son 70 viñetas chicas de 265 × 265 px, un sujeto centrado cada una.

Las fichas de esta guía **también sirven de referencia** para las cartas donde aparece el mismo personaje: *Gato Guardián del Templo* = PER-03, *Compañero Burlón* y *Compañero Traidor* = PER-04, *Mercenario con Espada de Juguete* = PER-06 + OBJ-08, *Soldado del Gobernador* = PER-08, y todas las técnicas = PER-01.

Marcos, dorsos e iconografía: ver `DISENO_CARTAS.md`.

---

## 9. Orden de producción

1. **PER-01 en sus cuatro estados.** Sin esto no hay nada: está en 17 de 23 viñetas.
2. **PER-02, PER-03, LOC-02, LOC-04, OBJ-01.** Con esto ya se pueden armar 15 viñetas.
3. **El resto de las fichas.**
4. **Las 8 viñetas de apertura** — es lo primero que ve cualquiera que abra el juego.
5. **Las 6 de finales** — cierran el ciclo y son las que dan ganas de rejugar.
6. **Las 9 de interludios** — mejoran el ritmo, pero el juego funciona sin ellas.
7. **Arte de cartas** — recién cuando el balance esté cerrado, porque los nombres todavía pueden cambiar.

---

## 10. Nota sobre el guion

Los textos de narración y diálogo **no van dibujados**: viven en `app/lib/temas/templo/textos_es.dart` y `textos_en.dart`, y se editan ahí. Si al ilustrar te queda mejor otro chiste o otro encuadre, cambialo — el texto se adapta al dibujo, no al revés.

Los `boceto` que la app muestra como placeholder salen de `app/lib/temas/templo/arte.dart` y son la versión corta de la columna "Escena" de la sección 6.
