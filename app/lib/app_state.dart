import 'dart:async';
import 'dart:convert';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';

import 'audio.dart';
import 'config_store.dart';
import 'data.dart';
import 'engine.dart';
import 'modos/encargos.dart';
import 'logros.dart';
import 'models.dart';
import 'modos/dificultad.dart';
import 'preferencias.dart';
import 'progreso.dart';
import 'ui_texturas.dart';
import 'temas/temas.dart';
import 'tienda/anuncios.dart';
import 'tienda/compra.dart';

class AppState extends ChangeNotifier {
  final prefs = Preferencias();
  final audio = Audio();

  /// La compra única y la publicidad entre fases. Van juntas porque son la
  /// misma decisión: quien compró no ve anuncios.
  late final Tienda tienda = Tienda(prefs);
  late final Anuncios anuncios = Anuncios(tienda);

  /// El jugador tiene el juego completo: los seis caminos, el selector
  /// de jefes, los modos opcionales y ningún anuncio.
  bool get premium => tienda.comprado;

  Config cfg = Config();
  Tema tema = temaTemplo;
  Contenido contenido = contenidoPorDefecto();
  Juego? juego;

  /// `null` = seguir el idioma del sistema.
  String? idiomaElegido;

  /// Racha de misiones diarias. Persiste entre sesiones.
  Progreso progreso = Progreso();

  bool introVista = false;
  bool tutorialVisto = false;
  bool listo = false;

  /// La fase que se está VIENDO, que va un paso atrás de `juego.fase`.
  ///
  /// El motor cambia de fase y en el mismo frame se abre el cómic, que tapa
  /// la pantalla entera: si el paisaje siguiera a `juego.fase` la transición
  /// pasaría detrás del cómic y el jugador no la vería nunca. Esto avanza
  /// recién cuando el cómic se cierra, y arrastra al paisaje y a la música.
  Fase faseEscenica = Fase.alba;

  /// Encargo con el que se está jugando la partida actual (modo Encargos).
  Encargo? encargoActivo;

  /// Beneficio que se aplicó a esta partida por un encargo cumplido antes.
  String? beneficioAplicado;

  /// La última victoria completó los 7 días.
  bool semanaCompletadaReciente = false;

  /// Lo que el jugador eligió en la pantalla de modos.
  OpcionesPartida opciones = OpcionesPartida();

  /// Logros desbloqueados y contadores acumulados entre partidas.
  LogrosEstado logros = LogrosEstado();

  /// Logros recién desbloqueados que todavía no se celebraron. La partida los
  /// va consumiendo de a uno.
  final List<Logro> colaCelebracion = [];

  // ---------------------------------------------------------------- idioma

  /// Idioma efectivo: el elegido, o el del sistema si hay textos para él.
  String get idioma {
    if (idiomaElegido != null) return idiomaElegido!;
    final sistema = PlatformDispatcher.instance.locale.languageCode;
    return tema.idiomas.contains(sistema) ? sistema : Tema.idiomaPorDefecto;
  }

  TextosTema get textos => tema.textosDe(idioma);

  Future<void> cambiarIdioma(String? id) async {
    idiomaElegido = id;
    await prefs.guardarIdioma(id);
    contenido = contenidoDe(tema, idioma);
    notifyListeners();
  }

  // ----------------------------------------------------------------- carga

  Future<void> cargar() async {
    await prefs.iniciar();
    await iniciarTexturas();
    await audio.iniciar(prefs.crudo);
    progreso = prefs.cargarProgreso();
    logros = prefs.cargarLogros();
    opciones = prefs.cargarOpciones();
    // La config sale del archivo versionado, no de las preferencias.
    cfg = await ConfigStore.cargar(prefs.crudo);
    idiomaElegido = prefs.cargarIdioma();
    tema = temaPorId(prefs.cargarTema());
    tutorialVisto = prefs.tutorialVisto;
    introVista = prefs.introVista;
    progreso.revisarCadena(DateTime.now());
    contenido = contenidoDe(tema, idioma);
    // La tienda primero: `Anuncios` le pregunta si tiene que existir.
    await tienda.iniciar();
    tienda.addListener(_alCambiarLaCompra);
    unawaited(anuncios.iniciar());
    _apretarOpcionesSiNoCompro();
    await prefs.guardarProgreso(progreso);
    listo = true;
    notifyListeners();
  }

  Future<void> guardar() async => prefs.guardarProgreso(progreso);

  Future<void> guardarOpciones() async {
    _apretarOpcionesSiNoCompro();
    await prefs.guardarOpciones(opciones);
    notifyListeners();
  }

  /// Sin compra, la partida es la de la versión gratis y punto.
  ///
  /// No alcanza con bloquear los controles en pantalla: `guardian_opciones_v1`
  /// puede venir de una versión anterior al bloqueo, con Maestro y tres jefes
  /// guardados, y entonces el juego entero quedaría abierto sin pagar.
  void _apretarOpcionesSiNoCompro() {
    if (premium) return;
    opciones
      ..dificultad = Dificultad.aprendiz
      ..jefes = null
      ..encargos = false
      ..cansancio = false;
  }

  void _alCambiarLaCompra() {
    if (premium) anuncios.soltar();
    notifyListeners();
  }

  /// Recalcula la galería sin partida: sirve para desbloquear un logro que se
  /// agregó al catálogo después de que el jugador ya cumplió su condición.
  Future<void> revisarLogros() async {
    evaluarLogros(progreso: progreso, estado: logros);
    await prefs.guardarLogros(logros);
  }

  /// El admin guarda un override local; el archivo se actualiza a mano
  /// pegando el JSON que exporta la pantalla de admin.
  Future<void> guardarConfig() async =>
      ConfigStore.guardarOverride(prefs.crudo, cfg);

  Future<void> marcarIntroVista() async {
    introVista = true;
    await prefs.marcarIntroVista(true);
  }

  Future<void> marcarTutorialVisto() async {
    tutorialVisto = true;
    await prefs.marcarTutorialVisto(true);
    notifyListeners();
  }

  // --------------------------------------------------------------- partida

  void nuevaPartida() {
    // El primer corte de fase llega a los pocos minutos: pedir el aviso ahora
    // le da tiempo de sobra para bajar, y así el jugador no espera nada.
    anuncios.precargar();
    final hoy = DateTime.now();
    final c = opciones.aplicar(cfg);
    beneficioAplicado = null;
    encargoActivo = null;
    semanaCompletadaReciente = false;

    if (c.modoEncargos) {
      // Se cobra el beneficio del encargo cumplido en un día anterior.
      if (progreso.beneficioListo(hoy)) {
        for (final e in encargos) {
          if (e.id == progreso.encargoCumplidoId) {
            e.beneficio(c);
            beneficioAplicado = textos.encargos[e.id]?.recompensa;
            break;
          }
        }
        progreso.encargoCumplidoId = null;
        progreso.encargoCumplidoEl = null;
        guardar();
      }
      encargoActivo = encargoDelDia(hoy);
    }

    juego = Juego(cfg: c, contenido: contenido);
    faseEscenica = Fase.alba;
    notifyListeners();
  }

  /// Se llama una sola vez al terminar la partida.
  void registrarResultado(Juego j) {
    final hoy = DateTime.now();
    var cumplioEncargo = false;

    if (j.estado == EstadoJuego.victoria) {
      semanaCompletadaReciente = progreso.registrarVictoria(hoy);
      final e = encargoActivo;
      if (e != null && e.cumplido(j)) {
        progreso.encargoCumplidoId = e.id;
        progreso.encargoCumplidoEl = Progreso.soloFecha(hoy);
        cumplioEncargo = true;
      }
    } else {
      progreso.registrarDerrota();
    }

    // Los logros se evalúan DESPUÉS del progreso: varios dependen de la racha
    // que se acaba de actualizar.
    colaCelebracion.addAll(
      evaluarLogros(
        juego: j,
        progreso: progreso,
        estado: logros,
        encargoCumplido: cumplioEncargo,
      ).where((l) => l.celebrable),
    );
    prefs.guardarLogros(logros);

    guardar();
    notifyListeners();
  }

  // ------------------------------------------------------------------ tema

  /// Cambia el tema activo. No toca el balance: `contenidoDe` combina el tema
  /// con los mismos números de `mecanica.dart`.
  void cambiarTema(Tema t) {
    tema = t;
    contenido = contenidoDe(t, idioma);
    prefs.guardarTema(t.id);
    notifyListeners();
  }

  void tocar() => notifyListeners();

  Future<void> restaurarContenido() async {
    cfg = await ConfigStore.cargarDelAsset() ?? Config();
    contenido = contenidoDe(tema, idioma);
    guardarConfig();
    notifyListeners();
  }

  String exportar() => const JsonEncoder.withIndent(
    '  ',
  ).convert({'config': cfg.toJson(), 'contenido': contenido.toJson()});

  String? importar(String texto) {
    try {
      final j = jsonDecode(texto) as Map<String, dynamic>;
      cfg = Config.fromJson(Map<String, dynamic>.from(j['config']));
      contenido = Contenido.fromJson(Map<String, dynamic>.from(j['contenido']));
      guardarConfig();
      notifyListeners();
      return null;
    } catch (e) {
      return 'No se pudo importar: $e';
    }
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState of(BuildContext c) =>
      c.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
