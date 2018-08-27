---
layout: page
title: "Obtener datos desde internet"
permalink: /cookbook/networking/fetch-data/
---

Obtener datos desde internet es necesario para la mayoría de las apps. Afortunadamente, Dart y 
Flutter provéen de herramientas para este tipo de trabajo!
  
## Instrucciones

  1. Añade el paquete `http`
  2. Realiza una petición de red usando el paquete `http`
  3. Convierte la respuesta en un objeto personalizado en Dart
  4. Obtiene y muestra los datos con Flutter
  
## 1. Añade el paquete `http`

El paquete [`http`](https://pub.dartlang.org/packages/http) proporciona la más 
simple manera de obtener datos desde internet.

Para instalar el paquete `http`, necesitamos añadir este a la sección de dependencias 
en nuestro fichero `pubspec.yaml`. Podemos [encontrar la última versión del paquete http en el sitio web de pub](https://pub.dartlang.org/packages/http#-installing-tab-).

```yaml
dependencies:
  http: <latest_version>
```
  
## 2. Realiza una petición de red

En este ejemplo, buscaremos un Post de muestra de 
[JSONPlaceholder REST API](https://jsonplaceholder.typicode.com/) usando el método 
[`http.get`](https://docs.flutter.io/flutter/package-http_http/package-http_http-library.html) .

<!-- skip -->
```dart
Future<http.Response> fetchPost() {
  return http.get('https://jsonplaceholder.typicode.com/posts/1');
}
```

El método `http.get` devuelve un `Future` que contiene un `Response`. 

  * [`Future`](https://docs.flutter.io/flutter/dart-async/Future-class.html) es 
  una clase del core de Dart para trabajar con operaciones asíncronas. Es usado para representar un 
  valor potencial o un error que estará disponible en algún momento en el futuro.
  * La clase `http.Response` contiene los datos recibidos en una llamada http satisfactoria.  

## 3. Convierte la respuesta en un objeto personalizado de Dart

Mientras que es fácil realizar una petición de red, trabajar con un 
`Future<http.Response>` crudo no es muy conveniente. Para hacer nuestra vida más sencilla, podemos 
convertir la `http.Response` en nuestro propio objeto Dart.

### Crea una clase `Post`

Primero, necesitaremos crear una clase `Post` que contiene los datos de nuestra 
petición de red. También incluirá un constructor factory que nos permite 
crear un `Post` desde un json.

Convertir JSON a mano es solo una opción. Para más información, por favor vea el 
artículo completo en [JSON y serialización](/json). 

<!-- skip -->
```dart
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
```

### Convierte la `http.Response` en un `Post`

Ahora, actualizaremos la función `fetchPost` para devolver un `Future<Post>`. Para hacerlo,
necesitaremos:

  1. Convertir el body de la respuesta en un `Map` json con el paquete `dart:convert`.

  2. Si el servidor devuelve una respuesta "OK" con un status code de 200, convierte 
  el `Map` json en un `Post` usando el método `fromJson` de tipo factory.
  3. Si el servidor devuelve una respuesta inesperada, lanza un error

<!-- skip -->
```dart
Future<Post> fetchPost() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // Si el servidor devuelve una repuesta OK, parseamos el JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // Si esta respuesta no fue OK, lanza un error.
    throw Exception('Failed to load post');
  }
}
```

Hurra! Ahora tenemos una función a la que podemos llamar para obtener un Post desde internet!

## 4. Obtén y muestra los datos con Flutter

Para obtener los datos y mostrarlos en la pantalla, podemos usar el widget 
[`FutureBuilder`](https://docs.flutter.io/flutter/widgets/FutureBuilder-class.html)! 
El widget `FutureBuilder` viene con Flutter y hace que sea fácil trabajar 
con fuentes de datos asíncronas.

Debemos proporcionar dos parámetros:

  1. El `Future` con el que queremos trabajar. En nuestro caso, llamaremos a nuestra 
  función `fetchPost()`.
  2. Una función `builder` que dice a Flutter que reproducir, dependiendo del 
  estado del `Future`: loading, success, o error.

<!-- skip -->
```dart
FutureBuilder<Post>(
  future: fetchPost(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text(snapshot.data.title);
    } else if (snapshot.hasError) {
      return Text("${snapshot.error}");
    }

    // Por defecto, muestra un loading spinner
    return CircularProgressIndicator();
  },
);
```

## Pruebas

Para más información sobre como probar esta funcionalidad, por favor vea la siguiente receta:

  * [Introducción a las pruebas unitarias](/cookbook/testing/unit-test/)
  * [Simular dependencias usando Mockito](/cookbook/testing/mocking/) 

## Ejemplo completo

```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // Si el servidor devuelve una repuesta OK, analizaremos el JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // Si esta respuesta no fue OK, lanza un error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: fetchPost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // Por defecto, muestra un loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
```
