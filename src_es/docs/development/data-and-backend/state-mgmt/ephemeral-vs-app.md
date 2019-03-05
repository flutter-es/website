---
title: Diferencia entre estado efímero y estado de app
prev:
  title: Empieza a pensar de forma declarativa
  path: /docs/development/data-and-backend/state-mgmt/declarative
next:
  title: Gestión de estado sencilla
  path: /docs/development/data-and-backend/state-mgmt/simple
---

Este documento presenta el estado de la aplicación, el estado efímero y cómo se puede manejar cada uno en una aplicación Flutter.

En el sentido más amplio posible, el estado de una aplicación es todo lo que existe en la memoria cuando la aplicación está en ejecución. Esto incluye los activos de la aplicación, todas las variables que el framework Flutter mantiene sobre la interfaz de usuario, el estado de la animación, las texturas, las fuentes, etc. Aunque esta definición lo más amplia posible de estado es válida, no es muy útil para la arquitectura de una aplicación.

En primer lugar, ni siquiera se puede manejar algún estado (como las texturas). El framework se encarga de ello por usted. Así que una definición más útil del estado es "cualquier dato que necesite para reconstruir tu interfaz de usuario en cualquier momento". En segundo lugar, el estado que _de verdad_ manejas puede ser separado en dos tipos conceptuales: estado efímero y estado de aplicación. 

## Estado efímero

El estado efímero (a veces llamado estado _UI_ o estado _local_) es el estado que puede contener claramente en un único widget.

Esta es, intencionalmente, una definición vaga, así que aquí hay algunos ejemplos. 

* página actual en un `PageView`
* progreso actual de una animación compleja
* tab seleccionada en un `BottomNavigationBar`

Otras partes del árbol de widgets rara vez necesitan acceder a este tipo de estado. No hay necesidad de serializarlo, y no cambia de manera compleja.

En otras palabras, no es necesario utilizar técnicas de gestión de estado ("ScopedModel", "Redux", etc.) en este tipo de estados. Todo lo que necesitas es un "StatefulWidget".

Abajo, puedes ver cómo el elemento actualmente seleccionado en una barra de navegación inferior se mantiene en el campo `_índice` de la clase `_MyHomepageState`. En este ejemplo, `_índice` es un estado efímero.

<?code-excerpt "state_mgmt/simple/lib/src/set_state.dart (Ephemeral)" plaster="// ... items ..."?>
```dart
class MyHomepage extends StatefulWidget {
  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: (newIndex) {
        setState(() {
          _index = newIndex;
        });
      },
      // ... items ...
    );
  }
}
```

Aquí, usar `setState()` y un campo dentro de la clase StatefulWidget es completamente natural. Ninguna otra parte de tu aplicación necesita acceder a `_index`. La variable sólo cambia dentro del widget 
`MyHomePage`. Y, si el usuario cierra y reinicia la aplicación, no te importa que el `_índice` se restablezca a cero.

## Estado de la app

Estado que no es efímero, que quieres compartir en muchas partes de tu aplicación, y que quieres mantener entre sesiones de usuario - es lo que llamamos estado de la aplicación (a veces también llamado estado compartido).

Ejemplos de estados de aplicación:

* Preferencias del usuario
* Información de inicio de sesión
* Notificaciones en una aplicación de redes sociales
* El carrito de compras en una aplicación de comercio electrónico
* Estado de los artículos leídos/no leídos en una aplicación de noticias

Para administrar el estado de las aplicaciones, deberá investigar sus opciones. Su elección depende de la complejidad y naturaleza de tu aplicación, de la experiencia previa de tu equipo y de muchos otros aspectos. Sigue leyendo.

## No hay una regla clara

Para ser claro, puedes usar `State` y `setState()` para administrar todo el estado de tu aplicación. De hecho, el equipo de Flutter hace esto en muchos ejemplos de aplicaciones simples (incluyendo la aplicación de inicio que se obtiene con cada `creacion de flutter`).

También va para el otro lado. Por ejemplo, puede decidir que - en el contexto de tu aplicación en particular - la pestaña seleccionada en una barra de navegación inferior _no_ es estado efímero. Es posible que tenga que cambiarlo desde fuera de la clase, mantenerlo entre sesiones, y así sucesivamente. En ese caso, la variable `_index` es app state.

No existe una regla clara y universal para distinguir si una variable en particular es efímera o es estado de aplicación. A veces, tendrás que refactorizar uno en otro. Por ejemplo, comenzará con un estado claramente efímero, pero a medida que tu aplicación crezca en características, tendrá que ser movida al estado de aplicación.

Por esa razón, toma el siguiente diagrama con un gran grano de sal (con el entendimiento de que exista la probabilidad de que algo sea falso o incorrecto):

{% asset development/data-and-backend/state-mgmt/ephemeral-vs-app-state alt="A flow chart. Start with 'Data'. 'Who needs it?'. Three options: 'Most widgets', 'Some widgets' and 'Single widget'. The first two options both lead to 'App state'. The 'Single widget' option leads to 'Ephemeral state'." %}

{% comment %}
Source drawing for the png above: : https://docs.google.com/drawings/d/1p5Bvuagin9DZH8bNrpGfpQQvKwLartYhIvD0WKGa64k/edit?usp=sharing
{% endcomment %}

Cuando se le preguntó sobre el setState de React vs la store de Redux, el autor de Redux, Dan Abramov, respondió:

> "La regla general es: [Hacer lo que sea menos 
> torpe]({{site.github}}/reduxjs/redux/issues/1287#issuecomment-175351978)."

En resumen, hay dos tipos conceptuales de estado en cualquier aplicación Flutter. El estado efímero puede ser implementado usando `State` y `setState()`, y a menudo es local a un solo widget. El resto es el estado de la aplicación. Ambos tipos tienen su lugar en cualquier aplicación Flutter, y la división entre los dos depende de tu propia preferencia y de la complejidad de la aplicación.
