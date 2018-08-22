---
layout: page
title: "Crear una lista básica"
permalink: /cookbook/lists/basic-list/
---

Mostrar listas de datos es un patrón fundamental para las aplicaciones móviles. ¡Flutter incluye el Widget [`ListView`](https://docs.flutter.io/flutter/widgets/ListView-class.html)
para que trabajar con listas sea muy fácil!

## Crea un ListView 

El uso del constructor estándar `ListView` es perfecto para listas que contienen solo algunos elementos. También emplearemos el Widget incorporado [`ListTile`](https://docs.flutter.io/flutter/material/ListTile-class.html) para darle a nuestros elementos una estructura visual.

<!-- skip -->
```dart
ListView(
  children: <Widget>[
    ListTile(
      leading: Icon(Icons.map),
      title: Text('Map'),
    ),
    ListTile(
      leading: Icon(Icons.photo_album),
      title: Text('Album'),
    ),
    ListTile(
      leading: Icon(Icons.phone),
      title: Text('Phone'),
    ),
  ],
);
```

## Ejemplo completo

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Basic List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Map'),
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('Album'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone'),
            ),
          ],
        ),
      ),
    );
  }
}
```

![Basic List Demo](/images/cookbook/basic-list.png)
