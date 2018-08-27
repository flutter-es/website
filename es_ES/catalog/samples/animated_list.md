---
layout: page
title: "AnimatedList"
permalink: /catalog/samples/animated-list/
---

Un AnimatedList que muestra una lista de tarjetas que permanecen sincronizadas con un
ListModel específico de la aplicación. Cuando se añade o se elimina un elemento del modelo, la tarjeta correspondiente se anima dentro o fuera de la vista.

<p>
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-4">
        <div class="panel panel-default">
          <div class="panel-body" style="padding: 16px 32px;">
            <img style="border:1px solid #000000" src="https://storage.googleapis.com/flutter-catalog/cb4a54db8fb3726bf4293b9cc5cb12ce16883803/animated_list_small.png" alt="Android screenshot" class="img-responsive">
          </div>
          <div class="panel-footer">
            Android screenshot
          </div>
        </div>
      </div>
    </div>
  </div>
</p>

Tap a un elemento para seleccionarlo, tap de nuevo para deseleccionarlo. Tap '+' para insertar en el elemento seleccionado, '-' para eliminar el elemento seleccionado. Los manejadores de tap agregan o eliminan elementos de un `ListModel<E>`, una simple encapsulación de `List<E>` que mantiene la AnimatedList sincronizada. El modelo de lista tiene una GlobalKey para su lista animada. Utiliza la key para llamar a los métodos insertItem y removeItem definidos por AnimatedListState.

Prueba esta aplicación creando un nuevo proyecto con `flutter create` y reemplazando los contenidos de `lib/main.dart` con el código que sigue.

```dart
// Copyright 2017 The Chromium Authors. Todos los derechos reservados.
// El uso de este código fuente se rige por una licencia de estilo BSD que puede ser
// encontrada en el archivo LICENSE.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnimatedListSample extends StatefulWidget {
  @override
  _AnimatedListSampleState createState() => _AnimatedListSampleState();
}

class _AnimatedListSampleState extends State<AnimatedListSample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ListModel<int> _list;
  int _selectedItem;
  int _nextItem; // El siguiente elemento insertado cuando el usuario pulsa el botón '+'.

  @override
  void initState() {
    super.initState();
    _list = ListModel<int>(
      listKey: _listKey,
      initialItems: <int>[0, 1, 2],
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = 3;
  }

  // Se usa para crear elementos de lista que no se han eliminado.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
    );
  }

  // Se usa para construir un elemento después de que ha sido eliminado de la lista.
  // Este método es necesario porque un elemento eliminado permanece visible hasta
  // que se haya completado su animación (aunque haya desaparecido en lo que concierne
  // a este ListModel). El widget será utilizado por el parámetro [AnimatedListState.removeItem]
  // del método [AnimatedListRemovedItemBuilder].
  Widget _buildRemovedItem(
      int item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      selected: false,
      // No hay detector de gestos aquí: no queremos que los elementos eliminados sean interactivos.
    );
  }

  // Inserta el "siguiente elemento" en el modelo de lista.
  void _insert() {
    final int index =
        _selectedItem == null ? _list.length : _list.indexOf(_selectedItem);
    _list.insert(index, _nextItem++);
  }

  // Elimina el elemento seleccionado del modelo de lista.
  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem));
      setState(() {
        _selectedItem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AnimatedList'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: _insert,
              tooltip: 'insert a new item',
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: _remove,
              tooltip: 'remove the selected item',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _list.length,
            itemBuilder: _buildItem,
          ),
        ),
      ),
    );
  }
}

/// Mantiene un Dart List sincronizado con un AnimatedList.
///
/// Los métodos [insert] y [removeAt] aplican tanto a la lista interna como a
/// lista animada que pertenece a [listKey].
///
/// Esta clase solo expone tanto de la Dart List API como lo que necesita el
/// ejemplo de la app. Es fácil añadir más métodos de lista; sin embargo, los métodos
/// que mutan la lista deben realizar los mismos cambios en la lista animada en términos de
/// [AnimatedListState.insertItem] y [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index,
          (BuildContext context, Animation<double> animation) {
        return removedItemBuilder(removedItem, context, animation);
      });
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

/// Muestra su ítem entero como 'item N' sobre una Card cuyo color se basa en
/// el valor del elemento. El texto se muestra en verde brillante si la selección
/// es verdadera. La altura de este widget se basa en el parámetro de animación,
/// varía de 0 a 128 ya que la animación varía de 0.0 to 1.0.
class CardItem extends StatelessWidget {
  const CardItem(
      {Key key,
      @required this.animation,
      this.onTap,
      @required this.item,
      this.selected: false})
      : assert(animation != null),
        assert(item != null && item >= 0),
        assert(selected != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final int item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.display1;
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: 128.0,
            child: Card(
              color: Colors.primaries[item % Colors.primaries.length],
              child: Center(
                child: Text('Item $item', style: textStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(AnimatedListSample());
}
```

<h2>Ver también:</h2>
- La sección "Components-Lists: Controls" de la especificación de Material Design:
    <https://material.io/guidelines/components/lists-controls.html#>
- El código fuente en [examples/catalog/lib/animated_list.dart](https://github.com/flutter/flutter/blob/master/examples/catalog/lib/animated_list.dart).
