---
title: Pasar argumentos a una ruta con nombre
prev:
  title: Navigate with named routes
  path: /docs/cookbook/navigation/named-routes
next:
  title: Return data from a screen
  path: /docs/cookbook/navigation/returning-data
---
 
El objeto [`Navigator`](https://docs.flutter.io/flutter/widgets/Navigator-class.html)
proporciona la habilidad de navegar a una nombre con nombre desde cualquier parte de la app usando 
un identificador común. En algunos casos, quizás necesites pasar argumentos a una 
ruta con nombre. Por ejemplo, es posible que desees navegar a la ruta `/user` y 
pasar información sobre el usuario a esta ruta.

En Flutter, puedes completar esta tarea proporcionando un parámetro adicional `arguments` a
el método 
[`Navigator.pushNamed`](https://docs.flutter.io/flutter/widgets/Navigator/pushNamed.html). 
Puedes extraer los argumentos usando el método 
[`ModalRoute.of`](https://docs.flutter.io/flutter/widgets/ModalRoute/of.html)
o dentro de una función 
[`onGenerateRoute`](https://docs.flutter.io/flutter/widgets/WidgetsApp/onGenerateRoute.html)
proporcionada al 
constructor de  
[`MaterialApp`](https://docs.flutter.io/flutter/material/MaterialApp-class.html)
o de 
[`CupertinoApp`](https://docs.flutter.io/flutter/cupertino/CupertinoApp-class.html).

Esta receta demuestra como pasar argumentos a una ruta con nombre y leer los 
argumentos usando `ModelRoute.of` y `onGenerateRoute`.

## Instrucciones

  1. Define los argumentos que necesitas pasar
  2. Crea un widget que extrae los argumentos
  3. Registra el widget en la tabla `routes` 
  4. Navega hasta el widget

## 1. Define los argumentos que necesitas pasar

Primero, define los argumentos que necesitas pasar a la nueva ruta. En este ejemplo, 
pasa dos pieza de datos: El `title` de la pantalla y un `message`.

Para pasar ambas piezas de datos, crea una clase que almacene esta información.

<!-- skip -->
```dart
// Puedes pasar cualquier objeto al parámetro `arguments`. En este ejemplo, crea una 
// clase que contiene ambos, un título y un mensaje personalizable.
class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
```

## 2. Crea un widget que extrae los argumentos

A continuación, crea un widget que extrae y muestra `title` y `message` desde 
el objeto `ScreenArguments`. Para acceder al objeto `ScreenArguments`, usa el método 
[`ModalRoute.of`](https://docs.flutter.io/flutter/widgets/ModalRoute/of.html). 
Este método devuelve la ruta actual con los argumentos.

<!-- skip -->
```dart
// Un widget que extrae los argumentos necesarios del ModalRoute.
class ExtractArgumentsScreen extends StatelessWidget {
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // Extrae los argumentos de la propiedad settings del ModalRoute actual y lo convierte
    // en un objeto ScreenArguments.
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Center(
        child: Text(args.message),
      ),
    );
  }
}
``` 

## 3. Registra el widget en la tabla `routes` 

A continuación, añade una entrada a la propiedad `routes` proporcionada por el widget  
`MaterialApp`. La propiedad `routes` define que widget debería ser creado basándose en el nombre de la ruta.  

<!-- skip -->
```dart
MaterialApp(
  routes: {
    ExtractArgumentsScreen.routeName: (context) => ExtractArgumentsScreen(),
  },     
);
```


## 4. Navega hasta el widget

Finalmente, navega hasta `ExtractArgumentsScreen` cuando el usuario pulsa un botón 
usando 
[`Navigator.pushNamed`](https://docs.flutter.io/flutter/widgets/Navigator/pushNamed.html).
Proporciona los argumentos a la ruta a través de la propiedad `arguments`. 
`ExtractArgumentsScreen` extrae `title` y `message` de estis 
argumentos.

<!-- skip -->
```dart
// Un botón que navega a una ruta con nombre. La ruta con nombre
// extrae los argumentos por si misma.
RaisedButton(
  child: Text("Navigate to screen that extracts arguments"),
  onPressed: () {
    // Cuando el usuario pulsa el botón, navega a una ruta específica
    // y proporciona los argumentos como pate de RouteSettings.
    Navigator.pushNamed(
      context,
      ExtractArgumentsScreen.routeName,
      arguments: ScreenArguments(
        'Extract Arguments Screen',
        'This message is extracted in the build method.',
      ),
    );
  },
);
```  

## Alternativamente, extrae los argumentos usando `onGenerateRoute`

En lugar de extraer los argumentos directamente dentro del widget, puedes tambén 
extraer los argumentos dentro de la función 
[`onGenerateRoute`](https://docs.flutter.io/flutter/widgets/WidgetsApp/onGenerateRoute.html)
y pasar estos al widget.

La función `onGenerateRoute` crea la ruta correcta basándose en la propiedad `RouteSettings` 
dada.

<!-- skip -->
```dart
MaterialApp(
  // Proporciona una función para manejar las rutas con nombre. Usa esta función para 
  // identificar la ruta con nombre que ha sido añadida, con push, y crea la 
  // pantalla correcta.
  onGenerateRoute: (settings) {
    // Si haces push del nombre de la ruta de la pantala PassArgumentsScreen
    if (settings.name == PassArgumentsScreen.routeName) {
      // Covierte los argumentos al tipo correcto: ScreenArguments.
      final ScreenArguments args = settings.arguments;

      // Entonces, extrae los datos requeridos de los argumentos
      // y pasa los datos a la pantalla correcta.
      return MaterialPageRoute(
        builder: (context) {
          return PassArgumentsScreen(
            title: args.title,
            message: args.message,
          );
        },
      );
    }
  },
);
```

## Complete example

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Proporciona una función para manejar las rutas con nombre. Usa esta función para 
      // identificar la ruta con nombre que ha sido añadida, con push, y crea la 
      // pantalla correcta.
      onGenerateRoute: (settings) {
        // Si haces push del nombre de la ruta de la pantala PassArgumentsScreen
        if (settings.name == PassArgumentsScreen.routeName) {
          // Covierte los argumentos al tipo correcto: ScreenArguments.
          final ScreenArguments args = settings.arguments;

          // Entonces, extrae los datos requeridos de los argumentos
          // y pasa los datos a la pantalla correcta.
          return MaterialPageRoute(
            builder: (context) {
              return PassArgumentsScreen(
                title: args.title,
                message: args.message,
              );
            },
          );
        }
      },
      title: 'Navigation with Arguments',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Un botón que navega a una ruta con nombre. La ruta con nombre
            // extrae los argumentos por si misma.
            RaisedButton(
              child: Text("Navigate to screen that extracts arguments"),
              onPressed: () {
                 // Cuando el usuario pulsa el botón, navega a una ruta específica
                // y proporciona los argumentos como pate de RouteSettings.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExtractArgumentsScreen(),
                    // Pasa los argumentos como parte de RouteSettings. 
                    // ExtractArgumentScreen lee los argumentos de su 
                    // propiedad settings.
                    settings: RouteSettings(
                      arguments: ScreenArguments(
                        'Extract Arguments Screen',
                        'This message is extracted in the build method.',
                      ),
                    ),
                  ),
                );
              },
            ),
            // Un botón que navega a una ruta con nombre. Para esta ruta, extrae
            // los argumentos en la función onGenerateRoute y los pasa a 
            // la pantalla.
            RaisedButton(
              child: Text("Navigate to a named that accepts arguments"),
              onPressed: () {
                // Cuando el usuario pulsa el botón, navega a la ruta con nombre
                // y proporciona los argumentos con un parámetro opcional.
                Navigator.pushNamed(
                  context,
                  PassArgumentsScreen.routeName,
                  arguments: ScreenArguments(
                    'Accept Arguments Screen',
                    'This message is extracted in the onGenerateRoute function.',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Un widget que extrae los argumentos necesarios del ModalRoute.
class ExtractArgumentsScreen extends StatelessWidget {
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // Extrae los argumentos de la propiedad settings del ModalRoute actual y lo convierte
    // en un objeto ScreenArguments.
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Center(
        child: Text(args.message),
      ),
    );
  }
}

// Un widget que acepta los argumentos necesarios a través de su constructor.
class PassArgumentsScreen extends StatelessWidget {
  static const routeName = '/passArguments';

  final String title;
  final String message;

  // Este widget acepta los argumentos como parámetros de su constructor. No  
  // extrae los argumentos del ModalRoute.
  //
  // Los agumentos son extraidos por la función onGenerateRoute proporcionada por el 
  // widget MaterialApp.
  const PassArgumentsScreen({
    Key key,
    @required this.title,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}

// Puedes pasar cualquier objeto al parámetro `arguments`. En este ejemplo, crea una 
// clase que contiene ambos, un título y un mensaje personalizable.
class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
```

![Demonstrates navigating to different routes with arguments](/images/cookbook/navigate-with-arguments.gif){:.site-mobile-screenshot}