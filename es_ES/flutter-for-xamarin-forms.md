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

## ¿Cómo se mueve el trabajo a un hilo de fondo?

Dado que Flutter es un hilo único y ejecuta un loop de eventos, no
tiene que preocuparse por la gestión de hilos o por el desove de hilos de fondo.
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

When initialized, the `WidgetsApp` (or `MaterialApp`) creates a
[`Localizations`](https://docs.flutter.io/flutter/widgets/Localizations-class.html)
widget for you, with the delegates you specify.
The current locale for the device is always accessible from the `Localizations`
widget from the current context (in the form of a `Locale` object), or using the
[`Window.locale`](https://docs.flutter.io/flutter/dart-ui/Window/locale.html).

To access localized resources, use the `Localizations.of()` method to
access a specific localizations class that is provided by a given delegate.
Use the [`intl_translation`](https://pub.dartlang.org/packages/intl_translation)
package to extract translatable copy to
[arb](https://code.google.com/p/arb/wiki/ApplicationResourceBundleSpecification)
files for translating, and importing them back into the app for using them
with `intl`.

For further details on internationalization and localization in Flutter, see the
[internationalization guide](/tutorials/internationalization),
which has sample code with and without the `intl` package.

## Where is my project file?

In Xamarin.Forms you will have a `csproj` file. The closest equivalent in Flutter is pubspec.yaml,
which contains package dependencies and various project details. Similar to .NET Standard,
files within the same directory are considered part of the project.

## What is the equivalent of Nuget? How do I add dependencies?

In the .NET eco-system, native Xamarin projects and Xamarin.Forms projects had access
to Nuget and the inbuilt package management system. Flutter apps contain a native
Android app, native iOS app and Flutter app.

In Android, you add dependencies by adding to your Gradle build script. In iOS, you add
dependencies by adding to your `Podfile`.

Flutter uses Dart's own build system, and the Pub package manager.
The tools delegate the building of the native Android and iOS wrapper apps to the
respective build systems.

In general, use `pubspec.yaml` to declare external dependencies to use in Flutter. A good
place to find Flutter packages is [Pub](https://pub.dartlang.org/flutter).

# Application Lifecycle

## How do I listen to application lifecycle events?

In Xamarin.Forms, you have an `Application` that contains `OnStart`, `OnResume` and
`OnSleep`. In Flutter you can instead listen to similar lifecycle events by hooking into
the `WidgetsBinding` observer and listening to the `didChangeAppLifecycleState()` change event.

The observable lifecycle events are:

* `inactive` — The application is in an inactive state and is not receiving
user input. This event is iOS only.
* `paused` — The application is not currently visible to
the user, is not responding to user input, but is running in the background.
* `resumed` — The application is visible and responding to user input.
* `suspending` — The application is suspended momentarily. This event is Android
only.

For more details on the meaning of these states, see
[`AppLifecycleStatus` documentation](https://docs.flutter.io/flutter/dart-ui
/AppLifecycleState-class.html).

# Layouts

## What is the equivalent of a StackLayout?

In Xamarin.Forms you can create a `StackLayout` with an `Orientation` of Horizontal or Vertical.
Flutter has a similar approach, however you would use the `Row` or `Column` widgets.

If you notice the two code samples are identical with the exception of the
"Row" and "Column" widget. The children are the same and this feature can be
exploited to develop rich layouts that can change overtime with the same
children.

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

## What is the equivalent of a Grid?

The closest equivalent of a `Grid` would be to use a `GridView`. This is much more powerful
than what you are used to in Xamarin.Forms. A `GridView` provides automatic scrolling when the
content exceeds the its viewable space.

<!-- skip -->
{% prettify dart %}
  GridView.count(
    // Create a grid with 2 columns. If you change the scrollDirection to
    // horizontal, this would produce 2 rows.
    crossAxisCount: 2,
    // Generate 100 Widgets that display their index in the List
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

You may have used a `Grid` in Xamarin.Forms to implement widgets that overlay other widgets.
In Flutter, you accomplish this with the `Stack` widget.

This sample creates two icons that overlap each other.

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

## What is the equivalent of a ScrollView?

In Xamarin.Forms, a `ScrollView` wraps around a `VisualElement` and, if the content is larger than
the device screen, it scrolls.

In Flutter, the closest match is the `SingleChildScrollView` widget. You simply fill the
Widget with the content that you want to be scrollable.

<!-- skip -->
{% prettify dart %}
  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Text('Long Content'),
    );
  }
{% endprettify %}

If you have many items you want to wrap in a scroll, even of different `Widget` types, you might want
to use a `ListView`. This might seem like overkill, but in Flutter this is far more optimized
and less intensive than a Xamarin.Forms `ListView` which is backing on to platform specific controls.

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

## How do I handle landscape transitions in Flutter?

Landscape transitions can be handled automatically by setting the `configChanges`
property in the AndroidManifest.xml:

{% prettify yaml %}
android:configChanges="orientation|screenSize"
{% endprettify %}

# Gesture detection and touch event handling

## How do I add GestureRecognizers to a widget in Flutter?

In Xamarin.Forms, `Element`s may contain a Click event you can attach to. Many elements
also contain a `Command` that is tied to this event. Alternatively you would use the
`TapGestureRecognizer`. In Flutter there are two very similar ways:

 1. If the Widget supports event detection, pass a function to it and handle it
    in the function. For example, the RaisedButton has an `onPressed` parameter:

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

 2. If the Widget doesn't support event detection, wrap the
    widget in a GestureDetector and pass a function to the `onTap` parameter.

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

## How do I handle other gestures on widgets?

In Xamarin.Forms you would add a `GestureRecognizer` to the `VisualElement`. You
would normally be limited to `TapGestureRecognizer`, `PinchGestureRecognizer` and
`PanGestureRecognizer`, unless you built your own.

In Flutter, using the GestureDetector, you can listen to a wide range of Gestures such as:

* Tap

  * `onTapDown` - A pointer that might cause a tap has contacted the screen at a
     particular location.
  * `onTapUp` - A pointer that triggers a tap has stopped contacting the
     screen at a particular location.
  * `onTap` - A tap has occurred.
  * `onTapCancel` - The pointer that previously triggered the `onTapDown` won't
     cause a tap.

* Double tap

  * `onDoubleTap` - The user tapped the screen at the same location twice in
     quick succession.

* Long press

  * `onLongPress` - A pointer has remained in contact with the screen at the same
    location for a long period of time.

* Vertical drag

  * `onVerticalDragStart` - A pointer has contacted the screen and might begin to
    move vertically.
  * `onVerticalDragUpdate` - A pointer in contact with the screen
    has moved further in the vertical direction.
  * `onVerticalDragEnd` - A pointer that was previously in contact with the
    screen and moving vertically is no longer in contact with the screen and was
    moving at a specific velocity when it stopped contacting the screen.

* Horizontal drag

  * `onHorizontalDragStart` - A pointer has contacted the screen and might begin
    to move horizontally.
  * `onHorizontalDragUpdate` - A pointer in contact with the screen
    has moved further in the horizontal direction.
  * `onHorizontalDragEnd` - A pointer that was previously in contact with the
    screen and moving horizontally is no longer in contact with the screen and was
    moving at a specific velocity when it stopped contacting the screen.

The following example shows a `GestureDetector` that rotates the Flutter logo
on a double tap:

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

# Listviews & adapters

## What is the alternative to a ListView in Flutter?

The equivalent to a `ListView` in Flutter is … a `ListView`!

In a Xamarin.Forms `ListView`, you create a `ViewCell` and possibly a `DataTemplateSelector`
and pass it into the `ListView`, which renders each row with what your `DataTemplateSelector`
or `ViewCell` returns. However, you often have have to make sure you turn on Cell Recycling
otherwise you will run into memory issues and slow scrolling speeds.

Due to Flutter's immutable widget pattern, you pass a List of
Widgets to your `ListView`, and Flutter takes care of making sure
that scrolling is fast and smooth.

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
      widgets.add(new Padding(padding: new EdgeInsets.all(10.0), child: new Text("Row $i")));
    }
    return widgets;
  }
}
{% endprettify %}

## How do I know which list item is clicked on?

In Xamarin.Forms, the ListView has a method to find out which item was clicked
`ItemTapped`. There are many other techniques you may have used such as checking
when `SelectedItem` or adding an `EventToCommand` behavior changes.

In Flutter, use the touch handling provided by the passed-in widgets.

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

## How do I update ListView's dynamically?

In Xamarin.Forms, if you bound the `ItemsSource` property to an `ObservableCollection`
you would just update the list in your ViewModel. Alternative you could assign
a new `List` to property `ItemsSource` is bound to to change all items.

In Flutter, things work a little differently. if you were to update the list of widgets
inside a `setState()`, you would quickly see that your data did not change visually.
This is because when `setState()` is called, the Flutter rendering engine
looks at the widget tree to see if anything has changed. When it gets to your
`ListView`, it performs a `==` check, and determines that the two `ListView`s are the
same. Nothing has changed, so no update is required.

For a simple way to update your `ListView`, create a new `List` inside of
`setState()`, and copy the data from the old list to the new list.
While this approach is simple, it is not recommended for large data sets,
as shown in the next example.

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

The recommended, efficient, and effective way to build a list uses a
ListView.Builder. This method is great when you have a dynamic
List or a List with very large amounts of data. This is essentially
the equivalent of RecyclerView on Android, which automatically
recycles list elements for you:

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

Instead of creating a "ListView", create a ListView.builder that
takes two key parameters: the initial length of the list, and an ItemBuilder
function.

The ItemBuilder function is similar to the `getView` function in an Android
adapter; it takes a position, and returns the row you want rendered at
that position.

Finally, but most importantly, notice that the `onTap()` function
doesn't recreate the list anymore, but instead `.add`s to it.

For more information, please visit
[Write your first Flutter app, part 1](https://codelabs.developers.google.com/codelabs/first-flutter-app-pt1/index.html?index=..%2F..%2Findex#0)
and [Write your first Flutter app, part 2](https://codelabs.developers.google.com/codelabs/first-flutter-app-pt2/index.html?index=..%2F..%2Findex#0)

# Working with text

## How do I set custom fonts on my Text widgets?

In Xamarin.Forms, you would have to add a custom font in each native project. Then
in your `Element` you would assign this font name to the `FontFamily` attribute
using `filename#fontname` and just `fontname` for iOS.

In Flutter, place the font file in a folder and reference it in the
`pubspec.yaml` file, similar to how you import images.

<!-- skip -->
{% prettify yaml %}
fonts:
   - family: MyCustomFont
     fonts:
       - asset: fonts/MyCustomFont.ttf
       - style: italic
{% endprettify %}

Then assign the font to your `Text` widget:

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
        'This is a custom font text',
        style: new TextStyle(fontFamily: 'MyCustomFont'),
      ),
    ),
  );
}
{% endprettify %}

## How do I style my Text widgets?

Along with fonts, you can customize other styling elements on a `Text` widget.
The style parameter of a `Text` widget takes a `TextStyle` object, where you can
customize many parameters, such as:

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

# Form input

## How do I retrieve user input?

Xamarin.Forms `element`s allow you to directly query the `element` to determine
the state of any of its properties, or it is bound to a property in a `ViewModel`.

Retrieving information in Flutter is handled by specialized widgets and is different
than how you are used to. If you have a `TextField` or a `TextFormField`, you can supply a
[`TextEditingController`](https://docs.flutter.io/flutter/widgets/TextEditingController-class.html)
to retrieve user input:

<!-- skip -->
{% prettify dart %}
class _MyFormState extends State<MyForm> {
  // Create a text controller and use it to retrieve the current value.
  // of the TextField!
  final myController = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when disposing of the Widget.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Retrieve Text Input'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        // When the user presses the button, show an alert dialog with the
        // text the user has typed into our text field.
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context) {
              return new AlertDialog(
                // Retrieve the text the user has typed in using our
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

You can find more information and the full code listing in
[Retrieve the value of a text field](/cookbook/forms/retrieve-input/),
from the [Flutter Cookbook](https://flutter.io/cookbook/).

## What is the equivalent of a "Placeholder" on an Entry?

In Xamarin.Forms, some `Elements` support a `Placeholder` property, you would
assign a value to. e.g.

<!-- skip -->
{% prettify xml %}
  <Entry Placeholder="This is a hint">
{% endprettify %}

In Flutter, you can easily show a "hint" or a placeholder text for your input by
adding an InputDecoration object to the decoration constructor parameter for
the Text Widget.

<!-- skip -->
{% prettify dart %}
body: new Center(
  child: new TextField(
    decoration: new InputDecoration(hintText: "This is a hint"),
  )
)
{% endprettify %}

## How do I show validation errors?

With Xamarin.Forms, if you wished to provide a visual hint of a
validation error, you would need to create new properties and `VisualElement`s
surrounding the `Element`s that had validation errors.

In Flutter we pass through an InputDecoration object to the decoration
constructor for the Text widget.

However, you don't want to start off by showing an error.
Instead, when the user has entered invalid data,
update the state, and pass a new `InputDecoration` object.

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
  String _errorText;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
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

# Flutter plugins

# Interacting with hardware, third party services and the platform

## How do I interact with the platform, and with platform native code?

Flutter doesn't run code directly on the underlying platform; rather, the Dart code
that makes up a Flutter app is run natively on the device, "sidestepping" the SDK
provided by the platform. That means, for example, when you perform a network request
in Dart, it runs directly in the Dart context. You don't use the Android or iOS
APIs you normally take advantage of when writing native apps. Your Flutter
app is still hosted in a native app's `ViewController` or `Activity` as a view,
but you don't have direct access to this, or the native framework.

This doesn't mean Flutter apps cannot interact with those native APIs, or with any
native code you have. Flutter provides [platform channels](/platform-channels/),
that communicate and exchange data with the `ViewController` or `Activity` that
hosts your Flutter view. Platform channels are essentially an asynchronous messaging
mechanism that bridge the Dart code with the host `ViewController` or `Activity` and
the iOS or Android framework it runs on. You can use platform channels to execute a method on
the native side, or to retrieve some data from the device's sensors, for example.

In addition to directly using platform channels, you can use a variety of pre-made
[plugins](/using-packages/) that encapsulate the native and
Dart code for a specific goal. For example, you can use a plugin to access
the camera roll and the device camera directly from Flutter, without having to
write your own integration. Plugins are found [on Pub](https://pub.dartlang.org/),
Dart and Flutter's open source package repository. Some packages might
support native integrations on iOS, or Android, or both.

If you can't find a plugin on Pub that fits your needs, you can
[write your own](/developing-packages/)
and [publish it on Pub](/developing-packages/#publish).

## How do I access the GPS sensor?

Use the [`geolocator`](https://pub.dartlang.org/packages/geolocator) community plugin.

## How do I access the camera?

The [`image_picker`](https://pub.dartlang.org/packages/image_picker) plugin is popular
for accessing the camera.

## How do I log in with Facebook?

To Log in with Facebook, use the
[`flutter_facebook_login`](https://pub.dartlang.org/packages/flutter_facebook_login) community plugin.

## How do I use Firebase features?

Most Firebase functions are covered by
[first party plugins](https://pub.dartlang.org/flutter/packages?q=firebase).
These plugins are first-party integrations, maintained by the Flutter team:

 * [`firebase_admob`](https://pub.dartlang.org/packages/firebase_admob) for Firebase AdMob
 * [`firebase_analytics`](https://pub.dartlang.org/packages/firebase_analytics) for Firebase Analytics
 * [`firebase_auth`](https://pub.dartlang.org/packages/firebase_auth) for Firebase Auth
 * [`firebase_database`](https://pub.dartlang.org/packages/firebase_database) for Firebase RTDB
 * [`firebase_storage`](https://pub.dartlang.org/packages/firebase_storage) for Firebase Cloud Storage
 * [`firebase_messaging`](https://pub.dartlang.org/packages/firebase_messaging) for Firebase Messaging (FCM)
 * [`flutter_firebase_ui`](https://pub.dartlang.org/packages/flutter_firebase_ui) for quick Firebase Auth integrations (Facebook, Google, Twitter and email)
 * [`cloud_firestore`](https://pub.dartlang.org/packages/cloud_firestore) for Firebase Cloud Firestore

You can also find some third-party Firebase plugins on Pub that cover areas
not directly covered by the first-party plugins.

## How do I build my own custom native integrations?

If there is platform-specific functionality that Flutter or its community
Plugins are missing, you can build your own following the
[developing packages and plugins](/developing-packages/) page.

Flutter's plugin architecture, in a nutshell, is much like using an Event bus in
Android: you fire off a message and let the receiver process and emit a result
back to you. In this case, the receiver is code running on the native side
on Android or iOS.

# Themes (Styles)

## How do I theme my app?

Out of the box, Flutter comes with a beautiful implementation of Material
Design, which takes care of a lot of styling and theming needs that you would
typically do.

Xamarin.Forms does have a global `ResourceDictionary` where you can share styles
across your app. Alternatively there is Theme support currently in preview.

In Flutter you declare themes in the top level widget.

To take full advantage of Material Components in your app, you can declare a top
level widget `MaterialApp` as the entry point to your application. MaterialApp
is a convenience widget that wraps a number of widgets that are commonly
required for applications implementing Material Design. It builds upon a WidgetsApp by
adding Material specific functionality.

You can also use a `WidgetApp` as your app widget, which provides some of the
same functionality, but is not as rich as `MaterialApp`.

To customize the colors and styles of any child components, pass a
`ThemeData` object to the `MaterialApp` widget. For example, in the code below,
the primary swatch is set to blue and text selection color is red.

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

# Databases and local storage

## How do I access Shared Preferences or UserDefaults?

Xamarin.Forms developers will likely be familar with the `Xam.Plugins.Settings` plugin.

In Flutter, access equivalent functionality using the
[Shared Preferences plugin](https://pub.dartlang.org/packages/shared_preferences).
This plugin wraps the functionality of both `UserDefaults` and the Android
equivalent, `SharedPreferences`.

## How do I access SQLite in Flutter?

In Xamarin.Forms most applications would use the `sqlite-net-pcl` plugin to access
SQLite databases.

In Flutter, access this functionality using the
[SQFlite](https://pub.dartlang.org/packages/sqflite) plugin.

# Notifications

## How do I set up push notifications?

In Android, you use Firebase Cloud Messaging to setup push
notifications for your app.

In Flutter, access this functionality using the
[Firebase_Messaging](https://github.com/flutter/plugins/tree/master/packages/firebase_messaging)
plugin.
For more information on using the Firebase Cloud Messaging API, see the
[`firebase_messaging`](https://pub.dartlang.org/packages/firebase_messaging)
plugin documentation.
