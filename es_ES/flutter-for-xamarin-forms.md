---
layout: page
title: Flutter para Desarrolladores de Xamarin.Forms
permalink: /flutter-for-xamarin-forms/
---
Este documento está dirigido a los desarrolladores de Xamarin.Forms que deseen aplicar su
conocimiento existente para construir aplicaciones móviles con Flutter. Si entiendes
los fundamentos del framework de Xamarin.Forms, entonces puedes usar este documento como
un comienzo para el desarrollo con Flutter.

Sus conocimientos y habilidades sobre iOS y Android son valiosos a la hora de construir con
Flutter, porque Flutter depende de las configuraciones del sistema operativo nativo, similar a
cómo configurar sus proyectos nativos de Xamarin.Forms. El  Framework Flutter es también similar
a la forma en que se crea una única interfaz de usuario, que se utiliza en múltiples plataformas.

Este documento puede ser usado como un libro de cocina saltando y encontrando preguntas
que son más relevantes para sus necesidades.

* TOC Placeholder
{:toc}

# Configuración del proyecto

## ¿Cómo comienza la aplicación?

Para cada plataforma en Xamarin.Forms, usted llama al método `LoadApplication`, que
crea una nueva Aplicación e inicia su app.

<!-- skip -->
{% prettify csharp %}
LoadApplication(new App());
{% endprettify %}

En Flutter, el punto de entrada principal por defecto es `main` donde se carga el archivo
Flutter app.

{% prettify dart %}
void main() {
  runApp(new MyApp());
}
{% endprettify %}

En Xamarin.Forms, usted asigna una `Page` a la propiedad `MainPage` en la clase `Application`.

<!-- skip -->
{% prettify csharp %}
public class App: Application
{
    public App()
    {
      MainPage = new ContentPage()
                 {
                   new Label()
                   {
                     Text="Hola Mundo!",
                     HorizontalOptions = LayoutOptions.Center,
                     VerticalOptions = LayoutOptions.Center
                   }
                 };
    }
}
{% endprettify %}

En Flutter, "todo es un widget", incluso la propia aplicación. El siguiente ejemplo muestra
`MyApp`, una simple aplicación `Widget`.

{% prettify dart %}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: Text("Hola Mundo!", textDirection: TextDirection.ltr));
  }
}
{% endprettify %}

## ¿Cómo se crea una Page?

Xamarin.Forms tiene muchos tipos diferentes de páginas;  `ContentPage` es la más común.

En Flutter, se especifica un widget de aplicación que contiene la página raíz. Puede utilizar
un widget [MaterialApp](https://docs.flutter.io/flutter/material/MaterialApp-class.html), que
soporta [Material Design](https://material.io/design/), o puede utilizar el nivel inferior
[WidgetsApp](https://docs.flutter.io/flutter/widgets/WidgetsApp-class.html), que puede personalizarse de cualquier forma que quieras.

El siguiente código define la página de inicio, un widget de estado. En Flutter, todos los widgets son inmutables,
pero hay dos tipos de widgets soportados: stateful y stateless. Ejemplos de un widget sin estado son los títulos, iconos o imágenes.

El siguiente ejemplo utiliza MaterialApp, que contiene su página raíz en la propiedad `home`.

{% prettify dart %}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      [[highlight]]home: new MyHomePage(title: 'Flutter Demo Home Page'),[[/highlight]]
    );
  }
}
{% endprettify %}

A partir de aquí, tu primera página actual es otro `Widget`, en el que creas tu estado.

Un widget de estado, como MyHomePage a continuación, consta de dos partes. La primera parte, que en sí misma es inmutable, crea un objeto de Estado, que contiene el estado del objeto. El objeto State persiste durante la vida del widget.

{% prettify dart %}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
{% endprettify %}

El objeto `state` implementa el método `build` para el widget stateful.

Cuando el estado del árbol de widgets cambia, llama a `setState()`, lo que desencadena una compilación de esa parte de la interfaz de usuario. Asegúrese de llamar a `setState()` sólo cuando sea necesario, y sólo en la parte del árbol de widgets que ha cambiado, o puede resultar en un pobre rendimiento de la interfaz de usuario.

{% prettify dart %}
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Aquí tomamos el valor del objeto MyHomePage que fue creado por
        // el método App.build, y usarlo para establecer el título de nuestra barra de aplicaciones.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center es un widget de diseño. Toma a un solo hijo y lo coloca
        // en el centro del padre.
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Has presionado el botón esta cantidad de veces:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
{% endprettify %}

La interfaz de usuario, también conocida como árbol de widgets, en Flutter es inmutable, lo que significa
que no se puede cambiar su estado una vez construido. Usted cambia los campos en su clase `State`, luego llama a `setState` para reconstruir el árbol de widgets de nuevo.

Esta forma de generar UI es diferente a Xamarin.Forms, pero hay muchos beneficios
a este enfoque.

# Views

## ¿Cuál es el equivalente a una `Page` o `Element` en Flutter?

Un `ContentPage`, `TabbedPage`, `MasterDetailPage` son todos tipos de páginas que usted podría usar
en una aplicación de Xamarin.Forms. Estas páginas contendrían entonces `Element`s para mostrar
los distintos controles. In Xamarin.Forms un `Entry` o `Button` son ejemplos de un `Element`.

En Flutter, casi todo es un widget. Una `Page`, llamada `Route` en Flutter, es un widget.
Botones, barras de progreso, controladores de animación son todos widgets. Cuando construye una ruta, crea un árbol de widgets.

Flutter inclutye la biblioteca [Material Components](https://flutter.io/widgets/material/).
Se trata de widgets que implementan la
[guía de Material Design](https://material.io/design/). Material Design es un sistema de diseño flexible [optimizado para todas las plataformas](https://material.io/design/platform-guidance/cross-platform-adaptation.html#cross-platform-guidelines),
incluyendo iOS.

Pero Flutter es lo suficientemente flexible y expresivo como para implementar cualquier lenguaje de diseño.
Por ejemplo, en iOS, puede utilizar los [widgets Cupertino](https://flutter.io/widgets/cupertino/)
para producir una interfaz que se parezca a
[Lenguaje de diseño iOS de Apple](https://developer.apple.com/design/resources/).

## ¿Cómo actualizo Widgets?

En Xamarin.Forms, cada `Page` o `Element` es una clase de estado, que tiene propiedades y
métodos. Usted actualiza su `Element` actualizando una propiedad, y ésta se propaga hasta el control nativo.

En Flutter los `Widget`s son inmutables y no puedes actualizarlos directamente cambiando una propiedad,
sino que tienes que trabajar con el estado del widget.

De ahí el concepto de los widgets Stateful vs Stateless. Un
`StatelessWidget` es justo lo que parece un widget sin información de estado.

Los `StatelessWidgets` son útiles cuando la parte de la interfaz de usuario
que está describiendo no depende de nada más que de la configuración
en el objeto.

Por ejemplo, en Xamarin.Forms, esto es similar a colocar un `Image`
con su logo. El logo no va a cambiar durante el tiempo de ejecución, así que
use un `StatelessWidget` en Flutter.

Si desea cambiar dinámicamente la interfaz de usuario basándose en los datos recibidos
después de realizar una llamada HTTP o una interacción con el usuario,
deberá trabajar con `StatefulWidget` y decirle al framework Flutter que el `State`
del widget ha sido actualizado para que pueda actualizar ese widget.

Lo importante a tener en cuenta aquí es que tanto los widgets stateless como stateful
se comportan de la misma manera. Reconstruyen cada cuadro, la diferencia es que el
`StatefulWidget` tiene un objeto `State` que almacena los datos de estado a través de cuadros y los restaura.

Si tienes dudas, recuerda siempre esta regla: si un widget cambia
(debido a las interacciones del usuario, por ejemplo), es un stateful.
Sin embargo, si un widget reacciona al cambio, el widget padre que lo contiene puede seguir siendo
stateless si no reacciona al cambio.

El siguiente ejemplo muestra cómo usar un `StatelessWidget`. Un
`StatelessWidget` común es el widget `Text`. Si se fija en la implementación del
widget `Text` encontrara su subclase `StatelessWidget`.

<!-- skip -->
{% prettify dart %}
new Text(
  '¡Me gusta Flutter!',
  style: new TextStyle(fontWeight: FontWeight.bold),
);
{% endprettify %}

Como puede ver, el Widget `Text` no tiene información de estado asociada a él,
muestra lo que se pasa en sus constructores y nada más.

Pero, ¿qué pasa si quieres hacer que "Me gusta Flutter" cambie dinámicamente,
por ejemplo, al hacer clic en un `FloatingActionButton`?

Para lograr esto, envuelva el widget `Text` en un `StatefulWidget` y
actualícelo cuando el usuario haga clic en el botón.

Por ejemplo:

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'App de ejemplo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  // Texto predeterminado
  String textToShow = "¡Me gusta Flutter!";

  void _updateText() {
    setState(() {
      // actualizar el texto
      textToShow = "¡Flutter es increíble!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("App de ejemplo"),
      ),
      body: new Center(child: new Text(textToShow)),
      floatingActionButton: new FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'Actualizar texto',
        child: new Icon(Icons.update),
      ),
    );
  }
}
{% endprettify %}

## ¿Cómo puedo diseñar mis widgets? ¿Cuál es el equivalente a un archivo XAML?

En Xamarin.Forms, la mayoría de los desarrolladores escriben diseños en XAML, aunque a veces en C#.
En Flutter escribes tus diseños con un árbol de widgets en código.

El siguiente ejemplo muestra cómo desplegar un widget simple con padding:

<!-- skip -->
{% prettify dart %}
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("App de ejemplo"),
      ),
      body: new Center(
        child: new MaterialButton(
          onPressed: () {},
          child: new Text('Hola'),
          padding: new EdgeInsets.only(left: 10.0, right: 10.0),
        ),
      ),
    );
  }
{% endprettify %}

Puedes ver los diseños que Flutter tiene para ofrecer en el [catálogo de widgets](/widgets/layout/).

## ¿Cómo agrego o elimino un elemento de mi diseño?

En Xamarin.Forms, si tenías que quitar o agregar un `Element`, tenías que hacerlo en código.
Esto implicaría establecer la propiedad `Content` o llamar `Add()` o `Remove()` si se trata de una lista.

En Flutter, como los widgets son inmutables, no hay equivalente directo.
En su lugar, puede pasar una función al padre que devuelva un widget, y
controlar la creación de ese widget hijo con una bandera booleana.

El siguiente ejemplo muestra cómo alternar entre dos widgets cuando el usuario hace clic
el `FloatingActionButton`:

<!-- skip -->
{% prettify dart %}
class SampleApp extends StatelessWidget {
  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'App de ejemplo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  // Valor por defecto para toggle
  bool toggle = true;
  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  _getToggleChild() {
    if (toggle) {
      return new Text('Toggle Uno');
    } else {
      return new CupertinoButton(
        onPressed: () {},
        child: new Text('Toggle Dos'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("App de ejemplo"),
      ),
      body: new Center(
        child: _getToggleChild(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _toggle,
        tooltip: 'Actualizar texto',
        child: new Icon(Icons.update),
      ),
    );
  }
}
{% endprettify %}

## ¿Cómo puedo animar un widget?

En Xamarin.Forms, usted crea animaciones simples usando ViewExtensions que incluyen
métodos como `FadeTo` y `TranslateTo`. Estos métodos se utilizarían en una vista
para realizar las animaciones necesarias.

<!-- skip -->
{% prettify xml %}
<Image Source="{Binding MyImage}" x:Name="myImage" />
{% endprettify %}

Entonces en code behind, o un behavior, esto se desvanecería en la imagen, en un período de 1 segundo.

<!-- skip -->
{% prettify csharp %}
myImage.FadeTo(0, 1000);
{% endprettify %}

En Flutter, los widgets se animan utilizando la biblioteca de animaciones, envolviendo
los widgets dentro de un widget animado. Utilice un `AnimationController` que es un `Animation<double>`
que puede pausar, buscar, detener e invertir la animación. Requiere un `Ticker`
que señala cuando se produce la sincronización, y produce una interpolación lineal
entre 0 y 1 en cada fotograma mientras está en ejecución. Luego creas una o más
`Animation`s y las adjuntas al controlador.

Por ejemplo, puede utilizar `CurvedAnimation` para implementar una animación
a lo largo de una curva interpolada. En este sentido, el controlador es la fuente
"maestra" del progreso de la animación y la `CurvedAnimation`
calcula la curva que reemplaza el movimiento lineal predeterminado del controlador.
Al igual que los widgets, las animaciones de Flutter trabajan con la composición.

Cuando construya el árbol de widgets, asigne la `Animation` a una propiedad animada
de un widget, como la opacidad de un `FadeTransition`, y dígale al controlador
que inicie la animación.

El siguiente ejemplo muestra cómo escribir un `FadeTransition` que desvanece el widget
en un logotipo al pulsar el `FloatingActionButton`:

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(new FadeAppTest());
}

class FadeAppTest extends StatelessWidget {
  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fade Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyFadeTest(title: 'Fade Demo'),
    );
  }
}

class MyFadeTest extends StatefulWidget {
  MyFadeTest({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyFadeTest createState() => new _MyFadeTest();
}

class _MyFadeTest extends State<MyFadeTest> with TickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation curve;

  @override
  void initState() {
    controller = new AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    curve = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
          child: new Container(
              child: new FadeTransition(
                  opacity: curve,
                  child: new FlutterLogo(
                    size: 100.0,
                  )))),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Fade',
        child: new Icon(Icons.brush),
        onPressed: () {
          controller.forward();
        },
      ),
    );
  }
}
{% endprettify %}

Para obtener más información, consulte
[Widgets de animación y movimiento](/widgets/animation/),
el [Tutorial de animaciones](/tutorials/animation),
and the [Resumen de las animaciones](/animations/).

## ¿Cómo puedo dibujar o pintar en la pantalla?

Xamarin.Forms nunca tuvo ninguna forma de dibujar directamente en la pantalla.
Muchos usarían SkiaSharp, si necesitaran una imagen personalizada dibujada. En Flutter,
tienes acceso directo al lienzo Skia y puedes dibujar fácilmente en la pantalla.

Flutter tiene dos clases que te ayudan a dibujar en el lienzo: `CustomPaint`
y `CustomPainter`, el último de los cuales implementa tu algoritmo para dibujar en
el lienzo.

Para aprender cómo implementar un pintor de firmas en Flutter, vea la respuesta de Collin en
[StackOverflow](https://stackoverflow.com/questions/46241071/create-signature-area-
for-mobile-app-in-dart-flutter).

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(home: new DemoApp()));

class DemoApp extends StatelessWidget {
  Widget build(BuildContext context) => new Scaffold(body: new Signature());
}

class Signature extends StatefulWidget {
  SignatureState createState() => new SignatureState();
}

class SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];
  Widget build(BuildContext context) {
    return new GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          RenderBox referenceBox = context.findRenderObject();
          Offset localPosition =
          referenceBox.globalToLocal(details.globalPosition);
          _points = new List.from(_points)..add(localPosition);
        });
      },
      onPanEnd: (DragEndDetails details) => _points.add(null),
      child: new CustomPaint(painter: new SignaturePainter(_points), size: Size.infinite),
    );
  }
}

class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);
  final List<Offset> points;
  void paint(Canvas canvas, Size size) {
    var paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        canvas.drawLine(points[i], points[i + 1], paint);
    }
  }
  bool shouldRepaint(SignaturePainter other) => other.points != points;
}
{% endprettify %}

## ¿Dónde está la opacidad del widget?

En Xamarin.Forms, todos los `VisualElement`s tienen una Opacidad. En Flutter, usted necesita
envolver un widget en un [Opacity widget](https://docs.flutter.io/flutter/widgets/Opacity-class.html)
para lograr esto.

## ¿Cómo construyo widgets personalizados?

En Xamarin.Forms, usted típicamente subclasifica `VisualElement`, o utiliza un `VisualElement`
preexistente, para anular e implementar métodos que logren el comportamiento deseado.

En Flutter, construye un widget personalizado
[integrando](/technical-overview/#everythings-a-widget) widgets más pequeños
(en lugar de extenderlos).
Es algo similar a la implementación de un control personalizado basado en un `Grid` con
numerosos `VisualElement`s agregados, mientras se extienden con lógica personalizada.

Por ejemplo, ¿cómo se construye un `CustomButton` que lleva una etiqueta en
el constructor? Cree un botón personalizado que componga un `RaisedButton` con una etiqueta,
en lugar de extender `RaisedButton`:

<!-- skip -->
{% prettify dart %}
class CustomButton extends StatelessWidget {
  final String label;

  CustomButton(this.label);

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(onPressed: () {}, child: new Text(label));
  }
}
{% endprettify %}

Entonces usa `CustomButton`, tal como lo harías con cualquier otro widget de Flutter:

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return new Center(
    child: new CustomButton("Hello"),
  );
}
{% endprettify %}

# Navegación

## ¿Cómo navego entre páginas?

En Xamarin.Forms, usted navega entre páginas normalmente a través de un
`NavigationPage` que gestiona la pila de páginas a mostrar.

Flutter tiene una implementación similar, usando un `Navigator` y
`Routes`. Un `Route` es una abstracción para una `Page` de una app, y
un `Navigator` es un [widget](technical-overview/#everythings-a-widget)
que gestiona las rutas.

Una ruta se mapea aproximadamente a una `Page`. El navigator funciona de manera similar a la del
Xamarin.Forms `NavigationPage`, en el que puede hacer `push()` y `pop()` a rutas
dependiendo de si desea navegar hacia o desde una vista.

Para navegar entre páginas, tiene un par de opciones:

* Especifique un `Map` de nombres de ruta. (MaterialApp)
* Navegar directamente a una ruta. (WidgetApp)

El siguiente ejemplo construye un Map.

<!-- skip -->
{% prettify dart %}
void main() {
  runApp(new MaterialApp(
    home: new MyAppHome(), // se convierte en la nombrada ruta '/'
    routes: <String, WidgetBuilder> {
      '/a': (BuildContext context) => new MyPage(title: 'page A'),
      '/b': (BuildContext context) => new MyPage(title: 'page B'),
      '/c': (BuildContext context) => new MyPage(title: 'page C'),
    },
  ));
}
{% endprettify %}

Navegue hasta una ruta empujando (`push`) su nombre hacia el `Navigator`.

<!-- skip -->
{% prettify dart %}
Navigator.of(context).pushNamed('/b');
{% endprettify %}

El Navegador es un stack que gestiona las rutas de su app. Empujando una ruta al stack
se mueve a esa ruta. Haciendo pop una ruta del stack, regresa a la ruta anterior. Esto
es hecho por `await` en el `Futuro` retornado por `push()`.

`Async`/`await` es muy similar a la implementación de .NET y se explica con más detalle
en [Async UI](/flutter-for-xamarin-forms/#async-ui).

Por ejemplo, para iniciar una ruta de `ubicación` que permita al usuario seleccionar
su ubicación, puede hacer lo siguiente:

<!-- skip -->
{% prettify dart %}
Map coordinates = await Navigator.of(context).pushNamed('/ubicacion');
{% endprettify %}

Y luego, dentro de la ruta de su ‘ubicación’, una vez que el usuario haya seleccionado su
ubicación, `pop()` el stack con el resultado:

<!-- skip -->
{% prettify dart %}
Navigator.of(context).pop({"lat":43.821757,"long":-79.226392});
{% endprettify %}

## ¿Cómo navego a otra aplicación?

En Xamarin.Forms, para enviar al usuario a otra aplicación, se utiliza un
esquema URI específico, usando `Device.OpenUrl("mailto://")`

Para implementar esta funcionalidad en Flutter, cree una integración de plataforma nativa,
o utilice un [plugin](#plugins) existente, como
[`url_launcher`](https://pub.dartlang.org/packages/url_launcher), disponible con
muchos otros paquetes en [pub.dartlang](https://pub.dartlang.org/flutter).

# Async UI

## ¿Cuál es el equivalente de `Device.BeginOnMainThread()` en Flutter?

Dart tiene un modelo de ejecución de un solo hilo, con soporte para `Isolate`s
(una forma de ejecutar código de Dart en otro hilo), un loop de eventos, y
programación asíncrona. A menos que usted genere un `Isolate`, su código Dart
se ejecuta en el hilo principal de la UI y es controlado por un loop de eventos.

El modelo de un solo hilo de Dart no significa que necesites ejecutarlo todo
como una operación de bloqueo que hace que la UI se congele. Al igual que Xamarin.Forms, necesita
mantener el hilo de la UI libre. Usaría `async`/`await` para realizar
tareas, donde debe esperar la respuesta.

En Flutter, utilice las capacidades asíncronas que proporciona el lenguaje Dart, también
llamado `async`/`await`, para realizar trabajos asíncronos. TEsto es muy similar a
C# y debería ser muy fácil de usar para cualquier desarrollador de Xamarin.Forms.

Por ejemplo, puede ejecutar código de red sin hacer que la interfaz de usuario se
cuelgue usando `async`/`await` y dejando que Dart haga el trabajo pesado:

<!-- skip -->
{% prettify dart %}
loadData() async {
  String dataURL = "https://jsonplaceholder.typicode.com/posts";
  http.Response response = await http.get(dataURL);
  setState(() {
    widgets = json.decode(response.body);
  });
}
{% endprettify %}

Una vez que la `await`ed llamada de red se haya realizado, actualice la UI llamando a `setState()`,
que desencadena una reconstrucción del sub-árbol del widget y actualiza los datos.

El siguiente ejemplo carga datos asincrónicamente y los muestra en un `ListView`:

<!-- skip -->
{% prettify dart %}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
      ),
      body: new ListView.builder(
          itemCount: widgets.length,
          itemBuilder: (BuildContext context, int position) {
            return getRow(position);
          }));
  }

  Widget getRow(int i) {
    return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new Text("Row ${widgets[i]["title"]}")
    );
  }

  loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }
}
{% endprettify %}

Consulte la siguiente sección para obtener más información sobre cómo trabajar
en segundo plano, y en qué se diferencia Flutter de Android.

## ¿Cómo se mueve el trabajo a un hilo de segundo plano?

Dado que Flutter es un hilo único y ejecuta un loop de eventos, no
tiene que preocuparse por la gestión de hilos o por el desove de hilos de segundo plano.
Esto es muy similar a Xamarin.Forms. Si está realizando un trabajo I/O, como un disco
o una llamada de red, entonces puede usar `async`/`await` con seguridad y ya está todo listo.

Si, por otro lado, necesita hacer un trabajo intensivo de computación que mantenga el
CPU ocupado, quieres moverla a un `Isolate` para evitar bloquear el loop de eventos, como
mantendrías cualquier tipo de trabajo fuera del hilo principal. Esto es similar a cuando
mueves cosas a un hilo diferente vía `Task.Run()` en Xamarin.Forms.

Para trabajos de I/O, declarar la función como una función `async`,
y `await` en tareas de larga duración dentro de la función:

<!-- skip -->
{% prettify dart %}
loadData() async {
  String dataURL = "https://jsonplaceholder.typicode.com/posts";
  http.Response response = await http.get(dataURL);
  setState(() {
    widgets = json.decode(response.body);
  });
}
{% endprettify %}

Así es como normalmente se hacen las llamadas de red o de base de datos, que son ambas
operaciones I/O.

Sin embargo, hay ocasiones en las que puede estar procesando una gran cantidad de datos y
tu UI se cuelga. En Flutter, utilice `Isolate`s para aprovechar los
úcleos de la CPU para realizar tareas de larga duración o intensivas en el cálculo.

Los Isolates son hilos de ejecución separados que no comparten ninguna memoria.
con la memoria de ejecución principal. Esta es una diferencia entre `Task.Run()`. Esto
significa que no puedes acceder a las variables desde el hilo principal, o actualizar tu UI llamando a
`setState()`.

El siguiente ejemplo muestra, en un isolate simple, cómo compartir datos de
vuelta al hilo principal para actualizar la UI.

<!-- skip -->
{% prettify dart %}
loadData() async {
  ReceivePort receivePort = new ReceivePort();
  await Isolate.spawn(dataLoader, receivePort.sendPort);

  // El 'eco' isolate envía su SendPort como primer mensaje
  SendPort sendPort = await receivePort.first;

  List msg = await sendReceive(sendPort, "https://jsonplaceholder.typicode.com/posts");

  setState(() {
    widgets = msg;
  });
}

// El punto de entrada para el isolate
static dataLoader(SendPort sendPort) async {
  // Open the ReceivePort for incoming messages.
  ReceivePort port = new ReceivePort();

  // Notifique a cualquier otro isolates a qué puerto escucha este isolate.
  sendPort.send(port.sendPort);

  await for (var msg in port) {
    String data = msg[0];
    SendPort replyTo = msg[1];

    String dataURL = data;
    http.Response response = await http.get(dataURL);
    // Lots of JSON to parse
    replyTo.send(json.decode(response.body));
  }
}

Future sendReceive(SendPort port, msg) {
  ReceivePort response = new ReceivePort();
  port.send([msg, response.sendPort]);
  return response.first;
}
{% endprettify %}

Aquí, , `dataLoader()` es el `Isolate` que se ejecuta en su propio hilo de ejecución separado.
En el isolate puede realizar un procesamiento más intensivo de la CPU (analizando un JSON grande, por
ejemplo), o realizar cálculos matemáticos intensivos en computación, como encriptación o procesamiento de señales.

Puede ejecutar el ejemplo completo a continuación:

{% prettify dart %}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:isolate';

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    }

    return false;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Sample App"),
        ),
        body: getBody());
  }

  ListView getListView() => new ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      });

  Widget getRow(int i) {
    return new Padding(padding: new EdgeInsets.all(10.0), child: new Text("Row ${widgets[i]["title"]}"));
  }

  loadData() async {
    ReceivePort receivePort = new ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    // The 'echo' isolate sends its SendPort as the first message
    SendPort sendPort = await receivePort.first;

    List msg = await sendReceive(sendPort, "https://jsonplaceholder.typicode.com/posts");

    setState(() {
      widgets = msg;
    });
  }

  // el punto de entrada de el isolate
  static dataLoader(SendPort sendPort) async {
    // Open the ReceivePort for incoming messages.
    ReceivePort port = new ReceivePort();

    // Notifique a cualquier otro isolate a qué puerto escucha este isolate.
    sendPort.send(port.sendPort);

    await for (var msg in port) {
      String data = msg[0];
      SendPort replyTo = msg[1];

      String dataURL = data;
      http.Response response = await http.get(dataURL);
      // Lots of JSON to parse
      replyTo.send(json.decode(response.body));
    }
  }

  Future sendReceive(SendPort port, msg) {
    ReceivePort response = new ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }
}
{% endprettify %}

## ¿Cómo hago solicitudes de red?

En Xamarin.Forms usted usaría `HttpClient`. Hacer una llamada de red en Flutter
es fácil cuando usas el popular [`http` package](https://pub.dartlang.org/packages/http).
Esto abstrae gran parte de la red que usted mismo podría implementar normalmente,
lo que simplifica la realización de llamadas de red.

Para usar el paquete `http`, agréguelo a sus dependencias en `pubspec.yaml`:

<!-- skip -->
{% prettify yaml %}
dependencies:
  ...
  http: ^0.11.3+16
{% endprettify %}

Para hacer una petición de red, llame `await` en la función `async` `http.get()`:

<!-- skip -->
{% prettify dart %}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
[...]
  loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }
}
{% endprettify %}

## ¿Cómo puedo mostrar el progreso de una tarea de larga duración?

En Xamarin.Forms normalmente se crea un indicador de carga, ya sea directamente
en XAML o a través de un plugin de terceros como AcrDialogs.

En Flutter, usa un widget `ProgressIndicator`. Muestre el progreso de forma programática
controlando cuándo se renderiza a través de una bandera booleana. Dile a Flutter que actualice
su estado antes de que comience la tarea de larga duración, y ocultarla después de que finalice.

En el siguiente ejemplo, la función de construcción se divide en tres funciones diferentes.
Si `showLoadingDialog()` es `true` (cuando `widgets.length == 0`),
entonces renderiza `ProgressIndicator`. De lo contrario, renderiza el
`ListView` con los datos devueltos de una llamada de red.

<!-- skip -->
{% prettify dart %}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  showLoadingDialog() {
    return widgets.length == 0;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Sample App"),
        ),
        body: getBody());
  }

  ListView getListView() => new ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      });

  Widget getRow(int i) {
    return new Padding(padding: new EdgeInsets.all(10.0), child: new Text("Row ${widgets[i]["title"]}"));
  }

  loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }
}
{% endprettify %}

# Estructura y recursos del proyecto

## ¿Dónde guardo mis archivos de imagen?

Xamarin.Forms no tiene una forma independiente de la plataforma para almacenar imágenes,
tenías que colocar las imágenes en la carpeta iOS `xcasset` o en Android, las diferentes carpetas `drawable`.

Mientras que Android e iOS tratan los recursos y activos como elementos distintos, las apps Flutter tienen
solo activos. Todos los recursos que vivirían en las carpetas `Resources/drawable-*`
de Android, se colocan en una carpeta de activos para Flutter.

Flutter sigue un formato simple basado en la densidad como iOS. Los activos pueden ser `1.0x`,
`2.0x`, `3.0x`, o cualquier otro multiplicador. Flutter no tiene `dp`s pero hay
píxeles lógicos, que son básicamente los mismos que los píxeles independientes del dispositivo.
El llamado
[`devicePixelRatio`](https://docs.flutter.io/flutter/dart-ui/Window/devicePixelRatio.html)
expresa la proporción de píxeles físicos en un solo píxel lógico.

Los equivalentes a los contenedores de densidad de Android son:

 Calificador de densidad Android | Relación de píxeles en Flutter
 --- | ---
 `ldpi` | `0.75x`
 `mdpi` | `1.0x`
 `hdpi` | `1.5x`
 `xhdpi` | `2.0x`
 `xxhdpi` | `3.0x`
 `xxxhdpi` | `4.0x`

Los activos se ubican en cualquier carpeta arbitraria, Flutter no tiene
una estructura de carpetas predefinida. Usted declara los activos (con ubicación) en
el archivo `pubspec.yaml`, y Flutter los recoge.

Tenga en cuenta que antes de Flutter 1.0 beta 2, los activos definidos en Flutter no eran
accesibles desde el lado nativo, y viceversa, los activos y recursos nativos
no estaban disponibles para Flutter, ya que vivían en carpetas separadas.

A partir de Flutter beta 2, los activos se almacenan en la carpeta de activos nativos,
y se accede a ellos desde el lado nativo utilizando el `AssetManager` de Android:

A partir de Flutter beta 2, Flutter sigue sin poder acceder a los recursos nativos,
ni a los activos nativos.

Para añadir un nuevo activo de imagen llamado `my_icon.png` a nuestro proyecto Flutter, por ejemplo,
y decidir que debería vivir en una carpeta que arbitrariamente llamamos `images`,
pondrías la imagen base (1.0x) en la carpeta `images`, y todas las demás
variantes en subcarpetas llamadas con el multiplicador de proporción apropiado:

```
images/my_icon.png       // Base: 1.0x image
images/2.0x/my_icon.png  // 2.0x image
images/3.0x/my_icon.png  // 3.0x image
```

A continuación, deberá declarar estas imágenes en su archivo `pubspec.yaml`:

<!-- skip -->
{% prettify yaml %}
assets:
 - images/my_icon.jpeg
{% endprettify %}

A continuación, puede acceder a sus imágenes utilizando `AssetImage`:

<!-- skip -->
{% prettify dart %}
return new AssetImage("images/a_dot_burr.jpeg");
{% endprettify %}

o directamente en un widget `Image`:

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return new Image.asset("images/my_image.png");
}
{% endprettify %}

Se puede encontrar información más detallada en
[Agregando Activos e Imágenes en Flutter](https://flutter.io/assets-and-images/).

## ¿Dónde almaceno cadenas de texto? ¿Cómo gestiono la ubicación?

A diferencia de.NET que tiene archivos `resx`, Flutter actualmente no tiene un sistema dedicado
similar a los recursos para las cadenas de texto. Por el momento, la mejor práctica es mantener su
texto de copia en una clase como campos estáticos y acceder a ellos desde allí. Por ejemplo:

<!-- skip -->
{% prettify dart %}
class Strings {
  static String welcomeMessage = "Bienvenido a Flutter";
}
{% endprettify %}

Luego, en tu código, puedes acceder a tus cadenas de texto como tal:

<!-- skip -->
{% prettify dart %}
new Text(Strings.welcomeMessage)
{% endprettify %}

Por defecto, Flutter sólo soporta el inglés de EE.UU. para sus cadenas de texto. Si usted necesita
agregar soporte para otros idiomas, incluye el paquete `flutter_localizations`.
Es posible que también tenga que agregar el paquete [`intl`](https://pub.dartlang.org/packages/intl)
de Dart para utilizar la maquinaria i10n, como el formato de fecha/hora.

<!-- skip -->
{% prettify yaml %}
dependencies:
  # ...
  flutter_localizations:
    sdk: flutter
  intl: "^0.15.6"
{% endprettify %}

Para usar el paquete `flutter_localizations`,
especifique `localizationsDelegates` y `supportedLocales` en el widget de la aplicación:

<!-- skip -->
{% prettify dart %}
import 'package:flutter_localizations/flutter_localizations.dart';

new MaterialApp(
 localizationsDelegates: [
   // Add app-specific localization delegate[s] here
   GlobalMaterialLocalizations.delegate,
   GlobalWidgetsLocalizations.delegate,
 ],
 supportedLocales: [
    const Locale('en', 'US'), // English
    const Locale('he', 'IL'), // Hebrew
    // ... other locales the app supports
  ],
  // ...
)
{% endprettify %}

Los delegados contienen los valores reales de las ubicaciones, mientras que los `supportedLocales`
define qué ubicaciones soporta la aplicación. El ejemplo anterior utiliza un `MaterialApp`,
por lo que tiene tanto un `GlobalWidgetsLocalizations` para los valores de ubicación
de los widgets base, como un `MaterialWidgetsLocalizations` para las ubicaciones
de los Material widgets. Si utiliza `WidgetsApp` para su app, no necesita esta última.
Tenga en cuenta que estos dos delegados contienen valores "predeterminados",
pero tendrá que proporcionar uno o más delegados para la copia traducible de su propia
aplicación, si desea que también se traduzcan.

Cuando se inicializa, el `WidgetsApp` (o `MaterialApp`)  crea un widget
[`Localizations`](https://docs.flutter.io/flutter/widgets/Localizations-class.html)
para usted, con los delegados que usted especifique.
La ubicación actual del dispositivo es siempre accesible desde el widget `Localizations`
desde el contexto actual (en forma de un objeto `Locale`), o usando el comando
[`Window.locale`](https://docs.flutter.io/flutter/dart-ui/Window/locale.html).

Para acceder a recursos locales, utilice el método `Localizations.of()`
para acceder a una clase específica de localizaciones proporcionada por un delegado determinado.
Utilice el paquete [`intl_translation`](https://pub.dartlang.org/packages/intl_translation)
para extraer una copia traducible a
[arb](https://code.google.com/p/arb/wiki/ApplicationResourceBundleSpecification)
a los archivos para traducir, e importarlos de nuevo a la aplicación para usarlos
con `intl`.

Para más detalles sobre la internacionalización y localización en Flutter, consulte la
[guía de internacionalización](/tutorials/internationalization),
que tiene código de ejemplo con y sin el paquete `intl`.

## ¿Dónde está mi archivo de proyecto?

En Xamarin.Forms tendrás un archivo `csproj`. El equivalente más cercano en Flutter es pubspec.yaml,
que contiene dependencias de paquetes y varios detalles del proyecto. Similar a.NET Standard,
los archivos dentro del mismo directorio se consideran parte del proyecto.

## ¿Cuál es el equivalente de Nuget? ¿Cómo puedo añadir dependencias?

En el ecosistema .NET, os proyectos nativos de Xamarin y Xamarin.Forms tuvieron acceso
a Nuget y al sistema de gestión de paquetes incorporado. Las aplicaciones Flutter contienen
una aplicación Android nativa, una aplicación iOS nativa y una aplicación Flutter.

En Android, puedes agregar dependencias agregándolas a tu script de construcción de Gradle.
En iOS, agregas dependencias agregándolas a tu `Podfile`.

Flutter utiliza el sistema de construcción propio de Dart y el gestor de paquetes de Pub.
Las herramientas delegan la creación de las aplicaciones nativas de envoltura de Android
e iOS a los respectivos sistemas de creación.

En general, usa `pubspec.yaml` para declarar dependencias externas para usar en Flutter. Un buen
ugar para encontrar paquetes de Flutter es [Pub](https://pub.dartlang.org/flutter).

# Ciclo de vida de la aplicación

## ¿Cómo escucho los eventos del ciclo de vida de la aplicación?

En Xamarin.Forms, usted tiene una `Aplicación` que contiene `OnStart`, `OnResume` y
`OnSleep`. En Flutter, en cambio, puede escuchar eventos similares del ciclo de vida enganchándose en
el observador `WidgetsBinding` y escuchando el evento de cambio `didChangeAppLifecycleState()`.

Los eventos observables del ciclo de vida son:

* `inactive` — La aplicación se encuentra en un estado inactivo y no está recibiendo
información del usuario. Este evento es sólo para iOS.
* `paused` — La aplicación no es actualmente visible para
el usuario, no responde a las entradas del usuario, pero se está ejecutando en segundo plano.
* `resumed` — La aplicación es visible y responde a las entradas de los usuarios.
* `suspending` — La aplicación se suspende momentáneamente. Este evento es Android
solamente.

Para más detalles sobre el significado de estos estados, vea la
[documentación `AppLifecycleStatus`](https://docs.flutter.io/flutter/dart-ui
/AppLifecycleState-class.html).

# Layouts

## ¿Cuál es el equivalente de un StackLayout?

En Xamarin.Forms puedes crear un `StackLayout` con una `Orientación` Horizontal o Vertical.
Flutter tiene un enfoque similar, sin embargo, puede usar los widgets `Row` o `Column`.

Si nota que los dos ejemplos de código son idénticos con la excepción del widget
"Row" y "Column". Los hijos son los mismos y esta característica puede ser
explotada para desarrollar diseños sofisticados que pueden cambiar con los mismos
hijos.

<!-- skip -->
{% prettify dart %}
  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text('Row One'),
        new Text('Row Two'),
        new Text('Row Three'),
        new Text('Row Four'),
      ],
    );
  }
{% endprettify %}

<!-- skip -->
{% prettify dart %}
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text('Column One'),
        new Text('Column Two'),
        new Text('Column Three'),
        new Text('Column Four'),
      ],
    );
  }
{% endprettify %}

## ¿Cuál es el equivalente a una Grid?

El equivalente más cercano a un `Grid` sería usar un `GridView`. Esto es mucho más poderoso
que a lo que estás acostumbrado en Xamarin.Forms. Un `GridView` proporciona desplazamiento automático cuando el
contenido excede el espacio visible.

<!-- skip -->
{% prettify dart %}
  GridView.count(
    // Cree una grid con 2 columnas. Si cambia el scrollDirection a
    // horizontal, esto produciría 2 filas.
    crossAxisCount: 2,
    // Genera 100 Widgets que muestran su índice en la Lista
    children: List.generate(100, (index) {
      return Center(
        child: Text(
          'Item $index',
          style: Theme.of(context).textTheme.headline,
        ),
      );
    }),
  );
{% endprettify %}

Es posible que hayas utilizado un `Grid` en Xamarin.Forms para implementar widgets que se superponen a otros widgets.
En Flutter, esto se consigue con el widget `Stack`.

Este ejemplo crea dos iconos que se superponen entre sí.

<!-- skip -->
{% prettify dart %}
  child: new Stack(
    children: <Widget>[
      new Icon(Icons.add_box, size: 24.0, color: const Color.fromRGBO(0,0,0,1.0)),
      new Positioned(
        left: 10.0,
        child: new Icon(Icons.add_circle, size: 24.0, color: const Color.fromRGBO(0,0,0,1.0)),
      ),
    ],
  ),
{% endprettify %}

## ¿Cuál es el equivalente de un ScrollView?

En Xamarin.Forms, un `ScrollView` envuelve un `VisualElement` y, si el contenido es mayor que
la pantalla del dispositivo, se desplaza.

En Flutter, la coincidencia más cercana es el widget `SingleChildScrollView`. Sólo tiene que rellenar el
Widget con el contenido que desea que se pueda desplazar.

<!-- skip -->
{% prettify dart %}
  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Text('Long Content'),
    );
  }
{% endprettify %}

Si tiene muchos elementos que desea envolver en un scroll, incluso de diferentes tipos de `Widget`, es posible que desee
utilizar un `ListView`. Esto puede parecer exagerado, pero en Flutter esto es mucho más optimizado
y menos intensivo que un `ListView` de Xamarin.Forms, que se apoya en controles específicos de la plataforma.

<!-- skip -->
{% prettify dart %}
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Text('Row One'),
        new Text('Row Two'),
        new Text('Row Three'),
        new Text('Row Four'),
      ],
    );
  }
{% endprettify %}

## ¿Cómo manejo las transiciones horizontales en Flutter?

Las transiciones horizontales se pueden manejar automáticamente configurando la propiedad `configChanges`
en el archivo AndroidManifest.xml:

{% prettify yaml %}
android:configChanges="orientation|screenSize"
{% endprettify %}

# Detección de gestos y manejo de eventos táctiles

## ¿Cómo puedo añadir GestureRecognizers a un widget en Flutter?

En Xamarin.Forms, `Element`s pueden contener un evento Click que puedes vincular. Muchos elementos
también contienen un `Command` que está ligado a este evento. Alternativamente puedes usar el
`TapGestureRecognizer`. En Flutter hay dos formas muy similares:

 1. Si el Widget soporta la detección de eventos, pásele una función y manéjela
    en la función. Por ejemplo, el RaisedButton tiene un parámetro `onPressed`:

    <!-- skip -->
    ```dart
    @override
    Widget build(BuildContext context) {
      return new RaisedButton(
          onPressed: () {
            print("click");
          },
          child: new Text("Button"));
    }
    ```

 2. Si el Widget no soporta la detección de eventos, envuélvalo el widget en
    un GestureDetector y pase una función al parámetro `onTap`.

    <!-- skip -->
    ```dart
    class SampleApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return new Scaffold(
            body: new Center(
          child: new GestureDetector(
            child: new FlutterLogo(
              size: 200.0,
            ),
            onTap: () {
              print("tap");
            },
          ),
        ));
      }
    }
    ```

## ¿Cómo puedo manejar otros gestos en los widgets?

En Xamarin.Forms agregarías un `GestureRecognizer` al `VisualElement`.
Normalmente se limitaría a `TapGestureRecognizer`, `PinchGestureRecognizer` y
`PanGestureRecognizer`, a menos que construyas el tuyo propio.

En Flutter, usando el GestureDetector, puedes escuchar una amplia gama de Gestos como:

* Tap

  * `onTapDown` - Un puntero que podría causar un tap ha entrado en contacto con la pantalla
     de una ubicación en particular.
  * `onTapUp` - Un puntero que activa un tap ha dejado de entrar en contacto con la
     pantalla en una ubicación determinada.
  * `onTap` - Se ha producido un tap.
  * `onTapCancel` - El puntero que previamente disparó el  `onTapDown` no
     causará un tap.

* Doble tap

  * `onDoubleTap` - El usuario tocó la pantalla en la misma ubicación dos veces en
     rápida sucesión.

* Pulsación larga

  * `onLongPress` - Un puntero ha permanecido en contacto con la pantalla en el mismo
    lugar durante un largo período de tiempo.

* Arrastre vertical

  * `onVerticalDragStart` - Un puntero ha entrado en contacto con la pantalla y podría comenzar a
    moverse verticalmente.
  * `onVerticalDragUpdate` - Un puntero en contacto con la pantalla
    se ha movido más en la dirección vertical.
  * `onVerticalDragEnd` - Un puntero que antes estaba en contacto con la
    y se movía verticalmente ya no está en contacto con la pantalla y se movía
    a una velocidad específica cuando dejó de entrar en contacto con la pantalla.

* Arrastre horizontal

  * `onHorizontalDragStart` - Un puntero ha entrado en contacto con la pantalla y puede comenzar
    a moverse horizontalmente.
  * `onHorizontalDragUpdate` - Un puntero en contacto con la pantalla
    se ha movido más en la dirección horizontal.
  * `onHorizontalDragEnd` - Un puntero que antes estaba en contacto con la
    pantalla y se movía horizontalmente ya no está en contacto con la pantalla y se movía
    a una velocidad específica cuando dejó de entrar en contacto con la pantalla.

El siguiente ejemplo muestra un `GestureDetector` que rota el logotipo de Flutter
con un doble tap:

<!-- skip -->
{% prettify dart %}
AnimationController controller;
CurvedAnimation curve;

@override
void initState() {
  controller = new AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
  curve = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
          child: new GestureDetector(
            child: new RotationTransition(
                turns: curve,
                child: new FlutterLogo(
                  size: 200.0,
                )),
            onDoubleTap: () {
              if (controller.isCompleted) {
                controller.reverse();
              } else {
                controller.forward();
              }
            },
        ),
    ));
  }
}
{% endprettify %}

# Listviews y adaptadores

## ¿Cuál es la alternativa a un ListView en Flutter?

El equivalente a un `ListView` en Flutter es … un `ListView`!

En un `ListView` de Xamarin.Forms, usted crea un `ViewCell` y posiblemente un `DataTemplateSelector`
y lo pasa a la `ListView`, que muestra cada fila con lo que su `DataTemplateSelector`
o `ViewCell` devuelve. Sin embargo, a menudo tienes que asegurarte de activar el Reciclaje de Celdas
de lo contrario te encontrarás con problemas de memoria y velocidades de desplazamiento lentas.

Debido al patrón inmutable de widgets de Flutter, pasas una lista de
Widgets a su `ListView`, y Flutter se encarga de asegurarse de que el
desplazamiento sea rápido y suave.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
      ),
      body: new ListView(children: _getListData()),
    );
  }

  _getListData() {
    List<Widget> widgets = [];
    for (int i = 0; i < 100; i++) {
      widgets.add(new Padding(padding: new EdgeInsets.all(10.0), child: new Text("Row $i")));
    }
    return widgets;
  }
}
{% endprettify %}

## ¿Cómo sé en qué elemento de la lista se hace clic?

En Xamarin.Forms, el ListView tiene un método para averiguar qué ítem fue clickeado
`ItemTapped`. Existen muchas otras técnicas que puede haber utilizado, como por ejemplo, verificar
cuando cambia el comportamiento de `SelectedItem` o de agregar un `EventToCommand`.

En Flutter, utiliza el manejo táctil proporcionado por los widgets transferidos.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
      ),
      body: new ListView(children: _getListData()),
    );
  }

  _getListData() {
    List<Widget> widgets = [];
    for (int i = 0; i < 100; i++) {
      widgets.add(new GestureDetector(
        child: new Padding(
            padding: new EdgeInsets.all(10.0),
            child: new Text("Row $i")),
        onTap: () {
          print('row tapped');
        },
      ));
    }
    return widgets;
  }
}
{% endprettify %}

## ¿Cómo actualizo ListView's dinámicamente?

En Xamarin.Forms, si vinculó la propiedad `ItemsSource` a una `ObservableCollection`
simplemente actualizaría la lista en su ViewModel. Alternativamente podría asignar
una nueva `List` a la propiedad `ItemsSource` vinculada para cambiar todos los items.

En Flutter, las cosas funcionan un poco diferente. Si actualizaras la lista de widgets
dentro de un `setState()`, verías rápidamente que tus datos no cambian visualmente.
Esto se debe a que cuando se llama `setState()`, el motor de renderizado de Flutter
mira el árbol de widgets para ver si algo ha cambiado. Cuando llega a su
`ListView`, realiza una comprobación `==`, y determina que las dos `ListView`s son las
mismas. No ha cambiado nada, por lo que no se requiere ninguna actualización.

Para una manera sencilla de actualizar su `ListView`, cree una nueva `List` dentro de
`setState()`, y copie los datos de la lista anterior a la nueva.
Aunque este enfoque es simple, no se recomienda para conjuntos de datos grandes,
como se muestra en el siguiente ejemplo.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  // TEste widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      widgets.add(getRow(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
      ),
      body: new ListView(children: widgets),
    );
  }

  Widget getRow(int i) {
    return new GestureDetector(
      child: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: new Text("Row $i")),
      onTap: () {
        setState(() {
          widgets = new List.from(widgets);
          widgets.add(getRow(widgets.length + 1));
          print('row $i');
        });
      },
    );
  }
}
{% endprettify %}

La manera recomendada, eficiente y efectiva de construir una lista utiliza un
ListView.Builder. Este método es excelente cuando se tiene una Lista dinámica
o una Lista con grandes cantidades de datos.  Esto es esencialmente
el equivalente de RecyclerView en Android, que automáticamente
recicla los elementos de la lista por ti:

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      widgets.add(getRow(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Sample App"),
        ),
        body: new ListView.builder(
            itemCount: widgets.length,
            itemBuilder: (BuildContext context, int position) {
              return getRow(position);
            }));
  }

  Widget getRow(int i) {
    return new GestureDetector(
      child: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: new Text("Row $i")),
      onTap: () {
        setState(() {
          widgets.add(getRow(widgets.length + 1));
          print('row $i');
        });
      },
    );
  }
}
{% endprettify %}

En lugar de crear un "ListView", cree un ListView.builder que
tome dos parámetros clave: la longitud inicial de la lista y una función ItemBuilder.

La función ItemBuilder es similar a la función `getView` en un adaptador Android
oma una posición y devuelve la fila que quieres que se muestre en esa posición.

Finalmente, pero lo más importante, note que la función `onTap()`
ya no recrea la lista, sino que `.add`s a ella.

Para más información, por favor visite
[Escribe tu primera aplicación Flutter, parte 1](https://codelabs.developers.google.com/codelabs/first-flutter-app-pt1/index.html?index=..%2F..%2Findex#0)
y [Escribe tu primera aplicación Flutter, parte 2](https://codelabs.developers.google.com/codelabs/first-flutter-app-pt2/index.html?index=..%2F..%2Findex#0)

# Trabajar con texto

## ¿Cómo configuro fuentes personalizadas en mis widgets de Texto?

En Xamarin.Forms, endría que agregar una fuente personalizada en cada proyecto nativo. Entonces
en su  `Element` usted asignaría este nombre de fuente al atributo  `FontFamily`
usando `filename#fontname` y sólo `fontname` para iOS.

En Flutter, coloque el archivo de fuente en una carpeta y haga referencia a él en
el archivo `pubspec.yaml`, de forma similar a como usted importa imágenes.

<!-- skip -->
{% prettify yaml %}
fonts:
   - family: MyCustomFont
     fonts:
       - asset: fonts/MyCustomFont.ttf
       - style: italic
{% endprettify %}

A continuación, asigne la fuente a su widget `Text`:

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return new Scaffold(
    appBar: new AppBar(
      title: new Text("Sample App"),
    ),
    body: new Center(
      child: new Text(
        'Este es un texto de fuente personalizado',
        style: new TextStyle(fontFamily: 'MyCustomFont'),
      ),
    ),
  );
}
{% endprettify %}

## ¿Cómo puedo cambiar el estilo de mis widgets de texto?

Junto con las fuentes, puedes personalizar otros elementos de estilo en un widget `Text`.
El parámetro de estilo de un widget `Text` toma un objeto `TextStyle`, donde puedes
personalizar muchos parámetros, como por ejemplo:

* `color`
* `decoration`
* `decorationColor`
* `decorationStyle`
* `fontFamily`
* `fontSize`
* `fontStyle`
* `fontWeight`
* `hashCode`
* `height`
* `inherit`
* `letterSpacing`
* `textBaseline`
* `wordSpacing`

# Entrada de formulario

## ¿Cómo puedo recuperar las entradas del usuario?

Los `element`s en Xamarin.Forms le permiten consultar directamente al `element` para determinar
el estado de cualquiera de sus propiedades, o está vinculado a una propiedad en un `ViewModel`.

La recuperación de información en Flutter es manejada por widgets especializados y es diferente
que a lo que estás acostumbrado. Si tiene un `TextField` o un `TextFormField`, puede proporcionar un
[`TextEditingController`](https://docs.flutter.io/flutter/widgets/TextEditingController-class.html)
para recuperar la entrada del usuario:

<!-- skip -->
{% prettify dart %}
class _MyFormState extends State<MyForm> {
  // Cree un controlador de texto y utilícelo para recuperar el valor actual.
  // de el TextField!
  final myController = new TextEditingController();

  @override
  void dispose() {
    // Limpie el controlador cuando elimine el Widget.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Recuperar entrada de texto'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        // Cuando el usuario pulsa el botón, muestra un diálogo de alerta con el
        // texto que el usuario ha escrito en nuestro campo de texto.
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context) {
              return new AlertDialog(
                // Recupere el texto que el usuario ha escrito con nuestro
                // TextEditingController
                content: new Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: new Icon(Icons.text_fields),
      ),
    );
  }
}
{% endprettify %}

Puede encontrar más información y la lista completa de códigos en
[Recuperar el valor de un campo de texto](/cookbook/forms/retrieve-input/),
del [Flutter Cookbook](https://flutter.io/cookbook/).

## ¿Cuál es el equivalente a un "Placeholder" en una entrada?

En Xamarin.Forms, algunos `Elements` soportan una propiedad `Placeholder`, se le asignaría
un valor a, por ejemplo

<!-- skip -->
{% prettify xml %}
  <Entry Placeholder="Esto es una sugerencia.">
{% endprettify %}

In Flutter, you can easily show a "hint" o un placeholder para su entrada
agregando un objeto InputDecoration al parámetro constructor de decoración
para el Widget de Texto.

<!-- skip -->
{% prettify dart %}
body: new Center(
  child: new TextField(
    decoration: new InputDecoration(hintText: "Esto es una sugerencia."),
  )
)
{% endprettify %}

## ¿Cómo puedo mostrar los errores de validación?

Con Xamarin.Forms, si desea proporcionar un indicio visual de un
error de validación, deberá crear nuevas propiedades y `VisualElement`s
que rodeen a los `Element`s que tengan errores de validación.

En Flutter pasamos a través de un objeto InputDecoration al constructor de decoración
para el widget Text.

Sin embargo, no desea comenzar mostrando un error.
En su lugar, cuando el usuario haya introducido datos no válidos,
actualice el estado y pase un nuevo objeto `InputDecoration`.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Ejemplo de aplicación',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  String _errorText;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Ejemplo de aplicación"),
      ),
      body: new Center(
        child: new TextField(
          onSubmitted: (String text) {
            setState(() {
              if (!isEmail(text)) {
                _errorText = 'Error: This is not an email';
              } else {
                _errorText = null;
              }
            });
          },
          decoration: new InputDecoration(hintText: "This is a hint", errorText: _getErrorText()),
        ),
      ),
    );
  }

  _getErrorText() {
    return _errorText;
  }

  bool isEmail(String em) {
    String emailRegexp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(emailRegexp);

    return regExp.hasMatch(em);
  }
}
{% endprettify %}

# Plugins de Flutter

# Interactuar con el hardware, los servicios de terceros y la plataforma

## ¿Cómo interactúo con la plataforma y con el código nativo de la plataforma?

Flutter no ejecuta código directamente en la plataforma subyacente; en cambio, el código de Dart
que constituye una aplicación Flutter se ejecuta de forma nativa en el dispositivo, esquivando" el SDK
que proporciona la plataforma. Esto significa, por ejemplo, que cuando se realiza una solicitud de red
en Dart, se ejecuta directamente en el contexto de Dart. No usas los APIs de Android o iOS
de las que normalmente se aprovecha al escribir aplicaciones nativas. Tu aplicación Flutter
sigue alojada en una aplicación nativa de `ViewController` o `Activity` como vista,
pero no tienes acceso directo a esto, o a la estructura nativa.

Esto no significa que las aplicaciones Flutter no puedan interactuar con esas APIs nativas, o con
o con código nativo que tengas. Flutter proporciona [canales de plataforma](/platform-channels/),
que se comunican e intercambian datos con el `ViewController` o `Activity` que
aloja su vista Flutter. Los canales de la plataforma son esencialmente un mecanismo de mensajería asíncrono
que une el código de Dart con el host `ViewController` o `Activity` y
el framework iOS o Android en el que se ejecuta. Puede utilizar canales de plataforma para ejecutar un método en
el lado nativo o para recuperar algunos datos de los sensores del dispositivo, por ejemplo.

Además de utilizar directamente los canales de la plataforma, puede utilizar una gran variedad de canales prefabricados.
[plugins](/using-packages/) que encapsula el código nativo y
el código Dart para un objetivo específico. Por ejemplo, puede utilizar un plugin para acceder
al registro de cámara y a la cámara del dispositivo directamente desde Flutter, sin tener que
escribir su propia integración. Plugins se encuentran [on Pub](https://pub.dartlang.org/),
el repositorio de paquetes de código abierto de Dart y Flutter. Algunos paquetes pueden
soportar integraciones nativas en iOS, Android o ambos.

Si no puede encontrar un plugin en Pub que se ajuste a sus necesidades, puede
[escribir su propio](/developing-packages/)
y [publicarlo en Pub](/developing-packages/#publish).

## ¿Cómo accedo al sensor GPS?

Utilice el plugin de la comunidad [`geolocator`](https://pub.dartlang.org/packages/geolocator).

## ¿Cómo accedo a la cámara?

El plugin [`image_picker`](https://pub.dartlang.org/packages/image_picker) es muy popular
para acceder a la cámara.

## ¿Cómo inicio sesión con Facebook?

Para iniciar sesión con Facebook, utilice el
plugin de la comunidad [`flutter_facebook_login`](https://pub.dartlang.org/packages/flutter_facebook_login).

## ¿Cómo uso las funciones de Firebase?

La mayoría de las funciones de Firebase están cubiertas por
[plugins de primera mano](https://pub.dartlang.org/flutter/packages?q=firebase).
Estos plugins son integraciones de primera mano, mantenidas por el equipo de Flutter:

 * [`firebase_admob`](https://pub.dartlang.org/packages/firebase_admob) para Firebase AdMob
 * [`firebase_analytics`](https://pub.dartlang.org/packages/firebase_analytics) para Firebase Analytics
 * [`firebase_auth`](https://pub.dartlang.org/packages/firebase_auth) para Firebase Auth
 * [`firebase_database`](https://pub.dartlang.org/packages/firebase_database) para Firebase RTDB
 * [`firebase_storage`](https://pub.dartlang.org/packages/firebase_storage) para Firebase Cloud Storage
 * [`firebase_messaging`](https://pub.dartlang.org/packages/firebase_messaging) para Firebase Messaging (FCM)
 * [`flutter_firebase_ui`](https://pub.dartlang.org/packages/flutter_firebase_ui) para integraciones rápidas de Firebase Auth (Facebook, Google, Twitter and email)
 * [`cloud_firestore`](https://pub.dartlang.org/packages/cloud_firestore) para Firebase Cloud Firestore

También puede encontrar algunos plugins Firebase de terceros en Pub que cubren áreas
que no están directamente cubiertas por los plugins de primera mano.

## ¿Cómo puedo crear mis propias integraciones nativas personalizadas?

Si hay funcionalidades específicas de la plataforma que Flutter o sus plugins de la comunidad
Plugins are missing, no están disponibles, puedes construir los tuyos propios siguiendo la página
[desarrollo de paquetes y plugins](/developing-packages/).

La arquitectura de los plugins de Flutter, en pocas palabras, es muy parecida a la de un bus de eventos en
Android: tú disparas un mensaje y dejas que el receptor lo procese y te devuelve el resultado.
En este caso, el receptor es código que se ejecuta en el lado
nativo de Android o iOS.

# Temas (Estilos)

## ¿Cómo puedo ponerle un tema a mi aplicación?

Desde el principio, Flutter viene con una hermosa implementación de Material Design
que se encarga de un montón de necesidades de estilo y de temas que usted
típicamente haría.

Xamarin.Forms tiene un `ResourceDictionary` global donde puedes compartir estilos
a través de tu aplicación. Alternativamente, hay soporte para temas actualmente en vista previa.

En Flutter declaras temas en el widget de nivel superior.

Para aprovechar al máximo los componentes de Material de su aplicación, puede declarar un
widget de nivel superior `MaterialApp` como punto de entrada a su aplicación. MaterialApp
es un widget de conveniencia que incluye una serie de widgets que son comúnmente
requeridos para las aplicaciones que implementan Material Design. Se basa en una WidgetsApp agregando
funcionalidad específica de Material.

También puede usar un `WidgetApp` como su widget de aplicación, que proporciona algunas
de las mismas funcionalidades, pero no es tan rica como `MaterialApp`.

Para personalizar los colores y estilos de cualquier componente hijo, pase un objeto
`ThemeData` al widget `MaterialApp`. Por ejemplo, en el siguiente código,
el primary swatch se establece en azul y el color de selección de texto es rojo.

<!-- skip -->
{% prettify dart %}
class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        textSelectionColor: Colors.red
      ),
      home: new SampleAppPage(),
    );
  }
}
{% endprettify %}

# Bases de datos y almacenamiento local

## ¿Cómo puedo acceder a las Preferencias compartidas o a los valores predeterminados del usuario?

Los desarrolladores de Xamarin.Forms probablemente estarán familiarizados con el plugin `Xam.Plugins.Settings`.

En Flutter, acceda a funciones equivalentes utilizando el
[Plugin de Preferencias compartidas](https://pub.dartlang.org/packages/shared_preferences).
Este plugin envuelve la funcionalidad tanto de `UserDefaults` como de su equivalente en Android,
`SharedPreferences`.

## ¿Cómo accedo a SQLite en Flutter?

En Xamarin.Forms la mayoría de las aplicaciones usarían el plugin `sqlite-net-pcl` para acceder
a las bases de datos SQLite.

En Flutter, acceda a esta funcionalidad utilizando el plugin
[SQFlite](https://pub.dartlang.org/packages/sqflite).

# Notificaciones

## ¿Cómo configuro las notificaciones push?

En Android, se utiliza la mensajería en nube de Firebase para configurar notificaciones
push para la aplicación.

En Flutter, acceda a esta funcionalidad utilizando el plugin
[Firebase_Messaging](https://github.com/flutter/plugins/tree/master/packages/firebase_messaging).
Para más información sobre el uso de la API de mensajería en la nube de Firebase,
consulte la documentación del plugin
[`firebase_messaging`](https://pub.dartlang.org/packages/firebase_messaging).