---
layout: page
title: "Haciendo scroll en test de integración"
permalink: /cookbook/testing/integration-test-scrolling/
---

Muchas apps presentan listas de contenido, desde clientes de correo electrónico hasta apps de música y más. Para verificar que las listas contengan el contenido que esperamos con los test de integración, necesitamos una forma de hacer scroll por las listas para buscar elementos en particular.

Para hacer scroll por las listas mediante pruebas de integración, podemos usar los métodos proporcionados por la clase
[`FlutterDriver`](https://docs.flutter.io/flutter/flutter_driver/FlutterDriver-class.html)
que se incluye en el paquete
[`flutter_driver`](https://docs.flutter.io/flutter/flutter_driver/flutter_driver-library.html):

En esta receta, aprenderemos a hacer scroll por una lista de elementos para verificar que se muestre un widget específico, y analizaremos los pros y contras de los diferentes enfoques. Si recién estás comenzando con los test de integración, por favor lee la receta [Introducción a los test de integración](/cookbook/testing/integration-test-introduction/).

### Instrucciones

  1. Crea una app con una lista de elementos
  2. Organiza la app
  3. Escribe una prueba que haga scroll por la lista
  4. Ejecuta la prueba

### 1. Crea una app con una lista de elementos

En esta receta, vamos a construir una aplicación que muestra una larga lista de elementos. Para mantener esta receta centrada en las pruebas, usaremos la aplicación que creamos en la receta 
[Trabajando con listas grandes](/cookbook/lists/long-lists/). Si no estás seguro de cómo trabajar con listas de contenido, por favor consulta esa receta para obtener una introducción.

Como hicimos en la receta [Introducción a los test de integración](/cookbook/testing/integration-test-introduction/), también agregaremos Keys a los widgets con los que queremos interactuar dentro de nuestras pruebas de integración.

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(
    items: List<String>.generate(10000, (i) => "Item $i"),
  ));
}

class MyApp extends StatelessWidget {
  final List<String> items;

  MyApp({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Long List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          // Agrega una clave a ListView. Esto nos permite encontrar la lista y
          // hacer scroll por ella en nuestras pruebas
          key: Key('long_list'),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                '${items[index]}',
                // Agrega una clave al Text Widget para cada elemento. Esto nos permite
                // buscar un elemento en particular en la lista y verificar que el
                // texto es correcto
                key: Key('item_${index}_text'),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

### 2. Instrumenta la app

A continuación, necesitaremos crear una versión instrumentada de nuestra aplicación. Este código reside en un archivo llamado `test_driver/app.dart`.

<!-- skip -->
```dart
import 'package:flutter_driver/driver_extension.dart';
import 'package:scrollable_app/main.dart' as app;

void main() {
  // La siguiente línea habilita la extensión de servicio VM de Flutter Driver
  enableFlutterDriverExtension();

  // Llama a la función `main()` de tu app o llama a `runApp` con cualquier widget
  // que estés interesado en probar.
  app.main();
}
```

### 3. Escribe una prueba que haga scroll por la lista

¡Ahora, podemos escribir nuestra prueba! En este ejemplo, necesitamos hacer scroll por la lista de elementos y verificar que un elemento en particular exista en la lista. La clase
[`FlutterDriver`](https://docs.flutter.io/flutter/flutter_driver/FlutterDriver-class.html)
proporciona tres métodos para hacer scroll por las listas:

  - El método 
  [`scroll`](https://docs.flutter.io/flutter/flutter_driver/FlutterDriver/scroll.html)
  nos permite desplazarnos por una lista específica en una cantidad determinada. 
  - El método 
  [`scrollIntoView`](https://docs.flutter.io/flutter/flutter_driver/FlutterDriver/scrollIntoView.html)
  encuentra un widget específico que ya se ha renderizado, y hará scroll completamente a
   la vista. Algunos Widgets, como 
  [`ListView.builder`](https://docs.flutter.io/flutter/widgets/ListView/ListView.builder.html), renderizan elementos bajo demanda.
  - El método 
  [`scrollUntilVisible`](https://docs.flutter.io/flutter/flutter_driver/FlutterDriver/scrollUntilVisible.html)
  se desplaza por una lista hasta que un widget específico esté visible.

Mientras que los tres métodos funcionan para casos de uso específicos, `scrollUntilVisible` es a menudo la opción más robusta. ¿Por qué?

  1. Si utilizamos el método `scroll` solo, podemos asumir incorrectamente la altura de cada elemento en la lista. Esto podría llevar a desplazarse demasiado o muy poco.
  2. Si utilizamos el método `scrollIntoView`, suponemos que el widget ha sido instanciado y renderizado. Para verificar que nuestras aplicaciones funcionen en una amplia gama de dispositivos, podríamos ejecutar nuestras pruebas de integración contra dispositivos con diferentes tamaños de pantalla. Como `ListView.builder` renderizará elementos bajo demanda, el hecho de que se haya renderizado o no un widget en particular puede depender del tamaño de la pantalla.

Por lo tanto, en lugar de asumir que conocemos la altura de todos los elementos de una lista, o que un widget en particular se renderizará en todos los dispositivos, podemos usar el método `scrollUntilVisible` para desplazarnos repetidamente a través de una lista de elementos hasta que encontremos lo que estamos buscando!

¡Veamos cómo podemos usar el método `scrollUntilVisible` para buscar en la lista por un elemento en particular! Este código reside en un archivo llamado `test_driver/app_test.dart`.

```dart
// Importa la API de Flutter Driver
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Scrollable App', () {
    FlutterDriver driver;

    // Conéctate al driver de Flutter antes de ejecutar cualquier prueba
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Cierra la conexión al driver después de que se hayan completado los test
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('verifies the list contains a specific item', () async {
      // Crea dos SerializableFinders. Los usaremos para localizar widgets
      // específicos mostrados por la aplicación. Los nombres proporcionados
      // al método byValueKey corresponden a las Keys que proporcionamos a
      // nuestros widgets en el paso 1.
      final listFinder = find.byValueKey('long_list');
      final itemFinder = find.byValueKey('item_50_text');

      await driver.scrollUntilVisible(
        // Haremos Scroll a través de esta lista
        listFinder,
        // Hasta que encontremos este elemento
        itemFinder,
        // Para hacer scroll down por la lista, necesitamos proporcionar un valor negativo
        // a dyScroll. Asegúrate de que este valor sea un incremento lo suficientemente
        // pequeño como para desplazarse por el elemento a la vista sin desplazarse
        // potencialmente más allá de él.
        //
        // Si necesitas desplazarte por listas horizontales, proporciona un argumento
        // dxScroll a cambio
        dyScroll: -300.0,
      );

      // Verifica que el elemento contenga el texto correcto
      expect(
        await driver.getText(itemFinder),
        'Item 50',
      );
    });
  });
}
```

### 4. Ejecuta la prueba

Finalmente, podemos ejecutar la prueba usando el siguiente comando desde la raíz del 
proyecto:

```
flutter drive --target=test_driver/app.dart
```