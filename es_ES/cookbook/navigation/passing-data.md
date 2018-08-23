---
layout: page
title: "Enviar datos a una nueva pantalla"
permalink: /cookbook/navigation/passing-data/
---

A menudo, no solo queremos navegar a una nueva pantalla, sino también pasar algunos datos a la pantalla. Por ejemplo, a menudo queremos pasar información acerca del elemento que hemos pulsado.

Recuerda: las pantallas son Sólo Widgets&trade;. En este ejemplo, crearemos una 
lista de tareas pendientes. Cuando se pulsa sobre una tarea pendiente, navegaremos a una nueva pantalla (Widget) que muestra información sobre dicha tarea pendiente.

## Instrucciones

  1. Define una clase Todo 
  2. Muestra una lista de objetos Todos
  3. Crea una pantalla detalle que pueda mostrar información sobre una tarea pendiente
  4. Navega y pasa datos a la pantalla detalle

## 1. Define una clase Todo

Primero, necesitaremos una forma simple de representar los objetos Todos. Para este ejemplo, crearemos una clase que contenga dos datos: el título y la descripción.

<!-- skip -->
```dart
class Todo {
  final String title;
  final String description;

  Todo(this.title, this.description);
}
```

## 2. Muestra una lista de objetos Todos

En segundo lugar, queremos mostrar una lista de objetos Todos. En este ejemplo, generaremos 20 tareas pendientes y las mostraremos usando una ListView. Para obtener más información sobre cómo trabajar con Lists, por favor consulta la receta [`Crear una lista básica`](/cookbook/lists/basic-list/).

### Genera la Lista de objetos Todos

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

### Muestra una Lista de objetos Todos usando una ListView

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

Hasta aquí todo bien. ¡Generaremos 20 objetos Todos y los exhibiremos en una ListView!

## 3. Crea una pantalla detalle que pueda mostrar información sobre una tarea pendiente

Ahora, crearemos nuestra segunda pantalla. El título de la pantalla contendrá el título de la tarea pendiente, y el cuerpo de la pantalla mostrará la descripción.

Dado que es un widget normal `StatelessWidget`, simplemente necesitaremos que los usuarios que creen la pantalla pasen a través de un objeto `Todo`! Luego, construiremos un UI usando el objeto Todo dado.

<!-- skip -->
```dart
class DetailScreen extends StatelessWidget {
  //Declara un campo que contenga la clase Todo
  final Todo todo;

  // En el constructor, se requiere el objeto Todo
  DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usa el objeto Todo para crear nuestra UI
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

## 4. Navega y pasa datos a la pantalla detalle

Con nuestra `DetailScreen` en su lugar, ¡estamos listos para realizar la Navigation! En nuestro caso, queremos navegar a `DetailScreen` cuando un usuario pulse en una tarea pendiente de nuestra lista. Cuando lo hagamos, también queremos pasar la tarea pendiente a `DetailScreen`. 

Para lograr esto, escribiremos un callback [`onTap`](https://docs.flutter.io/flutter/material/ListTile/onTap.html) 
 para nuestro Widget `ListTile` . Dentro de nuestro callback `onTap` , una vez más emplearemos el método [`Navigator.push`](https://docs.flutter.io/flutter/widgets/Navigator/push.html).

<!-- skip -->
```dart
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
      // Cuando un usuario pulsa en el ListTile, navega al DetailScreen.
      // Tenga en cuenta que no solo estamos creando un DetailScreen, 
      // también le pasamos el objeto Todo actual!
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
              'A description of what needs to be done for Todo $i',
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
            // también le pasamos el objeto Todo actual!
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
  // Declara un campo que contenga el objeto Todo
  final Todo todo;

  // En el constructor, se requiere un objeto Todo
  DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usa el objeto Todo para crear nuestra UI
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
