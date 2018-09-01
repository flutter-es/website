---
layout: page
title: "Tutorial: Animaciones en Flutter"
permalink: /tutorials/animation/
---

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>Lo que aprenderás:</b>

* Como usar clases fundamentales de la biblioteca de animaciones para añadir 
  animaciones a un widget.
* Cuando usar AnimatedWidget vs. AnimatedBuilder.

</div>

Este tutorial te muestra como construir animaciones en Flutter.
Después de introducir algunos conceptos esenciales, clases y métodos, 
de la biblioteca de animaciones, te conduce a través de 5 ejemplos de animación.
Los ejemplos se basan unos en otros,
introduciéndote en diferentes aspectos de la biblioteca de animaciones.

* [Conceptos y clases esenciales de animaciones](#concepts)
  * [Animations&lt;double&gt;](#animation-class)
  * [AnimationController](#animationcontroller)
  * [CurvedAnimation](#curvedanimation)
  * [Tween](#tween)
  * [Notificaciones de Animation](#animation-notifications)
* [Ejemplos de animaciones](#animation-examples)
  * [Renderizando animaciones](#rendering-animations)
  * [Monitorizar el progreso de una animación](#monitoring)
  * [Simplicando con AnimatedWidget](#simplifying-with-animatedwidget)
  * [Refactorizando con AnimatedBuilder](#refactoring-with-animatedbuilder)
  * [Animaciones simultáneas](#simultaneous-animations)
* [Siguientes pasos](#next-steps)

<a name="concepts"></a>
## Conceptos y clases esenciales de animaciones

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* El objeto Animation, una clase principal en la biblioteca de animaciones de Flutter,
  interpola los valores usados para guiar una animación.
* El objeto Animation conoce el estado actual de una animación (por ejemplo,
  ya sea que, ha comenzado, parado, o se mueve adelante o hacia atrás),
  pero no sabe nada de lo que aparece en la pantalla.
* Un AnimationController administra el Animation.
* Un CurvedAnimation define progresiones como una curva no lineal.
* Un Tween interpola entre el rango de datos usados por el objeto que 
  está siendo animado. Por ejemplo, un Tween podría definir una interpolación 
  de rojo a azul, o de 0 a 255.
* Usa Listeners y StatusListeners para monitorizar los cambios de estado de la animación.

</div>

El sistema de animaciones en Flutter está basado en 
objetos [`Animation`](https://docs.flutter.io/flutter/animation/Animation-class.html) tipados. 
Los widgets pueden incorporar estos objetos animation en sus funciones build directamente 
al leer su valor actual y escuchar sus cambios de estado, o pueden usarlos como la base
de animaciones mas elaboradas que pasan a través de otros widgets.

<a name="animation-class"></a>
### Animation&lt;double&gt;

En Flutter, un objeto Animation no sabe nada sobre que hay en la pantalla.
Un objeto Animation es una clase abstracta que entiende su valor actual y 
su estado (completado o rechazado). Uno de los tipos de animation mas comúnmente 
usados es Animation&lt;double&gt;.

Un objeto Animation en Flutter es una clase que genera secuencialmente números 
interpolándolos entre dos valores durante una cierta duración.
La salida de un objeto Animation puede ser lineal, una curva, una función por pasos,
o cualquier otro mapeado que puedas idear. Dependiendo de como el objeto Animation 
se controle, podría ejecutarse en modeo inverso, o incluso cambiar la dirección en 
el medio.

Los objetos Animation pueden también interpolar otros tipos diferentes a double, como 
Animation&lt;Color&gt; o Animation&lt;Size&gt;.

El objeto `Animation` tiene estado. El valor actual siempre esta disponible 
en la propiedad `.value`.

Un objeto Animation no conoce nada sobre renderizado o funciones `build()`.

### CurvedAnimation

Un objeto CurvedAnimation define el progreso de una animación como una curva no lineal.

<!-- skip -->
{% prettify dart %}
final CurvedAnimation curve =
    CurvedAnimation(parent: controller, curve: Curves.easeIn);
{% endprettify %}

<aside class="alert alert-success" markdown="1">
**Nota:**
La clase [Curves](https://docs.flutter.io/flutter/animation/Curves-class.html) 
define muchas curvas usadas comúnmente, o puedes crear la tuya propia.
Por ejemplo:

<!-- skip -->
{% prettify dart %}
class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(t * math.PI * 2);
  }
}
{% endprettify %}
</aside>

CurvedAnimation y AnimationController (descrito en la siguiente sección), 
son ambas de tipo Animation&lt;double&gt;, puedes pasarlas de forma intercambiable.
El objeto CurvedAnimation envuelve el objeto que está modificando&mdash;no puedes 
hacer una subclase de AnimationController para implementar una curva.

### AnimationController

AnimationController es un objeto Animation especial que genera un nuevo valor 
cada vez que el hardware esta preparado para un nuevo frame. Por defecto,
un AnimationController produce linealmente números desde 0.0 a 1.0
durante una duración dada. Por ejemplo, este código crea un objeto Animation, 
pero no comienza su ejecución:

<!-- skip -->
{% prettify dart %}
final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 2000), vsync: this);
{% endprettify %}

AnimationController deriva de Animation&lt;double&gt;, por esto puede ser 
usado donde quiera que se necesite un objeto Animation. Sin embargo, AnimationController 
tiene métodos adicionales para controlar la animación. Por ejemplo, inicias una animación 
con el método `.forward()`. La generación de números está vinculada al refresco de 
la pantalla, normalmente son generados 60 numeros por segundo. Después de que cada número 
es generado, cada objeto Animation llama a sus objetos Listener asociados. Para crear 
una lista personalizada para cada hijo, mira
[RepaintBoundary](https://docs.flutter.io/flutter/widgets/RepaintBoundary-class.html).

Cuando creas un AnimationController, le pasas un argumento `vsync`. 
La presencia de `vsync` previene animaciones fuera de pantalla que consuman 
recursos innecesarios. Puedes usar tu objeto stateful como vsync 
añadiendo SingleTickerProviderStateMixin a la definición de la clase.
Puedes ver un ejemplo de esto en 
[animate1](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/animation/animate1/main.dart)
en GitHub.
{% comment %}
The `vsync` object ties the ticking of the animation controller to
the visiblity of the widget, so that when the animating widget goes
off-screen, the ticking stops, and when the widget is restored, it
starts again (without stopping the clock, so it's as if it had
been ticking the whole time, but without using the CPU.)
To use your custom State object as the `vsync`, include the
`TickerProviderStateMixin` when defining the custom State class.
{% endcomment %}

<aside class="alert alert-success" markdown="1">
**Nota**:
En algunos casos, una posición podria sobrepasar el rango 0.0-1.0 del 
AnimationController. Por ejemplo, la función `fling()` te permite proporcionar 
velocidad, fuerza y posicion (vía el objeto Force).
La posición puede ser cualquiera y puede estar fuera del rango entre 0.0 y 1.0.

Un CurvedAnimation puede también sobrepasar el rango de 0.0 a 1.0,
en cambio AnimationController no puede. Dependiendo de la curva seleccionada,
la salida de CurvedAnimation puede ser un rango mas amplio que la entrada.
Por ejemplo, las curvas elásticas como Curves.elasticIn sobrepasaran 
significativamente el rango por defecto tanto por abajo como por arriba.
</aside>

### Tween

Por defecto, el objeto AnimationController tiene rangos entre 0.0 y 1.0.
Si necesitas un rango diferente o un tipo de datos diferente, 
puedes usar Tween para configurar un objeto animation que interpole 
un rango o tipo de dato diferente. Por ejemplo, el siguiente Tween
va desde -200.0 a 0.0:

<!-- skip -->
{% prettify dart %}
final Tween doubleTween = Tween<double>(begin: -200.0, end: 0.0);
{% endprettify %}

Un Tween es un objeto stateless que solo toma las propiedades `begin` y `end`.
El único trabajo de un Tween es definir un mapeado entre un rango de entrada 
y un rango de salida. El rango de entrada en normalment 0.0 a 1.0,
pero esto no es un requisito.

Un Tween hereda de Animatable&lt;T&gt;, no de Animation&lt;T&gt;.
Un Animatable, como un Animation, no tiene porque tener una salida de tipo double.
Por ejemplo, ColorTween especifica una progresión entre dos colores.

<!--- skip -->
{% prettify dart %}
final Tween colorTween =
    ColorTween(begin: Colors.transparent, end: Colors.black54);
{% endprettify %}

Un objeto Tween no almacena ningun estado. En cambio, provee el método 
`evaluate(Animation<double> animation)` que aplica la función de mapeado 
al valor actual del objeto Animation. El valor actual del 
objeto `Animation` puede ser encontrado en el método `.value`.
La función evaluate function también realiza algunas labores de limpieza, 
como asegurar que se devuelva begin y end cuando los valores del objeto 
animation sean 0.0 y 1.0, respectivamente.

#### Tween.animate

Para usar el objeto Tween, llama a `animate()` en Tween, pasado en el 
objeto controller. Por ejemplo, el siguiente código genera los valores 
enteros entre 0 y 255 en el trascurso de 500 ms.

<!-- skip -->
{% prettify dart %}
final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 500), vsync: this);
Animation<int> alpha = IntTween(begin: 0, end: 255).animate(controller);
{% endprettify %}

Noe que `animate()` devuelve un Animation, no un Animatable.

El siguiente ejemplo muestra un controller, un curve, y un Tween:

<!-- skip -->
{% prettify dart %}
final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 500), vsync: this);
final Animation curve =
    CurvedAnimation(parent: controller, curve: Curves.easeOut);
Animation<int> alpha = IntTween(begin: 0, end: 255).animate(curve);
{% endprettify %}

### Notificaciones de Animation

Un objeto Animation puede  tener Listeners y StatusListeners,
definidos con `addListener()` y `addStatusListener()`.
Un Listener es llamadno cada vez que el valor del objeto animation cambia.
El comportamiento mas habitual de un Listener es llamar a `setState()` 
para provocar un rebuild. Un StatusListener es llamado cuando una animación empieza, 
finaliza, se mueve hacia delante, o se mueve hacia atrás, como es definido por AnimationStatus.
La nueva sección tiene un ejemplo del método `addListener()`, 
y [Monitoriza el progreso de la animación](#monitoring) monstrando un ejemplo de 
`addStatusListener()`.

---

## Ejemplo de animaciones

Esta sección te conduce a través de 5 ejemplos de animaciones.
Cada sección proporciona un enlace al código fuente del ejemplo.

### Rendering animations

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* Como añadir animación básica a un widget usando `addListener()` y
  `setState()`.
* Cada vez que el objeto Animation genera un nuevo número, la función `addListener()`
  llama a `setState()`.
* Como definir un AnimatedController con el parámetro `vsync` requerido.
* Entendindo la sintaxis "`..`" en "`..addListener`", también conocida como 
  _cascade notation_ en Dart.
* Para hacer una clase privada, inicia su nombre con un guión bajo (`_`).

</div>

Hasta ahora has aprendido como generar una secuencia de números en el trascurso del un tiempo.
Nada se ha renderizado en la pantalla. Para renderizar con un objeto 
Animation&lt;&gt;, guarda el objeto Animation como un miembro de tu Widget, entonces 
usa su valor para decidir que dibujar.

Considera la siguiente aplicación que dibuja el logo de Flutter 
sin animación:

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> {
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: 300.0,
        width: 300.0,
        child: FlutterLogo(),
      ),
    );
  }
}

void main() {
  runApp(LogoApp());
}
{% endprettify %}

Lo siguiente muestra el mismo código modificado para animar el logo 
para crecer de nada al tamaño completo. Cuando defines 
un AnimationController, debes pasarlo en un objeto `vsync`.
El parámetro `vsync` es descrito en la sección 
[AnimationController](#animationcontroller).

Los cambios desde el ejemplo no animado están resaltados:

<!-- skip -->
{% prettify dart %}
[[highlight]]import 'package:flutter/animation.dart';[[/highlight]]
import 'package:flutter/material.dart';

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> [[highlight]]with SingleTickerProviderStateMixin[[/highlight]] {
  [[highlight]]Animation<double> animation;[[/highlight]]
  [[highlight]]AnimationController controller;[[/highlight]]

  [[highlight]]initState() {[[/highlight]]
    [[highlight]]super.initState();[[/highlight]]
    [[highlight]]controller = AnimationController([[/highlight]]
        [[highlight]]duration: const Duration(milliseconds: 2000), vsync: this);[[/highlight]]
    [[highlight]]animation = Tween(begin: 0.0, end: 300.0).animate(controller)[[/highlight]]
      [[highlight]]..addListener(() {[[/highlight]]
        [[highlight]]setState(() {[[/highlight]]
          [[highlight]]// El estado que ha cambiado aquí es el valor del objeto animation[[/highlight]]
        [[highlight]]});[[/highlight]]
      [[highlight]]});[[/highlight]]
    [[highlight]]controller.forward();[[/highlight]]
  [[highlight]]}[[/highlight]]

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: [[highlight]]animation.value,[[/highlight]]
        width: [[highlight]]animation.value,[[/highlight]]
        child: FlutterLogo(),
      ),
    );
  }

  [[highlight]]dispose() {[[/highlight]]
    [[highlight]]controller.dispose();[[/highlight]]
    [[highlight]]super.dispose();[[/highlight]]
  }
}

void main() {
  runApp(LogoApp());
}
{% endprettify %}

La función `addListener()` llama a `setState()`, cada vez que el objeto 
Animation genera un nuevo número, el frame actual es marcado como dirty,
lo caul fuerza al método `build()` a ser llamado de nuevo.
En la función `build()`, el container cambia su tamaño porque su altura y anchura
ahora usan `animation.value` en lugar de un valor fijo.
Deseche con el método dispose el controlador cuando la animación haya terminado para prevenir 
_memory leaks_.

Con estos pocos cambioss, habrás creado, ¡tu primera animación en Flutter!
Puedes encontrar el código fuente para este ejemplo en,
[animate1.](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/animation/animate1/main.dart)

<aside class="alert alert-success" markdown="1">
**Trucos del lenguaje Dart**
PUede que no estes familiarizado cocn la notacion en cascada de Dart&mdash;los dos 
puntos en `..addListener()`. Esta sintaxis significa que el método `addListener()`
es llamado con el valor devuelto desde `animate()`.
Considera el siguiente ejemplo:

<!-- skip -->
{% prettify dart %}
[[highlight]]animation = tween.animate(controller)[[/highlight]]
          [[highlight]]..addListener(()[[/highlight]] {
            setState(() {
              // el valor del objeto animation es el estado cambiado
            });
          });
{% endprettify %}

Este código es equivalente a:

<!-- skip -->
{% prettify dart %}
[[highlight]]animation = tween.animate(controller);[[/highlight]]
[[highlight]]animation.addListener(()[[/highlight]] {
            setState(() {
              // the animation object’s value is the changed state
            });
          });
{% endprettify %}

Puedes aprender más sobre la notación en cascada en el 
[Dart Language Tour.](https://www.dartlang.org/guides/language/language-tour)
</aside>

###  Simplificando con AnimatedWidget

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* Como usar la clase helper AnimatedWidget (en lugar de `addListener()`
  y `setState()`) para crear un widget que se anime.
* Usa AnimatedWidget para crear un widget que realiza una animación reutilizable.
  Para separar la transición desde el widget, usa un
  [AnimatedBuilder.](#refactoring-with-animatedbuilder)
* Ejemplos de AnimatedWidgets en la API de Flutter: AnimatedBuilder,
  AnimatedModalBarrier, DecoratedBoxTransition, FadeTransition,
  PositionedTransition, RelativePositionedTransition, RotationTransition,
  ScaleTransition, SizeTransition, SlideTransition.

</div>

La clase AnimatedWidget te permte separar el código del widger 
del código de la animación en la llamada a `setState()`. AnimatedWidget 
no neceita mantener un objeto State para sostener la animación.

En el ejemplo refactorizado más abajo, LogoApp ahora deriva de AnimatedWidget
en lugar de StatefulWidget. AnimatedWidget usa el valor actual del objeto animation 
cuando se dibuja a si mismo. LogoApp todavía administra el 
AnimationController y el Tween.

<!-- skip -->
{% prettify dart %}
// Demuestra una simple animación con AnimatedWidget

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
}

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();
  }

  Widget build(BuildContext context) {
    return AnimatedLogo(animation: animation);
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

void main() {
  runApp(LogoApp());
}
{% endprettify %}

LogoApp pasa el objeto Animation a la clase base y usa 
`animation.value` para fijar el alto y el ancho del container, funcionando entonces 
exactamente igual que antes.

Puedes encontrar el código fuente para este ejemplo en, 
[animate2,](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/animation/animate2/main.dart)
en GitHub.

<a name="monitoring"></a>
### Monitorzando el progreso de la animación

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* Usa addStatusListener para notificaciones de cambios del estado de la animacion, 
  como empenzando, parando, o invirtiendo la dirección.
* Ejecuta una animación en un loop infinito, invirtiendo la dirección cuando la animación 
  ha sido completada o regresado a su estado de inicio.

</div>

A menudo es útil saber cuando una animación cambia su estado,
como cuando finaliza, avanza hacia delante, o hacia atrás.
Puedes obtener notificaciones de esto con `addStatusListener()`.
El siguiente códgo modifica el ejemplo 
[animate1](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/animation/animate1/main.dart)
para que escuche los cambios de estado e imprima una actualización.
Las líneas resaltadas muestran los cambios:

<!-- skip -->
{% prettify dart %}
class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 300.0).animate(controller)
      [[highlight]]..addStatusListener((state) => print("$state"));[[/highlight]]
    controller.forward();
  }
  //...
}
{% endprettify %}

Ejecutar este código produce líneas como las siguientes:

<!-- skip -->
{% prettify sh %}
AnimationStatus.forward
AnimationStatus.completed
{% endprettify %}

A continuación, usa `addStatusListener()` para invertir la animación en el principio 
o en el final. Esto crea un efecto "respiración":

<!-- skip -->
{% prettify dart %}
class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 300.0).animate(controller);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }
  //...
}
{% endprettify %}

Puedes encontrar el código fuente para este ejemplo en, 
[animate3,](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/animation/animate3/main.dart)
en GitHub.

### Refactorizando con AnimatedBuilder

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* Un AnimatedBuilder entiende como renderizar la transición.
* Un AnimatedBuilder no conoce como renderizar el widget, ni tampoco 
  administra el objeto Animation.
* Usa AnimatedBuilder para describir una animación como parte de un método build 
  de otro widget. Si solo quieres definir un widget con una animación reusable, 
  use [AnimatedWidget.](#simplifying-with-animatedwidget)
* Ejemplos de AnimatedBuilders en la API de Flutter: BottomSheet, ExpansionTile,
  PopupMenu, ProgressIndicator, RefreshIndicator, Scaffold, SnackBar, TabBar,
  TextField.

</div>

Un problema con el código en el ejemplo 
[animate3](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/animation/animate3/main.dart)
, es que cambiar la animación requiere cambiar el widget que renderiza el logo.
Una mejor solución es separar las responsabilidades en dos clases diferentes:

* Renderizar el logo
* Definir el objeto Animation
* Renderizar la transición

Puedes conseguir esta separación con la ayuda de la clase 
AnimatedBuilder. Un AnimatedBuilder es una clase separada en el 
árbol de renderizado. Como AnimatedWidget, AnimatedBuilder automáticamente 
escucha las notificaciones del objeto Animation, y marka 
el árbol de widgets como _dirty_ cuando sea necesario, entonces no necesitas 
llamar a `addListener()`.

El árbol de widgets para el ejemplo 
[animate5](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/animation/animate5/main.dart)
se ve como esto:

<img src="images/AnimatedBuilder-WidgetTree.png" alt="Un árbol de widget con un Container apuntando a ContainerTransition, apuntando a AnimatedBuilder, apuntando a (AnonymousBuilder), apntando a LogoWidget.">

Empezando por el fondo del árbol de widget, el código para renderizar el 
logo es sencillo:

<!-- skip -->
{% prettify dart %}
class LogoWidget extends StatelessWidget {
  // Deja fuera la altura y la anchura ya que esto lo rellenará el padre animado
  build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: FlutterLogo(),
    );
  }
}
{% endprettify %}

Los tres bloques centrales en el diagrama son todos creados en el método 
`build()` en GrowTransition. El widget GrowTransition en si mismo 
es stateless y soporta el conjunto final de variable necesarias para 
definir la animación de transición. La función build() crea y devuelve 
el AnimatedBuilder, que toma el método (constructor anónimo) y 
el objeto LogoWidget como parámetros. El trabajo de renderizar 
la transición actualmente ocure en el método (construcor anónimo), 
que crea un Container del tamaño apropiado para forzar a 
LogoWidget a ajustarse para llenarlo.

Un punto complicado en el código más abajo hijo se ve como si se hubiera definido 
dos veces. Lo que está ocurriendo es que la referencia externa del hijo esta siendo 
pasada al AnimatedBuilder, el cual pase este a la función anónima, que usa este objeto 
como su hijo. La red resulta en que AnimatedBuilder es insertado entre los dos widgets 
en el árbol de renderizado.

<!-- skip -->
{% prettify dart %}
class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) {
            return Container(
                height: animation.value, width: animation.value, child: child);
          },
          child: child),
    );
  }
}
{% endprettify %}

Finalmente, el código para iniciar la animación se ve muy similar al primer ejemplo,
[animate1.](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/animation/animate1/main.dart)
El método `initState()` crea un AnimationController
y un Tween, enconces vincula estos con `animate()`. La mágia ocurre en el método 
`build()`, que devuelve un objeto GrowTransition con un 
LogoWidget como hijo, un objeto animation para dirigir la transición.
Estos son los tres elementos listados en los puntos más arriba.


<!-- skip -->
{% prettify dart %}
class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with TickerProviderStateMixin {
  Animation animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animation = Tween(begin: 0.0, end: 300.0).animate(curve);
    controller.forward();
  }

  Widget build(BuildContext context) {
    return GrowTransition(child: LogoWidget(), animation: animation);
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

void main() {
  runApp(LogoApp());
}
{% endprettify %}

Puedes encontrar el código fuente para este ejemplo, 
[animate4,](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/animation/animate4/main.dart)
en GitHub.

### Animaciones simultáneas

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* La clase [Curves](https://docs.flutter.io/flutter/animation/Curves-class.html)
  define un array de curvas usadas comúnmente que puedes usar con un 
  [CurvedAnimation](https://docs.flutter.io/flutter/animation/CurvedAnimation-class.html).

</div>

En esta sección, construirás el ejemplo de [monitorizando 
el progreso de la animación](#monitoring)
([animate3](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/animation/animate3/main.dart)),
que usa AnimatedWidget para animarlo dentro y fuera continuamente. Considera el caso en que 
queras animar adentro y afuera mientras que animas la opacidad de transparente a opaco.

<aside class="alert alert-success" markdown="1">
**Nota:**
Este ejemplo muestra como usar múltiples tweens en el mismo animation controller, 
donde cada uno administra un efecto diferente en la animación.
Solo para fines ilustrativos. Si quieres interpolar la opacidad y el tamaño 
en código de producción, problamente deberías usar 
[FadeTransition](https://docs.flutter.io/flutter/widgets/FadeTransition-class.html) y
[SizeTransition](https://docs.flutter.io/flutter/widgets/SizeTransition-class.html)
en su lugar.
</aside>

Cada tween administra un aspecto de la animación. Por ejemplo:

<!-- skip -->
{% prettify dart %}
final AnimationController controller =
    AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
final Animation<double> sizeAnimation =
    Tween(begin: 0.0, end: 300.0).animate(controller);
final Animation<double> opacityAnimation =
    Tween(begin: 0.1, end: 1.0).animate(controller);
{% endprettify %}

Puedes obtber el tamaño con `sizeAnimation.value` y la opacidad con 
`opacityAnimation.value`, pero el construcor para AnimatedWidget
solo toma un único objeto Animation. Para resolver este problema,
el ejemplo crea su propio objeto Tween y calcula los valores explícitamente.

El widget LogoApp fue cambiado para encapsular sus propios objetos Tween.
Su método `build` llama a la función `.evaluate()` del Tween  en el objeto
animation padre para calucar el tamaño requerido y los valores de opacidad.

El siguiente código muestra los cambios con resaltado:

<!-- skip -->
{% prettify dart %}
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AnimatedLogo extends AnimatedWidget {
  // Los Tweens son estáticos porque no cambian.
  [[highlight]]static final _opacityTween = Tween<double>(begin: 0.1, end: 1.0);[[/highlight]]
  [[highlight]]static final _sizeTween = Tween<double>(begin: 0.0, end: 300.0);[[/highlight]]

  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      [[highlight]]child: Opacity([[/highlight]]
        [[highlight]]opacity: _opacityTween.evaluate(animation),[[/highlight]]
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          height: [[highlight]]_sizeTween.evaluate(animation)[[/highlight]],
          width: [[highlight]]_sizeTween.evaluate(animation)[[/highlight]],
          child: FlutterLogo(),
        ),
      ),
    );
  }
}

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = [[highlight]]CurvedAnimation(parent: controller, curve: Curves.easeIn);[[/highlight]]

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  Widget build(BuildContext context) {
    return AnimatedLogo(animation: animation);
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

void main() {
  runApp(LogoApp());
}
{% endprettify %}

Puedes encontrar el código fuente para este ejemplo en, 
[animate5,](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/animation/animate5/main.dart)
en GitHub.

## Siguientes pasos

Este tutorial te da una base para crear animaciones en Flutter usando Tweens, 
pero hay muchas otras clases a explorar.
Puedes investigar las clases especializadas Tween,
animaciones específicas de Material Design, ReverseAnimation, elementos compartidos 
en transiciones (también conocidas como animaciones Hero), simulaciones físicas y 
métodos `fling()`. Mira la [página animaciones](/animations/) 
para los últimos documentos y ejemplos disponibles.