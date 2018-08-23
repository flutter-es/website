---
layout: page
title: "Obtener el valor de un campo de texto"
permalink: /cookbook/forms/retrieve-input/
---

En esta receta, veremos cómo recuperar el texto que un usuario ha escrito en un campo de texto.

## Instrucciones

  1. Crea un `TextEditingController`
  2. Proporciona el `TextEditingController` a un `TextField`
  3. Muestra el valor actual del campo de texto

## 1. Crea un `TextEditingController`

Para recuperar el texto que un usuario ha digitado en un campo de texto, necesitamos crear un [`TextEditingController`](https://docs.flutter.io/flutter/widgets/TextEditingController-class.html).
Luego proporcionaremos `TextEditingController` a un `TextField` en los siguientes pasos.

Una vez que se proporciona un `TextEditingController` a un `TextField` o `TextFormField`,
podemos usarlo para recuperar el texto que un usuario ha digitado en ese campo de texto.

Nota: También es importante hacer el `dispose` del `TextEditingController` cuando hayamos terminado de usarlo. Esto asegurará que descartemos cualquier recurso utilizado por el objeto.

<!-- skip -->
```dart
// Define un widget de formulario personalizado
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define la clase State correspondiente. Esta clase contendrá los datos relacionados con
// nuestro formulario.
class _MyCustomFormState extends State<MyCustomForm> {
  // Crea un controlador de texto. Lo usaremos para recuperar el valor actual
  // del TextField!
  final myController = TextEditingController();

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ¡Lo completaremos en el siguiente paso!
  }
}
```

## 2. Proporciona el `TextEditingController` a un `TextField`

Ahora que tenemos un `TextEditingController` para trabajar, tenemos que conectarlo a un  campo de texto específico. Para hacer esto, proporcionaremos el Widget `TextEditingController` 
a un `TextField` o `TextFormField`  como propiedad del `controller` .

<!-- skip -->
```dart
TextField(
  controller: myController,
);
```

## 3. Muestra el valor actual del campo de texto

Después de que hayamos proporcionado el `TextEditingController` a nuestro campo de texto, ¡podemos empezar a leer valores! Usaremos el método [`text`](https://docs.flutter.io/flutter/widgets/TextEditingController/text.html) 
proporcionado por el `TextEditingController` para recuperar el String de texto que el usuario haya digitado en el campo de texto.

En este ejemplo, mostraremos un cuadro de diálogo de alerta con el valor actual del campo de texto cuando el usuario pulsa un botón de acción flotante.  

<!-- skip -->
```dart
FloatingActionButton(
  // Cuando el usuario pulsa el botón, muestra un diálogo de alerta con el
  // texto que el usuario ha digitado en nuestro campo de texto.
  onPressed: () {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Recupera el texto que el usuario ha digitado utilizando nuestro
          // TextEditingController
          content: Text(myController.text),
        );
      },
    );
  },
  tooltip: 'Show me the value!',
  child: Icon(Icons.text_fields),
);
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

// Define la clase State correspondiente. Esta clase contendrá los datos relacionados con
// nuestro formulario.
class _MyCustomFormState extends State<MyCustomForm> {
  // Crea un controlador de texto. Lo usaremos para recuperar el valor actual
  // del TextField!
  final myController = TextEditingController();

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Cuando el usuario pulsa el botón, muestra un diálogo de alerta con el
        // texto que el usuario ha digitado en nuestro campo de texto.
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Recupera el texto que el usuario ha digitado utilizando nuestro
                // TextEditingController
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}
```

![Retrieve Text Input Demo](/images/cookbook/retrieve-input.gif)
