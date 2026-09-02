#!/usr/bin/env python3
"""Convierte el arte de la app a WebP para que el binario no pese 87 MB.

El problema que resuelve: `app/assets/` cumple dos papeles a la vez. Es la
**única copia** del arte terminado —las 50 cartas salieron de Canva y los 22
paneles del cómic de una generación que no se puede repetir igual— y es
además lo que Flutter empaqueta adentro del `.ipa`. Recomprimir en el lugar
arruinaría lo primero para arreglar lo segundo.

Y no se pueden ni siquiera mover:

  · `bin/imprimir.py` lee `app/assets/cartas` y `app/assets/comic` para armar
    el print & play a 300 dpi. El arte de imprenta sale de acá.
  · Los tres tomos congelados del libro (`cuento/libro/final/*.json`) tienen
    doce rutas `app/assets/comic/*.png` **grabadas adentro**. Renombrar un
    panel obliga a descongelar un tomo, y los tomos no se descongelan.

Así que los originales se quedan donde están y esto escribe al lado una copia
liviana en `app/assets/movil/`, que es lo único que declara `pubspec.yaml`.
De 87 MB a unos 17.

    python3 bin/aligerar.py            # sólo lo que cambió
    python3 bin/aligerar.py --forzar   # todo de nuevo

Sólo necesita Pillow (`pip3 install pillow`), igual que `imprimir.py`.
"""

import argparse
import sys
from pathlib import Path

from PIL import Image

RAIZ = Path(__file__).resolve().parent.parent
ASSETS = RAIZ / "app" / "assets"
DESTINO = ASSETS / "movil"

# Calidad por familia. Los tres números están medidos, no elegidos de memoria:
# se recortó la banda de texto de una carta a tamaño real y se comparó contra
# el original. A 72 el nombre de la carta y la línea de regla —que son texto
# horneado en el arte, lo peor que hay para un codificador con pérdida— ya
# salen sin un artefacto visible. 78 deja margen de sobra.
#
# La interfaz va más arriba porque son piezas 9-slice: el estirado amplifica
# cualquier suciedad del borde. Y aun a 90 el ahorro es brutal, porque eran
# PNG sin pérdida (`marco.png` pasa de 1,43 MB a 0,11).
FAMILIAS = {
    "comic": 82,
    "cartas": 78,
    "ui": 90,
}

# Lo que no viaja al teléfono.
#
# `background.jpeg` es un asset muerto: no lo nombra ni una línea de `lib/`.
# El fondo del patio que sí se usa es `background_home.jpg`, que es otro
# archivo. Entró al binario porque `pubspec.yaml` declaraba el directorio
# entero, y así estuvo 876 KB de viaje.
EXCLUIDOS = {"LEEME.txt", ".DS_Store", "background.jpeg"}

EXTENSIONES = {".png", ".jpg", ".jpeg"}


def formato_real(ruta: Path) -> str:
    """El formato POR LOS BYTES, no por la extensión.

    `comic/01_templo_amanecer.png` es un JPEG con nombre de PNG —el mismo
    despiste que ya documenta `imprimir.py`—. Abrirlo con Pillow es la única
    manera de saber la verdad, y la verdad importa porque es el panel que
    demuestra el argumento: pesa 1,0 MB donde sus veintiún hermanos pesan
    entre 2,2 y 3,2.
    """
    with Image.open(ruta) as im:
        return im.format or "?"


def convertir(origen: Path, destino: Path, calidad: int) -> tuple[int, int, bool]:
    """Devuelve (bytes antes, bytes después, si conservó alfa)."""
    antes = origen.stat().st_size

    with Image.open(origen) as im:
        # Un modo con alfa hay que conservarlo: `marco`, `home`, `paper` y el
        # personaje se dibujan encima del fondo del patio, y sin canal alfa
        # aparecen dentro de un rectángulo blanco. WebP con pérdida sí guarda
        # alfa —JPEG no—, y ésa es la razón de fondo para elegir WebP y no
        # JPEG para todo.
        con_alfa = im.mode in ("RGBA", "LA") or "transparency" in im.info
        im = im.convert("RGBA" if con_alfa else "RGB")

        destino.parent.mkdir(parents=True, exist_ok=True)
        # `method=6` es el buscador más lento del codificador. Tarda unos
        # segundos por imagen y saca entre un 5 y un 10 % más que el default.
        # Esto corre a mano y muy de vez en cuando: la lentitud es gratis.
        im.save(destino, "WEBP", quality=calidad, method=6, exact=False)

    return antes, destino.stat().st_size, con_alfa


def mb(n: int) -> str:
    return f"{n / 1_048_576:6.2f} MB"


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--forzar",
        action="store_true",
        help="reconvierte todo, incluso lo que ya está al día",
    )
    args = ap.parse_args()

    if not ASSETS.is_dir():
        print(f"No encuentro {ASSETS}", file=sys.stderr)
        return 1

    total_antes = total_despues = 0
    convertidos = saltados = 0

    for familia, calidad in FAMILIAS.items():
        carpeta = ASSETS / familia
        if not carpeta.is_dir():
            print(f"  ojo: no existe {carpeta}")
            continue

        fuentes = sorted(
            f
            for f in carpeta.iterdir()
            if f.is_file()
            and f.name not in EXCLUIDOS
            and f.suffix.lower() in EXTENSIONES
        )

        print(f"\n{familia}/  ({len(fuentes)} archivos, calidad {calidad})")

        antes_f = despues_f = 0
        for origen in fuentes:
            destino = DESTINO / familia / f"{origen.stem}.webp"

            al_dia = (
                destino.exists()
                and destino.stat().st_mtime >= origen.stat().st_mtime
            )
            if al_dia and not args.forzar:
                antes_f += origen.stat().st_size
                despues_f += destino.stat().st_size
                saltados += 1
                continue

            antes, despues, alfa = convertir(origen, destino, calidad)
            antes_f += antes
            despues_f += despues
            convertidos += 1

            marca = " ·alfa" if alfa else ""
            fmt = formato_real(origen)
            aviso = "  ⚠ dice .png y es JPEG" if fmt == "JPEG" and origen.suffix == ".png" else ""
            print(
                f"  {origen.name:<34} {mb(antes)} → {mb(despues)}"
                f"  ({100 * despues // max(antes, 1):3d} %){marca}{aviso}"
            )

        total_antes += antes_f
        total_despues += despues_f
        print(f"  {'─' * 34} {mb(antes_f)} → {mb(despues_f)}")

    # El audio y `config.json` no pasan por acá: se declaran directo desde
    # `assets/` y ya pesan poco. Los WAV están a 11 kHz mono y son pistas
    # sintéticas de relleno (ver `lib/audio.dart`); comprimirlas ahora es
    # trabajo que se tira cuando lleguen las definitivas.
    audio = ASSETS / "audio"
    peso_audio = sum(f.stat().st_size for f in audio.glob("*")) if audio.is_dir() else 0

    print(f"\n{'=' * 52}")
    print(f"  arte     {mb(total_antes)} → {mb(total_despues)}")
    print(f"  audio    {mb(peso_audio)} → {mb(peso_audio)}  (sin tocar)")
    print(f"  bundle   {mb(total_despues + peso_audio)}")
    print(f"\n  {convertidos} convertidos, {saltados} ya estaban al día.")
    print(f"  Salida: {DESTINO.relative_to(RAIZ)}/")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
