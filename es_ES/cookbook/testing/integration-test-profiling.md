---
layout: page
title: "Perfiles de rendimiento en test de integración"
permalink: /cookbook/testing/integration-test-profiling/
---

Cuando se trata de aplicaciones móviles, el rendimiento es fundamental para la experiencia del usuario. Los usuarios esperan que las aplicaciones tengan un desplazamiento suave y animaciones significativas sin el efecto stuttering o frames con saltos, lo que se conoce como "jank." ¿Cómo podemos asegurarnos que nuestras aplicaciones están libres de jank en una amplia variedad de dispositivos?

Hay dos opciones: primero, podríamos probar manualmente la aplicación en diferentes dispositivos. Si bien ese enfoque podría funcionar para una aplicación más pequeña, se volverá más engorroso a medida que la aplicación crezca en tamaño. Alternativamente, podemos realizar un test de integración que realice una tarea específica y registrar un timeline de rendimiento. Luego, podemos examinar los resultados para determinar si una sección específica de nuestra aplicación necesita ser mejorada o no.

En esta receta, aprenderemos a escribir un test que registre un timeline de rendimiento mientras se realiza una tarea específica y se guarda un resumen de los resultados en un archivo local.

### Instrucciones

  1. Escribe un test que haga scroll a través de una lista de elementos
  2. Registra el rendimiento de la aplicación
  3. Guarda los resultados en el disco
  4. Ejecuta el test
  5. Revisa los resultados

### 1. Escribe un test que haga scroll a través de una lista de elementos

En esta receta, registraremos el rendimiento de una aplicación a medida que se desplaza por una lista de elementos. Para centrarse en la creación de perfiles de rendimiento, esta receta se basa en la receta 
[Haciendo scroll en test de integración](/cookbook/testing/integration-test-scrolling/).

Por favor sigue las instrucciones de esa receta para crear una aplicación, instrumentarla y escribir un test para verificar que todo funcione como se espera.

### 2. Registra el rendimiento de la aplicación

A continuación, debemos registrar el rendimiento de la aplicación a medida que se hace scroll en la lista. Para lograr esta tarea, podemos usar el método
[`traceAction`](https://docs.flutter.io/flutter/flutter_driver/FlutterDriver/traceAction.html) proporcionado por la clase 
[`FlutterDriver`](https://docs.flutter.io/flutter/flutter_driver/FlutterDriver-class.html).

Este método ejecuta la función proporcionada y registra un
[`Timeline`](https://docs.flutter.io/flutter/flutter_driver/Timeline-class.html)
con información detallada sobre el rendimiento de la aplicación. En este ejemplo, proporcionamos una función que hace scroll en la lista de elementos, asegurando que se muestre un elemento específico. Cuando la función finalice, el método `traceAction` devuelve un `Timeline`.

<!-- skip -->
```dart
// Registra un timeline de rendimiento a medida que avanzamos por la lista de elementos
final timeline = await driver.traceAction(() async {
  await driver.scrollUntilVisible(
    listFinder,
    itemFinder,
    dyScroll: -300.0,
  );

  expect(await driver.getText(itemFinder), 'Item 50');
});
```

### 3. Guarda los resultados en el disco

Ahora que hemos capturado un timeline de rendimiento, ¡necesitamos una manera de revisarlo! El objeto `Timeline` proporciona información detallada sobre todos los eventos que tuvieron lugar, pero no proporciona una manera conveniente de revisar los resultados.

Por lo tanto, podemos convertir el `Timeline` en un
[`TimelineSummary`](https://docs.flutter.io/flutter/flutter_driver/TimelineSummary-class.html).
El `TimelineSummary` puede realizar dos tareas que facilitan la revisión de los resultados:

  1. Puedes escribir un documento json en el disco que resuma los datos contenidos en el `Timeline`. Este resumen incluye información sobre la cantidad de 
  frames con saltos, los tiempos que fueron los más lentos y más.
  2. Puedes guardar el `Timeline` completo como un archivo json en el disco. Este archivo se puede abrir con las herramientas de trace del navegador Chrome que se encuentran en 
  [chrome://tracing](chrome://tracing).

<!-- skip -->
```dart
// Convierte el timeline en un TimelineSummary que sea más fácil de leer y
// entender.
final summary = new TimelineSummary.summarize(timeline);

// Luego, guarda el resumen en el disco
summary.writeSummaryToFile('scrolling_summary', pretty: true);

// Opcionalmente, escribe todo el timeline al disco en formato json. Este
// archivo se puede abrir con las herramientas trace del navegador Chrome 
// que se encuentran en chrome://tracing.
summary.writeTimelineToFile('scrolling_timeline', pretty: true);
```

### 4. Ejecuta el test

Después de configurar nuestro test para capturar el `Timeline` de rendimiento y guardar un resumen de los resultados en el disco, podemos ejecutar el test con el siguiente comando:

```
flutter drive --target=test_driver/app.dart
```

### 5. Revisa los resultados

Después de finalizar el test con éxito, el directorio `build`, en la raíz del proyecto, contiene dos archivos::

  1. `scrolling_summary.timeline_summary.json` contiene el resumen. Abra el archivo con cualquier editor de texto para revisar la información contenida en él. Con una configuración más avanzada, podríamos guardar un resumen cada vez que se ejecute el test y crear un gráfico de los resultados.
  2. `scrolling_timeline.timeline.json` contiene la información completa del timeline.
  Abra el archivo usando las herramientas trace del navegador Chrome encontradas en 
  [chrome://tracing](chrome://tracing). Esas herramientas proporcionan una interfaz conveniente para inspeccionar los datos del timeline con el fin de descubrir el origen de un problema de rendimiento.

#### Ejemplo de resumen

```json
{
  "average_frame_build_time_millis": 4.2592592592592595,
  "worst_frame_build_time_millis": 21.0,
  "missed_frame_build_budget_count": 2,
  "average_frame_rasterizer_time_millis": 5.518518518518518,
  "worst_frame_rasterizer_time_millis": 51.0,
  "missed_frame_rasterizer_budget_count": 10,
  "frame_count": 54,
  "frame_build_times": [
    6874,
    5019,
    3638
  ],
  "frame_rasterizer_times": [
    51955,
    8468,
    3129
  ]
}
```

### Ejemplo completo

```dart
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Scrollable App', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('verifies the list contains a specific item', () async {
      final listFinder = find.byValueKey('long_list');
      final itemFinder = find.byValueKey('item_50_text');

      // Graba un perfil de rendimiento a medida que hacemos scroll en la lista de elementos
      final timeline = await driver.traceAction(() async {
        await driver.scrollUntilVisible(
          listFinder,
          itemFinder,
          dyScroll: -300.0,
        );

        expect(await driver.getText(itemFinder), 'Item 50');
      });

      // Convierte el timeline en un TimelineSummary que sea más fácil de leer y
      // entender.
      final summary = new TimelineSummary.summarize(timeline);

      // Luego, guarda el resumen en el disco
      summary.writeSummaryToFile('scrolling_summary', pretty: true);

      // Opcionalmente, escribe todo el timeline al disco en formato json. Este
      // archivo se puede abrir con las herramientas trace del navegador Chrome encontradas
      // en chrome://tracing.
      summary.writeTimelineToFile('scrolling_timeline', pretty: true);
    });
  });
}
```