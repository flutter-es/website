---
layout: page
title: "Creando listas con elementos de diferentes tipos"
permalink: /cookbook/lists/mixed-list/
---

A menudo necesitamos crear listas que muestren diferentes tipos de contenido. Por ejemplo, podríamos estar trabajando en una Lista que muestra un encabezado seguido de algunos elementos relacionados con el encabezado, seguido de otro encabezado, y así sucesivamente.

¿Cómo crearíamos una estructura así con Flutter?

## Instrucciones

  1. Crea una fuente de datos con diferentes tipos de elementos
  2. Convierte la fuente de datos en una Lista de Widgets

## 1. Crea una fuente de datos con diferentes tipos de elementos

### Tipos de Elementos

Para representar diferentes tipos de elementos en una Lista, necesitaremos definir una clase para cada tipo de elemento.

En este ejemplo, trabajaremos en una aplicación que muestra un encabezado seguido de cinco mensajes. Por lo tanto, crearemos tres clases: `ListItem`, `HeadingItem`, 
y `MessageItem`.

<!-- skip -->
```dart
// La clase base para los diferentes tipos de elementos que la Lista puede contener
abstract class ListItem {}

// Un ListItem que contiene datos para mostrar un encabezado
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);
}

// Un ListItem que contiene datos para mostrar un mensaje
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);
}
```

### Crea una Lista de Elementos

La mayoría de las veces, buscamos datos de Internet o de una base de datos local y los convertimos en una lista de elementos.
 
Para este ejemplo, generaremos una lista de elementos para trabajar. La lista contendrá un encabezado seguido de cinco mensajes. Limpie, repita.

<!-- skip -->
```dart
final items = List<ListItem>.generate(
  1200,
  (i) => i % 6 == 0
      ? HeadingItem("Encabezado $i")
      : MessageItem("Remitente $i", "Cuerpo del Mensaje $i"),
);
```

## 2. Convierta la fuente de datos en una Lista de Widgets

Para poder convertir cada elemento en un Widget, emplearemos el constructor 
[`ListView.builder`](https://docs.flutter.io/flutter/widgets/ListView/ListView.builder.html)
.

En general, queremos proporcionar una función `builder` que verifique con qué tipo de elemento estamos tratando, y devuelva el Widget apropiado para ese tipo de elemento.

En este ejemplo, utilizar la palabra clave `is` para comprobar el tipo de elemento con el que estamos tratando puede ser útil. Es rápido, y automáticamente lanzará cada elemento al tipo apropiado. ¡Sin embargo, hay diferentes maneras de abordar este problema si usted prefiere otro patrón!

<!-- skip -->
```dart
ListView.builder(
  // Deje que ListView sepa cuántos elementos necesita para construir
  itemCount: items.length,
  // Proporcione una función de constructor. ¡Aquí es donde sucede la magia! Vamos a
  // convertir cada elemento en un Widget basado en el tipo de elemento que es.
  itemBuilder: (context, index) {
    final item = items[index];

    if (item is HeadingItem) {
      return ListTile(
        title: Text(
          item.heading,
          style: Theme.of(context).textTheme.headline,
        ),
      );
    } else if (item is MessageItem) {
      return ListTile(
        title: Text(item.sender),
        subtitle: Text(item.body),
      );
    }
  },
);
```

## Ejemplo completo

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(
    items: List<ListItem>.generate(
      1000,
      (i) => i % 6 == 0
          ? HeadingItem("Encabezado $i")
          : MessageItem("Remitente $i", "Cuerpo del Mensaje $i"),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final List<ListItem> items;

  MyApp({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Lista Mixta';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          // Deje que ListView sepa cuántos elementos necesita para construir
          itemCount: items.length,
          // Proporcione una función de constructor. ¡Aquí es donde sucede la magia! Vamos a
          // convertir cada elemento en un Widget basado en el tipo de elemento que es.
          itemBuilder: (context, index) {
            final item = items[index];

            if (item is HeadingItem) {
              return ListTile(
                title: Text(
                  item.heading,
                  style: Theme.of(context).textTheme.headline,
                ),
              );
            } else if (item is MessageItem) {
              return ListTile(
                title: Text(item.sender),
                subtitle: Text(item.body),
              );
            }
          },
        ),
      ),
    );
  }
}

// La clase base para los diferentes tipos de elementos que la Lista puede contener
abstract class ListItem {}

// Un ListItem que contiene datos para mostrar un encabezado
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);
}

// Un ListItem que contiene datos para mostrar un mensaje
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);
}
```

![Mixed List Demo](/images/cookbook/mixed-list.png)
