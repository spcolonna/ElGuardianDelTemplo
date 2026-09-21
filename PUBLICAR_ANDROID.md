# Publicar la app en Google Play

El hermano de [PUBLICAR.md](PUBLICAR.md), que es de Apple. Misma forma:
**[hecho]** es código que ya está en el repositorio, **[tuyo]** es algo que solo
podés hacer vos porque necesita una cuenta, plata o una decisión.

Lo que decidimos —la edad, la monetización, qué recoge AdMob— no se repite acá.
Es lo mismo para las dos tiendas y está contado en `PUBLICAR.md`, sección 1.

---

## 1. Lo único que bloquea de verdad: la clave — **[tuyo]**

Google Play rechaza un AAB firmado con las claves de debug, que es con lo que
firmaba este proyecto desde el día uno.

```bash
keytool -genkey -v -keystore ~/guardian-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Guardalo **fuera del repositorio** y anotá la contraseña donde no se pierda.
Después, `app/android/key.properties` —ignorado en dos `.gitignore`, no se sube
nunca—:

```properties
storePassword=<la que pusiste>
keyPassword=<la que pusiste>
keyAlias=upload
storeFile=/Users/<vos>/guardian-upload.jks
```

Con eso, `app/android/app/build.gradle.kts` firma solo. Sin eso, firma con las
de debug y avisa por consola: `flutter run --release` sigue andando en cualquier
máquina y lo que falla es la subida, no algo que salga publicado mal firmado.

Dato que tranquiliza y que en Apple no existe: con **Play App Signing**, que es
obligatorio para apps nuevas, ésta es la clave de *subida*, no la de firma
final. Si algún día la perdés, Google te la resetea.

## 2. Armar el AAB — **[hecho]**

```bash
cd app && flutter build appbundle --release --build-number=1
```

Sale en `build/app/outputs/bundle/release/app-release.aab`.

El `--build-number` va explícito **a propósito**: Android lleva su propia cuenta
de builds. Los cinco que ya se gastaron fueron de TestFlight, y no hay ninguna
razón para quemarlos acá. El nombre de versión —1.1.0— sí sale de `pubspec.yaml`,
que sigue siendo la única fuente.

El AAB pesa unos 70 MB, pero eso **no es lo que baja el jugador**: Play lo parte
por densidad de pantalla, arquitectura e idioma y arma un paquete a medida de
cada teléfono.

## 3. Verificar el AAB, no el código

Esto no es opcional. Ya pasó en iOS: un binario de simulador viajó adentro del
IPA y `lipo` no lo mostraba; Apple lo rechazó y el problema era el doble de
grande de lo que decía el mensaje. Lo mismo vale acá.

```bash
keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab
```

Si dice `CN=Android Debug`, falta tu `key.properties` y Play lo va a rechazar.
Tiene que decir lo tuyo.

Y para lo demás conviene armar el APK, que se lee con las herramientas del SDK:

```bash
cd app && flutter build apk --release --build-number=1
~/Library/Android/sdk/build-tools/36.1.0/aapt2 dump badging build/app/outputs/flutter-apk/app-release.apk | grep -E "^package|application-label|targetSdk|uses-permission"
```

Tienen que aparecer `versionCode='1'`, `targetSdkVersion:'36'`, los siete
nombres —incluido `application-label-zh-TW`, que es el que se nos había
escapado— y los permisos `INTERNET` y `AD_ID`.

Un chequeo automático cubre la parte que se desalinea sola: `dart bin/check.dart`
compara el nombre idioma por idioma contra los `.lproj` de iOS, el App ID de
AdMob contra `ids.dart` y el `applicationId` contra el `namespace`.

## 4. Antes de subir: los anuncios de prueba — **[tuyo]**

`app/lib/tienda/ids.dart` tiene `kAnunciosDePrueba = true` y **se queda así**
para la prueba interna. Se pasa a `false` recién en el commit del build que va
a producción.

No es un detalle de prolijidad: tocar un aviso real desde tu propia app es
tráfico inválido, y Google no suspende el aviso, suspende la cuenta entera.

## 5. La consola — **[tuyo]**

### El orden, que es al revés que en Apple

En App Store Connect se crea la app y el producto de compra **antes** de subir
nada. En Play no se puede: la sección de monetización no aparece hasta que ya
subiste un AAB, porque Google necesita ver el permiso de facturación dentro de
un binario. Si la vas a buscar antes, no está, y parece un problema de la
cuenta.

1. Crear la aplicación: nombre, idioma predeterminado, app o juego, gratis o
   de pago.
2. Subir el AAB a la pista de prueba interna.
3. Recién ahí, el producto de compra, la ficha, Seguridad de los datos y el
   cuestionario de clasificación.

Dos cosas del paso 1 no tienen vuelta atrás:

- **Gratis.** El juego es gratis con una compra adentro. De pago a gratis se
  puede cambiar; de gratis a pago, nunca.
- **El nombre de paquete**, que no se tipea: se toma del primer AAB que subas y
  queda para siempre. Va a ser `com.sebastianperez.guardian_templo`, que **no
  es** el identificador de iOS (`com.sebastianperez.guardianTemplo`, en
  camelCase). Cada tienda lleva el suyo y después no se emparejan.

### El producto de compra

Uno solo, no consumible, y el identificador tiene que ser **exactamente**
`guardian_templo_completo`: el mismo string que en App Store Connect y el que
está escrito en `ids.dart`. Va en Monetización → Productos → Productos dentro
de la aplicación, que como decíamos recién aparece después de la primera subida.

El precio, 3,99, se pone por mercado igual que en Apple.

### Probar la compra sin que te cobren

Subí el AAB a la pista de **prueba interna** y agregate como tester de licencia
en Play Console → Configuración → Prueba de licencias. Con eso la compra corre
el flujo completo —diálogo de Google, confirmación, desbloqueo— y no cobra. Es
el equivalente del sandbox de Apple.

Qué mirar, igual que en TestFlight: que el botón diga el precio y no un guión,
que **Restaurar compras** devuelva el juego desbloqueado, que se abran los seis
caminos, el selector de jefes y los dos modos opcionales, y que dejen de salir
avisos en los cambios de fase.

### Seguridad de los datos

El formulario de Play, que es el gemelo de las declaraciones de App Store
Connect. Tiene que decir lo mismo que la tabla de `PUBLICAR.md` y lo mismo que
`ios/Runner/PrivacyInfo.xcprivacy`, porque es la misma app. **Todo lo recoge
AdMob**: el juego no tiene servidor, no pide login y no manda un solo byte a
ningún lado.

| Tipo de dato | ¿Se recoge? | ¿Se comparte? | Propósito | Obligatorio |
|---|:--:|:--:|---|:--:|
| Identificador de publicidad | Sí | Sí | Publicidad o marketing | No |
| Interacción con la app | Sí | Sí | Publicidad, Analítica | No |
| Ubicación aproximada | Sí | Sí | Publicidad o marketing | No |
| Registros de fallos | Sí | Sí | Funciones de la app | No |
| Diagnóstico | Sí | Sí | Funciones de la app | No |
| Historial de compras | Sí | No | Funciones de la app | Sí |

Dos respuestas más que el formulario pide aparte: los datos **van cifrados en
tránsito** (sí, el SDK de Google usa HTTPS) y **no hay forma de pedir que se
borren desde la app** (no hay cuenta ni servidor donde borrar nada; el
identificador de publicidad se resetea desde el sistema, y eso está contado en
`docs/privacidad.html`).

Aparte, Play pide declarar el permiso `AD_ID`. Está declarado explícitamente en
el manifiesto justamente para que no se olvide.

### La ficha

`TIENDA_FICHA.md` tiene los siete idiomas escritos, pero contra los límites de
**Apple**. Play usa otros: título 30, descripción corta 80, descripción larga
4000. Los textos se reusan, hay que rearmar los cortes.

Capturas: mínimo 2 por tipo de dispositivo, en 16:9 o 9:16. Las de iOS no
sirven tal cual, tienen otra proporción.

### La política de privacidad — **[tuyo]**, y bloquea las dos tiendas

`docs/privacidad.html` está escrito, pero **GitHub Pages sigue apagado**:
Settings → Pages → `main`, carpeta `/docs`. Hasta que eso no esté, la URL que
declara `lib/tienda/ids.dart` da 404, el botón de Ajustes no abre nada y Play
rechaza la ficha.

---

## 6. Lo que queda anotado y no bloquea

- **No hay verificación de recibo.** No hay backend y para un desbloqueo local
  no se justifica montarlo. Alguien con un dispositivo comprometido puede
  desbloquear el juego. Es la misma deuda que en iOS, y está en `PUBLICAR.md`.
- **La política de privacidad está solo en español**, mientras el juego habla
  siete idiomas. Ninguna tienda lo exige; es una incoherencia con la ficha.
- **El mensaje europeo de consentimiento de AdMob también está solo en
  español.** Se arregla en la consola de AdMob, sin build nueva, y pega igual en
  las dos tiendas.
