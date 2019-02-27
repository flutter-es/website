---
title: Animaciones escalonadas
short-title: Escalonada
---

{{site.alert.secondary}}
  <h4 class="no_toc">Lo que aprenderas</h4>

  * Una animación escalonada consiste en secuencial o superpuesta.
    animaciones
  * Para crear una animación escalonada, use varios objetos de animación.
  * Un AnimationController controla todas las animaciones.
  * Cada objeto de animación especifica la animación durante un intervalo.
  * Para cada propiedad que se esté animando, cree una interpolación.
{{site.alert.end}}

<aside class="alert alert-info" markdown="1">
  **Terminología:**
  Si el concepto de interpolaciones o interpolaciones es nuevo para usted, consulte la
  [Animaciones en tutorial Flutter.](/docs/development/ui/animations/tutorial)
</aside>

Las animaciones escalonadas son un concepto sencillo: cambios visuales
sucede como una serie de operaciones, en lugar de todas a la vez.
La animación puede ser puramente secuencial, con un cambio que se produce después de
la siguiente, o podría superponerse parcial o totalmente. También podría
Tiene brechas, donde no se producen cambios.

Esta guía muestra cómo construir una animación escalonada en Flutter.

{{site.alert.secondary}}
  <h4 class="no_toc">Ejemplos</h4>

  Esta guía explica el ejemplo de basic_staggered_animation. Tú también puedes
  Consulte un ejemplo más complejo, staggered_pic_selection.

  [basic_staggered_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/basic_staggered_animation)
  : Muestra una serie de animaciones secuenciales y superpuestas de un solo widget.
    Al tocar la pantalla comienza una animación que cambia la opacidad, el tamaño,
    Forma, color y relleno.

  [staggered_pic_selection](https://github.com/flutter/website/tree/master/src/_includes/code/animation/staggered_pic_selection)
  : Muestra la eliminación de una imagen de una lista de imágenes mostradas en uno de tres tamaños.
    Este ejemplo utiliza dos [animation
    controllers](https://docs.flutter.io/flutter/animation/AnimationController-class.html):
    Uno para la selección / deselección de imágenes, y otro para la eliminación de imágenes.
    La animación de selección / deselección es escalonada. (Para ver este efecto,
    puede que necesites aumentar el valor de `timeDilation`.)
    Seleccione una de las imágenes más grandes; se reduce, ya que muestra una marca de verificación
    dentro de un circulo azul. A continuación, seleccione una de las imágenes más pequeñas & mdash;
    La imagen grande se expande a medida que desaparece la marca de verificación. Antes de la imagen grande
    ha terminado de expandirse, la imagen pequeña se contrae para mostrar su marca de verificación.
    Este comportamiento escalonado es similar al que puedes ver en Google Photos.
{{site.alert.end}}



El siguiente video muestra la animación realizada por
basic_staggered_animation:

<!--
  Use esto en lugar del código de inserción de YouTube predeterminado para que la incrustación
  es receptivo
-->
<div class="embed-container"><iframe src="https://www.youtube.com/embed/0fFvnZemmh8?rel=0" frameborder="0" allowfullscreen></iframe></div>

En el video, ves la siguiente animación de un solo widget,
que comienza como un cuadrado azul bordeado con esquinas ligeramente redondeadas.
El cuadrado se ejecuta a través de cambios en el siguiente orden:

1. Se desvanece en
1. Ensancha
1. Se vuelve más alto mientras se mueve hacia arriba
1. Se transforma en un círculo bordeado.
1. Cambia de color a naranja

Después de correr hacia adelante, la animación se ejecuta en reversa.

<aside class="alert alert-info" markdown="1">
**Nuevo en Flutter?**<br>
Esta página asume que usted sabe cómo crear un diseño utilizando Flutter
widgets Para obtener más información, consulte [Creación de diseños en
Flutter](/docs/development/ui/layout).
</aside>

## Estructura básica de una animación escalonada.

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>What's the point?</b>

* Todas las animaciones son impulsadas por el mismo.
  [AnimationController](https://docs.flutter.io/flutter/animation/AnimationController-class.html).
* Independientemente de cuánto dure la animación en tiempo real,
  Los valores del controlador deben estar entre 0.0 y 1.0, inclusive.
* Cada animación tiene un
  [Intervalo](https://docs.flutter.io/flutter/animation/Interval-class.html)
  entre 0.0 y 1.0, inclusive.
* Para cada propiedad que se anime en un intervalo, cree una
  [Interpolación.](https://docs.flutter.io/flutter/animation/Tween-class.html)
  La interpolación especifica los valores de inicio y finalización de esa propiedad.
* La Tween produce una
  [Animación](https://docs.flutter.io/flutter/animation/Animation-class.html)
  Objeto que es gestionado por el controlador.
</div>

{% comment %}
La aplicación es esencialmente animar un contenedor cuya decoración y tamaño son
animado. El Contenedor está dentro de otro Contenedor cuyo relleno mueve el
Contenedor interno alrededor y un widget de opacidad que se usa para atenuar todo
dentro y fuera
{% endcomment %}

El siguiente diagrama muestra los intervalos utilizados en la
[basic_staggered_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/basic_staggered_animation)
ejemplo. Podrías notar las siguientes características:

* La opacidad cambia durante el primer 10% de la línea de tiempo.
* Se produce una pequeña brecha entre el cambio en la opacidad y el cambio en el ancho.
* Nada se anima durante el último 25% de la línea de tiempo.
* Aumentar el relleno hace que el widget parezca subir.
* Al aumentar el radio del borde a 0.5, se transforma el cuadrado con redondeado.
  esquinas en un círculo.
* Los cambios de relleno y del radio del borde se producen durante el mismo intervalo exacto,
  pero no tienen que hacerlo.

<img src="/docs/development/ui/animations/staggered-animations/images/StaggeredAnimationIntervals.png" alt="Diagram showing the interval specified for each motion." />

Para configurar la animación:

* Cree un controlador de animación que administre todas las animaciones.
* Crea una interpolación para cada propiedad que se está animando.
  * La Tween define un rango de valores.
  * El método `animate` de Tween requiere el controlador` parent`, y
    Produce una animación para esa propiedad.
* Especifique el intervalo en la propiedad `curve` de la animación.

Cuando el valor de la animación de control cambia, la nueva animación
cambios de valor, lo que desencadena la interfaz de usuario para actualizar.

El siguiente código crea una interpolación para la propiedad `width`.
Construye un
[CurvedAnimation](https://docs.flutter.io/flutter/animation/CurvedAnimation-class.html),
especificando una curva suavizada.
Vea [Curvas](https://docs.flutter.io/flutter/animation/Curves-class.html)
Para otras curvas de animación predefinidas disponibles.

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

Los valores de "comienzo" y "final" no tienen que ser dobles.
El siguiente código crea la interpolación para la propiedad `borderRadius`
(que controla la redondez de las esquinas del cuadrado), usando
`BorderRadius.circular ()`.

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

### Animación escalonada completa

Como todos los widgets interactivos, la animación completa consiste
de un par de widgets: un widget sin estado y uno con estado.

El widget sin estado especifica los Tweens,
define los objetos de animación y proporciona una función `build ()`
responsable de construir la porción de animación del árbol de widgets.

El widget de estado crea el controlador, reproduce la animación,
y construye la parte no animada del árbol de widgets.
La animación comienza cuando se detecta un toque en cualquier parte de la pantalla.

[Código completo para el main.dart de basic_staggered_animation](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/animation/basic_staggered_animation/main.dart)

### Widget sin estado: StaggerAnimation

En el widget sin estado, StaggerAnimation, la función `build ()` crea una instancia de
[AnimatedBuilder](https://docs.flutter.io/flutter/widgets/AnimatedBuilder-class.html)&mdash;a
Widget de propósito general para la construcción de animaciones. El AnimatedBuilder
crea un widget y lo configura usando los valores actuales de los preadolescentes.
El ejemplo crea una función llamada `_buildAnimation ()` (que realiza
las actualizaciones reales de la interfaz de usuario), y lo asigna a su propiedad `builder`.
AnimatedBuilder escucha las notificaciones del controlador de animación,
marcando el árbol de widgets sucio a medida que cambian los valores.
Para cada tick de la animación, los valores se actualizan,
dando como resultado una llamada a `_buildAnimation ()`.

<!-- skip -->
{% prettify dart %}
[[highlight]]clase StaggerAnimation extiende StatelessWidget[[/highlight]] {
  StaggerAnimation({ Key key, this.controller }) :

    // Cada animación definida aquí transforma su valor durante el subconjunto.
    // de la duración del controlador definida por el intervalo de la animación.
    // Por ejemplo, la animación de opacidad transforma su valor durante
    // El primer 10% de la duración del controlador.

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

    // ... Otras definiciones de interpolación ...

    super(key: key);

  [[highlight]]final Animation<double> controller;[[/highlight]]
  [[highlight]]final Animation<double> opacity;[[/highlight]]
  [[highlight]]final Animation<double> width;[[/highlight]]
  [[highlight]]final Animation<double> height;[[/highlight]]
  [[highlight]]final Animation<EdgeInsets> padding;[[/highlight]]
  [[highlight]]final Animation<BorderRadius> borderRadius;[[/highlight]]
  [[highlight]]final Animation<Color> color;[[/highlight]]

  // Esta función se llama cada vez que el controlador "marca" un nuevo marco.
  // Cuando se ejecuta, todos los valores de la animación habrán sido
  // actualizado para reflejar el valor actual del controlador.
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

### Widget de estado: StaggerDemo

El widget con estado, StaggerDemo, crea el controlador de animación
(el que los gobierna a todos), especificando una duración de 2000 ms. Juega
la animación, y construye la parte no animada del árbol de widgets.
La animación comienza cuando se detecta un toque en la pantalla.
La animación corre hacia adelante, luego hacia atrás.

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
      // La animación se canceló, probablemente porque estábamos dispuestos.
    }
  }

  @override
  [[highlight]]Widget build(BuildContext context)[[/highlight]] {
    timeDilation = 10.0; // 1.0 is normal animation speed.
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

Los siguientes recursos pueden ayudar al escribir animaciones:

[Página de inicio de animaciones](/docs/development/ui/animations)
: Enumera la documentación disponible para animaciones Flutter.
  Si las preadolescentes son nuevas para ti, echa un vistazo a la
  [Tutorial de animaciones](/docs/development/ui/animations/tutorial).

[Documentación de la API Flutter](https://docs.flutter.io/)
: Documentación de referencia para todas las bibliotecas de Flutter.
  En particular, ver la [biblioteca
  de animaciones](https://docs.flutter.io/flutter/animation/animation-library.html)
  documentacion.

[Galería de aleteo](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)
: Aplicación de demostración que muestra muchos componentes de material y otros Flutter
  caracteristicas.  El [Santuario
  manifestación](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery/lib/demo/shrine)
  Implementa una animación de héroe.

[Material de movimiento espec.](https://material.io/guidelines/motion/)
: Describe el movimiento para aplicaciones de material.

{% comment %}
Paquete aún no examinado.

## Otros recursos

* Para un enfoque alternativo a la secuencia de animación, vea el paquete
[flutter_sequence_animation](https://pub.dartlang.org/packages/flutter_sequence_animation)
en [pub.dartlang.org](https://pub.dartlang.org/packages).
{% endcomment %}
