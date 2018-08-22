---
layout: page
title: "Devolver datos desde una pantalla"
permalink: /cookbook/navigation/returning-data/
---

En algunos casos, es posible que queramos devolver los datos de una nueva pantalla. Por ejemplo, digamos que empujamos una nueva pantalla que presenta dos opciones para un usuario. Cuando el usuario pulsa sobre una opción, queremos informar a nuestra primera pantalla de la selección del usuario para que pueda actuar sobre esa información!

¿Cómo podemos lograr esto? Usando [`Navigator.pop`](https://docs.flutter.io/flutter/widgets/Navigator/pop.html)!

## Instrucciones

  1. Define la pantalla de inicio
  2. Agrega un botón que inicie la pantalla de selección
  3. Muestra la pantalla de selección con dos botones
  4. Cuando un botón es pulsado, cierra la pantalla de selección
  5. Muestra un snackbar en la pantalla de inicio con la selección

## 1. Define la pantalla de inicio

La pantalla de inicio mostrará un botón. Cuando se pulsa, se iniciará la pantalla de selección!

<!-- skip -->
```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Returning Data Demo'),
      ),
      // Crearemos el Widget SelectionButton en el siguiente paso 
      body: Center(child: SelectionButton()),
    );
  }
}
```

## 2. Agrega un botón que inicie la pantalla de selección

Ahora, crearemos nuestro SelectionButton. Nuestro botón de selección:

  1. Iniciará SelectionScreen cuando sea pulsado
  2. Esperará por SelectionScreen para devolver un resultado

<!-- skip -->
```dart
class SelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
      child: Text('Pick an option, any option!'),
    );
  }

  // Un método que inicia SelectionScreen y espera por el resultado de
  // Navigator.pop
  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push devuelve un Future que se completará después de que llamemos
    // Navigator.pop en la pantalla de selección!
    final result = await Navigator.push(
      context,
      // Crearemos la SelectionScreen en el siguiente paso!
      MaterialPageRoute(builder: (context) => SelectionScreen()),
    );
  }
}
```

## 3. Muestra la pantalla de selección con dos botones

Ahora, necesitaremos construir una pantalla de selección! Contendrá dos botones. Cuando un usuario pulsa un botón, debe cerrar la pantalla de selección y dejar que la pantalla de inicio sepa qué botón se pulsó!

Por ahora, definiremos la IU y descubriremos cómo devolver los datos en el siguiente paso.

```dart
class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick an option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  // Pop aquí con "Yep"...
                },
                child: Text('Yep!'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  // Pop aquí con "Nope"
                },
                child: Text('Nope.'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
``` 

## 4. Cuando un botón es pulsado, cierra la pantalla de selección

Ahora, queremos actualizar la devolución de llamada `onPressed` para nuestros dos botones! Para devolver los datos a la primera pantalla, necesitaremos usar el método 
[`Navitator.pop`](https://docs.flutter.io/flutter/widgets/Navigator/pop.html).

`Navigator.pop` acepta un segundo argumento opcional llamado `result`.  Si proporcionamos un resultado, ¡será devuelto al `Future` en nuestro SelectionButton!

### Yep button

<!-- skip -->
```dart
RaisedButton(
  onPressed: () {
    // Nuestro botón Yep devolverá "Yep!" como resultado
    Navigator.pop(context, 'Yep!');
  },
  child: Text('Yep!'),
);
```

### botón Nope 

<!-- skip -->
```dart
RaisedButton(
  onPressed: () {
    // Nuestro botón Nope devolverá "Nope!" como resultado
    Navigator.pop(context, 'Nope!');
  },
  child: Text('Nope!'),
);
```

## 5. Muestra un snackbar en la pantalla de inicio con la selección

Ahora que estamos lanzando una pantalla de selección y esperando el resultado, ¡queremos hacer algo con la información que se devuelve!

En este caso, mostraremos un Snackbar que muestra el resultado. Para hacerlo, actualizaremos el método `_navigateAndDisplaySelection` en nuestro `SelectionButton`.

<!-- skip -->
```dart
_navigateAndDisplaySelection(BuildContext context) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SelectionScreen()),
  );

  // ¡Después de que la pantalla de selección devuelva un resultado, muéstralo en
  // un Snackbar!
  Scaffold.of(context).showSnackBar(SnackBar(content: Text("$result")));
}
```

## Complete example

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Returning Data',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Returning Data Demo'),
      ),
      body: Center(child: SelectionButton()),
    );
  }
}

class SelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
      child: Text('Pick an option, any option!'),
    );
  }

  // Un método que inicia SelectionScreen y espera por el resultado de
  // Navigator.pop!
  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push devuelve un Future que se completará después de que llamemos
    // Navigator.pop en la pantalla de selección!
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectionScreen()),
    );

    // ¡Después de que la pantalla de selección devuelva un resultado, muéstralo en 
    // un Snackbar!
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("$result")));
  }
}

class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick an option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  // Cierra la pantalla y regresa "Yep!" como el resultado
                  Navigator.pop(context, 'Yep!');
                },
                child: Text('Yep!'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  // Cierra la pantalla y regresa "Nope!" como el resultado
                  Navigator.pop(context, 'Nope.');
                },
                child: Text('Nope.'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
```

![Returning Data Demo](/images/cookbook/returning-data.gif)
