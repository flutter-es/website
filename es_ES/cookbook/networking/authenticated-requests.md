---
layout: page
title: "Creando peticiones autentificadas"
permalink: /cookbook/networking/authenticated-requests/
---

Para obtener datos de muchos web services, necesitas proporcionar 
autentificación. Hay muchas maneras para hacer esto, pero tal vez la más común 
requiere el uso del encabezado HTTP `Authorization`.

## Añade el encabezado Authorization

El paquete [`http`](https://pub.dartlang.org/packages/http) provée una manera 
conveniente de agregar cabeceras a tus peticiones. También puedes aprovechar el 
paquete `dart:io` para `HttpHeaders` comunes.

<!-- skip -->
```dart
Future<http.Response> fetchPost() {
  return http.get(
    'https://jsonplaceholder.typicode.com/posts/1',
    // Envia headers de autentificación a tu backend
    headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"},
  );
}
```

## Ejemplo completo

Este ejemplo se basa en la receta [Obtener datos desde internet](/cookbook/networking/fetch-data/).

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response = await http.get(
    'https://jsonplaceholder.typicode.com/posts/1',
    headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"},
  );
  final responseJson = json.decode(response.body);

  return Post.fromJson(responseJson);
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
```
