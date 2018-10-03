---
layout: page
title: Entrega Continua usando fastlane con Flutter
description: Como usar fastlane para automatizar la compilación y proceso de release de tu aplicación Flutter.

permalink: /fastlane-cd/
---

Sigue las mejores prácticas de Entrega Continua con Flutter para asegurar que tu 
aplicación sea entregada a tus beta testers y validada con frequencia sin tener que 
recurrir a workflows manuales.

Esta guía muestra como integrar [fastlane](https://docs.fastlane.tools/), un suite 
de herramientas de código abierto, con tus workflows de pruebas en integración continua 
(CI) existentes (por ejemplo, Travis o Cirrus).

* TOC Placeholder
{:toc}

## Configuración local

Se recomienda que pruebes el proceso de compilación y despliegue localmente antes de migrar 
a un sistema basado en la nube. Podrías también elegir realizar entrega continua desde 
una máquina local.

1. Instala fastlane `gem install fastlane` o `brew cask install fastlane`.
1. Crea tu proyecto Flutter, y cuando esté listo, asegúrate que tu proyecto compila via
    * ![Android](/images/fastlane-cd/android.png) `flutter build apk --release`; y
    * ![iOS](/images/fastlane-cd/ios.png) `flutter build ios --release --no-codesign`.
1. Inicializa el proyecto fastlane para cada plataforma.
    * ![Android](/images/fastlane-cd/android.png) En tu carpeta `[project]/android`
    , ejecuta `fastlane init`.
    * ![iOS](/images/fastlane-cd/ios.png) En tu carpeta `[project]/ios`,
    ejecuta `fastlane init`.
1. Edita el `Appfile` para asegurar que tenga los metadatos adecuados para tu app.
    * ![Android](/images/fastlane-cd/android.png) Verifica que `package_name` en
    `[project]/android/Appfile` coincida con tu nombre de paquete en pubspec.yaml.
    * ![iOS](/images/fastlane-cd/ios.png) Verifica que `app_identifier` en
    `[project]/ios/Appfile` también coincida. Rellena `apple_id`, `itc_team_id`,
    `team_id` con tu información respectiva de tu cuenta.
1. Configura las credenciales de inicio de sesión locales para las tiendas.
    * ![Android](/images/fastlane-cd/android.png) Sigue los [pasos de configuración de Supply](https://docs.fastlane.tools/getting-started/android/setup/#setting-up-supply)
    y asegúrate que `fastlane supply init` sincroniza con existo datos de tu consola de 
    Play Store. _Trata el fichero .json como tu contraseña y no lo incluyas en ningún 
    repositorio de control de código público._
    * ![iOS](/images/fastlane-cd/ios.png) Tu nombre de usuario de iTunes Connect ya está en 
    tu campo `apple_id` de `Appfile`. Configura la variable de entorno de consola `FASTLANE_PASSWORD` 
    con tu contraseña de iTunes Connect. De otra manera, se te preguntaría cuando 
    se suba a iTunes/TestFlight.
1. Configura el firmado de código.
    * ![Android](/images/fastlane-cd/android.png) En Android, hay dos claves de firmado 
    : despliegue y subida. El usuario final descarga el .apk firmado con la 
    'clave de despligue'. Y la 'clave de subida' es usada para autentificar el .apk
    subido por los desarrolladores en la Play Store y es refirmado con la clave de despliegue 
    una vez en la Play Store.
        * Se recomienda muy especialmente utilizar la autenticación automática administrada 
        en la nube para la clave de despliegue. Para obtener más información, consulta la [documentación oficial de Play Store](https://support.google.com/googleplay/android-developer/answer/7384423?hl=en).
        * Sigue los pasos de [generación de claves](https://developer.android.com/studio/publish/app-signing#sign-apk)
        para crear tu clave de subida.
        * Configura gradle para usar tu clave de subida cuando compilas tu app en modo 
        release editando `android.buildTypes.release` en
        `[project]/android/app/build.gradle`.
    * ![iOS](/images/fastlane-cd/ios.png) En iOS, crea y firma usando un 
    certificado de distribución en lugar de un certificado de desarrollo cuando estes 
    preparado para probar y desplegar usando TestFlight o App Store.
        * Crea y descarga un certificado de distribución en tu [Apple Developer Account console](https://developer.apple.com/account/ios/certificate/).
        * `open [project]/ios/Runner.xcworkspace/` y selecciona el certificado de 
        distribucion en en el panel de configuración de tu target.
1. Crea un script `Fastfile` para cada plataforma.
    * ![Android](/images/fastlane-cd/android.png) En Android, sigue la 
    [Guía de despliegue Fastlane Android](https://docs.fastlane.tools/getting-started/android/beta-deployment/).
    Tu edición puede ser tan simple como añadir un `lane` que llama a `upload_to_play_store`.
    Configura el argumento `apk` a `../build/app/outputs/apk/release/app-release.apk`
    para usar el apk ya compilado con `flutter build`.
    * ![iOS](/images/fastlane-cd/ios.png) En iOS, sigue la [guía de despliegue fastlane iOS beta](https://docs.fastlane.tools/getting-started/ios/beta-deployment/).
    Tu edición de código podría ser tan simple como añadir un `lane` que llame a `build_ios_app` con 
    `export_method: 'app-store'` y `upload_to_testflight`. En iOS una compilación extra
    es requerida ya que `flutter build` compila un .app en lugar de archivar 
    .ipas para release.

Ahora estas preparado para realizar despliegues localmente o migrar el proceso de 
despliegue a un sistema de integración continua (CI).

## Ejecutando el despliegue localmente

1. Compila la app en modo release.
    * ![Android](/images/fastlane-cd/android.png) `flutter build apk --release`.
    * ![iOS](/images/fastlane-cd/ios.png) `flutter build ios --release --no-codesign`.
    No es necesario firmar ahora ya que fastlane firmará en la fase de archivado.
1. Ejecuta el script Fastfile en cada plataforma.
    * ![Android](/images/fastlane-cd/android.png) `cd android` y después
    `fastlane [nombre del lane que creaste]`.
    * ![iOS](/images/fastlane-cd/ios.png) `cd ios` y después
    `fastlane [nombre del lane que creaste]`.

## Configuración para compilar y desplegar en la nube

Primero, sigue la sección de configuración local descrita en 'Configuración local' para 
asegurarte que el proceso funciona antes de migrar hacia un sistema en la nube como Travis.

Lo principal para tener en cuenta es que como las instancias cloud son efímeras y no confiables, no dejarás tus credenciales como tu cuenta de servicio de Play Store JSON o tu certificado de distribución de iTunes en el servidor.

Los sistemas de integración continua (CI) , como 
[Cirrus](https://cirrus-ci.org/guide/writing-tasks/#encrypted-variables)
generalmente soportan variables de entorno encriptadas para almacenar datos 
privados.

**Ten precaución de no imprimir por consola los valores de estas variables en tus scripts de 
prueba**. Estas variables tampoco están disponibles en los pull request hasta que 
estos son fusionados para asegurar que que los actores maliciosos no puedan crear un pull
request que imprima estos secretos. Se precavido con las interacciones con estos 
secretos en los pull request que tu aceptes y fusiones.

1. Haz que las credenciales de inicio de sesión sean efímeras.
    * ![Android](/images/fastlane-cd/android.png) En Android:
        * Elimina el campo `json_key_file` del `Appfile` y guarda el texto contenido 
        en el JSON en la variable encriptada de tu sistema CI. Usa el argumento 
        `json_key_data` en `upload_to_play_store` para leer la variable 
        de entorno directamente en tu `Fastfile`.
        * Serializa tu clave de subida (por ejemplo, usando base64) y guardala como 
        una variable de entorno encriptada. Puedes deserializarla en tu sistema 
        CI durante la fase de instalación con 
        ```bash
        echo "$PLAY_STORE_UPLOAD_KEY" | base64 --decode > /home/cirrus/[directorio # y nombre de fichero especificado en tu gradle].keystore
        ```
    * ![iOS](/images/fastlane-cd/ios.png) En iOS:
        * Traslada la variable de entorno local `FASTLANE_PASSWORD` para emplear variables de 
        entorno cifradas en el sistema CI.
        * El sitema de CI necesita acceso a tu certificado de distribución. Se recomienda el sistema 
        [Match](https://docs.fastlane.tools/actions/match/) de fastlane para sincronizar tus certificados entre distintas máquinas.

2. Se recomienda usar un fichero Gemfile en lugar de usar cada vez una gema indeterminada 
`gem install fastlane` en el sistema de CI para garantizar que las dependencias de fastlane
sean estables y reproducibles entre las máquinas locales y las de la nube. Sin embargo, este paso es opcional.
    * En tus directorios `[project]/android` y `[project]/ios`, crea un fichero
    `Gemfile` con el siguiente contenido:
      ```
      source "https://rubygems.org"

      gem "fastlane"
      ```
    * En ambos directorios, ejecuta `bundle update` y verifica ambos ficheros `Gemfile` y
    `Gemfile.lock` en tu sistema de control de versiones.
    * Cuando ejecutes localmente, usa `bundle exec fastlane` en lugar de `fastlane`.

3. Crea el script de pruebas de CI, como `.travis.yml` o `.cirrus.yml` en la raíz
de tu repositorio.
    * Fragmenta tu script para ejecutarse tanto en plataformas Linux como macOS.
    * Recuerda especificar una dependencia de Xcode para macOS (por ejemplo
    `osx_image: xcode9.2`).
    * Mira la [documentación CI de fastlane](https://flutter.io/fastlane-cd/)
    para configuraciones espécificas del CI.
    * Durante la fase de configuración, dependiendo de la plataforma, asegúrate de que:
         * Está disponible Bundler usando `gem install bundler`.
         * Para Android, asegúrate que el Android SDK esta disponible y que `ANDROID_HOME` está configurado en el path.
         * Ejecuta `bundle install` en `[project]/android` o `[project]/ios`.
         * Asegúrate que el SDK de Flutter está disponible y configurado en `PATH`.
    * En la fase de script de la tarea (task) del CI:
         * Ejecuta `flutter build apk --release` o `flutter build ios --release --no-codesign` dependiendo de la plataforma.
         * `cd android` o `cd ios`.
         * `bundle exec fastlane [nombre del lane]`.

## Referencía

La [Galería Flutter en el repositorio de Flutter](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)
usa Fastlane para despliegue continuo. Mira el código fuente para ver un ejemplo 
funcional de Fastlane en acción. El script Cirrus del repositorio de Flutter está 
[aquí](https://github.com/flutter/flutter/blob/master/.cirrus.yml).
