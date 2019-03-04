---
title: Introducción a la UI declarativa
short-title: Declarative UI
description: Explica la diferencia entre un estilo de programación declarativo e imperativo.
---

_Esta introducción describe la diferencia conceptual entre el estilo declarativo usado por Flutter, y el estilo imperativo usado por muchos otros frameworks de UI._

## Por qué una UI declarative?

Los frameworks desde Win32 hasta web, pasando por Android e iOS suelen utilizar un estilo imperativo de programación de interfaz de usuario. Este puede ser el estilo con el que estés más familiarizado, en el que construyes manualmente una entidad de interfaz de usuario con todas sus funciones, como una UIView o equivalente, y luego la transformas usando métodos y configuradores cuando cambia la interfaz de usuario.

Para aligerar la carga sobre los desarrolladores de tener que programar cómo hacer la transición entre varios estados de la interfaz de usuario, Flutter, en contraste, permite que el desarrollador describa el estado actual de la interfaz de usuario y deja la transición al framework.

Esto, sin embargo, requiere un ligero cambio en la forma de pensar para manipular la interfaz de usuario.

## Cómo cambiar la UI en un framework declarativo

Considere un ejemplo simplificado a continuación:

<img src="/images/declarativeUIchanges.png" alt="View B (contained by view A) morphs from containing two views, c1 and c2, to containing only view c3">

En el estilo imperativo, normalmente irás al propietario de ViewB
y recuperar la instancia `b` usando selectores o con `findViewById` o similar,
e invocar mutaciones en ella (e implícitamente invalidarla). Por ejemplo:

```java
// Imperative style
b.setColor(red)
b.clearChildren()
ViewC c3 = new ViewC(...)
b.add(c3)
```

También puedes necesitar replicar esta configuración en el constructor de ViewB ya que la fuente de verdad para la interfaz de usuario puede sobrevivir a la propia instancia `b`.

En el estilo declarativo, las configuraciones de vista (como los Widgets de Flutter) son inmutables y sólo son "blueprints" ligeros. Para cambiar la interfaz de usuario, un Widget activará una reconstrucción sobre sí mismo (más comúnmente llamando a `setState()`
en StatefulWidgets en Flutter) y construirá un nuevo subárbol de Widgets.

<!-- skip -->
```dart
// Declarative style
return ViewB(
  color: red,
  child: ViewC(...),
)
```

Aquí, en lugar de mutar una vieja instancia `b` cuando la interfaz de usuario cambia, Flutter construye nuevas instancias de Widgets. El framework gestiona muchas de las responsabilidades de un objeto de interfaz de usuario tradicional (como mantener el estado del diseño) entre bastidores con RenderObjects. 
Los RenderObjects persisten entre frames y los Widgets ligeros de Flutter le dicen al framework que mute los RenderObjects entre estados. El framework de Flutter se encarga del resto.
