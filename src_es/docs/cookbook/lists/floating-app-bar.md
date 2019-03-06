---
title: Coloca un app bar flotante sobre una lista 
prev:
  title: Creando listas con elementos de diferentes tipos
  path: /docs/cookbook/lists/mixed-list
next:
  title: Trabajando con listas grandes
  path: /docs/cookbook/lists/long-lists
---

Para facilitar a los usuarios la visualización de una lista de elementos, es posible que desees ocultar el app bar a medida que el usuario se desplaza por la lista. Esto es especialmente cierto si tu aplicación muestra un app bar "alto" que ocupa mucho espacio vertical.

Tradicionalmente, creas el app bar proporcionando la propiedad `appBar` al 
Widget `Scaffold`. Esto crea el app bar fijo que siempre permanece por encima 
del `body` del `Scaffold`.

Mover el app bar desde un Widget `Scaffold` a un
[`CustomScrollView`](https://docs.flutter.io/flutter/widgets/CustomScrollView-class.html)
te permite crear el app bar que se desplaza fuera de la pantalla a medida que te desplazas a través de una lista de elementos contenidos dentro 
del `CustomScrollView`.

Esta receta demuestra cómo usar un `CustomScrollView` para mostrar una lista de elementos con un app bar en la parte superior que se desplaza fuera de la pantalla a medida que el usuario se desplaza por la lista.

### Instrucciones

  1. Crear un `CustomScrollView`
  2. Usar `SliverAppBar` para agregar el app bar flotante
  3. Agregar una lista de elementos usando un `SliverList`

## 1. Crear un `CustomScrollView`

Para crear el app bar flotante, necesitas colocar el app bar dentro de un
`CustomScrollView` que también contenga la lista de elementos. Esto sincroniza la posición de desplazamiento del app bar y la lista de elementos. Puedes pensar en el Widget `CustomScrollView` como un `ListView` que te permite ¡mezclar y combinar diferentes tipos de listas desplazables y widgets juntos!

Las listas de desplazamiento y los widgets que se pueden proporcionar al
`CustomScrollView` se conocen como slivers. Hay varios tipos de Slivers, como
¡`SliverList`, `SliverGridList`, y `SliverAppBar`! De hecho, los widgets
`ListView` y `GridView` ¡utilizan los widgets `SliverList` y `SliverGrid` bajo el capó!

Para este ejemplo, crea un `CustomScrollView` que contenga una 
`SliverAppBar` y un `SliverList`. ¡Además, necesitas eliminar cualquier app bar que pudieras estar proporcionando al Widget `Scaffold`!

<!-- skip -->
```dart
Scaffold(
  // ¡No se proporciona ninguna propiedad appBar, sólo el body!
  body: CustomScrollView(
    // Añade el app bar y la lista de elementos como slivers en los siguientes pasos
    slivers: <Widget>[]
  ),
);
```

### 2. Usa `SliverAppBar` para agregar el app bar flotante

A continuación, agrega el app bar al
[`CustomScrollView`](https://docs.flutter.io/flutter/widgets/CustomScrollView-class.html).
Flutter proporciona el Widget
[`SliverAppBar`](https://docs.flutter.io/flutter/material/SliverAppBar-class.html)
de manera novedosa. Al igual que el widget `AppBar` normal, puedes usar la
`SliverAppBar` para mostrar un título, pestañas, imágenes y más.

Sin embargo, la `SliverAppBar` también te ofrece la posibilidad de crear un app bar "flotante" que se desplaza fuera de la pantalla a medida que el usuario se desplaza hacia abajo en la lista. Además, puedes configurar la `SliverAppBar` para que se contraiga y se expanda a medida que el usuario se desplaza.

Para lograr este efecto:

  1. Comienza con un app bar que muestre sólo un título 
  2. Establece la propiedad `floating` a `true`. Esto permite a los usuarios revelar rápidamente el app bar cuando se desplazan por la lista.
  3. Agrega un widget `flexibleSpace` que ocupará la altura `expandedHeight` disponible.

<!-- skip -->
```dart
CustomScrollView(
  slivers: <Widget>[
    SliverAppBar(
      title: Text('Floating app bar'),
      // Permite al usuario revelar el app bar si comienza a desplazarse  
      // hacia arriba en la lista de elementos
      floating: true,
      // Mostrar un widget placeholder para visualizar el tamaño de reducción 
      flexibleSpace: Placeholder(),
      // Aumentar la altura inicial de la SliverAppBar más de lo normal
      expandedHeight: 200,
    ),
  ],
);
```

{{site.alert.tip}}
Juega con las [diversas propiedades que puedes pasar al Widget `SliverAppBar`
](https://docs.flutter.io/flutter/material/SliverAppBar/SliverAppBar.html)
y usa hot reload para ver los resultados. Por ejemplo, puedes usar un 
Widget `Image` para la propiedad `flexibleSpace` y crear una imagen de fondo 
que se reduce en tamaño a medida que se desplaza fuera de la pantalla.
{{site.alert.end}}


### 3. Agregar una lista de elementos usando un `SliverList`

Ahora que tienes el app bar en su lugar, agrega una lista de elementos al 
`CustomScrollView`. Tienes dos opciones: una
[`SliverList`](https://docs.flutter.io/flutter/widgets/SliverList-class.html) o
una [`SliverGrid`](https://docs.flutter.io/flutter/widgets/SliverGrid-class.html).
Si necesitas mostrar una lista de elementos uno tras otro, utiliza el 
Widget `SliverList`. Si necesitas mostrar una lista de cuadrículas, usa el 
Widget `SliverGrid`.

Los widgets `SliverList` y `SliverGrid` toman un parámetro requerido: un
[`SliverChildDelegate`](https://docs.flutter.io/flutter/widgets/SliverChildDelegate-class.html).
Si bien esto suena elegante, el delegado se utiliza simplemente para 
proporcionar una lista de Widgets a `SliverList` o `SliverGrid`. Por ejemplo, el
[`SliverChildBuilderDelegate`](https://docs.flutter.io/flutter/widgets/SliverChildBuilderDelegate-class.html)
te permite crear una lista de elementos que se construyen perezosamente a medida que te desplazas, igual que el widget `ListView.builder`.

<!-- skip -->
```dart
// Crea un SliverList
SliverList(
  // Para ello, se utiliza un delegado para crear elementos a medida que se desplazan
  // por la pantalla. 
  delegate: SliverChildBuilderDelegate(
    // La función builder devuelve un ListTile con un título que
    // muestra el índice del elemento actual
    (context, index) => ListTile(title: Text('Item #$index')),
    // Construye 1000 ListTiles
    childCount: 1000,
  ),
)
```

## Ejemplo completo

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Floating App Bar';

    return MaterialApp(
      title: title,
      home: Scaffold(
        // No se proporciona ningún appbar al Scaffold, sólo un body con un
        // CustomScrollView
        body: CustomScrollView(
          slivers: <Widget>[
            // Agrega un app bar al CustomScrollView
            SliverAppBar(
              // Provee un título estándard
              title: Text(title),
              // Permite al usuario revelar el app bar si comienza a desplazarse
              // hacia arriba en la lista de elementos
              floating: true,
              // Mostrar un widget placeholder para visualizar el tamaño de reducción
              flexibleSpace: Placeholder(),
              // Aumentar la altura inicial de la SliverAppBar más de lo normal
              expandedHeight: 200,
            ),
            // A continuación, crea un SliverList
            SliverList(
              // Para ello, se utiliza un delegado para crear elementos a medida que
              // se desplazan por la pantalla. 
              delegate: SliverChildBuilderDelegate(
                // La función builder devuelve un ListTile con un título que
                // muestra el índice del elemento actual
                (context, index) => ListTile(title: Text('Item #$index')),
                // Construye 1000 ListTiles
                childCount: 1000,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

![Demo básico de la lista](/images/cookbook/floating-app-bar.gif){:.site-mobile-screenshot}
