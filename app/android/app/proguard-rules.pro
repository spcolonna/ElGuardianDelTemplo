# R8 borra lo que no ve usado, y no ve lo que se llama por reflexión ni lo que
# cruza el canal de plataforma desde Dart. Las reglas de Flutter y las de los
# plugins vienen con ellos (consumerProguardFiles); acá va solo lo que falta.

# Play Billing. Las clases del cliente se resuelven por nombre desde el AIDL,
# así que si R8 las renombra la compra deja de existir en release y anda
# perfecto en debug: el peor tipo de error que hay.
-keep class com.android.vending.billing.** { *; }
-keep class com.android.billingclient.api.** { *; }

# google_mobile_ads carga los adaptadores de mediación por nombre de clase.
-keep class com.google.android.gms.ads.** { *; }

# El aviso que R8 tira por clases de Play Core que Flutter menciona para el
# modo diferido y este juego no usa: todos los assets van en el AAB base.
-dontwarn com.google.android.play.core.**
