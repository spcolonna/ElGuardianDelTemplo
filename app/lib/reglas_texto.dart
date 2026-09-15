import 'l10n.dart';
import 'models.dart';

/// Las reglas del juego en prosa, generadas desde el `Config` vivo.
///
/// Dart puro a propósito, sin importar Flutter: acá lo consumen TRES cosas —la
/// pantalla de Reglas de la app, `bin/export_libro.dart` para el reglamento
/// impreso, y los tests—. Ese es todo el punto de que exista este archivo.
///
/// Un reglamento impreso que repita los números a mano se desincroniza del
/// juego en el primer rebalanceo, y encima nadie se entera hasta que alguien
/// juega mal una partida entera. Con un solo generador, la app y el papel no
/// pueden divergir: si el motor cambia, cambian los dos.
///
/// La prosa vive en `TextosUi` bajo `reglas.*` y los NÚMEROS los sigue poniendo
/// el `Config` vivo, que es lo que hace que esto funcione. Cuando una regla
/// tiene dos formas según la configuración —robos ilimitados o no, el peligro
/// perdido sale del juego o vuelve al mazo— son dos claves enteras y no un
/// fragmento interpolado: una frase partida al medio no se puede traducir a un
/// idioma que ordene distinto.
class BloqueReglas {
  final String titulo;
  final List<String> lineas;
  const BloqueReglas(this.titulo, this.lineas);

  Map<String, dynamic> toJson() => {'titulo': titulo, 'lineas': lineas};
}

List<BloqueReglas> reglasDe(Config c, Contenido contenido, TextosUi t) {
  final cartasIniciales = contenido.mazoInicial.fold<int>(
    0,
    (a, e) => a + e.$2,
  );

  return [
    // El Objetivo NO lleva la cantidad de jefes. Es la definición del juego, y
    // el número de jefes lo decide el nivel elegido: escrito acá se leería como
    // ley, y en el reglamento impreso —donde no hay un nivel seleccionado—
    // sería directamente falso. El número va en Preparación, donde corresponde
    // a la partida que estás por armar.
    BloqueReglas(t('reglas.objetivo.titulo'), [
      t('reglas.objetivo.l1'),
      t('reglas.objetivo.l2'),
      t('reglas.objetivo.l3'),
    ]),
    BloqueReglas(t('reglas.preparacion.titulo'), [
      t.con('reglas.preparacion.l1', {'cartas': cartasIniciales}),
      t.con('reglas.preparacion.l2', {'jefes': c.cantidadJefes}),
      t.con('reglas.preparacion.l3', {
        'inicial': c.energiaInicial,
        'maxima': c.energiaMaxima,
      }),
    ]),
    BloqueReglas(t('reglas.turno.titulo'), [
      t('reglas.turno.l1'),
      if (c.robosGratisIlimitados)
        t('reglas.turno.l2Ilimitado')
      else
        t.con('reglas.turno.l2Limitado', {'coste': c.costeRoboExtra}),
      t('reglas.turno.l3'),
      t('reglas.turno.l4'),
      if (c.peligroPerdidoSaleDelJuego)
        t('reglas.turno.l5Sale')
      else
        t('reglas.turno.l5Vuelve'),
      t('reglas.turno.l6'),
    ]),
    BloqueReglas(t('reglas.combate.titulo'), [
      t('reglas.combate.l1'),
      t('reglas.combate.l2'),
      t('reglas.combate.l3'),
      t('reglas.combate.l4'),
    ]),
    BloqueReglas(t('reglas.energia.titulo'), [
      t('reglas.energia.l1'),
      t('reglas.energia.l2'),
      t('reglas.energia.l3'),
      t('reglas.energia.l4'),
      t.con('reglas.energia.l5', {'maxima': c.energiaMaxima}),
      t('reglas.energia.l6'),
    ]),
    BloqueReglas(t('reglas.meditar.titulo'), [
      t('reglas.meditar.l1'),
      if (c.meditarSoloAlPerder)
        t('reglas.meditar.cuandoSoloAlPerder')
      else
        t('reglas.meditar.cuandoSiempre'),
      t.con('reglas.meditar.l3', {
        'coste': c.costeMeditar,
        'cartas': c.cartasPorMeditacion,
      }),
      t('reglas.meditar.l4'),
      t('reglas.meditar.l5'),
      t('reglas.meditar.l6'),
      t('reglas.meditar.l7'),
    ]),
    BloqueReglas(t('reglas.final.titulo'), [
      t('reglas.final.l1'),
      t('reglas.final.l2'),
      t('reglas.final.l3'),
    ]),
  ];
}
