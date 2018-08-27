---
layout: page
title: "Apps de Ejemplo ExpansionTile"
permalink: /catalog/samples/expansion-tile-sample/
---

ExpansionTiles se puede usar para producir listas de dos niveles o niveles múltiples

<p>
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-4">
        <div class="panel panel-default">
          <div class="panel-body" style="padding: 16px 32px;">
            <img style="border:1px solid #000000" src="https://storage.googleapis.com/flutter-catalog/cb4a54db8fb3726bf4293b9cc5cb12ce16883803/expansion_tile_sample_small.png" alt="Android screenshot" class="img-responsive">
          </div>
          <div class="panel-footer">
            Android screenshot
          </div>
        </div>
      </div>
    </div>
  </div>
</p>

Esta aplicación muestra datos jerárquicos con ExpansionTiles. Al dar Tap a un tile se expande o contrae la vista de sus hijos. Cuando un tile se colapsa, sus hijos se disponen de forma que la huella del widget de la lista sólo refleje lo que es visible.

Cuando se muestra dentro de un elemento desplazable que crea sus elementos de lista perezosamente, como una lista desplegable creada con `ListView.builder()`, ExpansionTiles
puede ser bastante eficiente, particularmente para "expandir/contraer"
listas de Material Design.

Prueba esta aplicación creando un nuevo proyecto con `flutter create` y reemplazando los contenidos de `lib/main.dart` con el código que sigue.

```dart
// Copyright 2017 The Chromium Authors. Todos los derechos reservados.
// El uso de este código fuente se rige por una licencia de estilo BSD que puede ser
// encontrada en el archivo LICENSE.

import 'package:flutter/material.dart';

class ExpansionTileSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ExpansionTile'),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              EntryItem(data[index]),
          itemCount: data.length,
        ),
      ),
    );
  }
}

// Una entrada en la lista multinivel que muestra esta app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

// Toda la lista multinivel que muestra esta app.
final List<Entry> data = <Entry>[
  Entry(
    'Chapter A',
    <Entry>[
      Entry(
        'Section A0',
        <Entry>[
          Entry('Item A0.1'),
          Entry('Item A0.2'),
          Entry('Item A0.3'),
        ],
      ),
      Entry('Section A1'),
      Entry('Section A2'),
    ],
  ),
  Entry(
    'Chapter B',
    <Entry>[
      Entry('Section B0'),
      Entry('Section B1'),
    ],
  ),
  Entry(
    'Chapter C',
    <Entry>[
      Entry('Section C0'),
      Entry('Section C1'),
      Entry(
        'Section C2',
        <Entry>[
          Entry('Item C2.0'),
          Entry('Item C2.1'),
          Entry('Item C2.2'),
          Entry('Item C2.3'),
        ],
      ),
    ],
  ),
];

// Muestra una entrada. Si la entrada tiene hijos, se muestra
// con un ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

void main() {
  runApp(ExpansionTileSample());
}
```

<h2>Ver también:</h2>
- La parte de "expandir/contraer" de la especificación de Material Design :
    <https://material.io/guidelines/components/lists-controls.html#lists-controls-types-of-list-controls>
- El código fuente en [examples/catalog/lib/expansion_tile_sample.dart](https://github.com/flutter/flutter/blob/master/examples/catalog/lib/expansion_tile_sample.dart).
