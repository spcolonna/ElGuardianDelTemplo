import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_state.dart';
import 'rutas.dart';
import 'ui_kit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // El juego está pensado en vertical: una carta es más alta que ancha.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const GuardianApp());
}

class GuardianApp extends StatefulWidget {
  const GuardianApp({super.key});

  @override
  State<GuardianApp> createState() => _GuardianAppState();
}

class _GuardianAppState extends State<GuardianApp> {
  final estado = AppState();

  @override
  void initState() {
    super.initState();
    estado.cargar();
  }

  @override
  void dispose() {
    estado.audio.liberar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: estado,
      child: MaterialApp(
        title: 'El Guardián del Templo',
        debugShowCheckedModeBanner: false,
        theme: _temaClaro(),
        initialRoute: R.raiz,
        onGenerateRoute: generarRuta,
      ),
    );
  }

  ThemeData _temaClaro() {
    final base = ColorScheme.fromSeed(
      seedColor: kMadera,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: base.copyWith(
        surface: kPapel,
        primary: kMaderaOscura,
        secondary: kOroBorde,
      ),
      scaffoldBackgroundColor: kPapel,
      fontFamily: fuenteCuerpo,
      textTheme: Typography.blackMountainView
          .apply(bodyColor: kTinta, displayColor: kTinta)
          .copyWith(
            // Los títulos van en la manuscrita; el cuerpo en la legible.
            displayLarge: const TextStyle(fontFamily: fuenteTitulo),
            displayMedium: const TextStyle(fontFamily: fuenteTitulo),
            headlineLarge: const TextStyle(fontFamily: fuenteTitulo),
            headlineMedium: const TextStyle(fontFamily: fuenteTitulo),
            headlineSmall: const TextStyle(
              fontFamily: fuenteTitulo,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: kTinta,
            ),
            titleLarge: const TextStyle(fontFamily: fuenteTitulo),
          ),
      iconTheme: const IconThemeData(color: kTinta),
      dividerColor: kMadera.withValues(alpha: .5),
      sliderTheme: SliderThemeData(
        activeTrackColor: kOroBorde,
        thumbColor: kOroBorde,
        inactiveTrackColor: kMadera.withValues(alpha: .4),
      ),
      // Un solo idioma de botón en todo el juego.
      //
      // `BotonMadera` es EL botón de las pantallas de juego: madera clara para
      // lo secundario, dorado para la acción principal. Lo que sigue viste a
      // los botones de Material —diálogos, tutorial, cómic— con esa misma
      // forma y paleta, así nada desentona sin tener que reescribir cada
      // llamada.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: kOro,
          foregroundColor: kTinta,
          disabledBackgroundColor: kMadera.withValues(alpha: .35),
          disabledForegroundColor: kTintaSuave,
          textStyle: const TextStyle(
            fontFamily: fuenteCuerpo,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: kOroBorde, width: 2.5),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: kPapelClaro,
          foregroundColor: kTinta,
          textStyle: const TextStyle(
            fontFamily: fuenteCuerpo,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: kMaderaOscura, width: 2),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kMaderaOscura,
          textStyle: const TextStyle(
            fontFamily: fuenteCuerpo,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: kTinta),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: kPapelClaro,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontFamily: fuenteTitulo,
          fontSize: 21,
          fontWeight: FontWeight.bold,
          color: kTinta,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: fuenteCuerpo,
          fontSize: 14.5,
          color: kTintaSuave,
          height: 1.35,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: kMaderaOscura, width: 2),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: kPapelClaro,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (e) => e.contains(WidgetState.selected) ? kVerde : kPapelClaro,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (e) => e.contains(WidgetState.selected)
              ? kVerde.withValues(alpha: .45)
              : kMadera.withValues(alpha: .35),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: kTurquesa,
        linearTrackColor: Color(0x33C4915A),
      ),
    );
  }
}
