---
layout: page
title: "Creando una lista en un Grid"
permalink: /cookbook/lists/grid-lists/
---

En algunos casos, es posible que desee mostrar sus elementos como un Grid en lugar de una lista normal de elementos que vienen uno tras otro. Para esta tarea, emplearemos el 
widget [`GridView`](https://docs.flutter.io/flutter/widgets/GridView-class.html) . 

La forma más sencilla de empezar a usar grillas es usar el constructor 
[`GridView.count`](https://docs.flutter.io/flutter/widgets/GridView/GridView.count.html)
porque nos permite especificar cuántas filas o columnas queremos.

En este ejemplo, generaremos una Lista de 100 Widgets que mostrarán su índice en la lista. Esto nos ayudará a visualizar cómo funciona `GridView` .

<!-- skip -->
```dart
GridView.count(
  // Crea una grilla con 2 columnas. Si cambias el scrollDirection a 
  // horizontal, esto produciría 2 filas.
  crossAxisCount: 2,
  // Genera 100 Widgets que muestran su índice en la Lista
  children: List.generate(100, (index) {
    return Center(
      child: Text(
        'Item $index',
        style: Theme.of(context).textTheme.headline,
      ),
    );
  }),
);
```

## Ejemplo completo

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Lista Grid';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: GridView.count(
          // Crea una grilla con 2 columnas. Si cambias el scrollDirection a 
          // horizontal, esto produciría 2 filas.
          crossAxisCount: 2,
          // Genera 100 Widgets que muestran su índice en la Lista
          children: List.generate(100, (index) {
            return Center(
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.headline,
              ),
            );
          }),
        ),
      ),
    );
  }
}
```
