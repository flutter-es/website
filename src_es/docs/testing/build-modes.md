---
title: Modos de construcción de Flutter.
description: ¿Describe los modos de compilación de Flutter y cuándo debería usar el modo de depuración, lanzamiento o perfil?
---

La herramienta Flutter admite tres modos al compilar su aplicación 
y un modo si encabezados para pruebas. 
Este documento explica los tres modos y le dice cuándo usar cada uno de ellos.
Para obtener más información sobre las pruebas sin modo, consulte 
[Pruebas Unitarias.](/docs/testing#unit-testing)

Eliges el modo de compilación dependiendo de dónde te encuentres en el el 
ciclo de desarrollo. ¿Estás depurando tu código?, 
¿Necesita información de perfil?, ¿Estás listo para desplegar tu aplicación?

A continuación se describe cada modo y cuándo usarlo.

## Depurar

En _modo depuración_, la aplicación está configurada para la depuración en el 
Dispositivo físico, emulador, o simulador. El modo de depuración significa que:

* [Afirmaciones](https://www.dartlang.org/guides/language/language-tour#assert)
   están activadas.
* [Observatorio](https://dart-lang.github.io/observatory) está activado, 
le permite utilizar el depurador de dardos.
* Las extensiones de servicio están habilitadas.
* La compilación está optimizada para un rápido desarrollo y ciclos de ejecución 
(pero no para velocidad de ejecución, tamaño binario o implementación).

Por defecto, `flutter run` compila en modo debug.
Tu IDE también soporta estos modos. Android Studio,
por ejemplo, proporciona una opción de menú **Run > Debug...**, 
así como un icono de botón de ejecución verde triangular en la página del proyecto.
(El elemento del menú muestra una imagen del icono correspondiente.)
El emulador y el simulador ejecutan _solo_ en modo de depuración.

## Lanzamiento

Use _modo lanzamiento_ para desplegar la aplicación, cuando quieras 
el máximo en optimización y tamaño mínimo de huella. Modo de Lanzamiento, 
que no es soportado en el simulador o emulador, significa que:

* Las aserciones están deshabilitadas.
* La información de depuración se elimina.
* La depuración está deshabilitada.
* La compilación está optimizada para un inicio rápido, una ejecución 
rápida y paquetes pequeños.
* Las extensiones de servicio están deshabilitadas.

El comando `flutter run --release` compila en modo de Lanzamiento.
Tu IDE también soporta estos modos. Android Studio, por ejemplo,
provee una opción de menú **Run > Run...**, así como un ícono de error 
verde superpuesto con un pequeño triángulo en la página del proyecto.
(El elemento del menú muestra una imagen del icono correspondiente..)

También puede compilar para lanzamientocon el modo `flutter build`.
Para más información, vea la documentación sobre lanzamiento.
aplicaciones [iOS](../deployment/ios) y [Android](../deployment/android).

## Perfil

En _modo perfil_, Algunas funciones de depuración se mantienen lo suficiente para 
perfilar el rendimiento de su aplicación. El modo de perfil está deshabilitado 
en el emulador y simulador,Porque su comportamiento no es representativo del 
desempeño real. Modo Perfil es similar al modo lanzamiento, 
con las siguientes diferencias:

* Algunas extensiones de servicio, como la que permite la superposición 
de rendimiento, están habilitados.
* El rastreo está habilitado, y el Observatorio puede conectarse al proceso.

El comando `flutter run --profile` compila en Modo Perfil.
Tu IDE también soporta estos modos. Android Studio, por ejemplo,
provee una opción de menú **Run > Profile...**.∫

Para más información sobre estos modos
[Modos Flutter](https://github.com/flutter/flutter/wiki/Flutter%27s-modes)
en la [wiki SDK Flutter](https://github.com/flutter/flutter/wiki).
