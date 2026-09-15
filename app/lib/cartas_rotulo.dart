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
const _pelNombre = 0.4390;
const _pelExtra = 0.4760;

// Iniciales y Cansancio (15): nombre arriba, sabor abajo, sin banda impresa.
//
// La placa del nombre NO llega a los bordes: a la izquierda está el medallón
// del Poder y a la derecha la insignia del efecto, que son números y no se
// traducen. Taparlos sería romper la carta para arreglarle el idioma.
// Y llega hasta .108 porque las cinco iniciales tienen el nombre en DOS
// líneas: con la altura de una, «Postura del» quedaba tapado y «Flamenco»
// asomaba abajo, en español.
const _simIzq = 0.215;
const _simDer = 0.785;
const _simArriba = 0.0250;
const _simAbajo = 0.1080;
const _simNombre = 0.0665;
const _simSaborArriba = 0.8880;
const _simSaborAbajo = 0.9750;
const _simSabor = 0.9315;

// Jefes (5): apaisados, con placa oscura propia. La del sabor es alta porque
// el texto impreso son TRES líneas —bastante más largas que el sabor que
// guarda el dato— y hay que tapar las tres.
const _jefNombreArriba = 0.0400;
const _jefNombreAbajo = 0.1050;
const _jefNombre = 0.0725;
const _jefSaborArriba = 0.7880;
const _jefSaborAbajo = 0.9580;
const _jefSabor = 0.8730;

// Cuerpos de letra, en fracción del alto de la carta.
const _cNombre = 0.0283;
const _cMazo = 0.0172;
const _cSabor = 0.0146;
const _cNombreJefe = 0.0488;
const _cSaborJefe = 0.0313;

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
        izq: 0.105,
        arriba: _jefNombreArriba,
        der: 0.795,
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
  return [
    PlacaRotulo(
      izq: _simIzq,
      arriba: _simArriba,
      der: _simDer,
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
            _cSabor,
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
