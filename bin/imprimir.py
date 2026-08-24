#!/usr/bin/env python3
"""Genera los archivos listos para imprenta desde el arte de la app.

    python3 bin/imprimir.py

El problema que resuelve: el arte de `app/assets/cartas/` NO tiene sangrado.
La cenefa dorada llega casi al borde del JPG —quedan unos 15 px de crema— y
toda imprenta pide 3 mm de sangrado y corta con ±0,5 mm de tolerancia. Mandado
tal cual, la guillotina te come la cenefa de un lado sí y del otro no.

La salida NO es recortar, que perdería marco. Es componer cada carta en un
lienzo más grande y extender el papel hacia afuera. Sale gratis porque la
proporción del arte (0,6321) y la del corte bridge (0,6404) casi coinciden: el
arte entra entero por alto y sobran 0,38 mm de crema a los costados.

El sangrado se genera espejando la tira del borde, no rellenando con un color
plano: así se continúa la textura de papel y el empalme no se ve ni buscándolo.

La salida es JPEG y no PNG a propósito: `imprenta/` embebe estos archivos en el
PDF **copiando los bytes tal cual**, sin decodificar. Un PNG obligaría a
recomprimir en el navegador —una segunda generación de pérdida que nadie
controla— y pesa tres veces más. Con `subsampling=0` el croma queda entero,
que es donde se nota la cenefa dorada sobre el crema.

Sólo necesita Pillow (`pip3 install pillow`), no ImageMagick.
"""

import json
from collections import Counter
from pathlib import Path

from PIL import Image

DPI = 300
MM = DPI / 25.4  # 11,811 px por mm

CORTE_MM = (57, 89)  # bridge estándar
SANGRADO_MM = 3

# Los jefes tienen su propio troquel. No es capricho: en la mesa el giro de 90°
# no alcanzaba para que se sintieran distintos.
#
# 112x70 y no el tarot 70x120 porque el arte de jefe es 1620x1024 —proporción
# 1,582— y el tarot pide 1,714. Como la cenefa dorada ya viene pegada al borde
# de la imagen, recortarla se come la cenefa y dejar franjas de crema a los
# costados deja el marco flotando. 112x70 respeta la proporción del arte al
# milímetro, y aun así es 55 % más de superficie que los 89x57 de antes.
CORTE_POR_ROL = {
    "jefe": (112, 70),
    "dorso_jefe": (112, 70),
}

# Calidad de la única generación de pérdida que agregamos. 4:4:4 (subsampling
# 0) porque el arte fuente ya viene 4:2:0: perder croma dos veces sí se ve.
CALIDAD = 95

RAIZ = Path(__file__).resolve().parent.parent
CARTAS = RAIZ / "app" / "assets" / "cartas"
COMIC = RAIZ / "app" / "assets" / "comic"
SALIDA = RAIZ / "print"

# El lado largo de una viñeta impresa en el librillo A5: 130 mm a 300 dpi.
# La página tiene 148 mm de ancho y 14 de margen, así que 120 mm de columna;
# 130 deja aire para las viñetas que se sacan un poco al margen.
VINETA_PX = round(130 * DPI / 25.4)
# Las viñetas son ilustración, no cenefa contra un corte: 92 alcanza y pesa
# la mitad. El arte fuente son 59 MB de PNG.
CALIDAD_VINETA = 92

# Piezas que no son naipes y viven fuera de `app/assets/cartas`.
#
# No pasan por el espejado de bordes: su proporción ya coincide con la de la
# pieza con sangrado, así que se escalan directo y el recorte es de un píxel.
#
# El tercer valor dice si hay que girar el original 90° antes de encuadrar. El
# dorso del jefe lo necesita: `DorsoCarta.png` es vertical (1021x1540) y la
# pieza es apaisada. Sin girarlo, cubrir la caja le comería el 57 % del alto y
# se perdería la cenefa del mandala; girado primero, el recorte es del 3 %.
SUELTAS = {
    "reverso": (RAIZ / "Assets" / "Cards" / "DorsoCarta.png", (63, 95), False),
    "reverso_jefe": (RAIZ / "Assets" / "Cards" / "DorsoCarta.png", (118, 76), True),
    "tapa_caja": (RAIZ / "Assets" / "Imprimir" / "TapaCajaConLogo.png", (78, 122), False),
}

# Piezas cuyo tamaño físico lo decide la imposición, no este script.
#
# La ficha se corta redonda y el tablero se escala al ancho que entre en la
# hoja, así que acá sólo se normalizan: aplanar el alfa y sacarles el fondo
# del render. La medida en mm se elige en la web.
LIBRES = {
    # (archivo, cómo normalizarlo)
    "ficha_energia": (RAIZ / "Assets" / "Imprimir" / "Ficha.png", "redonda"),
    "tablero_energia": (RAIZ / "Assets" / "Imprimir" / "TableroEnergia.png", "hoja"),
}

# El crema del juego, para aplanar transparencias. Imprimir sobre papel no
# tiene canal alfa: lo que no se pinta queda del color del papel.
CREMA = (247, 241, 225)

# Cuántas copias de cada diseño pedirle a la imprenta. Las que no figuran van
# de a una. Sale de `mecMazoInicial` en app/lib/mecanica.dart.
COPIAS = {
    "inicial_puno_torpe": 8,
    "inicial_postura_flamenco": 4,
    "inicial_patada_descuidada": 3,
    "inicial_respiracion_agitada": 3,
    "inicial_duda_existencial": 2,
}


def px(mm: float) -> int:
    return round(mm * MM)


def espejar_borde(im: Image.Image, borde: int) -> Image.Image:
    """Extiende [im] [borde] px hacia los cuatro lados, espejando la orilla.

    Dos pasadas: primero arriba y abajo sobre la imagen original, después los
    costados sobre el resultado ya alto. Hacerlo en un solo paso dejaría las
    cuatro esquinas vacías.
    """
    w, h = im.size

    alto = Image.new("RGB", (w, h + borde * 2))
    alto.paste(im.crop((0, 0, w, borde)).transpose(Image.FLIP_TOP_BOTTOM), (0, 0))
    alto.paste(im, (0, borde))
    alto.paste(
        im.crop((0, h - borde, w, h)).transpose(Image.FLIP_TOP_BOTTOM),
        (0, borde + h),
    )

    w2, h2 = alto.size
    lleno = Image.new("RGB", (w2 + borde * 2, h2))
    lleno.paste(
        alto.crop((0, 0, borde, h2)).transpose(Image.FLIP_LEFT_RIGHT), (0, 0)
    )
    lleno.paste(alto, (borde, 0))
    lleno.paste(
        alto.crop((w2 - borde, 0, w2, h2)).transpose(Image.FLIP_LEFT_RIGHT),
        (borde + w2, 0),
    )
    return lleno


def crema(im: Image.Image) -> tuple:
    """El crema del propio borde, para el relleno lateral de 4 px."""
    w, h = im.size
    muestras = [im.getpixel((x, y)) for x in range(0, w, 5) for y in (1, h - 2)]
    muestras += [im.getpixel((x, y)) for y in range(0, h, 5) for x in (1, w - 2)]
    return Counter(muestras).most_common(1)[0][0]


def componer(origen: Path, destino: Path, corte_mm: tuple = CORTE_MM) -> tuple:
    im = Image.open(origen).convert("RGB")

    # Si el arte y el troquel no coinciden en orientación, manda el arte: es
    # más barato transponer la medida que rotar el dibujo.
    corte_w, corte_h = corte_mm
    if (im.width > im.height) != (corte_w > corte_h):
        corte_w, corte_h = corte_h, corte_w
    borde = px(SANGRADO_MM)
    # El tamaño con sangrado manda y la caja de corte se deriva de él. Al revés
    # —redondeando cada medida por separado— el lienzo queda 1 px corto.
    total = (px(corte_w + SANGRADO_MM * 2), px(corte_h + SANGRADO_MM * 2))
    caja = (total[0] - borde * 2, total[1] - borde * 2)

    # ENTRA ENTERO, no se recorta: escala para caber dentro de la caja de
    # corte. La proporción es casi la misma, así que el hueco es de 4 px.
    escala = min(caja[0] / im.width, caja[1] / im.height)
    arte = im.resize(
        (round(im.width * escala), round(im.height * escala)), Image.LANCZOS
    )

    # El arte llevado exactamente a la caja de corte, rellenando el sobrante
    # con el crema del propio borde. Recién sobre eso se espeja el sangrado.
    trim = Image.new("RGB", caja, crema(im))
    trim.paste(arte, ((caja[0] - arte.width) // 2, (caja[1] - arte.height) // 2))

    final = espejar_borde(trim, borde)
    assert final.size == total, f"{final.size} != {total}"

    guardar(final, destino)
    return total


def guardar(im: Image.Image, destino: Path) -> None:
    """Escribe el JPEG que la imposición va a copiar byte a byte.

    `progressive=False` es explícito y no decorativo: el filtro /DCTDecode de
    PDF es baseline, y aunque Acrobat tolere un progresivo, hay RIP de imprenta
    que lo rechazan. Mejor que no salga de acá.
    """
    destino.parent.mkdir(parents=True, exist_ok=True)
    im.save(
        destino,
        "JPEG",
        quality=CALIDAD,
        subsampling=0,
        progressive=False,
        optimize=True,
        dpi=(DPI, DPI),
    )


def componer_suelta(origen: Path, destino: Path, corte_mm: tuple,
                    girar: bool = False) -> tuple:
    """El dorso y la tapa: ya vienen en la proporción final, con su sangrado.

    A diferencia de las cartas, acá NO se espeja el borde. Estas dos piezas
    fueron dibujadas a la medida de la pieza sangrada —el dorso da 0,6630 y
    63x95 da 0,6632— así que se escalan para CUBRIR y lo que sobra es un
    píxel. Espejar encima sería inventar un sangrado que ya existe.
    """
    im = Image.open(origen).convert("RGB")
    if girar:
        im = im.transpose(Image.ROTATE_90)
    total = (px(corte_mm[0]), px(corte_mm[1]))

    escala = max(total[0] / im.width, total[1] / im.height)
    grande = im.resize(
        (round(im.width * escala), round(im.height * escala)), Image.LANCZOS
    )
    x = (grande.width - total[0]) // 2
    y = (grande.height - total[1]) // 2
    guardar(grande.crop((x, y, x + total[0], y + total[1])), destino)
    return total


def aplanar(im: Image.Image) -> Image.Image:
    """Quita el canal alfa componiendo sobre el crema del juego."""
    if im.mode not in ("RGBA", "LA", "P"):
        return im.convert("RGB")
    im = im.convert("RGBA")
    fondo = Image.new("RGB", im.size, CREMA)
    fondo.paste(im, mask=im.split()[3])
    return fondo


def sacar_marco(im: Image.Image, tolerancia: int = 34) -> Image.Image:
    """Recorta el fondo plano que rodea a la pieza.

    El tablero viene renderizado como una hoja de papel apoyada sobre un fondo
    gris oscuro. Ese gris es del render, no de la pieza: impreso saldría como
    un marco sucio alrededor del papel. Se detecta por el color de la esquina
    y se recorta hasta donde deja de aparecer.

    Si la esquina ya es del mismo color que el centro —o sea, no hay marco— no
    toca nada.
    """
    im = im.convert("RGB")
    w, h = im.size
    fondo = im.getpixel((1, 1))
    centro = im.getpixel((w // 2, h // 2))
    parecido = lambda p: all(abs(a - b) <= tolerancia for a, b in zip(p, fondo))
    if parecido(centro):
        return im

    # Una línea es "marco" si casi todos sus píxeles son del color del fondo.
    # Casi, y no todos: el papel tiene bordes rasgados y alguna fibra suelta
    # invade el fondo, y exigir el 100 % dejaría el marco entero.
    def marco_col(x):
        col = [im.getpixel((x, y)) for y in range(0, h, 16)]
        return sum(map(parecido, col)) >= len(col) * 0.9

    def marco_fila(y):
        fila = [im.getpixel((x, y)) for x in range(0, w, 16)]
        return sum(map(parecido, fila)) >= len(fila) * 0.9

    izq = next((x for x in range(w // 3) if not marco_col(x)), 0)
    der = next((x for x in range(w - 1, w * 2 // 3, -1) if not marco_col(x)), w - 1)
    arr = next((y for y in range(h // 3) if not marco_fila(y)), 0)
    aba = next((y for y in range(h - 1, h * 2 // 3, -1) if not marco_fila(y)), h - 1)
    return im.crop((izq, arr, der + 1, aba + 1))


def encuadrar(im: Image.Image, margen: float = 0.04) -> Image.Image:
    """Centra la pieza en un cuadrado, con algo de aire alrededor.

    La ficha se corta REDONDA, así que lo que importa es que el disco quede
    exactamente en el centro: si está corrido, el círculo de corte le muerde
    un borde. Se busca la caja de lo que no es fondo, se toma el lado mayor y
    se recorta un cuadrado centrado en ella. El aire que sobra es el sangrado.
    """
    im = im.convert("RGB")
    fondo = im.getpixel((1, 1))
    parecido = lambda p: all(abs(a - b) <= 30 for a, b in zip(p, fondo))

    w, h = im.size
    xs = [x for x in range(0, w, 4)
          if any(not parecido(im.getpixel((x, y))) for y in range(0, h, 8))]
    ys = [y for y in range(0, h, 4)
          if any(not parecido(im.getpixel((x, y))) for x in range(0, w, 8))]
    if not xs or not ys:
        return im

    cx = (xs[0] + xs[-1]) / 2
    cy = (ys[0] + ys[-1]) / 2
    lado = max(xs[-1] - xs[0], ys[-1] - ys[0]) * (1 + margen * 2) / 2

    caja = Image.new("RGB", (round(lado * 2), round(lado * 2)), fondo)
    caja.paste(im, (round(lado - cx), round(lado - cy)))
    return caja


def vinetas() -> list:
    """Prepara el arte del cómic para el librillo impreso.

    Tres cosas, y ninguna es opcional:

    1. Detectar el formato POR LOS BYTES. `01_templo_amanecer.png` no es un
       PNG: es un JPEG con la extensión mentida. Confiar en el nombre acá
       significa que Pillow lo abre igual pero cualquier herramienta que
       decida por extensión se equivoca.
    2. Aplanar el alfa sobre el crema, porque el papel no tiene canal alfa.
    3. Bajar a la medida impresa. Sin esto se embeben 59 MB de PNG para
       imprimir a 130 mm.
    """
    if not COMIC.is_dir():
        return []
    fuera = []
    for origen in sorted(COMIC.iterdir()):
        if origen.suffix.lower() not in (".png", ".jpg", ".jpeg"):
            continue
        with origen.open("rb") as fh:
            cabecera = fh.read(4)
        real = "PNG" if cabecera[:4] == b"\x89PNG" else "JPEG"

        im = aplanar(Image.open(origen))
        # Nunca se amplía: agrandar píxeles no agrega detalle, sólo peso.
        escala = min(1.0, VINETA_PX / max(im.size))
        if escala < 1:
            im = im.resize(
                (round(im.width * escala), round(im.height * escala)),
                Image.LANCZOS,
            )
        destino = SALIDA / "comic" / f"{origen.stem}.jpg"
        destino.parent.mkdir(parents=True, exist_ok=True)
        im.save(destino, "JPEG", quality=CALIDAD_VINETA, subsampling=0,
                progressive=False, optimize=True, dpi=(DPI, DPI))
        fuera.append({
            "archivo": f"comic/{origen.stem}.jpg",
            "rol": "vineta",
            "copias": 0,
            "ancho": im.width,
            "alto": im.height,
            "corte_mm": None,
            "sangrado_mm": 0,
            # Se guarda el nombre original porque es la clave con la que el
            # texto del cómic viaja desde Dart. Y el formato real, para que
            # quede constancia de que la extensión miente en al menos uno.
            "origen": origen.name,
            "formato": real,
        })
    return fuera


def rol_de(nombre: str) -> str:
    """Para qué sirve cada archivo, que es lo que la imposición necesita saber.

    Se decide acá y viaja en el manifiesto en vez de que la web lo adivine por
    el nombre: el arte no es homogéneo —hay archivos que pasaron por Canva y
    otros no— y una heurística de nombres se rompe en silencio.
    """
    if nombre == "reverso":
        return "dorso"
    if nombre == "reverso_jefe":
        return "dorso_jefe"
    if nombre == "tapa_caja":
        return "tapa"
    if nombre == "ficha_energia":
        return "ficha"
    if nombre == "tablero_energia":
        return "tablero"
    if nombre.startswith("jefe"):
        return "jefe"
    if nombre.startswith("inicial_"):
        return "inicial"
    if nombre.startswith("can"):
        return "cansancio"
    return "peligro"


def main() -> None:
    if not CARTAS.is_dir():
        raise SystemExit(f"No encuentro {CARTAS}")

    SALIDA.mkdir(exist_ok=True)
    tirada, verticales, apaisadas = [], 0, 0
    manifiesto = []

    for origen in sorted(CARTAS.glob("*.jpg")):
        nombre = origen.stem
        # El rol se decide ANTES de componer, porque ahora elige el troquel.
        rol = rol_de(nombre)
        corte = CORTE_POR_ROL.get(rol, CORTE_MM)
        tam = componer(origen, SALIDA / f"{nombre}.jpg", corte)
        if tam[0] > tam[1]:
            apaisadas += 1
            corte = (max(corte), min(corte))
        else:
            verticales += 1
            corte = (min(corte), max(corte))
        copias = COPIAS.get(nombre, 1)
        tirada.append((nombre, copias, f"{tam[0]}x{tam[1]}", corte))
        manifiesto.append({
            "archivo": f"{nombre}.jpg",
            "rol": rol,
            "copias": copias,
            "ancho": tam[0],
            "alto": tam[1],
            "corte_mm": list(corte),
            "sangrado_mm": SANGRADO_MM,
        })

    # El dorso y la tapa, que no son naipes pero van al mismo pliego.
    for nombre, (origen, sangrada, girar) in SUELTAS.items():
        if not origen.is_file():
            print(f"  falta {origen.name}, se saltea")
            continue
        tam = componer_suelta(origen, SALIDA / f"{nombre}.jpg", sangrada, girar)
        # `SUELTAS` da la medida CON sangrado; el manifiesto habla de corte.
        corte = tuple(round(v - SANGRADO_MM * 2) for v in sangrada)
        manifiesto.append({
            "archivo": f"{nombre}.jpg",
            "rol": rol_de(nombre),
            "copias": 0,  # el dorso se repite tantas veces como cartas haya
            "ancho": tam[0],
            "alto": tam[1],
            "corte_mm": list(corte),
            "sangrado_mm": SANGRADO_MM,
        })

    # La ficha y el tablero: se normalizan y viajan enteros. Su medida en mm
    # la elige la imposición, porque depende de la hoja y de la caja.
    for nombre, (origen, modo) in LIBRES.items():
        if not origen.is_file():
            print(f"  falta {origen.name}, se saltea")
            continue
        im = aplanar(Image.open(origen))
        im = encuadrar(im) if modo == "redonda" else sacar_marco(im)
        guardar(im, SALIDA / f"{nombre}.jpg")
        manifiesto.append({
            "archivo": f"{nombre}.jpg",
            "rol": rol_de(nombre),
            "copias": 0,
            "ancho": im.width,
            "alto": im.height,
            # La ficha y el tablero eligen su medida en la web, no acá.
            "corte_mm": None,
            "sangrado_mm": 0,
        })

    # Las viñetas del cómic, para el librillo. No son naipes ni entran en
    # ningún pliego de cartas: viajan en el manifiesto para poder verificar
    # que no falte ninguna contra el texto que exporta Dart.
    vin = vinetas()
    manifiesto.extend(vin)

    total = sum(c for _, c, _, _ in tirada)

    # Fuente de verdad única para `imprenta/`. Sin esto, la tabla de copias
    # queda duplicada en Python y en JS y se desincroniza en la primera
    # partida que se rebalancee.
    (SALIDA / "manifiesto.json").write_text(
        json.dumps(
            {
                "dpi": DPI,
                "corte_mm": list(CORTE_MM),
                "sangrado_mm": SANGRADO_MM,
                "naipes": total,
                "piezas": manifiesto,
            },
            indent=2,
            ensure_ascii=False,
        ),
        encoding="utf-8",
    )
    lista = SALIDA / "LISTA_DE_TIRADA.txt"
    with lista.open("w", encoding="utf-8") as f:
        f.write("EL GUARDIÁN DEL TEMPLO — lista de tirada\n")
        f.write(f"Corte {CORTE_MM[0]}x{CORTE_MM[1]} mm · sangrado "
                f"{SANGRADO_MM} mm por lado · {DPI} dpi\n\n")
        f.write(f"{'archivo':34} {'copias':>7}  medida\n")
        f.write("-" * 60 + "\n")
        for nombre, copias, tam, corte in tirada:
            f.write(f"{nombre:34} {copias:>7}  {tam} px  "
                    f"({corte[0]}x{corte[1]} mm)\n")
        f.write("-" * 60 + "\n")
        f.write(f"{'TOTAL':34} {total:>7}  naipes\n\n")
        f.write("Piezas que no son naipes:\n")
        f.write("  · reverso.jpg              1 diseño, detrás de los naipes de 57x89\n")
        f.write("  · reverso_jefe.jpg         1 diseño, detrás de los jefes de 112x70\n")
        f.write("  · tapa_caja.jpg            1, corte 72x116 mm\n")
        f.write("  · tablero_energia.jpg      1, el ancho se elige en la web\n")
        f.write("  · ficha_energia.jpg        1 diseño, tantas copias como quieras\n")

    print(f"{len(tirada)} diseños → {SALIDA}")
    print(f"  {verticales} verticales {px(CORTE_MM[0] + 6)}x{px(CORTE_MM[1] + 6)} px "
          f"({CORTE_MM[0]}x{CORTE_MM[1]} mm)")
    jefe = CORTE_POR_ROL["jefe"]
    print(f"  {apaisadas} apaisadas  {px(jefe[0] + 6)}x{px(jefe[1] + 6)} px "
          f"({jefe[0]}x{jefe[1]} mm)")
    print(f"  {total} naipes en total · ver {lista.name}")
    if vin:
        pesa = sum((SALIDA / v["archivo"]).stat().st_size for v in vin)
        mentidas = [v["origen"] for v in vin
                    if v["formato"] == "JPEG" and v["origen"].endswith(".png")]
        print(f"  {len(vin)} viñetas del cómic → print/comic/ ({pesa / 1e6:.1f} MB)")
        for m in mentidas:
            print(f"    ojo: {m} dice .png pero es un JPEG")

    viejos = list(SALIDA.glob("*.png"))
    if viejos:
        print(f"\n  Quedaron {len(viejos)} .png de la tirada anterior.")
        print("  Ya no se usan: la imposición lee los .jpg. Se pueden borrar.")


if __name__ == "__main__":
    main()
