---
layout: page
title: "Animaciones: Descripción Técnica"
permalink: /animations/overview.html
---

* TOC Placeholder
{:toc}

El sistema de animación de Flutter se basa en objetos del tipo [`Animation`](https://docs.flutter.io/flutter/animation/Animation-class.html).
Los widgets pueden incorporar estas animaciones en sus funciones build directamente leyendo su valor actual y escuchando sus cambios de estado o pueden usar las animaciones como base de animaciones más elaboradas que transmiten a otros widgets.

## Animation

El componente principal del sistema de animación es la clase
[`Animation`](https://docs.flutter.io/flutter/animation/Animation-class.html). Una animación representa un valor de un tipo específico que puede cambiar durante la duración de la animación. La mayoría de los widgets que ejecutan una animación reciben un objeto `Animation` como parámetro, desde el que leen el valor actual de la animación y al que escuchan para ver si hay cambios de ese valor.

### `addListener`

Cada vez que el valor de la animación cambia, la animación notifica a todos los oyentes añadidos con
[`addListener`](https://docs.flutter.io/flutter/animation/Animation/addListener.html).
Normalmente, un objeto [`State`](https://docs.flutter.io/flutter/widgets/State-class.html) que escucha a una animación llamará a [`setState`](https://docs.flutter.io/flutter/widgets/State/setState.html) sobre si mismo en su callback de escucha para notificar al sistema de widgets que necesita reconstruir con el nuevo valor de la animación.

Este patrón es tan común que hay dos widgets que ayudan a reconstruir los widgets cuando las animaciones cambian de valor: [`AnimatedWidget`](https://docs.flutter.io/flutter/widgets/AnimatedWidget-class.html)
y [`AnimatedBuilder`](https://docs.flutter.io/flutter/widgets/AnimatedBuilder-class.html).
El primero, `AnimatedWidget`, es muy útil para los widgets animados sin estado.
Para usar `AnimatedWidget`, simplemente subclasifíquelo e implemente la función [`build`](https://docs.flutter.io/flutter/widgets/AnimatedWidget/build.html).
El segundo, `AnimatedBuilder`, es útil para widgets más complejos que desean incluir una animación como parte de una función de construcción más grande. Para utilizar `AnimatedBuilder`, simplemente construya el widget y pase una función `Builder`.

### `addStatusListener`


Las animaciones también proporcionan un [`AnimationStatus`](https://docs.flutter.io/flutter/animation/AnimationStatus-class.html), que indica cómo evolucionará la animación a lo largo del tiempo. Cada vez que el estado de la animación cambia, la animación notifica a todos los oyentes añadidos con [`addStatusListener`](https://docs.flutter.io/flutter/animation/Animation/addStatusListener.html). Normalmente, las animaciones empiezan en el estado de `dismissed`, lo que significa que están al principio de su rango. Por ejemplo, las animaciones que progresan de 0.0 a 1.0 serán `dismissed` cuando su valor sea 0.0. Una animación podría entonces ejecutarse `forward` (ej., 0.0 a 1.0) o quizás en `reverse` (ej., de 1.0 a 0.0). Eventualmente, si la animación alcanza el final de su rango (por ejemplo 1.0), la animación alcanza el estado `completed`.

## AnimationController

Para crear una animación, primero cree un [`AnimationController`](https://docs.flutter.io/flutter/animation/AnimationController-class.html). Además de ser una animación en sí misma, un `AnimationController` te permite controlar la animación. Por ejemplo, puede decirle al controlador que reproduzca la animación [`forward`](https://docs.flutter.io/flutter/animation/AnimationController/forward.html) o [`detener`](https://docs.flutter.io/flutter/animation/AnimationController/stop.html) la animación. También puede [`lanzar`](https://docs.flutter.io/flutter/animation/AnimationController/fling.html) animaciones, que utilizan una simulación física, como un resorte, para dirigir la animación.

Una vez que haya creado un controlador de animación, puede empezar a crear otras animaciones basadas en él. Por ejemplo, se puede crear un
[`ReverseAnimation`](https://docs.flutter.io/flutter/animation/ReverseAnimation-class.html)
que refleja la animación original pero corre en la dirección opuesta (ej., de 1.0 a 0.0). Del mismo modo, se puede crear una
[`CurvedAnimation`](https://docs.flutter.io/flutter/animation/CurvedAnimation-class.html)
cuyo valor se ajusta mediante una [`curva`](https://docs.flutter.io/flutter/animation/Curves-class.html).

## Tweens

Para animar más allá del intervalo de 0.0 a 1.0 , puede utilizar un [`Tween<T>`](https://docs.flutter.io/flutter/animation/Tween-class.html), que interpola entre su valor [`inicial`](https://docs.flutter.io/flutter/animation/Tween/begin.html) y [`final`](https://docs.flutter.io/flutter/animation/Tween/end.html). Muchos tipos tienen subclases `Tween` específicas que proporcionan interpolación específica del tipo. Por ejemplo, [`ColorTween`](https://docs.flutter.io/flutter/animation/ColorTween-class.html) interpola entre colores y [`RectTween`](https://docs.flutter.io/flutter/animation/RectTween-class.html) interpola entre rectas. Puedes definir tus propias interpolaciones creando tu propia subclase de `Tween` y anulando la función [`lerp`](https://docs.flutter.io/flutter/animation/Tween/lerp.html).

Por sí mismo, una Tween sólo define cómo interpolar entre dos valores. Para obtener un valor concreto para el frame actual de una animación, también necesita una animación para determinar el estado actual. Hay dos maneras de combinar un Tween con una animación para obtener un valor concreto:

1. Puedes [`evaluar`](https://docs.flutter.io/flutter/animation/Tween/evaluate.html)
el Tween en el valor actual de una animación. Este enfoque es muy útil para los widgets que ya están escuchando la animación y por lo tanto reconstruyendo cada vez que la animación cambia de valor.

2. Puedes [`animar`](https://docs.flutter.io/flutter/animation/Animatable/animate.html)
   el tween basado en la animación. En lugar de devolver un único valor, la función animada devuelve una nueva `Animación` que incorpora el tween. Este enfoque es más útil cuando se desea dar la animación recién creada a otro widget, que puede leer el valor actual que incorpora el tween así como escuchar los cambios en el valor.

# Arquitectura

Las animaciones se construyen a partir de una serie de elementos básicos.

## Scheduler

El
[`SchedulerBinding`](https://docs.flutter.io/flutter/scheduler/SchedulerBinding-class.html)
es una clase singleton que expone los primitivos de programación de Flutter.

Para esta discusión, la clave primitiva son los frame callbacks. Cada vez que es necesario mostrar un cuadro en la pantalla, el motor de Flutter activa una llamada de retorno de "cuadro inicial" que el programador multiplexa a todos los oyentes registrados utilizando [`scheduleFrameCallback()`](https://docs.flutter.io/flutter/scheduler/SchedulerBinding/scheduleFrameCallback.html).
Todas estas llamadas de retorno reciben el sello de tiempo oficial del frame, en forma de una `duración` de alguna parte temporal arbitraria. Dado que todas las llamadas de retorno tienen el mismo tiempo, cualquier animación activada desde estas llamadas de retorno parecerá estar exactamente sincronizada incluso si tardan unos pocos milisegundos en ejecutarse.

## Tickers

La clase [`Ticker`](https://docs.flutter.io/flutter/scheduler/Ticker-class.html) se conecta al mecanismo [`scheduleFrameCallback()`](https://docs.flutter.io/flutter/scheduler/SchedulerBinding/scheduleFrameCallback.html) del scheduler para invocar un callback de tick. 

Un `Ticker` puede iniciarse y detenerse. Cuando se inicia, devuelve un `Future` que se resolverá cuando se detenga.

Cada tick, el `Ticker` proporciona un callback con la duración desde el primer tick después de que fue iniciado.

Debido a que los tick siempre dan su tiempo transcurrido en relación con el primer tick después de que se iniciaron, todos los ticks están sincronizados. Si inicia tres ticks en diferentes momentos entre dos frames, todos ellos se sincronizarán con la misma hora de inicio y, a continuación, se marcarán al mismo tiempo y posteriormente se tick en paralelo.


## Simulations

La clase abstracta [`Simulation`](https://docs.flutter.io/flutter/physics/Simulation-class.html) asigna un valor de tiempo relativo (un tiempo transcurrido) a un valor doble, y tiene una noción de finalización.

En principio, las simulaciones son stateless, pero en la práctica algunas simulaciones (por ejemplo, [`BouncingScrollSimulation`](https://docs.flutter.io/flutter/widgets/BouncingScrollSimulation-class.html) y [`ClampingScrollSimulation`](https://docs.flutter.io/flutter/widgets/ClampingScrollSimulation-class.html)) cambiar de estado irreversiblemente cuando se le pregunta.

Hay [varias implementaciones concretas](https://docs.flutter.io/flutter/physics/physics-library.html) de la clase `Simulation` para diferentes efectos.

## Animables

La clase abstracta [`Animatable`](https://docs.flutter.io/flutter/animation/Animatable-class.html) asigna un doble a un valor de un tipo particular.

Las clases `animables` son stateless e inmutables.

### Tweens

La clase abstracta [`Tween`](https://docs.flutter.io/flutter/animation/Tween-class.html) asigna un valor doble nominalmente en el rango 0.0-1.0 a un valor escrito (por ejemplo, un `Color`, u otro doble). Es un `Animatable`.

Tiene una noción de un tipo de salida (`T`), un valor `inicial` y un valor `final` de ese tipo, y una manera de interpolar (`lerp`) entre los valores inicial y final para un valor de entrada dado (el doble nominalmente en el rango 0.0-1.0).

Las clases `Tween` son stateless e immutables.

### Composición de animables

Pasar un método `Animatable<doble>` (el parent) a un método `Animatable` `chain()` crea una nueva subclase Animatable que aplica el mapeo del parent y luego el mapeo del hijo.

## Curves

Los mapas de clase abstracta [`Curve`](https://docs.flutter.io/flutter/animation/Curve-class.html) se duplican nominalmente en el rango 0.0-1.0 hasta duplicarse nominalmente en el rango 0.0-1.0.

Las clases `Curve` son stateless e immutables.

## Animations

La clases abstractas 
[`Animation`](https://docs.flutter.io/flutter/animation/Animation-class.html) proporciona un valor de un tipo dado, un concepto de dirección y estado de la animación, y una interfaz de escucha para registrar las llamadas de retorno que se invocan cuando el valor o estado cambia.

Algunas subclases de `Animation` tienen valores que nunca cambian ([`kAlwaysCompleteAnimation`](https://docs.flutter.io/flutter/animation/kAlwaysCompleteAnimation-constant.html), [`kAlwaysDismissedAnimation`](https://docs.flutter.io/flutter/animation/kAlwaysDismissedAnimation-constant.html), [`AlwaysStoppedAnimation`](https://docs.flutter.io/flutter/animation/AlwaysStoppedAnimation-class.html)); por lo que el registro de llamadas de retorno no tiene ningún efecto, ya que las llamadas de retorno nunca son llamadas.

La variante `Animación<doble>` es especial porque se puede utilizar para representar un doble nominal en el rango 0.0-1.0, que es la entrada esperada por las clases `Curve` y `Tween`, así como algunas otras subclases de `Animation`.

Algunas subclases de `Animation` son stateless, simplemente enviando a los oyentes a sus parents. Algunos son muy stateful.


### Animaciones compuestas

La mayoría de las subclases de `Animation` toman un "parent" `Animation<double>`. Son impulsados por ese parent.

La subclase `CurvedAnimation` toma una clase `Animation<double>` (el parent) y un par de clases `Curve` (las curvas forward y reverse) como entrada, y utiliza el valor del parent como entrada a las curvas para determinar su salida. `CurvedAnimation` es inmutable y stateless

La subclase `ReverseAnimation` toma una clase `Animation<double>` como su parent e invierte todos los valores de la animación. Asume que el parent está usando un valor nominal en el rango 0.0-1.0 y devuelve un valor en el rango 1.0-0.0. El estado y la dirección de la animación parent también se invierten. `ReverseAnimation` es inmutable y estateless.

La subclase `ProxyAnimation` toma una clase `Animation<double>` como su padre y simplemente reenvía el estado actual de ese parent. Sin embargo, el padre es mutable.

La subclase `TrainHoppingAnimation` toma dos parents, y cambia entre ellos cuando sus valores se cruzan.

### Controladores de animación

El `AnimationController` es una `Animation<double>` statefull que utiliza un `Ticker` para darse vida. Se puede arrancar y parar. Cada tick, toma el tiempo transcurrido desde que se inició y lo pasa a una `Simulation` para obtener un valor. Este es entonces el valor que reporta. Si la `Simulation` informa de que en ese momento ha finalizado, el controlador se detiene por sí mismo.

Al controlador de animación se le puede dar un límite inferior y superior para animar entre, y una duración.

En el caso simple (usando `forward()`, `reverse()`, `play()`, o `resume()`), el controlador de animación simplemente hace una interpolación lineal desde el límite inferior al límite superior (o viceversa, para la dirección inversa) durante la duración dada.

Cuando se utiliza `repeat()`, el controlador de animación utiliza una interpolación lineal entre los límites dados durante la duración dada, pero no se detiene.

Cuando se usa `animateTo()`, el controlador de animación hace una interpolación lineal sobre la duración dada desde el valor actual hasta el objetivo dado. Si no se da ninguna duración al método, la duración predeterminada del controlador y el rango descrito por el límite inferior y superior del controlador se utilizan para determinar la velocidad de la animación.

Cuando se utiliza `fling()`, se utiliza una `Force` para crear una simulación específica que luego se utiliza para accionar el controlador.

Cuando se utiliza `animateWith()`, la simulación dada se utiliza para controlar el controlador.

Todos estos métodos devuelven el futuro que el `Ticker` proporciona y que se resolverá cuando el controlador detenga o cambie la simulación.

### Adjuntar animables a las animaciones

Pasando una `Animation<doble>` (el nuevo parent) a un método `animatable()` de `Animatable` crea una nueva subclase de Animación que actúa como la Animatable pero es conducida desde el parent dado.
