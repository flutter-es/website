---
layout: page
title: "Manejando cambios en un campo de texto"
permalink: /cookbook/forms/text-field-changes/
---

En algunos casos, puede ser útil ejecutar una función callback cada vez que cambia el texto en un campo de texto. Por ejemplo, es posible que deseemos crear una pantalla de búsqueda con la funcionalidad de autocompletar. En este caso, quisiéramos actualizar los resultados a medida que el usuario escribe.

¿Cómo podemos ejecutar una función callback cada vez que cambia el texto? Con Flutter, tenemos dos opciones:

  1. Proporciona un `onChanged` callback a un `TextField`
  2. Usa un `TextEditingController`

## 1. Proporciona un `onChanged` callback a un `TextField`

El enfoque más simple es proporcionar un 
[`onChanged`](https://docs.flutter.io/flutter/material/TextField/onChanged.html) 
callback a un 
[`TextField`](https://docs.flutter.io/flutter/material/TextField-class.html). 
Siempre que el texto cambie, se invocará el callback. Una desventaja de este enfoque es que no funciona con Widgets `TextFormField` .

En este ejemplo, imprimiremos el valor actual del campo de texto en la consola cada vez que cambie el texto.

<!-- skip -->
```dart
TextField(
  onChanged: (text) {
    print("First text field: $text");
  },
);
```

## 2. Usa un `TextEditingController`

Un enfoque más poderoso, pero más elaborado, es suministrar un
[`TextEditingController`](https://docs.flutter.io/flutter/widgets/TextEditingController-class.html)
como propiedad del 
[`controller`](https://docs.flutter.io/flutter/material/TextField/controller.html)
de `TextField` o de un `TextFormField`.

Para recibir una notificación cuando el texto cambie, podemos escuchar al controlador usando su método 
[`addListener`](https://docs.flutter.io/flutter/foundation/ChangeNotifier/addListener.html).

### Instrucciones

  - Crea un `TextEditingController`
  - Proporciona el `TextEditingController` a un `TextField`
  - Crea una función para imprimir el último valor
  - Escucha al controlador por cambios

### Crea un `TextEditingController`

Primero, necesitaremos crear un `TextEditingController`. En los pasos siguientes, suministraremos el `TextEditingController` a un `TextField`. Una vez que hayamos conectado estas dos clases juntas, podremos escuchar los cambios en el campo de texto.

<!-- skip -->
```dart
// Define un Widget de formulario personalizado
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define una clase de estado correspondiente. Esta clase contendrá los datos relacionados
// con nuestro formulario.
class _MyCustomFormState extends State<MyCustomForm> {
  // Crea un controlador de texto. Lo usaremos para recuperar el valor actual 
  // del TextField!
  final myController = TextEditingController();

  @override
  void dispose() {
    // Limpia el controlador cuando el widget se elimine del árbol de widgets
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lo completaremos en el siguiente paso!
  }
}
```

Nota: Por favor recuerda hacer el `dispose` al `TextEditingController` cuando ya no sea necesario. Esto asegurará que descartemos cualquier recurso utilizado por el objeto.

### Proporciona el `TextEditingController` a un `TextField`

Para funcionar, el `TextEditingController` se debe suministrar a un 
`TextField` o a un `TextFormField`. Una vez que está conectado, podemos comenzar a escuchar los cambios en el campo de texto. 

<!-- skip -->
```dart
TextField(
  controller: myController,
);
```

### Crea una función para imprimir el último valor

Ahora, necesitaremos una función que debería ejecutarse cada vez que cambie el texto. En este ejemplo, crearemos un método que imprime el valor actual del campo de texto.

Este método vivirá dentro de nuestra clase `_MyCustomFormState` .

<!-- skip -->
```dart
_printLatestValue() {
  print("Second text field: ${myController.text}");
}
```

### Escucha al controlador por cambios

Finalmente, tenemos que escuchar el `TextEditingController` y ejecutar el método 
`_printLatestValue`  cada vez que el texto cambie. Utilizaremos el método 
[`addListener`](https://docs.flutter.io/flutter/foundation/ChangeNotifier/addListener.html)  para lograr esta tarea.

En este ejemplo, comenzaremos a escuchar los cambios cuando se inicializa la clase 
`_MyCustomFormState` , y dejaremos de escuchar cuando se elimine 
`_MyCustomFormState` .

<!-- skip -->
```dart
class _MyCustomFormState extends State<MyCustomForm> {
  @override
  void initState() {
    super.initState();

    // Comienza a escuchar los cambios 
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Deja de escuchar los cambios de texto
    myController.removeListener(_printLatestValue);
    
    // Limpie el controlador cuando el widget se elimine del árbol de widgets
    myController.dispose();
    super.dispose();
  }
}
```

## Ejemplo completo

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retrieve Text Input',
      home: MyCustomForm(),
    );
  }
}

// Define un widget de formulario personalizado
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define una clase de estado correspondiente. Esta clase contendrá los datos relacionados 
// con nuestro formulario.
class _MyCustomFormState extends State<MyCustomForm> {
  // Crea un controlador de texto. Lo usaremos para recuperar el valor actual
  // del TextField!
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el widget se elimine del árbol de widgets
    myController.removeListener(_printLatestValue);
    myController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    print("Second text field: ${myController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (text) {
                print("First text field: $text");
              },
            ),
            TextField(
              controller: myController,
            ),
          ],
        ),
      ),
    );
  }
}
```
