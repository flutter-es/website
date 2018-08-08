---
layout: page
title: Prepararando una aplicación de Android para su liberación

permalink: /android-release/
---

Durante el ciclo de desarrollo típico, probarás una aplicación usando `flutter run` en la
línea de comando, los botones Ejecutar y Depurar de la barra de herramientas en IntelliJ, o ambos. Por defecto, Flutter crea una versión *de depuración* de su aplicación.

Cuando esté listo para preparar una versión de *liberación* para Android, por ejemplo para
[publicarla a Google Play Store][play], siga los pasos en esta página.

* TOC Placeholder
{:toc}

## Revisa el App Manifest

Revisa el archivo de [Manifiesto de la aplicación][manifest] `AndroidManifest.xml` localizado
en el directorio `<app dir>/android/app/src/main/` y verifique si los valores son correctos,
especialmente:

* `application`: Edite la etiqueta [`application`][applicationtag] para reflejar el nombre
final de la aplicación.

* `uses-permission`: Remueva el [permiso][permissiontag] `android.permission.INTERNET`
si su código de la aplicación no necesita acceso a Internet. 
access. La plantilla estándar incluye esta etiqueta para permitir la comunicación entre
Herramientas de flutter y una aplicación en ejecución.

## Revisa la configuración de compilación

Revisa el archivo por defecto de [Gradle build][gradlebuild] `build.gradle`
localizado en el directorio `<app dir>/android/app/` y verifique si los valores estan correctos, especialmente:

* `defaultConfig`:

  * `applicationId`: Especifique el (Id de Aplicación)[appid]Specify final y único.

  * `versionCode` & `versionName`: Especifique el número de versión de la aplicación interna, y
  la cadena de número de versión. Consulte la guía de información de versión en
  la [documentación de versiones][versions] para más detalle.

  * `minSdkVersion` & `targetSdkVersion`: Especifique el nivel mínimo de API y el nivel de nivel en el que se está diseñando la aplicación. Consulte la sección de contenido de la API el las [documentación de versiones][versions] para más detalle.

## Añadiendo un icono para el Launcher

Cuando una nueva aplicación Flutter es creada, este tiene un icono de Launcher por defecto. Para personalizar este icono usted debería 
customize this icon es posible que desee ver el paquete [Iconos del launcher de Flutter](https://pub.dartlang.org/packages/flutter_launcher_icons).

Alternativamente, si desea hacerlo manualmente, aquí está como:

1. Revise las pautas de [Iconos del Launcher de Android][launchericons] para el diseño del ícono.

1. En el directorio `<app dir>/android/app/src/main/res/` , coloque sus archivos de iconos en la carpeta señalada
usando los [Calificadores de Configuración][configurationqualifiers].
Las carpetas predeterminadas `mipmap-` demuestran la convención de nomenclatura correcta.

1. En `AndroidManifest.xml`, actualice el atributo `android:icon` de la etiqueta [`application`][applicationtag] a los
iconos de referencia del paso anterior (por ejemplo, `<application android:icon="@mipmap/ic_launcher" ...`).

1. Para verificar que los iconos han sido reemplazados, ejecute su app usando `flutter run` e inspeccione el icono de la app en el 
Launcher.

## Firmando la app

### Creando un Keystore
Si usted tiene un Keystore, salte al siguiente paso. Si no, cree una corriendo lo siguiente en
la línea de comandos:
`keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key`

*Nota*: Mantenga est archivo privado; no lo verifique en el control de fuente pública.

*Nota*: `keytool` puede no estar en su ruta. Este es parte del JDK de Java, el cual es instalado como parte
de Android Studio. Para la ruta en concreto, ejecute `flutter doctor -v` y vea la ruta impresa después
de 'Java binary at:', y luego use esa ruta completamente calificada reemplazando `java` con` keytool`.

### Referencie el keystore desde la app

Cree un arfchivo llamado `<app dir>/android/key.properties` que contiene una referencia a su keystore:

```
storePassword=<contraseña del paso anterior>
keyPassword=<contraseña del paso anterior>
keyAlias=key
storeFile=<localización del archivo, por ejemplo /Users/<user name>/key.jks>
```

*Nota*: Mantenga est archivo privado; no lo verifique en el control de fuente pública.

### Configurar la firma en Gradle

Configure la firma de su app editando el archivo `<app dir>/android/app/build.gradle`
file.

1. Reemplace:
```
   android {
```
   con la información de la keystore desde su archivo de propiedades:
```
   def keystorePropertiesFile = rootProject.file("key.properties")
   def keystoreProperties = new Properties()
   keystoreProperties.load(new FileInputStream(keystorePropertiesFile))

   android {
```

1. Reemplace:
```
   buildTypes {
       release {
           // TODO: Add your own signing config for the release build.
           // Signing with the debug keys for now, so `flutter run --release` works.
           signingConfig signingConfigs.debug
       }
   }
```
   con:
```
   signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile file(keystoreProperties['storeFile'])
           storePassword keystoreProperties['storePassword']
       }
   }
   buildTypes {
       release {
           signingConfig signingConfigs.release
       }
   }
```

Las versiones de lanzamiento de su aplicación ahora se firmarán automáticamente.


## Habilitando Proguard

Por defecto, Flutter no ofusca o minifica el Android host.
Si usted intenta usar librerias de Java de terceras partes,
usted puede querer reducir el tamaño del APK o proteger ese código de ingeniería inversa.

Para información sobre código Dart de ofuscamiento, vea [Código Dart de Ofuscamiento](https://github.com/flutter/flutter/wiki/Obfuscating-Dart-Code)
En el [wiki de Flutter](https://github.com/flutter/flutter/wiki/).

### Paso 1 - Configurar Proguard

Cree el archivo `/android/app/proguard-rules.pro` y añada las reglas listada a continuación.

```
#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
```

La configuración anterior solo protege las bibliotecas del motor de Flutter. Cualquier biblioteca adicional (por ejemplo, Firebase) requiere que se agreguen sus propias reglas.

### Paso 2 - Habilite obfuscación y/o minificación

Abra el archivo `/android/app/build.gradle` y localice la definición `buildTypes`.
Dentro de la configuración `release` establezca las banderas `minifiyEnabled` y `useProguard`
a true. Usted tiene que también apuntar ProGuard al archivo que usted ha creado en el paso 1.

```
android {

    ...

    buildTypes {

        release {

            signingConfig signingConfigs.debug

            minifyEnabled true
            useProguard true

            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'

        }
    }
}
```

Nota: La ofuscación y la minificación pueden ampliar considerablemente el tiempo de compilación de la aplicación de Android.

## Construyendo una versión de APK

Esta sección describe cómo crear una versión APK. Si completó los pasos de firma en la sección anterior, se firmará la versión APK.

Usando la línea de comandos:

1. `cd <app dir>` (replace `<app dir>` con su directorio de la aplicación).
1. Ejecute `flutter build apk` (`flutter build` defaults to `--release`).

La versión APK para su aplicación se crea en `<app dir>/build/app/outputs/apk/app-release.apk`.

## Instalación de una versión APK en un dispositivo

Siga estos pasos para instalar el APK creado en el paso anterior en un dispositivo Android conectado.

Usando la línea de comando:

1. Conecte su dispositivo Android a su computadora con un cable USB.
1. `cd <app dir>` donde `<app dir>` es su directorio de la aplicación.
1. Ejecute `flutter install` .

## Publicación de una APK en Google Play Store

Para obtener instrucciones detalladas sobre la publicación de la versión de lanzamiento de una aplicación en Google Play Store, consulte la [documentación de publicación de Google Play][play].

[manifest]: http://developer.android.com/guide/topics/manifest/manifest-intro.html
[manifesttag]: https://developer.android.com/guide/topics/manifest/manifest-element.html
[appid]: https://developer.android.com/studio/build/application-id.html
[permissiontag]: https://developer.android.com/guide/topics/manifest/uses-permission-element.html
[applicationtag]: https://developer.android.com/guide/topics/manifest/application-element.html
[versions]: https://developer.android.com/studio/publish/versioning.html
[launchericons]: https://developer.android.com/guide/practices/ui_guidelines/icon_design_launcher.html
[configurationqualifiers]: https://developer.android.com/guide/practices/screens_support.html#qualifiers
[play]: https://developer.android.com/distribute/googleplay/start.html
