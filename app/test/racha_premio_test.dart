import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_templo/app_state.dart';
import 'package:guardian_templo/progreso.dart';
import 'package:guardian_templo/recordatorios.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('la semana completa', () {
    // `testWidgets` y no `test`: `AppState` arma el audio, y el plugin falla
    // afuera de la zona que el binding de widgets controla.
    testWidgets('sin compra, abre el templo un día y no lo regala', (
      tester,
    ) async {
      final app = AppState();
      expect(app.premium, isFalse);
      app.progreso.premiarSemana(DateTime.now(), comprado: false);
      expect(app.premium, isTrue);
      expect(app.comprado, isFalse, reason: 'la tienda se le sigue ofreciendo');
      app.progreso.temploAbiertoHasta = DateTime.now().subtract(
        const Duration(minutes: 1),
      );
      expect(app.premium, isFalse);
    });

    test('la racha sigue después del 7 y la fila vuelve a empezar', () {
      final p = Progreso();
      final d = DateTime(2026, 4, 1);
      for (var i = 0; i < 9; i++) {
        p.registrarVictoria(d.add(Duration(days: i)));
      }
      expect(p.racha, 9);
      expect(p.diasEnSemana(d.add(const Duration(days: 8))), 2);
      expect(p.semanasCompletadas, 1);
      expect(p.sellos, 1);
      expect(p.nivelTitulo, 1);
    });

    test('el progreso viejo, clavado en 7, se lee y sigue', () {
      final p = Progreso.fromJson(
        '{"racha":7,"ultimoDiaGanado":"2026-04-07T00:00:00.000",'
        '"logroActivo":true,"mejorRacha":7,"semanasCompletadas":1}',
      );
      expect(p.registrarVictoria(DateTime(2026, 4, 8)), isFalse);
      expect(p.racha, 8);
      expect(p.temploAbiertoHasta, isNull);
    });
  });

  group('recordatorios', () {
    test('sin racha no hay aviso de racha, sólo los de volver', () {
      final avisos = planificarRecordatorios(
        progreso: Progreso(),
        ahora: DateTime(2026, 4, 1, 10),
        comprado: false,
      );
      expect(avisos.map((a) => a.clave), ['vuelta1', 'vuelta2', 'vuelta3']);
    });

    test('ganado hoy, el de la racha es mañana a la tarde', () {
      final p = Progreso()..registrarVictoria(DateTime(2026, 4, 1));
      final avisos = planificarRecordatorios(
        progreso: p,
        ahora: DateTime(2026, 4, 1, 21),
        comprado: false,
      );
      expect(
        avisos.firstWhere((a) => a.id == 1).cuando,
        DateTime(2026, 4, 2, horaDelAviso),
      );
    });

    test('pasada la hora y sin ganar, no se programa un aviso viejo', () {
      final p = Progreso()..registrarVictoria(DateTime(2026, 4, 1));
      final avisos = planificarRecordatorios(
        progreso: p,
        ahora: DateTime(2026, 4, 2, 20),
        comprado: false,
      );
      expect(avisos.where((a) => a.id == 1), isEmpty);
    });

    test('el aviso del templo abierto sólo si no compró', () {
      final p = Progreso()..temploAbiertoHasta = DateTime(2026, 4, 2, 18);
      final ahora = DateTime(2026, 4, 1, 18);
      bool hay(bool comprado) => planificarRecordatorios(
        progreso: p,
        ahora: ahora,
        comprado: comprado,
      ).any((a) => a.clave == 'templo');
      expect(hay(false), isTrue);
      expect(hay(true), isFalse);
    });
  });
}
