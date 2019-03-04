---
title: Compatibilidad con AndroidX
description: Cómo solucionar las incompatibilidades de AndroidX que han sido detectadas en el framework Flutter.
---

{{site.alert.note}}
  Es posible que se te dirija a esta página si el framework detecta un problema en su aplicación Flutter que involucra incompatibilidades de AndroidX.
{{site.alert.end}}

El código de Android a menudo utiliza las bibliotecas [`android.support`]({{site.android-dev}}/topic/libraries/support-library/) para garantizar la compatibilidad con versiones anteriores. Las bibliotecas `android.support` están obsoletas, y fueron reemplazadas con [AndroidX]({{site.android-dev}}/jetpack/androidx/). AndroidX tiene similitudes de funciones con las bibliotecas antiguas con algunas capacidades adicionales, pero, desafortunadamente, estos dos conjuntos de bibliotecas son incompatibles.

_Gradle se bloquea al intentar crear un APK que se basa en ambos conjuntos de bibliotecas._ Esta página explica cómo podés solucionar este problema.

## Arreglando fallas de AndroidX en una aplicación Flutter

AndroidX puede romper una aplicación Flutter en tiempo de compilación de dos maneras:

1. La aplicación utiliza un complemento de AndroidX y su archivo `build.gradle` principal tiene en `compileSdkVersion` una versión menor a 28.
2. La aplicación utiliza tanto el código AndroidX como el obsoleto al mismo tiempo.

Los mensajes de error del Gradle varían. A veces, los mensajes mensionan "package androidx" o "package android.support" directamente. Sin embargo, a menudo los mensajes de error del Gradle no son obvios, y en cambio hablan de "AAPT", "AAPT2", o "parsing resources".

Estos problemas deben solucionarse ya sea migrando manualmente el código a la misma biblioteca, o degradando las versiones de los complementos que aún utilizas las bibliotecas de soporte originales.

### Cómo migrar una aplicación Flutter a AndroidX

{{site.alert.note}}
  Es imposible migrar completamente tu aplicación a AndroidX si estás utilizando activamente algunos complementos que dependen de la antigua biblioteca de soporte. Si su aplicación depende de los complementos que utilizan los paquetes `android.support` anteriores, deberá [evitar el uso de AndroidX](#avoiding-androidx).
{{site.alert.end}}

Primero asegúrate de que `compileSdkVersion` sea al menos `28` en `app/build.gradle`. Esta propiedad controla la versión del SDK de Android que Gradle usa para construir tu APK. No afecta a la versión mínima de SDK con la que se puede ejecutar tu aplicación. Consulte la documentación del desarrollador de Android en [el archivo de compilación a nivel módulo]({{site.android-dev}}/studio/build/#module-level) para obtener más información.

#### Recomendado: usa Android Studio para migrar tu aplicación

Esto requiere la última versión de Android Studio. Usa las siguientes instrucciones:

1. Importa tu aplicación Flutter en Android Studio para que el IDE pueda analizar el código de Android siguiendo los pasos en [Edición del código de Android en Android Studio con soporte completo de IDE](/docs/development/tools/android-studio#android-ide).
2. Sigue las instrucciones para [Mirgrar a AndroidX]({{site.android-dev}}/jetpack/androidx/migrate).

#### No recomendado: migra manualmente tu aplicación

Consulte [Migrando a AndroidX]({{site.android-dev}}/jetpack/androidx/migrate) para obtener instrucciones detalladas sobre cómo hacerlo.

### Evitando AndroidX

Si deseas o necesitas evitar la migración a AndroidX, deberá fijar las dependencias de tus complementos en `pubspec.yaml` a la última versión principal antes de que se migraran.

Estas son las últimas versiones disponibles de todos los paquetes `flutter/plugins` que son pre AndroidX:

- `android_alarm_manager`: 0.2.3
- `android_intent`: 0.2.1
- `battery`: 0.3.0
- `camera`: 0.2.9+1
- `cloud_firestore`: 0.8.2+3
- `cloud_functions`: 0.0.5
- `connectivity`: 0.3.2
- `device_info`: 0.3.0
- `firebase_admob`: 0.7.0
- `firebase_analytics`: 1.1.0
- `firebase_auth`: 0.7.0
- `firebase_core`: 0.2.5+1
- `firebase_database`: 1.0.5
- `firebase_dynamic_links`: 0.1.1
- `firebase_messaging`: 2.1.0
- `firebase_ml_vision`: 0.2.1
- `firebase_performance`: 0.0.8+1
- `firebase_remote_config`: 0.0.6+1
- `firebase_storage`: 1.0.4
- `google_maps_flutter`: 0.1.0
- `google_sign_in`: 3.2.4
- `image_picker`: 0.4.12+1
- `local_auth`: 0.3.1
- `package_info`: 0.3.2+1
- `path_provider`: 0.4.1
- `quick_actions`: 0.2.2
- `sensors`: 0.3.5
- `share`: 0.5.3
- `shared_preferences`: 0.4.3
- `url_launcher`: 4.1.0+1
- `video_player`: 0.9.0
- `webview_flutter`: 0.2.0

Ten en cuenta que esta no es una lista exhaustiva de todos los plugins de Flutter que
usan AndroidX, y la dependencia de AndroidX en tu app puede proceder 
de otro plugin distinto a estos.

## Para los mantenedores de complementos: Migrar un complemento de Flutter a AndroidX

La migración de un complemento de Flutter a AndroidX sigue básicamente el mismo proceso que la [migración de una aplicación Flutter](#How-to-migrate-a-Flutter-app-to-AndroidX), pero con algunas preocupaciones adicionales y algunos cambios leves.

1. Asegúrate de incrementar la [version principal]({{site.dart-site}}/tools/pub/versioning#semantic-versions) de tu complemento para este cambio y documéntalo claramente en el registro de cambios de tu complemento. Este cambio de última hora requiere una migración manual para que los usuarios puedan corregirlo. Pub trata los dígitos de manera diferente dependiendo de si un complemento es anterior o posterior a la 1.0.0. El primer dígito es la versión principal para los complementos que están en o por encima de 1.0.0. Para los complementos por debajo de 1.0.0, el dígito medio se considera la versión principal.
2. El código del complemento se puede migrar automáticamente con Android Studio de la misma manera que el código de una aplicación Flutter. Importa la aplicacion `plugin_root/example` en el IDE como si fuera una aplicación normal de Flutter. Android Studio también importa y analiza el código de Android del complemento.

