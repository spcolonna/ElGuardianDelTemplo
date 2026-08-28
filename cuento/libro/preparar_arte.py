#!/usr/bin/env python3
"""Piezas de arte derivadas para la maqueta del libro.

Lee de `Assets/` y `app/assets/` y escribe UNICAMENTE en `cuento/libro/img/`.
Ningun original se modifica.

    python3 cuento/libro/preparar_arte.py
"""
import os
import sys

from PIL import Image

RAIZ = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SALIDA = os.path.join(RAIZ, 'cuento', 'libro', 'img')

CALIDAD = 95  # igual que bin/imprimir.py: subsampling 4:4:4, sin banding en las acuarelas


def ruta(*partes):
    return os.path.join(RAIZ, *partes)


def guardar(im, nombre):
    destino = os.path.join(SALIDA, nombre)
    if im.mode in ('RGBA', 'P') and nombre.endswith('.png'):
        im.save(destino, 'PNG', optimize=True)
    else:
        im.convert('RGB').save(destino, 'JPEG', quality=CALIDAD, subsampling=0)
    kb = os.path.getsize(destino) // 1024
    print(f'  {nombre:28s} {im.size[0]:5d} x {im.size[1]:5d}  {kb:5d} KB')


# ---------------------------------------------------------------- triptico

def franjas_separadoras(im, salto=12, radio=8):
    """Las dos franjas claras que parten el triptico.

    No son blanco puro (el JPEG las lavo contra los paneles), asi que no
    alcanza con un umbral: se buscan columnas cuya media supere por `salto`
    a las de ambos lados a `radio` de distancia.
    """
    gris = im.convert('L')
    ancho, alto = gris.size
    pixeles = gris.load()
    filas = range(0, alto, 3)
    medias = [sum(pixeles[x, y] for y in filas) / len(filas) for x in range(ancho)]

    marcas = [False] * ancho
    for x in range(radio, ancho - radio):
        vecinos = max(medias[x - radio], medias[x + radio])
        marcas[x] = medias[x] - vecinos > salto
    return marcas


def tramos(marcas):
    """Agrupa las columnas marcadas en tramos contiguos (inicio, fin_exclusivo)."""
    salida, inicio = [], None
    for i, m in enumerate(marcas):
        if m and inicio is None:
            inicio = i
        elif not m and inicio is not None:
            salida.append((inicio, i))
            inicio = None
    if inicio is not None:
        salida.append((inicio, len(marcas)))
    return salida


def partir_triptico():
    origen = ruta('app', 'assets', 'ui', 'background.jpeg')
    im = Image.open(origen)
    ancho, alto = im.size

    franjas = [t for t in tramos(franjas_separadoras(im)) if (t[1] - t[0]) >= 3]
    # Las franjas del borde no separan nada; solo interesan las interiores.
    franjas = [t for t in franjas if t[0] > ancho * 0.08 and t[1] < ancho * 0.92]

    if len(franjas) != 2:
        print(f'  ! el triptico no dio 2 franjas sino {len(franjas)}: {franjas}')
        print('    corto en tercios y sigo; miralo antes de aprobarlo')
        cortes = [(0, ancho // 3), (ancho // 3, 2 * ancho // 3), (2 * ancho // 3, ancho)]
    else:
        (a0, a1), (b0, b1) = franjas
        cortes = [(0, a0), (a1, b0), (b1, ancho)]

    # Cada panel sale de unos 460 px de ancho. Como banda de apertura ocupa el
    # ancho entero de la pagina (145,7 mm con sangrado), y 460 px ahi son 80 dpi:
    # se ve borroso en papel. Se amplian x2,5 hasta ~1150 px, que dan 200 dpi.
    # No es el ideal de 300, pero son fondos de acuarela sin linea fina y a esa
    # densidad se imprimen bien; el limite de x2,5 es el mismo que se usa para
    # las vinetas.
    for nombre, (x0, x1) in zip(('templo_alba', 'templo_dia', 'templo_ocaso'), cortes):
        panel = im.crop((x0, 0, x1, alto))
        panel = panel.resize(
            (round(panel.size[0] * 2.5), round(panel.size[1] * 2.5)), Image.LANCZOS)
        guardar(panel, f'{nombre}.jpeg')


# ------------------------------------------------------------------- tapa

def ampliar_tapa():
    origen = ruta('Assets', 'Imprimir', 'TapaCajaConLogo.png')
    im = Image.open(origen).convert('RGB')
    # 5,5 x 8,5 in + 3,175 mm de sangrado por lado, a 300 dpi.
    destino = (1726, 2681)
    # Recorte previo para no deformar: la tapa da 0,640 y el destino 0,644.
    ancho, alto = im.size
    objetivo = destino[0] / destino[1]
    if ancho / alto > objetivo:
        nuevo = int(alto * objetivo)
        im = im.crop(((ancho - nuevo) // 2, 0, (ancho + nuevo) // 2, alto))
    else:
        nuevo = int(ancho / objetivo)
        # Se recorta de arriba: el cielo tiene menos informacion que el piso.
        im = im.crop((0, alto - nuevo, ancho, alto))
    guardar(im.resize(destino, Image.LANCZOS), 'tapa.jpeg')



# --------------------------------------------------------------- vinetas

# Las hojas de personaje no son ilustraciones: son fichas de produccion, con
# rotulos en ingles ("FRONT VIEW", "TERRIFIED & PUFFED UP") y varias poses en
# la misma imagen. No pueden entrar al libro enteras. Pero cada pose, recortada
# sin su rotulo, es un dibujo limpio sobre papel crema.
#
# Salen chicas —200 a 400 px— asi que se usan como vinetas al margen, de 25 a
# 45 mm, y se amplian para llegar a 300 dpi a ese tamano. No sirven a pagina
# entera y no hay que usarlas asi.
#
#   nombre: (origen, (x0, y0, x1, y1) en fracciones, ancho impreso en mm)
RECORTES = {
    'mei_desprecio':      ('Assets/mei.jpeg',       (0.090, 0.050, 0.320, 0.508), 42),
    'mei_caminando':      ('Assets/mei.jpeg',       (0.585, 0.050, 0.970, 0.503), 52),
    'mei_terror':         ('Assets/mei.jpeg',       (0.490, 0.575, 0.760, 0.898), 45),
    'mei_petulante':      ('Assets/mei.jpeg',       (0.748, 0.575, 0.970, 0.898), 40),

    'tao_entero':         ('Assets/kai.jpeg',       (0.305, 0.108, 0.442, 0.903), 30),
    'tao_burlon':         ('Assets/kai.jpeg',       (0.655, 0.080, 0.810, 0.403), 34),
    'tao_serio':          ('Assets/kai.jpeg',       (0.828, 0.105, 0.980, 0.448), 34),
    'tao_culpable':       ('Assets/kai.jpeg',       (0.673, 0.450, 0.818, 0.925), 32),

    'shifu_entero':       ('Assets/shifu.jpeg',     (0.230, 0.120, 0.430, 0.648), 40),
    'shifu_bajando':      ('Assets/shifu.jpeg',     (0.448, 0.120, 0.622, 0.648), 38),
    'shifu_desaprueba':   ('Assets/shifu.jpeg',     (0.812, 0.735, 0.962, 0.945), 36),

    'pinto':              ('Assets/vendedor.jpeg',  (0.130, 0.080, 0.450, 0.950), 44),

    'guang_entero':       ('Assets/Main.jpeg',      (0.290, 0.020, 0.392, 0.628), 28),
    'guang_panico':       ('Assets/Main.jpeg',      (0.238, 0.655, 0.382, 0.940), 34),
    'guang_cansado':      ('Assets/Main.jpeg',      (0.420, 0.655, 0.580, 0.940), 36),
    'guang_culpable':     ('Assets/Main.jpeg',      (0.618, 0.655, 0.752, 0.940), 32),

    # --- Tomo II ---------------------------------------------------------
    # Los tres originales son hojas de modelo rotuladas en ingles («FRONT
    # VIEW», «GROUP OF THREE», «WORN BOOTS»). Sin recortar no pueden entrar a
    # una pagina del libro.
    'bandido_palo':       ('Assets/Bandits.jpeg',   (0.144, 0.128, 0.272, 0.930), 36),
    'bandidos_tres':      ('Assets/Bandits.jpeg',   (0.632, 0.225, 0.962, 0.925), 52),

    'soldado_frente':     ('Assets/soldado.jpeg',   (0.030, 0.048, 0.268, 0.898), 38),
    'soldados_fila':      ('Assets/soldado.jpeg',   (0.588, 0.302, 0.902, 0.850), 54),

    'grom_frente':        ('Assets/Mercenario.jpeg', (0.202, 0.122, 0.352, 0.950), 36),

    # --- Tomo III --------------------------------------------------------
    # Poses que quedaban libres en las mismas hojas. Hacen falta porque una
    # ilustracion entra una sola vez en todo el volumen: Pinto de frente y el
    # Tao serio ya los gasto el Tomo I, y el Tao burlon el Tomo II.
    'pinto_yendose':      ('Assets/vendedor.jpeg', (0.575, 0.085, 0.835, 0.945), 44),

    # De espaldas, que es como se va: por el costado, hacia el barranco.
    'tao_de_espaldas':    ('Assets/kai.jpeg',      (0.516, 0.120, 0.672, 0.930), 30),
    'tao_neutral':        ('Assets/kai.jpeg',      (0.835, 0.548, 0.980, 0.935), 32),

    # La cara del humo con forma de signo de interrogacion.
    'guang_confundido':   ('Assets/Main.jpeg',     (0.070, 0.650, 0.210, 0.945), 32),
    'guang_de_espaldas':  ('Assets/Main.jpeg',     (0.762, 0.022, 0.880, 0.632), 28),

    # Para la contratapa: el mosquito solo, sin el patio de atras. Es el mejor
    # gancho que tiene el libro y no se entiende hasta que se lo ve.
    'mosquito':           ('Assets/Peligros/1.jpeg', (0.330, 0.125, 0.700, 0.800), 46),
}


def recortar_vinetas():
    for nombre, (origen, caja, ancho_mm) in RECORTES.items():
        im = Image.open(ruta(*origen.split('/'))).convert('RGB')
        ancho, alto = im.size
        x0, y0, x1, y1 = caja
        pieza = im.crop((int(x0 * ancho), int(y0 * alto), int(x1 * ancho), int(y1 * alto)))

        # Ampliar hasta 300 dpi al ancho de uso, sin pasar de x2,5: mas que eso
        # ya no es acuarela ampliada, es pure.
        objetivo = int(ancho_mm / 25.4 * 300)
        factor = min(2.5, max(1.0, objetivo / pieza.size[0]))
        if factor > 1.01:
            pieza = pieza.resize(
                (round(pieza.size[0] * factor), round(pieza.size[1] * factor)), Image.LANCZOS)
        guardar(pieza, f'{nombre}.jpeg')


# ------------------------------------------------------------------ sello

def recortar_sello(origen='cuento/libro/img/fuerza.jpg', nombre='sello_fuerza.png',
                   tinta=(59, 44, 32)):
    """El 加油 del cierre de tomo, recortado del papel gris que trae puesto.

    El original viene sobre su propio fondo (216, 209, 201), bastante mas
    oscuro que el papel del libro (253, 248, 236). Puesto tal cual —o con
    `multiply`, que lo oscurece todavia mas— se ve como un recuadro gris
    pegado en la pagina.

    Aca se convierte la mancha en transparencia: cada pixel aporta tanta
    opacidad como oscuro sea respecto del fondo, y la tinta se repinta con el
    marron del libro. Queda un sello de verdad, que flota sobre el papel
    cualquiera sea el color de la pagina.
    """
    im = Image.open(ruta(origen)).convert('L')
    pix = list(im.getdata())

    # El fondo se mide en el borde, no se supone: si algun dia cambia la
    # imagen, el recorte se adapta solo.
    ancho, alto = im.size
    borde = ([im.getpixel((x, 0)) for x in range(ancho)]
             + [im.getpixel((x, alto - 1)) for x in range(ancho)]
             + [im.getpixel((0, y)) for y in range(alto)]
             + [im.getpixel((ancho - 1, y)) for y in range(alto)])
    fondo = sorted(borde)[len(borde) // 2]
    piso = min(pix)
    rango = max(1, fondo - piso)

    # El umbral se come el ruido del JPEG en el papel; sin el, el sello queda
    # con una nube gris alrededor que en papel se ve como suciedad.
    umbral = 0.06
    alfa = []
    for v in pix:
        a = (fondo - v) / rango
        a = 0.0 if a < umbral else min(1.0, (a - umbral) / (1 - umbral))
        alfa.append(int(round(a * 255)))

    sello = Image.new('RGBA', im.size, tinta + (0,))
    sello.putalpha(Image.new('L', im.size).point(lambda _: 0))
    sello.putdata([tinta + (a,) for a in alfa])
    guardar(sello, nombre)


def main():
    os.makedirs(SALIDA, exist_ok=True)
    print('triptico del templo')
    partir_triptico()
    print('tapa ampliada')
    ampliar_tapa()
    print('vinetas de personaje')
    recortar_vinetas()
    print('sello del cierre de tomo')
    recortar_sello()
    print(f'\nlisto -> cuento/libro/img/')


if __name__ == '__main__':
    sys.exit(main())
