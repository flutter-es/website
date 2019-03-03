---
title: Documentación de Flutter
short-title: Docs
description: La landing page para la documentación de Flutter.
---

<div class="card-deck">
{% for card in site.data.docs_cards -%}
  <a class="card" href="{{card.url}}">
    <div class="card-body">
      <header class="card-title">{{card.name}}</header>
      <p class="card-text">{{card.description}}</p>
    </div>
  </a>
{% endfor -%}
</div>

## Que hay de nuevo en este sitio

**26 de Febrero, 2019 **

Flutter lanzó la [version
1.2](https://developers.googleblog.com/2019/02/launching-flutter-12-at-mobile-world.html)
en el Mobile World Congress (MWC) en Barcelona!

Además, aquí hay algunos documentos nuevos recientes:

* Hemos actualizado nuestros consejos de gestión de estado. Las nuevas páginas incluyen
  [introducción](/docs/development/data-and-backend/state-mgmt/intro),
  [pensamiento declarativo](/docs/development/data-and-backend/state-mgmt/declarative), 
  [efímero vs. estado de la aplicación](/docs/development/data-and-backend/state-mgmt/ephemeral-vs-app),
  [gestión sencilla del estado de la aplicación](/docs/development/data-and-backend/state-mgmt/simple),
  y [diferentes opciones de gestión del estado](/docs/development/data-and-backend/state-mgmt/options).
  La documentación de la gestión de estado es algo complicado, ya que no existe un enfoque único para todos los casos. !Nos encantaría conocer tu opinión sobre estos nuevos documentos!
* Una nueva página sobre [las mejores prácticas de desempeño](/docs/testing/best-practices).
* También en el MWC, anunciamos una versión preliminar de las nuevas 
  DevTools de Dart para profiling y debugging de las aplicaciones de Dart y Flutter. Puedes encontrar los documentos en el 
  [Wiki DevTools](https://flutter.github.io/devtools/).
  En particular, comprueba el [inspector de widgets Flutter]
  (https://flutter.github.io/devtools/inspector) de DevTool para depurar
  tu interfaz de usuario, o la [vista de la línea de tiempo]
  (https://flutter.github.io/devtools/timeline) para perfilar tu aplicación Flutter. !Pruébalos y dinos lo que piensas!
* Una actualización de la [página de perfiles de desempeño](/docs/testing/ui-performance)
  que incorpora la nueva interfaz de usuario de Dart DevTools.
* Actualizaciones a las páginas de [Android
  Studio/IntelliJ](/docs/development/tools/android-studio)
  y [VS Code](/docs/development/tools/vs-code) que incorporan información de la nueva interfaz de usuario de Dart DevTools.
Si tienes preguntas o comentarios sobre cualquiera de estos documentos, [presenta un
issue]({{site.repo.this}}/issues).

[¿Qué hay de nuevo? Archivo](/docs/whats-new-archive)

## ¿Nuevo en Flutter?

Cuando ya has pasado por [Empezar](/docs/get-started/install),
incluyendo [Escribe tu Primera App Flutter,](/docs/get-started/codelab)
aquí hay algunos nuevos pasos.

[Flutter para desarrolladores Android](/docs/get-started/flutter-for/android-devs)
: Revisa estos consejos si tienes experiencia en Android.

[Flutter para desarrolladores iOS](/docs/get-started/flutter-for/ios-devs)
: Revsa estos consejos si tienes experiencia en iOS.

[Flutter para desarrolladores Web](/docs/get-started/flutter-for/web-devs)
: Revisa estas analogías HTML -> Flutter si tienes experiencia en web.

[Flutter para desarrolladores React Native](/docs/get-started/flutter-for/react-native-devs)
: Revisa estos consejos si tienes experiencia en React Native.

[Flutter para desarrolladores Xamarin.Forms](/docs/get-started/flutter-for/xamarin-forms-devs)
: Revisa estos consejos si tienes experiencia con Xamarin Forms.

[Construyes layouts en Flutter](/docs/development/ui/layout)
: Aprende como crear layouts en Flutter, donde todo es un widget.

[Añade interactividad a tu app Flutter](/docs/development/ui/interactive)
: Aprende como añadir un widget stateful a tu app.

[Un tour por el framework de widgets de Flutter](/docs/development/ui/widgets-intro)
: Aprende más sobre el framework estilo-reactivo de Flutter.

[FAQ](/docs/resources/faq)
: Obtén las respuestas a las preguntas más frecuentes.


## ¿Buscas mejorar tus conocimientos?

Una vez domines lo básico, prueba estas páginas.

[Cookbook](/docs/cookbook)
: Una (creciente) colección de recetas que cubren los casos de uso común en Flutter.

[Apps de ejemplo en GitHub]({{site.github}}/flutter/samples/blob/master/INDEX.md)
: Una (creciente) colección de apps de ejemplo que muestra las mejores prácticas en  Flutter.

[Añadir assets e imágenes en Flutter](/docs/development/ui/assets-and-images)
: Como añadir recursos a tu app Flutter.

[Animaciones en Flutter](/docs/development/ui/animations)
: Como crear animaciones estándar, hero o escalonadas, por nombrar algunos de los 
estilos de animación que soporta Flutter.

[Navegación y rutas](/docs/development/ui/navigation)
: Como crear y navegar a una pantalla nueva (lamada _ruta_ en Flutter).

[Internacionalización](/docs/development/accessibility-and-localization/internationalization)
: ¡Sé global! Como internacionalizar tu app Flutter.

[Dart Efectivo]({{site.dart-site}}/guides/language/effective-dart)
: Guía sobre escribir mejor código Dart.

## Temas especializados

Sumérgete más profundamente en temas de tu interés.

[Flutter Widget inspector](/docs/development/tools/inspector)
: Como usar el widget inspector, una poderosa herramienta que te permite
  explorar el árbol de widgets, desacrivar el banner
  "DEBUG", mostrar la capa supuerpuesta de rendimiento, y mucho más.

[Fuentes personalizadas](/docs/cookbook/design/fonts)
: Como añadir nuevas fuentes a tu app.

[Entrada de texto](/docs/cookbook/forms/text-input)
: Como configurar una entrada de texto básica.

[Depurar aplicaciones Flutter](/docs/testing/debugging)
: Herramientas y consejos para depurar tu app.

Esta no es una lista completa. Por favor usa la navigación izquierda,
o el campo de buesqueda para encontrar otros temas.
