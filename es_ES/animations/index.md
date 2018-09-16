---
layout: page
title: Animaciones en Flutter
permalink: /animations/
---

* TOC Placeholder
{:toc}


Las animaciones bien diseñadas hacen que la interfaz de usuario sea más intuitiva, contribuyen a la apariencia de una aplicación pulida y mejoran la experiencia del usuario. El soporte de animación de Flutter facilita la implementación de una variedad de tipos de animación.
Muchos widgets, especialmente
[Material Design widgets](https://flutter.io/widgets/material/),
vienen con los efectos de movimiento estándar definidos en sus especificaciones de diseño, pero también es posible personalizar estos efectos.

Los siguientes recursos son un buen lugar para empezar a aprender el framework de animación de Flutter. Cada uno de estos documentos muestran, paso a paso, cómo escribir código de animación.

{% comment %}
Se está preparando más documentación sobre cómo implementar patrones de diseño comunes, como las transiciones de elementos compartidos y las animaciones basadas en la física.
Si tienes una solicitud específica, por favor [crea un issue](https://github.com/flutter/flutter/issues).
{% endcomment %}

* [Tutorial: Animations en Flutter](/tutorials/animation/)<br>
Explica las clases fundamentales del paquete de animación Flutter (controladores, Animatable, curvas, listeners, builders), ya que te guía a través de una progresión de animaciones intercaladas utilizando diferentes aspectos de las API de animación.


* [Cero a Uno con Flutter, parte 1](https://medium.com/dartlang/zero-to-one-with-flutter-43b13fd7b354) y [parte
2](https://medium.com/dartlang/zero-to-one-with-flutter-part-two-5aa2f06655cb)<br>
Artículos en Medium que muestran cómo crear un gráfico animado usando interpolación.

* [Construyendo interfaces de usuario hermosas con Flutter](https://codelabs.developers.google.com/codelabs/flutter/index.html#0)<br>
Codelab demostrando cómo construir una aplicación de chat simple. [Paso 7 (Anime su aplicación)](https://codelabs.developers.google.com/codelabs/flutter/index.html#6)
muestra cómo animar el nuevo mensaje&mdash;deslizándolo desde el área de entrada hasta la lista de mensajes.

## Tipos de animación

Las animaciones se clasifican en dos categorías: basadas en física o en interpolación.
Las siguientes secciones explican lo que significan estos términos y le señalan los recursos en los que puedes obtener más información. En algunos casos, la mejor documentación que tenemos actualmente es el código de ejemplo en la galería de Flutter.

### Animación Tween 

Abreviatura de _intermediación_. En una tween animación, se definen los puntos de inicio y finalización, así como una línea de tiempo y una curva que define el tiempo y la velocidad de la transición. El framework calcula cómo hacer la transición desde el punto de inicio hasta el punto final.

Los documentos listados arriba, como el [tutorial de animaciones](/tutorials/animation/) no tratan específicamente sobre la interpolación, sino que utilizan interpolación en sus ejemplos.

### Animación basada en la física

En la animación basada en la física, el movimiento se modela para que se parezca al comportamiento del mundo real. Cuando lanzas una pelota, por ejemplo, dónde y cuándo cae depende de la rapidez con la que fue lanzada, de su peso y de la distancia del suelo. De manera similar, dejar caer una pelota atada a un resorte cae (y rebota) de manera diferente que dejar caer una pelota atada a una cuerda.

* [Galeria de Flutter](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)<br>
Sobre **Material Components**, el ejemplo de [Grid](https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/grid_list_demo.dart) muestra una animación voladora. Selecciona una de las imágenes de la cuadrícula y acerca la imagen. Puedes desplazar la imagen con gestos de giro o de arrastre.

* Véase también la documentación de la API para
[AnimationController.animateWith](https://docs.flutter.io/flutter/animation/AnimationController/animateWith.html) y
[SpringSimulation](https://docs.flutter.io/flutter/physics/SpringSimulation-class.html).

## Patrones de animación comunes

La mayoría de los diseñadores de UX o de movimiento encuentran que ciertos patrones de animación se usan repetidamente cuando diseñan una interfaz de usuario. Esta sección enumera algunos de los patrones de animación más utilizados y te indica dónde puedes obtener más información.

### Lista o grid animada
Este patrón implica animar la adición o eliminación de elementos de una lista o cuadrícula.

* [Ejemplo de AnimatedList](/catalog/samples/animated-list/)<br>
Esta demostración, de la [App Catalog de Ejemplo](/catalog/samples), muestra cómo animar la adición de un elemento a una lista, o la eliminación de un elemento seleccionado.
La lista interna de Dart se sincroniza a medida que el usuario modifica la lista utilizando los botones más (+) y menos (-).

### Transición de elementos compartidos

En este patrón, el usuario selecciona un elemento&mdash;a menudo una imagen&mdash;de la página, y la interfaz de usuario anima el elemento seleccionado a una nueva página con más detalles. En Flutter, puedes implementar fácilmente transiciones de elementos compartidos entre routes (páginas) utilizando el widget Hero.

* [Animaciones Hero](/animations/hero-animations/)
Cómo crear dos estilos de animaciones de Hero:
  * El Hero vuela de una página a otra mientras cambia de posición y tamaño.
  * El borde del Hero cambia de forma, de un círculo a un cuadrado, a medida que vuela de una página a otra.
* [Galeria de Flutter](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)<br>
Puedes construir la aplicación Gallery tu mismo o descargarla de la Play Store.
La demo [Shrine](https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/shrine_demo.dart) incluye un ejemplo de animación Hero.

* Véase también la documentación de la API para las clases [Hero,](https://docs.flutter.io/flutter/widgets/Hero-class.html)
[Navigator,](https://docs.flutter.io/flutter/widgets/Navigator-class.html) y
[PageRoute](https://docs.flutter.io/flutter/widgets/PageRoute-class.html).

### Animación escalonada

Animaciones que se dividen en movimientos más pequeños, donde parte del movimiento se retrasa. Las animaciones más pequeñas pueden ser secuenciales, o pueden solaparse parcial o totalmente.

* [Animación escalonada](/animations/staggered-animations/)

<!-- Save so I can remember how to add it back later.
<img src="/images/ic_new_releases_black_24px.svg" alt="this doc is new!"> NEW<br>
-->

## Otros recursos

Aprenda más sobre las animaciones de Flutter en los siguientes enlaces:

* [Animaciones: Resumen técnico](/animations/overview.html)<br>
Un vistazo a algunas de las clases más importantes de la biblioteca de animaciones y a la arquitectura de animación de Flutter.

* [Widgets de animación y movimiento](/widgets/animation/)<br>
Un catálogo de algunos de los widgets de animación proporcionados en las APIs de Flutter.

{% comment %}
Until the landing page for the animation library is reworked, leave this
link out.
* The [animation
library](https://docs.flutter.io/flutter/animation/animation-library.html)
in the [Flutter API documentation](https://docs.flutter.io/)<br>
The animation API for the Flutter framework.
{% endcomment %}

<hr>

Si hay documentación de animación específica que te gustaría ver, por favor [crea un issue](https://github.com/flutter/flutter/issues).

