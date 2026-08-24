import 'mecanica.dart';
import 'models.dart';
import 'temas/temas.dart';

/// Ensambla el contenido jugable combinando los NÚMEROS de `mecanica.dart`
/// con los TEXTOS de un tema en un idioma. El motor recibe siempre el mismo
/// `Contenido`, así que ni el tema ni el idioma pueden mover el balance.
Contenido contenidoDe(Tema tema, [String idioma = Tema.idiomaPorDefecto]) {
  CartaCombate combate(String id) {
    final m = mecCombates.firstWhere((c) => c.id == id);
    return CartaCombate(
      id: m.id,
      nombre: tema.nombreDe(id, idioma),
      poder: m.poder,
      efecto: m.efecto,
      sabor: tema.saborDe(id, idioma),
    );
  }

  List<CartaPeligro> peligrosDe(Fase fase) => mecPeligros
      .where((p) => p.fase == fase)
      .map(
        (p) => CartaPeligro(
          id: p.id,
          nombre: tema.nombreDe(p.id, idioma),
          fase: p.fase,
          poder: p.poder,
          dano: p.dano,
          cartasGratis: p.cartasGratis,
          recompensa: combate(p.recompensa),
        ),
      )
      .toList();

  return Contenido(
    mazoInicial: [
      for (final (id, copias) in mecMazoInicial) (combate(id), copias),
    ],
    alba: peligrosDe(Fase.alba),
    mediodia: peligrosDe(Fase.mediodia),
    ocaso: peligrosDe(Fase.ocaso),
    jefes: [
      for (final j in mecJefes)
        CartaJefe(
          id: j.id,
          nombre: tema.nombreDe(j.id, idioma),
          poder: j.poder,
          dano: j.dano,
          cartasGratis: j.cartasGratis,
          lore: tema.saborDe(j.id, idioma),
        ),
    ],
  );
}

Contenido contenidoPorDefecto() => contenidoDe(temaTemplo);
