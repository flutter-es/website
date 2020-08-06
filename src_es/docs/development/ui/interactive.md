---
title: Añade Interactividad a Tu App Flutter
short-title: Añade Interactividad
diff2html: true
---

{% capture examples -%} {{site.repo.this}}/tree/{{site.branch}}/examples {%- endcapture -%}

{{site.alert.secondary}}
  <h4 class="no_toc">Lo que aprenderás</h4>

* Como responder a gestos tap.
* Como crear un widget personalizado.
* La diferencia entre stateless y stateful widgets.
{{site.alert.end}}

¿Cómo modificas tu app para hacer que reaccione a las entradas del usuario?
En este tutorial, añadirás interactividad a una app que contiene solo widgets no interactivos. 
Específicamente, modificarás un icono para hacerlo pulsable creando 
un widget stateful personalizado que administra dos widgets stateless.

[Tutorial de layout][] te 
mostró como crear el layout de la siguiente captura de pantalla.

{% include app-figure.md img-class="site-mobile-screenshot border"
    image="ui/layout/lakes.jpg" caption="The layout tutorial app" %}

Cuando la app se lanza por primera vez, la estrella esta rellena de rojo, indicando que este lago 
ha sido marcado previamente como favorito. El número a continuación de la estrella indica que 
41 personas han marcado como favorito este lago. Después de completar este tutorial,
pulsando la estrella se desmarcará como favorito, reemplazando la estrella rellena 
con una sin relleno y decrecerá el contador. Pulsando de nuevo 
se marca el lago como favorito, dibujando la estrella rellena e incrementando el contador.

{% asset ui/favorited-not-favorited.png class="mw-100"
    alt="The custom widget you'll create" width="200px" %}
{:.text-center}

Para lograr esto, crearás un widget personalizado que incluye tanto la estrella 
como el contador, que son a su vez widgets. Como pulsar sobre la estrella 
cambia el estado de ambos widgets, entonces el mismo debería administrar ambos.

Puedes empezar a tocar el código en  [Paso 2: Subclase 
StatefulWidget](#step-2). Si quieres probar diferentes 
maneras de administrar el estado, salta a [Administrando el estado](#managing-state).

## Stateful y stateless widgets

Un widget puede ser stateful, o stateless. Si un widget cambia&mdash;por ejemplo, 
cuando el usuario interactúa con el&mdash;es stateful.

Un widget _stateless_ widget. [Icon][], [IconButton][], y [Text][] son 
ejemplos de widgets stateless. Los widgets stateless heredan de la clase [StatelessWidget][].

Un widget _stateful_ es dinámico: por ejemplo, este puede cambiar su apariencia en 
respuesta a eventos desencadenados por la intereacción del usuario o cuando recibe datos. 
[Checkbox][], [Radio][], [Slider][], [InkWell][], [Form][], y [TextField][]
son ejemplos de widgets stateful. Los widgets stateful heredan de la clase [StatefulWidget][].

El estado de un widget se almacena en un objeto [State][], separando el estado del widget 
de su apariencia. El estado de un widget consiste en valores que pueden cambiar, como el valor actual 
de un slider o cuando un checkbox esta marcado como checked. 
Cuando el estado de un widget cambia, el objeto state llama a 
`setState()`, diciendo al framework que repinte el widget.

## Creando un widget stateful

{{site.alert.secondary}}
  <h4 class="no_toc">¿Qué aprenderás?</h4>

* Un widget stateful es implementado por dos clases: una subclase de 
  `StatefulWidget` y una subclase de `State`.
* La clase state contiene el estado mutable del widget y el 
  método `build()`.
* Cuando el estado del widget cambia, el objeto state llama a 
  `setState()`, diciéndole al framework que redibuje el widget.
{{site.alert.end}}

En esta sección, crearás un widget stateful personalizado. Reemplazarás dos 
widgets stateless&mdash;la estrella rellena de rojo y el contador numérico junto 
a ella&mdash;con un único stateful widget personalizado que administra una fila 
con dos widgets hijos: un `IconButton` y un `Text`.

Implementar un widget stateful personalizado requiere crear dos clases:

* Una subclase de `StatefulWidget` que define el widget.
* Una subclase de `State` que contiene el estado para el widget y define el método 
  `build()`.

Esta sección muestra como construir un StatefulWidget, llamado `FavoriteWidget`,
para la app Lakes. El primer paso es elegir como administrar el 
estado de `FavoriteWidget`.

### Paso 0: Preparativos

Si ya has contruido el layout en [Tutorial de layout (paso 6)][], 
salta a la siguiente sección.

1. Asegúrate que has [configurado](/docs/get-started/install) tu entorno.
1. [Crea una app "Hello World" Flutter básica.][hello-world].
1. Reemplaza el fichero `lib/main.dart` con
  [`main.dart`]{{examples}}/layout/lakes/step6/lib/main.dart).
* Reemplaza el fichero `pubspec.yaml` con 
  [`pubspec.yaml`]{{examples}}/layout/lakes/step6/pubspec.yaml).
* Crea un directorio `images` en tu proyecto, y añade 
  [`lake.jpg`.]({{examples}}/layout/lakes/step6/images/lake.jpg).

Cuando tienes un dispositivo conectado y habilitado, o has lanzado el [simulador iOS][] 
(parte de la instalación de Flutter), ¡estás preparado para seguir!

<a name="step-1"></a>
### Paso 1: Decide cual objeto administra el estado del widget

El estado de un widget puede ser administrado de varias maneras, pero en nuestro ejemplo, 
el widget `FavoriteWidget`, administrará por si mismo su estado.
En este ejemplo, alternar la estrella es una acción aislada que no afecta 
al widget padre o al resto de la UI, por eso el widget puede manejar su estado internamente.

Aprende mas acerca de la separación de widget y estado,
y como puede ser administrado el estado, en [Administrando el estado](#managing-state).

<a name="step-2"></a>
### Paso 2: Subclase StatefulWidget

La clase `FavoriteWidget` administra su propio estado, sobreescribiendo el método 
`createState()` para crear el objeto State.
El framework llama a `createState()` cuando quiere construir el widget.
En este ejemplo, `createState()` crea una instancia de _FavoriteWidgetState, que implementarás en el siguiente paso.

<?code-excerpt path-base="layout/lakes/interactive"?>
<?code-excerpt "lib/main.dart (FavoriteWidget)" title?>
```dart
class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}
```

{{site.alert.note}}
Miembros o clases que empiezan con un guión bajo (_) son privados. Para más información, 
mira [Bibliotecas y visibilidad,][] una sección en el 
[Dart language tour.][]

[Dart language tour.]: {{site.dart-site}}/guides/language/language-tour
  [Bibliotecas y visibilidad,]: {{site.dart-site}}/guides/language/language-tour#libraries-and-visibility
{{site.alert.end}}

<a name="step-3"></a>
### Paso 3: Subclase State

La clase _FavoriteWidgetState almacena la información mutable &mdash;la lógica y estado interno&mdash; que puede cambiar 
durante el tiempo de vida del widget. Cuando la app se lanza por primera vez, la UI muestra una estrella 
rellena de rojo, indicando que el lago tiene el estado "favorite", y tiene 41 “likes”.
El objeto state almacena esta información en las variables `_isFavorited` y `_favoriteCount`.

<?code-excerpt "lib/main.dart (_FavoriteWidgetState fields)" replace="/(bool|int) .*/[!$&!]/g" title?>
```dart
class _FavoriteWidgetState extends State<FavoriteWidget> {
  [!bool _isFavorited = true;!]
  [!int _favoriteCount = 41;!]
  // ···
}
```

La clase también define el método `build` que crea una fila que contiene un `IconButton`
rojo, y un `Text`. Usas [IconButton][] (en lugar de `Icon`) porque este tiene 
una propiedad `onPressed` que define el método callback 
(`_toggleFavorite`) para manejar un gesto tap. Definirás 
la función callback a continuación.

<?code-excerpt "lib/main.dart (_FavoriteWidgetState build)" replace="/build|icon.*|onPressed.*|child: Text.*/[!$&!]/g" title?>
```dart
class _FavoriteWidgetState extends State<FavoriteWidget> {
  // ···
  @override
  Widget [!build!](BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            [!icon: (_isFavorited ? Icon(Icons.star) : Icon(Icons.star_border)),!]
            color: Colors.red[500],
            [!onPressed: _toggleFavorite,!]
          ),
        ),
        SizedBox(
          width: 18,
          child: Container(
            [!child: Text('$_favoriteCount'),!]
          ),
        ),
      ],
    );
  }
}
```

{{site.alert.tip}}
  Colocando un `Text` en un [SizedBox][] y configurando su ancho previene un 
  apreciable "salto" cuando el texto cambia entre valores de 40 y 41 
  &mdash; ocurriría un salto de otro modo porque estos valores tienen 
  diferentes anchos.
{{site.alert.end}}

El método `_toggleFavorite()`, que es llamado cuando el `IconButton` es presionado,
llama a `setState()`. Llamar a `setState()` es fundamental, porque esto dice 
al framework que el estado del widget ha cambiado y el widget deberia redibujarse. La función 
pasada a `setState()` alterna la UI entre 
estos dos estados:

- Un icono `star` y el número 41
- Un icono `star_border` y el número 40.

<?code-excerpt "lib/main.dart (_toggleFavorite)"?>
```dart
void _toggleFavorite() {
  setState(() {
    if (_isFavorited) {
      _favoriteCount -= 1;
      _isFavorited = false;
    } else {
      _favoriteCount += 1;
      _isFavorited = true;
    }
  });
}
```

<a name="step-4"></a>
### Paso 4: Enchufa el widget stateful en el árbol de widgets

Añade tu widget stateful personalizado al árbol de widgets en el método `build()` 
de la app. Primero, localiza el código que creaba el `Icon` y el `Text`, y bórralo. En la misma 
ubicación, crea el widget stateful:

<?code-excerpt path-base=""?>
<?code-excerpt "layout/lakes/{step6,interactive}/lib/main.dart" remove="*3*" from="class MyApp" to="/^ }/"?>
```diff
--- layout/lakes/step6/lib/main.dart
+++ layout/lakes/interactive/lib/main.dart
@@ -10,2 +5,2 @@
 class MyApp extends StatelessWidget {
   @override
@@ -38,11 +33,7 @@
               ],
             ),
           ),
-          Icon(
-            Icons.star,
-            color: Colors.red[500],
-          ),
-          Text('41'),
+          FavoriteWidget(),
         ],
       ),
     );
@@ -117,3 +108,3 @@
     );
   }
 }
```

¡Esto es todo! Cuando haces hot reload de la app, el icono estrella debería responder a gestos tap.

### ¿Problemas?

Si no puedes hacer que el código se ejecute, mira en tu IDE por posibles errores.
[Depurar Apps en Flutter](/docs/testing/debugging) puede ayudar.
Si sigues sin encontrar el problema,
comprueba tu código con el ejemplo "interactive lakes" en GitHub.

{% comment %}
TODO: replace the following links with tabbed code panes.
{% endcomment -%}

* [lib/main.dart]({{site.repo.this}}/tree/{{site.branch}}/examples/layout/lakes/interactive/lib/main.dart)
* [pubspec.yaml]({{site.repo.this}}/tree/{{site.branch}}/examples/layout/lakes/interactive/pubspec.yaml)
* [lakes.jpg]({{site.repo.this}}/tree/{{site.branch}}/examples/layout/lakes/interactive/images/lake.jpg)

Si sigues teniendo preguntas, dirígete a uno de los 
canales de desarrolladores de la [comunidad](/community).

---

El resto de esta página cubre varias maneras en que puede ser administrado el estado de un widget, 
y lista otros widgets interactivos disponibles.

## Administrar el estado

{{site.alert.secondary}}
  <h4 class="no_toc">¿Qué aprenderás?</h4>

  * Hay diferentes enfoques para administrar estados.
  * Tú, como diseñador del widget, eliges qué enfoque usar.
  * Si tienes dudas, empieza administrando el estado en el widget padre.
{{site.alert.end}}


¿Quién administra el estado de un widget stateful? ¿El propio widget? ¿El widget padre?
¿Ambos? ¿Otro objeto? La respuesta es... depende.
Hay muchas formas válidas de hacer tu widget interactivo.
Tú, como diseñador del widget, tomas la decisión basándote en cómo esperas que 
tu widget sea usado. Aqui están las maneras más comunes de administrar estados:

* [El widget administra su propio estado](#self-managed)
* [El padre administra el estado del widget](#parent-managed)
* [Un enfoque intermedio](#mix-and-match)

{% comment %}
  NOTE: Commenting this out for now. The example needs some updates.

  First, fix TapboxD, add it back to the repo, and then restore this note.

  {{site.alert.tip}}
    You can also manage state by exporting the state to a model class
    that notifies widgets when state changes have occurred. This approach is
    particularly useful when you want multiple widgets to listen and respond to the
    same state information.

    Explaining this approach is beyond the scope of this tutorial,
    but you can try it out using the TapboxD example on GitHub.
    The only file you need is
    [lib/main.dart]().
    [PENDING: Add a link once it's up on the site.]
  {{site.alert.end}}
{% endcomment %}

¿Cómo decides que enfoque usar? Los siguientes principios deberían ayudarte a 
decidirte:

* Si el estado en cuestión son datos que genera el usuario, por ejemplo el modo 
 checked o unchecked de un checkbox, o la posición de un slider, entonces es mejor 
 administrar el estado en el widget padre.

* Si el estado en cuestión es estético, por ejemplo una animación,
  entonces el estado es mejor administrarlo en el propio widget.

Si tienes dudas, empieza administrando el estado en el widget padre.

Vamos a dar ejemplos de las diferentes maneras de administrar el estado creando tres 
ejemplos simples: TapboxA, TapboxB, y TapboxC.
Todos los ejemplos funcionan de forma similar &mdash;cada uno crea un container que,
cuando es pulsado, alterna entre una caja verde o gris.
El boolean `_active` determina el color: verde para activo o gris para inactivo.

<div class="row mb-4">
  <div class="col-12 text-center">
    {% asset ui/tapbox-active-state.png class="border mt-1 mb-1 mw-100" width="150px" alt="Active state" %}
    {% asset ui/tapbox-inactive-state.png class="border mt-1 mb-1 mw-100" width="150px" alt="Inactive state" %}
  </div>
</div>

Estos ejemplos usan [GestureDetector][] para capturar la actividad en el Container.

<a name="self-managed"></a>
### El widget maneja su propio estado

A veces tiene más sentido que el widget administre su estado internamente.
Por ejemplo, [ListView][] hace automáticamente scroll cuando su contenido excede la render box. La mayoría 
de desarrolladores que usan ListView no tienen que administrar el compartamiento de 
scroll del ListView, ya que ListView administra por si mismo su scroll offset.

La clase `_TapboxAState`:

* Administra el estado para TapboxA.
* Define la propiedad boolean `_active` que determina el color actual de la caja.
* Define la función `_handleTap()`, que actualiza `_active` cuando la caja es 
  pulsada y llama la función `setState()` para actualizar el UI.
* Implementa todo el comportamiento interactivo para el widget.

{% prettify dart %}
// TapboxA manages its own state.

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

A menudo tiene más sentido que el widget padre administre el estado y le diga al 
widget hijo cuando actualizarse. Por ejemplo, [IconButton][] te permite tratar un 
icono como un botón pulsable.
IconButton es un widget stateless porque decidimos que el widget padre 
necesita saber cuando se ha pulsado el botón, para entonces, poder tomar la acción adecuada.

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

{% prettify dart %}
// ParentWidget manages the state for TapboxB.

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

{{site.alert.tip}}
  Cuando creas la API, considera usar la notación `@required` para cualquier 
  parámetro en que se base tu código. Para usar `@required`, importa la [biblioteca `foundation`][] 
  (que re-exporta la blibioteca [meta.dart][]):

  <!-- skip -->
  ```dart
  import 'package:flutter/foundation.dart';
  ```
{{site.alert.end}}

<hr>

<a name="mix-and-match"></a>
### Un enfoque intermedio

Para algunos widgets, un enfoque intermedio es más conveniente.
En este escenario, el widget stateful administra algo del estado, y el 
widget padre administra otro aspecto del estado.

En el ejemplo `TapboxC`, cuando el gesto tap inicia, _tap down_, un borde verde oscuro aparece 
alrededor de la caja. Cuando el gesto tap acaba, _tap up_, el borde desaparece y el color 
de la caja cambia. `TapboxC` exporta su estado `_active` a su padre pero administra 
internamente su estado `_highlight`. Este 
ejemplo tiene dos objetos State, `_ParentWidgetState` y `_TapboxCState`.

El objeto `_ParentWidgetState`:

* Administra el estado `_active`.
* Implementa `_handleTapboxChanged()`, el método que se llama cuando la caja es pulsada.
* Llama a `setState()` para actualizar el UI cuando un gesto tap ocurre y el estado `_active` 
cambia.

El objeto `_TapboxCState`:

* Administra el estado `_highlight`.
* El `GestureDetector` escucha todos los eventos tap.  Cuando el usaurio hace _tap down_, 
añade el resaltado (implementado como un borde verde oscuro). Cuando el 
usuario termina de pulsar, _tap up_, el resaltado se elimina.
* Llama a `setState()` para actualizar el UI cuando se hace tap down, tap up, o se cancela el tap, y 
  cambie el estado `_highlight`.
* Cuando hay un evento tap, pasa este cambio de estado al widget padre para tomar la acción 
  adecuada usando la propiedad [widget][].

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
    // This example adds a green border on tap down.
    // On tap up, the square changes to the opposite state.
    return GestureDetector(
      onTapDown: _handleTapDown, // Handle the tap events in the order that
      onTapUp: _handleTapUp, // they occur: down, up, tap, cancel
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

Una implementación alternativa podría haber sido exportar el estado highlight al 
padre mientras mantiene el estado active internamente,
pero si le pides a alguien que use este tap box, probablemente consideren que no tiene mucho 
sentido. Al desarrollador le importa si la caja esta activa. Al desarrollador 
probablemente no le preocupe cómo se administra el resaltado, y prefiere
que el tap box maneje estos detalles.

<hr>

## Otros widgets interactivos

Flutter ofrece una variedad de botones y widgets interactivos similares.
La mayoría de estos widgets implementan las [Material Design guidelines][] que definen un conjunto de 
componentes con una UI pragmática.

Si lo prefieres, puedes usar [GestureDetector][] para construir interactividad 
en cualquier widget personalizado. Puedes encontrar ejemplos de GestureDetector 
en [Administrado el estado](#managing-state), y en la [Flutter Gallery][].

{{site.alert.tip}}
  Flutter también proporciona un conjunto de widgets con estilo iOS llamados [Cupertino][].
{{site.alert.end}}

Cuando necesitas interactividad,
lo más sencillo es usar uno de los widgets prefabricados. Aquí está una lista parcial:

### Widgets estándar

* [Form][]
* [FormField][]

### Material Components

* [Checkbox][]
* [DropdownButton][]
* [FlatButton][]
* [FloatingActionButton][]
* [IconButton][]
* [Radio][]
* [RaisedButton][]
* [Slider][]
* [Switch][]
* [TextField][]

## Recursos

Los siguientes recursos pueden ayudar cuando añades interactividad a tu app.

* [Manejando gestos][], una sección en [Introducción a los widgets][]<br>
  Como crear un botón y hacer que responda a las entradas.
* [Gestos en Flutter][]<br>
  Una descripción del mecanismo de gestos de Flutter.
* [Documentación de la API de Flutter API][]<br>
  Referencia para todas las bibliotecas de Flutter.
* [Flutter Gallery][]<br>
  App de demostración mostrando muchos Material Components y otras características de Flutter.
* [Flutter's Layered Design][] (video)<br>
   Este video incluye información acerca de state y stateless widgets.
   Presentado por el ingeniero de Google, Ian Hickson.

[Checkbox]: {{site.api}}/flutter/material/Checkbox-class.html
[Cupertino]: {{site.api}}/flutter/cupertino/cupertino-library.html
[DropdownButton]: {{site.api}}/flutter/material/DropdownButton-class.html
[FlatButton]: {{site.api}}/flutter/material/FlatButton-class.html
[FloatingActionButton]: {{site.api}}/flutter/material/FloatingActionButton-class.html
[Documentación de la API de Flutter API]: {{site.api}}
[Flutter Gallery]: {{site.github}}/flutter/flutter/tree/master/examples/flutter_gallery
[Flutter's Layered Design]: https://www.youtube.com/watch?v=dkyY9WCGMi0
[FormField]: {{site.api}}/flutter/widgets/FormField-class.html
[Form]: {{site.api}}/flutter/widgets/Form-class.html
[biblioteca `foundation`]: {{site.api}}/flutter/foundation/foundation-library.html
[GestureDetector]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[Manejando Gestos]: /docs/development/ui/widgets-intro#manejar-gestos
[Gestos en Flutter]: /docs/development/ui/advanced/gestures
[hello-world]: /docs/get-started/codelab#step-1-create-the-starter-flutter-app
[IconButton]: {{site.api}}/flutter/material/IconButton-class.html
[Icon]: {{site.api}}/flutter/widgets/Icon-class.html
[InkWell]: {{site.api}}/flutter/material/InkWell-class.html
[Introducción a los widgets]: /docs/development/ui/widgets-intro
[iOS simulator]: /docs/get-started/install/macos#set-up-the-ios-simulator
[Tutorial de layout]: /docs/development/ui/layout/tutorial
[Tutorial de layout (paso 6)]: /docs/development/ui/layout/tutorial#paso-6-el-toque-final
[ListView]: {{site.api}}/flutter/widgets/ListView-class.html
[Material Design guidelines]: {{site.material}}/design/guidelines-overview
[meta.dart]: {{site.pub}}/packages/meta
[Radio]: {{site.api}}/flutter/material/Radio-class.html
[RaisedButton]: {{site.api}}/flutter/material/RaisedButton-class.html
[SizedBox]: {{site.api}}/flutter/widgets/SizedBox-class.html
[Slider]: {{site.api}}/flutter/material/Slider-class.html
[State]: {{site.api}}/flutter/widgets/State-class.html
[StatefulWidget]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[StatelessWidget]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[Switch]: {{site.api}}/flutter/material/Switch-class.html
[TextField]: {{site.api}}/flutter/material/TextField-class.html
[Text]: {{site.api}}/flutter/widgets/Text-class.html
[widget]: {{site.api}}/flutter/widgets/State/widget.html
