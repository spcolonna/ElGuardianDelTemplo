import 'dart:async';
import 'dart:convert';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

import 'audio.dart';
import 'config_store.dart';
import 'data.dart';
import 'engine.dart';
import 'game_center.dart';
import 'idiomas.dart';
import 'ui_kit.dart';
import 'l10n.dart';
import 'modos/encargos.dart';
import 'logros.dart';
import 'models.dart';
import 'modos/dificultad.dart';
import 'notificaciones.dart';
import 'preferencias.dart';
import 'progreso.dart';
import 'recordatorios.dart';
import 'resena.dart';
import 'ui_texturas.dart';
import 'temas/temas.dart';
import 'tienda/anuncios.dart';
import 'tienda/compra.dart';
import 'tienda/ids.dart' show kAppStoreId;

class AppState extends ChangeNotifier {
  final prefs = Preferencias();
  final audio = Audio();

  /// La compra única y la publicidad entre fases. Van juntas porque son la
  /// misma decisión: quien compró no ve anuncios.
  late final Tienda tienda = Tienda(prefs);
  late final Anuncios anuncios = Anuncios(tienda);

  /// Los recordatorios para volver. Ver `recordatorios.dart`.
  final notificaciones = Notificaciones();
  final gameCenter = GameCenter();

  /// El jugador tiene el juego completo: los seis caminos, el selector
  /// de jefes, los modos opcionales y ningún anuncio. Lo tiene quien lo
  /// compró, y por un día quien completó una semana de racha.
  bool get premium => comprado || temploAbierto;

  /// Lo compró de verdad. Lo que se le ofrece en la tienda depende de esto y
  /// no de [premium]: con el templo abierto de prueba se le sigue ofreciendo.
  bool get comprado => tienda.comprado;

  /// El templo abierto que regala la semana completa, todavía vigente.
  bool get temploAbierto => !comprado && progreso.temploAbierto(DateTime.now());

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

  /// Esta partida arrancó con la bendición de una semana completa.
  bool bendicionAplicada = false;

  /// Energía de más con que arranca la partida bendecida.
  static const energiaDeBendicion = 3;

  /// Si quiere los recordatorios; `null` = todavía no se le preguntó.
  bool? avisos;

  /// Lo que el jugador eligió en la pantalla de modos.
  OpcionesPartida opciones = OpcionesPartida();

  /// Logros desbloqueados y contadores acumulados entre partidas.
  LogrosEstado logros = LogrosEstado();

  /// Logros recién desbloqueados que todavía no se celebraron. La partida los
  /// va consumiendo de a uno.
  final List<Logro> colaCelebracion = [];

  /// Sesiones y pedidos de reseña. Ver `resena.dart`.
  EstadoResena resena = EstadoResena();

  /// El cuadro nativo de calificación. Es una variable para que los tests lo
  /// cambien: el plugin no existe fuera del teléfono.
  Future<void> Function() mostrarCuadroDeResena = _cuadroNativo;

  static Future<void> _cuadroNativo() async {
    final r = InAppReview.instance;
    if (await r.isAvailable()) await r.requestReview();
  }

  // ---------------------------------------------------------------- idioma

  /// Idioma efectivo: el que eligió el jugador, o el que sepamos leerle al
  /// teléfono.
  ///
  /// Mira `locales` y no `locale`: los dos sistemas exponen la lista ordenada
  /// de preferencias del usuario, y alguien con el teléfono en [turco,
  /// italiano, inglés] tiene que recibir italiano. Desarmar el locale en
  /// lengua, escritura y región tampoco es cosmética: con `languageCode`
  /// pelado, `zh-Hant-TW` y `pt-PT` no matchean ningún código nuestro y el
  /// jugador terminaba en español.
  String get idioma {
    if (idiomaElegido != null) return idiomaElegido!;
    return resolverIdioma([
      for (final l in PlatformDispatcher.instance.locales)
        (
          lengua: l.languageCode,
          escritura: l.scriptCode,
          region: l.countryCode,
        ),
    ]);
  }

  TextosTema get textos => tema.textosDe(idioma);

  Future<void> cambiarIdioma(String? id) async {
    idiomaElegido = id;
    await prefs.guardarIdioma(id);
    contenido = contenidoDe(tema, idioma);
    // ANTES de notificar: si se hiciera después, el primer frame del idioma
    // nuevo se dibujaría con la fuente del anterior, y en japonés eso son
    // cuadraditos.
    fijarFuentes(idioma);
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
    fijarFuentes(idioma);
    tema = temaPorId(prefs.cargarTema());
    tutorialVisto = prefs.tutorialVisto;
    introVista = prefs.introVista;
    resena = prefs.cargarResena()..sesiones += 1;
    await prefs.guardarResena(resena);
    progreso.revisarCadena(DateTime.now());
    contenido = contenidoDe(tema, idioma);
    // La tienda primero: `Anuncios` le pregunta si tiene que existir.
    await tienda.iniciar();
    tienda.addListener(_alCambiarLaCompra);
    unawaited(anuncios.iniciar());
    _apretarOpcionesSiNoCompro();
    await prefs.guardarProgreso(progreso);
    avisos = prefs.avisos;
    unawaited(reprogramarAvisos());
    unawaited(_entrarAGameCenter());
    listo = true;
    notifyListeners();
  }

  // ---------------------------------------------------------- game center

  /// Entra a Game Center sin frenar el arranque y le manda lo que el jugador
  /// ya tenía: los logros ganados antes de que existiera la integración no se
  /// pierden.
  Future<void> _entrarAGameCenter() async {
    if (!await gameCenter.autenticar()) return;
    notifyListeners();
    await gameCenter.sincronizar(logros, progreso.mejorRacha);
  }

  // ------------------------------------------------------------- avisos

  /// Recalcula los recordatorios desde cero. Se llama al abrir, al terminar
  /// una partida y al dejar el juego en segundo plano, que es cuando cuentan
  /// los días sin venir.
  Future<void> reprogramarAvisos() async {
    if (avisos != true) return;
    await notificaciones.reprogramar(
      planificarRecordatorios(
        progreso: progreso,
        ahora: DateTime.now(),
        comprado: comprado,
      ),
      TextosUi.de(idioma),
    );
  }

  /// El jugador prende o apaga los recordatorios. Prenderlos pide el permiso
  /// del sistema; devuelve false si lo negó, y entonces quedan apagados.
  Future<bool> cambiarAvisos(bool v) async {
    var ok = true;
    if (v) ok = await notificaciones.pedirPermiso();
    avisos = v && ok;
    await prefs.guardarAvisos(avisos!);
    if (avisos!) {
      await reprogramarAvisos();
    } else {
      await notificaciones.cancelarTodo();
    }
    notifyListeners();
    return ok;
  }

  Future<void> guardar() async => prefs.guardarProgreso(progreso);

  /// Si ahora toca pedir la reseña. Se mira DESPUÉS de `registrarResultado`,
  /// así la victoria que se acaba de ganar ya cuenta.
  bool get correspondeResena => corresponderPedirResena(
    estado: resena,
    victorias: logros.cuenta('victorias'),
    ahora: DateTime.now(),
  );

  /// Pide la reseña si corresponde. El pedido se anota antes de mostrar el
  /// cuadro: Apple no avisa si lo mostró, así que se cuenta como gastado.
  Future<void> pedirResena() async {
    if (!correspondeResena) return;
    resena
      ..pedidas += 1
      ..ultima = DateTime.now();
    await prefs.guardarResena(resena);
    try {
      await mostrarCuadroDeResena();
    } catch (_) {
      // Sin tienda o sin plugin: no se pide y listo.
    }
  }

  /// La ficha del juego en la tienda, para calificar cuando el jugador quiera.
  Future<void> abrirFichaDeLaTienda() async {
    try {
      await InAppReview.instance.openStoreListing(appStoreId: kAppStoreId);
    } catch (_) {}
  }

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
    if (comprado) anuncios.soltar();
    notifyListeners();
  }

  /// Recalcula la galería sin partida: sirve para desbloquear un logro que se
  /// agregó al catálogo después de que el jugador ya cumplió su condición.
  Future<void> revisarLogros() async {
    evaluarLogros(progreso: progreso, estado: logros);
    await prefs.guardarLogros(logros);
    unawaited(gameCenter.sincronizar(logros, progreso.mejorRacha));
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
    // Si el templo abierto se terminó con el juego abierto, la partida nueva
    // ya es la de la versión gratis.
    _apretarOpcionesSiNoCompro();
    final c = opciones.aplicar(cfg);
    beneficioAplicado = null;
    encargoActivo = null;
    semanaCompletadaReciente = false;
    bendicionAplicada = false;

    // La bendición de la semana: la cobra quien ya compró, en la primera
    // partida de un día posterior. No cambia ninguna carta, sólo la Energía
    // con que se arranca, como el beneficio de un encargo.
    if (comprado && progreso.bendicionLista(hoy)) {
      c.energiaInicial += energiaDeBendicion;
      progreso.bendicionDel = null;
      bendicionAplicada = true;
      guardar();
    }

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

    juego = Juego(
      cfg: c,
      contenido: contenido,
      textos: TextosUi.de(idioma),
      recurso: textos.recurso,
    );
    faseEscenica = Fase.alba;
    notifyListeners();
  }

  /// Se llama una sola vez al terminar la partida.
  void registrarResultado(Juego j) {
    final hoy = DateTime.now();
    var cumplioEncargo = false;

    if (j.estado == EstadoJuego.victoria) {
      semanaCompletadaReciente = progreso.registrarVictoria(hoy);
      if (semanaCompletadaReciente) {
        progreso.premiarSemana(hoy, comprado: comprado);
      }
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
    unawaited(gameCenter.sincronizar(logros, progreso.mejorRacha));

    guardar();
    unawaited(reprogramarAvisos());
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
