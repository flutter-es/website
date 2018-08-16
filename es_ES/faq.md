---
layout: page
title: FAQ

permalink: /faq/
---

* Placeholder for TOC
{:toc}

## Introducción

### Que es Flutter?

Flutter es la aplicación móvil de Google SDK para la elaboración de alta calidad
experiencias nativas en iOS y Android en tiempo récord.
Flutter funciona con el código existente, es utilizado por los desarrolladores
y organizaciones de todo el mundo, es libre y de código abierto

### Qué hace Flutter?

Para los usuarios, Flutter crea hermosas UI de aplicaciones
que cobran vida.

Para los desarrolladores, Flutter baja la curva de aprendizaje
para construir aplicaciones móviles. Acelera el desarrollo de
aplicaciones móviles y reduce el costo y la complejidad
de la producción de aplicaciones en iOS y Android.

Para los diseñadores, Flutter ayuda a entregar el visión 
original de diseño,
sin pérdida de fidelidad ni compromisos. También
actúa como una herramienta productiva de creación de prototipos.

### Para quién es Flutter?

Flutter es para _desarrolladores_ que quieren una forma más rápida
de construir hermosas aplicaciones móviles, o
una forma de llegar a más usuarios con una sola inversión.

Flutter también es para _gerentes de ingeniería_ que necesitan liderar
equipos de desarrollo móvil. Flutter permite a los ingenieros de sistema
para crear _un solo equipo de desarrollo de aplicaciones móviles_, unificando sus
inversiones de desarrollo para entregar más funciones rápido,
entregar el mismo conjunto de características a iOS y Android al mismo
tiempo y disminuir costos de mantenimiento.

Si bien no es el público principal,
Flutter es también para _diseñadores_
que quieren que se entreguen sus visiones originales de diseño
consistentemente, con alta fidelidad, para todos los usuarios en dispositivos móviles.

Fundamentalmente, Flutter es para usuarios que desean aplicaciones bellas,
con movimientos y animaciones hermosas, y UI con carácter
y una identidad propia.

### Qué tan experimentado tengo que ser como programador / desarrollador para usar Flutter?

Flutter es accesible a los programadores familiarizados en los conceptos de la programación orientada a objetos (clases, métodos, variables, etc.) y conceptos de programación imperativa (bucles, condicionales, etc.).

No se requiere experiencia móvil previa para aprender y usar Flutter.

Hemos visto personas con muy poca experiencia en programación aprender
y usa Flutter para prototipos y desarrollo de aplicaciones.

### Qué tipo de aplicaciones puedo construir con Flutter?

Flutter está optimizado para aplicaciones móviles 2D que desean ejecutarse
tanto Android como iOS.

Las aplicaciones que necesitan entregar diseños de marca son particularmente
muy adecuado para Flutter. Sin embargo, las aplicaciones que deben verse como
las aplicaciones de plataforma de valores también se pueden construir con Flutter.

Puede crear aplicaciones con todas las funciones, incluido
cámara, geolocalización, red, almacenamiento, SDK de terceros y más.

### Quién hace Flutter?

Flutter es un proyecto de código abierto, con contribuciones de Google
y la comunidad.

### Quién usa Flutter?

Google usa Flutter para crear aplicaciones críticas para el negocio para iOS y Android.
Por ejemplo, la aplicación de herramientas de ventas móviles de Google está construida con Flutter, junto con una aplicación Gerente de Tienda para Google Shopping Express. Otras aplicaciones están en proceso, o "dentro del firewall".

Otros equipos fuera de Google también están utilizando Flutter.
Por ejemplo, la aplicación oficial para el musical Hamilton
([Android](https://play.google.com/store/apps/details?id=com.hamilton.app),
[iOS](https://itunes.apple.com/us/app/hamilton-the-official-app/id1255231054?mt=8))
está construido con Flutter.

### Qué hace que Flutter sea único?

Flutter es diferente a la mayoría de las otras opciones para construir
aplicaciones móviles porque Flutter no usa ni WebView ni los widgets OEM
que se incluyen con el dispositivo. En cambio, Flutter usa su propio motor de renderizado de alto rendimiento para dibujar widgets.

Además, Flutter es diferente porque solo tiene una capa delgada de código
C/C++. Flutter implementa la mayor parte de su sistema (composición, gestos,
animación, marco, widgets, etc.) en _Dart_ (un moderno, breve, lenguaje orientado a objetos) que los desarrolladores pueden acercarse fácilmente a leer, cambiar, reemplazar o eliminar.
Esto le da tremendos desarrolladores control sobre el sistema, así como también reduce significativamente la curva de aprendizaje y la accesibilidad para la mayoría del sistema.

### Debo construir mi próxima aplicación de producción con Flutter??

Flutter todavía se está desarrollando y aún no está en
1.0. Pero Flutter se usa dentro de Google y las aplicaciones construidas
con Flutter se implementan a los usuarios en producción.
Algunas aplicaciones de muestra se muestran en [showcase](/showcase/).

Algunas funciones clave aún no están completas, sin embargo, las características que se completan generalmente son de alta calidad y están listos para usar.

Nuestras API se estabilizan y seguimos mejorando
partes del sistema basadas en los comentarios de los usuarios.
Envianos un correo electrónico a [flutter-dev@googlegroups.com](mailto:flutter-dev@googlegroups.com)
cuando hacemos un cambio que podría afectar a nuestros usuarios.

Entonces realmente, depende de ti. Las características que necesita pueden ser
disponible hoy. Por favor, háganos saber si lanzó una aplicación
construido con Flutter para los usuarios. ¡Nos encantaría escuchar lo que estás construyendo!

## Qué proporciona Flutter?

### Qué hay dentro del SDK de Flutter?

* Motor de renderizado 2D altamente optimizado, especifico para móvil con excelente soporte para texto 
* Framework moderno estilo reactivo
* Rico conjunto de widgets para Android e iOS
* API para pruebas de unitarias e integración
* API de interoperatividad y complemento para conectarse al sistema y SDK de terceros
* Corredor de prueba sin encabezado para ejecutar pruebas en Windows, Linux y Mac
* Herramientas de línea de comandos para crear, construir, probar y compilar tus aplicaciones

### Flutter funciona con editores o IDEs?

Estamos construyendo complementos para [Android Studio](https://developer.android.com/studio/),
[IntelliJ IDEA](https://www.jetbrains.com/idea/), y [VS Code](https://code.visualstudio.com/).

Ver [configuración del editor](/get-started/editor/) para detalles de configuración, y
[Desarrollar aplicaciones de Flutter en un IDE](/using-ide/) para obtener consejos sobre cómo usar los complementos.

Alternativamente, puede usar una combinación del comando `flutter` en un terminal
y uno de los muchos editores que apoyan [edición con Dart](https://www.dartlang.org/tools).

### Flutter viene con un framework?

¡Sí! Flutter se trae un framework moderno, inspirado por React.
El framework de Flutter está diseñado para ser en capas y personalizable (y opcional).
Los desarrolladores pueden elegir usar solo partes del marco, o una diferente
framework de referencia.

### Flutter viene con widgets?

¡Sí! Flutter se envía con un juego de
[widgets de alta calidad de Material Design y Cupertino (estilo iOS)][widgets], layouts,
y temas.
Por supuesto, estos widgets son solo un punto de partida.
Flutter está diseñado para que sea fácil
crear tus propios widgets o personalizar los widgets existentes.

### Flutter admite Material Theming?

¡Sí! Los equipos Flutter y Material colaboran estrechamente
y Material Theming es totalmente compatible. Un numero de
ejemplos de esto se muestran en el laboratorio [MDC-103 Flutter: Material Theming](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/).

### Flutter viene con un framework de prueba?

Sí, Flutter proporciona API para escribir pruebas unitarias y de integración. Aprender más acerca de [pruebas con Flutter](/testing/).

Usamos nuestras propias capacidades de prueba para probar nuestro SDK.
Medimos nuestra [cobertura de prueba](https://coveralls.io/github/flutter/flutter?branch=master)
en cada commit.

### Flutter viene con un solución o con un framework de inyección de dependencia?

No en este momento. Por favor comparta sus ideas en
[flutter-dev@googlegroups.com](mailto:flutter-dev@googlegroups.com).

## Tecnología

### Con qué tecnología se construye Flutter?

Flutter está construido con C, C++, Dart y Skia (un motor de renderización 2D). Mira este
[diagrama de arquitectura](https://docs.google.com/presentation/d/1cw7A4HbvM_Abv320rVgPVGiUP2msVs7tfGbkgdrTy0I/edit#slide=id.gbb3c3233b_0_162) para una mejor idea de los componentes principales.

### Cómo ejecutar Flutter mi código en Android? {#run-android}

Los códigos C y C++ del motor están compilados con el NDK de Android. El código Dart
(tanto los SDK como los tuyos) están anticipados (AOT) compilados en una biblioteca ARM nativa. Esa biblioteca está incluida en un proyecto de Android "runner", y el conjunto está integrado en un APK. Cuando se inicia, la aplicación carga la biblioteca Flutter.
Cualquier representación, entrada o manejo de eventos, etc., se delegan en el compilado
Flutter y código de la aplicación. Esto es similar a la forma en que funcionan muchos motores de juegos.

Las construcciones de modo de depuración usan una máquina virtual (VM) para ejecutar el código de Dart (de ahí la "depuración"
anuncio que muestran para recordar a las personas que son un poco más lentos) con el fin de
habilitar el stateful hot reload.

### Cómo funciona Flutter para ejecutar mi código en iOS? {#run-ios}

Los códigos C y C++ del motor están compilados con LLVM. El código Dart (tanto
Los SDK y los suyos) están anticipados (AOT) compilados en una biblioteca ARM nativa.
Esa biblioteca está incluida en un proyecto de iOS "runner", y todo está construido
en un `.ipa`. Cuando se inicia, la aplicación carga la biblioteca Flutter. Cualquier renderizado, manejo de entradas o eventos, y así sucesivamente, se delegan al compilado de Flutter y código de la aplicación. Esto es similar a la forma en que funcionan muchos motores de juegos.

Las construcciones de modo de depuración usan una máquina virtual (VM) para ejecutar el código de Dart (de ahí el banner de "depuración" que muestran para recordar a las personas que son un poco más lentos) con el fin de
habilitar stateful hot reload.

### Flutter usa los widgets OEM de mi sistema?

No. En cambio, Flutter proporciona un conjunto de widgets
(incluidos los widgets de Material Design y Cupertino (estilo iOS))
administrado y renderizado por el framework y el motor de Flutter.
Puedes navegar por un
[catálogo de widgets de Flutter](/widgets/).

Esperamos que el resultado final sean aplicaciones de mayor calidad. Si reutilizamos
los widgets OEM, la calidad y el rendimiento de las aplicaciones de Flutter serán
limitado por la calidad de esos widgets.

En Android, por ejemplo, hay un conjunto de gestos rígidos y reglas fijas
para desambiguarlos. En Flutter, puede escribir su
propio gestor de reconocimiento que es un participante de primera clase en el
[gesture system](/gestures/). Por otra parte, dos widgets
escrito por diferentes personas puede coordinar para desambiguar los gestos.

Las tendencias de diseño de aplicaciones modernas apuntan a diseñadores y usuarios que desean UI más ricas en movimiento y diseños propios de la marca.
Para alcanzar ese nivel de diseño personalizado y hermoso,
Flutter está diseñado para manejar píxeles en lugar de los widgets OEM.

Al usar el mismo renderizador, framework y conjunto de widgets, lo hacemos
más fácil de publicar para iOS y Android al mismo tiempo, sin tener que hacer
planificación cuidadosa y costosa para alinear dos bases de códigos y conjuntos de características por separado.

Al usar un solo idioma, un solo framework,
y un único conjunto de bibliotecas para toda su UI
(independientemente de si su interfaz de usuario es diferente para cada plataforma móvil o en gran medida consistente), también apuntamos a
ayuda a reducir los costos de desarrollo y mantenimiento de la aplicación.

### Qué sucede cuando mi sistema operativo móvil se actualiza e introduce nuevos widgets?

El equipo de Flutter observa la adopción y demanda de nuevos widgets para dispositivos móviles de iOS y Android, y tiene como objetivo trabajar con la comunidad para construir soporte para nuevos widgets. Este trabajo puede venir en la forma de las características del framework de nivel inferior, nuevos widgets compuestos, o nuevas implementaciones de widgets.

La arquitectura en capas de Flutter está diseñada para soportar numerosas
bibliotecas de widgets, y alentamos y apoyamos a la comunidad en
construir y mantener bibliotecas de widgets.

### Qué sucede cuando mi sistema operativo móvil se actualiza e introduce nuevas capacidades de plataforma?

El sistema de interoperabilidad y plugin de Flutter está diseñado para permitir
desarrolladores para acceder a las nuevas funciones y capacidades del sistema operativo móvil inmediatamente. Los desarrolladores no tienen que esperar al equipo de Flutter para exponer la nueva capacidad del sistema operativo móvil.

### Qué sistemas operativos puedo usar para construir una aplicación de Flutter?

Flutter admite el desarrollo en Linux, Mac y Windows.

### En qué idioma está escrito Flutter?

Observamos muchos lenguajes y tiempos de ejecución, y finalmente adoptamos a Dart para el framwork y los widgets. El framework de gráficos subyacente y la máquina virtual de Dart se implementan en C/C++.

### Por qué Flutter eligió usar Dart?

Flutter utilizó cuatro dimensiones principales para la evaluación, y consideró las necesidades de autores de framework, desarrolladores y usuarios finales. Encontramos algunos lenguajes encontrados algunos requisitos, pero Dart obtuvo una puntuación alta en todas nuestras dimensiones de evaluación y cumplió todos nuestros requisitos y criterios.

Los tiempos de ejecución Dart y los compiladores admiten la combinación de dos características críticas para Flutter: un ciclo de desarrollo rápido basado en JIT que permite el cambio de forma y hot reload con estado en un idioma con tipado, más un compilador AOT que emite un código ARM eficiente para un arranque rápido y un rendimiento predecible de implementaciones de producción.

Además, tenemos la oportunidad de trabajar estrechamente con la comunidad Dart,
que está invirtiendo activamente recursos para mejorar Dart para usar en Flutter. por
ejemplo, cuando adoptamos Dart, el lenguaje no tenía una AOT toolchain para producir binarios nativos, que es fundamental para lograr predecible, de alto rendimiento, pero ahora el lenguaje lo hace porque el equipo de Dart lo construyó para Flutter. Del mismo modo, la Dart VM se ha optimizado previamente para rendimiento pero el equipo ahora está optimizando la VM para la latencia, que es más
importante para la carga de trabajo de Flutter.

Dart tiene una alta puntuación para nosotros en los siguientes criterios principales:

* _Productividad del desarrollador_. Una de las principales propuestas de valor de Flutter es que ahorra recursos de ingeniería al permitir que los desarrolladores creen aplicaciones tanto para iOS como para Android con la misma base de código. Usar un lenguaje altamente productivo acelera aún más a los desarrolladores y hace que Flutter sea más atractivo. Esto fue muy importante tanto para nuestro equipo de framework como para nuestros desarrolladores. La mayoría de Flutter está construido en el mismo idioma que le damos a nuestros usuarios, por lo que necesitamos seguir siendo productivos en las líneas de código de 100k, sin sacrificar accesibilidad o legibilidad del framework y widgets para nuestros desarrolladores.

* _Orientación a objetos_. Para Flutter, queremos un lenguaje que se adapte a  problema de dominio de Flutter: crear experiencias visuales de usuario. La industria tiene varias décadas de experiencia construyendo framework de interfaz de usuario en lenguajes orientados a objetos. Si bien podríamos usar un lenguaje no orientado a objetos, esto significaría reinventar la rueda para resolver varios problemas difíciles. Además, la gran mayoría de los desarrolladores tienen experiencia con desarrollo orientado a objetos, por lo que es más fácil aprender a desarrollar con Flutter.

* _Predictable, alto rendimiento_. Con Flutter, queremos potenciar a los desarrolladores para crear experiencias de usuario rápidas y fluidas. Para lograr eso, necesitamos ser capaz de ejecutar una cantidad significativa de código de desarrollador final durante cada marco de animación. Eso significa que necesitamos un lenguaje que ofrezca altos rendimiento y rendimiento predecible, sin pausas periódicas que causarían marcos caídos.

* _Fast allocation_. El framework de Flutter usa un flujo de estilo funcional eso depende mucho de la memoria manejando eficientemente asignaciones pequeñas y de corta duración. Este estilo fue desarrollado en idiomas con esta propiedad y lo hace no funciona de manera eficiente en idiomas que carecen de esta facilidad.

### Puede Flutter ejecutar cualquier código Dart?

Flutter debería poder ejecutar la mayoría del código Dart que no se importa (de forma transitiva o directamente) dart: mirrors o dart: html.

### Qué tan grande es el motor Flutter??

En junio de 2017, medimos el tamaño de una aplicación mínima de Flutter
(sin componentes de materiales, solo un único widget de "centro", construido con
`flutter build apk`), incluido y
comprimido como un lanzamiento APK, para ser aproximadamente 6.7MB.

Para esta aplicación simple,
el motor central es aproximadamente 3.3MB (comprimido),
el código framework + app es de aproximadamente 1.25MB (comprimido),
el archivo LICENSE (contenido en app.flx) es 55k (comprimido),
el código Java necesario (classes.dex) es 40k (comprimido),
y hay aproximadamente 2,1 MB de datos de la UCI (comprimidos).

Por supuesto, YMMV, y le recomendamos que mida su propia aplicación,
ejecutando `flutter build apk` y mirando `app/outputs/apk/app-release.apk`.

## Capacidades

### Qué tipo de rendimiento de la aplicación puedo esperar?

Puedes esperar un excelente rendimiento. Flutter es diseñado para ayudar a los desarrolladores a lograr fácilmente 60 fps constantes. Las aplicaciones de Flutter se ejecutan a través del código compilado de forma nativa, no hay intérpretes involucrados. Esto significa que las aplicaciones de Flutter inician rápidamente.

### Qué tipo de ciclos de desarrollador puedo esperar? ¿Cuánto tiempo entre editar y actualizar? {# hot-reload}

Flutter implementa un ciclo de desarrollador _hot reload_. Puedes esperar
tiempos de recarga por segundo, en un dispositivo o emulador/simulador.

El hot reload de Flutter es _stateful_, lo que significa que el estado de la aplicación se conserva después de una recarga. Esto significa que puede iterar rápidamente en una pantalla anidada profundamente en su aplicación, sin iniciar desde la pantalla de inicio después de cada recarga.

### En que se diferencia 'hot reload' de 'hot restart'?

Hot Reload funciona inyectando archivos actualizados de código fuente en la Dart VM en ejecución (Máquina virtual). Esto incluye no solo agregar nuevas clases, sino también agregar métodos y campos para clases existentes, y cambio de funciones existentes. Unos pocos tipos de cambios de código no pueden ser hot realoaded:

* Inicializadores variables globales.
* Inicializadores de campo estáticos.
* El método `main ()` de la aplicación.

Consulte [Using Hot Reload](/hot-reload/) para obtener detalles adicionales.

### Dónde puedo desplegar mi aplicación Flutter?

Puede compilar e desplegar su aplicación Flutter en iOS y Android.

### Qué dispositivos y versiones de sistema operativo ejecuta Flutter?

Sistemas operativos móviles: Android Jelly Bean, v16, 4.1.x o posterior, y
iOS 8 o más nuevo.

Hardware móvil: dispositivos iOS (iPhone 4S o posterior) y dispositivos Android ARM.

Nota Flutter actualmente no es compatible con la construcción de x86 Android
(problema [#9253](https://github.com/flutter/flutter/issues/9253)) directamente, sin embargo, las aplicaciones creadas para ARMv7 o ARM64 funcionan bien (a través de la emulación ARM en muchos dispositivos Android x86.

Apoyamos el desarrollo de aplicaciones de Flutter con dispositivos Android e iOS, como así como con los emuladores de Android y el simulador de iOS.

Probamos en una variedad de teléfonos de gama baja a gama alta pero aún no tenemos una garantía oficial de compatibilidad de dispositivos.

No probamos en tabletas, por lo que puede haber problemas con algunos widgets en tabletas. No hemos implementado adaptaciones específicas en tabletas de nuestros widgets.

### Flutter se ejecuta en la web?

No. No estamos trabajando para proporcionar una versión web de Flutter.

### Puedo usar Flutter para crear aplicaciones de escritorio?

Nos enfocamos en los casos de uso móvil primero. Sin embargo, Flutter es de código abierto y alentamos a la comunidad a utilizar Flutter de diversas maneras interesantes.

### Puedo usar Flutter dentro de mi aplicación nativa existente??

Sí, puedes insertar una vista de Flutter en tu aplicación existente de Android o iOS, sin embargo nuestras herramientas no están actualmente optimizadas para este caso de uso (ver [este problema](https://github.com/flutter/flutter/issues/14821) para detalles).

Dos demostraciones actuales de esto son por ejemplo [platform_view](https://github.com/flutter/flutter/tree/master/examples/platform_view)
y [flutter_view](https://github.com/flutter/flutter/tree/master/examples/flutter_view). Alguna documentación inicial está disponible en la página wiki
[Agrega Flutter a las aplicaciones existentes](https://github.com/flutter/flutter/wiki/Add-Flutter-to-existing-apps).

### ¿Puedo acceder a servicios de plataforma y API como sensores y almacenamiento local?

Sí. Flutter ofrece a los desarrolladores acceso inmediato a _some_ plataforma específica servicios y API del sistema operativo. Sin embargo, queremos evitar el
"problema del mínimo común denominador" con la mayoría de las API multiplataforma, por lo que no intentamos construir API multiplataforma para todos los servicios y API nativos.

Varios servicios de plataforma y API tienen [paquetes listos para usar](https://pub.dartlang.org/flutter/) disponible en el repositorio Pub. Usar un paquete existente [es fácil](/using-packages/).

Finalmente, alentamos a los desarrolladores a utilizar el paso de sistemas de mensajes asíncronos de Flutter para crear sus propias integraciones con [plataforma y APIs de terceros](/platform-channels/). Los desarrolladores pueden exponer tanto o tan poco de la plataforma API según lo necesiten, y construya capas de abstracciones que se ajusten mejor para su proyecto.

### Puedo ampliar y personalizar los widgets incluidos?

Absolutamente. El sistema de widgets de Flutter fue diseñado para ser fácilmente personalizable.

En lugar de tener cada widget proporciona una gran cantidad de parámetros, Flutter
abraza la composición. Los widgets están formados por widgets más pequeños que puedes
reutilice y combine de maneras novedosas para hacer widgets personalizados. Por ejemplo, más bien que subclasificar un widget de botón genérico, RaisedButton combina un Material widget con un widget GestureDetector. El widget Material proporciona el visual el diseño y el widget GestureDetector proporcionan el diseño de interacción.

Para crear un botón con un diseño visual personalizado, puede combinar widgets que
implemente su diseño visual con un GestureDetector, que proporciona diseño de interacción. Por ejemplo, CupertinoButton sigue este enfoque y combina un GestureDetector con varios otros widgets que implementan diseño visual.

La composición le brinda el máximo control sobre el diseño visual y de interacción
de sus widgets mientras que también permite una gran cantidad de reutilización de código. En el framework, hemos descompuesto widgets complejos en piezas que implementan por separado el diseño visual, de interacción y de movimiento. Sin embargo, puedes volver a mezclar estos widgets si te gusta crear tus propios widgets personalizados que tengan un rango completo de expresión.

### Por qué querría compartir el código de diseño en iOS y Android?

Puede optar por implementar diferentes diseños de aplicaciones para iOS y Android.
Los desarrolladores son libres de verificar el sistema operativo móvil en tiempo de ejecución y renderizar diferentes diseños, aunque encontramos que esta práctica es rara.

Cada vez más, vemos diseños y diseños de aplicaciones móviles evolucionando
para ser más impulsado por la marca y unificado en todas las plataformas. Esto implica una gran motivación para compartir el diseño y el código de UI en iOS y
Android.

La identidad de marca y la personalización del diseño estético de la aplicación es ahora volviéndose más importante que adherirse estrictamente a la plataforma tradicional estética. Por ejemplo, los diseños de aplicaciones a menudo requieren fuentes personalizadas, colores, formas, movimiento y más para transmitir claramente su identidad de marca.

También vemos patrones de diseño comunes implementados en iOS y Android.
Por ejemplo, ahora se puede encontrar naturalmente el patrón de "barra de navegación inferior" a través de iOS y Android. Parece que hay una convergencia de ideas de diseño a través de plataformas móviles.

### Puedo interoperar con el lenguaje de programación predeterminado de mi plataforma móvil?

Sí, Flutter admite llamar a la plataforma, incluida la integración con Java o Kotlin.
código en Android y código ObjectiveC o Swift en iOS. Esto está habilitado a través del estilo de paso flexible de mensajes donde una aplicación Flutter puede enviar y recibir mensajes a la plataforma móvil usando un [`BasicMessageChannel`](https://docs.flutter.io/flutter/services/BasicMessageChannel-class.html).

Obtenga más información sobre cómo acceder a servicios de plataforma y de terceros en Flutter con [canales de plataforma](/platform-channels/).

Aquí hay un [proyecto de ejemplo](https://github.com/flutter/flutter/tree/master/examples/platform_channel) que muestra como usar los canales de plataforma para acceder a la información de estado de la batería en iOS y Android

### Flutter viene con un sistema de reflection/mirrors?

No en este momento. Debido a que las aplicaciones de Flutter están compiladas previamente para iOS y tamaño binario siempre es una preocupación con las aplicaciones móviles, desactivamos dart: mirrors. Somos curiosos para qué puede necesitar reflection/mirrors, por favor avísenos
[flutter-dev@googlegroups.com](mailto:flutter-dev@googlegroups.com).

### Cómo hago la internacionalización (i18n), la localización (l10n) y la accesibilidad (a11y) en Flutter?

Aprenda más sobre i18n y l10n en el [Tutorial de internacionalización de Flutter](/tutorials/internationalization/).

Aprenda más sobre a11y en el [documentación de accesibilidad](/accessibility/).

### Cómo escribo aplicaciones paralelas y/o concurrentes para Flutter?

Flutter admite aislamientos. Los aislamientos son heaps separados en VM de Flutter, y
pueden ejecutarse en paralelo (generalmente implementados como hilos separados). Aislados comunicarse enviando y recibiendo mensajes asíncronos. Flutter no tiene
actualmente una solución de paralelismo de memoria compartida, aunque estamos evaluando soluciones para esto.

Echa un vistazo al [ejemplo de usar aislamientos con Flutter](https://github.com/flutter/flutter/blob/master/examples/layers/services/isolate.dart).

### Puedo ejecutar el código de Dart en el fondo de una aplicación de Flutter?

El código en ejecución en segundo plano tiene API específicas de plataforma debido a
diferencias en el soporte para la ejecución de fondo en cada uno de las plataformas para Android e iOS.

En Android, el complemento [`android_alarm_manager`](https://pub.dartlang.org/packages/android_alarm_manager) le permite ejecutar el código Dart en segundo plano, incluso cuando la aplicación de Flutter no está en primer plano.

En iOS, actualmente no admiten esta capacidad. Por favor, no pierdas de vista el [error 6192](https://github.com/flutter/flutter/issues/6192) para actualizaciones.

### Puedo usar JSON/XML/protobuffers/etc con Flutter?

Absolutamente. Hay bibliotecas en [pub.dartlang.org](https://pub.dartlang.org) para JSON, XML, protobufs, y muchas otras utilidades y formatos.

Para obtener un informe detallado sobre el uso de JSON con Flutter, consulte [el tutorial JSON](/json/).

### Puedo crear aplicaciones 3D (OpenGL) con Flutter?

Actualmente no admitimos 3D a través de OpenGL ES o similar. Tenemos planes a largo plazo para exponer una API 3D optimizada, pero estamos enfocados en 2D.

### Por qué mi APK o IPA es tan grande?

Por lo general, los activos que incluyen imágenes, archivos de sonido, fuentes, etc., son un bulk de un APK o IPA.
Varias herramientas en los ecosistemas de Android e iOS pueden ayudarlo a comprender
qué hay dentro de tu APK o IPA.

Además, asegúrate de crear un _release build_ de su APK o IPA con las herramientas de Flutter. Una compilación de lanzamiento es usualmente _mucho_ más pequeña
que un _debug build_.

Obtenga más información sobre cómo crear una [versión de lanzamiento de su aplicación de Android](https://flutter.io/android-release/), y creando un [lanzamiento de versión de su aplicación iOS](https://flutter.io/ios-release/).

### Las aplicaciones de Flutter se ejecutan en Chromebooks?

Hemos visto ejecutar aplicaciones de Flutter en algunos Chromebooks.
Estamos rastreando [problemas relacionados con la ejecución de Flutter en Chromebooks](https://github.com/flutter/flutter/labels/platform-arc).

## Framework

### Por qué el método build() está en estado, no en StatefulWidget?

Poniendo un método `Widget build (BuildContext context)` en State
en lugar de poner un método `Widget build(BuildContext context, State state)`
en StatefulWidget les da a los desarrolladores más flexibilidad con
subclases StatefulWidget. Puedes leer una [discusión más detallada sobre los documentos API para State.build](https://docs.flutter.io/flutter/widgets/State/build.html).

### Dónde está el lenguaje markup de Flutter? ¿Por qué Flutter no tiene una sintaxis de markup?

Las IU de Flutter están construidas con un lenguaje imperativo, orientado a objetos (Dart, el mismo lenguaje utilizado para construir el framework de Flutter). Flutter
no se envía con un markup declarativo.

Encontramos que las IU construidas dinámicamente con código permiten
más flexibilidad. Por ejemplo, nos ha resultado difícil
para un sistema de markup rígido expresar y producir
widgets personalizados con comportamientos a la medida.

También hemos descubierto que nuestro "code-first" permite mejores funciones como
adaptaciones de hot reload y entorno dinámico.

Es posible crear un lenguaje personalizado que sea entonces convertido en widgets sobre la marcha. Debido a que los métodos de compilación son "just code", puede hacer cualquier cosa, incluso interpretar el markup y convertirlo en widgets.

### Mi aplicación tiene una banner/cinta de depuración en la esquina superior derecha. ¿Por qué estoy viendo eso?

Por defecto, el comando `flutter run` usa la configuración de compilación de depuración.

La configuración de depuración ejecuta su código Dart en una máquina virtual (máquina virtual) habilitando un ciclo de desarrollo rápido con [carga en caliente](#hot-reload) (las versiones de lanzamiento son compilado usando el estándar [Android](#run-android) y [iOS](#run-ios) cadenas de herramientas).

La configuración de depuración también verifica todas las afirmaciones, lo que ayuda a detectar errores temprano durante el desarrollo, pero impone un costo de tiempo de ejecución. El banner "Debug" indica que estas comprobaciones están habilitadas. Puede ejecutar su aplicación sin estos comprueba usando el indicador `--profile` o` --release` para `flutter run`.

Si está utilizando el plugin Flutter para IntelliJ, puede iniciar la aplicación en
perfil o modo de liberación usando las entradas del menú **Run > Flutter Run en modo Profile** or **Release Mode**.

### Qué paradigma de programación usa el framework de Flutter?

Flutter es un entorno de programación multi-paradigma. Muchas técnicas de programación desarrollado en las últimas décadas se utilizan en Flutter. Usamos cada uno donde creemos que las fortalezas de la técnica lo hacen especialmente adecuado. Sin un orden en particular:

* Composición: el paradigma principal utilizado por Flutter es el de usar
objetos pequeños con alcances estrechos de comportamiento, compuestos juntos para
obtener efectos más complicados. La mayoría de los widgets en la biblioteca de widgets de Flutter está construida de esta manera. Por ejemplo, la clase Material
[FlatButton](https://docs.flutter.io/flutter/material/FlatButton-class.html)
se construye usando una clase [MaterialButton](https://docs.flutter.io/flutter/material/MaterialButton-class.html), que a su vez se construye utilizando
un [IconTheme](https://docs.flutter.io/flutter/widgets/IconTheme-class.html),
un [InkWell](https://docs.flutter.io/flutter/material/InkWell-class.html),
un [Padding](https://docs.flutter.io/flutter/widgets/Padding-class.html),
un [Center](https://docs.flutter.io/flutter/widgets/Center-class.html),
un [Material](https://docs.flutter.io/flutter/material/Material-class.html),
un [AnimatedDefaultTextStyle](https://docs.flutter.io/flutter/widgets/AnimatedDefaultTextStyle-class.html), y un [ConstrainedBox](https://docs.flutter.io/flutter/widgets/ConstrainedBox-class.html).
El [InkWell](https://docs.flutter.io/flutter/material/InkWell-class.html)
esta construido usando un [GestureDetector](https://docs.flutter.io/flutter/widgets/GestureDetector-class.html).
El [Material](https://docs.flutter.io/flutter/material/Material-class.html)
esta construido usando un [AnimatedDefaultTextStyle](https://docs.flutter.io/flutter/widgets/AnimatedDefaultTextStyle-class.html),
un [NotificationListener](https://docs.flutter.io/flutter/widgets/NotificationListener-class.html),
y un [AnimatedPhysicalModel](https://docs.flutter.io/flutter/widgets/AnimatedPhysicalModel-class.html).
Y así. Son widgets todo el camino.

* Programación funcional: las aplicaciones completas pueden construirse solo con
[StatelessWidget](https://docs.flutter.io/flutter/widgets/StatelessWidget-class.html), que son esencialmente funciones que describen cómo los argumentos se asignan a otras funciones, cayendo en primitivas que computan layouts o gráficos de pintura. (Tales aplicaciones no pueden tener estado fácilmente, por lo que normalmente no son interactivas.)
Por ejemplo, el [Icon](https://docs.flutter.io/flutter/widgets/Icon-class.html)
widget es esencialmente una función que mapea sus argumentos
([color](https://docs.flutter.io/flutter/widgets/Icon/color.html),
[icon](https://docs.flutter.io/flutter/widgets/Icon/icon.html),
[size](https://docs.flutter.io/flutter/widgets/Icon/size.html)) dentro de layout
primitivos. Además, se hace un uso intensivo de estructuras de datos inmutables
incluyendo toda la jerarquía de clase de
[Widget](https://docs.flutter.io/flutter/widgets/Widget-class.html), así como numerosas clases de apoyo tales como
[Rect](https://docs.flutter.io/flutter/dart-ui/Rect-class.html) y
[TextStyle](https://docs.flutter.io/flutter/painting/TextStyle-class.html). En una menor escala, La API
[Iterable](https://docs.flutter.io/flutter/dart-core/Iterable-class.html) de Dart,
que hace un uso intensivo del estilo funcional (map, reduce, where, etc.), es
frecuentemente utilizado para procesar listas de valores en el framework.

* Programación event-driven: las interacciones del usuario están representadas por objetos de eventos que se envían a callbacks registradas con controladores de eventos. Actualizaciones de pantalla son activados por un mecanismo de callback similar. La clase [Listenable](https://docs.flutter.io/flutter/foundation/Listenable-class.html), que se utiliza como base del sistema de animación, formatea un modelo de suscripción para eventos con múltiples oyentes.

* Programación orientada a objetos basada en clases: la mayoría de las API del Framework se construyen usando clases con herencia. Usamos un enfoque por el cual definimos API de muy alto nivel en nuestras clases base, luego especialícelas iterativamente en subclases. Por ejemplo, nuestros objetos de renderizado tienen una clase base ([RenderObject](https://docs.flutter.io/flutter/rendering/RenderObject-class.html)) eso es agnóstico con respecto al sistema de coordenadas, y luego tenemos una subclase ([RenderBox](https://docs.flutter.io/flutter/rendering/RenderBox-class.html)) que introduce la opinión de que la geometría debe basarse en el cartesiano sistema de coordenadas (x/ancho y/ alto).

* Programación orientada a objetos basada en prototipos: la clase [ScrollPhysics](https://docs.flutter.io/flutter/widgets/ScrollPhysics-class.html) se instancia para componer la física que se aplica al desplazamiento dinámicamente en tiempo de ejecución. Esto permite que el sistema componga, por ejemplo, paginación física con física específica de plataforma, sin que la plataforma tenga que ser seleccionado en tiempo de compilación.

* Programación imperativa: programación imperativa directa, por lo general emparejado con estado encapsulado dentro de un objeto, se usa donde proporciona la solución más intuitiva. Por ejemplo, las pruebas están escritas en un estilo imperativo, primero describiendo la situación bajo prueba, luego enumerando las invariantes que la prueba debe coincidir, luego avanzar el reloj o insertar eventos según sea necesario para la prueba.

* Programación reactiva: el widget y los árboles de elementos a veces se describen como reactivo, porque las nuevas entradas proporcionadas en el constructor de un widget son inmediatamente propagado como cambios a widgets de nivel inferior por el método de compilación del widget, y los cambios realizados en los widgets inferiores (p. ej., en respuesta a la entrada del usuario) se propagan copia de seguridad del árbol a través de controladores de eventos. Aspectos de reactivos funcionales y
imperativo-reactivo están presentes en el marco, en función de las necesidades de la
widgets. Widgets con métodos de compilación que consisten en solo una expresión
describir cómo el widget reacciona a los cambios en su configuración son funcionales
widgets reactivos (por ejemplo, la clase Material [Divider](https://docs.flutter.io/flutter/material/Divider-class.html)). Widgets cuyos métodos de compilación construyen una lista de hijos a lo largo de varias declaraciones, que describen cómo reacciona el widget a los cambios en su configuración, son widgets reactivos imperativos (por ejemplo, la clase [Chip](https://docs.flutter.io/flutter/material/Chip-class.html)).

* Programación declarativa: los métodos de compilación de widgets suelen ser una única expresión con múltiples niveles de constructores anidados, escritos utilizando un subconjunto declarativo de Dart. Tales expresiones anidadas podrían ser mecánicamente transformado hacia o desde cualquier lenguaje de markup expresivo adecuado. Por ejemplo, el widget [UserAccountsDrawerHeader](https://docs.flutter.io/flutter/material/UserAccountsDrawerHeader-class.html) tiene un método de compilación larga (más de 20 líneas), que consiste en una sola expresión anidada. Esto también se puede combinar con el estilo imperativo para construir UI eso sería más difícil de describir en un enfoque puramente declarativo.

* Programación genérica: los tipos pueden usarse para ayudar a los desarrolladores a captar errores tempranos en la programación. El framework de Flutter utiliza programación genérica para ayudar en esto. Por ejemplo, la clase [State](https://docs.flutter.io/flutter/widgets/State-class.html) es parametrizada en términos del tipo de su widget asociado, de modo que el analizador Dart puede detectar desajustes entre estados y widgets. Del mismo modo, la clase [GlobalKey](https://docs.flutter.io/flutter/widgets/GlobalKey-class.html) toma un parámetro de tipo para que pueda acceder al estado de un widget remoto en un tipo de manera segura (utilizando la comprobación de tiempo de ejecución), la interfaz [Route](https://docs.flutter.io/flutter/widgets/Route-class.html) es parametrizada con el tipo que se espera que use cuando [popped](https://docs.flutter.io/flutter/widgets/Navigator/pop.html), y colecciones tales como [List](https://docs.flutter.io/flutter/dart-core/List-class.html), [Map](https://docs.flutter.io/flutter/dart-core/Map-class.html), y [Set](https://docs.flutter.io/flutter/dart-core/Set-class.html) todas son parametrizadas de modo que los elementos no coincidentes se puedan detectar temprano durante análisis o en tiempo de ejecución durante la depuración.

* Programación concurrente: Flutter hace un uso intensivo de [Future](https://docs.flutter.io/flutter/dart-async/Future-class.html) y otras API asíncronas. Por ejemplo, el sistema de animación informa cuando la animación se completa al completar un futuro. El sistema de carga de imagen de manera similar utiliza futuros para informar cuando se completa una carga.

* Programación de restricción: el sistema de disposición en Flutter usa una forma débil de programación de restricciones para determinar la geometría de una escena. Restricciones (para cajas cartesianas, un ancho mínimo y máximo y un mínimo y máximo altura) se pasan de padres a hijos, y el hijo selecciona una geometría resultante (por ejemplo, para cajas cartesianas, un tamaño, específicamente un ancho y una altura) que cumple con esas restricciones. Al usar esta técnica, Flutter generalmente puede diseñar una escena completa con un solo pase.

## Proyecto

### Donde puedo obtener soporte?

Si crees que has encontrado un error, por favor archívalo en nuestro
[rastreador de problemas](https://github.com/flutter/flutter/issues). Nosotros te animamos a usar [Stack Overflow](https://stackoverflow.com/tags/flutter) para preguntas tipo "HOWTO". Para discusiones, por favor, únete a nuestra lista de correo en [flutter-dev@googlegroups.com](mailto:flutter-dev@googlegroups.com).

### Cómo me involucro?

Flutter es de código abierto, y te animamos a contribuir. Puedes comenzar por
simplemente presentando problemas para solicitudes de características y errores en nuestro [rastreador de problemas](https://github.com/flutter/flutter/issues).

Le recomendamos que se una a nuestra lista de correo en [flutter-dev@googlegroups.com](mailto:flutter-dev@googlegroups.com) y déjanos saber cómo estás usando Flutter y qué te gustaría hacer con él.

Si eres interesado en contribuir con el código, puede comenzar leyendo nuestra
[Guía de contribución](https://github.com/flutter/flutter/blob/master/CONTRIBUTING.md) y mirar nuestra lista de [temas fáciles de inicio](https://github.com/flutter/flutter/issues?q=is%3Aopen+is%3Aissue+label%3A%22easy+fix%22).

### Flutter es de código abierto?

Sí, Flutter es una tecnología de código abierto. Puedes encontrar el proyecto en[GitHub](https://github.com/flutter/flutter).

### Qué licencia(s) de software se aplican a Flutter y sus dependencias?

Flutter incluye dos componentes: un motor que se envía como un enlace dinámico
binario, y el framework Dart como un binario separado que carga el motor.
El motor usa múltiples componentes de software con muchas dependencias; ver el
lista completa [aquí](https://raw.githubusercontent.com/flutter/engine/master/sky/packages/sky_engine/LICENSE).

El marco es completamente autónomo y requiere [solo una licencia](https://github.com/flutter/flutter/blob/master/LICENSE).

Además, cualquier paquete Dart que use puede tener sus propios requisitos de licencia.

### Cómo puedo determinar las licencias que mi aplicación Flutter necesita mostrar?

Hay una API para encontrar la lista de licencias que necesita mostrar:

* Si su aplicación tiene un [Drawer](https://docs.flutter.io/flutter/material/Drawer-class.html),agrega una [AboutListTile](https://docs.flutter.io/flutter/material/AboutListTile-class.html).

* Si su aplicación no tiene un drawer pero sí utiliza la biblioteca de Material Components, llame a cualquier [showAboutDialog](https://docs.flutter.io/flutter/material/showAboutDialog.html) o [showLicensePage](https://docs.flutter.io/flutter/material/showLicensePage.html).

* Para un enfoque más personalizado, puede obtener las licencias sin procesar de la [LicenseRegistry](https://docs.flutter.io/flutter/foundation/LicenseRegistry-class.html).

### Quién trabaja en Flutter?

Flutter es un proyecto de código abierto. Actualmente, la mayor parte del desarrollo está hecho por ingenieros en Google. Si estás entusiasmado con Flutter, te animamos a que te unas la comunidad y contribuir a Flutter!

[widgets]: https://flutter.io/widgets/

### Cuáles son los principios rectores de Flutter?

Creemos que:

* Para llegar a todos los usuarios potenciales, los desarrolladores deben enfocarse en múltiples plataformas móviles.
* HTML y WebViews tal como existen hoy hacen que sea desafiante constantemente alcanzar altas velocidades de cuadro y ofrecer experiencias de alta fidelidad, debido a comportamiento automático (desplazamiento, diseño) y soporte heredado.
* Hoy, es demasiado costoso construir la misma aplicación varias veces: requiere diferentes equipos, diferentes bases de código, diferentes flujos de trabajo, diferentes herramientas, etc.
* Los desarrolladores quieren una forma más fácil y mejor de usar una única base de código para crear aplicaciones móviles para múltiples plataformas, y no quieren sacrificar calidad, control o actuación.

Estamos enfocados en tres cosas:

* _Control_ - Los desarrolladores merecen tener acceso y controlar todas las capas del sistema. Lo que lleva a:
* _Performance_ - Los usuarios merecen fluidez, capacidad de respuesta, aplicaciones jank-free. Lo que lleva a:
* _Fidelity_ - Todo el mundo merece precisión, belleza, deliciosas experiencias de aplicaciones móviles.

### Apple rechazará mi aplicación Flutter?

No podemos hablar por Apple, pero las políticas de Apple han cambiado en los ultimos años, y ellos tienen aplicaciones permitidas creadas con sistemas como Flutter. Somos conscientes de aplicaciones creadas con Flutter que han sido revisadas y lanzado a través de la App Store.

Por supuesto, Apple es en última instancia a cargo de su ecosistema, pero nuestro objetivo es continuar haciendo todo lo que puede asegurar que las aplicaciones de Flutter se puedan implementar en la App Store de Apple.
