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

## Ejecutando despligue localmente

1. Build the release mode app.
    * ![Android](/images/fastlane-cd/android.png) `flutter build apk --release`.
    * ![iOS](/images/fastlane-cd/ios.png) `flutter build ios --release --no-codesign`.
    No need to sign now since fastlane will sign when archiving.
1. Run the Fastfile script on each platform.
    * ![Android](/images/fastlane-cd/android.png) `cd android` then
    `fastlane [name of the lane you created]`.
    * ![iOS](/images/fastlane-cd/ios.png) `cd ios` then
    `fastlane [name of the lane you created]`.

## Cloud build and deploy setup

First, follow the local setup section described in 'Local setup' to make sure
the process works before migrating onto a cloud system like Travis.

The main thing to consider is that since cloud instances are ephemeral and
untrusted, you won't be leaving your credentials like your Play Store service
account JSON or your iTunes distribution certificate on the server.

Continuous Integration (CI) systems, such as
[Cirrus](https://cirrus-ci.org/guide/writing-tasks/#encrypted-variables)
generally support encrypted environment variables to store private data.

**Take precaution not to re-echo those variable values back onto the console in
your test scripts**. Those variables are also not available in pull requests
until they're merged to ensure that malicious actors cannot create a pull
request that prints these secrets out. Be careful with interactions with these
secrets in pull requests that you accept and merge.

1. Make login credentials ephemeral.
    * ![Android](/images/fastlane-cd/android.png) On Android:
        * Remove the `json_key_file` field from `Appfile` and store the string
        content of the JSON in your CI system's encrypted variable. Use the
        `json_key_data` argument in `upload_to_play_store` to read the
        environment variable directly in your `Fastfile`.
        * Serialize your upload key (for example, using base64) and save it as
        an encrypted environment variable. You can deserialize it on your CI
        system during the install phase with
        ```bash
        echo "$PLAY_STORE_UPLOAD_KEY" | base64 --decode > /home/cirrus/[directory # and filename specified in your gradle].keystore
        ```
    * ![iOS](/images/fastlane-cd/ios.png) On iOS:
        * Move the local environment variable `FASTLANE_PASSWORD` to use
        encrypted environment variables on the CI system.
        * The CI system needs access to your distribution certificate. fastlane's
        [Match](https://docs.fastlane.tools/actions/match/) system is
        recommended to synchronize your certificates across machines.

2. It's recommended to use a Gemfile instead of using an indeterministic
`gem install fastlane` on the CI system each time to ensure the fastlane
dependencies are stable and reproducible between local and cloud machines. However, this step is optional.
    * In both your `[project]/android` and `[project]/ios` folders, create a
    `Gemfile` containing the following content:
      ```
      source "https://rubygems.org"

      gem "fastlane"
      ```
    * In both directories, run `bundle update` and check both `Gemfile` and
    `Gemfile.lock` into source control.
    * When running locally, use `bundle exec fastlane` instead of `fastlane`.

3. Create the CI test script such as `.travis.yml` or `.cirrus.yml` in your
repository root.
    * Shard your script to run on both Linux and macOS platforms.
    * Remember to specify a dependency on Xcode for macOS (for example
    `osx_image: xcode9.2`).
    * See [fastlane CI documentation](https://flutter.io/fastlane-cd/)
    for CI specific setup.
    * During the setup phase, depending on the platform, make sure that:
         * Bundler is available using `gem install bundler`.
         * For Android, make sure the Android SDK is available and the `ANDROID_HOME`
         path is set.
         * Run `bundle install` in `[project]/android` or `[project]/ios`.
         * Make sure the Flutter SDK is available and set in `PATH`.
    * In the script phase of the CI task:
         * Run `flutter build apk --release` or `flutter build ios --release --no-codesign` depending on the platform.
         * `cd android` or `cd ios`.
         * `bundle exec fastlane [name of the lane]`.

## Reference

The [Flutter Gallery in the Flutter repo](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)
uses Fastlane for continuous deployment. See the source for a working example of
Fastlane in action. The Flutter framework repository's Cirrus script is [here](https://github.com/flutter/flutter/blob/master/.cirrus.yml).
