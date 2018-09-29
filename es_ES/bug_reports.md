---
layout: page
title: Creando Informes de Errores Útiles

permalink: /bug-reports/
---

* TOC Placeholder
{:toc}

## Introducción

Las instrucciones de este documento detallan los pasos actuales necesarios para proporcionar los informes de fallos más actualizados en caso de fallos y otros casos de mal funcionamiento. Cada paso es opcional, pero mejorará enormemente la rapidez con la que se diagnostican y abordan los problemas. Agradecemos tu esfuerzo por enviarnos la mayor cantidad de información posible.

## Crear un Issue en Github
* Se puede crear un nuevo issue Github en [https://github.com/flutter/flutter/issues/new](https://github.com/flutter/flutter/issues/new)

## Proporcionar algunos Diagnósticos de Flutter
* Ejecuta `flutter doctor` en tu directorio de proyecto y pega los resultados en el issue de Github:

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

## Ejecutar el comando en modo Verbose
Sigue estos pasos sólo si tu problema está relacionado con la herramienta `flutter`.

* Todos los comandos de Flutter aceptan el parámetro `--verbose`. Si se adjunta al issue, la salida de este comando puede ayudar a diagnosticar el problema.
* Adjunta los resultados del comando al issue de Github.
![flutter verbose](/images/verbose_flag.png)

## Proporcionar los logs más recientes
* Se puede acceder a los registros del dispositivo actualmente conectado mediante `flutter logs`
* Si la falla es reproducible, borra los logs (⌘ + k en Mac), reproduce el fallo y copia los registros recién generados en un archivo adjunto al informe de fallo.
* Si estás obteniendo excepciones lanzadas por el framework, incluye toda la salida de por medio e incluyé las líneas punteadas de la primera de esas excepciones.
![flutter logs](/images/logs.png)

## Proporcionar el informe de fallos
* En caso de que el simulador iOS falle, se genera un informe de fallo en `~/Library/Logs/DiagnosticReports/`.
* En caso de que el dispositivo iOS falle, se genera un informe de fallo en `~/Library/Logs/CrashReporter/MobileDevice`.
* Busca el informe correspondiente al fallo (normalmente el último) y adjúntalo al issue de Github.
![crash report](/images/crash_reports.png)
