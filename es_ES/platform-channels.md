---
layout: page
title: Escribiendo código personalizado, específico de plataforma, con platform channels
permalink: /platform-channels/
---

Esta guía describe como escribir código personalizado, específico de plataforma. Algunas 
funcionalidades específicas de plataforma están disponibles a través de los paquetes existentes;
por favor mire [usando paquetes](/using-packages/).

* TOC
{:toc}

Flutter usa un sistema flexible que permite llamar APIs específicas de plataforma 
ya esté disponible en código Java o Kotlin en Android, o en código ObjectiveC o Swift en iOS.

El soporte de APIs específicas de plataforma de Flutter, no está relacionado con la generación de código, sino 
más bien con un estilo flexible de paso de mensajes:

* La parte Flutter de tu app envía mensajes a su *host*, la parte iOS o
 Android de tu app, usando platform channel.

* El *host* escucha el platform channel, y recibe el mensaje. Esto entonces
 permite llamar a cualquier número de APIs específicas de plataforma -- usando el 
 lenguaje de programación nativo -- y devuelve una respuesta al *cliente*, la parte 
 Flutter de tu app.

## Visión general de la arquitectura: platform channels {#architecture}

Los mensajes son pasados entre el cliente (UI) y el host (plataforma) usando platform
channels como se ilustra en este diagrama:

![Platform channels architecture](/images/PlatformChannels.png)

Los mensajes y las respuestas son pasados de forma asíncrona, para asegurar que el interfaz 
de usuario permanece responsivo.

En el lado del cliente, la ([API][MethodChannel]) `MethodChannel` permite enviar 
mensajes que corresponden con llamadas a métodos. En el lado de la plataforma, la 
([API][MethodChannelAndroid]) `MethodChannel` en Android y la ([API][MethodChanneliOS])
`FlutterMethodChannel` en iOS permiten recibir llamadas a métodos y devolver 
un resultado. Estas clases te permiten desarrollar un plugin de plataforma con 
un código 'boilerplate' verdaderamente pequeño.

*Nota*: Si se desea, las llamadas a métodos pueden también ser enviadas en la 
dirección inversa, con la plataforma actuando como cliente de métodos implementados 
en Dart. Un ejemplo concreto de esto es el plugin [`quick_actions`](https://pub.dartlang.org/packages/quick_actions).

[MethodChannel]: https://docs.flutter.io/flutter/services/MethodChannel-class.html
[MethodChannelAndroid]: https://docs.flutter.io/javadoc/io/flutter/plugin/common/MethodChannel.html
[MethodChanneliOS]: https://docs.flutter.io/objcdoc/Classes/FlutterMethodChannel.html

### Tipos de datos y codecs soportados por Platform channel {#codec}

La _standard platform channels_ usa un codec de mensaje standard que soporta 
serialización binaria eficiente de valores similares a JSON simples, como booleans,
numbers, Strings, byte buffers, y List y Maps de estos (mira
[`StandardMessageCodec`](https://docs.flutter.io/flutter/services/StandardMessageCodec-class.html))
para detalles. La serialización y deserialización de estos valores hacia y desde los 
mensajes ocurre automáticamente cuando envías y recibes valores.

La siguiente tabla muestra como son recibidos los valores Dart en la plataforma y viceversa:

| Dart        | Android             | iOS                        
|-------------|---------------------|----
| null        | null                | nil (NSNull cuando están anidados)
| bool        | java.lang.Boolean   | NSNumber numberWithBool:
| int         | java.lang.Integer   | NSNumber numberWithInt:
| int, si 32 bits no son suficientes | java.lang.Long | NSNumber numberWithLong:
| double      | java.lang.Double    | NSNumber numberWithDouble:
| String      | java.lang.String    | NSString
| Uint8List   | byte[]   | FlutterStandardTypedData typedDataWithBytes:
| Int32List   | int[]    | FlutterStandardTypedData typedDataWithInt32:
| Int64List   | long[]   | FlutterStandardTypedData typedDataWithInt64:
| Float64List | double[] | FlutterStandardTypedData typedDataWithFloat64:
| List        | java.util.ArrayList | NSArray
| Map         | java.util.HashMap   | NSDictionary

<br>
## Ejemplo: Llamando código especifico de plataforma iOS y Android usando platform channels {#example}

Lo siguiente demuestra como llamar una API especifica de plataforma para obtener y 
mostrar el nivel de batería actual. Usa la API `BatteryManager` de Android, y
la API `device.batteryLevel` de iOS, vía un único mensaje de plataforma,
`getBatteryLevel`.

El ejemplo añade el código especifico de plataforma dentro del método main de la app. Si 
quieres reutilizar el código específico de plataforma para múltiples aplicaciones, el paso
de creación del proyecto es ligeramente diferente (mira [desarrollando
paquetes](/developing-packages/#plugin)), pero el código del platform channel se escribe de
la misma manera.

*Nota*: El código fuente ejecutable completo para este ejemplo, está disponible en 
[`/examples/platform_channel/`](https://github.com/flutter/flutter/tree/master/examples/platform_channel)
para Android con Java y iOS con Objective-C. Para iOS con Swift, mira
[`/examples/platform_channel_swift/`](https://github.com/flutter/flutter/tree/master/examples/platform_channel_swift).

### Step 1: Crea un nuevo proyecto de app {#example-project}

Empieza creando una nueva app:

* En un terminal ejecuta: `flutter create batterylevel`

Por defecto nuestra plantilla soporta escribir código Android usando Java , o código iOS 
usando Objective-C. Para usar Kotlin o Swift, usa el flag  `-i` y/o `-a`:

* En un terminal ejecuta: `flutter create -i swift -a kotlin batterylevel`

### Step 2: Crea un platform client de Flutter {#example-client}

La clase `State` de la app conserva el estado actual de la app. Necesitamos ampliar esto 
para conservar el estado actual de la batería.

Primero, construimos el channel. Usamos un `MethodChannel` con un único 
método de plataforma que devuelve el nivel de batería.

Los lados cliente y host de un channel son conectados a través de un _channel name_ 
pasado en el constructor del channel. Todos los _channel names_ usados en una app deben 
ser únicos; recomendamos prefijar el _channel name_ con un 'prefijo de dominio' único', 
ej. `samples.flutter.io/battery`.

<!-- skip -->
```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
...
class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('samples.flutter.io/battery');

  // Obtiene el nivel de batería.
}
```

A continuación, invocamos un método en el _method channel_, especificando el método concreto 
a llamar vía un String identificador `getBatteryLevel`. La llamada puede fallar -- por 
ejemplo si la plataforma no soporta la API de plataforma (si estamos ejecutando en 
un simulador), entonces envolveremos la llamada a `invokeMethod` en una declaración try-catch.

Usamos el resultado devuelto para actualizar el estado de nuestro interfaz de usuario en 
`_batteryLevel` dentro de `setState`.

<!-- skip -->
```dart
  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }
```

Finalmente, reemplazamos el método `build` de la plantilla para contener una pequeña interfaz 
de usuario que muestra el estado de la batería en un string, y un botón para refrescar el valor.

<!-- skip -->
```dart
@override
Widget build(BuildContext context) {
  return Material(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RaisedButton(
            child: Text('Get Battery Level'),
            onPressed: _getBatteryLevel,
          ),
          Text(_batteryLevel),
        ],
      ),
    ),
  );
}
```


### Paso 3a: Añade la implementación especifica de plataforma Android usando Java {#example-java}

*Nota*: El siguiente paso usa Java. Si prefieres Kotlin, salta al paso 
3b.

Empieza abriendo la parte host de Android de tu app Flutter en 
Android Studio:

1. Inicia Android Studio

1. Selecciona el menú 'File > Open...'

1. Navega al directorio que contiene tu app Flutter, y selecciona la carpeta `android`
dentro de él. Haz clic en OK.

1. Abre el fichero `MainActivity.java` localizado en la carpeta `java` en la vista de Proyecto.

A continuación, crea un `MethodChannel` y establece un `MethodCallHandler` dentro del 
método `onCreate`. Asegúrate de usar el mismo _channel name_ que fue usado en el 
lado del cliente en Flutter.

```java
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.io/battery";

    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        // TODO
                    }
                });
    }
}
```

A continuación, añadimos el código actual Android en Java, que usa la API Android battery para 
obtener el nivel de la batería. Este código es exactamente el mismo que habrías escrito 
en una app nativa Android.

Primero, añade los imports necesarios al principio del fichero:

```
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
```

Entonces añade lo siguiente como un método en la clase activity, debajo del método 
`onCreate`:

```java
private int getBatteryLevel() {
  int batteryLevel = -1;
  if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
    BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
    batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
  } else {
    Intent intent = new ContextWrapper(getApplicationContext()).
        registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
    batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
        intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
  }

  return batteryLevel;
}
```

Finalmente, completamos el método `onMethodCall` que añadimos anteriormente. Necesitamos 
manejar un único método de plataforma, `getBatteryLevel`, vamos a probar esto en el 
argumento `call`. La implementación de este método de plataforma simplemente llama al 
código Android que escribimos en el paso anterior, y pasa de vuelta una respuesta para
ambos casos, éxito y error, usando el argumento `response`. En cambio, si se llama 
un método desconocido, reportaremos esto. Reemplaza:

```java
public void onMethodCall(MethodCall call, Result result) {
    // TODO
}
```

con:

```java
@Override
public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getBatteryLevel")) {
        int batteryLevel = getBatteryLevel();

        if (batteryLevel != -1) {
            result.success(batteryLevel);
        } else {
            result.error("UNAVAILABLE", "Battery level not available.", null);
        }
    } else {
        result.notImplemented();
    }
}               
```

Deberías ahora poder ejecutar la app en Android. Si estas usando el emulador de Android, 
puedes ajustar el nivel de batería en el panel Extended Controls 
accesible desde el botón `...` en la barra de herramientas.

### Paso 3b: Añadir una implementación espéfica de plataforma Android usando Kotlin {#example-kotlin}

*Nota*: Los siguientes pasos son similares al paso 3a, solo usaremos Kotlin en lugar de 
Java.

Este paso asume que has creado tu proyecto en el [paso 1.](#example-project)
usando la opción `-a kotlin`.

Empieza abriendo la parte host Android de tu app Flutter en Android Studio:

1. Inicia Android Studio

1. Selecciona el menú 'File > Open...'

1. Navega hasta el directorio que contiene tu app Flutter, y selecciona la carpeta `android`
   dentro de él. Haz Clic en OK.

1. Abre el fichero `MainActivity.kt` localizado en la carpeta `kotlin` en la Project
   view. (Nota: Si estas editando usando Android Studio 2.3, nota que la carpeta 
   'kotlin' se mostrará como si se llamara 'java'.)

A continuación, dentro del método `onCreate`, crea un `MethodChannel` y llama a 
`setMethodCallHandler`. Asegúrate que usas el mismo _channel name_ que fue usado 
la parte cliente en Flutter.

```kotlin
import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity() : FlutterActivity() {
  private val CHANNEL = "samples.flutter.io/battery"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      // TODO
    }
  }
}
```

A continuación, añadimos el código actual Kotlin de Android que usa la API Android battery para 
obtener el nivel de batería. Este código es exactamente el mismo que escribirías 
en una app Android nativa.

Primero, añade los imports necesarios al principio del fichero:

```
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
```

A continuación, añade lo siguiente como un nuevo método en la clase `MainActivity`, 
debajo del método `onCreate`:

```kotlin
  private fun getBatteryLevel(): Int {
    val batteryLevel: Int
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    } else {
      val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
      batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
    }

    return batteryLevel
  }
```

Finalmente, completamos el método `onMethodCall` que añadimos anteriormente. Necesitamos 
manejar un único método de plataforma, `getBatteryLevel`, entonces probamos esto en el 
argumento `call`. La implementación de ese método de plataforma simplemente llama al código 
Android que escribimos en el paso anterior, y pasamos de vuelta una respuesta para 
ambos casos, éxito y error, usando el argumento `response`. En cambio, si se llama 
un método desconocido, reportaremos esto. Reemplaza:

```kotlin
    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      // TODO
    }
```

with:

```kotlin
    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "getBatteryLevel") {
        val batteryLevel = getBatteryLevel()

        if (batteryLevel != -1) {
          result.success(batteryLevel)
        } else {
          result.error("UNAVAILABLE", "Battery level not available.", null)
        }
      } else {
        result.notImplemented()
      }
    }
```

Deberías poder ejecutar tu app en Android. Si estas usando el emulador de Android, 
puedes ajustar el nivel de batería en el panel Extended Controls 
accesible desde el botón `...` en la barra de herramientas.

### Paso 4a: Añade la implementación específica de la plataforma iOS usando Objective-C {#example-objc}

*Nota*: Los siguientes pasos usan Objective-C. Si prefieres Swift, salta al paso 
4b.

Empieza abriendo la parte iOS de tu app Flutter en Xcode:

1. Inicia Xcode

1. Selecciona el menú 'File > Open...'

1. Navega hasta el directorio que contiene tu app Flutter, y selecciona la carpeta `ios`
dentro de él. Haz Clic en OK.

1. Asegúrate que el proyecto Xcode compila sin errores.

1. Abre el fichero `AppDelegate.m` situado bajo Runner > Runner en el navegador Project.

A continuación, crea un `FlutterMethodChannel` y añade un manejador dentro del método `application
didFinishLaunchingWithOptions:`. Asegúrate de usar el mismo _channel name_
que fue usado en la parte del cliente en Flutter.

```objectivec
#import <Flutter/Flutter.h>

@implementation AppDelegate
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

  FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"samples.flutter.io/battery"
                                          binaryMessenger:controller];

  [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    // TODO
  }];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
```

A continuación, añadimos el código actual ObjectiveC en iOS que usa la API iOS battery para 
obtener el nivel de batería. Este código es exactamente el mismo que habrías escrito 
en una app nativa iOS.

Añade lo siguiente como un nuevo método en la clase `AppDelegate`, justo antes de `@end`:

```objectivec
- (int)getBatteryLevel {
  UIDevice* device = UIDevice.currentDevice;
  device.batteryMonitoringEnabled = YES;
  if (device.batteryState == UIDeviceBatteryStateUnknown) {
    return -1;
  } else {
    return (int)(device.batteryLevel * 100);
  }
}
```

Finalmente, completamos el método `setMethodCallHandler` añadido anteriormente. Necesitamos 
manejar un único método de plataforma, `getBatteryLevel`, entonces probamos esto en el 
argumento `call`. La implementación de este método de plataforma simplemente llama al 
código iOS que escribimos en el paso anterior, y pasa de vuelta una respuesta para ambos 
casos, éxito y error, usando el argumento `result`. En cambio, si se llama 
un método desconocido, reportaremos esto. Reemplaza:

```objectivec
[batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
  if ([@"getBatteryLevel" isEqualToString:call.method]) {
    int batteryLevel = [self getBatteryLevel];

    if (batteryLevel == -1) {
      result([FlutterError errorWithCode:@"UNAVAILABLE"
                                 message:@"Battery info unavailable"
                                 details:nil]);
    } else {
      result(@(batteryLevel));
    }
  } else {
    result(FlutterMethodNotImplemented);
  }
}];
```

Ahora deberías poder ejecutar la app en iOS. Si estas usando el simulador de iOS, 
nota que este no soporta la API battery, y la app mostrara 'battery info unavailable'.

### Paso 4b: Añade la implementación específica de la plataforma iOS usando Swift {#example-swift}

*Nota*: Los siguientes pasos son similares al paso 4a, solo usando Swift en lugar de 
Objective-C.

Este paso asume que has creado tu proyecto en el [paso 1.](#example-project)
usando la opción `-i swift`.

Empieza abriendo la parte iOS de tu app Flutter en Xcode:

1. Inicia Xcode

1. Selecciona el menú 'File > Open...'

1. Navega hasta el directorio que contiene tu app Flutter, y selecciona la carpeta `ios`
dentro de él. Haz Clic en OK.

A continuación, añadidos soporte para Swoft en la configuración de la plantilla standard 
que usa Objective-C:

1. Expande Runner > Runner en Project navigator.

1. Abre el fichero `AppDelegate.swift` localizado bajo Runner > Runner en Project
navigator.


A continuación, sobrescribe la función `application` y crea un `FlutterMethodChannel`
atado al _channel name_ `samples.flutter.io/battery`:

```swift
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
    let batteryChannel = FlutterMethodChannel.init(name: "samples.flutter.io/battery",
                                                   binaryMessenger: controller);
    batteryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // Maneja mensajes sobre la batería.
    });

    return super.application(application, didFinishLaunchingWithOptions: launchOptions);
  }
}
```

A continuación, añadimos el código actual Swift en iOS que usa la API iOS battery para 
obtener el nivel de batería. Este código es exactamente el mismo que habrías escrito 
en una app nativa iOS.

Añade lo siguiente como un nuevo método al final de `AppDelegate.swift`:

```swift
private func receiveBatteryLevel(result: FlutterResult) {
  let device = UIDevice.current;
  device.isBatteryMonitoringEnabled = true;
  if (device.batteryState == UIDeviceBatteryState.unknown) {
    result(FlutterError.init(code: "UNAVAILABLE",
                             message: "Battery info unavailable",
                             details: nil));
  } else {
    result(Int(device.batteryLevel * 100));
  }
}
```

Finalmente, completamos el método `setMethodCallHandler` añadido anteriormente. Necesitamos 
manejar un único método de plataforma, `getBatteryLevel`, entonces probamos esto en el 
argumento `call`. La implementación de este método de plataforma simplemente llama al 
código iOS que escribimos en el paso anterior, y pasa de vuelta una respuesta para ambos 
casos, éxito y error, usando el argumento `result`. En cambio, si se llama 
un método desconocido, reportaremos esto. Reemplaza:

```swift
batteryChannel.setMethodCallHandler({
  (call: FlutterMethodCall, result: FlutterResult) -> Void in
  if ("getBatteryLevel" == call.method) {
    self.receiveBatteryLevel(result: result);
  } else {
    result(FlutterMethodNotImplemented);
  }
});
```

Ahora deberiás poder ejecutar la app en iOS. Si estas usando el simulador de iOS, 
nota que este no soporta la API battery, y la app mostrara 'battery info unavailable'.

## Separa código específico de la plataforma del código de UI {#separate}

Si esperas usar tu código específico de plataforma en múltiples aplicaciones Flutter, 
puede ser útil separar el código en un plugin de plataforma situado en un directorio
fuera de tu aplicación. Mira [deserrollando paquetes](/developing-packages/) 
para los detalles.

## Publica código específico de plataforma como un paquete {#publish}

Si deseas compartir tu paquete específico de plataforma con otros desarrolladores en el 
ecosistema Flutter, por favor mira [publishing packages](/developing-packages/#publish)
para los detalles.

## Custom channels y codecs

Además de `MethodChannel` mencionado anteriormente, también puedes usar el básico 
[`BasicMessageChannel`][BasicMessageChannel], que soporta paso de mensajes asíncronos
básicos, usando un codec de mensajes personalizado. Además, puedes usar las clases 
especializadas [`BinaryCodec`][BinaryCodec], [`StringCodec`][StringCodec], y
[`JSONMessageCodec`][JSONMessageCodec], o crear tu propio codec.

[BasicMessageChannel]: https://docs.flutter.io/flutter/services/BasicMessageChannel-class.html
[BinaryCodec]: https://docs.flutter.io/flutter/services/BinaryCodec-class.html
[StringCodec]: https://docs.flutter.io/flutter/services/StringCodec-class.html
[JSONMessageCodec]: https://docs.flutter.io/flutter/services/JSONMessageCodec-class.html
