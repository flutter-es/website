---
layout: page
title: "Efectos Fade in and out en un Widget"
permalink: /cookbook/animation/opacity-animation/
---

Como desarrolladores de UI, a menudo necesitamos mostrar y ocultar elementos en pantalla. Sin embargo, los elementos que aparecen y desaparecen rápidamente de la pantalla pueden resultar molestos para los usuarios finales. En su lugar, a los elementos les podemos aplicar un fade con una animación de opacidad para crear una experiencia suave.

En Flutter, podemos lograr esta tarea usando el widget [`AnimatedOpacity`](https://docs.flutter.io/flutter/widgets/AnimatedOpacity-class.html).

## Instrucciones

  1. Muestra una cuadro para realizar el fade in and out
  2. Define un `StatefulWidget`
  3. Muestra un botón que alterne la visibilidad
  4. Al cuadro, aplícale el Fade in and out
  
## 1. Crea un cuadro para realizar el fade in and out

Primero, necesitaremos algo para realizar el fade in and out! En este ejemplo, dibujaremos un cuadro verde en la pantalla.

<!-- skip -->
```dart
Container(
  width: 200.0,
  height: 200.0,
  color: Colors.green,
);
```

## 2. Define un `StatefulWidget`

Ahora que tenemos un cuadro verde para animar, necesitaremos una forma de saber si el cuadro debe ser visible o invisible. Para lograr esto, podemos usar un widget 
[`StatefulWidget`](https://docs.flutter.io/flutter/widgets/StatefulWidget-class.html).

Un `StatefulWidget` es una clase que crea un objeto `State`. El objeto `State` 
contiene algunos datos sobre nuestra aplicación y proporciona una forma de actualizar esos datos. Cuando actualizamos los datos, también podemos pedirle a Flutter que reconstruya nuestra UI con esos cambios.

En nuestro caso, tendremos un dato: un booleano que representa si el botón es visible o invisible. 

Para construir un `StatefulWidget`, necesitamos crear dos clases: Una clase 
`StatefulWidget` y la clase correspondiente `State`. Consejo profesional: Los plugins Flutter para Android Studio y VSCode incluyen el snippet `stful`  para generar rápidamente este código!

<!-- skip -->
```dart
// El trabajo de StatefulWidget es tomar algunos datos y crear una clase State.
// En este caso, nuestro Widget toma un título y crea un _MyHomePageState.
class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// La clase State es responsable de dos cosas: mantener algunos datos que podamos 
// actualizar y construir la UI usando esa información.
class _MyHomePageState extends State<MyHomePage> {
  // Si el recuadro verde debe ser visible o invisible
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    // ¡El cuadro verde irá aquí con algunos otros widgets!
  }
}
```

## 3. Muestra un botón que alterne la visibilidad

Ahora que tenemos algunos datos para determinar si nuestro recuadro verde debe ser visible o invisible, necesitaremos una forma de actualizar esos datos. En nuestro caso, si el cuadro está visible, queremos ocultarlo. Si la caja está oculta, ¡queremos mostrarla!  

Para lograrlo, mostraremos un botón. Cuando un usuario pulsa el botón, alternamos el booleano de verdadero a falso, o de falso a verdadero. Necesitamos hacer este cambio usando [`setState`](https://docs.flutter.io/flutter/widgets/State/setState.html),
que es un método de la clase `State`. Esto le permitirá a Flutter saber que necesita reconstruir el Widget.

Nota: Para obtener más información sobre cómo trabajar con las entradas del usuario, por favor consulta la sección 
[Manejando Gestos](/cookbook/#manejando-gestos) del Cookbook.

<!-- skip -->
```dart
FloatingActionButton(
  onPressed: () {
    // ¡Asegúrate de llamar a setState! Esto le dirá a Flutter que reconstruya el
    // UI con nuestros cambios!
    setState(() {
      _visible = !_visible;
    });
  },
  tooltip: 'Toggle Opacity',
  child: Icon(Icons.flip),
);
``` 

## 4. Al cuadro, aplícale el Fade in and out

Tenemos un recuadro verde en la pantalla. Tenemos un botón para alternar la visibilidad a verdadero o falso. Entonces, ¿cómo aplicamos el fade in and out al cuadro? Con un Widget
[`AnimatedOpacity`](https://docs.flutter.io/flutter/widgets/AnimatedOpacity-class.html)!

El Widget `AnimatedOpacity` requiere tres argumentos:

  * `opacity`: Un valor de 0.0 (invisible) a 1.0 (completamente visible).
  * `duration`: Cuánto tiempo debe durar la animación para completar
  * `child`: El widget para animar. En nuestro caso, el cuadro verde.

<!-- skip -->
```dart
AnimatedOpacity(
  // Si el Widget debe ser visible, anime a 1.0 (completamente visible). Si
  // el Widget debe estar oculto, anime a 0.0 (invisible).
  opacity: _visible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 500),
  // El cuadro verde debe ser el hijo de AnimatedOpacity
  child: Container(
    width: 200.0,
    height: 200.0,
    color: Colors.green,
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
    final appTitle = 'Opacity Demo';
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

// El trabajo de StatefulWidget es tomar algunos datos y crear una clase State.
// En este caso, nuestro Widget toma un título y crea un _MyHomePageState.
class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// La clase State es responsable de dos cosas: mantener algunos datos que podamos
// actualizar y construir la UI usando esa información.
class _MyHomePageState extends State<MyHomePage> {
  // Si el recuadro verde debe ser visible o invisible
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: AnimatedOpacity(
          // Si el Widget debe ser visible, anime a 1.0 (completamente visible). Si
          // el Widget debe estar oculto, anime a 0.0 (invisible).
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          // El cuadro verde debe ser el hijo de AnimatedOpacity
          child: Container(
            width: 200.0,
            height: 200.0,
            color: Colors.green,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Asegúrate de llamar a setState! Esto le dirá a Flutter que reconstruya el
          // UI con nuestros cambios!
          setState(() {
            _visible = !_visible;
          });
        },
        tooltip: 'Toggle Opacity',
        child: Icon(Icons.flip),
      ), // Esta coma final hace que el auto-formateo sea más agradable para los métodos de construcción.
    );
  }
}
```

![Fade In and Out Demo](/images/cookbook/fade-in-out.gif)
