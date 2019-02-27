---
title: Grifos, arrastres, y otros gestos.
---

Este documento explica cómo escuchar y responder a
_gestos_ en Flutter. Ejemplos de gestos incluyen
grifos, arrastres, y escalado.

El sistema de gestos en Flutter tiene dos capas separadas. La primera capa tiene crudo
eventos de puntero, que describen la ubicación y el movimiento de los punteros (por ejemplo,
toques, ratones y estiletes en la pantalla. La segunda capa tiene _gesturas_,
que describen acciones semánticas que consisten en uno o más movimientos de puntero.

## Punteros

Los punteros representan datos en bruto sobre la interacción del usuario con el dispositivo
pantalla. Hay cuatro tipos de eventos de puntero:

- [`PointerDownEvent`](https://docs.flutter.io/flutter/gestures/PointerDownEvent-class.html)
  El puntero ha contactado con la pantalla en una ubicación particular.
- [`PointerMoveEvent`](https://docs.flutter.io/flutter/gestures/PointerMoveEvent-class.html)
  El puntero se ha movido de una ubicación en la pantalla a otra.
- [`PointerUpEvent`](https://docs.flutter.io/flutter/gestures/PointerUpEvent-class.html)
  El puntero ha dejado de entrar en contacto con la pantalla.
- [`PointerCancelEvent`](https://docs.flutter.io/flutter/gestures/PointerCancelEvent-class.html)
  La entrada de este puntero ya no se dirige hacia esta aplicación.

En el puntero hacia abajo, el marco hace un _hit test_ en su aplicación para determinar cuál
El widget existe en la ubicación donde el puntero entró en contacto con la pantalla. los
el evento de puntero hacia abajo (y los eventos subsiguientes para ese puntero) se distribuyen
al widget más interno encontrado por la prueba de éxito. A partir de ahí, los eventos burbujean.
El árbol y se envían a todos los widgets en el camino desde el interior
Widget a la raíz del árbol. No hay ningún mecanismo para cancelar o detener
Los eventos de puntero se envían más lejos.

Para escuchar los eventos de puntero directamente desde la capa de widgets, use un
[`Observadores`](https://docs.flutter.io/flutter/widgets/Listener-class.html)
widget Sin embargo, en general, considere usar gestos (como se discutió
abajo) en su lugar.

## Gestos

Los gestos representan acciones semánticas (por ejemplo, toque, arrastre y escala) que son
reconocido desde múltiples eventos de puntero individuales, potencialmente incluso múltiples
punteros individuales. Los gestos pueden despachar múltiples eventos, correspondientes a la
ciclo de vida del gesto (por ejemplo, arrastrar inicio, arrastrar actualización y arrastrar final):

- Tap
  - `onTapDown` Un puntero que podría causar un toque ha contactado con la pantalla en un
    Ubicación particular.
  - `onTapUp` Un puntero que activará un toque ha dejado de entrar en contacto con la pantalla.
    en un lugar particular.
  - `onTap` Se ha producido un toque.
  - `onTapCancel` El puntero que activó previamente el `onTapDown` no
    Terminar causando un toque.
- Double tap
  - `onDoubleTap` El usuario ha tocado la pantalla en la misma ubicación dos veces en
    sucesión rápida
- Long press
  - `onLongPress` Un puntero ha permanecido en contacto con la pantalla al mismo tiempo.
    Ubicación durante un largo período de tiempo.
- Vertical drag
  - `onVerticalDragStart` Un puntero ha contactado con la pantalla y puede comenzar a
    mover verticalmente
  - `onVerticalDragUpdate` Un puntero que está en contacto con la pantalla y
    El movimiento vertical se ha movido en la dirección vertical.
  - `onVerticalDragEnd` Un puntero que previamente estaba en contacto con la pantalla.
    y el movimiento vertical ya no está en contacto con la pantalla y se movía
    a una velocidad específica cuando dejó de tocar la pantalla.
- Horizontal drag
  - `onHorizontalDragStart` Un puntero ha contactado con la pantalla y puede comenzar a
    mover horizontalmente
  - `onHorizontalDragUpdate` Un puntero que está en contacto con la pantalla y
    El movimiento horizontal se ha movido en la dirección horizontal.
  - `onHorizontalDragEnd` Un puntero que previamente estaba en contacto con el
    Pantalla y movimiento horizontal ya no está en contacto con la pantalla y
    se movía a una velocidad específica cuando dejó de tocar la pantalla.
- Pan
  - `onPanStart` Un puntero ha contactado con la pantalla y podría comenzar a moverse.
    horizontal o verticalmente Esta devolución de llamada provoca un bloqueo si 
    `onHorizontalDragStart` o `onVerticalDragStart` Está establecido.
  - `onPanUpdate`Un puntero que está en contacto con la pantalla y se está moviendo.
    En la dirección vertical u horizontal. Esta devolución de llamada provoca un bloqueo si
    Se establece `onHorizontalDragUpdate` o `onVerticalDragUpdate`.
  - `onPanEnd` Un puntero que previamente estaba en contacto con la pantalla.
    ya no está en contacto con la pantalla y se está moviendo a una velocidad específica
    Cuando se detuvo el contacto con la pantalla. Esta devolución de llamada provoca un bloqueo si
    Se establece `onHorizontalDragEnd` o `onVerticalDragEnd`.

Para escuchar gestos desde la capa de widgets, use un
[`GestureDetector`](https://docs.flutter.io/flutter/widgets/GestureDetector-class.html).

Si está utilizando componentes materiales, muchos de esos widgets ya responden
A los grifos o gestos.
Por ejemplo,
[IconButton](https://docs.flutter.io/flutter/material/IconButton-class.html) and
[FlatButton](https://docs.flutter.io/flutter/material/FlatButton-class.html)
responde a (taps), y
[`ListView`](https://docs.flutter.io/flutter/widgets/ListView-class.html)
responde a los golpes para activar el desplazamiento.
Si no está utilizando esos widgets, pero desea que el efecto de "salpicadura de tinta" en un
toque, puedes usar
[`InkWell`](https://docs.flutter.io/flutter/material/InkWell-class.html).

### Desambiguación de gestos

En una ubicación determinada en la pantalla, puede haber varios detectores de gestos. Todos
de estos detectores de gestos escuchan el flujo de eventos de puntero a medida que fluyen
Pasado e intento de reconocer gestos específicos. los
[`GestureDetector`](https://docs.flutter.io/flutter/widgets/GestureDetector-class.html)
widget decide qué gestos intentar reconocer en función de cuál de sus
Las devoluciones de llamada no son nulas.

Cuando hay más de un reconocedor de gestos para un puntero dado en el
En la pantalla, el marco desmarca qué gesto pretende el usuario al tener
Cada reconocedor se unirá a la _gestura arena_. La arena gestual determina cuál
El gesto gana usando las siguientes reglas:

- En cualquier momento, un reconocedor puede declarar la derrota y abandonar la arena. Si hay
  solo queda un reconocedor en la arena, ese reconocedor es el ganador.

- En cualquier momento, un reconocedor puede declarar la victoria, lo que hace que gane y todo
  Los restantes reconocedores a perder.

Por ejemplo, al desambiguar el arrastre horizontal y vertical, ambos
los reconocedores entran en la arena cuando reciben el evento puntero hacia abajo. los
Los reconocedores observan los eventos de movimiento del puntero. Si el usuario mueve más el puntero.
que un cierto número de píxeles lógicos horizontalmente, el reconocedor horizontal
Declarará la victoria y el gesto se interpretará como un arrastre horizontal.
Del mismo modo, si el usuario mueve más de un cierto número de píxeles lógicos
Verticalmente, el reconocedor vertical declarará la victoria.

El campo de gestos es beneficioso cuando solo hay una horizontal (o vertical)
reconocedor de arrastre. En ese caso, solo habrá un reconocedor en la arena.
y el arrastre horizontal se reconocerá inmediatamente, lo que significa el primer
El píxel del movimiento horizontal puede tratarse como un arrastre y el usuario no lo necesitará.
Para esperar más desambiguación gesto.
