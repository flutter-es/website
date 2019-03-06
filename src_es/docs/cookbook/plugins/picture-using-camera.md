---
title: Toma una imagen usando la Camera
prev:
  title: Reproducir y pausar un video
  path: /docs/cookbook/plugins/play-video
next:
  title: Introducción a los test de integración
  path: /docs/cookbook/testing/integration/introduction
---

Muchas aplicaciones requieren trabajar con las cámaras del dispositivo para tomar fotos y videos.
Flutter proporciona el plugin [`camera`](https://pub.dartlang.org/packages/camera)
para este propósito. El plugin `camera` proporciona herramientas para obtener una lista de las
cámaras disponibles, mostrar una vista previa que viene de una cámara específica, y tomar
fotos o videos.

Esta receta demuestra cómo usar el plugin `camera` para mostrar una vista previa, 
tomar una foto y mostrarla.

## Indicaciones

  1. Añadir las dependencias necesarias
  2. Obtén una lista de las cámaras disponibles
  3. Crear e inicializar el `CameraController`.
  4. Usa un `CameraPreview` para mostrar el feed de la cámara.
  5. Toma una foto con el `CameraController`.
  6. Muestra la imagen con un widget `Image`.

## 1. Añadir las dependencias necesarias

Para completar esta receta, necesitas añadir tres dependencias a tu aplicación:

  - [`camera`](https://pub.dartlang.org/packages/camera) - Proporciona herramientas para trabajar con las cámaras del dispositivo
  - [`path_provider`](https://pub.dartlang.org/packages/path_provider) - Encuentra las rutas correctas para almacenar imágenes
  - [`path`](https://pub.dartlang.org/packages/path) - Crea rutas que funcionan en cualquier plataforma

```yaml
dependencies:
  flutter:
    sdk: flutter
  camera:
  path_provider:
  path:
```

## 2. Obtén una lista de las cámaras disponibles

A continuación, puedes obtener una lista de las cámaras disponibles utilizando el plugin `camera`.

<!-- skip -->
```dart
// Obtén una lista de las cámaras disponibles en el dispositivo.
final cameras = await availableCameras();

// Obtén una cámara específica de la lista de cámaras disponibles
final firstCamera = cameras.first; 
```

## 3. Crear e inicializar el `CameraController`.

Una vez que tengas una cámara para trabajar, deberás crear e inicializar un `CameraController`. Este 
proceso establece una conexión con la cámara del dispositivo que le permite controlar la cámara 
y mostrar una vista previa de la alimentación de la cámara.

Para lograrlo, por favor:

  1. Crear un `StatefulWidget` con un compañero `State`
  2. Añade una variable a la clase `State` para almacenar el `CameraController`.
  3. Añade una variable a la clase `State` para almacenar el `Future` devuelto desde `CameraController.initialize`
  4. Crear e inicializar el controlador en el método `initState`
  5. Elimine el controlador en el método `dispose`

<!-- skip -->
```dart
// Una pantalla que contiene una lista de cámaras y el directorio para almacenar imágenes.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  // Añada dos variables a la clase de estado para almacenar el CameraController 
  // y el futuro
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Para visualizar la salida actual de la cámara, es necesario crear
    // un CameraController.
    _controller = CameraController(
      // Obtén una cámara específica de la lista de cámaras disponibles
      widget.camera,
      // Define la resolución a utilizar
      ResolutionPreset.medium,
    );

    // A continuación, debes inicializar el controlador. Esto devolverá un Futuro
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Asegúrate de eliminar el controlador cuando se elimine el Widget.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Llenaras esto en los siguientes pasos
  }
}
```

{{site.alert.warning}}
Si no inicializas el `CameraController`, *no* podrás trabajar con
la cámara.
{{site.alert.end}}

## 4. Usa un `CameraPreview` para mostrar el feed de la cámara

A continuación, puedes utilizar el widget `CameraPreview` del paquete `camera` 
para mostrar una vista previa de la alimentación de la cámara.

Recuerda: Debes esperar hasta que el controlador haya terminado de inicializar 
antes de trabajar con la cámara. Por lo tanto, debes esperar a que 
el `_initializeControllerFuture` creado en el paso anterior se complete 
antes de mostrar una `CameraPreview`.

Puede utilizar un [`FutureBuilder`](https://docs.flutter.io/flutter/widgets/FutureBuilder-class.html) 
exactamente para este propósito.

<!-- skip -->
```dart
// Debes esperar hasta que el controlador se inicialice antes de mostrar la vista previa de la cámara. 
// Utiliza un FutureBuilder para mostrar un spinner de carga hasta que 
// el controlador haya terminado de inicializar.
FutureBuilder<void>(
  future: _initializeControllerFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      // Si el Futuro esta completo, mostrar vista previa
      return CameraPreview(_controller);
    } else {
      // De lo contrario, mostrar el indicador de cargando
      return Center(child: CircularProgressIndicator());
    }
  },
)
```

## 5. Tomar una foto con el `CameraController`.

También puedes usar el `CameraController` para tomar fotos usando el método 
[`takePicture`](https://pub.dartlang.org/documentation/camera/latest/camera/CameraController/takePicture.html). 
En este ejemplo, crearas un `FloatingActionButton` que tome una foto usando 
el `CameraController` cuando un usuario toque el botón.

Para guardar una imagen se necesitan 3 pasos:

  1. Asegúrate de que la cámara esté inicializada
  2. Construir una ruta que defina dónde se guardará la imagen
  3. Utilizar el controlador para tomar una fotografía y guardar el resultado en la ruta
  
Es una buena práctica envolver estas operaciones en un bloque `try / catch` para poder manejar cualquier error que pueda ocurrir.

<!-- skip -->
```dart
FloatingActionButton(
  child: Icon(Icons.camera_alt),
  // Agrega un callback onPressed
  onPressed: () async {
    // Toma la foto en un bloque de try / catch. Si algo sale mal, 
    // atrapa el error.
    try {
      // Asegúrate que tu cámara esta inicializada
      await _initializeControllerFuture;

      // Construye la ruta donde la imagen se guardará
      // usando el plugin `path`.
      final path = join(
        // En este ejemplo, guarde la imagen en el directorio temporal. Encuentra 
        // el directorio temporal usando el plugin `path_provider`.
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      // Intenta tomar una foto y registrar donde se ha guardado
      await _controller.takePicture(path);
    } catch (e) {
      // Si se produce un error, regístralo en la consola.
      print(e);
    }
  },
)
```

## 6. Muestra la imagen con un widget `Imagen`

Si tomas la foto con éxito, puedes mostrar la imagen guardada utilizando 
un widget `Image`. En este caso, la imagen se almacenará como un archivo 
en el dispositivo.

Por lo tanto, debes proporcionar un `Archivo` al constructor `Image.file`. Puedes 
crear una instancia de la clase `File` pasando la ruta 
que creaste en el paso anterior.

<!-- skip -->
```dart
Image.file(File('path/to/my/picture.png'))
```

## Ejemplo Completo

```dart
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  // Obtén una lista de las cámaras disponibles en el dispositivo.
  final cameras = await availableCameras();

  // Obtén una cámara específica de la lista de cámaras disponibles
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pasa la cámara correcta al widget de TakePictureScreen
        camera: firstCamera,
      ),
    ),
  );
}

// Una pantalla que permite a los usuarios tomar una fotografía utilizando una cámara determinada.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Para visualizar la salida actual de la cámara, es necesario 
    // crear un CameraController.
    _controller = CameraController(
      // Obtén una cámara específica de la lista de cámaras disponibles
      widget.camera,
      // Define la resolución a utilizar
      ResolutionPreset.medium,
    );

    // A continuación, debes inicializar el controlador. Esto devolverá un futuro!
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Asegúrate de deshacerte del controlador cuando se deshaga del Widget.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture!')),
      // Debes esperar hasta que el controlador se inicialice antes de mostrar la vista previa 
      // de la cámara. Utiliza un FutureBuilder para mostrar un spinner de carga 
      // hasta que el controlador haya terminado de inicializar.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Si el Futuro está completo, muestra la vista previa
            return CameraPreview(_controller);
          } else {
            // De lo contrario, muestra un indicador de carga
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Agrega un callback onPressed
        onPressed: () async {
          // Toma la foto en un bloque de try / catch. Si algo sale mal, 
          // atrapa el error.
          try {
            // Ensure the camera is initialized
            await _initializeControllerFuture;

            // Construye la ruta donde la imagen debe ser guardada usando 
            // el paquete path.
            final path = join(

              // 
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved
            await _controller.takePicture(path);
            // En este ejemplo, guarda la imagen en el directorio temporal. Encuentra 
            // el directorio temporal usando el plugin `path_provider`.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            // Si se produce un error, regístralo en la consola.
            print(e);
          }
        },
      ),
    );
  }
}

// Un Widget que muestra la imagen tomada por el usuario
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // La imagen se almacena como un archivo en el dispositivo. Usa el 
      // constructor `Image.file` con la ruta dada para mostrar la imagen
      body: Image.file(File(imagePath)),
    );
  }
}
```
