---
layout: page
title: "Implementando Deslizar para Descartar"
permalink: /cookbook/gestures/dismissible/
---

El patrón "Deslizar para descartar" es común en muchas aplicaciones móviles. Por ejemplo, si estamos escribiendo una aplicación de correo electrónico, es posible que queramos  permitir que nuestros usuarios eliminen los mensajes de correo electrónico de una lista. Cuando lo hagan, querremos mover el elemento del Inbox al Trash.

Flutter facilita esta tarea al proporcionar el Widget [`Dismissible`](https://docs.flutter.io/flutter/widgets/Dismissible-class.html).

## Instrucciones

  1. Crea una lista de elementos
  2. Envuelve cada elemento en un Widget `Dismissible`
  3. Proporciona indicadores "Leave Behind"

## 1. Crea una lista de elementos

Primero, crearemos una lista de elementos que podemos eliminar. Para obtener instrucciones más detalladas sobre cómo crear una lista, siga la receta [Trabajando con listas grandes](/cookbook/lists/long-lists/).

### Crea un Data Source

En nuestro ejemplo, querremos 20 elementos de muestra para trabajar. Para hacerlo simple, generaremos una lista de Strings.

<!-- skip -->
```dart
final items = List<String>.generate(20, (i) => "Item ${i + 1}");
```

### Convierte el data source en una lista

Al principio, simplemente mostraremos cada elemento de la lista en la pantalla. ¡Los usuarios no podrán deslizar esos elementos todavía!

<!-- skip -->
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text('${items[index]}'));
  },
);
```

## 2. Envuelve cada elemento en un Widget `Dismissible`

Ahora que estamos mostrando una lista de elementos, ¡querremos ofrecer a nuestros usuarios la posibilidad de deslizar cada elemento fuera de la lista!

Después de que el usuario haya eliminado el elemento, tendremos que ejecutar un código para eliminar el elemento de la lista y mostrar un Snackbar. En una aplicación real, es posible que se deba realizar una lógica más compleja, como eliminar el elemento desde un web service o una base de datos.

¡Aquí es donde entra en juego el Widget [`Dismissible`](https://docs.flutter.io/flutter/widgets/Dismissible-class.html)!
En nuestro ejemplo, actualizaremos nuestra función `itemBuilder` 
para devolver un Widget `Dismissible` .

<!-- skip -->
```dart
Dismissible(
  // Cada Dismissible debe contener una llave. Las llaves permiten a Flutter
  // identificar de manera única los Widgets.
  key: Key(item),
  // También debemos proporcionar una función que diga a nuestra aplicación
  // qué hacer después de que un elemento ha sido eliminado.
  onDismissed: (direction) {
    // Remueve el elemento de nuestro data source.
    setState(() {
      items.removeAt(index);
    });

    // Muestra un snackbar! Este snackbar tambien podría contener acciones "Undo".
    Scaffold
        .of(context)
        .showSnackBar(SnackBar(content: Text("$item dismissed")));
  },
  child: ListTile(title: Text('$item')),
);
```

## 3. Proporciona indicadores “Leave Behind” 

Tal como está, nuestra aplicación permite a los usuarios deslizar los elementos fuera de la Lista, pero puede que no les dé una indicación visual de lo que sucede cuando lo hacen. Para indicar que estamos eliminando elementos, mostraremos el indicador "Leave Behind" mientras deslizan el elemento fuera de la pantalla. En este caso, un background rojo!

Para este propósito, proporcionaremos un parámetro `background` al `Dismissible`.

<!-- skip -->
```dart
Dismissible(
  // Muestra un background rojo a medida que el elemento se elimina
  background: Container(color: Colors.red),
  key: Key(item),
  onDismissed: (direction) {
    setState(() {
      items.removeAt(index);
    });

    Scaffold
        .of(context)
        .showSnackBar(SnackBar(content: Text("$item dismissed")));
  },
  child: ListTile(title: Text('$item')),
);
``` 

## Ejemplo completo

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// MyApp es un StatefulWidget. Nos permite actualizar el estado del Widget
// cada vez que se elimine un elemento.
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final items = List<String>.generate(3, (i) => "Item ${i + 1}");

  @override
  Widget build(BuildContext context) {
    final title = 'Dismissing Items';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Dismissible(
              // Cada Dismissible debe contener una llave. Las llaves permiten a Flutter
              // identificar de manera única los Widgets.
              key: Key(item),
              // También debemos proporcionar una función que diga a nuestra aplicación
              // qué hacer después de que un elemento ha sido eliminado.
              onDismissed: (direction) {
                // Remueve el elemento de nuestro data source.
                setState(() {
                  items.removeAt(index);
                });

                // Luego muestra un snackbar!
                Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(content: Text("$item dismissed")));
              },
              // Muestra un background rojo a medida que el elemento se elimina
              background: Container(color: Colors.red),
              child: ListTile(title: Text('$item')),
            );
          },
        ),
      ),
    );
  }
}
```

![Dismissible Demo](/images/cookbook/dismissible.gif)
