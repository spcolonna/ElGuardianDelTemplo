#!/usr/bin/env python3
"""Arma el ícono adaptativo y la splash de Android desde el arte que ya existe.

Android 8 y arriba no muestra un PNG cuadrado: lo mete adentro de una máscara
que elige el fabricante —círculo, cuadrado redondeado, gota— y que recorta
bastante más que las esquinas redondeadas de iOS. Un ícono pensado para iOS
entra ahí recortado o con un borde gris alrededor.

Por eso el ícono de Android se arma en dos capas: un fondo liso y un frente
transparente con el dibujo adentro de la zona segura. El frente sale del
emblema de la splash de iOS —el bastón y la cinta, sin el texto—, porque el
ícono de iOS tiene el nombre escrito encima y una máscara circular se lo come.
El nombre igual va abajo del ícono, puesto por el sistema.

Necesita Pillow, igual que aligerar.py:  pip3 install Pillow

    python3 bin/iconos_android.py

No se corre en cada build: escribe PNG que van commiteados.
"""

import os
from PIL import Image, ImageChops

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(RAIZ, 'android/app/src/main/res')
EMBLEMA = os.path.join(
    RAIZ, 'ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png')

# El rojo del ícono de iOS, muestreado de su franja de arriba. Que las dos
# tiendas muestren el mismo color importa más que cualquier otra cosa acá.
ROJO = (194, 48, 32)
# El crema del juego. Es el mismo que ya usa la splash de iOS en
# ios/Runner/Base.lproj/LaunchScreen.storyboard.
CREMA = (249, 250, 244)

# El ícono adaptativo mide 108dp de lado, pero la máscara solo garantiza los
# 66dp del medio. Todo lo que dibujemos afuera de eso lo puede recortar algún
# teléfono, así que el emblema va al 62% y no más.
LADO_DP = 108
SEGURO = 0.62
# La splash de iOS pone el emblema a 220pt; Android usa el mismo número en dp.
SPLASH_DP = 220

DENSIDADES = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}


def emblema_recortado():
    """El emblema sin el crema de atrás y sin el aire que le sobra."""
    im = Image.open(EMBLEMA).convert('RGB')
    # El fondo es crema liso: lo que se le parece se vuelve transparente. El
    # emblema es tinta oscura y rojo, así que no hay riesgo de comerse el
    # dibujo.
    fondo = Image.new('RGB', im.size, CREMA)
    dif = ImageChops.difference(im, fondo).convert('L')
    alfa = dif.point(lambda v: 0 if v < 18 else min(255, (v - 18) * 8))
    con_alfa = im.convert('RGBA')
    con_alfa.putalpha(alfa)
    caja = alfa.getbbox()
    return con_alfa.crop(caja) if caja else con_alfa


def encajar(arte, lado, proporcion):
    """El arte centrado en un lienzo transparente, ocupando `proporcion`."""
    destino = int(lado * proporcion)
    escala = min(destino / arte.width, destino / arte.height)
    chico = arte.resize(
        (max(1, round(arte.width * escala)), max(1, round(arte.height * escala))),
        Image.LANCZOS)
    lienzo = Image.new('RGBA', (lado, lado), (0, 0, 0, 0))
    lienzo.paste(chico, ((lado - chico.width) // 2, (lado - chico.height) // 2), chico)
    return lienzo


def monocromo(capa):
    """La misma silueta en un solo color, para los íconos temáticos.

    Android 13 repinta esto con el color que eligió el usuario, así que lo
    único que importa es el alfa: la tinta opaca, el resto transparente.
    """
    gris = capa.convert('L')
    tinta = Image.eval(gris, lambda v: 255 - v)
    alfa = ImageChops.multiply(tinta, capa.getchannel('A'))
    salida = Image.new('RGBA', capa.size, (0, 0, 0, 0))
    salida.putalpha(alfa.point(lambda v: min(255, int(v * 1.6))))
    return salida


def escribir(ruta, im):
    os.makedirs(os.path.dirname(ruta), exist_ok=True)
    im.save(ruta)
    print(' ', os.path.relpath(ruta, RAIZ))


def main():
    arte = emblema_recortado()
    print('emblema recortado a', arte.size)

    for nombre, factor in DENSIDADES.items():
        lado = int(LADO_DP * factor)
        frente = encajar(arte, lado, SEGURO)
        escribir(f'{RES}/mipmap-{nombre}/ic_launcher_foreground.png', frente)
        escribir(f'{RES}/mipmap-{nombre}/ic_launcher_monochrome.png', monocromo(frente))

        # La splash: el emblema sobre crema, del tamaño que tiene en iOS.
        splash = encajar(arte, int(SPLASH_DP * factor), 1.0)
        escribir(f'{RES}/drawable-{nombre}/launch_image.png', splash)


if __name__ == '__main__':
    main()
