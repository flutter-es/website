---
layout: page
title: Animando un Widget entre pantallas
permalink: /cookbook/navigation/hero-animations/
---

A menudo es útil guiar a los usuarios a través de nuestras aplicaciones mientras navegan de pantalla en pantalla. Una técnica común para guiar a los usuarios a través de una aplicación es animar un widget de una pantalla a la siguiente. Esto crea un anclaje visual que conecta las dos pantallas.

¿Cómo podemos animar un widget de una pantalla a la siguiente con Flutter? ¡Usando el Widget [`Hero`](https://docs.flutter.io/flutter/widgets/Hero-class.html)!  

## Instrucciones

  1. Crea dos pantallas que muestren la misma imagen
  2. Agrega un Widget `Hero` a la primera pantalla
  3. Agrega un widget `Hero` a la segunda pantalla

## 1. Crea dos pantallas que muestren la misma imagen

En este ejemplo, mostraremos la misma imagen en ambas pantallas. Quisiéramos animar la imagen desde la primera pantalla hasta la segunda pantalla cuando el usuario pulse la imagen. Por ahora, crearemos la estructura visual y manejaremos las animaciones en los próximos pasos!

*Nota:* Este ejemplo se basa en las recetas
[Navegar a una nueva pantalla y volver](/cookbook/navigation/navigation-basics/) 
y [Manejando pulsos ](/cookbook/gestures/handling-taps/). 

```dart
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DetailScreen();
          }));
        },
        child: Image.network(
          'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg',
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.network(
            'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg',
          ),
        ),
      ),
    );
  }
}
```

## 2.  Agrega un Widget `Hero` a la primera pantalla

Para conectar las dos pantallas junto con una animación, debemos ajustar el widget `Image` en ambas pantallas en un Widget `Hero`. El Widget `Hero` requiere dos argumentos:

  1. `tag`: Un objeto que identifica al `Hero`. Debe ser el mismo en ambas pantallas.
  2. `child`: El widget que queremos animar a través de las pantallas.
  
<!-- skip -->
```dart
Hero(
  tag: 'imageHero',
  child: Image.network(
    'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg',
  ),
);
```  

## 3. Agrega un widget `Hero` a la segunda pantalla

Para completar la conexión con la primera pantalla, también debemos envolver la `Image` en la segunda pantalla con un Widget `Hero`. Debe usar la misma etiqueta que la primer pantalla.

Después de aplicar el Widget `Hero` a la segunda pantalla, ¡la animación entre pantallas funcionará!

<!-- skip -->
```dart
Hero(
  tag: 'imageHero',
  child: Image.network(
    'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg',
  ),
);
```

Nota: ¡este código es idéntico al que teníamos en la primera pantalla! En general, puedes crear un Widget reutilizable en lugar de repetir el código, pero para este ejemplo, duplicaremos el código para fines de demostración.

## Ejemplo completo

```dart
import 'package:flutter/material.dart';

void main() => runApp(HeroApp());

class HeroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transition Demo',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: GestureDetector(
        child: Hero(
          tag: 'imageHero',
          child: Image.network(
            'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg',
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DetailScreen();
          }));
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg',
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
```

![Hero Demo](/images/cookbook/hero.gif)