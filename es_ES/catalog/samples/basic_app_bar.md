---
layout: page
title: "Conceptos básicos de AppBar"
permalink: /catalog/samples/basic-app-bar/
---

Una AppBar típica con un título, acciones y un menú desplegable de desbordamiento.

<p>
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-4">
        <div class="panel panel-default">
          <div class="panel-body" style="padding: 16px 32px;">
            <img style="border:1px solid #000000" src="https://storage.googleapis.com/flutter-catalog/cb4a54db8fb3726bf4293b9cc5cb12ce16883803/basic_app_bar_small.png" alt="Android screenshot" class="img-responsive">
          </div>
          <div class="panel-footer">
            Android screenshot
          </div>
        </div>
      </div>
    </div>
  </div>
</p>

Una app que muestra una de media docena de opciones con un icono y un título. Las dos opciones más comunes están disponibles como botones de acción y las opciones restantes se incluyen en el menú desplegable de desbordamiento.

Prueba esta app creando un nuevo proyecto con `flutter create` y reemplazando los contenidos de `lib/main.dart` con el código que sigue.

```dart
// Copyright 2017 The Chromium Authors. Todos los derechos reservados.
// El uso de este código fuente se rige por una licencia de estilo BSD que puede ser
// encontrada en el archivo LICENSE.

import 'package:flutter/material.dart';

// Esta aplicación es un stateful, rastrea la elección actual del usuario.
class BasicAppBarSample extends StatefulWidget {
  @override
  _BasicAppBarSampleState createState() => _BasicAppBarSampleState();
}

class _BasicAppBarSampleState extends State<BasicAppBarSample> {
  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Basic AppBar'),
          actions: <Widget>[
            // botón de acción
            IconButton(
              icon: Icon(choices[0].icon),
              onPressed: () {
                _select(choices[0]);
              },
            ),
            // botón de acción
            IconButton(
              icon: Icon(choices[1].icon),
              onPressed: () {
                _select(choices[1]);
              },
            ),
            // menú de desbordamiento
            PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.skip(2).map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ChoiceCard(choice: _selectedChoice),
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(BasicAppBarSample());
}
```

<h2>Ver también:</h2>
- La sección "Layout-Structure" de la especificación Material Design:
    <https://material.io/guidelines/layout/structure.html#structure-app-bar>
- El código fuente en [examples/catalog/lib/basic_app_bar.dart](https://github.com/flutter/flutter/blob/master/examples/catalog/lib/basic_app_bar.dart).
