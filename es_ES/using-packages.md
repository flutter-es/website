---
layout: page
title: Usando Paquetes
permalink: /using-packages/
---

Flutter soporta el uso de paquetes compartidos, aportados por otros 
desarrolladores al ecosistema de Flutter y Dart. Esto te permite construir tu app
rápidamente sin tener que desarrollar todo desde cero.

Los paquetes existentes posibilitan muchos casos de uso, por ejemplo, crear peticiones de red 
([`http`](/cookbook/networking/fetch-data/)), manejo personalizado de navegacion/enrutado 
([`fluro`](https://pub.dartlang.org/packages/fluro)), integración con APIs del dispositivo 
(como [`url_launcher`](https://pub.dartlang.org/packages/url_launcher) &
[`battery`](https://pub.dartlang.org/packages/battery)), y usar SDKs de plataforma de terceras
partes (como 
[Firebase](https://github.com/flutter/plugins/blob/master/FlutterFire.md)).

Si estás buscando desarrollar un nuevo paquete, por favor mira [desarrollando paquetes](/developing-packages/).

Si estas buscando añadir assets, imaágenes, o fuentes, ya sea almacenados en archivos o 
paquetes, porfavor mira [Assets & Imágenes](https://flutter.io/assets-and-images/).

* TOC
{:toc}

## Usando paquetes

### Buscando paquetes

Los paquetes son publicados el repositorio de paquetes *[Pub](https://pub.dartlang.org)*.

La [landing page de Flutter](https://pub.dartlang.org/flutter/) muestra los paquetes 'top' 
que son compatibles con Flutter (ej., que declaran dependencias generales compatibles 
con Flutter), y admite la búsqueda entre todos los paquetes publicados.

### Añadiendo un paquete a las dependencias de una app

Para añadir un paquete 'css_colors' a una app:

1. Depende de él
   * Abre el fichero `pubspec.yaml` localizado dentro de la carpeta de la app, y añade 
   `css_colors:` debajo de `dependencies`.

1. Instálalo
   * Desde la terminal: Ejecuta `flutter packages get`<br/>
   **OR**
   * Desde Android Studio/IntelliJ: Haz clic en 'Packages Get' en la barra de acciones encima de `pubspec.yaml`
   * Desde VS Code: Haz clic en 'Get Packages' localizado en la parte derecha de la barra de acciones encima de `pubspec.yaml`

1. Impórtalo
   * Añade la declaración `import` correspondiente en tu código Dart.

1. Para y reinicia la app, si es necesario
   * Si el paquete trae código especifico de la plataforma (Java/Kotlin para Android, Swift/Objective-C para iOS), 
   este código debe ser compilado dentro de tu app. Hot reload y hot restart hace esto solo para el código Dart
   del paquete, puede que tenga que hacer un reinicio completo de la app para evitar errores del tipo `MissingPluginException` cuando usa el paquete.

La pestaña 
['installing'](https://pub.dartlang.org/packages/css_colors#-installing-tab-)
disponible en cada paqueteen Pub es una referencia útil para estos pasos.

Para un ejemplo completo, mira [CSS Colors example](#css-example) más abajo.

## Desarrollando nuevos paquetes

Si un paquete no está disponible para su caso específico de uso, puedes [desarrollar un nuevo paquete
personalizado](https://flutter.io/developing-packages/).

## Gestionando dependencias de paquetes & versiones

### Versiones de paquetes

Todos los paquets tienen un núnmero de versión, especificado specified en su fichero `pubspec.yaml`. Pub 
muestra la versión actual del paquete a continuación de su nombre (por ejemplo, mira el paquete 
[url_launcher](https://pub.dartlang.org/packages/url_launcher)), así como una lista de todas las 
versiones anteriores ([url_launcher
versions](https://pub.dartlang.org/packages/url_launcher#-versions-tab-)).

Cuando un paquete es añadido a `pubspec.yaml` usando la forma abreviada `plugin1:`
esto es interpretado como `plugin1: any`, es decir cualquier versión del paquete  puede 
usarse. Para asegurar que tu app no se rompe cuando un paquete es actualizado, recomendamos 
especificar un rango de versiones usando uno de los siguientes formatos:

* Restricciones de rango: Especifica una version mínima y máxima, ej.:
  ```
  dependencies:
    url_launcher: '>=0.1.2 <0.2.0'
  ```

* Restricciones de rango con [*caret syntax*](https://www.dartlang.org/tools/pub/dependencies#caret-syntax):
  Similar a una restricción de rango de expresión regular
  ```
  dependencies:
    collection: '^0.1.2'
  ```

Para detalles adicionales, mire la [Pub versioning guide](https://www.dartlang.org/tools/pub/versioning).

### Actualizando las dependencias de paquetes

Cuando ejecutas `flutter packages get` ('Packages Get' en IntelliJ) por primera 
vez después de añadir un paquete, Flutter guarda la version concreta encontrada en 
el [lockfile](https://www.dartlang.org/tools/pub/glossary#lockfile) `pubspec.lock`. 
Esto asegura que se obtiene la misma versión de nuevo si tu, u otro desarrollador en
tu equipo, ejecuta `flutter packages get`.

Si quieres actualizar a una nueva versión del paquete, por ejemplo para usar nuevas 
funcionalidades en este paquete, ejecuta `flutter packages upgrade` ('Upgrade dependencies'
en IntelliJ). Esto obtendrá la versión más alta disponible del paquete,
que sea permitida por las restricciones que hayas especificado en `pubspec.yaml`.

### Dependencias de paquetes no publicados

Los paquetes pueden ser usados aunque no estén publicados en Pub. Para plugins privados 
no destinados a publicarlos de forma pública, o para paquetes aún no listos para publicar, 
están disponibles opciones adicionales de dependencias:

* Dependencia **Path**: Una aplicación Flutter puede depender de un plugin, vía una dependencia `path:`, 
  del sistema de ficheros. El path puede ser relativo o absoluto. Por ejemplo, para 
  depender de un plugin 'plugin1' localizado en un directorio al anexo a la app, usa esta sintaxis:
  ```
  dependencies:
    plugin1:
      path: ../plugin1/
  ```

* Dependencia **Git**: Puedes depender también de un paquete almacenado en un repositorio Git. 
  Si el paquete esta ubicado en la raíz del repositorio, usa esta sintaxis:
  ```
  dependencies:
    plugin1:
      git:
        url: git://github.com/flutter/plugin1.git
  ```

* Dependencia **Git** de un paquete en una carpeta: por defecto Pub asume que 
  el paquete está ubicado en el directorio ráiz del repositorio Git. Si este no es el caso,
  puedes especificar la ubicación con el argumento `path` , ej.:
  ```
  dependencies:
    package1:
      git:
        url: git://github.com/flutter/packages.git
        path: packages/package1        
  ```

  Finalmente, puedes usar el argumento `ref` para fijar la dependencia un commit específico de git,
  rama, o etiqueta. Para más detalles, mira el 
  [Pub Dependencies article](https://www.dartlang.org/tools/pub/dependencies).

## Examples

### Example: Using the CSS Colors package {#css-example}

The [`css_colors`](https://pub.dartlang.org/packages/css_colors) package defines
color constants for the CSS colors, allowing you to use them wherever the
Flutter framework expects the `Color` type.

To use this package:

1. Create a new project called 'cssdemo'

1. Open `pubspec.yaml`, and replace:
   ```
   dependencies:
     flutter:
       sdk: flutter
   ```
   with:

   ```
   dependencies:
     flutter:
       sdk: flutter
     css_colors: ^1.0.0
   ```

1. Run `flutter packages get` in the terminal, or click 'Packages get' in IntelliJ

1. Open `lib/main.dart` and replace its full contents with:

```dart
import 'package:css_colors/css_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(color: CSSColors.orange));
  }
}
```

1. Run the app. When you click the 'Show Flutter homepage' you should see the
phone's default browser open, and the Flutter homepage appear.


### Example: Using the URL Launcher package to launch the browser {#url-example}

The [URL Launcher](https://pub.dartlang.org/packages/url_launcher) plugin package
enables you to open the default browser on the mobile platform to display a
given URL. It demonstrates how packages may also contain platform-specific code
(we call these packages 'plugins'). It is supported on both Android and iOS.

To use this plugin:

1. Create a new project called 'launchdemo'

1. Open `pubspec.yaml`, and replace:
   ```
   dependencies:
     flutter:
       sdk: flutter
   ```
   with:

   ```
   dependencies:
     flutter:
       sdk: flutter
     url_launcher: ^0.4.1
   ```

1. Run `flutter packages get` in the terminal, or click 'Packages get' in IntelliJ

1. Open `lib/main.dart` and replace its full contents with:

```dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  launchURL() {
    launch('https://flutter.io');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: launchURL,
          child: Text('Show Flutter homepage'),
        ),
      ),
    );
  }
}
```

1. Run the app (or stop and restart it, if you already had it running before adding the plugin). When you click the 'Show Flutter homepage' you should see the phone's default browser open, and the Flutter homepage appear.
