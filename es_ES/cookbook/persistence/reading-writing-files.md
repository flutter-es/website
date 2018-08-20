---
layout: page
title: "Leyendo y Escribiendo Archivos"
permalink: /cookbook/persistence/reading-writing-files/
---

En algunos casos, puede ser útil leer y escribir archivos en el disco. Esto puede 
ser usado para conservar los datos en los lanzamientos de la aplicación o descargar 
datos de Internet y guardarlos para su posterior uso fuera de línea.

Para guardar archivos en el disco, necesitaremos combinar el plugin
[`path_provider`](https://pub.dartlang.org/packages/path_provider) con 
la biblioteca [`dart:io`](https://docs.flutter.io/flutter/dart-io/dart-io-library.html).

  
## Instrucciones

  1. Encuentra la ruta local correcta
  2. Crea una referencia a la ubicación del archivo
  3. Escriba datos en el archivo
  4. Lea datos del archivo
  
## 1. Encuentra la ruta local correcta

En este ejemplo, mostraremos un contador. Cuando el contador cambia, queremos escribir 
datos en el disco para que podamos volver a leerlos cuando se cargue la aplicación. Por 
lo tanto, debemos preguntarnos: ¿Dónde deberíamos almacenar esta información?

El plugin [`path_provider`](https://pub.dartlang.org/packages/path_provider) 
proporciona una forma independiente de la plataforma para acceder a las ubicaciones de 
uso común en el sistema de archivos del dispositivo. El complemento actualmente admite 
el acceso a dos ubicaciones del sistema de archivos:

  * *Directorio temporal:* Un directorio temporal (caché) que el sistema puede borrar 
  en cualquier momento. En iOS, este corresponde al valor que 
  [`NSTemporaryDirectory()`](https://developer.apple.com/reference/foundation/1409211-nstemporarydirectory) 
  retorna. En Android, este es el valor que 
  [`getCacheDir()`](https://developer.android.com/reference/android/content/Context.html#getCacheDir()) 
  retorna.
  * *Directorio documentos:* Un directorio para que la aplicación almacene archivos 
  a los que solo puede acceder. El sistema borra el directorio solo cuando se elimina 
  la aplicación. En iOS, esto corresponde a `NSDocumentDirectory`. En Android, este 
  es el directorio `AppData`.
  
En nuestro caso, ¡queremos almacenar información en el directorio de documentos! 
Podemos encontrar la ruta al directorio de documentos de esta manera:
  
<!-- skip -->
```dart
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  
  return directory.path;
}
```

## 2. Crea una referencia a la ubicación del archivo

Una vez que sepamos dónde almacenar el archivo, tendremos que crear una referencia a la 
ubicación completa del archivo. Podemos usar la clase [`File`](https://docs.flutter.io/flutter/dart-io/File-class.html) 
de la biblioteca [dart:io](https://docs.flutter.io/flutter/dart-io/dart-io-library.html) para lograr esto.

<!-- skip -->
```dart
Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}
```

## 3. Escribir datos en el archivo

Ahora que tenemos un archivo `File` para trabajar, ¡podemos usarlo para leer y escribir datos! 
Primero, escribiremos algunos datos en el archivo. Como estamos trabajando con un contador, 
simplemente almacenaremos el número entero como una cadena.

<!-- skip -->
```dart
Future<File> writeCounter(int counter) async {
  final file = await _localFile;
  
  // Write the file
  return file.writeAsString('$counter');
}
``` 

## 4. Leer datos del archivo

¡Ahora que tenemos algunos datos en el disco, podemos leerlo! Una vez más, usaremos la clase 
`File` para hacerlo.

<!-- skip -->
```dart
Future<int> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file
    String contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If we encounter an error, return 0
    return 0;
  }
}
``` 

## Pruebas

Para probar el código que interactúa con los archivos, tendremos que simular llamadas al 
`MethodChannel`. El `MethodChannel` es la clase que usa Flutter para comunicarse con la 
plataforma anfitrion.

En nuestras pruebas, no podemos interactuar con el sistema de archivos en un dispositivo. 
¡Tendremos que interactuar con el sistema de archivos de nuestro entorno de prueba!

Para simular la llamada al método, podemos proporcionar una función `setupAll` en nuestro 
archivo de prueba. Esta función se ejecutará antes de que se ejecuten las pruebas.

<!-- skip -->
```dart
setUpAll(() async {
  // Create a temporary directory to work with
  final directory = await Directory.systemTemp.createTemp();
  
  // Mock out the MethodChannel for the path_provider plugin
  const MethodChannel('plugins.flutter.io/path_provider')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    // If we're getting the apps documents directory, return the path to the
    // temp directory on our test environment instead.
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      return directory.path;
    }
    return null;
  });
});
``` 

## Ejemplo completo

```dart
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: FlutterDemo(storage: CounterStorage()),
    ),
  );
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If we encounter an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class FlutterDemo extends StatefulWidget {
  final CounterStorage storage;

  FlutterDemo({Key key, @required this.storage}) : super(key: key);

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  int _counter;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() async {
    setState(() {
      _counter++;
    });

    // write the variable as a string to the file
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading and Writing Files')),
      body: Center(
        child: Text(
          'Button tapped $_counter time${_counter == 1 ? '' : 's'}.',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```
