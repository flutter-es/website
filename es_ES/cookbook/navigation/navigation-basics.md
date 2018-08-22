---
layout: page
title: "Navegar a una nueva pantalla y volver"
permalink: /cookbook/navigation/navigation-basics/
---

La mayoría de las aplicaciones contienen varias pantallas para mostrar diferentes tipos de información. Por ejemplo, podríamos tener una pantalla que muestre productos. Nuestros usuarios podrían entonces pulsar un producto para obtener más información sobre él en una nueva pantalla.

En términos de Android, nuestras pantallas serían nuevas actividades. En términos de iOS, nuevos ViewControllers. ¡En Flutter, las pantallas son solo Widgets!

Entonces, ¿cómo navegamos a nuevas pantallas? ¡Usando el [`Navigator`](https://docs.flutter.io/flutter/widgets/Navigator-class.html)!

## Instrucciones

  1. Crea dos pantallas
  2. Navega a la segunda pantalla usando `Navigator.push`
  3. Regresa a la primer pantalla usando `Navigator.pop`

## 1.  Crea dos pantallas

Primero, necesitaremos dos pantallas con las que trabajar. Como este es un ejemplo básico, crearemos dos pantallas, cada una conteniendo un solo botón. Pulsando sobre el botón de la primera pantalla se navegará a la segunda. Pulsando sobre el botón de la segunda pantalla, nuestro usuario volverá a la primera!

Primero, configuraremos la estructura visual.

```dart
class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Launch screen'),
          onPressed: () {
            // Navega a la segunda pantalla cuando se pulsa!
          },
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // ¡Regresa a la primera pantalla cuando se pulsa!
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
```

## 2. Navega a la segunda pantalla usando `Navigator.push`

Para navegar a una nueva pantalla, necesitaremos usar el método 
[`Navigator.push`](https://docs.flutter.io/flutter/widgets/Navigator/push.html) 
. El método `push`  agregará una `Route` a la pila de rutas administradas por el Navegador!

El método `push` requiere una `Route`, pero ¿de dónde viene la `Route`? 
Podemos crear la nuestra, o usar el [`MaterialPageRoute`](https://docs.flutter.io/flutter/material/MaterialPageRoute-class.html). El `MaterialPageRoute` es muy práctico, ya que pasa a la nueva pantalla mediante una animación específica de la plataforma. 

En el método `build` de nuestro Widget `FirstScreen`,actualizaremos el callback `onPressed`:

<!-- skip -->
```dart
// Within the `FirstScreen` Widget
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondScreen()),
  );
}
``` 

## 3. Regresa a la primer pantalla usando `Navigator.pop`

Ahora que estamos en nuestra segunda pantalla, ¿cómo la cerramos y volvemos a la primera? ¡Usando el método [`Navigator.pop`](https://docs.flutter.io/flutter/widgets/Navigator/pop.html)! El método `pop` eliminará la `Route` actual desde la pila de rutas administradas por el navegador.

Para esta parte, necesitaremos actualizar el callback `onPressed` que se encuentra en nuestro widget `SecondScreen` 

<!-- skip -->
```dart
// Dentro del widget SecondScreen
onPressed: () {
  Navigator.pop(context);
}
```    

## Ejemplo Completo

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: FirstScreen(),
  ));
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Launch screen'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondScreen()),
            );
          },
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
```

![Navigation Basics Demo](/images/cookbook/navigation-basics.gif)
