---
layout: page
title: Preparando una aplicación iOS para su lanzamiento

permalink: /ios-release/
---

Esta guía proporciona una guía paso a paso para lanzar una aplicación Flutter a la [App Store][appstore] y a [TestFlight][testflight].

Para obtener información sobre la ofuscación del código Dart, vea [Ofuscación del código de Dart](https://github.com/flutter/flutter/wiki/Obfuscating-Dart-Code).


* TOC Placeholder
{:toc}

## Preliminares

Antes de iniciar el proceso de publicación de tu aplicación, asegúrate de que cumple con las directrices [de revisión de aplicaciones de Apple][appreview].

Para publicar tu aplicación en el App Store, tendrás que inscribirte en el [Apple Developer Program][devprogram]. Puedes leer más sobre las distintas opciones de afiliación en la guía de Apple [como elegir una membresía][devprogram_membership].

## Registra tu aplicación en iTunes Connect

[iTunes Connect][itunesconnect] es donde podrás gestionar el ciclo de vida de tu aplicación.
Definirás el nombre y la descripción de tu aplicación, añadirás capturas de pantalla, establecerás el precio,
y gestionaras las versiones en la App Store y TestFlight.

El registro de tu aplicación implica dos pasos: registrar un ID de paquete único, y
crear un registro de aplicación en iTunes Connect.

Para obtener una descripción detallada de iTunes Connect, consulta la guía de [iTunes Connect][itunesconnect_guide].

### Registrar un ID de paquete

Todas las aplicaciones iOS están asociadas a un ID de paquete, un identificador único registrado en Apple. Para registrar un ID de paquete para tu aplicación, sigue estos pasos:

1. Abre la página [App IDs][devportal_appids] de tu cuenta de desarrollador. 
1. Haz clic en **+** para crear un nuevo ID de paquete.
1. Ingresa un nombre de aplicación, selecciona **Explicit App ID** e ingresa un ID.
1. Selecciona los servicios que utilizará tu aplicación y, a continuación, haz clic en **Continue**. 
1. En la página siguiente, confirma los detalles y haz clic en **Register** para registrar tu ID de paquete.

### Crear un registro de aplicación en iTunes Connect

A continuación, registrarás tu aplicación en iTunes Connect:

1. Abre [iTunes Connect][itunesconnect_login] en tu navegador.
1. En la página de inicio de iTunes Connect, haz clic en **My Apps**. 
1. Haz clic en + en la esquina superior izquierda de la página My Apps y a continuación selecciona **New App**. 
1. Rellena los datos de tu aplicación en el formulario que aparece. En la sección Plataformas,
   asegúrate de que el iOS esté marcado. Ya que actualmente Flutter no soporta tvOS, deja esa casilla sin marcar. Haz clic en **Create**.
1. Navega hasta los detalles de la aplicación para tu aplicación y selecciona **App Information** en la barra lateral.
1. En la sección Información general, selecciona el ID del paquete que registraste en el paso anterior.

Para obtener un resumen detallado, consulta [Añade una aplicación a tu cuenta][itunesconnect_guide_register].

## Revisar la configuración del proyecto Xcode

En este paso, repasarás los ajustes más importantes en el Xcode workspace.
Para obtener más información sobre los procedimientos y las descripciones, mira [Preparar la distribución de aplicaciones][distributionguide_config].

Navega hasta los ajustes de tu objetivo en Xcode:

1. En Xcode, abre `Runner.xcworkspace` en la carpeta `ios` de tu aplicación.
1. Para ver la configuración de tu aplicación, selecciona el proyecto **Runner** en el navegador de proyectos Xcode. Luego, en la vista principal de la barra lateral, selecciona el objetivo **Runner**.
1. Selecciona la pestaña **General**.

A continuación, verificaras los ajustes más importantes:

En la sección Identity:

  * `Display Name:` el nombre de la aplicación que se mostrará en la pantalla de inicio y en otros lugares.
  * `Bundle Identifier:` el ID de la aplicación que has registrado en iTunes Connect.

En la sección Signing:

  * `Automatically manage signing:` Xcode debería gestionar automáticamente la firma y el aprovisionamiento de aplicaciones. Se establece como `true` de forma predeterminada, lo que debería ser suficiente para la mayoría de las aplicaciones. Para escenarios más complejos, consulta la [Guía de firma de código][codesigning_guide].
  * `Team:` selecciona el equipo asociado a tu cuenta Apple de desarrollador registrada. Si es necesario, selecciona **Add Account...** y a continuación actualiza esta configuración.

En la sección Deployment Info:

  * `Deployment Target:` la versión mínima de iOS que su aplicación soportará. Flutter es compatible con iOS 8.0 y posteriores. Si tu aplicación incluye código Objective-C o Swift que utiliza APIs que no estaban disponibles en iOS 8, actualiza esta configuración de forma adecuada.

La pestaña General de la configuración de tu proyecto debe parecerse a la siguiente:

![Xcode Project Settings](/images/releaseguide/xcode_settings.png)

Para obtener una descripción detallada de la firma de aplicaciones, consulta [Crear, exportar y eliminar certificados de firma][appsigning].

## Agregar un icono en la aplicación

Cuando se crea una nueva aplicación Flutter, se crea un conjunto de iconos de placeholder. En este paso, reemplazarás estos iconos de placeholder por los iconos de tu aplicación:

1. Revisa las directrices del [Icono de aplicación de iOS][appicon].
1. En el navegador del proyecto Xcode, selecciona `Assets.xcassets` en la carpeta `Runner`. Actualiza los iconos placeholder con tus propios iconos de aplicación.
1. Verifica que el icono ha sido reemplazado ejecutando tu aplicación usando `flutter run`.

## Crear un archivo de construcción

En este paso, crearás un archivo de compilación y cargarás tu compilación en iTunes Connect.

Durante el desarrollo, has estado creando, depurando y probando con *debug* builds. Cuando estés listo para enviar tu aplicación a los usuarios en el App Store o en TestFlight, tendrás que preparar una build *release*.

En la línea de comandos, sigue estos pasos en el directorio de la aplicación:

1. Ejecuta `flutter build ios` para crear una release build (`flutter build` por defecto es `--release`).
1. Para asegurarse de que Xcode actualiza la configuración del modo de liberación, cierra y vuelve a abrir el Xcode workspace. Para Xcode 8.3 y posteriores, este paso no es necesario.

En Xcode, configura la versión de la aplicación y constrúyela:

1. En Xcode, abre `Runner.xcworkspace` en la carpeta `ios` de tu aplicación.
1. Selecciona **Product > Scheme > Runner**.
1. Selecciona **Product > Destination > Generic iOS Device**.
1. Selecciona **Runner** en el navegador de proyectos Xcode a continuación selecciona el objetivo **Runner**
   en la barra lateral de la vista de configuración.
1. En la sección Identity, actualisa la **Versión** con el número de versión user-facing que deseas publicar.
1. En la sección Identidad, actualiza el identificador **Build** a un número de compilación único que se utiliza para rastrear esta compilación en iTunes Connect. Cada carga requiere un número de compilación único.

Por último, crea un archivo de construcción y súbelo a iTunes Connect:

1. Selecciona **Product > Archive** para producir un archivo de construcción.
1. En la barra lateral de la ventana de Xcode Organizer, selecciona tu aplicación iOS, luego selecciona el archivo de compilación que acabas de producir.
1. Haz clic en el botón **Validate...**. Si se informa de algún problema, resuelvelo y produce otra construcción. Puedes reutilizar el mismo ID de construcción hasta que subas un archivo.
1. Una vez que el archivo comprimido se haya validado correctamente, haz clic en **Upload to App Store....**. Puedes seguir el estado de tu compilación en la pestaña Actividades de la página de detalles de tu aplicación en [iTunes Connect][itunesconnect_login].

Recibirás un correo electrónico dentro de 30 minutos notificándote que tu compilación ha sido validada y está disponible para ser liberada a los probadores en TestFlight. En este punto puedes elegir si quieres publicar en TestFlight, o seguir adelante y publicar tu aplicación en el App Store.

Para obtener más información, consulta [Cargar una aplicación a iTunes Connect][distributionguide_upload].

## Lanza tu aplicación en TestFlight

[TestFlight][testflight] permite a los desarrolladores enviar sus aplicaciones a probadores internos y externos. En este paso opcional, lanzarás tu build en TestFlight. 

1. Navega a la pestaña TestFlight de la página de detalles de la aplicación de tu aplicación en [iTunes Connect][itunesconnect_login].
1. Selecciona **Internal Testing** en la barra lateral.
1. Selecciona la compilación que deseas publicar a los probadores y a continuación da clic en **Save**.
1. Añade las direcciones de correo electrónico de los probadores internos. Puedes añadir usuarios internos adicionales en la página Usuarios y roles de iTunes Connect, disponible en el menú desplegable de la parte superior de la página.

Para obtener más información, consulta [Distribuir una aplicación con TestFlight][distributionguide_testflight].

## Publica tu aplicación en el App Store

Cuando estés listo para lanzar tu aplicación al mundo, sigue estos pasos para enviarla a la App Store para su revisión y publicación:

1. Selecciona **Pricing and Availability** en la barra lateral de la página de detalles de la aplicación de tu aplicación en[iTunes Connect][itunesconnect_login] y completa la información necesaria.
1. Selecciona el estado en la barra lateral. Si esta es la primera versión de esta aplicación, su estado será **1.0 Prepare for Submission**. Rellena todos los campos obligatorios.
1. Haz clic en **Submit for Review**.

Apple te notificará cuando se complete el proceso de revisión de la aplicación. Tu aplicación será liberada de acuerdo con las instrucciones que especificaste en la sección **Version Release**.

Para obtener más información, consulta [Distribuir una aplicación a través del App Store][distributionguide_submit].

## Solución de problemas

La guía [Distribuye tu aplicación][distributionguide] proporciona una descripción detallada del proceso de publicación de una aplicación en el App Store.

[appicon]: https://developer.apple.com/ios/human-interface-guidelines/icons-and-images/app-icon/
[appreview]: https://developer.apple.com/app-store/review/
[appsigning]: https://help.apple.com/xcode/mac/current/#/dev154b28f09
[appstore]: https://developer.apple.com/app-store/submissions/
[codesigning_guide]: https://developer.apple.com/library/content/documentation/Security/Conceptual/CodeSigningGuide/Introduction/Introduction.html
[devportal_appids]: https://developer.apple.com/account/ios/identifier/bundle
[devprogram]: https://developer.apple.com/programs/
[devprogram_membership]: https://developer.apple.com/support/compare-memberships/
[distributionguide]: https://help.apple.com/xcode/mac/current/#/dev8b4250b57
[distributionguide_config]: https://help.apple.com/xcode/mac/current/#/dev91fe7130a
[distributionguide_submit]: https://help.apple.com/xcode/mac/current/#/dev067853c94
[distributionguide_testflight]: https://help.apple.com/xcode/mac/current/#/dev2539d985f
[distributionguide_upload]: https://help.apple.com/xcode/mac/current/#/dev442d7f2ca
[itunesconnect]: https://developer.apple.com/support/itunes-connect/
[itunesconnect_guide]: https://developer.apple.com/support/itunes-connect/
[itunesconnect_guide_register]: https://help.apple.com/itunes-connect/developer/#/dev2cd126805
[itunesconnect_login]: https://itunesconnect.apple.com/
[testflight]: https://developer.apple.com/testflight/
