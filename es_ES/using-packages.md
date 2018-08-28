---
layout: page
title: Usando Paquetes
permalink: /using-packages/
---

Flutter soporta el uso de paquetes compartidos, aportados por otros 
desarrolladores al ecosistema de Flutter y Dart. Esto te permite construir tu app
rápidamente sin tener que desarrollar todo desde cero.

Los paquetes existentes posibilitan muchos casos de uso, por ejemplo, crear peticiones de red 
([`http`](/cookbook/networking/fetch-data/)), manejo personalizado de navegación/enrutado 
([`fluro`](https://pub.dartlang.org/packages/fluro)), integración con APIs del dispositivo 
(como [`url_launcher`](https://pub.dartlang.org/packages/url_launcher) &
[`battery`](https://pub.dartlang.org/packages/battery)), y usar SDKs de plataforma de terceras
partes (como 
[Firebase](https://github.com/flutter/plugins/blob/master/FlutterFire.md)).

Si estás buscando desarrollar un nuevo paquete, por favor mira [desarrollando paquetes](/developing-packages/).

Si estas buscando añadir assets, imágenes, o fuentes, ya sea almacenados en archivos o 
paquetes, por favor mira [Assets & Imágenes](https://flutter.io/assets-and-images/).

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

Todos los paquetes tienen un número de versión, especificado en su fichero `pubspec.yaml`. Pub 
muestra la versión actual del paquete a continuación de su nombre (por ejemplo, mira el paquete 
[url_launcher](https://pub.dartlang.org/packages/url_launcher)), así como una lista de todas las 
versiones anteriores ([url_launcher
versions](https://pub.dartlang.org/packages/url_launcher#-versions-tab-)).

Cuando un paquete es añadido a `pubspec.yaml` usando la forma abreviada `plugin1:`
esto es interpretado como `plugin1: any`, es decir cualquier versión del paquete  puede 
usarse. Para asegurar que tu app no se rompe cuando un paquete es actualizado, recomendamos 
especificar un rango de versiones usando uno de los siguientes formatos:

* Restricciones de rango: Especifica una versión mínima y máxima, ej.:
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
vez después de añadir un paquete, Flutter guarda la versión concreta encontrada en 
el [lockfile](https://www.dartlang.org/tools/pub/glossary#lockfile) `pubspec.lock`. 
Esto asegura que se obtiene la misma versión de nuevo si tú, u otro desarrollador en
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
  Si el paquete está ubicado en la raíz del repositorio, usa esta sintaxis:
  ```
  dependencies:
    plugin1:
      git:
        url: git://github.com/flutter/plugin1.git
  ```

* Dependencia **Git** de un paquete en una carpeta: por defecto Pub asume que 
  el paquete está ubicado en el directorio raíz del repositorio Git. Si este no es el caso,
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

## Ejemplos

### Ejemplo: Usando el paquete CSS Colors {#css-example}

El paquete [`css_colors`](https://pub.dartlang.org/packages/css_colors) define 
constantes para los colores CSS, permitiéndote usar esto en cualquier lugar que 
el framework de Flutter espere un argumento de tipo `Color`.

Para usar este paquete:

1. Crea un nuevo proyecto llamado 'cssdemo'

1. Abre `pubspec.yaml`, y reemplaza:
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

1. Ejecuta `flutter packages get` en el terminal, o haz clic en 'Packages get' en IntelliJ

1. Abre `lib/main.dart` y reemplaza todo su contenido con:

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

1. Ejecuta la app.


### Ejemplo: Usando el paquete URL Launcher para lanzar el navegador {#url-example}

El paquete del plugin [URL Launcher](https://pub.dartlang.org/packages/url_launcher) 
te permite abrir el navegador por defecto en la plataforma móvil para mostrar una 
URL dada. Esto demuestra como los paquetes pueden también contener código específico 
de plataforma (nosotros llamamos a estos paquetes 'plugins'). Este es soportado tanto
en Android como en iOS.

Para usar este plugin:

1. Crea un proyecto nuevo llamado 'launchdemo'

1. Abre `pubspec.yaml`, y reemplaza:
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

1. Ejecuta `flutter packages get` en el terminal, o haz clic en 'Packages get' en IntelliJ

1. Abre `lib/main.dart` y reemplaza su contenido completo con:

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

1. Ejecuta la app (o párala y reiníciala, si ya la estabas ejecutando antes de añadir el plugin). Cuando haces clic
en 'Show Flutter homepage' deberías ver el navegador predeterminado del teléfono abierto, y aparecer la homepage
de Flutter.
