---
layout: page
title: "Construyendo un formulario con validaciones"
permalink: /cookbook/forms/validation/
---

Las aplicaciones a menudo requieren que los usuarios ingresen información en un campo de texto. Por ejemplo, podríamos estar trabajando en una aplicación que requiera que nuestros usuarios inicien sesión con una combinación de dirección de correo electrónico y contraseña.

Para que nuestras aplicaciones sean seguras y fáciles de usar, podemos verificar si la información que el usuario ha proporcionado es válida. Si el usuario completó correctamente el formulario, podemos procesar la información. Si el usuario envía información incorrecta, podemos mostrar un mensaje de error amistoso para informarle qué fue lo que salió mal.

En este ejemplo, veremos cómo agregar validación a un formulario con un solo campo de texto. 

## Instrucciones

  1. Crea una `Form` con un `GlobalKey`
  2. Agrega un `TextFormField` con lógica de validación
  3. Crea un botón para validar y enviar el formulario

## 1. Crea una `Form` con un `GlobalKey`

Primero, necesitaremos un [`Form`](https://docs.flutter.io/flutter/widgets/Form-class.html) para trabajar. El Widget `Form`  actúa como un contenedor para agrupar y validar múltiples campos de formulario.

Cuando creamos el formulario, también debemos proporcionar una [`GlobalKey`](https://docs.flutter.io/flutter/widgets/GlobalKey-class.html). 
Esto identificará de manera única el `Form` con el que estamos trabajando y nos permitirá validar el formulario en un paso posterior. 

<!-- skip -->
```dart
// Define un widget de formulario personalizado
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define una clase de estado correspondiente. Esta clase contendrá los datos
// relacionados con el formulario.
class MyCustomFormState extends State<MyCustomForm> {
  // Crea una clave global que identificará de manera única el widget Form 
  // y nos permita validar el formulario
  //
  // Nota: Esto es un `GlobalKey<FormState>`, no un GlobalKey<MyCustomFormState>! 
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Cree un widget Form usando el _formKey que creamos anteriormente
    return Form(
      key: _formKey,
      child: // Construiremos esto en los siguientes pasos!
    );
  }
}
```

## 2. Agrega un `TextFormField` con lógica de validación

Tenemos nuestro `Form` en su lugar, pero no hemos proporcionado una forma para que nuestros usuarios ingresen texto. Este es el trabajo de un [`TextFormField`](https://docs.flutter.io/flutter/material/TextFormField-class.html).
El Widget `TextFormField`  nos da una entrada de texto de material design y sabe cómo mostrar los errores de validación cuando se producen.

¿Cómo podemos validar la entrada? Proporcionando una función `validator` para 
`TextFormField`. Si hay un error con la información que el usuario ha proporcionado, la función `validator` debe devolver un `String` que contenga un mensaje de error. Si no hay errores, la función no debe devolver nada.

En este ejemplo, crearemos un `validator` que asegure que el `TextFormField`
no esté vacío. Si lo está, ¡devolveremos un mensaje de error amigable!

<!-- skip -->
```dart
TextFormField(
  // El validator recibe el texto que el usuario ha digitado
  validator: (value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
  },
);
```

## 3. Crea un botón para validar y enviar el formulario

Ahora que tenemos un formulario con un campo de texto, tendremos que proporcionar un botón que el usuario pueda pulsar para enviar la información. 

Cuando el usuario intente enviar el formulario, necesitaremos verificar si el formulario es válido. Si es así, mostraremos un mensaje de éxito. Si el campo de texto no tiene contenido, desearemos mostrar el mensaje de error.

<!-- skip -->
```dart
RaisedButton(
  onPressed: () {
    // Validate devolverá true si el formulario es válido, o false si
    // el formulario no es válido.
    if (_formKey.currentState.validate()) {
      // Si el formulario es válido, muestre un snackbar. En el mundo real, a menudo
      // desea llamar a un servidor o guardar la información en una base de datos
      Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text('Processing Data')));
    }
  },
  child: Text('Submit'),
);
```

### How does this work?

Para validar el formulario, necesitaremos usar el `_formKey` creado en el paso 1. Podemos usar el método `_formKey.currentState` para acceder a 
[`FormState`](https://docs.flutter.io/flutter/widgets/FormState-class.html),
que Flutter crea automáticamente cuando creamos un `Form`. 

La clase `FormState` contiene el método `validate`. Cuando se llama al método `validate`, ejecutará la función `validator` para cada campo de texto en formulario. 
Si todo se ve bien, el método devuelve `true`. Si algún campo de texto contiene errores, mostrará el mensaje de error para cada campo de texto no válido y devolverá 
`false`.

## Ejemplo completo

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

// Crea un Widget Form
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Crea una clase State correspondiente. Esta clase contendrá los datos relacionados con
// el formulario.
class MyCustomFormState extends State<MyCustomForm> {
  // Crea una clave global que identificará de manera única el widget Form
  // y nos permita validar el formulario
  //
  // Nota: Esto es un GlobalKey<FormState>, no un GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Crea un widget Form usando el _formKey que creamos anteriormente
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // devolverá true si el formulario es válido, o falso si
                // el formulario no es válido.
                if (_formKey.currentState.validate()) {
                  // Si el formulario es válido, queremos mostrar un Snackbar
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
```

![Form Validation Demo](/images/cookbook/form-validation.gif)
