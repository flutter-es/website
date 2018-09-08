---
layout: page
title: Añadir Assets e Imágenes en Flutter

permalink: /assets-and-images/
---

* TOC Placeholder
{:toc}

## Introducción

Las aplicaciones de Flutter pueden incluir tanto código como _assets_ (algunas veces llamado recursos). Un asset es un archivo que se incluye e implementa con su aplicación, y es accesible en tiempo de ejecución. Los tipos comunes de recursos incluyen datos estáticos (por ejemplo, archivos JSON), archivos de configuración, iconos e imágenes (JPEG, WebP, GIF, WebP/GIF animados, PNG, BMP y WBMP).

## Especificando recursos

Flutter usa el archivo [`pubspec.yaml`](https://www.dartlang.org/tools/pub/pubspec), ubicado en la raíz de su proyecto, para identificar los recursos requeridos por una aplicación.

Aquí hay un ejemplo:

```yaml
flutter:
  assets:
    - assets/my_icon.png
    - assets/background.png
```

Para incluir todos los assets en un directorio, especifique el nombre del directorio con el carácter `/` al final:

```yaml
flutter:
  assets:
    - assets/
```

Tenga en cuenta que solo se incluirán los archivos ubicados directamente en el directorio; para agregar archivos ubicados en subdirectorios, cree una entrada por directorio.

### Agrupación de recursos

La subsección `assets` de la sección `flutter` especifica los archivos que deberían incluirse con la aplicación. Cada recurso se identifica mediante una ruta explícita (relativa al archivo `pubspec.yaml`) donde se encuentra la carpeta de recursos. El orden en que se declaran los recursos no importa. El directorio real utilizado ( `assets` en este caso) no importa.

Durante una compilación, Flutter coloca los recursos en un archivo especial llamado _asset bundle_ (paquete de recursos), del cual las aplicaciones pueden leer en tiempo de ejecución.

### Variantes de recursos

El proceso de compilación admite la noción de variantes de recursos: diferentes versiones de un activo que pueden mostrarse en diferentes contextos. Cuando se especifica la ruta de un recurso en la sección `assets` de `pubspec.yaml`, el proceso de compilación busca cualquier archivo con el mismo nombre en subdirectorios adyacentes. Dichos archivos se incluyen en el paquete de recursos junto con el activo especificado.

Por ejemplo, si tiene los siguientes archivos en el directorio de su aplicación:

```
  .../pubspec.yaml
  .../graphics/my_icon.png
  .../graphics/background.png
  .../graphics/dark/background.png
  ...etc.
```
...y su archivo `pubspec.yaml` contiene:

```yaml
flutter:
  assets:
    - graphics/background.png
```

...entonces ambos `graphics/background.png` y `graphics/dark/background.png` se incluirán en su paquete de recursos. El primero se considera el _main asset_ (recurso principal), mientras que el segundo se considera una _variante_.

Si, por otro lado, se especifica el directorio de gráficos:
```yaml
flutter:
  assets:
    - graphics/
```

...entonces `graphics/my_icon.png`, `graphics/background.png` y `graphics/dark/background.png` serán incluidos.

Flutter utiliza variantes de recursos al elegir imágenes apropiadas para la resolución; observa abajo. En el futuro, este mecanismo se puede ampliar para incluir variantes para diferentes lugares o regiones, leer instrucciones, etc.

## Cargando recursos

Tu aplicación puede acceder a sus recursos a través de un objeto
[`AssetBundle`](https://docs.flutter.io/flutter/services/AssetBundle-class.html) (paquete de recursos).

Los dos métodos principales en un paquete de recursos te permiten cargar un elemento de texto (`loadString`) o una imagen/recurso binario (`load`) fuera del paquete, dada una clave lógica. La clave lógica se correlaciona con la ruta al recurso especificado en el archivo `pubspec.yaml` durante el tiempo de compilación.

### Cargando elementos de texto

Cada aplicación Flutter tiene un [`rootBundle`](https://docs.flutter.io/flutter/services/rootBundle.html) (paquete raiz) para acceder fácilmente al paquete de recursos principal. Es posible cargar recursos directamente utilizando la `rootBundle` estática global de `package:flutter/services.dart`.

Sin embargo, se recomienda obtener el AssetBundle para el BuildContext actual utilizando `DefaultAssetBundle`. En lugar del paquete de recursos predeterminado que se creó con la aplicación, este enfoque permite que un Widget principal sustituya un AssetBundle diferente en tiempo de ejecución, lo que puede ser útil para escenarios de localización o prueba.

Normalmente, utilizará `DefaultAssetBundle.of()` para cargar indirectamente un recurso, por ejemplo un archivo JSON, desde el `rootBundle` en tiempo de ejecución de la aplicación.

{% comment %}

  Need example here to show obtaining the AssetBundle for the current
  BuildContext using DefaultAssetBundle.of

{% endcomment %}

Fuera de un contexto de Widget, o cuando no está disponible un identificador para un AssetBundle, puede usar `rootBundle` para cargar directamente dichos recursos, por ejemplo:

```dart
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}
```

### Cargando imágenes

Flutter puede cargar imágenes con la resolución apropiada para la relación de píxeles del dispositivo actual.

#### Declaración de assets de imagen según la resolución {#resolution-aware}

[`AssetImage`](https://docs.flutter.io/flutter/painting/AssetImage-class.html) entiende cómo asignar un recurso solicitado lógico a uno que se aproxime más a la proporción actual de píxeles del dispositivo. Para que esta asignación funcione, los activos se deben organizar de acuerdo con una estructura de directorios particular:

```
  .../image.png
  .../Mx/image.png
  .../Nx/image.png
  ...etc.
```
...donde **M** y **N** son identificadores numéricos que corresponden a la resolución nominal de las imágenes contenidas en el interior, en otras palabras, especifican la relación de píxel del dispositivo para el que están destinadas las imágenes.

Se supone que el recurso principal corresponde a una resolución de 1.0. Por ejemplo, considera el siguiente diseño de recursos para una imagen llamada `my_icon.png`:

```
  .../my_icon.png
  .../2.0x/my_icon.png
  .../3.0x/my_icon.png
```

En los dispositivos con una relación de píxel de dispositivo de 1.8, se elegiría el recurso `.../2.0x/my_icon.png`. Para una proporción de píxel de dispositivo de 2.7, se elegiría el recurso `.../3.0x/my_icon.png`.

Si el ancho y el alto de la imagen renderizada no están especificados en el Widget `Image`, la resolución nominal se usa para escalar el recurso de modo que ocupe la misma cantidad de espacio en la pantalla que el recurso principal, solo con una resolución más alta. Es decir, si `.../my_icon.pnges` es de 72px por 72px, entonces `.../3.0x/my_icon.png` debería ser de 216px por 216px; pero ambos se procesarán en 72px por 72px (en píxeles lógicos) si no se especifican el ancho y el alto.

Cada entrada en la sección de recursos de `pubspec.yaml` debe corresponder a un archivo real, con la excepción de la entrada del recurso principal. Si la entrada del recurso principal no corresponde a un archivo real, entonces el recurso con la resolución más baja se utilizará como respaldo para los dispositivos con proporciones de píxel del dispositivo por debajo de esa resolución. Sin embargo, la entrada debe incluirse en el manifiesto `pubspec.yaml`.

#### Cargando imagenes

Para cargar una imagen, usa la clase [`AssetImage`](https://docs.flutter.io/flutter/painting/AssetImage-class.html) en el método `build` de un Widget.

Por ejemplo, tu aplicación puede cargar la imagen de fondo de las declaraciones de recursos anteriores:

```dart
Widget build(BuildContext context) {
  // ...
  return DecoratedBox(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('graphics/background.png'),
        // ...
      ),
      // ...
    ),
  );
  // ...
}
```

Cualquier cosa que use el paquete de assets predeterminado heredará el conocimiento de la resolución al cargar imágenes. (Si trabaja con algunas de las clases de nivel inferior, como [`ImageStream`](https://docs.flutter.io/flutter/painting/ImageStream-class.html) o [`ImageCache`](https://docs.flutter.io/flutter/painting/ImageCache-class.html), también notarás los parámetros relacionados con la escala).

### Recursos de imágenes en paquetes {#from-packages}

Para cargar una imagen desde un [paquete](https://flutter.io/using-packages/), el argumento `package` se debe proporcionar a [`AssetImage`](https://docs.flutter.io/flutter/painting/AssetImage-class.html).

Por ejemplo, supongamos que su aplicación depende de un paquete llamado `my_icons`, que tiene la siguiente estructura de directorio:

```
  .../pubspec.yaml
  .../icons/heart.png
  .../icons/1.5x/heart.png
  .../icons/2.0x/heart.png
  ...etc.
```

Entonces, para cargar la imágen, usa:

<!-- skip -->
```dart
 AssetImage('icons/heart.png', package: 'my_icons')
```

Los recursos utilizados por el paquete en sí también se deben buscar usando el argumento `package` como se indica arriba.

#### Agrupando recursos de un paquete

Si el recurso deseado se especifica en el archivo `pubspec.yaml` del paquete, se incluye automáticamente con la aplicación. En particular, los assets utilizados por el paquete en sí se deben especificar en su `pubspec.yaml`.

Un paquete también puede elegir tener activos en su carpeta `lib/` que no estén especificados en su archivo `pubspec.yaml`. En este caso, para que las imágenes se agrupen, la aplicación debe especificar cuáles incluir en su `pubspec.yaml`. Por ejemplo, un paquete nombrado `fancy_backgrounds` podría tener los siguientes archivos:

```
  .../lib/backgrounds/background1.png
  .../lib/backgrounds/background2.png
  .../lib/backgrounds/background3.png
```
Para incluir, por ejemplo, la primera imagen, el `pubspec.yaml` de la aplicación debe especificarla en la sección `assets`:

```yaml
flutter:
  assets:
    - packages/fancy_backgrounds/backgrounds/background1.png
```

La `lib/` está implícita, por lo que no debe incluirse en la ruta del recurso.

## Compartir recursos con la plataforma subyacente

Los recursos de Flutter están disponibles para el código de la plataforma a través de AssetManager en Android y NSBundle en iOS.

### Android

En Android, los recursos están disponibles a través de la [API de AssetManager](https://developer.android.com/reference/android/content/res/AssetManager.html). La clave de búsqueda utilizada, por ejemplo [openFd](https://developer.android.com/reference/android/content/res/AssetManager.html#openFd(java.lang.String)) se obtiene a partir de `lookupKeyForAsset` en [PluginRegistry.Registrar](https://docs.flutter.io/javadoc/io/flutter/plugin/common/PluginRegistry.Registrar.html) o `getLookupKeyForAsset` en [FlutterView](https://docs.flutter.io/javadoc/io/flutter/view/FlutterView.html). `PluginRegistry.Registrar` está disponible cuando se desarrolla un complemento, mientras que `FlutterView` sería la opción al desarrollar una aplicación que incluye una vista de plataforma.

Como ejemplo, suponga que ha especificado esto en su pubspec.yaml

```yaml
flutter:
  assets:
    - icons/heart.png
```
reflejando la siguiente estructura en su aplicación Flutter.

```
  .../pubspec.yaml
  .../icons/heart.png
  ...etc.
```

Para acceder a `icons/heart.png` desde tu código de complemento de Java, lo harías;

```java
AssetManager assetManager = registrar.context().getAssets();
String key = registrar.lookupKeyForAsset("icons/heart.png");
AssetFileDescriptor fd = assetManager.openFd(key);
```

### iOS

En iOS, los recursos están disponibles a través de [mainBundle](https://developer.apple.com/documentation/foundation/nsbundle/1410786-mainbundle). La clave de búsqueda utilizada, por ejemplo [pathForResource:ofType:](https://developer.apple.com/documentation/foundation/nsbundle/1410989-pathforresource) se obtiene de `lookupKeyForAsset` o `lookupKeyForAsset:fromPackage:` en [FlutterPluginRegistrar](https://docs.flutter.io/objcdoc/Protocols/FlutterPluginRegistrar.html) o `lookupKeyForAsset:` o `lookupKeyForAsset:fromPackage:` en [FlutterViewController](https://docs.flutter.io/objcdoc/Classes/FlutterViewController.html). `FlutterPluginRegistrar` está disponible cuando se desarrolla un complemento, mientras que `FlutterViewController` sería la opción al desarrollar una aplicación que incluye una vista de plataforma.

Como ejemplo, supongamos que tiene la configuración de Flutter de arriba.

Para acceder `icons/heart.png` desde tu código de complemento Objective-C, lo haría;

```objective-c
NSString* key = [registrar lookupKeyForAsset:@"icons/heart.png"];
NSString* path = [[NSBundle mainBundle] pathForResource:key ofType:nil];
```
Para obtener un ejemplo más completo, consulta la implementación [del plugin de video_player](https://pub.dartlang.org/packages/video_player) de Flutter.

## Recursos de plataforma

También habrá ocasiones para trabajar directamente con los recursos en los proyectos de la plataforma. A continuación, se muestran dos casos comunes en los que se utilizan recursos antes de que se cargue y se ejecute el framework Flutter.

### Actualizando el ícono de la aplicación

La actualización del icono de inicio de la aplicación de Flutter funciona de la misma manera que la actualización de iconos de inicio en aplicaciones nativas de Android o iOS.

![Launch icon](/images/assets-and-images/icon.png)

#### Android

En el directorio raíz de tu proyecto Flutter, ve a `.../android/app/src/main/res`. Las diversas carpetas de recursos de mapa de bits como `mipmap-hdpi` ya contienen imágenes placeholder nombradas `ic_launcher.png`. Simplemente reemplázalos con tus recursos deseados respetando el tamaño de icono recomendado por densidad de pantalla según lo indicado por la [Guía del desarrollador de Android](https://developer.android.com/guide/practices/ui_guidelines/icon_design_launcher.html#size).

![Android icon location](/images/assets-and-images/android-icon-path.png)

<aside class="alert alert-info" markdown="1">
**Nota:** si cambia el nombre de los archivos .png, también debe coincidir con el nuevo nombre en el atributo `android:icon` de `AndroidManifest.xml` en su etiqueta <application>.
</aside>

#### iOS

En el directorio raíz de tu proyecto Flutter, ve a `.../ios/Runner`. El directorio `Assets.xcassets/AppIcon.appiconset` ya contiene imágenes placeholder. Simplemente reemplácelos con las imágenes de tamaño adecuado según lo indicado por su nombre de archivo según lo dictado por las [Pautas de interfaz humana de Apple](https://developer.apple.com/ios/human-interface-guidelines/graphics/app-icon). Mantener los nombres de los archivos originales.

![iOS icon location](/images/assets-and-images/ios-icon-path.png)

### Actualizando la pantalla de bienvenida

<p align="center">
  <img src="/images/assets-and-images/launch-screen.png" alt="Launch screen" />
</p>

Flutter también usa mecanismos de plataformas nativas para dibujar pantallas de lanzamiento de transición a su aplicación Flutter mientras se carga el framework Flutter. Esta pantalla de bienvenida continuará hasta que Flutter represente el primer frame de tu aplicación.

<aside class="alert alert-info" markdown="1">
**Nota:** esto implica que si no llamas a [runApp](https://docs.flutter.io/flutter/widgets/runApp.html) en la función `void main()` de tu aplicación (o más específicamente, si no llamas a [`window.render`](https://docs.flutter.io/flutter/dart-ui/Window/render.html) en respuesta [`window.onDrawFrame`](https://docs.flutter.io/flutter/dart-ui/Window/onDrawFrame.html)), la pantalla de bienvenida se mantendrá para siempre.
</aside>

#### Android

Para agregar una "pantalla de bienvenida" a tu aplicación Flutter, ve a `.../android/app/src/main`. En `res/drawable/launch_background.xml`, puedes usar esta [layer list drawable](https://developer.android.com/guide/topics/resources/drawable-resource.html#LayerList) XML para personalizar el aspecto de su pantalla de bienvenida. La plantilla existente proporciona un ejemplo para agregar una imagen a la mitad de una pantalla blanca en el código comentado. Puedes descomentarlo o usar otros objetos [drawables](https://developer.android.com/guide/topics/resources/drawable-resource.html) para lograr el efecto deseado.

#### iOS

Para agregar una imagen al centro de tu "pantalla de bienvenida", ve a `.../ios/Runner`. En, `Assets.xcassets/LaunchImage.imageset`, coloca imágenes llamadas `LaunchImage.png`, `LaunchImage@2x.png`, `LaunchImage@3x.png`. Si usas diferentes nombres de archivo, también deberás actualizar el archivo `Contents.json` en el mismo directorio.

También puedes personalizar completamente tu storyboard de pantalla de bienvenida en Xcode abriendo `.../ios/Runner.xcworkspace`. Navega hasta `Runner/Runner` en el Navegador de proyectos y coloca las imágenes abriendo `Assets.xcassets` o realiza cualquier personalización usando el Constructor de interfaces en `LaunchScreen.storyboard`.

![Adding launch icons in Xcode](/images/assets-and-images/ios-launchscreen-xcode.png)
