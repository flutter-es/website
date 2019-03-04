---
title: Empieza a pensar de forma declarativa
prev:
  title: Introducción
  path: /docs/development/data-and-backend/state-mgmt
next:
  title: Estado efímero versus estado de aplicación
  path: /docs/development/data-and-backend/state-mgmt/ephemeral-vs-app
---

Si vienes a Flutter desde un framework imperativo (como Android SDK o iOS UIKit), debes empezar a pensar en el desarrollo de aplicaciones a partir de una nueva perspectiva. 

Muchas de las suposiciones que puedes tener no se aplican a Flutter. Por ejemplo, en Flutter, está bien reconstruir partes de su interfaz de usuario desde cero en lugar de modificarlas. Flutter es lo suficientemente rápido para hacerlo, incluso en cada cuadro si es necesario.

Flutter es _declarativo_. Esto significa que Flutter construye su interfaz de usuario para reflejar el estado actual de su aplicación:

{% asset development/data-and-backend/state-mgmt/ui-equals-function-of-state alt="A mathematical formula of UI = f(state). 'UI' is the layout on the screen. 'f' is your build methods. 'state' is the application state." %}

{% comment %}
Source drawing for the png above: : https://docs.google.com/drawings/d/1RDcR5LyFtzhpmiT5-UupXBeos2Ban5cUTU0-JujS3Os/edit?usp=sharing
{% endcomment %}

Cuando el estado de tu aplicación cambia (por ejemplo, el usuario acciona un switch en la ventana de control de la aplicación), se modifica el estado y esto desencadena una nueva configuración de la interfaz de usuario. No hay ningún cambio imperativo de la propia interfaz de usuario (como por ejemplo `widget.setText`) - cambias el estado, y la interfaz de usuario se reconstruye desde cero.

Leé más sobre el enfoque declarativo de la programación de la interfaz de usuario [en la guía de inicio (/docs/get-started/flutter-for/declarative). 

El estilo declarativo de la programación de la interfaz de usuario tiene muchos beneficios. Sorprendentemente, hay sólo una ruta de código para cualquier estado de la interfaz de usuario. Describe lo que la interfaz de usuario debería ser para cualquier estado dado, una vez - y eso es todo.

Al principio, este estilo de programación puede no parecer tan intuitivo como el imperativo estilo. Esta es la razón por la que esta sección está aquí. Sigue leyendo.
