---
layout: page
title: Desarrollando paquetes & Plugins
permalink: /developing-packages/
---

* TOC
{:toc}

## Introducción a los paquetes

Los paquetes permiten la creación de código modular que puede ser compartido fácilmente. Un 
paquete mínimo consiste en:

* Un fichero `pubspec.yaml`: Un fichero de metadatos que declara el nombre del paquete,
  version, autor, etc.

* Un directorio `lib` conteniendo el código público del paquete, como mínimo un 
  único fichero `<package-name>.dart`.

### Tipos de paquetes {#types}

Los paquetes pueden contener varios tipos de contenido:

* *Paquetes Dart*: Paquetes generales escritos en Dart, por ejemplo el 
  paquete [`path`](https://pub.dartlang.org/packages/path). Algunos de estos 
  pueden contener funcionalidades específicas de Flutter y así tener una
  dependencia del framework Flutter, restringiendo su uso solo a Flutter, 
  por ejemplo el paquete [`fluro`](https://pub.dartlang.org/packages/fluro).

* *Paquetes de Plugin*: Un paquete especializado de Dart que contiene una API 
  escrita en código Dart combinado con una implementación específica de plataforma 
  para Android (usando Java o Kotlin), y/o para iOS (usando ObjC o Swift). Un ejemplo 
  concreto es el paquete de plugin [`battery`](https://pub.dartlang.org/packages/battery).

## Desarrollando paquetes Dart {#dart}

### Paso 1: Crea el paquete

Para crear un paquete Dart, usa la etiqueta `--template=package` con `flutter create`:

{% commandline %}
flutter create --template=package hello
{% endcommandline %}

Esto crea un proyecto de paquete en la carpeta `hello/` con el siguiente
contenido especializado:

* `lib/hello.dart`:
   - El código Dart para el paquete.
* `test/hello_test.dart`:
   - Los [test unitarios](https://flutter.io/testing/#unit-testing) para el paquete.

### Paso 2: Implementa el paquete

Para paquetes Dart puros, simplemente añade la funcionalidad dentro del fichero 
main dentro de `lib/<package name>.dart`, o en múltiples ficheros en el directorio `lib`.

Para probar el paquete, añade [test unitarios](https://flutter.io/testing/#unit-testing)
en el directorio `test`.

Para detalles adicionales sobre como organizar el contenido de un paquete, mira la documentación 
en [Dart library package](https://www.dartlang.org/guides/libraries/create-library-packages).

## Desarrollar paquetes de plugin {#plugin}

Si quieres desarrollar un paquete que hace llamadas a APIs específicas de plataforma, 
necesitas desarrollar un paquete de plugin. Un paquete de plugin es una version especiliazada 
de un paquete Dart, que además del contenido descrito anteriormente también contiene
implementaciones especificas de plataforma, escritas para Android (código Java o Kotlin) 
o para iOS (código Objective-C o Swift), o para ambas. La API se conecta con las
implementaciones específicas de plataforma usando [platform channels](/platform-channels/).

### Paso 1: Crea el paquete

Para crear el paquete de plugin, usa la opción `--template=plugin` con `flutter create`.

Usa la opción `--org` para especificar tu organización, usando notación de nombre de
dominio inversa. Este valor es usado en varios paquetes y bundle identifiers en el código
generado Android e iOS.

{% commandline %}
flutter create --org com.example --template=plugin hello
{% endcommandline %}

Esto crea un proyecto de plugin en la carpeta `hello/` con el siguiente contenido 
especializado:

* `lib/hello.dart`:
   - La API dart para el plugin.
* <code>android/src/main/java/com/example/&#8203;hello/HelloPlugin.java</code>:
   - La implementación específica de la API del plugin.
* `ios/Classes/HelloPlugin.m`:
   - La implementación ,especifica de plataforma iOS, de la API del plugin.
* `example/`:
   - Una app Flutter app que dependa del plugin, e ilustra como usarlo.

Por defecto, el proyecto de plugin usa código Objective-C para iOS y 
código Java para Android. Si prefieres Swift o Kotlin, puedes especificar el 
lenguaje iOS usando `-i` y/o el lenguaje Android usando `-a`. Por ejemplo:

{% commandline %}
flutter create --template=plugin -i swift -a kotlin hello
{% endcommandline %}

### Paso 2: Implementa el paquete {#edit-plugin-package}

Como un paquete de plugin, contiene código de diversas plataformas escritos en múltiples 
lenguajes de programación, son necesarios algunos pasos especificos para asegurar una 
experiencia adecuada.

#### Paso 2a: Define la API del paquete (.dart)

La API del paquete de plugin es definida en código Dart. Abre la carpeta principal `hello/`
en tu [editor Flutter] favorito(/get-started/editor/). Localiza el fichero 
`lib/hello.dart`.

#### Paso 2b: Añade el código de la platafoma Android (.java/.kt)

Te recomendamos que edites el código Android usando Android Studio.

Después de editar el código de la plataforma Android en Android Studio, primero asegúrate que 
el código ha sido compilado al menos una vez (ej., ejecuta la app de ejemplo desde tu IDE/editor,
o en terminal ejecuta `cd hello/example; flutter build apk`).

A continuación,

1. Lanza Android Studio
1. Selecciona 'Import project' en el diálogo 'Welcome to Android Studio', o selecciona
'File > New > Import Project...'' en el menú, y selecciona el fichero 
`hello/example/android/build.gradle`.
1. En el diálogo 'Gradle Sync' , selecciona 'OK'.
1. En el diálogo 'Android Gradle Plugin Update', selecciona 'Don't remind me again
   for this project'.

El código de la plataforma Android de tu plugin está ubicado en 
<code>hello/java/com.example.hello/&#8203;HelloPlugin</code>.

Puedes ejecutar la app de ejemplo desde Android Studio presionando el botón &#9654;.

#### Paso 2c: Añade el código de la plataforma iOS (.h+.m/.swift)

Te recomendamos editar tu código iOS en Xcode.

Después de editar el código de la plataforma iOS en Xcode, primero asegúrate que el 
código ha sido compilado al menos una vez (ej., ejecuta la app de ejemplo desde tu IDE/editor,
o en una terminal ejecuta `cd hello/example; flutter build ios --no-codesign`).

A continuación,

1. Lanza Xcode
1. Selecciona 'File > Open', y selecciona el fichero `hello/example/ios/Runner.xcworkspace`.

El código de la plataforma iOS de tu plugin esta ubicado en `Pods/Development
Pods/hello/Classes/` en Project Navigator.

Puedes ejecutar la app de ejemplo presionando el botón &#9654;.

#### Paso 2d: Conecta la API y el código de plataforma

Finalmente, necesitas conectar la API escrita en código Dart con las implementaciones 
específicas de plataforma. 
Esto se consigue usando [platform channels](/platform-channels/).

## Añadiendo documentación

Es una práctica recomendada añadir la siguiente documentación a todos los paquetes:

1. Un fichero `README.md` que hace de introducción al paquete
1. Un fichero `CHANGELOG.md` que documenta los cambios en cada versión
1. Un fichero `LICENSE` conteniendo los términos bajo los que el paquete es licensiado
1. Documentación de la API para todas las APIs públicas (mira abajo para más detalles)

### Documentación de API

Cuando publicas un paquete, la documentación de la API es generada y publicada automaticamente a 
dartdocs.org, mira por ejemplo la [documentación de device_info](https://www.dartdocs.org/documentation/device_info/0.0.4/index.html).

Si quieres generar documentación de la API localmente en tu máquina de desarrollo 
, usa los siguientes comandos:

1. Cambia al directorio en que está ubicado tu paquete:

   `cd ~/dev/mypackage`

1. Di a la herramienta de documentación donde esta el SDK de Flutter (
  cambialo para reflejar donde lo has ubicado):

   `export FLUTTER_ROOT=~/dev/flutter` (en macOS o Linux)

   `set FLUTTER_ROOT=~/dev/flutter` (en Windows)

1. Ejecuta la herramienta `dartdoc` (que viene como parte del SDK de Flutter):

   `$FLUTTER_ROOT/bin/cache/dart-sdk/bin/dartdoc` (en macOS o Linux)

   `%FLUTTER_ROOT%\bin\cache\dart-sdk\bin\dartdoc` (en Windows)

Para consejos sobre como escribir la documentación de la API, mira [Effective Dart: Documentation](https://www.dartlang.org/guides/language/effective-dart/documentation).

## Publicando paquetes {#publish}

Una vez que has implementado un paquete, puedes publicarlo en 
[Pub](https://pub.dartlang.org/), para que otros desarrolladores puedan usarlo fácilmente.

Antes de publicar, asegúrate de revisar el `pubspec.yaml`, `README.md`, y
`CHANGELOG.md` para estar seguro de que su contenido está completo y es correcto.

A continuación, ejecuta el comando dry-run para ver si todos los análisis pasan correctamente:

{% commandline %}
flutter packages pub publish --dry-run
{% endcommandline %}

Finalmente, ejecuta el comando actual para publicar:
{% commandline %}
flutter packages pub publish
{% endcommandline %}

Para detales sobre publicación, mira [Pub publishing docs](https://www.dartlang.org/tools/pub/publishing).

## Manejando interdependencias entre paquetes {#dependencies}

Si has desarrollado el paquete `hello` que depende de la API Dart expuesta por otro paquete,
necesitas añadir este paquete a la sección `dependencies` en tu fichero `pubspec.yaml`.
El código a continuación hace que la API Dart del plugin `url_launcher` esté disponible para `hello`:

En `hello/pubspec.yaml`:
```yaml
dependencies:
  url_launcher: ^0.4.2
```

Ahora puedes hacer `import 'package:url_launcher/url_launcher.dart'` y `launch(someUrl)` en 
el código Dart de `hello`.

Esto no es diferente de como incluyes paquetes en aplicaciones Flutter o en cualquier otro 
proyecto Dart.

Pero si `hello` resulta ser un paquete de _plugin_ cuyo código específico de plataforma 
necesita acceso al código específico de plataforma de la API expuesta por `url_launcher`, 
tambien necesitas añadir declaraciones de dependencia adecuadas a tus archivos de compilación 
específicos de plataforma, como mostramos abajo.

### Android

En `hello/android/build.gradle`:
```groovy
android {
    // varias líneas saltadas
    dependencies {
        provided rootProject.findProject(":url_launcher")
    }
}
```
Ahora puedes hacer `import io.flutter.plugins.urllauncher.UrlLauncherPlugin` y acceder a la clase 
`UrlLauncherPlugin` en el código fuent en `hello/android/src`.

### iOS

En `hello/ios/hello.podspec`:
```ruby
Pod::Spec.new do |s|
  # varias líneas saltadas
  s.dependency 'url_launcher'
```
Ahora puedes hacer `#import "UrlLauncherPlugin.h"` y acceder a la clase `UrlLauncherPlugin` 
en el código fuente en `hello/ios/Classes`.

### Resolución de conflictos

Supón que quieres usar `algun_paquete` y `otro_paquete` en tu paquete `hello`, y ambos dependen de 
`url_launcher`, pero en diferentes versiones. Entonces tenemos un conflicto en potencia. La mejor manera de evitar 
esto para el autor del paquete es usar los [rangos de versiones](https://www.dartlang.org/tools/pub/dependencies#version-constraints)
antes que versiones especificas cuando especificamos las dependencias.

```yaml
dependencies:
  url_launcher: ^0.4.2    # Bien, cuaquiera 0.4.x with x >= 2 valdrá.
  image_picker: '0.1.1'   # No tan bien, solo 0.1.1 valdrá.
```

Si `algun_paquete` declara las dependencias anteriores y `otro_paquete` declara una dependencia con 
`url_launcher` compatible, como `'0.4.5'` o `^0.4.0`, `pub` podrá resolver este problema automáticamente. 
Algo similar se aplica a las depedencias específicas de plataforma, en paquetes de plugin, en [Gradle modules](https://docs.gradle.org/current/userguide/dependency_management.html#sub:dynamic_versions_and_changing_modules)
y/o [Cocoa pods](https://guides.cocoapods.org/syntax/podspec.html#dependency).

Incluso si `algun_paquete` y `otro_paquete` declaran versiones incompatibles para `url_launcher`, aún puede
ser que estos usen `url_launcher` de maneras compatibles. Entonces el conflicto puede resolverse agregando 
una sobrescritura de dependencia al fichero `pubspec.yaml` en `hello`, forzando a usar una versión en 
particular:

Forzando el uso de la version `0.4.3` de `url_launcher` en `hello/pubspec.yaml`:
```yaml
dependencies:
  some_package:
  other_package:
dependency_overrides:
  url_launcher: '0.4.3'
```

Si la dependencia conflictiva no es en si misma un paquete, sino una biblioteca específica de Android 
como `guava`, la declarción de sobrescritura de dependencia debe ser añadida en cambio, a la lógica de compilado de 
Gradle en su lugar.

Fozando el uso de la version `23.0` de `guava` en `hello/android/build.gradle`:
```groovy
configurations.all {
    resolutionStrategy {
        force 'com.google.guava:guava:23.0-android'
    }
}
```

Cocoapods no ofrece actualmente la funcionalidad de sobrescritura de dependencias.