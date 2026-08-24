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
class BloqueReglas {
  final String titulo;
  final List<String> lineas;
  const BloqueReglas(this.titulo, this.lineas);

  Map<String, dynamic> toJson() => {'titulo': titulo, 'lineas': lineas};
}

List<BloqueReglas> reglasDe(Config c, Contenido contenido) {
  final cartasIniciales = contenido.mazoInicial.fold<int>(
    0,
    (a, e) => a + e.$2,
  );

  return [
    BloqueReglas('Objetivo', [
      'Sobrevivís tres fases de peligro (Alba, Mediodía, Ocaso) mejorando tu '
          'mazo de técnicas, y después enfrentás ${c.cantidadJefes} jefe(s) final(es).',
      'Perdés si tu Energía llega a 0 o menos.',
    ]),
    BloqueReglas('Preparación', [
      'Barajá el mazo inicial de combate ($cartasIniciales cartas).',
      'Separá los tres mazos de peligro y elegí ${c.cantidadJefes} jefe(s) al azar.',
      'Empezás con ${c.energiaInicial} de Energía (tope al curarte: ${c.energiaMaxima}).',
    ]),
    BloqueReglas('Turno', [
      '1. Revelá el peligro superior del mazo de la fase actual.',
      if (c.robosGratisIlimitados)
        '2. Robá cartas de combate una a una, sin coste, hasta que quieras parar.'
      else
        '2. Robá gratis hasta el número de "cartas gratis" del peligro. '
            'Cada carta adicional cuesta ${c.costeRoboExtra} de Energía.',
      '3. Sumá el Poder de las cartas jugadas y comparalo con el Poder del peligro.',
      '4. Si tu suma ≥ el peligro, ganás: la carta de peligro entra a tu descarte '
          'como la técnica de recompensa.',
      '5. Si perdés, restás el Daño del peligro a tu Energía y '
          '${c.peligroPerdidoSaleDelJuego ? 'la carta de peligro sale del juego' : 'la carta vuelve al fondo del mazo'}.',
      '6. Todas las cartas jugadas van al descarte. Cuando el mazo se acaba, barajá el descarte.',
    ]),
    BloqueReglas('Ganar o perder un combate (importante)', [
      'GANÁS si la suma de tus cartas ≥ el Poder del peligro. La carta de peligro '
          'se da vuelta y entra a tu pila de descarte convertida en la técnica de recompensa: '
          'a partir de ahí es una carta más de tu mazo.',
      'PERDÉS si te plantás por debajo del Poder. Restás el Daño del peligro a tu Energía '
          'y la carta de peligro se descarta del juego: NO te la llevás. '
          'Nunca ganás una carta perdiendo un combate.',
      'Plantarse por debajo no es un "precio" que pagás para quedarte la carta: es rendirte. '
          'A veces conviene igual, cuando pagar más robos costaría más Energía que el propio Daño.',
      'Ganes o pierdas, todas las cartas que jugaste van a tu descarte.',
    ]),
    BloqueReglas('Cómo se recupera Energía', [
      'No existe ninguna acción para curarte: no podés "descansar" ni gastar un turno en recuperarte.',
      'La Energía sube SÓLO por efectos de cartas de combate, y esos efectos se disparan '
          'automáticamente cuando la carta sale durante un combate. No elegís cuándo usarlas.',
      'Efecto "+X Energía": se aplica en el momento en que robás la carta, ganes o pierdas después. '
          'Ej.: Reflejo +1, Disciplina +2, Escama de Dragón +1, Puño del Dragón +2, '
          'Serenidad +3, Agua Sagrada +2, Iluminación +1.',
      'Efecto "+X Energía si ganás": se aplica recién al resolver, y sólo si ganaste ese combate. '
          'Ej.: Puño del Bambú +1, Ala de Grulla +1, Vuelo de Grulla +2.',
      'Nunca superás el tope de ${c.energiaMaxima} de Energía: lo que sobra se pierde.',
      'Consecuencia de diseño: curarte depende de haber metido cartas de curación en tu mazo '
          'y de que salgan. Por eso conviene meditar para eliminar cartas malas: un mazo más chico '
          'hace que las buenas aparezcan más seguido.',
    ]),
    BloqueReglas('Meditar: sacar cartas malas de tu mazo', [
      'Meditar es la ÚNICA forma de sacar cartas de tu mazo. No hay otra.',
      if (c.meditarSoloAlPerder)
        'Cuándo: sólo en el paso posterior a un combate que PERDISTE.'
      else
        'Cuándo: en el paso posterior a cualquier combate, lo hayas ganado o perdido.',
      'Cómo: pagá ${c.costeMeditar} de Energía y eliminá ${c.cartasPorMeditacion} carta(s) '
          'de tu pila de descarte. Salen del juego para siempre: no vuelven al mazo.',
      'Podés repetirlo varias veces seguidas, pagando cada vez, mientras te quede Energía.',
      'LIMITACIÓN CLAVE: sólo podés eliminar cartas que estén en el DESCARTE. '
          'Una Duda Existencial que sigue enterrada en el mazo es intocable: primero tiene que salir '
          'en algún combate. Por eso el mejor momento para meditar es justo después de un combate '
          'donde salieron tus peores cartas: todas las que acabás de jugar están en el descarte.',
      'Cuando el mazo se agota, el descarte se baraja y vuelve a ser mazo: ahí perdés la oportunidad '
          'de purgar esas cartas hasta que vuelvan a salir.',
      'Por qué conviene: quitar una Duda Existencial (-1) o una Respiración Agitada (0) no sube tu poder '
          'total, pero achica el mazo y hace que las cartas buenas (y las que curan Energía) salgan más seguido.',
    ]),
    BloqueReglas('Enfrentamiento final', [
      'Revelá los jefes y enfrentalos en orden, igual que un peligro normal.',
      'Si perdés contra un jefe, restás su Daño y volvés a enfrentarlo.',
      'Ganás la partida cuando derrotás al último.',
    ]),
  ];
}
