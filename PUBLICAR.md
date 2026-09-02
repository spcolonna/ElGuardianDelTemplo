# Publicar la app en la App Store

Todo lo que hace falta para llevar la app del repositorio a la tienda de Apple.
El estado de cada cosa está marcado: **[hecho]** es código que ya está en el
repositorio, **[tuyo]** es algo que solo podés hacer vos porque necesita una
cuenta, plata o una decisión.

Android va aparte y todavía no está: firma con las claves de debug
(`app/android/app/build.gradle.kts`, con el TODO puesto).

---

## 1. Lo que decidimos, y por qué

### La edad

Son **dos declaraciones distintas** y se confunden todo el tiempo.

La **clasificación de contenido** sale de un cuestionario que se contesta en App
Store Connect. El juego tiene demonios, mercenarios y peleas, dibujados y sin
sangre: eso es violencia fantástica leve e infrecuente, y da **9+**. No hay nada
sexual, ni drogas, ni apuestas. La dificultad del juego **no es una pregunta del
cuestionario**: a Apple no le importa si cuesta entenderlo.

El **público objetivo** es otra cosa, y va en **13+**. O sea que la app **no** se
declara dirigida a menores. Esto es lo que importa de verdad, porque es lo que
decide si entrás en COPPA y en la política de Familias — y no querés entrar: te
obliga a avisos limitados, te saca el identificador de publicidad siempre, y
suma reglas de contenido y de enlaces externos.

Un 9+ de contenido **no** te mete en COPPA. Son ejes independientes.

Como red, el código pide avisos con `maxAdContentRating: 'PG'` y
`tagForChildDirectedTreatment` en `no`
([anuncios.dart](app/lib/tienda/anuncios.dart)). Filtrar los avisos más subidos
de tono no cuesta plata y saca de encima el riesgo de que a un chico de nueve le
aparezca un aviso de casino.

El **14+** impreso en la contratapa de la caja (`PRODUCCION.md` §4) es la
dificultad del juego de mesa, no una clasificación de contenido. No tiene por qué
coincidir y nadie los cruza.

### iPhone y iPad

Se soportan los dos (`TARGETED_DEVICE_FAMILY = "1,2"`). Eso trae una obligación
que **ya no se puede esquivar**: desde iPadOS 26 la clave `UIRequiresFullScreen`
está deprecada y el sistema la ignora (ver TN3192 de Apple), así que el iPad le
da a la app la ventana que quiere — un tercio de pantalla en Slide Over, la
mitad, o los 1366 pt del apaisado.

**[hecho]** `app/test/ipad_test.dart` construye las cinco pantallas grandes
—patio, modos, ajustes, progreso y la mesa de juego— en seis anchos, de 320 a
1366 pt, en los dos idiomas, y falla si alguna se desborda. Encontró y arregló
cuatro desbordes reales que en un simulador de teléfono no se ven nunca.

---

## 2. Bloqueantes

### 2.1 Manifiesto de privacidad — **[hecho]**

`app/ios/Runner/PrivacyInfo.xcprivacy`, ya dado de alta en «Copy Bundle
Resources» del target Runner. Sin él, el upload se cae solo con **ITMS-91053**
antes de que nadie mire nada, porque `shared_preferences` usa `NSUserDefaults`,
que es API de razón requerida.

Declara: `NSUserDefaults` (CA92.1), marca de tiempo de archivos (C617.1) y
espacio en disco (E174.1), rastreo en `true`, los dominios de Google, y los
tipos de datos que recoge AdMob más el historial de compras de StoreKit.

Verificado: el archivo viaja adentro del `.app` compilado.

### 2.2 Los identificadores de AdMob — **[tuyo]**

**Este es el que hoy impide publicar.** Los IDs son los de prueba públicos de
Google. Publicar así viola las políticas de AdMob y la guideline 2.3.

Todo se toca en un solo archivo, [ids.dart](app/lib/tienda/ids.dart), que tiene
los pasos en el encabezado:

1. Crear la app en AdMob y copiar su App ID.
2. Crear un bloque **intersticial** y copiar su ID.
3. Poner `kIdsDePrueba = false`.
4. Repetir el App ID en `app/ios/Runner/Info.plist` (`GADApplicationIdentifier`)
   y en `app/android/app/src/main/AndroidManifest.xml`. Son archivos nativos y
   no leen Dart; si no coincide con `ids.dart`, el SDK tira una excepción y la
   app se cae al arrancar.

**Orden importante:** no pongas `kIdsDePrueba = false` antes de que el producto
de compra exista en App Store Connect. El botón de compra queda deshabilitado
—que es lo correcto— pero avisa mal.

### 2.3 El producto de compra — **[tuyo]**

En App Store Connect, **No consumible**, con el identificador exacto
`guardian_templo_completo` (el mismo string que Play Console). Desbloquea los
seis caminos, el selector de jefes, los modos Encargos y Cansancio, y saca la
publicidad.

**[hecho]** El botón de restaurar compras ya existe en dos lugares —dentro de la
hoja de compra y suelto en Ajustes—, que es lo que Apple exige para un producto
no consumible.

**Deuda conocida, no bloqueante:** no hay verificación de recibo. No hay backend
y para un desbloqueo local no se justifica montarlo. Alguien con un dispositivo
comprometido puede desbloquear el juego. Está anotado a propósito.

### 2.4 Cumplimiento de encriptación — **[hecho]**

`ITSAppUsesNonExemptEncryption` en `false`. Sin esta clave, cada build sube
marcado como «Missing Compliance» y hay que contestar a mano antes de poder
mandarlo a revisión.

### 2.5 Consentimiento y rastreo — **[hecho]** el código, **[tuyo]** la consola

`app/lib/tienda/consentimiento.dart` resuelve los dos permisos en el orden que
pide Google: primero **UMP** (el formulario del RGPD, que solo aparece en Europa,
el Reino Unido y Suiza) y después **ATT** (el cartel de Apple, solo en iOS).
Recién cuando `canRequestAds` da `true` se inicializa el SDK y se pide el primer
aviso. Si el jugador dice que no, no se carga nada.

En Ajustes hay una sección de Privacidad con el botón **Opciones de privacidad**
—que reabre el formulario, y que AdMob exige— y el enlace a la política. El
botón solo aparece donde el formulario existe.

`NSUserTrackingUsageDescription` está en el Info.plist, en español. Sin esa clave
iOS no muestra el cartel: responde «denegado» sin preguntarle a nadie.

**Falta tuyo:** crear y **publicar el mensaje de consentimiento en la consola de
AdMob**, en español, y elegir los socios publicitarios. Sin eso publicado, el
formulario no baja y el SDK no sirve avisos en Europa.

### 2.6 SKAdNetwork — **[hecho]**

El Info.plist tenía **un** identificador; ahora tiene los **50** que publica
Google en `developers.google.com/admob/ios/3p-skadnetworks`. No bloquea la
revisión: sin la lista se pierde atribución, y con eso baja el relleno de avisos
y lo que se paga. Cuando Google agregue socios, hay que volver a pegarla.

### 2.7 Política de privacidad — **[hecho]** el texto, **[tuyo]** publicarla

`docs/privacidad.html`, en español, versionada en este repositorio.

**Falta tuyo, dos cosas:**

1. **Encender GitHub Pages**: Settings → Pages → rama `main`, carpeta `/docs`.
   La URL que espera el código es
   `https://spcolonna.github.io/ElGuardianDelTemplo/privacidad.html`
   (constante `urlPoliticaDePrivacidad` en [ids.dart](app/lib/tienda/ids.dart)).
   Mientras no esté encendido, el botón de Ajustes abre un 404.
2. **Poner una dirección de contacto** en el documento. La dejé marcada como
   `[falta la dirección de contacto]` a propósito: publicar tu correo es una
   decisión tuya. Apple y AdMob exigen que haya una.

---

## 3. El peso — **[hecho]**

Los assets pasaron de **87 MB a 16,5 MB**, y lo que se empaqueta —arte más
audio— de 86,2 MB a 20,1 MB. El `.app` de release quedó en **51 MB** medidos;
como los 66 MB de diferencia salen enteros de ahí, el mismo build antes del
cambio pesaba alrededor de 117 MB.

El diseño tiene una restricción que manda sobre todo lo demás: **los originales
no se pueden tocar ni mover.**

- `bin/imprimir.py` lee `app/assets/cartas` y `app/assets/comic` para armar el
  print & play a 300 dpi. Recomprimirlos arruina la imprenta.
- Los tres tomos congelados del libro (`cuento/libro/final/*.json`) tienen doce
  rutas `app/assets/comic/*.png` **grabadas adentro**. Renombrar un panel obliga
  a descongelar un tomo.
- Las cartas salieron de Canva y los paneles de una generación que no se repite:
  `app/assets/` es la única copia que existe.

Así que los originales se quedan donde están y **dejan de empaquetarse**.
`bin/aligerar.py` escribe al lado una copia WebP en `app/assets/movil/`, que es
lo único que declara `pubspec.yaml`:

| | Antes | Después |
|---|--:|--:|
| Cómic (23 paneles) | 58,4 MB | 4,9 MB |
| Cartas (50) | 17,8 MB | 10,3 MB |
| Interfaz | 6,4 MB | 1,3 MB |
| Audio (sin tocar) | 3,6 MB | 3,6 MB |
| **Total empaquetado** | **86,2 MB** | **20,1 MB** |

Las calidades están medidas, no elegidas de memoria: se recortó la banda de
texto de una carta a tamaño real y se comparó contra el original. A calidad 72 el
nombre de la carta y la línea de regla —texto horneado en el arte, lo peor para
un codificador con pérdida— ya salen sin un artefacto visible. Las cartas van a
78, con margen.

**Se borró** `assets/ui/background.jpeg`: 876 KB que no nombraba ni una línea de
código y que viajaban en el binario solo porque `pubspec.yaml` declaraba el
directorio entero. Por lo mismo entraban dos `LEEME.txt`.

**Cuando toques una imagen**, corré:

```bash
python3 bin/aligerar.py
```

El **chequeo 19** de `app/bin/check.dart` falla si una copia falta o quedó vieja.
Eso es lo que evita el error silencioso: agregar una carta y olvidarse del
script deja una carta sin imagen en el teléfono aunque el archivo esté en el
repositorio, y la app dibuja el respaldo sin quejarse.

El audio queda como está. Son 12 WAV, ya a 11 kHz mono, y `lib/audio.dart` dice
que son pistas sintéticas de relleno para reemplazar: comprimirlas ahora es
trabajo que se tira cuando lleguen las definitivas.

### De qué está hecho el `.app`, medido

| Pieza | Peso |
|---|--:|
| `flutter_assets` (los 20 MB de arte y audio) | 21 MB |
| Motor de Flutter | 9,6 MB |
| `libswift_Concurrency.dylib` | 7,4 MB |
| Código Dart compilado (`App.framework/App`) | 5,0 MB |
| Binario `Runner` (incluye el SDK de AdMob, que va estático) | 4,0 MB |
| Los demás plugins | ~3 MB |

**Quedan 7,4 MB sobre la mesa y son tuyos de decidir.** El
`libswift_Concurrency.dylib` es una biblioteca de compatibilidad que iOS trae de
fábrica desde la versión 15: se empaqueta **solo** porque el objetivo mínimo está
en **iOS 13**. Subirlo a 15 la saca entera del binario. El precio es dejar afuera
a iPhone 6s, 7 y SE de primera generación, que son los que se quedaron en 15. No
lo cambié porque es una decisión de producto, no de código: decime y lo subo.

Y una aclaración para cuando lo veas en App Store Connect: **lo que descarga el
jugador es bastante menos que estos 51 MB.** Apple comprime y hace *app
thinning* —le manda a cada teléfono solo la arquitectura y los recursos que le
sirven—. El número de arriba es el del paquete sin adelgazar, que es el único
que se puede medir desde acá.

---

## 4. Presentación — **[hecho]**

- **Pantalla de arranque.** Era el placeholder de Flutter: tres PNG de **1×1
  píxel transparente** sobre fondo blanco, o sea que el juego abría en un
  rectángulo vacío. Ahora lleva el isotipo a 220 pt sobre el papel del propio
  logo, medido del borde de la imagen para que el cuadrado no se vea.
- **`CFBundleDisplayName`** pasó de «Guardian Templo» a **«Guardián del Templo»**.
- **`CFBundleDevelopmentRegion = es`** y `CFBundleLocalizations = [es, en]`. Sin
  eso, una app escrita en español se lista como inglesa.
- **`description`** de `pubspec.yaml` ya no dice «A new Flutter project.».
- **`platform :ios, '13.0'`** destapado en el Podfile. Andaba de casualidad, por
  el `IPHONEOS_DEPLOYMENT_TARGET` del proyecto.

Lo que ya estaba bien y no se tocó: bundle ID propio
`com.sebastianperez.guardianTemplo`, `DEVELOPMENT_TEAM` en las tres
configuraciones, y **los 15 íconos completos, con el de 1024×1024 y sin canal
alfa en ninguno** — verificados uno por uno. Por ahí no va a haber rechazo.

---

## 5. Lo que falta, y es tuyo

1. **Apple Developer Program**, USD 99 al año. El equipo `RZGQPAGH53` ya figura
   en el proyecto, así que puede estar hecho: confirmalo.
2. **Cuenta de AdMob**, la app dada de alta, el bloque intersticial creado, y el
   mensaje de consentimiento **publicado**.
3. **El producto `guardian_templo_completo`** en App Store Connect, No
   consumible, con precio.
4. **GitHub Pages encendido** y la dirección de contacto puesta en
   `docs/privacidad.html`.
5. **Capturas**: iPhone 6.9" y iPad 13". Las puedo sacar del simulador; elegir
   cuáles y en qué orden es tuyo.
6. **El texto de la ficha**: nombre, subtítulo, descripción y palabras clave, en
   español. El idioma principal de la ficha va en español; el inglés se agrega
   cuando puedas revisar los textos de las cartas.
7. **Las declaraciones de privacidad** de App Store Connect. Lo que hay que
   tildar está abajo.

### Qué tildar en App Store Connect

Tiene que coincidir con `PrivacyInfo.xcprivacy`. Todo esto lo recoge **AdMob**,
no el juego: la app no tiene servidor, no pide login y no manda un solo byte a
ningún lado.

| Categoría | Dato | Vinculado a la identidad | Usado para rastrear | Propósito |
|---|---|:--:|:--:|---|
| Identificadores | ID de dispositivo | No | **Sí** | Publicidad de terceros |
| Uso | Datos de publicidad | No | **Sí** | Publicidad de terceros |
| Uso | Interacción con el producto | No | **Sí** | Publicidad de terceros, Analítica |
| Ubicación | Ubicación aproximada | No | **Sí** | Publicidad de terceros |
| Diagnóstico | Datos de fallos | No | No | Funcionalidad de la app |
| Diagnóstico | Datos de rendimiento | No | No | Funcionalidad de la app |
| Compras | Historial de compras | **Sí** | No | Funcionalidad de la app |

---

## 6. Verificación

```bash
cd app && flutter analyze && flutter test && dart bin/check.dart
```

Los chequeos que importan acá: el **9** (ningún idioma con huecos), el **18**
(las viñetas existen y son imágenes de verdad) y el **19** (la copia para el
teléfono está al día).

```bash
cd app && flutter build ios --release --no-codesign
du -sh build/ios/iphoneos/Runner.app
```

Que el print & play siga saliendo igual — es la prueba de que los originales
quedaron intactos:

```bash
python3 bin/imprimir.py
```

Y que el libro no se rompió, con los tres tomos todavía congelados:

```bash
node cuento/libro/parser.mjs && node cuento/libro/verificar.mjs
```

En simulador, iPhone **y iPad**:

- Primer arranque limpio: aparece el formulario de consentimiento, después el
  cartel de rastreo, y recién entonces el patio.
- Rechazar el consentimiento y comprobar que el juego anda igual.
- Ajustes → Opciones de privacidad reabre el formulario.
- Los tres intersticiales de cambio de fase.
- Comprar en Sandbox, desinstalar, reinstalar y **restaurar**.
- Con la compra hecha: los seis caminos abiertos y **cero avisos**.
- Que todas las imágenes se vean. Las rutas se arman por interpolación, así que
  una mal escrita no la agarra el compilador: se ve como una carta en blanco.
