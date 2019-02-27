---
title: Reando reportes de error funcionales
---

Las instrucciones en este documento detallan los pasos actuales requeridos para proporcionar la mayor
Informes de errores procesables por fallas y otros comportamientos incorrectos. Cada paso es opcional pero
mejorará en gran medida la rapidez con que se diagnostican y abordan los problemas. Apreciamos su
esfuerzo en enviarnos tantos comentarios como sea posible.

## Crear un problema en Github

* Se puede crear un nuevo problema de Github en
 [https://github.com/flutter/flutter/issues/new](https://github.com/flutter/flutter/issues/new)

## Proporcionar algunos diagnósticos Flutter

* Ejecuta `flutter doctor` en el directorio de su proyecto y pegue los resultados en el problema de Github:

```
[✓] Flutter (on Mac OS, channel master)
    • Flutter at /Users/me/projects/flutter
    • Framework revision 8cbeb2e (4 hours ago), engine revision 5c28578

[✓] Android toolchain - develop for Android devices (Android SDK 23.0.2)
    • Android SDK at /usr/local/Cellar/android-sdk/24.4.1_1
    • Platform android-23, build-tools 23.0.2
    • Java(TM) SE Runtime Environment (build 1.8.0_73-b02)

[✓] iOS toolchain - develop for iOS devices (Xcode 7.3)
    • XCode at /Applications/Xcode.app/Contents/Developer
    • Xcode 7.3, Build version 7D175

[✓] IntelliJ IDEA Ultimate Edition (version 2016.2.5)
    • Dart plugin installed
    • Flutter plugin installed
```

## Ejecutar el comando en modo detallado

Siga estos pasos solo si su problema está relacionado con la herramienta `flutter`.

* Todos los comandos de Flutter aceptan la etiqueta `--verbose`.Si se adjunta al problema, la salida de este comando puede ayudar a diagnosticar el problema.
* Adjunte los resultados del comando al problema de Github.
![flutter verbose](/images/verbose_flag.png)

## Proporcionar los registros más recientes

* Se puede acceder a los registros del dispositivo conectado actualmente a través de `flutter logs`
* Si el bloqueo es reproducible, borre los registros (⌘ + k en Mac), reproduzca el bloqueo y copie los registros recién generados en un archivo adjunto al informe de errores.
* Si está obteniendo excepciones generadas por el marco, incluya todos los resultados entre las líneas discontinuas de la primera excepción.
![flutter logs](/images/logs.png)

## Proporcionar el Informe de Accidente

* En caso de que el simulador de iOS se bloquee, se genera un informe de fallo en `~/Library/Logs/DiagnosticReports/`.
* En caso de que el dispositivo iOS se caiga, se genera un informe de error en `~/Library/Logs/CrashReporter/MobileDevice`.
* Encuentre el informe correspondiente al fallo (generalmente el más reciente) y adjúntelo al problema de Github.
![informe del accidente](/images/crash_reports.png)
