---
layout: page
title: "Introducción a los test de integración"
permalink: /cookbook/testing/integration-test-introduction/
---

Las pruebas unitarias y las pruebas de widgets son útiles para probar clases individuales, funciones o widgets. Sin embargo, generalmente no prueban cómo las piezas individuales trabajan juntas, como un todo, o capturan el rendimiento de una aplicación que se ejecuta en un dispositivo real. Estas tareas se realizan con *tests de integración*.

Los tests de integración funcionan como un par: primero, hacen el deploy a una aplicación instrumentada en un dispositivo o emulador real y luego "conducen" la aplicación desde una suite de tests separados, verificando para asegurarse de que todo esté correcto en el camino.

Para crear este par de prueba, podemos usar el paquete 
[flutter_driver](https://docs.flutter.io/flutter/flutter_driver/flutter_driver-library.html). Proporciona herramientas para crear aplicaciones instrumentadas e impulsar esas aplicaciones desde una suite de tests.

En esta receta, aprenderemos cómo hacer un test a una app counter. Demostrará cómo configurar los test de integración, cómo verificar que la aplicación muestre un texto específico, cómo hacer tap sobre widgets específicos, y como ejecutar los test de integración. 

### Instrucciones

  1. Crea una app para el test
  2. Agrega la dependencia `flutter_driver` 
  3. Crea los archivos de test
  4. Instrumenta la app
  5. Escribe el test de integración
  6. Ejecuta el test de integración</n>
  
### 1. Crea una app para el test

¡Primero, crearemos una aplicación a la que le podamos hacer el test! En este ejemplo, haremos el test a la app counter producida por el comando `flutter create`. Esta app permite a un usuario hacer tap sobre un botón para aumentar un contador.

Además, también tendremos que proporcionar una
[`ValueKey`](https://docs.flutter.io/flutter/foundation/ValueKey-class.html) a
los widgets `Text` y `FloatingActionButton`. Esto nos permite identificar 
e interactuar con estos Widgets específicos dentro de la suite de tests. 

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      home: MyHomePage(title: 'Counter App Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              // Proporciona una Key a este widget Text específico. Esto nos permite
              // identificar este widget específico desde adentro de nuestra suite de test y
              // leer el texto.
              key: Key('counter'),
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Proporciona una Key para el botón. Esto nos permite encontrar este
        // botón específico y hacerle tap dentro de la suite de test.
        key: Key('increment'),
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### 2. Agrega la dependencia `flutter_driver`

A continuación, necesitaremos el paquete `flutter_driver` para escribir el test de integración. Podemos agregar la dependencia `flutter_driver` a la sección 
`dev_dependencies` del archivo `pubspec.yaml` de nuestras apps. 

```yaml
dev_dependencies:
  flutter_driver:
    sdk: flutter
```
    
### 3. Crea los archivos de test

A diferencia de los test unitarios y los test de widgets, las suits de test de integración no se ejecutan en el mismo proceso en el que la app está siendo probada. Por lo tanto, necesitamos crear dos archivos que residan en el mismo directorio. Por convención, el directorio se llama `test_driver`.

  1. El primer archivo contiene una versión "instrumentada" de la app. La instrumentación nos permite "conducir" la aplicación y registrar perfiles de rendimiento desde la suite de test. A este archivo se le puede dar cualquier nombre que tenga sentido. Para este ejemplo, crea un archivo llamado `test_driver/app.dart`.
  2. El segundo archivo contiene la suite test, que controla la aplicación y verifica que funcione como se esperaba. La suite de test puede registrar perfiles de rendimiento. 
  El nombre del archivo de test debe corresponderse con el nombre del archivo que contiene la app instrumentada, con `_test` agregado al final. Por lo tanto, cree un segundo archivo llamado `test_driver/app_test.dart`.
  
Esto nos deja con la siguiente estructura de directorio:

```
counter_app/
  lib/
    main.dart
  test_driver/
    app.dart
    app_test.dart
``` 
 

### 4. Instrumenta la app

Ahora, podemos instrumentar la app. Esto implicará dos pasos:

  1. Habilitar las extensiones del driver de flutter
  2. Ejecutar la app

Agregaremos este código dentro del archivo `flutter_driver/app.dart`.

<!-- skip -->
```dart
import 'package:flutter_driver/driver_extension.dart';
import 'package:counter_app/main.dart' as app;

void main() {
  // Esta línea permite la extensión
  enableFlutterDriverExtension();

  // Llama la función `main()` de nuestra app o llama a `runApp` con cualquier widget
  // en el que estés interesado en realizarle el test.
  app.main();
}
```

### 5. Escribe el test de integración

Ahora que tenemos una app instrumentada, ¡podemos escribir tests para ella! Esto implicará cuatro pasos:

  1. Crea
  [`SeralizableFinders`](https://docs.flutter.io/flutter/flutter_driver/CommonFinders-class.html)
  para localizar widgets específicos
  2. Conéctate a la app antes de que nuestros tests ejecuten la función `setUpAll`
  3. Realiza el test a los escenarios importantes 
  4. Desconéctate desde la app en la función `teardownAll` al completar nuestros tests
 
```dart
// Importa la Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Counter App', () {
    // Primero, define los Finders. Podemos usarlos para localizar Widgets desde
    // la suite de test. Nota: los Strings proporcionados al método `byValueKey`
    // deben ser los mismos que los Strings utilizados para las Keys del paso 1.
    final counterTextFinder = find.byValueKey('counter');
    final buttonFinder = find.byValueKey('increment');

    FlutterDriver driver;

    // Conéctate al driver de Flutter antes de ejecutar cualquier test
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Cierra la conexión con el driver después de que se hayan completado los tests
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('starts at 0', () async {
      // Usa el método `driver.getText` para verificar que el contador comience en 0.
      expect(await driver.getText(counterTextFinder), "0");
    });

    test('increments the counter', () async {
      // Primero, realiza un tap sobre el botón
      await driver.tap(buttonFinder);

      // Luego, verifica que el contador de texto ha sido incrementado en 1
      expect(await driver.getText(counterTextFinder), "1");
    });
  });
}
```

### 6. Ejecuta el test de integración

Ahora que tenemos una aplicación instrumentada y una suite de test, ¡podemos realizar los tests! En primer lugar, asegúrate de iniciar un emulador de Android, Simulador de iOS, o conectar tu ordenador a un dispositivo real iOS / Android.

Luego, ejecuta el siguiente comando desde la raíz del proyecto:

```
flutter drive --target=test_driver/app.dart
```

Este comando:

  1. construye la app `--target` y la instala en el emulator / device
  2. lanza la app
  3. ejecuta la suite de test `app_test.dart` localizada en el folder `test_driver/`