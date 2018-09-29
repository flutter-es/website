---
title: Resumen Técnico
layout: page
permalink: /technical-overview/
---

## ¿Qué es Flutter?

Flutter es un SDK de aplicaciones móviles para la creación de aplicaciones de alto rendimiento y alta fidelidad para iOS y Android, a partir de un único código base.

El objetivo es permitir a los desarrolladores que lancen aplicaciones de alto rendimiento que se adapten de forma natural a diferentes plataformas. Abarcamos las diferencias en los comportamientos de scrolling, tipografía, iconos, y más.

<object type="image/svg+xml" data="/images/whatisflutter/hero-shrine.svg" style="width: 100%; height: 100%;"></object>

Esta es una aplicación de demostración de la [Galería](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery/lib/demo),
una colección de aplicaciones de ejemplo de Flutter que puedes ejecutar después de instalar Flutter y de configurar tu entorno. 
Shrine tiene scrolling de imágenes de alta calidad, cards interactivas, botones, listas desplegables, y una página de carrito de compras. Para ver el código base único de este y otros ejemplos, [visita nuestro repositorio en GitHub](https://github.com/flutter/flutter/tree/master/examples).

No se requiere experiencia en desarrollo móvil para empezar. Las aplicaciones están escritas en [Dart](https://dartlang.org/), lo que resulta familiar si has utilizado un lenguaje como Java o JavaScript. !La experiencia con lenguajes orientados a objetos es definitivamente útil, pero, incluso los no programadores han desarrollado aplicaciones Flutter!

## ¿Por qué usar Flutter?

¿Cuáles son algunas de las ventajas de Flutter? Te ayuda a:

*   Ser altamente productivo
    *   Desarrolla para iOS y Android desde una único código base
    *   Haz más con menos código, incluso en un solo sistema operativo, 
        con un lenguaje moderno y expresivo y un enfoque declarativo.
    *   Haz un prototipo e itera fácilmente
        *   Experimenta cambiando el código y recargando a medida que tu aplicación se ejecuta (con hot reload)
        *   Corrige los fallos y continúa depurando desde donde la aplicación se quedó
*   Crear experiencias de usuario maravillosas y altamente personalizadas
    *   Benefíciate de un amplio conjunto de widgets Material Design y Cupertino (toque iOS)
        construidos usando el propio framework de Flutter
    *   Realiza diseños personalizados, agradables y de marca, sin las
        limitaciones de los conjuntos de widgets OEM

## Principios básicos

Flutter incluye un framework moderno de estilo reactivo, un motor de renderizado 2D, widgets listos y herramientas de desarrollo. Estos componentes trabajan juntos para ayudarte a diseñar, construir, probar y depurar aplicaciones. Todo está organizado en torno a unos pocos principios básicos.

### Todo es un Widget

Los widgets son los elementos básicos de la interfaz de usuario de una aplicación Flutter. Cada widget es una declaración inmutable de parte de la interfaz de usuario.  A diferencia de otros frameworks que separan vistas, controladores de vistas, layouts y otras propiedades, Flutter tiene un modelo de objeto unificado y consistente: el widget.

Un widget puede definir:

*   un elemento estructural (como un botón o menú)
*   un elemento de estilo (como una fuente o un esquema de color)
*   un aspecto del diseño (como padding)
*   y así sucesivamente...

Los widgets forman una jerarquía basada en la composición.  Cada widget se integra en el interior y hereda propiedades de su padre.  No existe un objeto "application" separado.
En su lugar, el widget raíz sirve para esta función.

Puedes responder a eventos, como la interacción del usuario, diciéndole al framework que reemplace un widget en la jerarquía con otro widget.  El framework compara los widgets nuevos y antiguos y actualiza eficientemente la interfaz de usuario.

#### Composición > herencia

Los widgets se componen a menudo de muchos widgets pequeños y de un solo propósito, que se combinan para producir efectos poderosos. Por ejemplo, [Container](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/container.dart),
un widget de uso común está compuesto por varios widgets responsables del diseño,
pintado, posicionamiento y dimensionado. Específicamente, Container está compuesto por widgets 
[LimitedBox](https://docs.flutter.io/flutter/widgets/LimitedBox-class.html),
[ConstrainedBox](https://docs.flutter.io/flutter/widgets/ConstrainedBox-class.html),
[Align](https://docs.flutter.io/flutter/widgets/Align-class.html),
[Padding](https://docs.flutter.io/flutter/widgets/Padding-class.html),
[DecoratedBox](https://docs.flutter.io/flutter/widgets/DecoratedBox-class.html),
y [Transform](https://docs.flutter.io/flutter/widgets/Transform-class.html). 
En lugar de subclasificar Contenedor para producir un efecto personalizado, puedes componer estos y otros widgets sencillos de formas novedosas.

La jerarquía de clases es superficial y amplia para maximizar el número posible de combinaciones.

<object type="image/svg+xml" data="/images/whatisflutter/diagram-widgetclass.svg" style="width: 100%; height: 100%;"></object>

También puedes controlar el *diseño* de un widget componiéndolo con otros widgets.
Por ejemplo, para centrar un widget, puedes envolverlo en un widget Center. Hay widgets para
padding, alignment, row, columns, y grids. Estos widgets de diseño no tienen una representación visual propia. En cambio, su único propósito es controlar algún aspecto del diseño de otro widget. Para entender por qué un widget se renderiza de cierta manera, a menudo es útil inspeccionar los widgets vecinos.

#### Los pasteles en capas son deliciosos

El framework Flutter está organizado en una serie de capas, con cada capa
construyéndose sobre la capa anterior.

<object type="image/svg+xml" data="/images/whatisflutter/diagram-layercake.svg" style="width: 85%; height: 85%"></object>

El diagrama muestra las capas superiores de la estructura, que se utilizan más
frecuentemente que las capas inferiores. Para el conjunto completo de librerías que componen
la estructura de capas de Flutter, consulta nuestra [documentación de la API ](https://docs.flutter.io).

El objetivo de este diseño es ayudarte a hacer más con menos código.  Por ejemplo, la capa Material se construye componiendo widgets básicos a partir de la capa de widgets, y la capa de widgets se construye organizando los objetos de nivel inferior a partir de la capa de renderizado.

Las capas ofrecen muchas opciones para crear aplicaciones. Elige un enfoque personalizado para liberar todo el poder expresivo del framework, o usa los componentes de la capa de widgets, o mezcla y combina. Puedes componer los widgets que Flutter proporciona, o crear tus propios widgets personalizados usando las mismas herramientas y técnicas que el equipo de Flutter utilizó para desarrollar el framework.

No se te oculta nada.  Obtendrás los beneficios de productividad de un concepto de widget unificado de alto nivel, sin sacrificar la capacidad de profundizar tanto como desees en las capas inferiores.

### Construyendo widgets

Las características únicas de un widget se definen mediante la implementación de una función [build](https://docs.flutter.io/flutter/widgets/StatelessWidget/build.html)
que devuelve un árbol (o jerarquía) de widgets. Este árbol representa la parte del widget de la interfaz de usuario en términos más concretos. Por ejemplo, un widget de la barra de herramientas puede tener una función de compilación que devuelva un [horizontal layout](https://docs.flutter.io/flutter/widgets/Row-class.html)
de algún [text](https://docs.flutter.io/flutter/widgets/Text-class.html) y
[diversos](https://docs.flutter.io/flutter/material/IconButton-class.html)
[botones](https://docs.flutter.io/flutter/material/PopupMenuButton-class.html).
El framework solicita entonces, recursivamente, a cada uno de estos widgets, que ejecuten su método build hasta que el proceso llegue a su fin en un [widget completo correcto](https://docs.flutter.io/flutter/widgets/RenderObjectWidget-class.html),
que luego el framework une en un árbol.

La función de construcción de un widget debería estar libre de efectos secundarios.  Siempre que se le pida que construya, el widget debe devolver un nuevo árbol de widgets independientemente de lo que el widget haya devuelto previamente. El framework hace el trabajo pesado de comparar la construcción anterior con la actual y determinar qué modificaciones se deben hacer a la interfaz de usuario.

Esta comparación automatizada es bastante efectiva, permitiendo aplicaciones interactivas de alto rendimiento. Y el diseño de la función build simplifica el código al centrarse en declarar de qué está hecho un widget, en lugar de las complejidades de
actualizar la interfaz de usuario de un estado a otro.

### Manejo de la interacción del usuario

Si las características únicas de un widget necesitan cambiar, basadas en la interacción del usuario u otros factores, ese widget es *stateful*. Por ejemplo, si un widget tiene un contador que se incrementa cada vez que el usuario pulsa un botón, el valor del contador es el estado de ese widget. Cuando ese valor cambia, el widget necesita ser reconstruido para actualizar la UI.

Estos widgets heredan de [StatefulWidget](https://docs.flutter.io/flutter/widgets/StatefulWidget-class.html)
(en lugar de [StatelessWidget](https://docs.flutter.io/flutter/widgets/StatelessWidget-class.html))
y almacenan su estado mutable en una subclase de [State](https://docs.flutter.io/flutter/widgets/State-class.html).

<object type="image/svg+xml" data="/images/whatisflutter/diagram-state.svg" style="width: 85%; height: 85%"></object>

Cada vez que se muta un objeto State (p.ej., incrementando el contador), debes llamar a
[setState](https://docs.flutter.io/flutter/widgets/State/setState.html)() para indicar al framework que actualice la interfaz de usuario llamando al método build de State 
de nuevo. Para ver un ejemplo de la gestión del estado, consulta el [template MyApp](https://github.com/flutter/flutter/blob/master/packages/flutter_tools/templates/create/lib/main.dart.tmpl) que es creado con cada nuevo proyecto de Flutter.

El hecho de tener objetos state y widget separados permite que otros widgets traten de la misma manera a los widgets stateless y stateful, sin preocuparse por perder estado.
En lugar de tener que aferrarse a un hijo para preservar su estado, el padre es libre de crear una nueva instancia del hijo sin perder el estado persistente del mismo. El framework hace todo el trabajo de encontrar y reutilizar los objetos de estado existentes cuando sea apropiado.

## ¡Inténtalo!

Ahora que estás familiarizado con la estructura básica y los principios del framework de Flutter, junto con la manera de crear aplicaciones y hacerlas interactivas, estás listo para empezar a desarrollarlas e iterarlas.

Próximos pasos:

1.  [Sigue la Guía de Inicio de Flutter](/get-started/).
1.  Prueba con el [Tutorial - Construyendo layouts](/tutorials/layout/) y con el 
    [Tutorial - Agregando interactividad](/tutorials/interactive/).
1.  Sigue un ejemplo detallado en [Un Recorrido por el Framework de Widgets Flutter](/widgets-intro/).

## Obtén apoyo

Sigue el proyecto Flutter y únete a la conversación de varias maneras.
Somos de código abierto y nos encantaría saber de ti.

- [Haz preguntas sobre "Como Hacer" que puedan ser respondidas con una solución especifica][so]
- [Chat en vivo con ingenieros y usuarios de Flutter][gitter]
- [Discusión sobre Flutter, mejores prácticas, diseño de aplicaciones y más en nuestra lista de correo][mailinglist]
- [Notificar fallos, solicitar funcionalidades y documentos][issues]
- [Síguenos en Twitter: @flutterio](https://twitter.com/flutterio/)
- [Inscríbete en futuros estudios de UX sobre Flutter](/research-signup)
- [Únete al subreddit para estar al día con lo último en la comunidad de Flutter][reddit]


[issues]: https://github.com/flutter/flutter/issues
[apidocs]: https://docs.flutter.io
[so]: https://stackoverflow.com/tags/flutter
[mailinglist]: https://groups.google.com/d/forum/flutter-dev
[gitter]: https://gitter.im/flutter/flutter
[reddit]: https://www.reddit.com/r/FlutterDev/
