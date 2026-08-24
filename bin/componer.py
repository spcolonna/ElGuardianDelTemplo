#!/usr/bin/env python3
"""Rearma una carta desde las piezas sueltas, para probar la escala tipográfica.

    python3 bin/componer.py --carta alba1

El problema que resuelve: el texto de las cartas está horneado en los JPG de
`app/assets/cartas/`, que salieron de Canva. No hay ni una línea de código en
todo el repo que lo dibuje, así que "agrandar la fuente" no es una edición:
hay que rearmar la carta.

Y se puede, porque las ilustraciones desnudas —sin marco y sin una sola letra—
sí están en el repo: `Assets/Peligros/`, `Assets/Skills/`, `Assets/MazoInicial/`,
`Assets/Cansancio/` y `Assets/Jefes/`. Esto NO compone encima de la carta
terminada: la vuelve a armar desde la ilustración pelada, así que no hay texto
viejo que se superponga.

Es una PRUEBA, deliberadamente de a una carta. La decisión de extenderlo a las
65 se toma mirando `print/muestra_<carta>_comparacion.jpg`, no antes.

Sólo necesita Pillow.
"""

import argparse
import csv
import re
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

RAIZ = Path(__file__).resolve().parent.parent
ASSETS = RAIZ / "Assets"
FUENTES = RAIZ / "app" / "fonts"
SALIDA = RAIZ / "print"

DPI = 300
MM = DPI / 25.4
CORTE_MM = (57, 89)
SANGRADO_MM = 3

# La paleta oficial (app/lib/ui_kit.dart).
CREMA = (247, 241, 225)
TINTA = (74, 55, 40)
MADERA_OSCURA = (138, 95, 51)

# ---------------------------------------------------------------- tipografía
#
# ESTA TABLA ES EL ENTREGABLE. Lo demás es andamio para poder verla impresa.
#
# El piso es 7 pt: abajo de eso un texto de carta deja de leerse a la distancia
# normal de mesa. Medido sobre `alba1.jpg`, el texto de sabor de hoy ronda los
# 5 pt. Si un texto no entra a 7 pt se acorta el TEXTO, nunca el cuerpo.
PT = {
    "nombre": 12.0,
    "efecto": 8.5,
    "sabor": 7.5,
    "poder": 28.0,
    "dato": 15.0,
    "fase": 8.0,
}


def px(mm: float) -> int:
    return round(mm * MM)


def pt(puntos: float) -> int:
    return round(puntos * DPI / 72)


def fuente(archivo: str, puntos: float) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(str(FUENTES / archivo), pt(puntos))


TITULO = "PatrickHandSC-Regular.ttf"
CUERPO = "AtkinsonHyperlegible-Regular.ttf"
CUERPO_NEGRITA = "AtkinsonHyperlegible-Bold.ttf"


def alto_linea(f: ImageFont.FreeTypeFont) -> int:
    subir, bajar = f.getmetrics()
    return subir + bajar


def partir(texto: str, f: ImageFont.FreeTypeFont, ancho: int) -> list:
    """Corte de línea codicioso. Una palabra más larga que la caja se deja pasar."""
    lineas, actual = [], ""
    for palabra in texto.split():
        prueba = f"{actual} {palabra}".strip()
        if f.getbbox(prueba)[2] <= ancho or not actual:
            actual = prueba
        else:
            lineas.append(actual)
            actual = palabra
    if actual:
        lineas.append(actual)
    return lineas


def centrado(d: ImageDraw.ImageDraw, texto, f, y: int, caja, color) -> int:
    """Escribe centrado en [caja] = (x0, x1) y devuelve el y siguiente."""
    x0, x1 = caja
    for linea in texto if isinstance(texto, list) else [texto]:
        ancho = d.textbbox((0, 0), linea, font=f)[2]
        d.text((x0 + (x1 - x0 - ancho) // 2, y), linea, font=f, fill=color)
        y += alto_linea(f)
    return y


def cubrir(im: Image.Image, caja: tuple) -> Image.Image:
    """Escala para CUBRIR la caja y recorta el sobrante, centrado."""
    escala = max(caja[0] / im.width, caja[1] / im.height)
    grande = im.resize(
        (max(caja[0], round(im.width * escala)), max(caja[1], round(im.height * escala))),
        Image.LANCZOS,
    )
    x = (grande.width - caja[0]) // 2
    y = (grande.height - caja[1]) // 2
    return grande.crop((x, y, x + caja[0], y + caja[1]))


def velo(tam: tuple, alto_velo: int, difuminado: int) -> Image.Image:
    """El velo crema sobre el que va el texto, con el borde superior difuminado.

    Es una banda translúcida y no una opaca a propósito: la ilustración se
    sigue leyendo por debajo y el texto no pierde contraste. Una banda maciza
    resuelve la legibilidad tapando el dibujo, que es justo lo que no se quiere.
    """
    mascara = Image.new("L", tam, 0)
    d = ImageDraw.Draw(mascara)
    # 88 % de opacidad; el difuminado se lo da el desenfoque del borde.
    d.rectangle([0, tam[1] - alto_velo, tam[0], tam[1]], fill=224)
    mascara = mascara.filter(ImageFilter.GaussianBlur(difuminado / 2))
    capa = Image.new("RGB", tam, CREMA)
    return capa, mascara


def medallon(archivo: str, diametro: int, numero: str) -> Image.Image:
    """El medallón con el número de Poder, en RGBA para pegarlo con su alfa."""
    im = Image.open(ASSETS / archivo).convert("RGBA")
    im = im.resize((diametro, diametro), Image.LANCZOS)
    d = ImageDraw.Draw(im)
    f = fuente(CUERPO_NEGRITA, PT["poder"])
    caja = d.textbbox((0, 0), numero, font=f)
    d.text(
        ((diametro - caja[2]) // 2 - caja[0], (diametro - caja[3]) // 2 - caja[1]),
        numero,
        font=f,
        fill=TINTA,
    )
    return im


def icono(archivo: str, alto: int) -> Image.Image:
    im = Image.open(ASSETS / archivo).convert("RGBA")
    escala = alto / im.height
    return im.resize((round(im.width * escala), alto), Image.LANCZOS)


# ------------------------------------------------------------------- mitades

BLEED = px(SANGRADO_MM)
SEGURO = px(4)                 # margen de seguridad hacia adentro del corte
BORDE = BLEED + SEGURO         # desde el canto del lienzo sangrado
RESPIRO = px(1.7)              # aire dentro del velo
CENEFA = BLEED + px(7)         # retiro para no meterse debajo del marco


def hueco(im: Image.Image) -> tuple:
    """Centro y radio del agujero interior de un medallón, en píxeles.

    Los medallones no vienen centrados ni son cuadrados —`BlueCircule.png` es
    956x662 y su agujero está por encima del centro geométrico—, así que
    escalarlos a un cuadrado los deforma y el número queda corrido. Esto lo
    mide: se inunda el alfa desde el borde, y lo transparente que queda sin
    inundar es el agujero.
    """
    alfa = im.getchannel("A").point(lambda v: 255 if v > 16 else 0)
    fuera = alfa.copy()
    ImageDraw.floodfill(fuera, (0, 0), 128, thresh=0)
    dentro = Image.eval(fuera, lambda v: 255 if v == 0 else 0)
    caja = dentro.getbbox()
    if caja is None:                       # sin agujero: al centro geométrico
        return im.width / 2, im.height / 2, min(im.size) / 4
    x0, y0, x1, y1 = caja
    return (x0 + x1) / 2, (y0 + y1) / 2, min(x1 - x0, y1 - y0) / 2


def medallon(archivo: str, numero: str) -> tuple:
    """Devuelve (imagen RGBA, cx, cy): el medallón y dónde cae su agujero."""
    im = Image.open(ASSETS / archivo).convert("RGBA")
    cx, cy, r = hueco(im)

    # Se escala por el AGUJERO, no por el lienzo: así el número entra igual en
    # los dos medallones aunque tengan proporciones distintas.
    f = fuente(CUERPO_NEGRITA, PT["poder"])
    caja = f.getbbox(numero)
    necesita = max(caja[2] - caja[0], caja[3] - caja[1]) * 1.55 / 2
    escala = necesita / r

    im = im.resize((round(im.width * escala), round(im.height * escala)), Image.LANCZOS)
    cx, cy = cx * escala, cy * escala

    d = ImageDraw.Draw(im)
    d.text((cx, cy), numero, font=f, fill=TINTA, anchor="mm")
    return im, cx, cy


def icono(archivo: str, alto: int) -> Image.Image:
    im = Image.open(ASSETS / archivo).convert("RGBA")
    escala = alto / im.height
    return im.resize((round(im.width * escala), alto), Image.LANCZOS)


def mitad(ilustracion: Path, bloques: list, medallon_arte: str, poder: str,
          datos: list, tam: tuple) -> Image.Image:
    """Una mitad de la carta: ilustración a sangre, velo, texto y medallón.

    La ilustración cubre el lienzo ENTERO, sangrado incluido. Por eso acá no
    se espeja ningún borde: el sangrado es dibujo de verdad, no una copia de
    la orilla. Espejar sería además desastroso, porque la cenefa dorada llega
    hasta el corte y quedaría duplicada a los costados.
    """
    base = cubrir(Image.open(ilustracion).convert("RGB"), tam)

    x0, x1 = BORDE, tam[0] - BORDE
    lineas = []
    for texto, f, color in bloques:
        for linea in partir(texto, f, x1 - x0):
            lineas.append((linea, f, color))

    alto_velo = sum(alto_linea(f) for _, f, _ in lineas) + RESPIRO * 2
    capa, mascara = velo(tam, alto_velo, px(2))
    base = Image.composite(capa, base, mascara)

    d = ImageDraw.Draw(base)
    y = tam[1] - alto_velo + RESPIRO
    for linea, f, color in lineas:
        y = centrado(d, linea, f, y, (x0, x1), color)

    med, _, _ = medallon(medallon_arte, poder)
    base.paste(med, (CENEFA - px(3), CENEFA - px(3)), med)

    if datos:
        _cajita(base, datos, tam)
    return base


def _cajita(base: Image.Image, datos: list, tam: tuple) -> None:
    """Daño y cartas gratis, arriba a la derecha. [datos] = [(icono, valor)]."""
    f = fuente(CUERPO_NEGRITA, PT["dato"])
    alto_icono = px(5)
    fila = max(alto_icono, alto_linea(f))
    ancho = alto_icono + px(2) + f.getbbox("00")[2] + px(3)
    alto = fila * len(datos) + px(3)
    x0, y0 = tam[0] - CENEFA - ancho, CENEFA

    caja = Image.new("RGBA", (ancho, alto), CREMA + (222,))
    base.paste(caja, (x0, y0), caja)

    d = ImageDraw.Draw(base)
    y = y0 + px(1.5)
    for archivo, valor in datos:
        ic = icono(archivo, alto_icono)
        base.paste(ic, (x0 + px(1.5), y + (fila - alto_icono) // 2), ic)
        d.text((x0 + px(1.5) + alto_icono + px(2), y + fila // 2),
               str(valor), font=f, fill=TINTA, anchor="lm")
        y += fila


def _hay(valor: str) -> bool:
    """El CSV escribe los efectos vacíos como raya, no como cadena vacía."""
    return valor.strip() not in ("", "-", "—", "–")


def en_palabras(efecto: str) -> str:
    """Cambia los emoji del CSV por palabras.

    El CSV usa 🃏, ⚡ y 👊 porque nació para la pantalla. Ninguna de las dos
    tipografías del juego tiene esos glifos, así que impresos salen como
    cuadraditos vacíos —se ve en la primera prueba—. Y aun con una fuente de
    emoji, un pictograma a 8,5 pt es justamente lo que no se lee: la carta
    tiene lugar de sobra para decirlo con todas las letras.
    """
    efecto = re.sub(r"([+−-]?\d+)\s*🃏", r"Roba \1", efecto)
    efecto = re.sub(r"([+−-]?\d+)\s*⚡", r"\1 Energía", efecto)
    efecto = re.sub(r"([+−-]?\d+)\s*👊", r"\1", efecto)
    return efecto.replace("Roba +", "Roba ")


def carta_partida(fila: dict, ilus_peligro: Path, ilus_tecnica: Path) -> Image.Image:
    """Arma la carta entera: peligro arriba, técnica abajo y rotada 180°."""
    total = (px(CORTE_MM[0] + SANGRADO_MM * 2), px(CORTE_MM[1] + SANGRADO_MM * 2))
    media = (total[0], total[1] // 2)

    f_nombre = fuente(TITULO, PT["nombre"])
    f_efecto = fuente(CUERPO_NEGRITA, PT["efecto"])
    f_sabor = fuente(CUERPO, PT["sabor"])
    f_fase = fuente(CUERPO_NEGRITA, PT["fase"])

    arriba = mitad(
        ilus_peligro,
        [(fila["peligro_nombre"].upper(), f_nombre, TINTA),
         (fila["mazo"].upper(), f_fase, MADERA_OSCURA)],
        "RedCircle.png",
        fila["peligro_poder"],
        [("Damage.png", fila["peligro_dano"]),
         ("Cards.png", fila["peligro_cartas_gratis"])],
        media,
    )

    bloques = [(fila["tecnica_nombre"].upper(), f_nombre, TINTA)]
    if _hay(fila["tecnica_efecto"]):
        bloques.append((en_palabras(fila["tecnica_efecto"]), f_efecto, MADERA_OSCURA))
    if _hay(fila["tecnica_texto_sabor"]):
        bloques.append((fila["tecnica_texto_sabor"], f_sabor, MADERA_OSCURA))
    abajo = mitad(ilus_tecnica, bloques, "BlueCircule.png",
                  fila["tecnica_poder"], [], media)

    hoja = Image.new("RGB", total, CREMA)
    hoja.paste(arriba, (0, 0))
    hoja.paste(abajo.transpose(Image.ROTATE_180), (0, media[1]))

    # La línea divisoria tiene que gritar: es lo único que evita que el jugador
    # sume el número de la mitad equivocada (DISENO_CARTAS.md, regla 1).
    ImageDraw.Draw(hoja).rectangle(
        [BLEED, media[1] - px(1), total[0] - BLEED, media[1] + px(1)], fill=TINTA
    )

    # El marco va dentro de la caja de CORTE, nunca en el sangrado: lo que cae
    # afuera se lo lleva la guillotina.
    trim = (total[0] - BLEED * 2, total[1] - BLEED * 2)
    marco = Image.open(ASSETS / "marco.png").convert("RGBA").resize(trim, Image.LANCZOS)
    hoja.paste(marco, (BLEED, BLEED), marco)
    return hoja


# ---------------------------------------------------------------------- main

CSV = RAIZ / "csv" / "templo" / "es" / "cartas_peligro_tecnica.csv"


def filas() -> list:
    with CSV.open(encoding="utf-8") as fh:
        return list(csv.DictReader(fh))


def buscar(clave: str):
    """Devuelve (fila, ilustración de peligro, ilustración de técnica).

    El índice de las ilustraciones es POSICIONAL: la fila n del CSV usa
    `Peligros/n.jpeg` y `Skills/n.jpeg`. Está verificado a ojo sólo para
    `alba1` —`Skills/1.jpeg` es exactamente la mitad inferior de `alba1.jpg`
    sin el texto—. Antes de extender esto a las 65 hay que comprobar el mapeo
    completo; si no cierra, la salida correcta es una columna en el CSV, no
    una tabla de excepciones acá.
    """
    todas = filas()
    for i, fila in enumerate(todas, start=1):
        if Path(fila["archivo"]).stem == clave:
            return fila, ASSETS / "Peligros" / f"{i}.jpeg", ASSETS / "Skills" / f"{i}.jpeg"
    disponibles = ", ".join(Path(f["archivo"]).stem for f in todas)
    raise SystemExit(f"No existe la carta '{clave}'. Hay: {disponibles}")


def comparacion(vieja: Path, nueva: Image.Image, destino: Path) -> None:
    """Las dos cartas pegadas, para decidir mirando y no leyendo una tabla."""
    if not vieja.exists():
        print(f"  (sin {vieja.name}: corré primero python3 bin/imprimir.py)")
        return
    a = Image.open(vieja).convert("RGB")
    hueco = px(6)
    f = fuente(CUERPO_NEGRITA, 10)
    cinta = alto_linea(f) + px(2)
    lienzo = Image.new(
        "RGB",
        (a.width + hueco + nueva.width, cinta + max(a.height, nueva.height)),
        CREMA,
    )
    lienzo.paste(a, (0, cinta))
    lienzo.paste(nueva, (a.width + hueco, cinta))

    # Los rótulos van en una cinta propia y no encima de las cartas: tapando
    # arte se juzga mal justo la esquina que interesa mirar.
    d = ImageDraw.Draw(lienzo)
    d.text((a.width // 2, px(1)), "ANTES", font=f, fill=TINTA, anchor="ma")
    d.text((a.width + hueco + nueva.width // 2, px(1)), "DESPUÉS",
           font=f, fill=TINTA, anchor="ma")
    lienzo.save(destino, "JPEG", quality=92, subsampling=0, dpi=(DPI, DPI))


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    p.add_argument("--carta", default="alba1", help="alba1..oca10 (por defecto alba1)")
    args = p.parse_args()

    fila, ilus_peligro, ilus_tecnica = buscar(args.carta)
    for f in (ilus_peligro, ilus_tecnica):
        if not f.exists():
            raise SystemExit(f"Falta la ilustración {f.relative_to(RAIZ)}")

    carta = carta_partida(fila, ilus_peligro, ilus_tecnica)
    SALIDA.mkdir(parents=True, exist_ok=True)
    destino = SALIDA / f"muestra_{args.carta}.jpg"
    carta.save(destino, "JPEG", quality=95, subsampling=0, progressive=False,
               optimize=True, dpi=(DPI, DPI))

    print(f"{destino.relative_to(RAIZ)}  {carta.width}x{carta.height} px "
          f"({CORTE_MM[0]}x{CORTE_MM[1]} mm + {SANGRADO_MM} de sangrado)")
    print(f"  peligro: {fila['peligro_nombre']}  ->  técnica: {fila['tecnica_nombre']}")
    print("  cuerpos: " + ", ".join(f"{k} {v} pt" for k, v in PT.items()))

    comp = SALIDA / f"muestra_{args.carta}_comparacion.jpg"
    comparacion(SALIDA / f"{args.carta}.jpg", carta, comp)
    if comp.exists():
        print(f"{comp.relative_to(RAIZ)}  <- mirá ésta")
    return 0


if __name__ == "__main__":
    sys.exit(main())
