---
title: Reproducir y pausar un video
prev:
  title: Almacenando datos clave-valor en disco
  path: /docs/cookbook/persistence/key-value
next:
  title: Toma una imagen usando la Camera
  path: /docs/cookbook/plugins/picture-using-camera
---

Reproducir videos es una tarea común en el desarrollo de aplicaciones, y las aplicaciones de Flutter no son la excepción. Para reproducir videos, el equipo de Flutter proporciona el complemento [`video_player`](https://pub.dartlang.org/packages/video_player). Puedes usar el complemento `video_player` tanto para reproducir videos almacenados en el sistema de archivos, como un asset, o desde internet.

En iOS, el complemento `video_player` hace uso de [`AVPlayer`](https://developer.apple.com/documentation/avfoundation/avplayer) para manejar la reproducción. En Android, utiliza [`ExoPlayer`](https://google.github.io/ExoPlayer/).

Este cookbook muestra cómo usar el paquete `video_player` para transmitir un video desde internet con los controles básicos de reprodución y pausa.

## Instrucciones

  1. Añadir la dependencia `video_player`
  2. Agrega permisos a tu aplicación
  3. Crear e inicializar un `VideoPlayerController`
  4. Mostrar el reproductor de video
  5. Reproducir y pausar el video

## 1.Añadir la dependencia `video_player`

Este cookbook depende de un complemento: `video_player`. Primero, agrega esta dependecia a tu `pubspec.yaml`.

```yaml
dependencies:
  flutter:
    sdk: flutter
  video_player:
```

## 2. Agrega permisos a tu aplicación

A continuación, debes asegurarte de que tu aplicación tenga los permisos correctos para transmitir videos desde internet. Para ello, actualiza tus configuraciones de  `android` y `ios`.

### Android

Agrega el siguiente permiso a `AndroidManifest.xml` justo después de la definición `<application>`. El `AndroidManifest.xml` se puede encontrar en `<project root>/android/app/src/main/AndroidManifest.xml`

<!-- skip -->
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application ...>
        
    </application>

    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>
```

### iOS

FParaor iOS, debe agregar lo siguiente a su archivo `Info.plist` que se encuentra en `<project root>/ios/Runner/Info.plist`. 

<!-- skip -->
```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

{{site.alert.warning}}
El complemento `video_player` no funciona en simuladores iOS. Debes probar los videos en dispositivos iOS reales.
{{site.alert.end}}

## 3. Crear e inicializar un `VideoPlayerController`

Ahora que tienes el complemento `video_player` instalado con los permisos correctos, necesitas crear un archivo `VideoPlayerController`. La clase
`VideoPlayerController` te permite conectarte a diferentes tipos de vídeos y controlar la repoducción.

Antes de poder reproducir videos, tambien debe `inicializar` el controlador. Esto establecerá la conexión al video y preparará el controlador para la reproducción.

Para crear una inicialización del `VideoPlayerController`, por favor:

  1. Crear una clase `StatefulWidget` con una clase `State` 
  2. Agrega una variable a la clase `State` para almacenar el `VideoPlayerController`
  3. Agrega una variable a la clase `State` para almacenar los datos `Future` devueltos desde `VideoPlayerController.initialize`
  4. Crear e inicializar el controlador en el método `initState`
  5. Desechar el controlador en el método `dispose`
  
<!-- skip -->
```dart
class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Crear y almacenar el VideoPlayerController. El VideoPlayerController
    // ofrece distintos constructores diferentes para reproducir videos desde assets, archivos,
    // o internet.
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    super.initState();
  }

  @override
  void dispose() {
    // Asegúrate de despachar el VideoPlayerController para liberar los recursos
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Muestra el video en el siguiente paso
  }
}
```

## 4. Mostrar el reproductor de video

Ahora es el momento de mostrar el video. El complemento `video_player` proporciona el Widget [`VideoPlayer`](https://pub.dartlang.org/documentation/video_player/latest/video_player/VideoPlayer-class.html) para mostrar el video inicializado por el `VideoPlayerController`. Por defecto, el Widget `VideoPlayer` ocupará tanto espacio como sea posible. Esto a menudo no es ideal para videos porque están diseñados para mostrarse en una resolución de aspecto específica, como 16x9 o 4x3.

Por lo tanto, puedes envolver el Widget `VideoPlayer` en un Widget [`AspectRatio`](https://docs.flutter.io/flutter/widgets/AspectRatio-class.html) para asegurarte de que el video tenga las proporciones correctas.

Además, debes mostrar el Widget `VideoPlayer` después de que `_initializeVideoPlayerFuture` finalice. Puedes usar un `FutureBuilder` para mostrar un spinner de carga hasta que finalice la inicialización. Nota: la inicialización del controlador no comienza la reproducción.

<!-- skip -->
```dart
// Usa un FutureBuilder para visualizar un spinner de carga mientras espera a que
// la inicialización de VideoPlayerController finalice.
FutureBuilder(
  future: _initializeVideoPlayerFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      // Si el VideoPlayerController ha finalizado la inicialización, usa
      // los datos que proporciona para limitar la relación de aspecto del VideoPlayer
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        // Usa el Widget VideoPlayer para mostrar el video
        child: VideoPlayer(_controller),
      );
    } else {
      // Si el VideoPlayerController todavía se está inicializando, muestra un
      // spinner de carga
      return Center(child: CircularProgressIndicator());
    }
  },
)
```

## 5. Reproducir y pausar el video

Por defecto, el video se mostrará en estado de pausa. Para inicial la reproducción, llama al método [`play`](https://pub.dartlang.org/documentation/video_player/latest/video_player/VideoPlayerController/play.html) proporcionado por `VideoPlayerController`. para pausar la reproducción, llama al método [`pause`](https://pub.dartlang.org/documentation/video_player/latest/video_player/VideoPlayerController/pause.html).

Para este ejemplo, agrega un `FloatingActionButton` a su aplicación que muestre un icono de reproducción o pausa según la situación. Cuando el usuario toque el botón, reproduzca el video si etá actualmente pausado, o pause el video si está reproduciendo.

<!-- skip -->
```dart
FloatingActionButton(
  onPressed: () {
    // Envuelve la reproducción o pausa en una llamada a `setState`. Esto asegurará 
    // que se muestra el icono correcto
    setState(() {
      // Si el video se está reproduciendo, pausalo.
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        // Si el video está pausado, reprodúcelo
        _controller.play();
      }
    });
  },
  // Muestra el icono correcto dependiendo del estado del video.
  child: Icon(
    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
  ),
)
``` 
 
## Ejemplo completo

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Crear y almacenar el VideoPlayerController. El VideoPlayerController
    // ofrece distintos constructores diferentes para reproducir videos desde assets, archivos,
    // o internet.
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    // Inicializa el controlador y almacena el Future para utilizarlo luego
    _initializeVideoPlayerFuture = _controller.initialize();

    // Usa el controlador para hacer un bucle en el video
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Asegúrate de despachar el VideoPlayerController para liberar los recursos
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Butterfly Video'),
      ),
      // Usa un FutureBuilder para visualizar un spinner de carga mientras espera a que
      // la inicialización de VideoPlayerController finalice.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Si el VideoPlayerController ha finalizado la inicialización, usa
            // los datos que proporciona para limitar la relación de aspecto del VideoPlayer
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Usa el Widget VideoPlayer para mostrar el video
              child: VideoPlayer(_controller),
            );
          } else {
            // Si el VideoPlayerController todavía se está inicializando, muestra un
            // spinner de carga
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Envuelve la reproducción o pausa en una llamada a `setState`. Esto asegurará 
          // que se muestra el icono correcto
          setState(() {
            // Si el video se está reproduciendo, pausalo.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // Si el video está pausado, reprodúcelo
              _controller.play();
            }
          });
        },
        // Muestra el icono correcto dependiendo del estado del video.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ), // Esta coma final hace que el formateo automático sea mejor para los métodos de compilación.
    );
  }
}
```
