---
title: Anima las propiedades de un Container
next:
  title: Efectos Fade in and out en un Widget
  path: /docs/cookbook/animation/opacity-animation
---

La clase [`Container`](https://docs.flutter.io/flutter/widgets/Container-class.html) 
proporciona una manera conveniente de crer un widget con propiedades específicas: 
ancho, alto, color de fondo, padding, bordes, y más.

Las animaciones simples a menudo implican cambiar estas propiedades a lo largo del tiempo.
Por ejemplo, es posible que desees animar el color de fondo de gris a verde para indicar que el usuario ha seleccionado un elemento.

Para animar estas propiedades, Flutter proporciona el widget 
[`AnimatedContainer`](https://docs.flutter.io/flutter/widgets/AnimatedContainer-class.html). 
Al igual que el widget `Container`,` AnimatedContainer` te permite definir 
el ancho, la altura, los colores de fondo y más. Sin embargo, cuando el 
`AnimatedContainer` se reconstruye con nuevas propiedades, automáticamente 
se anima entre los valores antiguos y nuevos. En Flutter, 
estos tipos de animaciones se conocen 
como "animaciones implícitas".

Esta receta describe cómo usar un `AnimatedContainer` para animar el tamaño, 
el color de fondo y el radio del borde cuando el usuario toca un botón.

## Instrucciones

  1. Crear un widget StatefulWidget con propiedades por defecto
  2. Construir un `AnimatedContainer` usando las propiedades
  3. Iniciar la animación reconstruyendo con nuevas propiedades

## 1. Crear un widget StatefulWidget con propiedades por defecto

Para empezar, crea unas clases 
[`StatefulWidget`](https://docs.flutter.io/flutter/widgets/StatefulWidget-class.html) y 
[`State`](https://docs.flutter.io/flutter/widgets/State-class.html).
Usa la clase State personalizada para definir las propiedades que necesitas cambiar a 
lo largo del tiempo. En este ejemplo, esto incluye el ancho, alto, color, y radio del 
borde. Además, también puedes definir el valor por defecto de cada propiedad.

Estas propiedades deben pertenecer a una clase `State` personalizada para que 
puedan actualizarse cuando el usuario toca un botón.

<!-- skip -->
```dart
class AnimatedContainerApp extends StatefulWidget {
  @override
  _AnimatedContainerAppState createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {
  // Define las diferentes propiedades con valores por defecto. 
  // Actualiza estas propiedades cuando el usuario toque un FloatingActionButton.
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    // Completa esto en los siguientes pasos.
  }
}
```

## 2. Construir un `AnimatedContainer` usando las propiedades

A continuación, puedes crear el `AnimatedContainer` utilizando las propiedades 
definidas en el paso anterior. Además, debes proporcionar una propiedad `duration` 
que defina la duración de la animación.

<!-- skip -->
```dart
AnimatedContainer(
  // Define las diferentes propiedades con valores por defecto. 
  // Actualiza estas propiedades cuando el usuario toque un FloatingActionButton.
  width: _width,
  height: _height,
  decoration: BoxDecoration(
    color: _color,
    borderRadius: _borderRadius,
  ),
  // Define la duración de la animación. 
  duration: Duration(seconds: 1),
  // Proporciona una curva opcional para hacer que la animación se sienta más suave. 
  curve: Curves.fastOutSlowIn,
);
```

## 3. Iniciar la animación reconstruyendo con nuevas propiedades

Finalmente, inicia la animación reconstruyendo el `AnimatedContainer` con 
nuevas propiedades. ¿Cómo desencadenar una reconstrucción? Cuando se trata de `StatefulWidgets`, 
[`setState`] (https://docs.flutter.io/flutter/widgets/State/setState.html) 
es la solución.

Para este ejemplo, agrega un botón a la aplicación. Cuando el usuario toca el botón, actualiza 
las propiedades con un nuevo ancho, alto, color de fondo y radio de borde 
dentro de una llamada a `setState`.

En una aplicación real, la mayoría de las veces, realiza la transición entre valores fijos (por 
ejemplo, de un fondo gris a verde). Para esta aplicación, genera nuevos valores cada vez que el 
usuario toque el botón.

<!-- skip -->
```dart
FloatingActionButton(
  child: Icon(Icons.play_arrow),
  // Cuando el usuario toca el botón
  onPressed: () {
    // Usa setState para reconstruir el widget con nuevos valores.
    setState(() {
      // Crea un generador de números aleatorios.
      final random = Random();

      // Genera un ancho y alto aleatorio.
      _width = random.nextInt(300).toDouble();
      _height = random.nextInt(300).toDouble();

      // Genera un color aleatorio.
      _color = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );

      // Genera un radio de borde aleatorio.
      _borderRadius =
          BorderRadius.circular(random.nextInt(100).toDouble());
    });
  },
);
```

## Ejemplo completo

```dart
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(AnimatedContainerApp());

class AnimatedContainerApp extends StatefulWidget {
  @override
  _AnimatedContainerAppState createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {
  // Define las diferentes propiedades con valores por defecto. 
  // Actualiza estas propiedades cuando el usuario toque un FloatingActionButton.
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('AnimatedContainer Demo'),
        ),
        body: Center(
          child: AnimatedContainer(
            // Usa setState para reconstruir el widget con nuevos valores.
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: _borderRadius,
            ),
            // Define la duración de la animación. 
            duration: Duration(seconds: 1),
            // Proporciona una curva opcional para hacer que la animación se sienta más suave. 
            curve: Curves.fastOutSlowIn,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.play_arrow),
          // Cuando el usuario toca el botón
          onPressed: () {
            // Usa setState para reconstruir el widget con nuevos valores.
            setState(() {
              // Crea un generador de números aleatorios.
              final random = Random();

              // Genera un ancho y alto aleatorio.
              _width = random.nextInt(300).toDouble();
              _height = random.nextInt(300).toDouble();

              // Genera un color aleatorio.
              _color = Color.fromRGBO(
                random.nextInt(256),
                random.nextInt(256),
                random.nextInt(256),
                1,
              );

              // Genera un radio de borde aleatorio.
              _borderRadius =
                  BorderRadius.circular(random.nextInt(100).toDouble());
            });
          },
        ),
      ),
    );
  }
}
```

![AnimatedContainer demo showing a box growing and shrinking in size while changing color and border radius](/images/cookbook/animated-container.gif){:.site-mobile-screenshot}