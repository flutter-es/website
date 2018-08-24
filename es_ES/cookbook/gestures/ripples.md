---
layout: page
title: "Añadiendo efecto ripple de Material Touch"
permalink: /cookbook/gestures/ripples/
---

Mientras  diseñamos una aplicación que debería seguir las directrices de Material Design, queremos agregar la animación ripple a los Widgets cuando se pulsen. 

Flutter proporciona el widget [`InkWell`](https://docs.flutter.io/flutter/material/InkWell-class.html) para lograr este efecto.

## Instrucciones

  1. Crea un Widget que deseemos pulsar
  2. Envuélvelo en un widget `InkWell` para administrar los tap callbacks y las animaciones ripple 
 
<!-- skip -->
```dart
// El InkWell envuelve nuestro widget flat button personalizado
InkWell(
  // Cuando el usuario pulsa el button, muestra un snackbar
  onTap: () {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Tap'),
    ));
  },
  child: Container(
    padding: EdgeInsets.all(12.0),
    child: Text('Flat Button'),
  ),
);
```   

## Ejemplo completo

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'InkWell Demo';

    return MaterialApp(
      title: title,
      home: MyHomePage(title: title),
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
      body: Center(child: MyButton()),
    );
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // El InkWell envuelve nuestro widget flat button personalizado
    return InkWell(
      // Cuando el usuario pulsa el button, muestra un snackbar
      onTap: () {
        Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Tap'),
            ));
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Text('Flat Button'),
      ),
    );
  }
}
```

![Ripples Demo](/images/cookbook/ripples.gif)
