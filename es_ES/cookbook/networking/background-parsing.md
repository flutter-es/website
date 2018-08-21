---
layout: page
title: "Analizando un JSON en segundo plano"
permalink: /cookbook/networking/background-parsing/
---

Por defecto, las aplicaciones Dart hacen todo su trabajo en un solo hilo. En la mayoría de los casos, 
este modelo simplifica la programación y es lo suficientemente rápido para no resultar en 
un mal rendimiento de la app o en animaciones a saltos, a menudo llamadas "jank".

Sin embargo, es posible que tengamos que realizar un cálculo costoso, como analizar un 
documento JSON muy largo. Si este trabajo toma más de 16 milisegundos, nuestros 
usuarios experimentarán "jank".

Para evitar el "jank", necesitamos realizar operaciones costosas computacionalmente como esta en 
segundo plano. En Android, esto significaría programar el trabajo en un hilo diferente. 
En Flutter, podemos usar una clase [Isolate](https://docs.flutter.io/flutter/dart-isolate/Isolate-class.html)
separada.

## Instrucciones

  1. Añade el paquete `http`
  2. Haz una petición de red usando el paquete `http`
  3. Convierte la respuesta en una lista de fotos
  4. Mueve este trabajo a una clase Isolate separada
  
## 1. Añade el paquete `http`

Primero, agregaremos el paquete [`http`](https://pub.dartlang.org/packages/http) 
a nuestro proyecto. El paquete `http` hace más fácil realizar peticiones de 
red, como obtener datos desde un "JSON endpoint".

```yaml
dependencies:
  http: <latest_version>
```
  
## 2. Make a network request

En este ejemplo, obtendremos un documento JSON grande que contiene una lista de 5000 
objetos fotográficos desde la [JSONPlaceholder REST API](https://jsonplaceholder.typicode.com/) 
usando el método [`http.get`](https://docs.flutter.io/flutter/package-http_http/package-http_http-library.html). 

<!-- skip -->
```dart
Future<http.Response> fetchPhotos(http.Client client) async {
  return client.get('https://jsonplaceholder.typicode.com/photos');
}
```

Nota: Estamos proporcionando un `http.Client` a la función en este ejemplo. Esto hará
que la función sea mas fácil de probar y usar en diferentes entornos!

## 3. Analiza y convierte la respuesta en una lista de fotos

A continuación, siguiendo la guía de la receta [Obtener datos desde internet](/cookbook/networking/fetch-data/), 
queremos convertir nuestra `http.Response` en una lista de objetos Dart.
Esto facilitará trabajar con tales objetos en el futuro.

### Crea una clase `Photo`

Primero, necesitaremos crear una clase `Photo` que contenga datos acerca de una foto. 
También incluiremos un método `fromJson` del tipo factory para facilitar la creación de un objeto `Photo` 
comenzando con un objeto json.

<!-- skip -->
```dart
class Photo {
  final int id;
  final String title;
  final String thumbnailUrl;

  Photo({this.id, this.title, this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}
```

### Convierte la respuesta en un List de Photos

Ahora, actualizaremos la función `fetchPhotos` para que pueda devolver un 
`Future<List<Photo>>`. Para hacer esto, necesitaremos:

  1. Crea un método `parsePhotos` que convierta el body de la respuesta en un `List<Photo>`
  2. Usa la función `parsePhotos` en la función `fetchPhotos`

<!-- skip -->
```dart
// Una función que convertirá el body de la respuesta en un List<Photo>
List<Photo> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('https://jsonplaceholder.typicode.com/photos');

  return parsePhotos(response.body);
}
```

## 4. Mueve este trabajo a una clase Isolate separada

Si ejecutas la función `fetchPhotos` en un teléfono lento, puedes notar que la app 
se congela por un breve momento cuando esta analizando y convirtiendo el json. Esto es un jank, 
y queremos deshacernos de esto!

Entonces ¿Cómo podemos hacer esto? Moviendo el análisis y conversión a un segundo plano aislado 
usando la función [`compute`](https://docs.flutter.io/flutter/foundation/compute.html) 
proporcionada por Flutter. La función `compute` puede ejecutar costosas funciones en un 
segundo plano aislado y devolver el resultado. En este caso, queremos ejecutar 
la función `parsePhotos` en segundo plano!

<!-- skip -->
```dart
Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('https://jsonplaceholder.typicode.com/photos');

  // Usa la función compute para ejecutar parsePhotos en un isolate separado
  return compute(parsePhotos, response.body);
}
```

## Notas sobre el trabajo con Isolates

Isolates se comunican pasando mensajes de un lado a otro. Los mensajes pueden 
ser valores primitivos, como son `null`, `num`, `bool`, `double`, o `String`, o
objetos simples como es el `List<Photo>` en este ejemplo.

Puedes experimentar errores si intentas pasar objetos más complejos, como es 
un `Future` o `http.Response` entre _isolates_.

## Ejemplo completo

```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('https://jsonplaceholder.typicode.com/photos');

  // Usa la función compute para ejecutar parsePhotos en un isolate separado
  return compute(parsePhotos, response.body);
}

// Una función que convertirá el body de la respuesta en un List<Photo>
List<Photo> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Isolate Demo';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Image.network(photos[index].thumbnailUrl);
      },
    );
  }
}
```

![Isolate Demo](/images/cookbook/isolate.gif)
