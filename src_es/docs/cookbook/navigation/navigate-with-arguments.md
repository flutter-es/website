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
// Puedes pasar cualquier objeto al parametro `arguments`. En este ejemplo, crea una 
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
      // Provide a function to handle named routes. Use this function to
      // identify the named route being pushed and create the correct
      // Screen.
      onGenerateRoute: (settings) {
        // If you push the the PassArguments route
        if (settings.name == PassArgumentsScreen.routeName) {
          // Cast the arguments to the correct type: ScreenArguments.
          final ScreenArguments args = settings.arguments;

          // Then, extract the required data from the arguments and
          // pass the data to the correct screen.
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
            // A button that navigates to a named route that. The named route
            // extracts the arguments by itself.
            RaisedButton(
              child: Text("Navigate to screen that extracts arguments"),
              onPressed: () {
                // When the user taps the button, navigate to the specific route
                // and provide the arguments as part of the RouteSettings.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExtractArgumentsScreen(),
                    // Pass the arguments as part of the RouteSettings. The
                    // ExtractArgumentScreen reads the arguments from these
                    // settings.
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
            // A button that navigates to a named route. For this route, extract
            // the arguments in the onGenerateRoute function and pass them
            // to the screen.
            RaisedButton(
              child: Text("Navigate to a named that accepts arguments"),
              onPressed: () {
                // When the user taps the button, navigate to a named route
                // and provide the arguments as an optional parameter.
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

// A Widget that extracts the necessary arguments from the ModalRoute.
class ExtractArgumentsScreen extends StatelessWidget {
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast
    // them as ScreenArguments.
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

// A Widget that accepts the necessary arguments via the constructor.
class PassArgumentsScreen extends StatelessWidget {
  static const routeName = '/passArguments';

  final String title;
  final String message;

  // This Widget accepts the arguments as constructor parameters. It does not
  // extract the arguments from the ModalRoute.
  //
  // The arguments are extracted by the onGenerateRoute function provided to the
  // MaterialApp widget.
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

// You can pass any object to the arguments parameter. In this example, create a
// class that contains both a customizable title and message.
class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
```

![Demonstrates navigating to different routes with arguments](/images/cookbook/navigate-with-arguments.gif){:.site-mobile-screenshot}