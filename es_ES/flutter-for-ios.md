---
layout: page
title: Flutter para desarrolladores iOS
permalink: /flutter-for-ios/
---

Este documento es para desarrolladores en iOS que buscan aplicar su conocimiento existente sobre iOS para construir aplicaciones móviles con Flutter. Si entiendes los fundamentos del framework de trabajo de iOS, entonces puedes usar este documento como una forma de empezar a aprender a desarrollar con Flutter.

Tus conocimientos y habilidades sobre iOS son muy valiosos cuando construyes con
Flutter, porque Flutter se apoya en el sistema operativo móvil para numerosas
capacidades y configuraciones. Flutter es una nueva forma de crear interfaces de usuario para móviles,
pero tiene un sistema de plugin para comunicarse con (iOS y Android) para tareas que no sean de interfaz de usuario. Si eres un experto en desarrollo iOS, no tienes que volver a aprenderlo todo
para usar Flutter.

Este documento puede ser utilizado como un cookbook, puedes saltar entre sus secciones y encontrar las preguntas que son más relevantes a tus necesidades.

* TOC Placeholder
{:toc}

# Vistas

## ¿Cuál es el equivalente a un `UIView` en Flutter?

En iOS, la mayor parte de lo que se crea en la interfaz de usuario se hace utilizando objetos de vista, que son
de la clase  `UIView`. Estos pueden actuar como contenedores para otras `UIView`, que forman tu layout.

En Flutter, el equivalente aproximado a un `UIView` es un `Widget`. Los Widgets no se asimilan exactamente a las vistas de iOS, pero mientras te familiarizas con el funcionamiento de Flutter
puedes pensar en ellos como "la forma en que declaras y construyes la interfaz de usuario".

Sin embargo, estos tienen algunas diferencias con un `UIView`. Para empezar, los widgets tienen diferentes vidas útiles: son inmutables y sólo existen hasta que necesitan ser cambiados. 
Cada vez que los widgets o su estado cambian, el framework de Flutter crea
un nuevo árbol de instancias de widgets. En comparación, una vista iOS no se recrea cuando
cambia, sino que es una entidad mutable que se dibuja una vez y no lo hace
redibujar hasta que se invalide usando `setNeedsDisplay()`.

Además, a diferencia de `UIView`, los widgets de Flutter son ligeros, en parte debido
a su inmutabilidad. Porque no son puntos de vista en sí mismos, y no están dibujando nada directamente, sino que son una descripción de la UI y su semántica que se "inflan" en objetos de vistas reales.

Flutter incluye la librería [Material Components](https://material.io/develop/flutter/). Estos son los widgets que implementan las [Material Design guidelines](https://material.io/design/). El diseño de Material Design es un sistema de diseño flexible [optimizado para todas las plataformas](https://material.io/design/platform-guidance/cross-platform-adaptation.html#cross-platform-guidelines),
incluyendo iOS.

Pero Flutter es lo suficientemente flexible y expresivo como para implementar cualquier lenguaje de diseño.
En iOS, puedes utilizar los [Cupertino widgets](https://flutter.io/widgets/cupertino/)
para producir una interfaz que se parezca al
[Lenguaje de diseño iOS de Apple](https://developer.apple.com/design/resources/).

## ¿Cómo actualizo `Widgets`?

Para actualizar tus vistas en iOS, los transformas directamente. En Flutter, los widgets son
inmutables y no actualizables directamente. En su lugar, tienes que manipular el
estado del widget.

Aquí es donde el concepto de los widgets Stateful vs Stateless
entra en escena. Un `StatelessWidget` es justo lo que suena como un widget sin
estado adjunto.

Los `StatelessWidgets` son útiles cuando la parte de la interfaz de usuario que usted está
describiendo no depende de nada más que de la configuración inicial
información en el widget.

Por ejemplo, en iOS, esto es similar a colocar un `UIImageView` con
su logo como la `image`. Si el logotipo no cambia durante el tiempo de ejecución,
usa un `StatelessWidget` en Flutter.

Si deseas cambiar dinámicamente la interfaz de usuario basándose en los datos recibidos después de hacer una
llamada HTTP, utiliza un `StatefulWidget`. Después de que la llamada HTTP se haya
completado, avisa al framework de Flutter que el `State` del widget ha sido 
actualizado, para que pueda actualizar la interfaz de usuario.

La diferencia importante entre stateless y stateful widgets es que `StatefulWidget`s tiene un objeto `State` que almacena el estado de los datos y los transporta a través de los rebuilds del árbol de widgets, para que no se pierdan.

Si tienes dudas, recuerda esta regla: si un widget cambia fuera de
el método `build` (debido a las interacciones de los usuarios en tiempo de ejecución, por ejemplo), es stateful.
Si el widget nunca cambia, una vez construido, es stateless.
Sin embargo, y los transporta a través de los rebuilds del árbol de widgets, para que no se pierdan puede
ser stateless si no está reaccionando a esos cambios (u otras entradas).

El siguiente ejemplo muestra cómo usar un `StatelessWidget`. Un
`StatelessWidget` común es el widget `Text`. Si nos fijamos en la implementación de
el widget `Text` encontrarás que es una subclase de `StatelessWidget`.

<!-- skip -->
{% prettify dart %}
Text(
  'Me gusta Flutter!',
  style: TextStyle(fontWeight: FontWeight.bold),
);
{% endprettify %}

Si miras el código de arriba, puedes notar que el widget `Text`
no lleva ningún estado explícito. Hace lo que se pasa en su
constructores y nada más.

Pero, ¿qué pasa si quieres hacer que “Me gusta Flutter!“ cambie dinámicamente, por ejemplo
al hacer clic en un `FloatingActionButton` ?

Para lograr esto, coloca el `Text` widget en un `StatefulWidget` y actualizarlo cuando el usuario haga clic en el botón.

Por ejemplo:

<!-- skip -->
{% prettify dart %}
class SampleApp extends StatelessWidget {
  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación de ejemplo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  // Texto por defecto
  String textToShow = "Me Gusta Flutter";
  void _updateText() {
    setState(() {
      // actualiza el texto
      textToShow = "Flutter es Impresionante!";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aplicación de ejemplo"),
      ),
      body: Center(child: Text(textToShow)),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'Actualizar texto',
        child: Icon(Icons.update),
      ),
    );
  }
}
{% endprettify %}

## ¿Cómo diseño mis widgets? ¿Dónde está mi Storyboard?

En iOS, puede utilizar un archivo de Storyboard para organizar sus viewcontrollers y establecer
restricciones, o puede establecer sus restricciones programáticamente en su vista
controladores. En Flutter, declara tu layout en código componiendo
un árbol de widgets.

El siguiente ejemplo enseña como mostrar un widget simple con padding:

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Aplicación de ejemplo"),
    ),
    body: Center(
      child: CupertinoButton(
        onPressed: () {
          setState(() { _pressedCount += 1; });
        },
        child: Text('Hola'),
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
      ),
    ),
  );
}
{% endprettify %}

Puedes añadir padding a cualquier widget, lo que imita la restricciones
en iOS.

Puedes ver los layouts que Flutter te ofrece en la sección [catálogo de widgets](/widgets/layout/).

## ¿Cómo agrego o elimino un componente de mi layout?

En iOS, se llama `addSubview()` como los widgets son inmutables, no hay `removeFromSuperview()`
en una vista secundaria para añadir o eliminar dinámicamente vistas secundarias. En Flutter, porque
son inmutables no hay equivalente directo a `addSubview()`.
En su lugar, puede pasar una función al padre que devuelva un widget, y
controlar la creación de ese hijo con una etiqueta booleana.

El siguiente ejemplo muestra cómo alternar entre dos widgets cuando el usuario hace clic en
el `FloatingActionButton`:

<!-- skip -->
{% prettify dart %}
class SampleApp extends StatelessWidget {
  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación de ejemplo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
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
      return Text('Toggle One');
    } else {
      return CupertinoButton(
        onPressed: () {},
        child: Text('Toggle Two'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aplicación de ejemplo"),
      ),
      body: Center(
        child: _getToggleChild(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggle,
        tooltip: 'Texto actualizado',
        child: Icon(Icons.update),
      ),
    );
  }
}
{% endprettify %}

## ¿Cómo puedo animar un Widget?

En iOS, creas una animación llamando al método
`animate(withDuration:animations:)` en una vista. En Flutter,
usa la biblioteca de animación para incluir widgets dentro de un widget animado.

En Flutter, usa un `AnimationController` y `Animation<double>`
que puede pausar, buscar, detener e invertir la animación. Requiere un `Ticker`
que señala cuando ocurre la sincronización y produce una interpolación lineal entre
0 y 1 en cada fotograma mientras está en marcha. A continuación, crea una o más
`Animations` y adjúntalas al controlador.

Por ejemplo, puede usar `CurvedAnimation` para implementar una animación
a lo largo de una curva interpolada. En este sentido, el controlador
es la fuente "maestra" del progreso de la animación y la  `CurvedAnimation`
calcula la curva que reemplaza el movimiento lineal predeterminado del controlador.
Al igual que los widgets, las animaciones en Flutter trabajan con la composición.

Cuando construyas el árbol de widgets, asigna la `Animation` a una propiedad animada
de un widget, como la opacidad de una `FadeTransition`, y dile al controlador que inicie la animación

El siguiente ejemplo muestra cómo escribir un `FadeTransition` que desvanece el widget
en un logotipo al pulsar el botón `FloatingActionButton`:

<!-- skip -->
{% prettify dart %}
class SampleApp extends StatelessWidget {
  // Este widget es la raíz de tu aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fade Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyFadeTest(title: 'Fade Demo'),
    );
  }
}

class MyFadeTest extends StatefulWidget {
  MyFadeTest({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyFadeTest createState() => _MyFadeTest();
}

class _MyFadeTest extends State<MyFadeTest> with TickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation curve;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: FadeTransition(
            opacity: curve,
            child: FlutterLogo(
              size: 100.0,
            )
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Fade',
        child: Icon(Icons.brush),
        onPressed: () {
          controller.forward();
        },
      ),
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }
}
{% endprettify %}

Para más información, mira
[Widgets de animación y movimiento](/widgets/animation/),
el [Tutorial de animaciones](/tutorials/animation),
y el [Visión general](/animations/).

## ¿Cómo puedo dibujar en la pantalla?

En iOS, utilizas  `CoreGraphics` para dibujar líneas y formas en la
pantalla. Flutter tiene una API diferente basada en la clase  `Canvas` con dos
otras clases que te ayudan a dibujar: `CustomPaint` y `CustomPainter`, el último de estos implementa su algoritmo para dibujar al canvas.

Para aprender cómo implementar un pintor de firmas en Flutter, vea la respuesta de Collin 
en [StackOverflow](https://stackoverflow.com/questions/46241071/create-signature-area-for-mobile-app-in-dart-flutter).

<!-- skip -->
{% prettify dart %}
class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);

  final List<Offset> points;

  void paint(Canvas canvas, Size size) {
    var paint = Paint()
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

class Signature extends StatefulWidget {
  SignatureState createState() => SignatureState();
}

class SignatureState extends State<Signature> {

  List<Offset> _points = <Offset>[];

  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          RenderBox referenceBox = context.findRenderObject();
          Offset localPosition =
          referenceBox.globalToLocal(details.globalPosition);
          _points = List.from(_points)..add(localPosition);
        });
      },
      onPanEnd: (DragEndDetails details) => _points.add(null),
      child: CustomPaint(painter: SignaturePainter(_points), size: Size.infinite),
    );
  }
}
{% endprettify %}

## ¿Dónde está la opacidad del widget?

En iOS, todo tiene .opacidad o .alpha. En Flutter, la mayor parte del tiempo necesitas
envolver un widget en un widget de Opacidad para lograr esto.

## ¿Cómo construyo widgets personalizados?

En iOS, normalmente se crea una subclase de `UIView`, o se utiliza una vista preexistente, para sobrescribir e implementar métodos que logren el comportamiento deseado. En
En Flutter, construye un widget personalizado mediante
[composición](/technical-overview/#everythings-a-widget) widgets más pequeños
(en lugar de extenderlos).

Por ejemplo, ¿cómo se construye un `CustomButton` que tome una etiqueta en
el constructor? Cree un botón personalizado que componga un `RaisedButton` con una etiqueta,
en lugar de extender `RaisedButton`:

<!-- skip -->
{% prettify dart %}
class CustomButton extends StatelessWidget {
  final String label;

  CustomButton(this.label);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(onPressed: () {}, child: Text(label));
  }
}
{% endprettify %}

Entonces utiliza `CustomButton`, tal y como lo harías con cualquier otro widget de Flutter:

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return Center(
    child: CustomButton("Hello"),
  );
}
{% endprettify %}

# Navegación

## ¿Cómo desplazarse entre páginas?

En iOS, para desplazarse entre la pila de viewcontrollers, puedes utilizar el botón
`UINavigationController` que gestiona la pila de controladores de vista para
mostrar en la pantalla.

Flutter tiene una implementación similar, usando `Navigator` y
"Routes". Un `Route` es una abstracción para una "pantalla" o "página" de una aplicación, y
un `Navegador` es un [widget](technical-overview/#everythings-a-widget)
que gestiona las rutas. Una se asimila aproximadamente a un
`UIViewController`. El navigator funciona de forma similar al iOS
`UINavigationController`, puedes hacer push `push()` y `pop()` dependiendo de que quieras navegar hacia, o volver desde, una vista.

Para navegar entre páginas, tiene un par de opciones:

* Especifique un `Map` de nombres de ruta. (MaterialApp)
* Navegar directamente a una ruta. (WidgetApp)

El siguiente ejemplo construye un Map.

<!-- skip -->
{% prettify dart %}
void main() {
  runApp(MaterialApp(
    home: MyAppHome(), // se convierte en la ruta nombrada '/'
    routes: <String, WidgetBuilder> {
      '/a': (BuildContext context) => MyPage(title: 'page A'),
      '/b': (BuildContext context) => MyPage(title: 'page B'),
      '/c': (BuildContext context) => MyPage(title: 'page C'),
    },
  ));
}
{% endprettify %}

Navega hasta una route haciendo `push` por su nombre en el `Navigator`.

<!-- skip -->
{% prettify dart %}
Navigator.of(context).pushNamed('/b');
{% endprettify %}

La clase `Navigator` maneja enrutamiento en Flutter y se utiliza para obtener una respuesta de vuelta desde una ruta que has añadido a la pila. Esto se hace usando
`await` en el `Future` devuelto por `push()`.

Por ejemplo, para iniciar una ruta 'location' que permita al usuario seleccionar su
localización, podrías hacer lo siguiente:

<!-- skip -->
{% prettify dart %}
Map coordinates = await Navigator.of(context).pushNamed('/location');
{% endprettify %}

Y luego, dentro de tu ruta de 'location', una vez que el usuario haya seleccionado su
localización, haces `pop()` en pila con la respuesta:

<!-- skip -->
{% prettify dart %}
Navigator.of(context).pop({"lat":43.821757,"long":-79.226392});
{% endprettify %}

## ¿Cómo puedo navegar a otra aplicación?

En iOS, para enviar al usuario a otra aplicación, utilizas un esquema de URL específico. Para las aplicaciones a nivel de sistema, el esquema
depende de la aplicación. Para implementar esta funcionalidad en Flutter,
crear una integración de plataforma nativa, o utiliza un plugin existente, como es url_launcher
[plugin](#plugins), tales como [`url_launcher`](https://pub.dartlang.org/packages/url_launcher).

## ¿Cómo puedo volver al al viewcontroller nativo de iOS?

LLamando a `SystemNavigator.pop()` desde su código Dart invoca la opción
siguiendo el código iOS:

```
UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    [((UINavigationController*)viewController) popViewControllerAnimated:NO];
  }
```

Si eso no hace lo que quieres, puedes crear tu propio  
[plarform channel](/platform-channels/) para invocar código iOS arbitrario.

# ¿Hilos o Asincronicidad?

## ¿Cómo se puede escribir código asíncrono?

Dart tiene un modelo de ejecución de un solo hilo, con soporte para `Isolate`s (una forma de
para ejecutar código Dart en otro hilo), un event loop y programación asíncrona.
A menos que generes un `Isolate`, su código Dart se ejecuta en el hilo principal de la interfaz de usuario y es
conducido por un un event loop. El un event loop del flutter es equivalente al iOS main loop, es decir, the `Looper` que está conectado al hilo principal.

El modelo de un solo hilo de Dart no significa que requieras ejecutar todo como una operación bloqueante que cause que la UI se congele. En vez de eso,
usa las facilidades asincrónicas que proporciona el lenguaje Dart, tales como
`async`/`await`, para realizar trabajos asincrónicos.

Por ejemplo, puedes ejecutar código de red sin que la interfaz de usuario se bloquee utilizando
`async`/`await` y dejar que Dart haga el trabajo pesado:

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

Una vez que la llamada de red que estamos esperando con `await`, se completa, actualiza el UI llamando a `setState()`, que desencadena un rebuild del widget y actualiza los datos.

El siguiente ejemplo carga datos de forma asincrónica y los visualiza en un `ListView`:

<!-- skip -->
{% prettify dart %}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
      ),
      body: ListView.builder(
          itemCount: widgets.length,
          itemBuilder: (BuildContext context, int position) {
            return getRow(position);
          }));
  }

  Widget getRow(int i) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text("Row ${widgets[i]["title"]}")
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

Consulte la siguiente sección para obtener más información sobre cómo realizar el trabajo en en segundo plano y como Flutter difiere de iOS.

## ¿Cómo se mueve el trabajo a un hilo en segundo plano?

Ya que Flutter tiene un solo hilo y ejecuta un event loop (como Node.js), no tienes que preocuparte del manejo de hilos o por generar hilos en segundo plano. Si estás realizando un trabajo de E/S, como acceso al disco o una llamada de red, entonces puedes usar con seguridad `async`/`await` y estás listo. Si, por otro lado
necesita hacer un trabajo intensivo de computación que mantenga ocupada a la CPU,
quieres moverlo a un `Isolate` para evitar bloquear el event loop.

Para el trabajo de E/S, declare la función como `async`,
y usa `await` en tareas de larga duración dentro de la función:

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

Así es como normalmente se realizan las llamadas a la red o a la base de datos, que son ambas
Operaciones de E/S.

Sin embargo, hay ocasiones en las que puede estar procesando una gran cantidad de datos y
tu UI se cuelga. En Flutter, utiliza `Isolates` Isolates para aprovechar CPUs de múltiples núcleos para realizar tareas de larga duración o que requieren un gran trabajo de computación.

Los Isolates son hilos de ejecución separados que no comparten ninguna memoria
con el main execution memory heap. Esto significa que no se puede acceder a las varables del hilo principal, o actualizar tu UI llamando a `setState()`. Los Isolates son fieles a
su nombre y no pueden compartir memoria (en forma de campos estáticos, por ejemplo).

El siguiente ejemplo muestra, en un Isolate simple, cómo compartir datos de nuevo a
el hilo principal para actualizar la interfaz de usuario.

<!-- skip -->
{% prettify dart %}
loadData() async {
  ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(dataLoader, receivePort.sendPort);

  // El 'echo' isolate envía su SendPort como primer mensaje
  SendPort sendPort = await receivePort.first;

  List msg = await sendReceive(sendPort, "https://jsonplaceholder.typicode.com/posts");

  setState(() {
    widgets = msg;
  });
}

// El punto de entrada para el aislamiento
static dataLoader(SendPort sendPort) async {
  // Para los mensajes entrantes, abra el ReceivePort.
  ReceivePort port = ReceivePort();

  // Notifique a cualquier otro aislamiento a qué puerto escucha este aislamiento.
  sendPort.send(port.sendPort);

  await for (var msg in port) {
    String data = msg[0];
    SendPort replyTo = msg[1];

    String dataURL = data;
    http.Response response = await http.get(dataURL);
    // Muchisimos JSON para analizar
    replyTo.send(json.decode(response.body));
  }
}

Future sendReceive(SendPort port, msg) {
  ReceivePort response = ReceivePort();
  port.send([msg, response.sendPort]);
  return response.first;
}
{% endprettify %}

Aquí, `dataLoader()` es el `Isolate` que corre en su propio hilo de ejecución separado.
En el aislamiento se puede realizar procesamientos más intensivos de CPU (analizando un archivo grande formato JSON, por ejemplo), o realizar cálculos matemáticos intensivos en computación, como encriptación o procesamiento de señales.

Puede ejecutar el ejemplo completo a continuación:

{% prettify dart %}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:isolate';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
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
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sample App"),
        ),
        body: getBody());
  }

  ListView getListView() => ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      });

  Widget getRow(int i) {
    return Padding(padding: EdgeInsets.all(10.0), child: Text("Row ${widgets[i]["title"]}"));
  }

  loadData() async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    // El 'echo' isolate envía su SendPort como primer mensaje
    SendPort sendPort = await receivePort.first;

    List msg = await sendReceive(sendPort, "https://jsonplaceholder.typicode.com/posts");

    setState(() {
      widgets = msg;
    });
  }

// El punto de entrada para el isolate
  static dataLoader(SendPort sendPort) async {
    // Para los mensajes entrantes, abra el ReceivePort.
    ReceivePort port = ReceivePort();

    // Notifique a cualquier otro isolate a qué puerto escucha este isolate.
    sendPort.send(port.sendPort);

    await for (var msg in port) {
      String data = msg[0];
      SendPort replyTo = msg[1];

      String dataURL = data;
      http.Response response = await http.get(dataURL);
      // Lotes de JSON para analizar
      replyTo.send(json.decode(response.body));
    }
  }

  Future sendReceive(SendPort port, msg) {
    ReceivePort response = ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }
}
{% endprettify %}

## Cómo puedo hacer peticiones de red?

Realizar una petición de red en Flutter es fácil cuando se utiliza el popular
[`paquete` http](https://pub.dartlang.org/packages/http). Este abstrae una gran parte del trabajo de red que normalmente podría implementar tu mismo,
lo que simplifica la realización de peticiones de red.

Para utilizar el paquete `http`, añádelo a tus depedendencias en `pubspec.yaml`:

<!-- skip -->
{% prettify yaml %}
dependencies:
  ...
  http: ^0.11.3+16
{% endprettify %}

Para realizar una llamada de red, llame `await` en la función `async`  `http.get()`:

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

En iOS, normalmente utilizas un `UIProgressView` durante la ejecución de
una larga tarea en segundo plano.

En Flutter, usa un `ProgressIndicator` widget.
Muestra el progreso programáticamente controlando cuándo se renderiza
a través de una señal booleana. Dile a Flutter que actualice este estado antes de comenzar la tarea de larga duración, y ocúltalo después de que acabe.

En el siguiente ejemplo, la función de build se divide en tres funciones 
diferentes. Si `showLoadingDialog()` es `true` (cuándo `widgets.length == 0`),
entonces renderizamos el `ProgressIndicator`. De lo contrario, renderizar el
`ListView` con los datos devueltos de una llamada de red.

<!-- skip -->
{% prettify dart %}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
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
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sample App"),
        ),
        body: getBody());
  }

  ListView getListView() => ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      });

  Widget getRow(int i) {
    return Padding(padding: EdgeInsets.all(10.0), child: Text("Row ${widgets[i]["title"]}"));
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

# Estructura del proyecto, localización, dependencias y assets del proyecto

## ¿Cómo puedo incluir assets de imagen para Flutter? ¿Qué pasa con las resoluciones múltiples?

Mientras que iOS trata las imágenes y los assets como elementos distintos, las aplicaciones Flutter sólo tienen
assets. Los recursos que se colocan en el `Images.xcasset` en la carpeta iOS,
se colocan en una carpeta de assets para Flutter.
Al igual que con iOS, los assets son cualquier tipo de archivo, no sólo imágenes.
Por ejemplo, puede tener un archivo JSON ubicado en el directorio `my-assets`:

```
my-assets/data.json
```

Declare el asset en el archivo `pubspec.yaml`:

<!-- skip -->
{% prettify yaml %}
assets:
 - my-assets/data.json
{% endprettify %}

Y luego acceder a él desde el código usando un
[`AssetBundle`](https://docs.flutter.io/flutter/services/AssetBundle-class.html):

<!-- skip -->
{% prettify dart %}
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('my-assets/data.json');
}
{% endprettify %}

Para las imágenes, Flutter sigue un formato simple basado en la densidad como iOS.  Assets de imagen 
podrían ser `1.0x`, `2.0x`, `3.0x`, o cualquier otro multiplicador. El denominado
[`devicePixelRatio`](https://docs.flutter.io/flutter/dart-ui/Window/devicePixelRatio.html)
expresa la proporción de píxeles físicos en un solo píxel lógico.

Los assets se encuentran en cualquier carpeta arbitraria; Flutter no tiene
estructura de carpetas predefinida. Declara los assets (con localización) en el archivo, `pubspec.yaml` y Flutter los detecta.

Por ejemplo, para añadir una imagen llamada `my_icon.png` a tu proyecto Flutter, podrías decidir almacenarlo en una carpeta que se llama de forma arbitraria `images`.
Coloque la imagen base (1.0x) en la carpeta, `images` y las otras variantes en subcarpetas nombradas según el multiplicador de proporción apropiado:

```
images/my_icon.png       // Base: 1.0x image
images/2.0x/my_icon.png  // 2.0x image
images/3.0x/my_icon.png  // 3.0x image
```

A continuación, declare estas imágenes en el archivo `pubspec.yaml` :

<!-- skip -->
{% prettify yaml %}
assets:
 - images/my_icon.jpeg
{% endprettify %}

Ya puede acceder a tus imágenes usando `AssetImage`:

<!-- skip -->
{% prettify dart %}
return AssetImage("images/a_dot_burr.jpeg");
{% endprettify %}

o directamente en un `Image` widget:

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return Image.asset("images/my_image.png");
}
{% endprettify %}

Para más detalles, mira
[Añadiendo Assets e Imágenes en Flutter](/assets-and-images).

## ¿Dónde guardo las cadenas? ¿Cómo gestiono la localización?

A diferencia de iOS, que tiene el archivo `Localizable.strings`, Flutter no tiene actualmente un sistema dedicado para manejar cadenas. Por el momento, la mejor práctica es declarar una copia de su texto en una clase como campos estáticos y acceder a ellos desde allí. Por ejemplo:

<!-- skip -->
{% prettify dart %}
class Strings {
  static String welcomeMessage = "Welcome To Flutter";
}
{% endprettify %}

Puedes acceder a tus cadenas como tal:

<!-- skip -->
{% prettify dart %}
Text(Strings.welcomeMessage)
{% endprettify %}

Por defecto, Flutter sólo es compatible con el inglés de EE.UU. para sus cadenas. Si necesita añadir soporte para otros idiomas, incluya el paquete `flutter_localizations`. 
Puede que también necesites añadir el paquete Dart [`intl`](https://pub.dartlang.org/packages/intl)
para usar el mecanismo i10n, búsqueda como formateo de fecha y hora.

<!-- skip -->
{% prettify yaml %}
dependencies:
  # ...
  flutter_localizations:
    sdk: flutter
  intl: "^0.15.6"
{% endprettify %}

Para usar el paquete `flutter_localizations` ,
especifica `localizationsDelegates` y `supportedLocales` en el widget de la aplicación:

<!-- skip -->
{% prettify dart %}
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
 localizationsDelegates: [
   // Agregue aquí los delegados de localización específicos de la aplicación
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

Los delegados contienen los valores actuales localizados, mientras que la opción `supportedLocales`
define qué localizaciones soporta la aplicación. El ejemplo anterior utiliza un `MaterialApp`,
por lo que tiene tanto una `GlobalWidgetsLocalizations` para los valores localizados de los widgets base, y una `MaterialWidgetsLocalizations` para las localizaciones de los widgets de Material. Si utiliza `WidgetsApp` para tu aplicación, no necesitas lo último. Nota que estos dos delegados contienen "valores predeterminados", pero tendrá que proporcionar uno o más delegados para la copia localizable de su propia aplicación, si desea que también se localicen.

Cuando se inicializa, el `WidgetsApp` (o `MaterialApp`) crea un widget
[`Localizations`](https://docs.flutter.io/flutter/widgets/Localizations-class.html)
para ti, con los delegados que especifique.
La localización actual del dispositivo es siempre accesible desde el widget `Localizations`
del contexto actual (en forma de un objecto `Locale`), o utilizando el
[`Window.locale`](https://docs.flutter.io/flutter/dart-ui/Window/locale.html).

Para acceder a recursos localizados, utiliza el método `Localizations.of()` para acceder a una clase de localización específica proporcionada por un delegado determinado.
Utiliza el paquete [`intl_translation`](https://pub.dartlang.org/packages/intl_translation)
para
extraer una copia traducible a archivos
[arb](https://code.google.com/p/arb/wiki/ApplicationResourceBundleSpecification)
para traducir, e importarlos de nuevo a la aplicación para usarlos con `intl`.

Para más detalles sobre la internacionalización y localización en Flutter, consulte la sección
[guía de internacionalización](/tutorials/internationalization),
que tiene código de muestra con y sin el paquete `intl`.

Fíjate que antes de Flutter 1.0 beta 2, los assets en Flutter no eran accesibles desde el lado nativo, y viceversa, los assets y recursos nativos no estaban disponibles para Flutter, ya que vivían en carpetas separadas.

## ¿Cuál es el equivalente de Cocoapods? ¿Cómo puedo añadir dependencias?

En iOS, añades dependencias añadiendo a tu `Podfile`. Flutter usa el sistema de compilado de Dart y el administrador de paquetes de Pub para manejar dependencias. Las herramientas delegan la compilación de las envolturas de apps nativas Android e iOS a su sistema de compilado correspondiente.

Si bien hay un Podfile en la carpeta iOS en su proyecto Flutter, úselo solo si estas añadiendo dependencias nativas que necesitas para la integración por plataforma. En general, usa `pubspec.yaml` para declarar dependencias externas en Flutter. Un buen lugar para encontrar buenos paquetes para Flutter es
[Pub](https://pub.dartlang.org/flutter/packages/).

# ViewControllers

## ¿Cual es el equivalente a un ViewController en Flutter?

En iOS, un `ViewController` representa una porción de la interfaz de usuario, usado mayormente para una pantalla o sección. Estos se componen juntos para construir interfaces de usuario complejas y ayuda a escalar la interfaz de usuario de su aplicación. En Flutter,este trabajo recae en los Widgets. Como se mencionó en la sección Navegación, las pantallas de Flutter están representadas por Widgets ya que "todo es un widget!" Utilice un `Navigator` para moverse entre diferentes `Route`s que representan diferentes pantallas o páginas, o tal vez diferentes estados o representaciones de los mismos datos.

## ¿Cómo escuchar los eventos del ciclo de vida de iOS?

En iOS, puedes sobrescribir métodos del `ViewController` para capturar métodos del ciclo de vida para la propia vista, o registrar lifecycle callbacks `AppDelegate`. En Flutter no tienes ninguno de los dos conceptos, pero en cambio puedes escuchar los eventos del ciclo de vida conectándote al observador `WidgetsBinding` y escuchando el evento de cambio `didChangeAppLifecycleState()`.

Los eventos observables del ciclo de vida son:

* `inactive` — La aplicación se encuentra en un estado inactivo y no está recibiendo la entrada del usuario. Este evento sólo funciona en iOS, ya que no hay ningún evento equivalente en Android.
* `paused` — La aplicación no es actualmente visible para
el usuario, no responde a las entradas del usuario, pero se ejecuta en segundo plano.
* `resumed` — La aplicación es visible y responde a las entradas del usuario.
* `suspending` — La aplicación se suspende momentáneamente. La plataforma iOS no tiene un evento equivalente.

Para más detalles sobre el significado de estos estados, véase
[`AppLifecycleStatus` documentación](https://docs.flutter.io/flutter/dart-ui
/AppLifecycleState-class.html).

# Layouts

## ¿Cuál es el equivalente de un `UITableView` o `UICollectionView` en Flutter?

En iOS, puede mostrar una lista en una de las dos opciones siguientes `UITableView` o un
`UICollectionView`. En Flutter, tiene una implementación similar utilizando un 
`ListView`.
En iOS, estas vistas tienen métodos delegados para decidir el número de filas, la celda para cada ruta de índice y el tamaño de las celdas.

Debido al patrón inmutable de widgets de Flutter, pasas una lista de widgets a tu `ListView`, y Flutter se encarga de asegurarse de que el desplazamiento sea rápido y suave.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación de ejemplo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
      ),
      body: ListView(children: _getListData()),
    );
  }

  _getListData() {
    List<Widget> widgets = [];
    for (int i = 0; i < 100; i++) {
      widgets.add(Padding(padding: EdgeInsets.all(10.0), child: Text("Row $i")));
    }
    return widgets;
  }
}
{% endprettify %}

## ¿Cómo sé en qué elemento de la lista se ha hecho clic?

En iOS, se implementa el método de delegado, `tableView:didSelectRowAtIndexPath:`.
En Flutter, utiliza el manejo táctil proporcionado por los widgets pasados.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
      ),
      body: ListView(children: _getListData()),
    );
  }

  _getListData() {
    List<Widget> widgets = [];
    for (int i = 0; i < 100; i++) {
      widgets.add(GestureDetector(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Row $i"),
        ),
        onTap: () {
          print('row tapped');
        },
      ));
    }
    return widgets;
  }
}
{% endprettify %}

## ¿Cómo puedo actualizar dinámicamente un `ListView`?

En iOS, se actualizan los datos para la vista de lista y se notifica a la vista de tabla o de colección mediante la utilización del método `reloadData`.

En Flutter, si tu actualizas dentro `setState()`,
se puede ver rápidamente que sus datos no cambian visualmente.
Esto se debe a que cuando `setState()` se llama, el motor de renderizado de Flutter mira el árbol de widgets para ver si algo ha cambiado. Cuando llegue a tu
`ListView`, realiza una comprobación `==`, y determina que los dos `ListViews`
son el mismo. Nada ha cambiado, por lo que no se requiere ninguna actualización.

Para una forma sencilla de actualizar tu `ListView`, crea una nueva `List` dentro de
`setState()`, y copia los datos de la lista antigua a la nueva lista.
Aunque este enfoque es simple, no se recomienda para conjuntos de datos grandes, como se muestra en el siguiente ejemplo.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
      ),
      body: ListView(children: widgets),
    );
  }

  Widget getRow(int i) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text("Row $i"),
      ),
      onTap: () {
        setState(() {
          widgets = List.from(widgets);
          widgets.add(getRow(widgets.length + 1));
          print('row $i');
        });
      },
    );
  }
}
{% endprettify %}

La manera recomendada, eficiente y efectiva de construir una lista es usando un
`ListView.Builder`. Este método es excelente cuando se tiene una lista dinámica o una lista con grandes cantidades de datos.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
      ),
      body: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (BuildContext context, int position) {
          return getRow(position);
        },
      ),
    );
  }

  Widget getRow(int i) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text("Row $i"),
      ),
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

En lugar de crear un "ListView", crea un `ListView.builder` que toma dos parámetros clave: la longitud inicial de la lista y una función. `ItemBuilder`.
La función `ItemBuilder` es similar al método delegado `cellForItemAt`
en una vista de tabla o colección de iOS, ya que toma una posición, y devuelve la celda
que quieres que se renderice en esa posición.

Finalmente, pero lo más importante, note que la función `onTap()`
ya no recrea la lista, sino que en vez de eso la agrega `.add`.

## ¿Cuál es el equivalente de un `ScrollView` en Flutter?

En iOS, las vistas se envuelven en un `ScrollView` que permite al usuario desplazarse por el contenido si es necesario.

En Flutter la forma más fácil de hacerlo es usando el widget `ListView`. Esto actúa como un `ScrollView` como un `TableView` de iOS, y puedes hacer un layout de widgets en formato vertical.

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return ListView(
    children: <Widget>[
      Text('Row One'),
      Text('Row Two'),
      Text('Row Three'),
      Text('Row Four'),
    ],
  );
}
{% endprettify %}

Para documentos más detallados sobre cómo diseñar widgets en Flutter,
ver el [layout tutorial](/widgets/layout/).

# Detección de gestos y manejo de eventos táctiles

## ¿Cómo puedo añadir un click listener a un widget en Flutter?

En iOS, se adjunta un `GestureRecognizer` a una vista para gestionar eventos de clic. En Flutter, hay dos maneras de añadir touch listeners.:

 1. Si el widget soporta la detección de eventos, pásale una función y gestiona el evento en la función. Por ejemplo, el widget `RaisedButton` tiene un parámetro `onPressed`:

    <!-- skip -->
    ```dart
    @override
    Widget build(BuildContext context) {
      return RaisedButton(
        onPressed: () {
          print("click");
        },
        child: Text("Button"),
      );
    }
    ```

 2. Si el Widget no soporta la detección de eventos, envuélvelo en un GestureDetector y pase una función al parámetro `onTap`.

    <!-- skip -->
    ```dart
    class SampleApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Center(
            child: GestureDetector(
              child: FlutterLogo(
                size: 200.0,
              ),
              onTap: () {
                print("tap");
              },
            ),
          ),
        );
      }
    }
    ```

## ¿Cómo puedo gestionar otros gestos en los widgets?

Utilizando `GestureDetector` puedes escuchar una amplia gama de gestos como:

* Tapping

  * `onTapDown` — Un puntero que podría provocar un toque ha entrado en contacto con la pantalla en una ubicación determinada.
  * `onTapUp` — Un puntero que activa un toque ha dejado de entrar en contacto con la pantalla en una ubicación determinada.
  * `onTap` — Se ha producido un toque.
  * `onTapCancel` — El puntero que desencadenó previamente el `onTapDown` no causará un toque.

* Double tapping

  * `onDoubleTap` — El usuario tocó la pantalla en la misma ubicación dos veces en una sucesión rápida.

* Long pressing

  * `onLongPress` — Un puntero ha permanecido en contacto con la pantalla en el mismo lugar durante un largo período de tiempo.

* Vertical dragging

  * `onVerticalDragStart` — Un puntero ha entrado en contacto con la pantalla y puede comenzar a moverse verticalmente.
  * `onVerticalDragUpdate` — Un puntero en contacto con la pantalla se ha movido más en la dirección vertical.
  * `onVerticalDragEnd` — Un puntero que anteriormente estaba en contacto con la pantalla y se movía verticalmente ya no está en contacto con la pantalla y se movía a una velocidad específica cuando dejó de entrar en contacto con la pantalla.

* Horizontal dragging

  * `onHorizontalDragStart` — Un puntero ha entrado en contacto con la pantalla y puede comenzar a moverse horizontalmente.
  * `onHorizontalDragUpdate` — Un puntero en contacto con la pantalla se ha movido más en la dirección horizontal.
  * `onHorizontalDragEnd` — Un puntero que antes estaba en contacto con la pantalla y que se movía horizontalmente ya no está en contacto con la pantalla.

El siguiente ejemplo muestra un `GestureDetector` que rota el logotipo de Flutter
con un doble toque:

<!-- skip -->
{% prettify dart %}
AnimationController controller;
CurvedAnimation curve;

@override
void initState() {
  controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
  curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: RotationTransition(
            turns: curve,
            child: FlutterLogo(
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
      ),
    );
  }
}
{% endprettify %}

# Creación de themes y texto

## ¿Cómo se crea un theme para una aplicación?

De inicio, Flutter viene con una atractiva implementación de Material Design, que se encarga de un montón de necesidades de estilos y creación de themes que normalmente harías.

Para aprovechar al máximo los Material Components en tu app, declare un widget de primer nivel, MaterialApp, como punto de entrada a su aplicación. MaterialApp es un widget de conveniencia que incluye una serie de widgets que son comúnmente requeridos para aplicaciones que implementan Material Design. Se basa en una WidgetsApp añadiendo funcionalidad específica de Material.

Pero Flutter es lo suficientemente flexible y expresivo como para implementar cualquier lenguaje de diseño.
En iOS, puede utilizar la
[biblioteca Cupertino](https://docs.flutter.io/flutter/cupertino/cupertino-library.html)
para producir una interfaz que se adhiera a las [Human Interface
Guidelines](https://developer.apple.com/ios/human-interface-guidelines/overview/themes/).
Para ver el listado completo de estos widgets, consulte la sección
[Cupertino (widgets estilo iOS)](/widgets/cupertino/).

También puede utilizar un `WidgetApp` como tu widget de aplicación, que proporciona parte de la misma funcionalidad, pero no es tan rica como `MaterialApp`.

Para personalizar los colores y estilos de cualquier componente hijo, utilice
`ThemeData` objeto del widget `MaterialApp`. Por ejemplo, en el código de abajo, la muestra principal está configurada en azul y el color de la selección de texto es rojo.

<!-- skip -->
{% prettify dart %}
class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textSelectionColor: Colors.red
      ),
      home: SampleAppPage(),
    );
  }
}
{% endprettify %}

## ¿Cómo configuro fuentes personalizadas en mis widgets Text?

En iOS, puede importar cualquier fuente de tipo `ttf` en tu proyecto y crear una referencia en el archivo `info.plist`. En Flutter, coloca el archivo de fuente en una carpeta y has referencia a él en el archivo `pubspec.yaml`, de forma similar a como se importan las imágenes.

<!-- skip -->
{% prettify yaml %}
fonts:
   - family: MyCustomFont
     fonts:
       - asset: fonts/MyCustomFont.ttf
       - style: italic
{% endprettify %}

A continuación, asigna la fuente a su widget `Text`:

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Sample App"),
    ),
    body: Center(
      child: Text(
        'Este es un fuente de texto personalizado',
        style: TextStyle(fontFamily: 'MyCustomFont'),
      ),
    ),
  );
}
{% endprettify %}

## ¿Cómo doy estilos a mis widgets Text?

Junto con las fuentes, puede personalizar otros elementos de estilo en un widget `Text`.
El parámetro de style de un widget `Text` toma un objeto `TextStyle`, donde puede personalizar muchos parámetros, como por ejemplo:

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

# Entrada de formularios

## ¿Cómo funcionan los formularios en Flutter? ¿Cómo puedo recuperar los datos introducidos por el usuario?

Dada la forma en que Flutter utiliza widgets inmutables con un estado separado, puede que te preguntes cómo encaja la entrada del usuario en la imagen. En iOS, normalmente consultas los widgets por sus valores actuales cuando llega el momento de enviar la entrada del usuario, o una acción sobre ella. ¿Cómo funciona eso en Flutter?

En la práctica, los formularios son manejados, como todo en Flutter, por widgets especializados. Si tu tiene un `TextField` o un `TextFormField`, puede asignar un
[`TextEditingController`](https://docs.flutter.io/flutter/widgets/TextEditingController-class.html)
para recuperar las entradas del usuario:

<!-- skip -->
{% prettify dart %}
class _MyFormState extends State<MyForm> {
  // Crea un controlador de texto y utilícelo para recuperar el valor actual.
  // del campo de texto!
  final myController = TextEditingController();

  @override
  void dispose() {
    // Limpia el controlador cuando elimine el Widget.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar entrada de texto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Cuando el usuario pulsa el botón, muestra un diálogo de alerta con el
        // texto que el usuario ha escrito en    nuestro campo de texto.
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Recupera el texto que el usuario ha tecleado con nuestro
                // TextEditingController
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}
{% endprettify %}

Puede encontrar más información y la lista completa de códigos en
[Obtener el valor de un campo de texto](/cookbook/forms/retrieve-input/),
desde el [Flutter Cookbook](https://flutter.io/cookbook/).

## ¿Cuál es el equivalente de un placeholder en un campo de texto?

En Flutter puede mostrar fácilmente un "hint" o un texto de referencia para su campo añadiendo un objeto `InputDecoration` al parámetro decoration del constructor de decoración para el widget `Text` :

<!-- skip -->
{% prettify dart %}
body: Center(
  child: TextField(
    decoration: InputDecoration(hintText: "This is a hint"),
  ),
)
{% endprettify %}

## ¿Cómo puedo mostrar los errores de validación?

Al igual que lo harías con un "hint", pasa un objeto `InputDecoration`
al constructor de decoración para el widget `Text`.

Sin embargo, no desea comenzar mostrando un error.
En su lugar, cuando el usuario haya introducido datos no válidos, actualice el estado y pase un nuevo objeto `InputDecoration`.

<!-- skip -->
{% prettify dart %}
class SampleApp extends StatelessWidget {
  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  String _errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
      ),
      body: Center(
        child: TextField(
          onSubmitted: (String text) {
            setState(() {
              if (!isEmail(text)) {
                _errorText = 'Error: Esto no es un correo electrónico';
              } else {
                _errorText = null;
              }
            });
          },
          decoration: InputDecoration(hintText: "Esto es una pista", errorText: _getErrorText()),
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

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }
}
{% endprettify %}

# Interactuar con el hardware, servicios de terceros y con la plataforma

## ¿Cómo interactúo con la plataforma y con el código nativo de la plataforma?

Flutter no ejecuta código directamente en la plataforma subyacente; más bien, el código Dart que constituye una aplicación Flutter se ejecuta de forma nativa en el dispositivo, "evitando" el SDK proporcionado por la plataforma. Esto significa, por ejemplo, que cuando realizas una solicitud de red en Dart, se ejecuta directamente en el contexto de Dart. No se utilizan las API de Android o iOS que normalmente se aprovechan al escribir aplicaciones nativas. Tu app Flutter sigue alojada en el `ViewController` de una app nativa, como una vista, pero no tienes acceso directo al `ViewControlleren` si mismo, ni al framework nativo.

Esto no significa que las aplicaciones Flutter no puedan interactuar con esas API nativas, o con cualquier código nativo que tengas. Flutter proporciona [platfom channels](/platform-channels/),
que comunican e intercambian datos con el `ViewController` que contiene tu vista Flutter. Los platfom channels son esencialmente un mecanismo de mensajería asíncrono que une el código Dart con el anfitrión `ViewController` y el framework de trabajo de iOS en el que se ejecuta. Puede utilizar platfom channels para ejecutar un método en el lado nativo o para recuperar algunos datos de los sensores del dispositivo, por ejemplo.

Además de utilizar directamente los platfom channels, puede utilizar una gran variedad de plugins prefabricaddos [plugins](/using-packages/) que encapsula el código nativo y el código Dart para un objetivo específico. Por ejemplo, puede utilizar un plugin para acceder al carrete de cámara y a la cámara del dispositivo directamente desde Flutter, sin tener que escribir su propia integración. Los plugins se encuentran en el reposiorio de paquetes de código abierto de Dart y Flutter, [Pub](https://pub.dartlang.org/).
Algunos paquetes pueden soportar integraciones nativas en iOS, Android o ambos.

Si no puede encontrar un plugin en Pub que se adapte a sus necesidades, puede
[escribir el tuyo propio](/developing-packages/)
y [publicarlo en Pub](/developing-packages/#publish).

## ¿Cómo accedo al sensor GPS?

Utilice el plugin [`geolocator`](https://pub.dartlang.org/packages/geolocator) de la comunidad.

## ¿Cómo accedo a la cámara?

El plugin [`image_picker`](https://pub.dartlang.org/packages/image_picker) es popular para acceder a la cámara.

## ¿Cómo me conecto con Facebook?

Para iniciar sesión con Facebook, utilice el plugin 
[`flutter_facebook_login`](https://pub.dartlang.org/packages/flutter_facebook_login) de la comunidad.

## ¿Cómo uso las funciones de Firebase?

La mayoría de las funciones de Firebase están cubiertas por
[first party plugins](https://pub.dartlang.org/flutter/packages?q=firebase).
Estos plugins son integraciones de primera mano, mantenidas por el equipo de Flutter:

 * [`firebase_admob`](https://pub.dartlang.org/packages/firebase_admob) para Firebase AdMob
 * [`firebase_analytics`](https://pub.dartlang.org/packages/firebase_analytics) para la analítica de Firebase
 * [`firebase_auth`](https://pub.dartlang.org/packages/firebase_auth) para Firebase autenticación
 * [`firebase_core`](https://pub.dartlang.org/packages/firebase_core) para el package principal de Firebase
 * [`firebase_database`](https://pub.dartlang.org/packages/firebase_database) para RTDB Firebase
 * [`firebase_storage`](https://pub.dartlang.org/packages/firebase_storage) para Firebase Cloud Storage
 * [`firebase_messaging`](https://pub.dartlang.org/packages/firebase_messaging) para Mensajería Firebase (FCM)
 * [`cloud_firestore`](https://pub.dartlang.org/packages/cloud_firestore) para Firebase Cloud Firestore

También puedes encontrar algunos plugins Firebase de terceros en Pub que cubren áreas que no están directamente cubiertas por los plugins de primer nivel.

## ¿Cómo puedo crear mis propias integraciones nativas personalizadas?

Si hay funcionalidades específicas de la plataforma que Flutter o los plugins de su comunidad no están disponibles, puedes construir los tuyos propios siguiendo la página
[developing packages and plugins](/developing-packages/).

La arquitectura de plugins de Flutter, en pocas palabras, es muy parecida a la de un bus de eventos en Android: tú disparas un mensaje y dejas que el receptor lo procese y te devuelve el resultado. En este caso, el receptor es código que se ejecuta en el lado nativo de Android o iOS.

# Bases de datos y almacenamiento local

## ¿Cómo accedo a `UserDefaults` en Flutter?

En iOS, puede almacenar una colección de pares clave/valor utilizando una lista de propiedades,
conocido como `UserDefaults`.

En Flutter, accede a la funcionalidad equivalente mediante
[Shared Preferences plugin](https://pub.dartlang.org/packages/shared_preferences).
Este plugin envuelve la funcionalidad de ambos `UserDefaults` y el equivalente en Android, `SharedPreferences`.

## ¿Cuál es el equivalente a CoreData en Flutter?

En iOS, puede utilizar CoreData para almacenar datos estructurados. Esto es simplemente una capa encima de una base de datos SQL, lo que facilita la realización de consultas relacionadas con sus modelos.

En Flutter, acceda a esta funcionalidad utilizando el plugin
[SQFlite](https://pub.dartlang.org/packages/sqflite).

# Notificaciones

## ¿Cómo configuro las notificaciones push?

En iOS, debe registrar la aplicación en el portal del desarrollador para permitir las notificaciones push.

En Flutter, acceda a esta funcionalidad utilizando el plugin
`firebase_messaging`.

Para obtener más información sobre el uso de la API de mensajería en nube de Firebase, consulte la documentación del plugin [`firebase_messaging`](https://pub.dartlang.org/packages/firebase_messaging).
