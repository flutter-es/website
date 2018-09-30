---
layout: page
title: Entrega Contínua usando fastlane con Flutter
description: Como usar fastlane para automatizar la compilación y proceso de release 
de tu aplicación Flutter.

permalink: /fastlane-cd/
---

Sigue las mejores prácticas de Entrega Contínua con Flutter para asegurar que tu 
aplicación es entregada a tus beta testers y validada con frequencia sin resultar un 
proceso de trabajo manual.

Esta guía muestra como integrar [fastlane](https://docs.fastlane.tools/), un conjunto 
de herramientas de código abierto, con tu flujo de trabajo existente de integración continua 
(continuous integration, CI, for example, Travis o Cirrus).

* TOC Placeholder
{:toc}

## Configuración local

Se recomienta que testees el proceso de compilación y entrega localmente antes de migrar 
a un sistema basado en la nube. Podrías tambien elegir realizar entrega continua desde 
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
    * ![Android](/images/fastlane-cd/android.png) Chequea que `package_name` en
    `[project]/android/Appfile` coincida con tu nombre de paquete en pubspec.yaml.
    * ![iOS](/images/fastlane-cd/ios.png) Chequea que `app_identifier` en
    `[project]/ios/Appfile` tambien coincida. Rellena `apple_id`, `itc_team_id`,
    `team_id` con tu información respectiva de tu cuenta.
1. Configura las credenciales de logado locales para las tiendas.
    * ![Android](/images/fastlane-cd/android.png) Sigue los [pasos de configuración de Supply](https://docs.fastlane.tools/getting-started/android/setup/#setting-up-supply)
    y asegúrate que `fastlane supply init` sincroniza con existo datos de tu consola de 
    Play Store. _Trata el fichero .json como tu contraseña y no lo incluyas en ningún 
    repositorio de control de código público._
    * ![iOS](/images/fastlane-cd/ios.png) Tu nombre de usuario de iTunes Connect ya esta en 
    tu campo `apple_id` de `Appfile`. Configura la variable de entorno de consola `FASTLANE_PASSWORD` 
    con tu contraseña de iTunes Connect. De otra manera, se te preguntaría cuando 
    se suba a iTunes/TestFlight.
1. Configura el firmado de código.
    * ![Android](/images/fastlane-cd/android.png) En Android, hay dos claves de firmado 
    : despliegue y subida. El usuario final descarga el .apk firmado con la 
    'clave de despligue'. Y la 'clave de subida' es usada para autentificar el .apk
    subido por los desarrolladores en la Play Store y es refirmado con la clave de despliegue 
    una vez en la Play Store.
        * Es altamente recomendable usar usar la administración automática en la nube de firmas 
        para la clave de despliegue. Para más información, mirá la [documentación oficial de Play Store](https://support.google.com/googleplay/android-developer/answer/7384423?hl=en).
        * Sigo los pasos de [generación de claves](https://developer.android.com/studio/publish/app-signing#sign-apk)
        para crear tu clave de subida.
        * Configura gradle para usar tu clave de subida cuando compilas tu app en modo 
        release editando `android.buildTypes.release` en
        `[project]/android/app/build.gradle`.
    * ![iOS](/images/fastlane-cd/ios.png) En iOS, crea y firma usando un 
    certificado de distribución en lugar de un certificado de desarrollo cuando estes 
    preparado para probar y desplegar usando TestFlight o App Store.
        * Crea y descarga un certificado de distribución en tu [Apple Developer Account console](https://developer.apple.com/account/ios/certificate/).
        * `open [project]/ios/Runner.xcworkspace/` y selecciona el certificado de 
        distribucion en tu panel de configuración target.
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
despliegue a un sistema de integración contínua(CI).

## Ejecutando el despligue localmente

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

Primero, sigue la sección de configuración en local descrita en 'Configuración local' para 
asegurarte que el proceso funciona antes de migrar hacia un sistema en la nube como Travis.

El aspecto principal a considerar es que ya que las instancias en la nube son éfimeras 
y no confiables, no querrás dejar tus credenciales, como tu JSON de cuenta de tu servicio de 
Play Store o tu certificado de distribución de iTunes, en el servidor.

Los sistemas de integración continúa (CI) , como 
[Cirrus](https://cirrus-ci.org/guide/writing-tasks/#encrypted-variables)
generalmente soportan variables de entorno encriptadas para almacenar datos 
privados.

**Ten precaución de no imprimir por consola los valores de estas variables en tus scripts de 
pruebas**. Estas variables tampoco están disponibles en los pull request hasta que 
estos son fusionados para asegurar que un actor malicioso no pueda crear un pull
request que imprima estos secretos. Se precavido con las interacciones con estos 
secretos en los pull request que tu aceptes y fusiones.

1. Haz las credenciales de logado efímeras.
    * ![Android](/images/fastlane-cd/android.png) En Android:
        * Elimina el campo `json_key_file` de `Appfile` y guarda el texto contenido 
        en el JSON en tu variable encriptada de tu sistema CI. Usa el argumento 
        `json_key_data` en `upload_to_play_store` para leer la variable 
        de entorno directamente en tu `Fastfile`.
        * Serializa tu clave de subida (por ejemplo, usando base64) y guardala como 
        una variable de entorno encriptada. Puedes deserializarla en tu sistema 
        CI durante la fase de instalación con 
        ```bash
        echo "$PLAY_STORE_UPLOAD_KEY" | base64 --decode > /home/cirrus/[directorio # y nombre de fichero  especificado en tu gradle].keystore
        ```
    * ![iOS](/images/fastlane-cd/ios.png) En iOS:
        * Mueva la variable de entorno local `FASTLANE_PASSWORD` para usarla 
        como variable de entorno encriptada en el sistema de CI.
        * El sitema de CI necesita acceso al certificado de distribución. El sistema 
        [Match](https://docs.fastlane.tools/actions/match/) de fastlane es 
        recomenado para sincronizar tus certificados entre distintas máquinas.

2. Se recomienda usar un fichero Gemfile en lugar de usar cada vez un no determinístico 
`gem install fastlane` en el sistema de CI para asegurar que las dependencias de fastlane
son estables y reproducibles entre las máquinas locales y en la nube. Sin embargo, este paso es opcional.
    * En tus directorios `[project]/android` y `[project]/ios`, crea un fichero
    `Gemfile` con el siguiente contenido:
      ```
      source "https://rubygems.org"

      gem "fastlane"
      ```
    * En ambos directorios, ejecuta `bundle update` y verifica ambos ficheros `Gemfile` y
    `Gemfile.lock` en tu sistema de control de versiones.
    * Cuando ejecutes localmente, usa `bundle exec fastlane` en lugar de `fastlane`.

3. Crea el script de pruebas de CI, como `.travis.yml` o `.cirrus.yml` en el raíz
de tu repositorio.
    * Fragmenta tu script para ejecutarse tanto en plataformas Linux como macOS.
    * Recuerda especificar una dependencia de Xcode para macOS (por ejemplo
    `osx_image: xcode9.2`).
    * Mira la [documentación CI de fastlane](https://flutter.io/fastlane-cd/)
    para configuraciones espécificas del CI.
    * Durante la fase de configuración, dependiendo de la plataforma, asegúrate que:
         * Está disponible Bundler usando `gem install bundler`.
         * Para Android, asegúrate que el Android SDK esta disponible y que el path `ANDROID_HOME` está configurado.
         * Ejecuta `bundle install` en `[project]/android` o `[project]/ios`.
         * Asegúrate que esta dispobible el SDK de Flutter y configurado en `PATH`.
    * En la fase de script de la tarea (task) del CI:
         * Ejecuta `flutter build apk --release` o `flutter build ios --release --no-codesign` dependiendo de la plataforma.
         * `cd android` o `cd ios`.
         * `bundle exec fastlane [nombre del lane]`.

## Referencía

La [Galería Flutter en el repositorio de Flutter](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)
usa Fastlane para despliegue contínuo. Mira el código fuente para ver un ejemplo 
funcional de Fastlane en acción. El script Cirrus del repositorio de Flutter está 
[aquí](https://github.com/flutter/flutter/blob/master/.cirrus.yml).
