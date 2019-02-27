---
title: Taps, drags, y otros gestos en Flutter.
---

Este documento explica cómo escuchar y responder a
_gestos_ en Flutter. Ejemplos de gestos incluyen
taps, drags y scalling.

El sistema de gestos en Flutter tiene dos capas separadas. La primera capa tiene eventos 
de puntero en crudo, que describen la ubicación y el movimiento de los punteros (por ejemplo,
taps, mice, styli) en la pantalla. La segunda capa tiene _gestos_,
que describen acciones semánticas que consisten en uno o más movimientos de puntero.

## Punteros

Los punteros representan datos en bruto de la interacción del usuario con la pantalla del dispositivo. 
Existen cuatro tipos de eventos de punteros:

- [`PointerDownEvent`](https://docs.flutter.io/flutter/gestures/PointerDownEvent-class.html)
  El puntero ha contactado con una ubicación determinada de la pantalla. 
- [`PointerMoveEvent`](https://docs.flutter.io/flutter/gestures/PointerMoveEvent-class.html)
  El puntero se ha movido de una ubicación de la pantalla a otra.
- [`PointerUpEvent`](https://docs.flutter.io/flutter/gestures/PointerUpEvent-class.html)
  El puntero ha dejado  de hacer contacto con la pantalla.
- [`PointerCancelEvent`](https://docs.flutter.io/flutter/gestures/PointerCancelEvent-class.html)
  La acción de ese puntero ya no está dirigida hacia esta aplicación.

En el evento pointer down, el framework hace un _hit test_ en tu app para determinar que 
widget existe en la ubicación donde el puntero entró en contacto con la pantalla. 
El evento pointer down (y los eventos posteriores para ese puntero) se envían luego al widget 
más interno encontrado por el hit test.A partir de ahí, los eventos emergen en el árbol y 
son enviados a todos los widgets en el camino desde el widget más interno a la raíz del árbol. 
No hay ningún mecanismo para cancelar o detener los eventos de punteros de 
ser enviados más allá.

Para escuchar eventos de puntero directamente desde la capa de widgets, 
use un widget [`Listener`](https://docs.flutter.io/flutter/widgets/Listener-class.html)
widget. Sin embargo, en general, considere usar gestos en su lugar 
(como se discute a continuación).

## Gestos

Los gestos representan acciones semánticas (por ejemplo, tap, drag, y scale) que son
reconocido desde múltiples eventos de puntero individuales, potencialmente incluso múltiples
punteros individuales. Los gestos pueden despachar múltiples eventos, correspondientes al
ciclo de vida del gesto (por ejemplo, drag start, drag update, y drag end):

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

Si está utilizando Material Components, muchos de esos widgets ya responden
A los taps o gestos.
Por ejemplo,
[IconButton](https://docs.flutter.io/flutter/material/IconButton-class.html) y
[FlatButton](https://docs.flutter.io/flutter/material/FlatButton-class.html)
responde a (taps), y
[`ListView`](https://docs.flutter.io/flutter/widgets/ListView-class.html)
responde a los swipes para activar el desplazamiento.
Si no está utilizando esos widgets, pero desea que el efecto de "salpicadura de tinta" en un
tap, puedes usar
[`InkWell`](https://docs.flutter.io/flutter/material/InkWell-class.html).

### Desambiguación de gestos

En una ubicación determinada en la pantalla, puede haber varios detectores de gestos. Todos
de estos detectores de gestos escuchan el flujo de eventos de puntero a medida que fluyen
Pasado e intento de reconocer gestos específicos. los
[`GestureDetector`](https://docs.flutter.io/flutter/widgets/GestureDetector-class.html)
widget decide qué gestos intentar reconocer en función de cuál de sus
Las devoluciones de llamada no son nulas.

Cuando hay más de un reconocedor de gestos para un puntero dado en la pantalla, 
el framework desambigua qué gesto pretende el usuario haciendo que cada 
reconocedor se una a la _arena de gestos_. La arena de gestos 
determina qué gesto gana usando las siguientes reglas:

- En cualquier momento, un reconocedor puede declarar la derrota y abandonar la arena. Si hay
  solo queda un reconocedor en la arena, ese reconocedor es el ganador.

- En cualquier momento, un reconocedor puede declarar la victoria, lo que hace que gane y todo
  Los restantes reconocedores a perder.

Por ejemplo, cuando se desambigua el arrastre horizontal y vertical, ambos 
reconocedores entran en la arena cuando reciben el evento pointer down. 
Los reconocedores observan los eventos de movimiento del puntero. Si el usuario mueve 
el puntero más de un cierto número de píxeles lógicos horizontalmente, 
el reconocedor horizontal declarará la victoria y el gesto se interpretará 
como un arrastre horizontal. De forma similar, si el usuario mueve más de un 
cierto número de píxeles lógicos verticalmente, el reconocedor vertical declarará la victoria.

La arena de gestos es beneficiosa cuando solo hay un reconocedor de arrastre horizontal (o vertical). 
En ese caso, habrá solo un reconocedor en la arena y la resistencia horizontal será 
reconocida inmediatamente,lo que significa que el primer píxel del movimiento 
horizontal se puede tratar como un arrastre y el usuario no tendrá que esperar 
una desambiguación adicional del gesto.
