---
layout: page
title: "Animaciones escalonadas"
permalink: /animations/staggered-animations/
---

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>Lo que aprenderás:</b>

* Una animación escalonada consiste en animaciones secuenciales o superpuestas.
* Para crear una animación escalonada, utiliza varios objetos de animación.
* Un AnimationController controla todas las Animaciones.
* Cada objeto de animación especifica la animación durante un intervalo.
* Para cada propiedad que se esté animando, crea una interpolación.
</div>

<aside class="alert alert-info" markdown="1">
**Terminología:**
Si el concepto de interpolaciones o interpolar es nuevo para ti consulte el [tutorial Animaciones en Flutter.](/tutorials/animation/)
</aside>

Las animaciones escalonadas son un concepto sencillo: los cambios visuales ocurren como una serie de operaciones, en lugar de todas a la vez.
La animación puede ser puramente secuencial, con un cambio que ocurre después del siguiente, o puede superponerse parcial o completamente. También podría tener vacíos, donde no ocurren cambios.

Esta guía muestra cómo crear una animación escalonada en Flutter.

<aside class="alert alert-info" markdown="1">
**Ejemplos**<br>

Esta guía explica el ejemplo básico de animación escalonada. También puede referirse a un ejemplo más complejo, la _basic_staggered_animation_.

[basic_staggered_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/basic_staggered_animation)
: Muestra una serie de animaciones secuenciales y superpuestas de un único widget. Al tocar la pantalla se inicia una animación que cambia el tamaño de la opacidad, la forma, el color y el relleno.

[staggered_pic_selection](https://github.com/flutter/website/tree/master/src/_includes/code/animation/staggered_pic_selection)
: Muestra cómo eliminar una imagen de una lista de imágenes mostradas en uno de los tres tamaños.
  Este ejemplo utiliza dos [controladores de animacion](https://docs.flutter.io/flutter/animation/AnimationController-class.html):
  uno para la selección/deselección de imágenes, y otro para la eliminación de imágenes. La animación de selección/deselección está escalonada. 
  es posible que necesites aumentar el valor de `timeDilation`. Selecciona una de las imágenes más grandes:&mdash;se encoge al mostrar una marca de verificación dentro de un círculo azul. A continuación, selecciona una de las imágenes más pequeñas&mdash;la imagen grande se expande a medida que desaparece la marca de verificación. Antes de que la imagen grande haya terminado de expandirse, la imagen pequeña se encoge para mostrar su marca de verificación. Este comportamiento escalonado es similar al que se puede ver en Google Photos.

</aside>

* TOC Placeholder
{:toc}

El siguiente video muestra la animación realizada por basic_staggered_animation:

<!--
  Use this instead of the default YouTube embed code so that the embed
  is responsive.
-->
<div class="embed-container"><iframe src="https://www.youtube.com/embed/0fFvnZemmh8?rel=0" frameborder="0" allowfullscreen></iframe></div>

En el vídeo, puedes ver la siguiente animación de un único widget, que comienza como un cuadrado azul bordeado con esquinas ligeramente redondeadas. El cuadrado pasa por cambios en el siguiente orden:

1. Fades in
1. Se expande
1. Se hace más alto mientras se mueve hacia arriba
1. Se transforma en un círculo delimitado
1. Cambia de color a naranja

Después de correr hacia adelante, la animación se ejecuta en reversa.

<aside class="alert alert-info" markdown="1">
**¿Nuevo en Flutter?**<br>
Esta página asume que sabes cómo crear un diseño usando los widgets de Flutter.  Para más información, véase [Construyendo Layouts en Flutter](/tutorials/layout/).
</aside>

## Estructura básica de una animación escalonada

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Cuál es el punto??</b>

* Todas las animaciones son conducidas por el mismo [AnimationController](https://docs.flutter.io/flutter/animation/AnimationController-class.html).
* Independientemente de cuánto dure la animación en tiempo real, los valores del controlador deben estar entre 0.0 y 1.0, inclusive.
* Cada animación tiene un
  [Interval](https://docs.flutter.io/flutter/animation/Interval-class.html)
  entre 0.0 y 1.0, inclusive.
* Para cada propiedad que se anima en un intervalo, crea un
  [Tween.](https://docs.flutter.io/flutter/animation/Tween-class.html)
  Tween especifica los valores de inicio y final para esa propiedad.
* El Tween produce un objeto [Animation](https://docs.flutter.io/flutter/animation/Animation-class.html) que es manejado por el controlador.
</div>

{% comment %}
The app is essentially animating a Container whose decoration and size are
animated. The Container is within another Container whose padding moves the
inner container around and an Opacity widget that's used to fade everything
in and out.
{% endcomment %}

El siguiente diagrama muestra los Intervalos utilizados en el ejemplo
[basic_staggered_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/basic_staggered_animation). Puedes notar las siguientes características:

* La opacidad cambia durante el primer 10% de la línea de tiempo.
* Se produce un pequeño hueco entre el cambio de opacidad y el cambio de anchura.
* Nada se anima durante el último 25% de la línea de tiempo.
* Aumentar el relleno hace que el widget parezca subir hacia arriba.
* Aumentando el radio del borde a 0.5, transforma el cuadrado con esquinas redondeadas en un círculo.
* Los cambios de padding en el radio y del borde ocurren durante el mismo intervalo exacto, pero no es necesario.

<img src="images/StaggeredAnimationIntervals.png" alt="Diagram showing the interval specified for each motion." />

Para configurar la animación:

* Crear un AnimationController que administre todas las Animaciones.
* Crear un Tween para cada propiedad que se esté animando.
  * El Tween define un rango de valores.
  * El método `animated` de los Tween requiere el controlador `parent`, y produce una Animación para esa propiedad.
* Especifica el intervalo en la propiedad `curved` de la animación.

Cuando el valor de la animación de control cambia, el valor de la nueva animación cambia, provocando que la interfaz de usuario se actualice.

El siguiente código crea una interpolación para la propiedad `width`. Construye un [CurvedAnimation](https://docs.flutter.io/flutter/animation/CurvedAnimation-class.html), especificando una eased curve.
ver [Curves](https://docs.flutter.io/flutter/animation/Curves-class.html)
para otras curvas de animación predefinidas disponibles.

<!-- skip -->
{% prettify dart %}
width = Tween<double>(
  begin: 50.0,
  end: 150.0,
).animate(
  CurvedAnimation(
    parent: controller,
    curve: Interval(
      0.125, 0.250,
      curve: Curves.ease,
    ),
  ),
),
{% endprettify %}

Los valores de `begin` y `end` no tienen que ser dobles. El siguiente código construye la interpolación para la propiedad `borderRadius` (que controla la redondez de las esquinas del cuadrado), usando `BorderRadius.circular()`.

{% prettify dart %}
borderRadius = BorderRadiusTween(
  begin: BorderRadius.circular(4.0),
  end: BorderRadius.circular(75.0),
).animate(
  CurvedAnimation(
    parent: controller,
    curve: Interval(
      0.375, 0.500,
      curve: Curves.ease,
    ),
  ),
),
{% endprettify %}

### Animación completa escalonada

Como todos los widgets interactivos, la animación completa consiste en un par de widgets: un widget sin estado y un widget con estado.

El widget sin estado especifica los Tweens, define los objetos de Animación, y proporciona una función `build()` responsable de construir la parte animada del árbol de widgets.

El widget de estado crea el controlador, reproduce la animación y construye la parte no animada del árbol de widgets. La animación comienza cuando se detecta un toque en cualquier parte de la pantalla.

[Código completo de main.dart para basic_staggered_animation](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/animation/basic_staggered_animation/main.dart)

### Widget sin estado: StaggerAnimation

En el widget stateless, StaggerAnimation, la función `build()` instancia un [AnimatedBuilder](https://docs.flutter.io/flutter/widgets/AnimatedBuilder-class.html)&mdash;un widget de propósito general para construir animaciones. El AnimatedBuilder construye un widget y lo configura usando los valores actuales de los Tweens. 
El ejemplo crea una función llamada `_buildAnimation()` (que realiza las actualizaciones de la interfaz de usuario), y la asigna a su propiedad `builder`.
AnimatedBuilder escucha las notificaciones del controlador de animación, marcando el árbol de widgets sucio a medida que cambian los valores.
Para cada tick de la animación, los valores se actualizan, resultando en una llamada a `_buildAnimation()`.

<!-- skip -->
{% prettify dart %}
[[highlight]]class StaggerAnimation extends StatelessWidget[[/highlight]] {
  StaggerAnimation({ Key key, this.controller }) :

    // Cada animación definida aquí transforma su valor durante el subconjunto
    // de la duración del controlador definido por el intervalo de la animación.
    // Por ejemplo, la animación de opacidad transforma su valor durante
    // el primer 10% de la duración del controlador.

    [[highlight]]opacity = Tween<double>[[/highlight]](
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0, 0.100,
          curve: Curves.ease,
        ),
      ),
    ),

    // ... Otras definiciones de tween ...

    super(key: key);

  [[highlight]]final Animation<double> controller;[[/highlight]]
  [[highlight]]final Animation<double> opacity;[[/highlight]]
  [[highlight]]final Animation<double> width;[[/highlight]]
  [[highlight]]final Animation<double> height;[[/highlight]]
  [[highlight]]final Animation<EdgeInsets> padding;[[/highlight]]
  [[highlight]]final Animation<BorderRadius> borderRadius;[[/highlight]]
  [[highlight]]final Animation<Color> color;[[/highlight]]

  // Esta función se llama cada vez que el controlador "ticks" un nuevo frame.
  // Cuando se ejecuta, todos los valores de la animación habrán sido
  // actualizados para reflejar el valor actual del controlador.
  [[highlight]]Widget _buildAnimation(BuildContext context, Widget child)[[/highlight]] {
    return Container(
      padding: padding.value,
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: opacity.value,
        child: Container(
          width: width.value,
          height: height.value,
          decoration: BoxDecoration(
            color: color.value,
            border: Border.all(
              color: Colors.indigo[300],
              width: 3.0,
            ),
            borderRadius: borderRadius.value,
          ),
        ),
      ),
    );
  }

  @override
  [[highlight]]Widget build(BuildContext context)[[/highlight]] {
    return [[highlight]]AnimatedBuilder[[/highlight]](
      [[highlight]]builder: _buildAnimation[[/highlight]],
      animation: controller,
    );
  }
}
{% endprettify %}

### Widget con estado: StaggerDemo

El widget de estado, StaggerDemo, crea el AnimationController (el que las gobierna a todos), especificando una duración de 2000ms. Reproduce la animación y construye la parte no animada del árbol de widgets.
La animación comienza cuando se detecta un tap en la pantalla.
La animación se ejecuta hacia adelante y luego hacia atrás.

<!-- skip -->
{% prettify dart %}
[[highlight]]class StaggerDemo extends StatefulWidget[[/highlight]] {
  @override
  _StaggerDemoState createState() => _StaggerDemoState();
}

class _StaggerDemoState extends State<StaggerDemo> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this
    );
  }

  // ...Boilerplate...

  [[highlight]]Future<Null> _playAnimation() async[[/highlight]] {
    try {
      [[highlight]]await _controller.forward().orCancel;[[/highlight]]
      [[highlight]]await _controller.reverse().orCancel;[[/highlight]]
    } on TickerCanceled {
      // la animación fue cancelada, probablemente porque la descartamos
    }
  }

  @override
  [[highlight]]Widget build(BuildContext context)[[/highlight]] {
    timeDilation = 10.0; // 1.0 es la velocidad normal.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staggered Animation'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _playAnimation();
        },
        child: Center(
          child: Container(
            width: 300.0,
            height: 300.0,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: Border.all(
                color:  Colors.black.withOpacity(0.5),
              ),
            ),
            child: StaggerAnimation(
              controller: _controller.view
            ),
          ),
        ),
      ),
    );
  }
}
{% endprettify %}

## Recursos

Los siguientes recursos pueden ayudar a escribir animaciones:

[Animaciones de landing page](/animations/)
: Enumera la documentación disponible para las animaciones de Flutter.
  Si las interpolaciones son nuevas para ti, consulta el
  [tutorial de Animaciones](/tutorials/animation/).

[Documentation de la API de Flutter](https://docs.flutter.io/)
: Documentación de referencia para todas las bibliotecas de Flutter.
  En particular, vea la documentación de la [libreria de animación](https://docs.flutter.io/flutter/animation/animation-library.html).

[Galeria de Flutter](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)
: Demo app que muestra muchos Componentes de Material y otras características de Flutter. La [demo Shrine](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery/lib/demo/shrine) implementa una animación Hero.

[Especificación del movimiento Material](https://material.io/guidelines/motion/)
: Describe el movimiento de las aplicaciones de Material.

{% comment %}
Package not yet vetted.

## Other resources

* For an alternate approach to sequence animation, see the
[flutter_sequence_animation](https://pub.dartlang.org/packages/flutter_sequence_animation)
package on [pub.dartlang.org](https://pub.dartlang.org/packages).
{% endcomment %}