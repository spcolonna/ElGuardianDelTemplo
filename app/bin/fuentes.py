#!/usr/bin/env python3
"""Recorta las fuentes CJK a los signos que el juego usa de verdad.

    python3 bin/fuentes.py

Por qué existe
--------------
Las dos fuentes latinas del juego pesan 55 y 167 KB porque el alfabeto latino
tiene doscientos y pico de signos. Una Noto CJK entera pesa entre 4 y 9 MB
porque tiene decenas de miles de ideogramas, y Flutter **no** subsetea las
fuentes de texto: lo que declarás en `pubspec.yaml` viaja entero. Meter las
cuatro enteras serían 26 MB sobre 17, para dibujar los mil y pico de signos que
el juego de verdad escribe.

Así que se recortan a la lista que genera `dart run bin/export_glifos.dart`.

Dos subsets y no uno
--------------------
El japonés y el chino comparten miles de codepoints, así que tentaba hacer un
solo archivo para los dos. No: varios hanzi se DIBUJAN distinto según la
región —el trazo de 直, 骨, 兄 y unos cuantos más— y una fuente sola tendría
que elegir una forma, que para la mitad de los jugadores sería la forma de otro
país. Son dos familias separadas y `fuenteCuerpoDe(idioma)` elige.

Qué se commitea
---------------
Los `.otf` recortados, que son lo único que necesita `flutter build`. Los
originales viven en `fonts/fuente/`, que está en `.gitignore`: pesan 26 MB, no
los usa nadie más que este script, y el script los baja solo si faltan.

Requiere `fonttools`:

    python3 -m pip install fonttools brotli
"""
import subprocess
import sys
import urllib.request
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
FUENTE = RAIZ / 'fonts' / 'fuente'
SALIDA = RAIZ / 'fonts'

BASE = 'https://github.com/notofonts/noto-cjk/raw/main/Sans/SubsetOTF'

# (archivo original, de dónde bajarlo, idioma cuya lista de signos se usa,
#  nombre del recorte)
TRABAJOS = [
    ('NotoSansJP-Regular.otf', f'{BASE}/JP/NotoSansJP-Regular.otf', 'ja', 'NotoSansJP-Cuerpo.otf'),
    ('NotoSansJP-Bold.otf', f'{BASE}/JP/NotoSansJP-Bold.otf', 'ja', 'NotoSansJP-CuerpoBold.otf'),
    ('NotoSansSC-Regular.otf', f'{BASE}/SC/NotoSansSC-Regular.otf', 'zh-Hans', 'NotoSansSC-Cuerpo.otf'),
    ('NotoSansSC-Bold.otf', f'{BASE}/SC/NotoSansSC-Bold.otf', 'zh-Hans', 'NotoSansSC-CuerpoBold.otf'),
]


def signos(idioma):
    """Los codepoints de `fonts/glifos_<idioma>.txt`, como los quiere pyftsubset."""
    lista = SALIDA / f'glifos_{idioma}.txt'
    if not lista.exists():
        sys.exit(f'Falta {lista}. Corré antes: dart run bin/export_glifos.dart')
    return ','.join(
        f'U+{l.strip()}' for l in lista.read_text().splitlines() if l.strip()
    )


def bajar(nombre, url):
    destino = FUENTE / nombre
    if destino.exists():
        return destino
    FUENTE.mkdir(parents=True, exist_ok=True)
    print(f'  bajando {nombre}…')
    urllib.request.urlretrieve(url, destino)
    return destino


def main():
    try:
        import fontTools  # noqa: F401
    except ImportError:
        sys.exit('Falta fonttools: python3 -m pip install fonttools brotli')

    for original, url, idioma, recorte in TRABAJOS:
        entrada = bajar(original, url)
        salida = SALIDA / recorte
        subprocess.run(
            [
                sys.executable, '-m', 'fontTools.subset', str(entrada),
                f'--unicodes={signos(idioma)}',
                f'--output-file={salida}',
                # El nombre de familia del recorte no importa —quien manda es
                # el `family:` de pubspec.yaml— pero dejarlo con el nombre
                # original hace que el archivo se explique solo si alguien lo
                # abre.
                '--name-IDs=*',
                '--layout-features=*',
                '--notdef-outline',
            ],
            check=True,
        )
        antes = entrada.stat().st_size / 1e6
        despues = salida.stat().st_size / 1e6
        print(f'{recorte}: {antes:.1f} MB → {despues:.2f} MB  ({idioma})')


if __name__ == '__main__':
    main()
