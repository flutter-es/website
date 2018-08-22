---
layout: page
title: "Enviar datos a una nueva pantalla"
permalink: /cookbook/navigation/passing-data/
---

A menudo, no solo queremos navegar a una nueva pantalla, sino también pasar algunos datos a la pantalla. Por ejemplo, a menudo queremos pasar información acerca del elemento que hemos pulsado.

Recuerda: las pantallas son Just Widgets&trade;. En este ejemplo, crearemos una 
lista de pendientes. Cuando se pulsa un pendiente, navegaremos a una nueva pantalla (Widget) que muestra información sobre dicho pendiente.

## Instrucciones

  1. Define una clase Todo 
  2. Muestra una Lista de Todos
  3. Crea una Pantalla Detalle que pueda mostrar información sobre un pendiente
  4. Navega y pasa datos a la Pantalla Detalle

## 1. Define una clase Todo

Primero, necesitaremos una forma simple de representar Todos. Para este ejemplo, crearemos una clase que contenga dos datos: el título y la descripción.

<!-- skip -->
```dart
class Todo {
  final String title;
  final String description;

  Todo(this.title, this.description);
}
```

## 2. Muestra una List de Todos

En segundo lugar, queremos mostrar una lista de Todos. En este ejemplo, generaremos 20 pendientes y los mostraremos usando una ListView. Para obtener más información sobre cómo trabajar con Lists, por favor consulta la receta [`Basic List`](/cookbook/lists/basic-list/).

### Genera la Lista de Todos

<!-- skip -->
```dart
final todos = List<Todo>.generate(
  20,
  (i) => Todo(
        'Todo $i',
        'Una descripción de lo que se debe hacer para Todo $i',
      ),
);
```

### Muestra una Lista de Todos usando una ListView

<!-- skip -->
```dart
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
    );
  },
);
```

Hasta aquí todo bien. ¡Generaremos 20 Todos y los exhibiremos en un ListView!

## 3. Crea una Pantalla Detalle que pueda mostrar información sobre un pendiente

Ahora, crearemos nuestra segunda pantalla. El título de la pantalla contendrá el título del pendiente, y el cuerpo de la pantalla mostrará la descripción.

Dado que es un widget normal `StatelessWidget`, simplemente necesitaremos que los usuarios que creen la pantalla pasen a través de un `Todo`! Luego, construiremos un UI usando el Todo dado.

<!-- skip -->
```dart
class DetailScreen extends StatelessWidget {
  //Declara un campo que contenga el Todo
  final Todo todo;

  // En el constructor, se requiere un Todo
  DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usa el Todo para crear nuestra UI
    return Scaffold(
      appBar: AppBar(
        title: Text("${todo.title}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('${todo.description}'),
      ),
    );
  }
}
``` 

## 4. Navega y pasa datos a la Pantalla Detalle

Con nuestra `DetailScreen` en su lugar, ¡estamos listos para realizar la navegación! En nuestro caso, queremos navegar a `DetailScreen` cuando un usuario pulse en un Todo de nuestra lista. Cuando lo hagamos, también queremos pasar el Todo a `DetailScreen`.  

Para lograr esto, escribiremos un [`onTap`](https://docs.flutter.io/flutter/material/ListTile/onTap.html) 
callback para nuestro Widget `ListTile` . Dentro de nuestro `onTap` callback, una vez más emplearemos el método [`Navigator.push`](https://docs.flutter.io/flutter/widgets/Navigator/push.html).

<!-- skip -->
```dart
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
      // Cuando un usuario pulsa en el ListTile, navega al DetailScreen.
      // Tenga en cuenta que no solo estamos creando un DetailScreen, 
      // también le pasamos el pendiente actual!
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(todo: todos[index]),
          ),
        );
      },
    );
  },
);
```      

## Ejemplo completo

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Todo {
  final String title;
  final String description;

  Todo(this.title, this.description);
}

void main() {
  runApp(MaterialApp(
    title: 'Passing Data',
    home: TodosScreen(
      todos: List.generate(
        20,
        (i) => Todo(
              'Todo $i',
              'Una descripción de lo que se debe hacer para Todo $i',
            ),
      ),
    ),
  ));
}

class TodosScreen extends StatelessWidget {
  final List<Todo> todos;

  TodosScreen({Key key, @required this.todos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
            // Cuando un usuario pulsa en el ListTile, navega al DetailScreen.
            // Tenga en cuenta que no solo estamos creando un DetailScreen,
            // también le pasamos el pendiente actual!
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(todo: todos[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  // Declara un campo que contenga el Todo
  final Todo todo;

  // En el constructor, se requiere un Todo
  DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usa el Todo para crear nuestra UI
    return Scaffold(
      appBar: AppBar(
        title: Text("${todo.title}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('${todo.description}'),
      ),
    );
  }
}
```

![Passing Data Demo](/images/cookbook/passing-data.gif)
