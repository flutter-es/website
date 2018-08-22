---
layout: page
title: "Navegar con rutas con nombre"
permalink: /cookbook/networking/named-routes/
---

En la receta 
[Navegar a una nueva pantalla y volver](/cookbook/navigation/navigation-basics/)
, aprendimos cómo Navegar a una nueva pantalla creando una nueva ruta y publicándola en el [`Navigator`](https://docs.flutter.io/flutter/widgets/Navigator-class.html). 

Sin embargo, si tenemos que navegar a la misma pantalla en muchas partes de nuestras aplicaciones, esto puede provocar la duplicación del código. En estos casos, puede ser útil definir una "ruta con nombre" y usarla para la Navegación.

Para trabajar con rutas con nombre, podemos usar la función 
[`Navigator.pushNamed`](https://docs.flutter.io/flutter/widgets/Navigator/pushNamed.html) 
. Este ejemplo replicará la funcionalidad de la receta original, demostrando cómo usar rutas con nombre en su lugar.

## Instrucciones

  1. Crea 2 pantallas
  2. Define las rutas
  3. Navega a la segunda pantalla usando `Navigator.pushNamed`
  4. Devuelvete a la primer pantalla usando `Navigator.pop`

## 1. Crea 2 pantallas

Primero, necesitaremos dos pantallas para trabajar. La primer pantalla contendrá un botón que navega a la segunda pantalla. La segunda pantalla contendrá un botón que navega de regreso a la primera.

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
            // Navega a la segunda pantalla cuando la pulsen!
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
            // ¡Regrese a la primera pantalla cuando la pulsen!
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
```

## 2. Define las rutas

A continuación, tendremos que definir nuestras rutas proporcionando propiedades adicionales al constructor de 
[`MaterialApp`](https://docs.flutter.io/flutter/material/MaterialApp-class.html),
el `initialRoute` y las `routes` mismas.

La propiedad `initialRoute` define con qué ruta debe comenzar nuestra aplicación. La propiedad `routes` define las rutas con nombre disponibles y los Widgets que deberían construirse cuando navegamos a esas rutas.

<!-- skip -->
```dart
MaterialApp(
  // Inicie la aplicación con la ruta con nombre "/". En nuestro caso, la aplicación comenzará
  // en el Widget FirstScreen
  initialRoute: '/',
  routes: {
    // Cuando naveguemos hacia la ruta "/", crearemos el Widget FirstScreen
    '/': (context) => FirstScreen(),
    // Cuando naveguemos hacia la ruta "/second", crearemos el Widget SecondScreen
    '/second': (context) => SecondScreen(),
  },
);
```   

Nota: Al usar `initialRoute`,asegúrate de no definir una propiedad `home` .   

## 3. Navega a la segunda pantalla usando

Con nuestros Widgets y rutas en su lugar, ¡podemos comenzar a navegar! En este caso, usaremos la función
[`Navigator.pushNamed`](https://docs.flutter.io/flutter/widgets/Navigator/pushNamed.html)
. Esto le dice a Flutter que cree el Widget definido en nuestra tabla de rutas y que abra la pantalla.

En el método `build` de nuestro Widget  `FirstScreen` , actualizaremos el callback `onPressed`:

<!-- skip -->
```dart
// Dentro del Widget `FirstScreen`
onPressed: () {
  // Navega a la segunda pantalla usando una ruta con nombre
  Navigator.pushNamed(context, '/second');
}
``` 

## 4. Devuelvete a la primer pantalla

Para volver a la primera página, podemos usar la función 
[`Navigator.pop`](https://docs.flutter.io/flutter/widgets/Navigator/pop.html).

<!-- skip -->
```dart
// Dentro del widget SecondScreen
onPressed: () {
  // Navega de regreso a la primera pantalla haciendo clic en la ruta actual
  // fuera de la pila
  Navigator.pop(context);
}
```    

## Ejemplo Completo 

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    // Inicie la aplicación con la ruta con nombre. En nuestro caso, la aplicación comenzará
    // en el Widget FirstScreen
    initialRoute: '/',
    routes: {
      // Cuando naveguemos hacia la ruta "/", crearemos el Widget FirstScreen
      '/': (context) => FirstScreen(),
      // Cuando naveguemos hacia la ruta "/second", crearemos el Widget SecondScreen
      '/second': (context) => SecondScreen(),
    },
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
            // Navega a la segunda pantalla usando una ruta con nombre
            Navigator.pushNamed(context, '/second');
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
            // Navega de regreso a la primera pantalla haciendo clic en la ruta actual
            // fuera de la pila
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
