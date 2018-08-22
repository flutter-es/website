---
layout: page
title: "Usar Themes para compartir colores y estilos de fuente"
permalink: /cookbook/design/themes/
---

Para compartir colores y estilos de fuente a través de nuestra aplicación, podemos aprovechar los temas. Hay dos formas de definir temas: App-wide o usando los Widgets 
`Theme` que definen los colores y estilos de fuente para una parte particular de nuestra aplicación. De hecho, los temas app-wide son simplemente Widgets `Theme` creados en la raíz de nuestras aplicaciones por `MaterialApp`! 

Después de definir un Theme, podemos usarlo dentro de nuestros propios Widgets. Además, los Widgets Material proporcionados por Flutter utilizarán nuestro Theme para establecer los colores de fondo y los estilos de fuente para AppBars, Buttons, Checkboxes, y más.    

## Creando una app theme

Para compartir un Theme que contenga colores y estilos de fuente en toda nuestra aplicación, podemos proporcionar [`ThemeData`](https://docs.flutter.io/flutter/material/ThemeData-class.html)
al constructor de `MaterialApp` .

Si no se proporciona ningún `theme` , Flutter creará un tema alternativo por nosotros.

<!-- skip -->
```dart
MaterialApp(
  title: title,
  theme: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue[800],
    accentColor: Colors.cyan[600],
  ),
);
```

Por favor consulta la documentación de [ThemeData](https://docs.flutter.io/flutter/material/ThemeData-class.html)
para ver todos los colores y fuentes que puede definir.

## Temas para parte de una aplicación

Si queremos sobrescribir el tema app-wide en parte de nuestra aplicación, podemos envolver una sección de nuestra aplicación en un Widget `Theme`.

Hay dos formas de abordar esto: crear un `ThemeData` único, o extender el tema padre.

### Creando un `ThemeData` único

Si no queremos heredar ninguno de los colores de la aplicación o estilos de fuente, podemos crear una instancia de 
 `ThemeData()` y pasarla al Widget `Theme` .

<!-- skip -->
```dart
Theme(
  // Crea un tema único con "ThemeData"
  data: ThemeData(
    accentColor: Colors.yellow,
  ),
  child: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
);
```

### Extendiendo el tema padre

En lugar de sobrescribir todo, a menudo tiene sentido extender el tema padre. Podemos lograr esto utilizando el método 
[`copyWith`](https://docs.flutter.io/flutter/material/ThemeData/copyWith.html).

<!-- skip -->
```dart
Theme(
  // Encuentra y amplía el tema padre usando "copyWith". Por favor observa la siguiente 
  // sección para más información sobre `Theme.of`.
  data: Theme.of(context).copyWith(accentColor: Colors.yellow),
  child: FloatingActionButton(
    onPressed: null,
    child: Icon(Icons.add),
  ),
);
```

## Usando un Theme

Ahora que hemos definido un tema, podemos usarlo en nuestros métodos `build` del Widget 
utilizando la función `Theme.of(context)`!

`Theme.of(context)` buscará el árbol de widgets y devolverá el `Theme` 
más cercano en el árbol. Si tenemos un `Theme` stand-alone definido sobre nuestro Widget, lo devuelve. Si no, devuelve el tema de la App.

De hecho, el `FloatingActionButton` usa esta técnica exacta para encontrar el 
`accentColor`!
 
<!-- skip -->
```dart
Container(
  color: Theme.of(context).accentColor,
  child: Text(
    'Texto con un color de fondo',
    style: Theme.of(context).textTheme.title,
  ),
);
```   

## Ejemplo completo

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appName = 'Custom Themes';

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      ),
      home: MyHomePage(
        title: appName,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Container(
          color: Theme.of(context).accentColor,
          child: Text(
            'Text with a background color',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.yellow),
        child: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
```

![Themes Demo](/images/cookbook/themes.png)