/// Dónde va el texto de cada carta y qué dice, en coordenadas normalizadas.
///
/// Las 50 cartas están impresas y su texto está HORNEADO en el JPG, en
/// español. Traducir el juego sin tocar esto dejaba al alemán jugando con
/// cartas en castellano, y un juego de cartas donde las cartas no se entienden
/// no está traducido.
///
/// Las dos salidas obvias no servían. Hornear un `.webp` por idioma son 10 MB
/// por idioma: con siete, sesenta y pico de megas sobre diecisiete, por un
/// texto que ya tenemos escrito. Y rehacer las cartas enteras en Dart tira a la
/// basura la ilustración, el marco y los medallones, que es casi todo lo que
/// hace que la carta sea linda.
///
/// Así que se tapa SOLO la franja del texto y se vuelve a escribir encima.
/// Pesa cero, porque el texto ya viaja en `TextosTema`.
///
/// Dart puro a propósito, sin `package:flutter`: lo importa `bin/check.dart`,
/// igual que hace con `tutorial_zonas.dart` e `idiomas.dart`. Por eso las
/// coordenadas son doubles sueltos y no `Rect`, y los colores viven del otro
/// lado, en `ui_carta.dart`.
library;

import 'mecanica.dart';
import 'modos/cansancio.dart';
import 'temas/tema.dart';
import 'tutorial_zonas.dart';

/// Una línea de texto sobre la placa.
class LineaRotulo {
  final String texto;

  /// Centro vertical de la línea, 0 a 1 sobre el alto de la carta.
  final double y;

  /// Cuerpo de la fuente, también en fracción del alto. Normalizar por el
  /// ALTO y no por el ancho es lo que hace que la letra mida lo mismo en un
  /// teléfono que en un iPad sin una sola cuenta de pantalla.
  final double cuerpo;

  final bool negrita;
  final bool mayusculas;

  /// -1 izquierda, 0 centro, 1 derecha.
  final int alineacion;

  final int maxLineas;

  const LineaRotulo(
    this.texto,
    this.y,
    this.cuerpo, {
    this.negrita = false,
    this.mayusculas = false,
    this.alineacion = 0,
    this.maxLineas = 1,
  });
}

/// Un parche de color sobre la carta y lo que se escribe encima.
class PlacaRotulo {
  final double izq;
  final double arriba;
  final double der;
  final double abajo;

  /// Si va dibujada media vuelta. La mitad de abajo de las cartas de peligro
  /// está impresa a 180°, como en la mesa de verdad.
  final bool rotada;

  /// Los jefes tienen fondo de noche y letra clara; el resto, papel y tinta.
  final bool oscura;

  final List<LineaRotulo> lineas;

  const PlacaRotulo({
    required this.izq,
    required this.arriba,
    required this.der,
    required this.abajo,
    required this.lineas,
    this.rotada = false,
    this.oscura = false,
  });
}

// ---------------------------------------------------------------- geometría
//
// Los números salen de medir las cartas originales (1024 x 1620 las verticales,
// 1620 x 1024 los jefes) y de mirar el resultado, no de una fórmula: el arte lo
// dibujó una persona y las franjas no caen en ningún lugar deducible.
//
// Hay UNA constante por familia, no una por carta. Medir carta por carta se
// probó y no converge: la banda no es un color plano sino pergamino texturado,
// y el detector encuentra antes una pared clara de la ilustración que la banda.
// Dentro de cada familia el arte SÍ está alineado, que es lo que importa.

/// Margen lateral de la placa. El mismo de los dos lados a propósito: la mitad
/// de abajo se dibuja girada, así que cualquier asimetría sale espejada y las
/// dos placas quedan desfasadas entre sí.
const _margen = 0.045;

// Peligros (30): la banda del medio, la que parte la carta en dos.
const _pelArriba = 0.4180;
const _pelAbajo = 0.4900;
// El nombre sube y el sabor baja apenas, para hacerle lugar al sabor más
// grande: con cuerpo 0,0220 e interlineado 1,25 las dos líneas suman 0,0629
// dentro de los 0,0720 de la banda, y quedan sin tocarse.
const _pelNombre = 0.4360;
const _pelExtra = 0.4755;

// Iniciales y Cansancio (15): nombre arriba, sabor abajo, sin banda impresa.
//
// La placa del nombre NO llega a los bordes: a la izquierda está el medallón
// del Poder y a la derecha la insignia del efecto, que son números y no se
// traducen. Taparlos sería romper la carta para arreglarle el idioma.
// Y llega hasta .108 porque las cinco iniciales tienen el nombre en DOS
// líneas: con la altura de una, «Postura del» quedaba tapado y «Flamenco»
// asomaba abajo, en español.
//
// Acá SÍ hay dos constantes y no una, aunque las quince cartas compartan el
// resto del arte: el medallón de las Iniciales es el aro azul grande y llega
// hasta .299, y el de Cansancio es el sello rojo, que termina en .235. Con un
// solo .215 para las dos familias —que es como estaba— la placa entraba casi
// un tercio adentro del aro azul, y el borde opaco del parche se leía como si
// el nombre traducido le hubiera comido el Poder a la carta. Lo mismo del
// otro lado: la insignia del efecto de las Iniciales arranca en .716 y el
// viejo .785 la partía al medio.
//
// Los cuatro números salen de medir los quince JPG (el aro azul por su tinta
// azul, el sello por su bermellón, la insignia por su blanco), no de mirar la
// pantalla. Están abajo como [zonaPoderInicial] y compañía, y `bin/check.dart`
// los cruza contra estas placas.
const _aire = 0.012;
const _iniPoderDer = 0.2988;
const _iniInsigniaIzq = 0.7158;
const _canPoderDer = 0.2354;

const _iniIzq = _iniPoderDer + _aire;
const _iniDer = _iniInsigniaIzq - _aire;
const _canIzq = _canPoderDer + _aire;
// Cansancio no tiene insignia del efecto: por derecha la placa llega tan lejos
// como llegaba, que es lo que necesita «GANAS DE RENUNCIAR».
const _canDer = 0.7850;
const _simArriba = 0.0250;
const _simAbajo = 0.1080;
const _simNombre = 0.0665;
const _simSaborArriba = 0.8880;
const _simSaborAbajo = 0.9750;
const _simSabor = 0.9315;

// ---------------------------------------------------- iconografía intocable
//
// Lo que la placa no puede pisar: números y símbolos que son las reglas de la
// carta y que no se traducen. Medidos sobre los JPG de 1024 x 1620, igual que
// las placas, y en las mismas coordenadas normalizadas.

/// El aro azul del Poder de las cinco cartas Iniciales.
const zonaPoderInicial = RectN(0.0557, 0.0370, _iniPoderDer, 0.1623);

/// El sello bermellón del Poder de las diez cartas de Cansancio.
const zonaPoderCansancio = RectN(0.0625, 0.0321, _canPoderDer, 0.1401);

/// La insignia del efecto de las Iniciales, arriba a la derecha. Sólo la
/// tienen algunas, pero la placa es una sola para la familia.
const zonaInsigniaInicial = RectN(_iniInsigniaIzq, 0.0340, 0.9463, 0.1160);

/// El anillo bermellón del Poder de los cinco jefes, arriba a la izquierda.
///
/// Medido con un detector de rojo sobre los cinco JPG: en `jefe1`, `jefe3` y
/// `jefe4` da 0,0340–0,1568 clavado, y en `jefe2` y `jefe5` el detector se
/// ensucia con el rojo de la propia ilustración. La maqueta es la misma en los
/// cinco, así que manda la medición limpia.
const zonaPoderJefe = RectN(0.0340, 0.0527, 0.1568, 0.2471);

/// El panel blanco del daño y las cartas gratis, arriba a la derecha. Los cinco
/// jefes coinciden dentro de un píxel.
const zonaIconosJefe = RectN(0.8235, 0.0439, 0.9722, 0.2988);

// Jefes (5): apaisados, con placa oscura propia. La del sabor es alta porque
// el texto impreso son TRES líneas —bastante más largas que el sabor que
// guarda el dato— y hay que tapar las tres.
//
// El ancho de la placa del nombre NO es el de la banda impresa, porque la banda
// no mide igual en las cinco cartas: se dibujó al ancho de cada nombre, de
// 0,2210 a 0,7370 en la más angosta y de 0,2735 a 0,7315 en la más ancha. La
// geometría es una constante por familia, así que acá manda el otro límite: que
// no toque la iconografía. Va de `zonaPoderJefe.der` a `zonaIconosJefe.izq` con
// un respiro de un par de milésimas a cada lado.
const _jefIzq = 0.1680;
const _jefDer = 0.8150;
const _jefNombreArriba = 0.0400;
const _jefNombreAbajo = 0.1050;
const _jefNombre = 0.0725;
const _jefSaborArriba = 0.7880;
const _jefSaborAbajo = 0.9580;
const _jefSabor = 0.8730;

// Cuerpos de letra, en fracción del alto de la carta.
//
// Casi todos salen de medir el texto horneado en los JPG: se toma la altura de
// mayúscula de la línea impresa y se divide por 0,72, que es la proporción de
// esta fuente. Son un TECHO, no una orden: el que dibuja es `_TextoAjustado`,
// que baja el cuerpo cuando el idioma no entra.
//
// El sabor tiene dos tamaños porque las cartas no lo imprimen igual: en el
// peligro es un pie de renglón apretado contra la banda y en las Iniciales y el
// Cansancio es una línea suelta, bastante más grande (mayúscula 0,0167). Con un
// solo 0,0146 para las dos, el sabor de las simples salía al 63 % de lo
// impreso, que a tamaño de mano es ilegible.
//
// `_cSabor` es el único que NO respeta el impreso, y es a propósito. El arte lo
// imprime a 0,0164 (mayúscula 0,0118) y a tamaño de teléfono eso no se lee. Se
// midió el ancho de los 326 sabores del juego —47 técnicas por 7 idiomas, con
// las fuentes reales— buscando qué cuerpo entra en la placa de cada uno: el
// mínimo de todo el corpus es 0,0168 (alemán) pero la mediana está entre 0,0280
// y 0,0320. O sea que 0,0164 le estaba aplicando a las 326 el peor caso de una.
// Con 0,0220, 304 de las 326 entran sin encoger un punto y el resto lo hace
// solo, que para eso está `_TextoAjustado`. No volver a bajarlo a 0,0164 "para
// respetar la carta": el que manda acá es el que la lee en la mano.
const _cNombre = 0.0283;
const _cMazo = 0.0172;
const _cSabor = 0.0220;
const _cSaborSimple = 0.0231;
const _cNombreJefe = 0.0488;
const _cSaborJefe = 0.0313;

/// ¿Hay que escribir el texto encima del arte, o el arte ya lo dice?
///
/// El texto de las 50 cartas está horneado en el JPG EN ESPAÑOL. Para los otros
/// seis idiomas se tapa la franja con un parche opaco y se reescribe encima, que
/// es lo que evita que un jugador inglés pelee contra el MOSQUITO DEL TEMPLO.
///
/// En español no hay nada que traducir, y el parche es todo costo: es un
/// rectángulo de color plano sobre un pergamino texturado, con otra tipografía y
/// otro cuerpo que el impreso. La carta se ve peor por escribirle lo mismo que ya
/// decía. Así que en español se muestra tal como salió de imprenta.
///
/// Lo aceptado a cambio: el jefe del Loto Negro vuelve a decir «EL GM DEL TEMPLO
/// LOTO NEGRO», abreviado a mano para que entrara en el cartón. Es lo que dice la
/// carta de verdad, y la carta de verdad es la que el jugador tiene en la mesa.
///
/// La usan `lib/ui_carta.dart`, el chequeo 22 de `bin/check.dart` y
/// `test/rotulo_test.dart`: es una sola regla para que los tres no opinen
/// distinto.
bool rotulaEn(String idioma) => idioma != 'es';

/// Las placas que van sobre la carta de imagen [archivo], ya con su texto.
///
/// [archivo] es lo que devuelve `archivoCarta`, o sea el nombre del JPG: una
/// técnica de recompensa no tiene carta propia y entra acá como el peligro que
/// la otorga. Devolver la lista vacía es válido y significa «esta carta no
/// lleva texto encima», que es lo que pasa si algún día se suma un arte suelto.
List<PlacaRotulo> rotuloDe(String archivo, TextosTema t) {
  String nom(String id) => t.cartas[id]?.nombre ?? id;
  String sab(String id) => t.cartas[id]?.sabor ?? '';

  final peligro = mecPeligros.where((p) => p.id == archivo).firstOrNull;
  if (peligro != null) {
    final tec = peligro.recompensa;
    final sabor = sab(tec);
    return [
      PlacaRotulo(
        izq: _margen,
        arriba: _pelArriba,
        der: 1 - _margen,
        abajo: _pelAbajo,
        lineas: [
          LineaRotulo(
            nom(archivo),
            _pelNombre,
            _cNombre,
            negrita: true,
            mayusculas: true,
          ),
          LineaRotulo(
            t.fase(peligro.fase),
            _pelExtra,
            _cMazo,
            negrita: true,
            mayusculas: true,
            alineacion: 1,
          ),
        ],
      ),
      PlacaRotulo(
        izq: _margen,
        arriba: _pelArriba,
        der: 1 - _margen,
        abajo: _pelAbajo,
        rotada: true,
        lineas: [
          // Sin sabor el nombre no tiene por qué colgar del borde de arriba:
          // se centra en la placa, que es donde lo pone el arte impreso.
          LineaRotulo(
            nom(tec),
            sabor.isEmpty ? (_pelArriba + _pelAbajo) / 2 : _pelNombre,
            _cNombre,
            negrita: true,
            mayusculas: true,
          ),
          if (sabor.isNotEmpty) LineaRotulo(sabor, _pelExtra, _cSabor),
        ],
      ),
    ];
  }

  if (mecJefes.any((j) => j.id == archivo)) {
    final sabor = sab(archivo);
    return [
      PlacaRotulo(
        izq: _jefIzq,
        arriba: _jefNombreArriba,
        der: _jefDer,
        abajo: _jefNombreAbajo,
        oscura: true,
        lineas: [
          // Ojo: la carta IMPRESA de jefe4 dice «EL GM DEL TEMPLO LOTO
          // NEGRO», abreviado a mano para que entrara. El dato tiene el
          // nombre entero, así que en pantalla se lee completo y un poco más
          // chico. Se decidió así: el nombre de verdad se lee, la abreviatura
          // no se puede traducir, y la carta de cartón no se va a reimprimir.
          LineaRotulo(
            nom(archivo),
            _jefNombre,
            _cNombreJefe,
            negrita: true,
            mayusculas: true,
          ),
        ],
      ),
      if (sabor.isNotEmpty)
        PlacaRotulo(
          izq: 0.022,
          arriba: _jefSaborArriba,
          der: 0.978,
          abajo: _jefSaborAbajo,
          oscura: true,
          lineas: [
            LineaRotulo(
              sabor,
              _jefSabor,
              _cSaborJefe,
              mayusculas: true,
              maxLineas: 3,
            ),
          ],
        ),
    ];
  }

  // Iniciales y Cansancio comparten arte: el nombre arriba y el sabor abajo,
  // los dos sobre el pergamino, sin banda que los separe.
  final id = _idSimple(archivo);
  if (id == null) return const [];
  final sabor = sab(id);
  final esInicial = archivo.startsWith('inicial_');
  return [
    PlacaRotulo(
      izq: esInicial ? _iniIzq : _canIzq,
      arriba: _simArriba,
      der: esInicial ? _iniDer : _canDer,
      abajo: _simAbajo,
      lineas: [
        LineaRotulo(
          nom(id),
          _simNombre,
          _cNombre,
          negrita: true,
          mayusculas: true,
          maxLineas: 2,
        ),
      ],
    ),
    if (sabor.isNotEmpty)
      PlacaRotulo(
        izq: _margen,
        arriba: _simSaborArriba,
        der: 1 - _margen,
        abajo: _simSaborAbajo,
        lineas: [
          LineaRotulo(
            sabor,
            _simSabor,
            _cSaborSimple,
            mayusculas: true,
            maxLineas: 2,
          ),
        ],
      ),
  ];
}

/// El id de juego detrás de un archivo `inicial_*` o `canN`.
///
/// Es la vuelta de `archivoCarta`, y la de Cansancio tiene que hacerse por
/// ORDEN en `mazoCansancio` por la misma razón que la ida: el número del
/// archivo sale de la posición, no de una tabla que se pueda desalinear.
String? _idSimple(String archivo) {
  if (archivo.startsWith('inicial_')) {
    return archivo.substring('inicial_'.length);
  }
  final n = int.tryParse(
    archivo.startsWith('can') ? archivo.substring(3) : 'x',
  );
  if (n != null && n >= 1 && n <= mazoCansancio.length) {
    return mazoCansancio[n - 1].id;
  }
  return null;
}
