---
title: Visión general de animaciones
short-title: Visión general
description: Una visión general de los conceptos de animación.
---

El sistema de animación en Flutter está basado en mecanografiado del objeto
[`Animation`](https://docs.flutter.io/flutter/animation/Animation-class.html)
Los widgets pueden incorporar estas animaciones en su compilación.
funciona directamente leyendo su valor actual y escuchando su
cambios de estado o pueden utilizar las animaciones como la base de más elaborados
Animaciones que pasan a otros widgets.

## Animación

El bloque de construcción principal del sistema de animación es el
[`Animation`](https://docs.flutter.io/flutter/animation/Animation-class.html)
clase. Una animación representa un valor de un tipo específico que puede cambiar
A lo largo de la vida de la animación. La mayoría de los widgets que realizan una animación.
recibir un objeto `Animation` como parámetro, desde el cual leen el actual
Valor de la animación y a la que escuchan los cambios en ese valor.

### `addListener`

Cada vez que cambia el valor de la animación, la animación notifica a todos los
oyentes añadidos con
[`addListener`](https://docs.flutter.io/flutter/animation/Animation/addListener.html).
Normalmente, un [`Estado`](https://docs.flutter.io/flutter/widgets/State-class.html)
Objeto que escucha una animación llamará
[`setState`](https://docs.flutter.io/flutter/widgets/State/setState.html) en
en su devolución de llamada del oyente para notificar al sistema de widgets que necesita
Reconstruir con el nuevo valor de la animación.

Este patrón es tan común que hay dos widgets que ayudan a reconstruir los widgets
cuando las animaciones cambian de valor:
[`AnimatedWidget`](https://docs.flutter.io/flutter/widgets/AnimatedWidget-class.html)
y
[`AnimatedBuilder`](https://docs.flutter.io/flutter/widgets/AnimatedBuilder-class.html).
El primero, `AnimatedWidget`, es más útil para widgets sin estado y animados.
Para usar `AnimatedWidget`, simplemente subclasifique e implemente el
[`build`](https://docs.flutter.io/flutter/widgets/AnimatedWidget/build.html)
función. El segundo, `AnimatedBuilder`, es útil para widgets más complejos
que desean incluir una animación como parte de una función de compilación más grande. Usar
`AnimatedBuilder`, simplemente construye el widget y pásalo una función` builder`.

### `addStatusListener`

Las animaciones también proporcionan una
[`AnimationStatus`](https://docs.flutter.io/flutter/animation/AnimationStatus-class.html),
lo que indica cómo la animación evolucionará con el tiempo. Siempre que la animación sea de
cambios de estado, la animación notifica a todos los oyentes agregados con
[`addStatusListener`](https://docs.flutter.io/flutter/animation/Animation/addStatusListener.html).
Normalmente, las animaciones comienzan en el estado `descartado ', lo que significa que son
Al comienzo de su gama. Por ejemplo, animaciones que progresan desde 0.0.
a 1.0 será 'descartado' cuando su valor sea 0.0. Entonces podría correr una animación.
`forward` (por ejemplo, de 0.0 a 1.0) o tal vez en` reverse` (por ejemplo, de 1.0 a 1.0)
0.0). Finalmente, si la animación llega al final de su rango (por ejemplo, 1.0), la animación
la animación alcanza el estado `completado`.

## AnimationController

Para crear una animación, primero crea una
[`AnimationController`](https://docs.flutter.io/flutter/animation/AnimationController-class.html).
Además de ser una animación en sí misma, un `AnimationController 'te permite controlar
la animación. Por ejemplo, puedes decirle al controlador que reproduzca la animación.
[`forward`](https://docs.flutter.io/flutter/animation/AnimationController/forward.html)
o [`stop`](https://docs.flutter.io/flutter/animation/AnimationController/stop.html)
la animación. También puede [`fling`](https://docs.flutter.io/flutter/animation/AnimationController/fling.html)
animaciones, que utiliza una simulación física, como un resorte, para impulsar el
animación.

Una vez que haya creado un controlador de animación, puede comenzar a construir otros
Animaciones basadas en él. Por ejemplo, puede crear un
[`ReverseAnimation`](https://docs.flutter.io/flutter/animation/ReverseAnimation-class.html)
que refleja la animación original pero se ejecuta en la dirección opuesta (por ejemplo,
de 1.0 a 0.0). Del mismo modo, puede crear un
[`CurvedAnimation`](https://docs.flutter.io/flutter/animation/CurvedAnimation-class.html)
cuyo valor se ajusta mediante una [curva](https://docs.flutter.io/flutter/animation/Curves-class.html).

## Tweens

Para animar más allá del intervalo de 0.0 a 1.0, puede usar un
[`Tween <T>`](https://docs.flutter.io/flutter/animation/Tween-class.html), que
interpola entre sus
[`begin`](https://docs.flutter.io/flutter/animation/Tween/begin.html)
y [`end`](https://docs.flutter.io/flutter/animation/Tween/end.html)
valores. Muchos tipos tienen subclases `Tween` específicas que proporcionan tipos específicos
interpolación. Por ejemplo,
[`ColorTween`](https://docs.flutter.io/flutter/animation/ColorTween-class.html)
Interpola entre colores y
[`RectTween`](https://docs.flutter.io/flutter/animation/RectTween-class.html)
Interpola entre rectas. Puedes definir tus propias interpolaciones creando
tu propia subclase de `Tween` y anulando su
[`lerp`](https://docs.flutter.io/flutter/animation/Tween/lerp.html)
función.

Por sí misma, una interpolación simplemente define cómo interpolar entre dos valores. Llegar
un valor concreto para el cuadro actual de una animación, también necesita un
Animación para determinar el estado actual. Hay dos formas de combinar una interpolación.
Con una animación para obtener un valor concreto:

1. Puede [`evaluar`](https://docs.flutter.io/flutter/animation/Tween/evaluate.html)
   la interpolación en el valor actual de una animación. Este enfoque es el más útil.
   para widgets que ya están escuchando la animación y por lo tanto
   reconstruir cada vez que la animación cambia de valor.

2. Puedes [`animate`](https://docs.flutter.io/flutter/animation/Animatable/animate.html)
   La interpolación basada en la animación. En lugar de devolver un solo valor, el
   La función animar devuelve un nuevo `Animación` que incorpora la interpolación. Esta
   El enfoque es más útil cuando se quiere dar la animación recién creada a
   Otro widget, que luego puede leer el valor actual que incorpora
   la interpolación, así como escuchar los cambios en el valor.

# Arquitectura

Las animaciones en realidad se construyen a partir de una serie de elementos básicos.

## Sheduler

los
[`SchedulerBinding`](https://docs.flutter.io/flutter/scheduler/SchedulerBinding-class.html)
es una clase singleton que expone las primitivas de planificación de Flutter.

Para esta discusión, la clave primitiva son las devoluciones de llamada de marco. Cada
el tiempo que se necesita mostrar un cuadro en la pantalla, el motor de Flutter
activa una devolución de llamada de "cuadro inicial" que el planificador multiplexa
todos los oyentes registrados usando
[`scheduleFrameCallback()`](https://docs.flutter.io/flutter/scheduler/SchedulerBinding/scheduleFrameCallback.html).
Todas estas devoluciones de llamada reciben la marca de tiempo oficial del marco, en
La forma de una "Duración" de alguna época arbitraria. Ya que todos los
las devoluciones de llamada tienen el mismo tiempo, las animaciones activadas de estos
Las devoluciones de llamada aparecerán exactamente sincronizadas incluso si toman una
Pocos milisegundos para ser ejecutados.

## Tickers

los
[`Ticker`](https://docs.flutter.io/flutter/scheduler/Ticker-class.html)
clase engancha en el programador
[`scheduleFrameCallback()`](https://docs.flutter.io/flutter/scheduler/SchedulerBinding/scheduleFrameCallback.html)
Mecanismo para invocar una devolución de llamada cada tick.

Un 'Ticker' se puede iniciar y detener. Cuando se inicia, devuelve un
'Futuro' que se resolverá cuando se detenga.

Cada marca, el 'Ticker' proporciona la devolución de llamada con la duración desde
La primera marca después de que se inició.

Porque los tickers siempre dan su tiempo transcurrido en relación al primero.
tick después de que se iniciaron, todos los tickers están sincronizados. Si tu
iniciar tres tics en diferentes momentos entre dos cuadros, todos ellos
no obstante, se sincronizará con la misma hora de inicio y
posteriormente marque en el paso.

## Simulaciones

los
[`Simulation`](https://docs.flutter.io/flutter/physics/Simulation-class.html)
clase abstracta asigna un valor de tiempo relativo (un tiempo transcurrido) a un
Doble valor, y tiene una noción de terminación.

En principio, las simulaciones son apátridas pero en la práctica algunas simulaciones
(por ejemplo,
[`BouncingScrollSimulation`](https://docs.flutter.io/flutter/widgets/BouncingScrollSimulation-class.html) y
[`ClampingScrollSimulation`](https://docs.flutter.io/flutter/widgets/ClampingScrollSimulation-class.html))
cambio de estado irreversible cuando se consulta.

Hay [varias implementaciones concretas](https://docs.flutter.io/flutter/physics/physics-library.html)
de la clase `Simulation` para diferentes efectos.

## animables

los
[`Animatable`](https://docs.flutter.io/flutter/animation/Animatable-class.html)
clase abstracta asigna un doble a un valor de un tipo particular.

Las clases `animables` son apátridas e inmutables.

### Tweens

los
[`Tween`](https://docs.flutter.io/flutter/animation/Tween-class.html)
clase abstracta asigna un valor doble nominalmente en el rango de 0.0-1.0 a un
valor escrito (por ejemplo, un `Color`, u otro doble). Es un
`Animatable`.

Tiene una noción de un tipo de salida (`T`), un valor de` begin` y un `end`
valor de ese tipo, y una manera de interpolar (`lerp`) entre
valores iniciales y finales para un valor de entrada dado (el doble nominalmente en
el rango 0.0-1.0).

Las clases `tween` son apátridas e inmutables.

### Componiendo animatables

Pasando un `Animatable <double>` (el padre) a un `Animatable`'s
El método `chain ()` crea una nueva subclase `Animatable` que aplica la
mapeo de los padres luego mapeo del niño.

## Curvas

los
[`Curve`] (https://docs.flutter.io/flutter/animation/Curve-class.html)
los mapas abstractos de clase se duplican nominalmente en el rango de 0.0-1.0 a dobles
nominalmente en el rango de 0.0-1.0.

Las clases de 'curva' son apátridas e inmutables.

## Animaciones

los
[`Animation`](https://docs.flutter.io/flutter/animation/Animation-class.html)
clase abstracta proporciona un valor de un tipo dado, un concepto de
Dirección de animación y estado de animación, y una interfaz de escucha para
registrar devoluciones de llamada que se invocan cuando cambia el valor o el estado.

Algunas subclases de `Animation` tienen valores que nunca cambian
([`kAlwaysCompleteAnimation`](https://docs.flutter.io/flutter/animation/kAlwaysCompleteAnimation-constant.html),
[`kAlwaysDismissedAnimation`](https://docs.flutter.io/flutter/animation/kAlwaysDismissedAnimation-constant.html),
[`AlwaysStoppedAnimation`](https://docs.flutter.io/flutter/animation/AlwaysStoppedAnimation-class.html));
el registro de devoluciones de llamada en estos no tiene efecto ya que las devoluciones de llamada son
nunca llamado

La variante `Animation <double>` es especial porque puede usarse para
representa un doble nominalmente en el rango de 0.0-1.0, que es la entrada
esperado por las clases `Curve` y` Tween`, así como algunas más
subclases de `animacion`.

Algunas subclases `Animation` son sin estado, simplemente enviando oyentes
a sus padres. Algunos son muy con estado.

### Animaciones compostables

La mayoría de las subclases `Animación` toman un" padre "explícito
`Animación <double>`. Ellos son conducidos por ese padre.

La subclase `CurvedAnimation` toma una clase` Animation <double> `(la
padre) y un par de clases `Curve` (el avance y el reverso
curvas) como entrada, y utiliza el valor del padre como entrada para el
Curvas para determinar su salida. 'CurvedAnimation' es inmutable y
apátrida.

La subclase `ReverseAnimation` toma una clase` Animation <double> `como
Es padre e invierte todos los valores de la animación. Asume
el padre está usando un valor nominalmente en el rango de 0.0-1.0 y devuelve
un valor en el rango de 1.0-0.0. El estado y dirección del padre.
La animación también se invierte. `ReverseAnimation` es inmutable y
apátrida.

La subclase `ProxyAnimation` toma una clase` Animation <double> `como
su padre y simplemente reenvía el estado actual de ese padre.
Sin embargo, el padre es mutable.

La subclase `TrainHoppingAnimation` toma dos padres, y cambia
entre ellos cuando sus valores se cruzan.

### Controladores de animacion

los
[`AnimationController`] (https://docs.flutter.io/flutter/animation/AnimationController-class.html)
es un estado `Animation <double>` que usa un `Ticker` para darse a sí mismo
vida. Se puede iniciar y detener. Cada tick, toma el tiempo.
transcurrió desde que se inició y lo pasa a una 'Simulación' para obtener
un valor. Ese es entonces el valor que reporta. Si la `simulación`
informa que en ese momento ha finalizado, entonces el controlador se detiene
sí mismo.

Al controlador de animación se le puede asignar un límite inferior y superior a
Animar entre, y una duración.

En el caso simple (usando `forward ()`, `reverse ()`, `play ()`, o
`resume ()`), el controlador de animación simplemente hace un lineal
interpolación desde el límite inferior al límite superior (o viceversa,
para la dirección inversa) sobre la duración dada.

Cuando se usa `repeat ()`, el controlador de animación usa un
interpolación entre los límites dados sobre la duración dada, pero
no para.

Cuando se usa `animateTo ()`, el controlador de animación realiza una
interpolación sobre la duración dada desde el valor actual hasta el
objetivo dado. Si no se le da una duración al método, el valor predeterminado es
Duración del controlador y el rango descrito por el controlador.
El límite inferior y el límite superior se utilizan para determinar la velocidad del
animación.

Cuando se usa `fling ()`, se usa un `Force` para crear un
Simulación que luego se utiliza para conducir el controlador.

Cuando se usa `animateWith ()`, la simulación dada se usa para conducir el
controlador.

Todos estos métodos devuelven el futuro que el 'Ticker' proporciona y
que se resolverá cuando el controlador se detenga o cambie a continuación
simulación.

### Adjuntando animatables a animaciones

Pasando un `Animation <double>` (el nuevo padre) a un `Animatable`'s
El método `animate ()` crea una nueva subclase `Animation` que actúa como
el 'Animatable' pero es expulsado del padre dado.
