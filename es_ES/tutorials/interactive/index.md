---
layout: tutorial
title: "Añade Interactividad a Tu App Flutter"

permalink: /tutorials/interactive/
---

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>Lo que aprenderás:</b>

* Como responder a gestos tap.
* Como crear un widget personalizado.
* La diferencia entre stateless y stateful widgets.

</div>

¿Cómo modificas tu app para hacer que reaccione a las entradas del usuario?
En este tutorial, añadirás interactividad a una app que contiene solo widgets 
no interactivos. Específicamente, modificarás un icono para hacerlo 
pulsable creando un widget stateful personalizado que administra 
dos widgets stateless.

### Contenidos

* [Widgets stateful y stateless](#stateful-stateless)
* [Creando un widget stateful](#creating-stateful-widget)
  * [Paso 1: Decide cual objeto maneja el estado del widget](#step-1)
  * [Paso 2: Subclase de StatefulWidget](#step-2)
  * [Paso 3: Subclase de State](#step-3)
  * [Paso 4: Enchufa el widget stateful en el árbol de widgets](#step-4)
  * [¿Problemas?](#problems)
* [Administrando el estado](#managing-state)
  * [El widget administra su propio estado](#self-managed)
  * [El padre administra el estado del widget](#parent-managed)
  * [Una aproximación intermedia](#mix-and-match)
* [Otros widgets interactivos](#other-interactive-widgets)
  * [Widgets standard](#standard-widgets)
  * [Material Components](#material-components)
* [Recursos](#resources)

## Preparándose

Si ya has contruido el layout en 
[Construyendo Layouts en Flutter](/tutorials/layout/),
salta a la siguiente sección.

* Asegúrate que has [configurado](/get-started/install/) tu entorno.
* [Crea una app Flutter básica.](/get-started/test-drive/#create-app)
* Reemplaza el fichero `lib/main.dart` con
  [`main.dart`](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/main.dart)
  en GitHub.
* Reemplaza el fichero `pubspec.yaml` con 
  [`pubspec.yaml`](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/pubspec.yaml)
  en GitHub.
* Crea un directorio `images` en tu proyecto, y añade 
  [`lake.jpg`.](https://github.com/flutter/website/blob/master/src/_includes/code/layout/lakes/images/lake.jpg)

Cuando tienes un dispositivo conectado y habilitado, o has lanzado el [simulador 
iOS](/setup-macos/#set-up-the-ios-simulator) (parte de la instalación de Flutter),
¡estás preparado para seguir!

[Construyendo Layouts en Flutter](https://flutter.io/tutorials/layout/)
mostró como crear el layout de la siguiente captura de pantalla.

<img src="images/lakes.jpg" style="border:1px solid black" alt="La app de inicio Lakes que modificaremos">

Cuando la app se lanza por primera vez, la estrella esta rellena de rojo, indicando que este lago 
ha sido marcado previamente como favorito. El número a continuación de la estrella indica que 
41 personas han marcado como favorito este lago. Después de completar este tutorial,
pulsando la estrella se desmarcará como favorito, reemplazando la estrella rellena 
con una sin relleno y decrecerá el contador. Pulsando de nuevo 
se marca el lago como favorito, dibujando la estrella rellena e incrementando el contador.

<img src="images/favorited-not-favorited.png" alt="el widget custom que crearás">

Para lograr esto, crearás un widget personalizado que incluye tanto la estrella 
como el contador, que son a su vez widgets. Como pulsar sobre la estrella 
cambia el estado de ambos widgets, entonces el mismo debería administrar ambos.

Puedes empezar a tocar el código en 
[Paso 2: Subclase StatefulWidget](#step-2).
Si quieres probar diferentes maneras de administrar el estado, salta a
[Administrando el estado](#managing-state).

<a name="stateful-stateless"></a>
## Widgets Stateful y stateless

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* Algunos widgets son stateful, y otros son stateless.
* Si un widget cambia&mdash;por ejemplo, cuando el usuario 
  interactúa con el&mdash;es _stateful_.
* El estado de un widget consiste en valores que pueden cambiar, como el valor actual 
  de un slider o cuando un checkbox esta marcado como checked.
* El estado de un widget es almacenado en un objeto State, separando el estado del widget 
  de su apariencia.
* Cuando el estado de un widget cambia, el objeto state llama a 
  `setState()`, diciendo al framework que repinte el widget.

</div>

Un widget _stateless_ no tiene estado interno que administrar.
[Icon](https://docs.flutter.io/flutter/widgets/Icon-class.html),
[IconButton](https://docs.flutter.io/flutter/material/IconButton-class.html),
y [Text](https://docs.flutter.io/flutter/widgets/Text-class.html) son
ejemplos de widgets stateless, los cuales son subclases de 
[StatelessWidget](https://docs.flutter.io/flutter/widgets/StatelessWidget-class.html).

Un widget _stateful_ es dinámico. El usuario puede interactuar con un stateful widget 
(escribiendo en un formulario, o moviendo un slider, por ejemplo),
o este cambia a lo largo del tiempo (por ejemplo la obtención de datos que causa que se actualice la UI).
[Checkbox](https://docs.flutter.io/flutter/material/Checkbox-class.html),
[Radio](https://docs.flutter.io/flutter/material/Radio-class.html),
[Slider](https://docs.flutter.io/flutter/material/Slider-class.html),
[InkWell](https://docs.flutter.io/flutter/material/InkWell-class.html),
[Form](https://docs.flutter.io/flutter/widgets/Form-class.html), and
[TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
son ejemplos de widgets stateful, los cuales son subclases de 
[StatefulWidget](https://docs.flutter.io/flutter/widgets/StatefulWidget-class.html).

<a name="creating-stateful-widget"></a>
## Creando un widget stateful

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* Para crear un widget stateful, se hereda de dos clases:
  StatefulWidget y State.
* El objeto state contiene el estado del widget y el método `build()`.
* Cuando el estado del widget cambia, el objeto state llama a 
  `setState()`, diciéndole al framework que redibuje el widget.

</div>

En esta sección, crearás un widget stateful personalizado.
Reemplazarás dos widgets stateless&mdash;la estrella rellena de rojo y el 
contador numérico junto a ella&mdash;con un único stateful widget 
personalizado que administra una fila con dos widgets hijos: un IconButton
y un Text.

Implementar un widget stateful personalizado requiere crear dos clases:

* Una subclase de StatefulWidget que define el widget.
* Una subclase de State que contiene el estado para el widget y define el método 
  `build()`.

Esta sección muestra como construir un StatefulWidget, llamado FavoriteWidget,
para la app Lakes. El primer paso es elegir como administrar el estado de FavoriteWidget.

<a name="step-1"></a>
### Paso 1: Decide cual objeto administra el estado del widget

El estado de un widget puede ser administrado de varias maneras, pero en nuestro ejemplo, 
el widget FavoriteWidget, administrará por si mismo su estado.
En este ejemplo, alternar la estrella es una acción aislada que no afecta 
al widget padre o al resto de la UI, por eso el widget puede manejar su estado 
internamente.

Aprende mas acerca de la separación de widget y estado,
y como puede ser admnistrado el estado, en [Administrando el estado](#managing-state).

<a name="step-2"></a>
### Paso 2: Subclase StatefulWidget

La clase FavoriteWidget administra su propio estado, sobreescribiendo el método 
`createState()` para crear el objeto State.
El framework llama a `createState()` cuando quiere construir el widget.
En este ejemplo, `createState()` crea una instancia de _FavoriteWidgetState,
que implementarás en el siguiente paso.

<!-- code/layout/lakes-interactive/main.dart -->
<!-- skip -->
{% prettify dart %}
class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}
{% endprettify %}

<aside class="alert alert-info" markdown="1">
**Nota:**
Miembros o clases que empiezan con un guión bajo (_) son privados.
Para más información, mira [Bibliotecas y visibilidad,](https://www.dartlang.org/guides/language/language-tour#libraries-and-visibility)
una sección en el 
[Dart language tour.](https://www.dartlang.org/guides/language/language-tour)
</aside>

<a name="step-3"></a>
### Paso 3: Subclase State

La clase State personalizada, almacena la información mutable&mdash;la lógica y 
estado interno que puede cambiar durante el tiempo de vida del widget.
Cuando la app se lanza por primera vez, la UI muestra una estrella rellena de rojo,
indicando que el lago tiene el estado "favorite", y tiene 41 “likes”.
El objeto state almacena esta información en las variables 
`_isFavorited` y `_favoriteCount`.

El objeto state también define el método `build`. Este método `build` 
crea una fila conteniendo un IconButton rojo, y un Text. El widget usa 
[IconButton](https://docs.flutter.io/flutter/material/IconButton-class.html),
(en lugar de Icon), porque este tiene una propiedad `onPressed` que 
define el método callback para manejar un gesto tap.
IconButton tambien tiene una propiedad `icon` que guarda el Icon.

El método `_toggleFavorite()`, que es llamado couando el IconButton es presionado,
llama a `setState()`. Llamar a `setState()` es fundamental, porque esto dice 
al framework que el estado del widget ha cambiado y el widget deberia redibujarse. 
La función `_toggleFavorite` alterna la UI entre 
1) un icono star y el número ‘41’, y
2) un icono star_border y el número ‘40’.

<!-- code/layout/lakes-interactive/main.dart -->
<!-- skip -->
{% prettify dart %}
class _FavoriteWidgetState extends State<FavoriteWidget> {
  [[highlight]]bool _isFavorited = true;[[/highlight]]
  [[highlight]]int _favoriteCount = 41;[[/highlight]]

  [[highlight]]void _toggleFavorite()[[/highlight]] {
    [[highlight]]setState(()[[/highlight]] {
      // Si el lago esta marcado actualmente como favorito, lo desmarca como favorito.
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
        // En otro caso, lo marca como favorito.
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0.0),
          child: IconButton(
            [[highlight]]icon: (_isFavorited[[/highlight]]
                [[highlight]]? Icon(Icons.star)[[/highlight]]
                [[highlight]]: Icon(Icons.star_border)),[[/highlight]]
            color: Colors.red[500],
            [[highlight]]onPressed: _toggleFavorite,[[/highlight]]
          ),
        ),
        SizedBox(
          width: 18.0,
          child: Container(
            [[highlight]]child: Text('$_favoriteCount'),[[/highlight]]
          ),
        ),
      ],
    );
  }
}
{% endprettify %}

<aside class="alert alert-success" markdown="1">
<i class="fa fa-lightbulb-o"> </i> **Consejo:**
Colocar el Text en un SizedBox y configurar su anchura previene un "salto" perceptible 
cuando el texto cambia entre los valores 40 y 41&mdash;esto 
de otro modo ocurriría porque estos valores tienen diferentes anchos.
</aside>

<a name="step-4"></a>
### Paso 4: Enchufa el widget stateful en el árbol de widgets

Añade tu widget stateful personalizado al árbol de widgets en el método build 
de la app. Primero, localiza el código que creaba el Icon y el Text, y borralo:

<!-- code/layout/lakes/main.dart -->
<!-- skip -->
{% prettify dart %}
// ...
[[strike]]Icon([[/strike]]
  [[strike]]Icons.star,[[/strike]]
  [[strike]]color: Colors.red[500],[[/strike]]
[[strike]]),[[/strike]]
[[strike]]Text('41')[[/strike]]
// ...
{% endprettify %}

En el mismo sitio, crea el widget stateful:

<!-- code/layout/lakes-interactive/main.dart -->
<!-- skip -->
{% prettify dart %}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      // ...
      child: Row(
        children: [
          Expanded(
            child: Column(
              // ...
          ),
          [[highlight]]FavoriteWidget()[[/highlight]],
        ],
      ),
    );

    return MaterialApp(
      // ...
    );
  }
}
{% endprettify %}

<br>¡Esto es todo! Cuando haces hot reload de la app, el icono estrella debería responder a gestos tap.

### ¿Problemas?

Si no puedes hacer que el código se ejecute, mira en tu IDE por posibles errores.
[Depurar Apps en Flutter](/debugging/) puede ayudar.
Si sigues sin encontrar el problema,
comprueba tu código con el ejemplo "interactive Lakes" en GitHub.

* [`lib/main.dart`](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes-interactive/main.dart)
* [`pubspec.yaml`](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes-interactive/pubspec.yaml)&mdash;no hay cambioes en este fichero
* [`lakes.jpg`](https://github.com/flutter/website/blob/master/src/_includes/code/layout/lakes-interactive/images/lake.jpg)&mdash;no hay cambios en este fichero

Si sigues teniendo preguntas, acude a [Obtener soporte.](/support/)

---

El resto de esta página cubre varias maneras en que puede ser administrado el estado de un widget, 
y lista otros widgets interactivos disponibles.

<a name="managing-state"></a>
## Administrar el estado

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* Hay diferentes enfoques para administrar estados.
* Tú, como diseñador del widget, eliges que enfoque usar.
* Si dudas, empieza administrando el estado en el widget padre.

</div>

¿Quién administra el estado de un widget stateful? ¿El propio widget? ¿El widget padre?
¿Ambos? ¿Otro objeto? La respuesta es... depende.
Hay muchas formas válidas de hacer tu widget interactivo.
Tú, como diseñador del widget, tomas la decisión basándote en como esperas que 
tu widget sea usado. Aqui están las maneras más comunes de administrar estados:

* [El widget administra su propio estado](#self-managed)
* [El padre administra el estado del widget](#parent-managed)
* [Un enfoque intermedio](#mix-and-match)

{% comment %}
NOTE: Commenting this out for now. The example needs some updates.

First, fix TapboxD, add it back to the repo, and then restore this note.
<aside class="alert alert-info" markdown="1">
**Note:** You can also manage state by exporting the state to a model class
that notifies widgets when state changes have occurred. This approach is
particularly useful when you want multiple widgets to listen and respond to the
same state information.

Explaining this approach is beyond the scope of this tutorial,
but you can try it out using the TapboxD example on GitHub.
The only file you need is
[lib/main.dart]().
[PENDING: Add a link once it's up on the site.]
</aside>
{% endcomment %}

¿Cómo decides que enfoque usar? Los siguientes principios deberían ayudarte a 
decidirte:

* Si el estado en cuestión son datos que genera el usuario,
  por ejemplo el modo checked o unchecked de un checkbox,
  o la posición de un slider,
  entonces es mejor administrar el estado en el widget padre.

* Si el estado en cuestión es estético, por ejemplo una animación,
  entonces el estado es mejor administrarlo en el propio widget.

Si dudas, empieza administrando el estado en el widget padre.

Vamos a dar ejemplos de las diferentes maneras de administrar el estado creando tres 
ejemplos simples: TapboxA, TapboxB, y TapboxC.
Todos los ejemplos funcionan de forma similar&mdash;cada uno crea un container que,
cuando es pulsado, alterna entre una caja verde o gris.
El boolean `_active` determina el color: verede para activo o
gris para inactivo.

<img src="images/tapbox-active-state.png" style="border:1px solid black" alt="una caja verde grande con el texto, 'Active'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/tapbox-inactive-state.png" style="border:1px solid black" alt="una caja grande gris con el texto, 'Inactive'">

Estos ejemplos usan 
[GestureDetector](https://docs.flutter.io/flutter/widgets/GestureDetector-class.html)
para capturar la actividad en el Container.

<a name="self-managed"></a>
### El widget maneja su propio estado

A veces tiene más sentido que el widget administre su estado internamente.
Por ejemplo, 
[ListView](https://docs.flutter.io/flutter/widgets/ListView-class.html)
hace automáticamente scroll cuando su contenido excede la render box. La mayoría 
de desarrolladores que usan ListView no tienen que administrar el compartamiento de 
scroll del ListView, ya que ListView administra por si mismo su scroll offset.

La clase `_TapboxAState`:

* Administra el estado para `TapboxA`.
* Define la propiedad boolean `_active` que determina el color actual de la caja.
* Define la función `_handleTap()`, que actualiza `_active` cuando la caja es 
  pulsada y llama la función `setState()` para actualizar el UI.
* Implementa todo el comportamiento interactivo para el widget.

<!-- skip -->
{% prettify dart %}
// TapboxA administra su propio estado.

//------------------------- TapboxA ----------------------------------

class TapboxA extends StatefulWidget {
  TapboxA({Key key}) : super(key: key);

  @override
  _TapboxAState createState() => _TapboxAState();
}

class _TapboxAState extends State<TapboxA> {
  bool _active = false;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        child: Center(
          child: Text(
            _active ? 'Active' : 'Inactive',
            style: TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: _active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
      ),
    );
  }
}

//------------------------- MyApp ----------------------------------

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Demo'),
        ),
        body: Center(
          child: TapboxA(),
        ),
      ),
    );
  }
}
{% endprettify %}


<hr>

<a name="parent-managed"></a>
### El widget padre administra el estado del widget

A menudo tiene mas sentido que el widget padre administre el estado y le diga al 
widget hijo cuando actualizarse. Por ejemplo,
[IconButton](https://docs.flutter.io/flutter/material/IconButton-class.html)
te permite tratar un icono como un botón pulsable.
IconButton es un widget stateless porque decidimos que el widget padre 
necesita saber cuando se ha pulsado el botón, para entonces, 
poder tomar la acción adecuada.

En el siguiente ejemplo, TapboxB exporta su estado a su padre a través de un 
callback. Como TapboxB no administra su estado, es 
una subclase de StatelessWidget.

La clase ParentWidgetState:

* Administra el estado `_active` para TapboxB.
* Implementa `_handleTapboxChanged()`, el método llamado cuando la caja es pulsada.
* Cuando el estado cambia, llama a `setState()` para actualizar el UI.

La clase TapboxB:

* Hereda de StatelessWidget porque todo estado es manejado por su padre.
* Cuando detecta un gesto tap, notifica al padre.

<!-- skip -->
{% prettify dart %}
// ParentWidget administra el estado para TapboxB.

//------------------------ ParentWidget --------------------------------

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TapboxB(
        active: _active,
        onChanged: _handleTapboxChanged,
      ),
    );
  }
}

//------------------------- TapboxB ----------------------------------

class TapboxB extends StatelessWidget {
  TapboxB({Key key, this.active: false, @required this.onChanged})
      : super(key: key);

  final bool active;
  final ValueChanged<bool> onChanged;

  void _handleTap() {
    onChanged(!active);
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        child: Center(
          child: Text(
            active ? 'Active' : 'Inactive',
            style: TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
      ),
    );
  }
}
{% endprettify %}


<aside class="alert alert-success" markdown="1">
<i class="fa fa-lightbulb-o"> </i> **Consejo:**
Cuando creas la API, considera usar la notación `@required` para cualquier 
parámetro en que se base tu código.
Para usar `@required`, importa la [biblioteca foundation](https://docs.flutter.io/flutter/foundation/foundation-library.html)
(que re-exporta la blibioteca 
[meta.dart](https://pub.dartlang.org/packages/meta)):

<pre>
import 'package:flutter/foundation.dart';
</pre>
</aside>

<hr>

<a name="mix-and-match"></a>
### Un enfoque intermedio

Para algunos widgets, un enfoque intermedio es más conveniente.
En este escenario, el widget stateful administra algo del estado, y el 
widget padre administra otro aspecto del estado.

En el ejemplo TapboxC, cuando el gesto tap inicia, _tap down_, un borde verde oscuro aparece 
alrededor de la caja.
Cuando el gesto tap acaba, _tap up_, el borde desaparece y el color de la caja cambia.
TapboxC exporta su estado `_active` a su padre pero administra 
internamente su estado `_highlight`.
Este ejemplo tiene dos objetos State, _ParentWidgetState y _TapboxCState.

El objeto _ParentWidgetState:

* Administra el estado `_active`.
* Implementa `_handleTapboxChanged()`, el método que se llama cuando la caja es pulsada.
* Llama a `setState()` para actualizar el UI cuando un gesto tap ocurre y el estado `_active` 
  cambia.

El objeto _TapboxCState:

* Administra el estado `_highlight`.
* El GestureDetector escucha todos los eventos tap.
  Cuando el usaurio hace _tap down_, añade el resaltado
  (implementado como un borde verde oscuro).
  Cuando el usuario termina de pulsar, _tap up_, el resaltado se elimina.
* LLama a `setState()` para actualizar el UI cuando se hace tap down, tap up, o se cancela el tap, y 
  cambie el estado `_highlight`.
* Cuan hay un evento tap, pasa este cambio de estado al widget padre para tomar la acción 
  adecuada usando la propiedad [widget](https://docs.flutter.io/flutter/widgets/State/widget.html).

<!-- skip -->
{% prettify dart %}
//---------------------------- ParentWidget ----------------------------

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TapboxC(
        active: _active,
        onChanged: _handleTapboxChanged,
      ),
    );
  }
}

//----------------------------- TapboxC ------------------------------

class TapboxC extends StatefulWidget {
  TapboxC({Key key, this.active: false, @required this.onChanged})
      : super(key: key);

  final bool active;
  final ValueChanged<bool> onChanged;

  _TapboxCState createState() => _TapboxCState();
}

class _TapboxCState extends State<TapboxC> {
  bool _highlight = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTap() {
    widget.onChanged(!widget.active);
  }

  Widget build(BuildContext context) {
    // Este ejemplo añade un borde verde cuando se produce el evento "tap down".
    // En el evento "tap up", el cuadrado cambia al estado opuesto.
    return GestureDetector(
      onTapDown: _handleTapDown, // Maneja los eventos tap en el orden que 
      onTapUp: _handleTapUp, // estos ocurren: down, up, tap, cancel
      onTap: _handleTap,
      onTapCancel: _handleTapCancel,
      child: Container(
        child: Center(
          child: Text(widget.active ? 'Active' : 'Inactive',
              style: TextStyle(fontSize: 32.0, color: Colors.white)),
        ),
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color:
              widget.active ? Colors.lightGreen[700] : Colors.grey[600],
          border: _highlight
              ? Border.all(
                  color: Colors.teal[700],
                  width: 10.0,
                )
              : null,
        ),
      ),
    );
  }
}
{% endprettify %}

Una implementación alternativa podría haber sido exportar el estado resaltado al 
padre mientras mantiene el estado active internamente,
pero si preguntas a alguien por usar este tap box, probablemente opinen que no tienen mucho 
sentido. Al desarrollador le importa si la caja esta activa. Al desarrollador 
probablemente no le preocupe como se administra el resaltado, y prefiera
que el tap box maneje estos detalles.


<hr>

<a name="other-interactive-widgets"></a>
## Otros widgets interactivos

Flutter ofrece una variedad de botones y widgets interactivos similares.
La mayoría de estos widgets implementan las [Material Design
guidelines,](https://material.io/guidelines/) que definen un conjunto de 
componentes con una UI pragmática.

Si lo prefieres, puedes usar 
[GestureDetector](https://docs.flutter.io/flutter/widgets/GestureDetector-class.html)
para construir interactividad en cualquier widget personalizado. Puedes encontrar ejemplos de 
GestureDetector en [Administrado el estado](#managing-state), y en la [Flutter
Gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery).

<aside class="alert alert-info" markdown="1">
**Nota:**
Flutter también proporciona un conjunto de widgets con estilo iOS llamados 
[Cupertino](https://docs.flutter.io/flutter/cupertino/cupertino-library.html).
</aside>

Cuando necesitas interactividad,
lo más sencillo es usar uno de los widgets prefabricados. Aquí está una lista parcial:

### Widgets standard:

* [Form](https://docs.flutter.io/flutter/widgets/Form-class.html)
* [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)

### Material Components:

* [Checkbox](https://docs.flutter.io/flutter/material/Checkbox-class.html)
* [DropdownButton](https://docs.flutter.io/flutter/material/DropdownButton-class.html)
* [FlatButton](https://docs.flutter.io/flutter/material/FlatButton-class.html)
* [FloatingActionButton](https://docs.flutter.io/flutter/material/FloatingActionButton-class.html)
* [IconButton](https://docs.flutter.io/flutter/material/IconButton-class.html)
* [Radio](https://docs.flutter.io/flutter/material/Radio-class.html)
* [RaisedButton](https://docs.flutter.io/flutter/material/RaisedButton-class.html)
* [Slider](https://docs.flutter.io/flutter/material/Slider-class.html)
* [Switch](https://docs.flutter.io/flutter/material/Switch-class.html)
* [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)

<a name="resources"></a>
## Recursos

Los siguientes recursos pueden ayudar cuando añades interactividad a tu app.

* [Manejando gestos](/widgets-intro/#manejar-gestos),
  una sección en [Un Tour por el Framework de Widgets de Flutter](/widgets-intro/)<br>
  Como crear un botón y hacer que responda a las entradas.
* [Gestos en Flutter](/gestures/)<br>
  Una descripción del mecanismo de gestos de Flutter.
* [Documentación de la API de Flutter API](https://docs.flutter.io/)<br>
  Referencia para todas las bibliotecas de Flutter.
* [Flutter
  Gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)<br>
  App de demostración mostrando muchos Material Components y otras características de Flutter.
* [Flutter's Layered
   Design (video)](https://www.youtube.com/watch?v=dkyY9WCGMi0)<br>
   Este video incluye información acerca de state y stateless widgets.
   Presentado por el ingeniero de Google, Ian Hickson.