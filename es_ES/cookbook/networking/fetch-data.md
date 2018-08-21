---
layout: page
title: "Obtener datos desde internet"
permalink: /cookbook/networking/fetch-data/
---

Obtener datos desde internet es necesario para la mayoría de las apps. Afortunadamente, Dart y 
Flutter provéen de herramientas para este tipo de trabajo!
  
## Instrucciones

  1. Añade el paquete `http`
  2. Realiza una solicitud de red usando el paquete `http`
  3. Convierte la respuesta en un objeto personalizado en Dart
  4. Obtiene y muestra los datos en Flutter
  
## 1. Añade el paquete `http`

El paquete [`http`](https://pub.dartlang.org/packages/http) proporciona la más 
simple manera de obtener datos desde internet.

Para instalar el paquete `http`, necesitamos añadir este a la sección de dependencias 
en nuestro fichero `pubspec.yaml`. Podemos [encontrar la última versión del paquete http en el sitio web de pub](https://pub.dartlang.org/packages/http#-installing-tab-).

```yaml
dependencies:
  http: <latest_version>
```
  
## 2. Realiza una solicitud de red

En este ejemplo, buscaremos una publicación de muestra de 
[JSONPlaceholder REST API](https://jsonplaceholder.typicode.com/) usado el método 
[`http.get`](https://docs.flutter.io/flutter/package-http_http/package-http_http-library.html) .

<!-- skip -->
```dart
Future<http.Response> fetchPost() {
  return http.get('https://jsonplaceholder.typicode.com/posts/1');
}
```

The `http.get` method returns a `Future` that contains a `Response`. 

  * [`Future`](https://docs.flutter.io/flutter/dart-async/Future-class.html) is 
  a core Dart class for working with async operations. It is used to represent a 
  potential value or error that will be available at some time in the future.
  * The `http.Response` class contains the data received from a successful http 
  call.  

## 3. Convert the response into a custom Dart object

While it's easy to make a network request, working with a raw 
`Future<http.Response>` isn't very convenient. To make our lives easier, we can 
convert the `http.Response` into our own Dart object.

### Create a `Post` class

First, we'll need to create a `Post` class that contains the data from our 
network request. It will also include a factory constructor that allows us to 
create a `Post` from json.

Converting JSON by hand is only one option. For more information, please see the 
full article on [JSON and serialization](/json). 

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

### Convert the `http.Response` to a `Post`

Now, we'll update the `fetchPost` function to return a `Future<Post>`. To do so,
we'll need to:

  1. Convert the response body into a json `Map` with the `dart:convert`
  package.
  2. If the server returns an "OK" response with a status code of 200, convert 
  the json `Map` into a `Post` using the `fromJson` factory.
  3. If the server returns an unexpected response, throw an error

<!-- skip -->
```dart
Future<Post> fetchPost() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}
```

Hooray! Now we've got a function that we can call to fetch a Post from the 
internet!

## 4. Fetch and Display the data

In order to fetch the data and display it on screen, we can use the
[`FutureBuilder`](https://docs.flutter.io/flutter/widgets/FutureBuilder-class.html)
widget! The `FutureBuilder` Widget comes with Flutter and makes it easy to work
with async data sources.

We must provide two parameters:

  1. The `Future` we want to work with. In our case, we'll call our
  `fetchPost()` function.
  2. A `builder` function that tells Flutter what to render, depending on the
  state of the `Future`: loading, success, or error.

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

    // By default, show a loading spinner
    return CircularProgressIndicator();
  },
);
```

## Testing

For information on how to test this functionality, please see the following 
recipes:

  * [Introduction to unit testing](/cookbook/testing/unit-test/)
  * [Mock dependencies using Mockito](/cookbook/testing/mocking/) 

## Complete example

```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
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

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
```
