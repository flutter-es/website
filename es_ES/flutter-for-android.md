---
layout: page
title: Flutter para Desarrolladores Android
permalink: /flutter-for-android/
---
Este documento está dirigido a desarrolladores de Android que deseen aplicar sus conocimientos existentes sobre Android para crear aplicaciones móviles con Flutter. Si entiendes los fundamentos del framework de Android entonces puedes usar este documento como un inicio para el desarrollo de Flutter.

Tus conocimientos y habilidades sobre Android son muy valiosos a la hora de construir con Flutter, ya que Flutter depende del sistema operativo móvil para numerosas funcionalidades y configuraciones. Flutter es una nueva forma de crear UI para móviles,
pero tiene un sistema de plugin para comunicarse con Android (e iOS) para tareas que no son de UI. Si eres un experto con Android, no tienes que volver a aprender todo para usar Flutter.

Este documento puede ser usado como un cookbook en el que se tratan las siguientes cuestiones que son más relevantes para tus necesidades.

* TOC Placeholder
{:toc}

# Views

## ¿Cuál es el equivalente de una `View` en Flutter?

En Android, el `View` es la base de todo lo que aparece en la pantalla. Botones, toolbars, e inputs, todo es un View. En Flutter, el equivalente aproximado a un `View` es un `Widget`. Los widgets no se asignan exactamente a las vistas de Android, pero mientras te familiarizas con el funcionamiento de Flutter, puedes pensar en ellos como "la forma en que declaras y construyes la UI".

Sin embargo, estos tienen algunas diferencias con un `View`. Para empezar, los widgets tienen una vida útil diferente: son inmutables y sólo existen hasta que necesitan ser cambiados. Cada vez que los widgets o su estado cambian, el framework de Flutter crea un nuevo árbol de instancias de widgets. En comparación, una view de Android se dibuja una vez y no se vuelve a dibujar hasta que se llama `invalidate`.

Los widgets de Flutter son ligeros, en parte debido a su inmutabilidad. Porque no son vistas en sí mismas, y no están dibujando nada directamente, sino más bien una descripción de la UI y su semántica que se "sube" a los objetos view que están en el interior.

Flutter incluye la biblioteca [Material Components](https://material.io/develop/flutter/). Estos son los widgets que implementan la
[Guías de Material Design](https://material.io/design/). Material Design es un
sistema de diseño flexible [optimizado para todas las 
plataformas](https://material.io/design/platform-guidance/cross-platform-adaptation.html#cross-platform-guidelines),
incluyendo iOS.

Pero Flutter es lo suficientemente flexible y expresivo como para implementar cualquier lenguaje de diseño.
Por ejemplo, en iOS, puedes utilizar los [widgets Cupertino](https://flutter.io/widgets/cupertino/)
para producir una interfaz que se parezca al
[Lenguaje de diseño iOS de Apple](https://developer.apple.com/design/resources/).

## ¿Cómo actualizo `Widgets`?

En Android, puedes actualizar tus vistas mutándolas directamente. Sin embargo,
en Flutter, los `Widgets` son inmutables y no se actualizan directamente, en su lugar
tienes que trabajar con el estado del widget.

De ahí el concepto de los widgets Stateful vs Stateless. Un `StatelessWidget` es justo lo que parece, un widget sin información de estado.

Los `StatelessWidgets` son útiles cuando la parte de la interfaz de usuario que está describiendo no depende de nada más que de la configuración en el objeto.

Por ejemplo, en Android, esto es similar a colocar un "ImageView" con su logo. El logo no va a cambiar durante el tiempo de ejecución, así que usa un `StatelessWidget` en Flutter.

Si deseas cambiar dinámicamente la UI basándote en los datos recibidos después de realizar una llamada HTTP o una interacción con el usuario, entonces tienes que trabajar con `StatefulWidget` y decirle al framework Flutter que el `State` del widget
ha sido actualizado para que pueda actualizarlo.

Lo importante a tener en cuenta aquí es que tanto los widgets stateless como los stateful se comportan de la misma manera. Reconstruyen cada frame, la diferencia es que el `StatefulWidget` tiene un objeto `State` que almacena datos de estado a través de frames y los restaura.

Si tienes dudas, recuerda siempre esta regla: si un widget cambia (debido a las interacciones del usuario, por ejemplo), es stateful. Sin embargo, si un widget reacciona al cambio, el widget padre que lo contiene puede seguir siendo stateless si él mismo no reacciona al cambio.

El siguiente ejemplo muestra cómo usar un `StatelessWidget`. Un `StatelessWidget` común es el widget `Text`. Si observamos la implementación del widget `Text` lo encontrarás en las subclases `StatelessWidget`. 

<!-- skip -->
{% prettify dart %}
Text(
  'I like Flutter!',
  style: TextStyle(fontWeight: FontWeight.bold),
);
{% endprettify %}

Como puedes ver, el Widget "Text" no tiene ninguna información de estado asociada a él, muestra lo que se le pasa a sus constructores y nada más.

Pero ¿qué pasa si quieres hacer que "I Like Flutter" cambie dinámicamente, por
ejemplo al hacer clic en un `FloatingActionButton`?

Para lograr esto, envuelve el widget `Text` en un `StatefulWidget` y actualízalo cuando el usuario haga clic en el botón.

Por ejemplo:

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget es la raíz de tu aplicación.
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
  // Texto placeholder predeterminado
  String textToShow = "I Like Flutter";
  void _updateText() {
    setState(() {
      // update the text
      textToShow = "Flutter is Awesome!";
    });
  }  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
      ),
      body: Center(child: Text(textToShow)),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: Icon(Icons.update),
      ),
    );
  }
}
{% endprettify %}

## ¿Cómo puedo diseñar mis widgets? ¿Dónde está mi archivo de diseño XML?

En Android, los diseños se escriben en XML, pero en Flutter se escriben con un árbol de widgets.

El siguiente ejemplo muestra cómo desplegar un widget simple con padding:

<!-- skip -->
{% prettify dart %}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {},
          child: Text('Hello'),
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
        ),
      ),
    );
  }
{% endprettify %}

Puedes ver los diseños que Flutter tiene para ofrecer en el [Catálogo de Widgets](/widgets/layout/).

## ¿Cómo agrego o elimino un componente de mi diseño?

En Android, puedes llamar a `addChild()` o `removeChild()` en un padre para añadir o eliminar dinámicamente las vistas hijas. En Flutter, dado que los widgets son inmutables no hay equivalente directo a `addChild()`.
En su lugar, puedes pasar una función al padre que devuelva un widget, y
controlar la creación de ese hijo con una etiqueta booleana.

Por ejemplo, aquí está cómo puedes alternar entre dos widgets cuando haces clic en un 
`FloatingActionButton`:

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
  // Valor por defecto para conmutar
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
      return MaterialButton(onPressed: () {}, child: Text('Toggle Two'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
      ),
      body: Center(
        child: _getToggleChild(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggle,
        tooltip: 'Update Text',
        child: Icon(Icons.update),
      ),
    );
  }
}
{% endprettify %}

## ¿Cómo puedo animar un widget?

En Android, puedes crear animaciones usando XML, o llamar al método `animate()` en una vista. En Flutter, anima los widgets usando la biblioteca de animaciones, envolviendo los widgets dentro de un widget animate.

En Flutter, utiliza un `AnimationController` que es un `Animation<double>` que puede pausar, buscar, detener e invertir la animación. Requiere un `Ticker` que señala cuando se produce la sincronización, y produce una interpolación lineal entre 0 y 1 en cada frame mientras está en ejecución. Luego creas una o más `Animations` y las vinculas al controlador.

Por ejemplo, puedes usar `CurvedAnimation` para implementar una animación a lo largo de una curva interpolada. En este sentido, el controlador es la fuente "maestra" del progreso de la animación y la `AnimaciónCurvada` calcula la curva que reemplaza el movimiento lineal predeterminado del controlador. Al igual que los widgets, las animaciones de Flutter trabajan con la composición. 

Cuando construyas el árbol de widgets, asigna la `Animation` a una propiedad animada de un widget, como la opacidad de un `FadeTransition`, y le dices al controlador que inicie la animación.

El siguiente ejemplo muestra cómo escribir un `FadeTransition` que desvanece el widget en un logotipo al pulsar el `FloatingActionButton`:

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(FadeAppTest());
}

class FadeAppTest extends StatelessWidget {
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
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
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
                  )))),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Fade',
        child: Icon(Icons.brush),
        onPressed: () {
          controller.forward();
        },
      ),
    );
  }
}
{% endprettify %}

Para más información, consulta
[Wigets de animación y movimiento](/widgets/animation/),
el [Tutorial de Animaciones ](/tutorials/animation),
y [Animaciones](/animations/).

## ¿Cómo puedo usar un `Canvas` para dibujar/pintar?

En Android, usarías `Canvas` y `Drawable` para dibujar imágenes y formas en la pantalla. Flutter tiene una API similar a la de `Canvas`, puesto que se basa en el mismo motor de renderizado de bajo nivel, Skia. Como resultado, pintar en un canvas en Flutter es una tarea muy familiar para los desarrolladores de Android.

Flutter tiene dos clases que te ayudan a dibujar en el canvas: `CustomPaint` y 
`CustomPainter`, el último de los cuales implementa su algoritmo para dibujar en el canvas.

Para aprender cómo implementar un signature painter en Flutter, consulta la respuesta de Collin en
[StackOverflow](https://stackoverflow.com/questions/46241071/create-signature-area-
for-mobile-app-in-dart-flutter).

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: DemoApp()));

class DemoApp extends StatelessWidget {
  Widget build(BuildContext context) => Scaffold(body: Signature());
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
{% endprettify %}

## ¿Cómo construyo widgets personalizados?

En Android, normalmente se subclasifica `View`, o se utiliza una vista preexistente, para sobrescribir e implementar métodos que logren el comportamiento deseado.

En Flutter, construye un widget personalizado mediante pequeños widgets
[composing](/technical-overview/#everythings-a-widget) 
(en lugar de heredarlos).
Es algo similar a la implementación de un `ViewGroup` personalizado en Android, donde todos los bloques de construcción ya existen, pero
proporcionas un comportamiento diferente, por ejemplo, una lógica de diseño personalizada.

Por ejemplo, ¿cómo se construye un `CustomButton` que toma una etiqueta en
el constructor? Crea un CustomButton que componga un `RaisedButton` con una etiqueta, en lugar de heredar de `RaisedButton`:

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

Entonces usa `CustomButton`, tal como lo harías con cualquier otro widget de Flutter:

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return Center(
    child: CustomButton("Hello"),
  );
}
{% endprettify %}

# Intents

## ¿Cuál es el equivalente a una `intent` en Flutter?

En Android, existen dos casos de uso principales para `Intent`: navegar entre Activities, y comunicarse con los componentes. Flutter, por otro lado, no tiene el concepto de intents, aunque todavía se pueden iniciar intents a través de integraciones nativas.
(usando [un plugin](https://pub.dartlang.org/packages/android_intent)).

Flutter no tiene realmente un equivalente directo a actividades y fragmentos; más bien, en Flutter se navega entre pantallas, usando un `Navigator` y `Route`, todo dentro de la misma `Activity`.

Un `Route` es una abstracción para un "screen" o "page" de una aplicación, y un `Navigator` es un widget que gestiona rutas. Una ruta se mapea aproximadamente a un `Activity`, pero no tiene el mismo significado. Un navegador puede empujar y hacer push y pop a rutas para moverse de pantalla en pantalla. Los navegadores funcionan como una pila en la que puedes hacer `push()` a nuevas rutas hacia las que quieres navegar, y desde la que puedes hacer 
`pop()` a las rutas en las que quieres "volver atrás".

En Android, declaras tus actividades dentro de la aplicación `AndroidManifest.xml`.

En Flutter, tienes un par de opciones para navegar entre páginas:

* Especifica un `Map` de nombres de ruta. (MaterialApp)
* Navega directamente a una ruta. (WidgetApp)

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

Navega a una ruta mediante `push` a su nombre en el `Navigator`.

<!-- skip -->
{% prettify dart %}
Navigator.of(context).pushNamed('/b');
{% endprettify %}

El otro caso de uso popular para `Intent` es llamar a componentes externos como una cámara o un selector de archivos. Para ello, necesitarías crear una integración de plataforma nativa (o usar un [plugin existente](https://pub.dartlang.org/flutter/)).

Para obtener más información sobre cómo crear una integración de plataforma nativa, consulta
[Desarrollando Paquetes y Plugins](/developing-packages/).

## ¿Cómo manejo los intents entrantes desde aplicaciones externas en Flutter?

Flutter puede manejar los intents entrantes de Android hablando directamente con la capa de Android y solicitando los datos que se compartieron.

El siguiente ejemplo registra un filtro de intent para compartir texto en la actividad nativa que ejecuta nuestro código Flutter, para que otras aplicaciones puedan compartir texto con nuestra aplicación Flutter.

El flujo básico implica que primero manejemos los datos de texto compartidos en el lado nativo de Android (en nuestra `Activity`), y luego esperar hasta que Flutter solicite los datos para proporcionarlos usando un `MethodChannel`.

Primero, registra el filtro intent para todos los intents en `AndroidManifest.xml`:

<!-- skip -->
{% prettify xml %}
<activity
  android:name=".MainActivity"
  android:launchMode="singleTop"
  android:theme="@style/LaunchTheme"
  android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection"
  android:hardwareAccelerated="true"
  android:windowSoftInputMode="adjustResize">
  <!-- ... -->
  <intent-filter>
    <action android:name="android.intent.action.SEND" />
    <category android:name="android.intent.category.DEFAULT" />
    <data android:mimeType="text/plain" />
  </intent-filter>
</activity>
{% endprettify %}

Luego, en `MainActivity`, maneja el intent, extrae el texto que fue compartido desde el intent, y consérvalo. Cuando Flutter está listo para procesar, solicita los datos utilizando un canal de la plataforma y su envío desde el lado nativo:

<!-- skip -->
{% prettify java %}
package com.example.shared;

import android.content.Intent;
import android.os.Bundle;

import java.nio.ByteBuffer;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.ActivityLifecycleListener;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private String sharedText;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    Intent intent = getIntent();
    String action = intent.getAction();
    String type = intent.getType();

    if (Intent.ACTION_SEND.equals(action) && type != null) {
      if ("text/plain".equals(type)) {
        handleSendText(intent); // Manejar el texto que se envía
      }
    }

    MethodChannel(getFlutterView(), "app.channel.shared.data")
      .setMethodCallHandler(MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
          if (methodCall.method.contentEquals("getSharedText")) {
            result.success(sharedText);
            sharedText = null;
          }
        }
      });
  }

  void handleSendText(Intent intent) {
    sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
  }
}
{% endprettify %}

Por último, solicita los datos desde el lado Flutter cuando se muestre el widget:

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Shared App Handler',
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
  static const platform = const MethodChannel('app.channel.shared.data');
  String dataShared = "No data";

  @override
  void initState() {
    super.initState();
    getSharedText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(dataShared)));
  }

  getSharedText() async {
    var sharedData = await platform.invokeMethod("getSharedText");
    if (sharedData != null) {
      setState(() {
        dataShared = sharedData;
      });
    }
  }
}
{% endprettify %}

## ¿Cuál es el equivalente de `startActivityForResult()`?

La clase `Navigator` maneja el enrutamiento en Flutter y se utiliza para obtener un resultado de una ruta a la que le hiciste push en la pila. Esto se hace mediante `await` en el `Future` devuelto por `push()`.

Por ejemplo, para iniciar una location route que permita al usuario seleccionar su ubicación, puedes hacer lo siguiente:

<!-- skip -->
{% prettify dart %}
Map coordinates = await Navigator.of(context).pushNamed('/location');
{% endprettify %}

Y luego, dentro de la  location route, una vez que el usuario haya seleccionado su ubicación puedes hacer `pop` en la pila con el resultado:

<!-- skip -->
{% prettify dart %}
Navigator.of(context).pop({"lat":43.821757,"long":-79.226392});
{% endprettify %}

# UI Asíncrono

## ¿Cuál es el equivalente de `runOnUiThread()` en Flutter?

Dart tiene un modelo de ejecución de un solo hilo, con soporte para `Isolate` (una forma de ejecutar código de Dart en otro hilo), un bucle de eventos y programación asíncrona. A menos que se genere un `Isolate`, el código de Dart se ejecuta en el hilo principal de la UI y es controlado por un bucle de eventos. El bucle de eventos de Flutter es equivalente al principal `Looper`, es decir, el `Looper` que está conectado al hilo principal.

El modelo de un solo hilo de Dart no significa que necesites ejecutarlo todo como una operación de bloqueo que hace que la UI se congele. A diferencia de Android, que requiere que mantengas el hilo principal libre en todo momento, en Flutter, utiliza las funciones asíncronas que proporciona el lenguaje Dart, como "async"/"await", para realizar el trabajo asíncrono. Puedes estar familiarizado con el paradigma `async`/`await` si lo has usado en C#, Javascript, o si has usado las corutinas de Kotlin.

Por ejemplo, puedes ejecutar código de red sin hacer que la UI se cuelgue usando `async`/`await` y dejando que Dart haga el trabajo pesado:

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

Una vez que la llamada de red `await` se haya realizado, actualiza la interfaz de usuario llamando a `setState()`, que desencadena una reconstrucción del subárbol del widget y actualiza los datos.

El siguiente ejemplo carga datos asincrónicamente y los muestra en una `ListView`:

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

Consulta la siguiente sección para obtener más información sobre cómo trabajar en segundo plano y en qué se diferencia Flutter de Android.

## ¿Cómo se mueve el trabajo a un background thread?

En Android, cuando deseas acceder a un recurso de red, normalmente te mueves a un background thread y haces el trabajo, para no bloquear el hilo principal y evitar los ANR. Por ejemplo, puedes estar usando un `AsyncTask`, un `LiveData`, un `IntentService`, un `JobScheduler` o un pipeline RxJava con un programador que trabaja sobre background threads.

Dado que Flutter es un hilo único y ejecuta un bucle de eventos (como Node.js), no tienes que preocuparte por la gestión de hilos o por la generación de background threads. Si estás realizando un trabajo de E/S, como acceso a disco o una llamada de red, puedes usar 
`async`/`wait` con seguridad y ya está todo configurado. Si, por otro lado, necesitas hacer un trabajo intensivo de computación que mantenga la CPU ocupada, quieres moverla a un `Isolate` para evitar bloquear el bucle de eventos, como si mantuvieras _cualquier_ tipo de trabajo fuera del hilo principal en Android.

Para trabajos de E/S, declara la función como una función de "async", y en tareas de larga duración "await" dentro de la función:

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

Así es como normalmente se hacen las llamadas de red o de base de datos, que son operaciones de E/S.

En Android, cuando heredas de `AsyncTask`, normalmente sobrescribes 3 métodos, 
`onPreExecute()`, `doInBackground()` y `onPostExecute()`. No hay equivalente en Flutter, ya que debes `await` (esperar) en una función de larga duración, y el bucle de eventos de Dart se encarga del resto.

Sin embargo, hay ocasiones en las que podrías estar procesando una gran cantidad de datos y tu UI se bloquea. En Flutter, utiliza `Isolate` para aprovechar los múltiples núcleos de la CPU para realizar tareas de larga duración o intensivas en el cálculo.

Los isolates son hilos de ejecución separados que no comparten ninguna memoria con la memoria de ejecución principal. Esto significa que no puede acceder a las variables desde el hilo principal, o actualizar su UI llamando a `setState()`. A diferencia de los hilos de Android, los Isolates son fieles a su nombre y no pueden compartir memoria (en forma de campos estáticos, por ejemplo).

El siguiente ejemplo muestra, en un isolate simple, cómo compartir datos de vuelta al hilo principal para actualizar la UI.

<!-- skip -->
{% prettify dart %}
loadData() async {
  ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(dataLoader, receivePort.sendPort);

  // El isolate 'echo' envía su SendPort como primer mensaje
  SendPort sendPort = await receivePort.first;

  List msg = await sendReceive(sendPort, "https://jsonplaceholder.typicode.com/posts");

  setState(() {
    widgets = msg;
  });
}

// El punto de entrada para el isolate
static dataLoader(SendPort sendPort) async {
  // Open the ReceivePort for incoming messages.
  ReceivePort port = ReceivePort();

  // Notificar a otros isolates qué puerto escucha este isolate.
  sendPort.send(port.sendPort);

  await for (var msg in port) {
    String data = msg[0];
    SendPort replyTo = msg[1];

    String dataURL = data;
    http.Response response = await http.get(dataURL);
    // Un montón de JSON para analizar
    replyTo.send(json.decode(response.body));
  }
}

Future sendReceive(SendPort port, msg) {
  ReceivePort response = ReceivePort();
  port.send([msg, response.sendPort]);
  return response.first;
}
{% endprettify %}

Aquí, `dataLoader()` es el `Isolate` que se ejecuta en su propio hilo de ejecución separado.
En el isolate se puede realizar un procesamiento más intensivo de la CPU (por ejemplo, analizando un JSON grande), o realizar cálculos matemáticos intensivos de computación, como encriptación o procesamiento de señales.

Puedes ejecutar el ejemplo completo a continuación:

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

    // El isolate 'echo' envía su SendPort como primer mensaje
    SendPort sendPort = await receivePort.first;

    List msg = await sendReceive(sendPort, "https://jsonplaceholder.typicode.com/posts");

    setState(() {
      widgets = msg;
    });
  }

  // el punto de entrada para el isolate
  static dataLoader(SendPort sendPort) async {
    // Abre el ReceivePort para los mensajes entrantes.
    ReceivePort port = ReceivePort();

    // Notifica a cualquier otro isolate qué puerto escucha este isolate.
    sendPort.send(port.sendPort);

    await for (var msg in port) {
      String data = msg[0];
      SendPort replyTo = msg[1];

      String dataURL = data;
      http.Response response = await http.get(dataURL);
      // Mucho JSON para analizar
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

## ¿Cuál es el equivalente de OkHttp en Flutter?

Realizar una llamada de red en Flutter es fácil cuando se utiliza la popular función
[`http` package](https://pub.dartlang.org/packages/http).

Aunque el paquete http no tiene todas las funciones que se encuentran en OkHttp, abstrae gran parte de la red que normalmente se implementa por sí misma, lo que hace que sea una forma sencilla de realizar llamadas de red.

Para usar el paquete `http`, agrégalo a tus dependencias en `pubspec.yaml`:

<!-- skip -->
{% prettify yaml %}
dependencies:
  ...
  http: ^0.11.3+16
{% endprettify %}

Para hacer una llamada de red, llama a `await` en la función `async` (asíncrona) 
`http.get()`:

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

En Android normalmente mostrarías una vista de `ProgressBar` en tu UI mientras ejecutas una tarea de larga duración en un background thread.

En Flutter, usa un widget `ProgressIndicator`.
Muestra el progreso programáticamente controlando cuándo se renderiza a través de una etiqueta booleana. Dile a Flutter que actualice su estado antes de que comience la tarea de larga duración y que la oculte después de que termine.

En el siguiente ejemplo, la función de construcción se divide en tres funciones diferentes. Si `showLoadingDialog()` es `true` (cuando `widgets.length == 0`), entonces renderiza el `ProgressIndicator`. De lo contrario, renderiza el "ListView" con los datos devueltos de una llamada de red.

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

# Estructura y recursos del proyecto

## ¿Dónde guardo mis archivos de imagen dependientes de la resolución?

Mientras que Android trata los recursos y los assets como elementos distintos, las aplicaciones Flutter sólo tienen assets. Todos los recursos que vivirían en las carpetas `res/drawable-*` de Android, se colocan en una carpeta de assets para Flutter.

Flutter sigue un formato simple basado en la densidad como iOS. Los activos pueden ser `1.0x`, `2.0x`, `3.0x`, o cualquier otro multiplicador. Flutter no tiene `dp` pero hay píxeles lógicos, que son básicamente los mismos que los píxeles independientes del dispositivo. El llamado
[`devicePixelRatio`](https://docs.flutter.io/flutter/dart-ui/Window/devicePixelRatio.html)
expresa la proporción de píxeles físicos en un solo píxel lógico.

Los equivalentes a los cubos de densidad de Android son:

 Calificador de densidad Android | Relación de píxeles de Flutter
  --- | ---
 `ldpi` | `0.75x`
 `mdpi` | `1.0x`
 `hdpi` | `1.5x`
 `xhdpi` | `2.0x`
 `xxhdpi` | `3.0x`
 `xxxhdpi` | `4.0x`

Los assets están localizados en cualquier carpeta arbitraria. Flutter no tiene una estructura de carpetas predefinida. Usted declara los assets (con ubicación) en el archivo `pubspec.yaml`, y Flutter los recoge.

Tenga en cuenta que antes de Flutter 1.0 beta 2, los assets definidos en Flutter no eran accesibles desde el lado nativo, y viceversa, los assets y los recursos nativos no estaban disponibles para Flutter, ya que vivían en carpetas separadas.

A partir de Flutter beta 2, los assets se almacenan en la carpeta nativa de asset, y se accede a ellos desde el lado nativo usando el `AssetManager` de Android:

<!-- skip -->
{% prettify kotlin %}
val flutterAssetStream = assetManager.open("flutter_assets/assets/my_flutter_asset.png")
{% endprettify %}

A partir de Flutter beta 2, Flutter sigue sin poder acceder a los recursos nativos, ni a los assets nativos.

Para añadir un nuevo asset de imagen llamado `my_icon.png` a nuestro proyecto Flutter, por ejemplo, y decidir qué debería vivir en una carpeta que arbitrariamente llamamos `images`, pondrías la imagen base (1.0x) en la carpeta `images`, y todas las demás variantes en subcarpetas llamadas con el multiplicador de proporción apropiado:

```
images/my_icon.png       // Base: 1.0x image
images/2.0x/my_icon.png  // 2.0x image
images/3.0x/my_icon.png  // 3.0x image
```

A continuación, deberás declarar estas imágenes en tu archivo `pubspec.yaml`:

<!-- skip -->
{% prettify yaml %}
assets:
 - images/my_icon.jpeg
{% endprettify %}

A continuación, puedes acceder a tus imágenes utilizando `AssetImage`:

<!-- skip -->
{% prettify dart %}
return AssetImage("images/a_dot_burr.jpeg");
{% endprettify %}

o directamente en un widget `Image`:

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return Image.asset("images/my_image.png");
}
{% endprettify %}

## ¿Dónde guardo los strings? ¿Cómo gestiono la localización?

Flutter actualmente no tiene un sistema de recursos dedicado para los strings. Por el momento, la mejor práctica es mantener tu texto de copia en una clase como campos estáticos y acceder a ellos desde allí. Por ejemplo:

<!-- skip -->
{% prettify dart %}
class Strings {
  static String welcomeMessage = "Welcome To Flutter";
}
{% endprettify %}

Luego, en tu código, puedes acceder a tus strings como tal:

<!-- skip -->
{% prettify dart %}
Text(Strings.welcomeMessage)
{% endprettify %}

Flutter tiene soporte básico para la accesibilidad en Android, aunque esta característica es un trabajo en progreso.

Se recomienda a los desarrolladores de Flutter que utilicen el 
[paquete intl](https://pub.dartlang.org/packages/intl) para la internacionalización y localización.

## ¿Cuál es el equivalente a un archivo Gradle? ¿Cómo puedo añadir dependencias?

En Android, puedes añadir dependencias añadiéndolas a tu script de construcción de Gradle. Flutter utiliza el sistema de construcción propio de Dart y el gestor de paquetes de Pub. Las herramientas delegan la creación de las aplicaciones envolventes nativas de Android e iOS a los respectivos sistemas de creación.

Aunque hay archivos Gradle bajo la carpeta `android` en tu proyecto Flutter, sólo puedes usarlos si estás añadiendo dependencias nativas necesarias para
integración por plataforma. En general, usa `pubspec.yaml` para declarar dependencias externas para usar en Flutter. Un buen lugar para encontrar paquetes de Flutter es
[Pub](https://pub.dartlang.org/flutter/packages/).

# Actividades y fragmentos

<aside class="alert alert-info" markdown="1">
**Nota:** Casi nunca quieres que Android reinicie la actividad para una aplicación Flutter. Especialmente porque esto va directamente en contra de los consejos de la documentación de Android. Así, por ejemplo, el soporte de pantalla dividida requiere que añadas `screenLayout` y probablemente `density` también.
</aside>

## ¿Cuál es el equivalente de actividades y fragmentos en Flutter?

En Android, un " Activity " representa una sola cosa enfocada que el usuario puede hacer. Un "Fragment" representa un comportamiento o una parte de la interfaz de usuario. Los fragmentos son una forma de modularizar el código, componer interfaces de usuario sofisticadas para pantallas más grandes y ayudar a escalar la UI de la aplicación. En Flutter, ambos conceptos caen bajo el paraguas de `Widget`.

Como se mencionó en la sección [Intents](#what-is-the-equivalent-of-an-intent-in-flutter)
, las pantallas en Flutter están representadas por `Widgets` ya que todo es un widget en Flutter. Usas un `Navigator` para moverte entre diferentes `Routes`
que representan diferentes pantallas o páginas, o tal vez sólo diferentes estados o representaciones de los mismos datos.

## ¿Cómo escucho los eventos del ciclo de vida de las actividades Android?

En Android, puedes anular los métodos de `Activity` para capturar métodos del ciclo de vida para la actividad en sí, o registrar `ActivityLifecycleCallbacks` en la `Aplicación`. En Flutter, no tienes ningún concepto, pero puedes escuchar los eventos del ciclo de vida enganchándote al observador `WidgetsBinding` y escuchando el evento de cambio `didChangeAppLifecycleState()`.

Los eventos observables del ciclo de vida son:

* `inactive` — La aplicación se encuentra en un estado inactivo y no está recibiendo entrada de uso. Este evento sólo funciona en iOS, ya que no hay ningún evento equivalente para mapear en Android.
* `paused` — La aplicación no está actualmente visible para el usuario, no responde a las entradas del usuario y se ejecuta en background. Esto equivale a `onPause()` en Android
* `resumed` — La aplicación es visible y responde a las entradas de los usuarios. Esto equivale a `onPostResume()` en Android
* `suspending` — La aplicación se suspende momentáneamente. Esto es equivalente a "onStop" en Android; no se activa en iOS ya que no hay ningún evento equivalente al que mapear en iOS.

Para más detalles sobre el significado de estos estados, consulta la sección
[Documentation de `AppLifecycleStatus` ](https://docs.flutter.io/flutter/dart-ui/AppLifecycleState-class.html).

Como habrás notado, sólo una pequeña minoría de los eventos del ciclo de vida de Activity están disponibles; mientras que `FlutterActivity` captura casi todo el ciclo de vida de la actividad internamente y los envía al motor Flutter, la mayoría están protegidos lejos de ti. Flutter se encarga de arrancar y parar el motor por ti, y
hay pocas razones para observar el ciclo de vida de la actividad en Flutter en la mayoría de los casos. Si necesita observar el ciclo de vida para adquirir o liberar cualquier recurso nativo, es probable que lo haga desde el lado nativo, en cualquier caso.

He aquí un ejemplo de cómo observar el estado del ciclo de vida de la actividad de contención:

<!-- skip -->
{% prettify dart %}
import 'package:flutter/widgets.dart';

class LifecycleWatcher extends StatefulWidget {
  @override
  _LifecycleWatcherState createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher> with WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lastLifecycleState == null)
      return Text('This widget has not observed any lifecycle changes.', textDirection: TextDirection.ltr);

    return Text('The most recent lifecycle state this widget observed was: $_lastLifecycleState.',
        textDirection: TextDirection.ltr);
  }
}

void main() {
  runApp(Center(child: LifecycleWatcher()));
}
{% endprettify %}

# Diseños

## ¿Cuál es el equivalente de un LinearLayout?

En Android, se utiliza un diseño lineal para distribuir los widgets de forma lineal, ya sea horizontal o vertical. En Flutter, utiliza el widget Row o Column para conseguir el mismo resultado.

Si lo notas, los dos ejemplos de código son idénticos con la excepción del widget "Row" y "Column". Los hijos son los mismos y esta característica puede ser explotada para desarrollar diseños detallados que pueden cambiar con los mismos hijos.

<!-- skip -->
{% prettify dart %}
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Row One'),
        Text('Row Two'),
        Text('Row Three'),
        Text('Row Four'),
      ],
    );
  }
{% endprettify %}

<!-- skip -->
{% prettify dart %}
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Column One'),
        Text('Column Two'),
        Text('Column Three'),
        Text('Column Four'),
      ],
    );
  }
{% endprettify %}

Para obtener más información sobre la creación de diseños lineales, consulta el artículo de medium [Flutter para Android Developers: ¿Cómo disegñar LinearLayout en Flutter?](https://medium.com/@burhanrashid52/flutter-for-android-developers-how-to-design-linearlayout-in-flutter-5d819c0ddf1a).

## ¿Cuál es el equivalente de un RelativeLayout?

Un RelativeLayout dispone sus widgets en relación con los demás. En
Flutter, hay algunas maneras de lograr el mismo resultado.

Puedes obtener el resultado de un RelativeLayout utilizando una combinación de
Widgets Column, Row y Stack. Puedes especificar reglas para los widgets
constructores sobre cómo están dispuestos los hijos en relación con el padre.

Para un buen ejemplo de cómo construir un RelativeLayout en Flutter, consulta la respuesta de Collin en
[StackOverflow](https://stackoverflow.com/questions/44396075/equivalent-of-relativelayout-in-flutter).

## ¿Cuál es el equivalente de un ScrollView?

En Android, utiliza un ScrollView para diseñar tus widgets, si el dispositivo del usuario tiene una pantalla más pequeña que tu contenido, hará scroll.

En Flutter, la forma más fácil de hacerlo es utilizando el widget ListView. Esto puede parecer exagerado viniendo de Android, pero en Flutter un widget ListView es tanto un ScrollView como un Android ListView.

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

## ¿Cómo manejo las transiciones landscape en Flutter?

FlutterView maneja el cambio de configuración si AndroidManifest.xml contiene:

{% prettify yaml %}
android:configChanges="orientation|screenSize"
{% endprettify %}

# Detección de gestos y manejo de eventos táctiles

## ¿Cómo puedo añadir un listener onClick a un widget en Flutter?

En Android, puedes vincular onClick a vistas como el botón llamando al método 'setOnClickListener'.

En Flutter hay dos maneras de añadir listeners táctiles:

 1. Si el Widget soporta la detección de eventos, pásale una función y adminístrala en la función. Por ejemplo, el RaisedButton tiene un parámetro `onPressed`:

    <!-- skip -->
    ```dart
    @override
    Widget build(BuildContext context) {
      return RaisedButton(
          onPressed: () {
            print("click");
          },
          child: Text("Button"));
    }
    ```

 2. Si el Widget no soporta la detección de eventos, envuelve el widget en un GestureDetector y pásale una función al parámetro `onTap`.

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
        ));
      }
    }
    ```

## ¿Cómo puedo manejar otros gestos en los widgets?

Usando el GestureDetector, puedes escuchar una amplia gama de Gestos como:

* Tap

  * `onTapDown` - Un puntero que podría provocar que un tap haya entrado en contacto con la pantalla, en una ubicación determinada.
  * `onTapUp` - Un puntero que activa un tap ha dejado de entrar en contacto con la pantalla en una ubicación determinada.
  * `onTap` - Se ha producido un tap.
  * `onTapCancel` - El puntero que previamente disparó el `onTapDown` no causará un golpecito.

* Double tap

  * `onDoubleTap` - El usuario tocó la pantalla en la misma ubicación dos veces en rápida sucesión.

* Pulsación larga

  * `onLongPress` - Un puntero ha permanecido en contacto con la pantalla en el mismo lugar durante un largo período de tiempo. 

* Arrastre vertical

  * `onVerticalDragStart` - Un puntero ha entrado en contacto con la pantalla y podría comenzar a moverse verticalmente.
  * `onVerticalDragUpdate` - Un puntero, en contacto con la pantalla,
    se ha movido más en la dirección vertical.
  * `onVerticalDragEnd` - Un puntero, que antes estaba en contacto con la pantalla y se movía verticalmente, ya no está en contacto con la pantalla y se movía a una velocidad específica cuando dejó de entrar en contacto con la pantalla.

* Horizontal drag

  * `onHorizontalDragStart` - Un puntero ha entrado en contacto con la pantalla y podría comenzar a moverse horizontalmente.
  * `onHorizontalDragUpdate` - Un puntero, en contacto con la pantalla, se ha movido más en la dirección horizontal.
  * `onHorizontalDragEnd` - Un puntero, que antes estaba en contacto con la pantalla y se movía horizontalmente, ya no está en contacto con la pantalla y se movió a una velocidad específica cuando dejó de entrar en contacto con la pantalla.

El siguiente ejemplo muestra un `Detector de Objetos` que rota el logotipo de Flutter con un doble toque:

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
    ));
  }
}
{% endprettify %}

# Listviews & adapters

## ¿Cuál es la alternativa a un ListView en Flutter?

El equivalente a un ListView en Flutter es... ¡un ListView!

En una ListView de Android, creas un adaptador y lo pasas a ListView, que muestra cada fila con lo que devuelve tu adaptador. Sin embargo, tienes que asegurarte de reciclar tus filas, de lo contrario, tendrás todo tipo de problemas visuales y de memoria.

Debido al patrón inmutable de widgets de Flutter, pasas una lista de widgets a tu ListView, y Flutter se encarga de asegurarse de que el desplazamiento sea rápido y fluido.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget es la raíz de tu aplicación.
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
      widgets.add(Padding(padding: EdgeInsets.all(10.0), child: Text("Row $i")));
    }
    return widgets;
  }
}
{% endprettify %}

## ¿Cómo sé en cuál elemento de la lista se hace clic?

En Android, ListView tiene el método 'onItemClickListener' para averiguar en cuál de los elementos se ha hecho clic.
En Flutter, utiliza el manejo táctil proporcionado por los widgets transferidos.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget es la raíz de tu aplicación.
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
            child: Text("Row $i")),
        onTap: () {
          print('row tapped');
        },
      ));
    }
    return widgets;
  }
}
{% endprettify %}

## ¿Cómo actualizo ListView dinámicamente?

En Android, actualizas el adaptador y llamas a `notifyDataSetChanged`.

En Flutter, si actualizaras la lista de widgets dentro de un `setState()`,
rápidamente te darás cuenta de que tus datos no han cambiado visualmente.
Esto se debe a que cuando se llama `setState()`, el motor de renderizado de Flutter
mira el árbol de widgets para ver si algo ha cambiado. Cuando llegue a tu
`ListView`, realiza una comprobación `===`, y determina que los dos `ListView` son los
mismos. No ha cambiado nada, por lo que no se requiere ninguna actualización.

Una forma sencilla de actualizar tu `ListView`, es creando una nueva `List` dentro de la sección `setState()`, y copias los datos de la lista anterior a la nueva lista.
Aunque este enfoque es simple, no se recomienda para conjuntos de datos grandes,
como se muestra en el siguiente ejemplo.

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
          child: Text("Row $i")),
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

La manera recomendada, eficiente y efectiva de construir una lista, es utilizando un
ListView.Builder. Este método es excelente cuando se tiene una lista dinámica o una lista con grandes cantidades de datos. Esto es esencialmente
el equivalente de RecyclerView en Android, que automáticamente
recicla los elementos de la lista por ti.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget es la raíz de tu aplicación.
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
            }));
  }

  Widget getRow(int i) {
    return GestureDetector(
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Row $i")),
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

En lugar de crear un "ListView", crea un ListView.builder que
toma dos parámetros clave: la longitud inicial de la lista y una funcion ItemBuilder.

La función ItemBuilder es similar a la función `getView` en un adaptador Android; toma una posición y devuelve la fila que quieres que se muestre en
esa posición.

Finalmente, pero lo más importante, nota que la función `onTap()` ya no recrea la lista, sino la adiciona a ella mediante `.add`.

# Trabajar con texto

## ¿Cómo configuro fuentes personalizadas en mis widgets Text?

En el SDK de Android (a partir de Android O), creas un archivo Font resource y lo 
pasas al parámetro FontFamily para su TextView.

En Flutter, coloca el archivo de fuente en una carpeta y haz referencia a él en el archivo `pubspec.yaml`, de forma similar a como importas imágenes.

<!-- skip -->
{% prettify yaml %}
fonts:
   - family: MyCustomFont
     fonts:
       - asset: fonts/MyCustomFont.ttf
       - style: italic
{% endprettify %}

A continuación, asigna la fuente a tu widget `Text`:

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
        'This is a custom font text',
        style: TextStyle(fontFamily: 'MyCustomFont'),
      ),
    ),
  );
}
{% endprettify %}

## ¿Cómo puedo cambiar el estilo de mis widgets Text?

Junto con las fuentes, puedes personalizar otros elementos de estilo en un widget `Text`.
El parámetro de estilo de un widget `Text` toma un objeto `TextStyle`, donde puedes
personalizar muchos parámetros, como, por ejemplo:

* color
* decoration
* decorationColor
* decorationStyle
* fontFamily
* fontSize
* fontStyle
* fontWeight
* hashCode
* height
* inherit
* letterSpacing
* textBaseline
* wordSpacing

# Entrada de formulario

Para obtener más información sobre la utilización de formularios, consulta
[Recuperar el valor de un campo de texto](/cookbook/forms/retrieve-input/),
en el [Cookbook de Flutter](https://flutter.io/cookbook/).

## ¿Cuál es el equivalente a un "hint" sobre un Input?

En Flutter, puedes mostrar fácilmente un "hint" o un texto placeholder para tu entrada añadiendo un objeto InputDecoration al parámetro constructor de decoración para
el Widget Text.

<!-- skip -->
{% prettify dart %}
body: Center(
  child: TextField(
    decoration: InputDecoration(hintText: "This is a hint"),
  )
)
{% endprettify %}

## ¿Cómo puedo mostrar los errores de validación?

Al igual que lo harías con un " hint ", pasa un objeto InputDecoration
al constructor de decoración para el widget Text.

Sin embargo, no querrás empezar mostrando un error. En su lugar, cuando el usuario haya introducido datos no válidos, actualiza el estado y pasa un nuevo objeto `InputDecoration`.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget es la raíz de tu aplicación.
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
                _errorText = 'Error: This is not an email';
              } else {
                _errorText = null;
              }
            });
          },
          decoration: InputDecoration(hintText: "This is a hint", errorText: _getErrorText()),
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

    RegExp regExp = RegExp(emailRegexp);

    return regExp.hasMatch(em);
  }
}
{% endprettify %}


# Flutter plugins

## ¿Cómo accedo al sensor de GPS?

Usa el plugin de la comunidad [`geolocator`](https://pub.dartlang.org/packages/geolocator).

## ¿Cómo accedo a la cámara?

El plugin [`image_picker`](https://pub.dartlang.org/packages/image_picker) es popular para acceder a la cámara.

## ¿Cómo me autentico con Facebook?

Para iniciar sesión con Facebook, utiliza el plugin de la comunidad
[`flutter_facebook_login`](https://pub.dartlang.org/packages/flutter_facebook_login).

## ¿Cómo uso las características de Firebase?

La mayoría de las funciones de Firebase están cubiertas por
[plugins de primera parte](https://pub.dartlang.org/flutter/packages?q=firebase).
Estos plugins son integraciones de primera mano, mantenidas por el equipo de Flutter:

 * [`firebase_admob`](https://pub.dartlang.org/packages/firebase_admob) para Firebase AdMob
 * [`firebase_analytics`](https://pub.dartlang.org/packages/firebase_analytics) para Firebase Analytics
 * [`firebase_auth`](https://pub.dartlang.org/packages/firebase_auth) para Firebase Auth
 * [`firebase_database`](https://pub.dartlang.org/packages/firebase_database) para Firebase RTDB
 * [`firebase_storage`](https://pub.dartlang.org/packages/firebase_storage) para Firebase Cloud Storage
 * [`firebase_messaging`](https://pub.dartlang.org/packages/firebase_messaging) para Firebase Messaging (FCM)
 * [`flutter_firebase_ui`](https://pub.dartlang.org/packages/flutter_firebase_ui) para integraciones rápidas con Firebase Auth (Facebook, Google, Twitter y email)
 * [`cloud_firestore`](https://pub.dartlang.org/packages/cloud_firestore) para Firebase Cloud Firestore

También puedes encontrar algunos plugins Firebase de terceros en Pub que cubren áreas que no están directamente cubiertas por los plugins de primera mano.

## ¿Cómo puedo crear mis propias integraciones nativas personalizadas?

Si hay funcionalidades específicas de la plataforma que Flutter o sus plugins de la comunidad no estén disponibles, puedes construir los tuyos propios siguiendo la página [desarrollo de paquetes y plugins](/developing-packages/).

La arquitectura de los plugins de Flutter, en pocas palabras, es muy parecida a la de un bus Event en Android: tú disparas un mensaje y dejas que el receptor lo procese y te devuelva el resultado. En este caso, el receptor es código que se ejecuta en el lado nativo de Android o iOS.

## ¿Cómo utilizo el NDK en mi aplicación Flutter?

Si utilizas el NDK en tu aplicación Android actual y quieres que tu aplicación Flutter aproveche las bibliotecas nativas, es posible crear un plugin personalizado.

Tu plugin personalizado primero habla con tu aplicación Android, donde llamas a tus funciones `nativas` sobre JNI. Una vez que la respuesta esté lista, envía un mensaje a Flutter y muestra el resultado.

_Actualmente no se admite la llamada a código nativo directamente desde Flutter._

# Themes

## ¿Cómo puedo ponerle un theme a mi aplicación?

Listo para su uso, Flutter viene con una hermosa implementación de Material Design, que se encarga de un montón de necesidades de estilo y tematización que típicamente harías. A diferencia de Android, donde se declaran los themes en XML y luego se asignan
a tu aplicación usando AndroidManifest.xml, en Flutter declaras themes en el widget de nivel superior.

Para aprovechar al máximo los componentes de Material en tu aplicación, puedes declarar un widget de nivel superior `MaterialApp` como punto de entrada a tu aplicación. MaterialApp es un widget de conveniencia que incluye una serie de widgets que son comúnmente requeridos para las aplicaciones que implementan Material Design. Se basa en un WidgetsApp añadiendo funcionalidad específica de Material.

También puedes usar un `WidgetApp` como su widget de aplicación, que proporciona algunas de las mismas funcionalidades, pero no es tan completa como `MaterialApp`.

Para personalizar los colores y estilos de cualquier componente hijo, pasa un objeto 
`ThemeData` al widget `MaterialApp`. Por ejemplo, en el siguiente código, la muestra primaria se establece en azul y el color de selección de texto es rojo.

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


# Bases de datos y almacenamiento local

## ¿Cómo puedo acceder a las Preferencias Compartidas?

En Android, puedes almacenar una pequeña colección de parejas clave-valor utilizando la API de preferencias compartidas.

En Flutter, accedemos a esta funcionalidad mediante el 
[Plugin Shared_Preferences](https://pub.dartlang.org/packages/shared_preferences).
Este plugin envuelve la funcionalidad de ambas Preferencias Compartidas y
NSUserDefaults (el equivalente en iOS).

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: RaisedButton(
            onPressed: _incrementCounter,
            child: Text('Increment Counter'),
          ),
        ),
      ),
    ),
  );
}

_incrementCounter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  print('Pressed $counter times.');
  prefs.setInt('counter', counter);
}

{% endprettify %}

## ¿Cómo accedo a SQLite en Flutter?

En Android, se utiliza SQLite para almacenar datos estructurados que se pueden consultar usando SQL.

En Flutter, puedes acceder a esta función mediante el plugin 
[SQFlite](https://pub.dartlang.org/packages/sqflite).

# Notificaciones

## ¿Cómo configuro las notificaciones push?

En Android, se utiliza Firebase Cloud Messaging para configurar 
notificaciones push para tu aplicación.

En Flutter, puedes acceder a esta función mediante el plugin 
[Firebase_Messaging](https://github.com/flutter/plugins/tree/master/packages/firebase_messaging).

Para obtener más información sobre el uso de la API Firebase Cloud Messaging, consulta la documentation del plugin 
[`firebase_messaging`](https://pub.dartlang.org/packages/firebase_messaging).
