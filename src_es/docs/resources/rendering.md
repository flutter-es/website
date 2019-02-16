---
title: Renderizando en Flutter
---

## Introducción

El árbol de renderizado Flutter es un sistema de diseño y pintura de bajo nivel basado en un
árbol retenido de objetos que heredan de `RenderObject`. La mayoría de los desarrolladores
de Flutter no tendrá que interactuar directamente con el árbol de representación.
En su lugar, la mayoría de los desarrolladores deberían usar
[widgets](/widgets-intro), que se construyen utilizando el árbol de render.

### Modelo base

La clase base para cada nodo en el árbol de renderizado es
`RenderObject`, que define el modelo de diseño base. La base
El modo de diseño es extremadamente general y puede acomodar un gran número de 
Modelos de maquetación concretos que pueden coexistir en el mismo árbol. Por ejemplo, la base
del modelo no se compromete a un número fijo de dimensiones o incluso a un sistema
de coordenadas cartesiano. De esta manera, un solo árbol de render puede contener objetos de render
Operando en el espacio tridimensional junto con otros objetos renderizados
operando en el espacio bidimensional, p.Ej.,en la cara de un cubo en tres dimensiones.
Por otra parte, el diseño bidimensional puede ser parcialmente
computado en coordenadas cartesianas y parcialmente computado en coordenadas polares.
Estos distintos modelos pueden interactuar durante el diseño, por ejemplo, determinando el
tamaño del cubo por la altura de un bloque de texto en la cara del cubo.

No totalmente libre, el modelo base impone cierta estructura en el
árbol de renderización

 * Subclases de `RenderObject` debe implementar un `performLayout` función que
   toma como entrada un objeto `constraints` proporcionado por su padre. `RenderObject`
   no tiene opinión sobre la estructura de este objeto y los diferentes modelos de diseño
   usan diferentes tipos de restricciones. Sin embargo, cualquier tipo que elijan deben
   implementar `operator==` de una manera que `performLayout` produce la misma
   salida para dos objetos `constraints` que son `operator==`.

 * Implementaciones de `performLayout` se espera que llamen `layout` en su
   hijos. Al llamar `layout`, a `RenderObject` debe usar el parámetro
   `parentUsesSize` para declarar si su función `performLayout` Depende 
   de la información leída por el hijo. Si el padre no declara
   que utiliza el tamaño del hijo, el borde del padre al hijo se convierte en
   _relayout boundary_, lo que significa que el hijo (y su subárbol) podría sufrir
   diseño sin que el padre realice el diseño.

 * Subclases de `RenderObject` debe implementar una functión `paint` que dibuja una
   representación visual del objeto sobre una `PaintingCanvas`. Si
   el `RenderObject` tiene hijos, el `RenderObject` es responsable por
   el pintando a sus hijos usando la función `paintChild` en el
   `PaintingCanvas`.

 * Subclase de `RenderObject` debe llamar `adoptChild` cada vez que agregan un
   hijo. Similarmente, deben llamar `dropChild` cada vez que sacan a un hijo.

 * La mayoría de las subclases de `RenderObject` implementará una function `hitTest` que
   permite a los clientes consultar el árbol de renderización de objetos que se intersecan con una
   ubicación de entrada del usuario. `RenderObject` en sí no impone un particular
   tipo de firma en `hitTest`, pero la mayoría de las implementaciones tomarán un argumento
   de tipo `HitTestResult` (o, más probablemente, una subclase específica del modelo de
   `HitTestResult`) así como un objeto que describe la ubicación en la que
   la entrada proporcionada por el usuario (p.Ej., un `Point` para un modelo cartesiano de dos dimensiones).

 * Finalmente, las subclases de `RenderObject` puede anular el valor predeterminado, no hacer nada
   de implementaciones en `handleEvent` y `rotate` para responder a la entrada del usuario y
   rotación de la pantalla, respectivamente.

El modelo base también proporciona dos mixins para modelos de hijos comunes:

 * `RenderObjectWithChildMixin` es útil para las subclases de `RenderObject` al
   tener un hijo único.

 * `ContainerRenderObjectMixin` es útil para las subclases de `RenderObject` al
   tener una lista de hijos.

Subclases de `RenderObject` no están obligados a usar ninguno de estos hijos
los modelos son libres de inventar nuevos modelos infantiles para sus casos de uso específicos.

### Datos de los padres

TODO(ianh): Describe el concepto de datos padre.

El método `setupParentData()` se llama automáticamente para cada hijo
cuando se cambia el padre del hijo. Sin embargo, si necesitas
preinicializar el miembro `parentData` para establecer sus valores antes de agregar
un nodo a su padre, usted puede llamar preventivamente a ese padre futuro el método
`setupParentData()` con el futuro hijo como argumento.

TODO(ianh): Discuta cómo poner información de configuración por niño para
el padre en los datos del padre del niño.

Si cambia dinámicamente los datos de los padres de un hijo, también debe llamar
markNeedsLayout() en el padre, de lo contrario la nueva información no
surtirá efecto hasta que algo más active un diseño.

### Modelo de caja

#### Dimensiones

Todas las dimensiones se expresan como unidades de píxeles lógicos. Los tamaños de fuente son
también en unidades de píxeles lógicos. Las unidades de píxeles lógicos son aproximadamente
96dpi, pero el valor preciso varía según el hardware, de tal manera
forma de optimizar el rendimiento y la calidad de renderizado manteniendo
Interfaces de apróximadamente el mismo tamaño en todos los dispositivos, independientemente de la
densidad de píxeles del hardware.

Las unidades de píxeles lógicos se convierten automáticamente a pixeles del dispositivo (hardware)
al pintar aplicando un factor de escala apropiado.

TODO(ianh): Defina cómo obtiene realmente la proporción de píxeles del dispositivo si
Necesitarlo, y documentar las mejores prácticas en torno a eso.

#### EdgeInsets

#### BoxConstraints

### Bespoke Models


Usando las subclases proporcionadas
-----------------------------

### render_box.dart

#### RenderConstrainedBox

#### RenderShrinkWrapWidth

#### RenderOpacity

#### RenderColorFilter

#### RenderClipRect

#### RenderClipOval

#### RenderPadding

#### RenderPositionedBox

#### RenderImage

#### RenderDecoratedBox

#### RenderTransform

#### RenderSizeObserver

#### RenderCustomPaint

### RenderBlock (render_block.dart)

### RenderFlex (render_flex.dart)

### RenderParagraph (render_paragraph.dart)

### RenderStack (render_stack.dart)

Escribir nuevas subclases
----------------------

### El contrato RenderObject

Si quieres definir un `RenderObject` que usa una nueva coordenada
sistema, entonces usted debe heredar directamente de `RenderObject`. Ejemplos
de hacer esto se puede encontrar en `RenderBox`, que se ocupa en
rectángulos en el espacio cartesiano, y en el [ejemplo sector_layout.dart
](https://github.com/flutter/flutter/blob/master/examples/layers/rendering/src/sector_layout.dart), cual
implementa un modelo de juguete basado en coordenadas polares. La clase `RenderView`,
que se utiliza internamente para adaptarse desde el sistema host a este
marco de representación, es otro ejemplo.

Una subclase de `RenderObject` debe cumplir los siguientes parámetros:

* Debe cumplir la condición `AbstractNode` cuando trata
  con hijos. Utilizando `RenderObjectWithChildMixin` o
  `ContainerRenderObjectMixin` puede hacer esto más fácil.

* Información sobre el hijo manejado por el padre., p.Ej., típicamente
  informando la posición y configuración para el diseño de los padres,
  debe ser almacenado en el miembro `parentData`; para este efecto, una 
  clase ParentData debe ser definida y el método `setupParentData()`
  debe anularse para inicializar los datos de los padres del hijo
  apropiadamente.

* Las restricciones de diseño se deben expresar en una subclase de Restricciones. Esta
  subclase debe implementar `operator==` (y `hashCode`).

* Cuando sea necesario actualizar el diseño, el método `markNeedsLayout()`
  debe ser llamado.

* Cuando sea necesario actualizar la representación sin cambiar el diseño,
  el método `markNeedsPaint()` debe ser llamado. (llamando
  `markNeedsLayout()` implica una llamada a `markNeedsPaint()`, usted 
  no necesita llamar a los dos.)

* La subclase debe anular `performLayout()` para realizar el diseño basado
  en las restricciones dadas en el miembro `constraints`. Cada objeto es
  responsable de dimensionarse; El posicionamiento debe ser hecho por el
  objeto llamado `performLayout()`. Si el posicionamiento se realiza antes
  o después de que el diseño del hijo, es una decisión que debe tomar la clase.
  TODO(ianh): Documentación sizedByParent, performResize(), rotate

* TODO(ianh): Documentación painting, hit testing, debug*

#### El parámetro ParentData

#### Uso de RenderObjectWithChildMixin

#### Uso de ContainerRenderObjectMixin (y ContainerParentDataMixin)

Esta combinación se puede utilizar para clases que tienen una lista secundaria, para administrar
la lista. Implementa la lista utilizando punteros de lista enlazada en la
estructura 'parentData`.

TODO(ianh): Documentar esta mezcla.

Las subclases deben seguir el siguiente contrato, además de la
contratos de cualquier otra clase que subclase:

* Si el constructor toma una lista de hijos, debe llamar addAll()
  con esa lista.

TODO(ianh): Documentar como recorrer los hijos.

### El parámetro RenderBox

Se requiere una subclase `RenderBox` para implementar el siguiente contrato:

* Debe cumplir el contrato `AbstractNode` cuando
  trata con hijos. Tenga en cuenta que utilizando `RenderObjectWithChildMixin`
  o `ContainerRenderObjectMixin` se encarga de esto por ti, asumiendo
  usted cumple su contrato en su lugar.

* Si tiene datos para almacenar en sus hijos, debe definir una subclase
  BoxParentData y anular setupParentData() para inicializar
  los datos de los hijos apropiadamente, como en el siguiente ejemplo.
  (Si la subclase tiene una opinión sobre qué tipo de hijos deben
  ser, P.Ej. la forma en que `RenderBlock` quiere que sus hijos sean
  los nodos de `RenderBox`, luego cambian la firma `setupParentData()`
  en consecuencia, para detectar el mal uso del método..)

<!-- skip -->
```dart
  class FooParentData extends BoxParentData { ... }

  // En RenderFoo
  void setupParentData(RenderObject child) {
    if (child.parentData is! FooParentData)
      child.parentData = FooParentData();
  }
```

* La clase debe encapsular un algoritmo de diseño que tenga las siguientes
  caracteristicas:

** Utiliza como entrada un conjunto de restricciones, descritas por un
   Objeto BoxConstraints, y un conjunto de cero o más hijos, como
   determinado por la propia clase, y tiene como salida un Tamaño (que es
   establecido en el propio campo `size` del objeto), y las posiciones para cada hijo
   (que se establecen en el campo `parentData.position` de los hijos).

** El algoritmo puede decidir el tamaño en una de dos formas:
   basado exclusivamente en las restricciones dadas (es decir, es efectivamente
   dimensionado enteramente por su matriz), o basado en esas restricciones y
   las dimensiones de los niños.

   En el primer caso, la clase debe tener un getter sizeByParent que
   devuelve verdadero, y debe tener un método `performResize()` que usa
   los objetos de tamaño `constraints` a sí mismo mediante el establecimiento del miembro
   `size`. El tamaño debe ser consistente, un conjunto dado de
   las restricciones siempre deben resultar en el mismo tamaño.

   En este último caso, heredará el valor por defecto del getter `sizedByParent`
   que devuelve falso, y se dimensionará en 
   función `performLayout()` que se describe a continuación.

   La distinción `sizedByParent` es puramente una performance
   de mejoramiento. Permite nodos que solo establecen su tamaño en función de la
   restricciones entrantes para omitir esa lógica cuando necesitan ser
   rediseñado y, lo que es más importante, permite que el sistema al diseño
   tratar el nodo como un _layout boundary_, lo que reduce la cantidad de
   trabajo que debe ocurrir cuando el nodo está marcado como necesario
   en el diseño.

* Los siguientes métodos deben reportar números consistentes con la salida
  del algoritmo de diseño utilizado:

  * `double getMinIntrinsicWidth(BoxConstraints constraints)` debe
     devolver el ancho que se ajuste dentro de las restricciones dadas debajo de las cuales
     hacer la restricción de ancho más pequeña no aumentaría la
     altura resultante, o, para decirlo de otra manera, el ancho más estrecho en
     que la caja se puede renderizar sin dejar de colocar a los hijos
     dentro de sí mismo.

     Por ejemplo, el ancho intrínseco mínimo de un fragmento de texto como "a
     b cd e ", donde se permite que el texto se ajuste a los espacios, sería el
     ancho de "cd".

  * `double getMaxIntrinsicWidth(BoxConstraints constraints)` devuelve
     el ancho que se ajusta dentro de las restricciones dadas arriba del cual
     hacer la restricción de ancho más grande no disminuiría el resultado
     altura.

     Por ejemplo, el ancho intrínseco máximo de un fragmento de texto como "a
     b cd e ", donde se permite que el texto se ajuste a los espacios, sería el
     ancho de toda la cadena "a b cd e", sin envoltura.

  * `double getMinIntrinsicHeight(BoxConstraints constraints)` devuelve
     la altura que se ajusta a las restricciones dadas a continuación
     lo que reduce la restricción de altura y no aumentaría el
     ancho resultante, o, para decirlo de otra manera, la altura más corta en
     que la caja se puede renderizar sin dejar de colocar a los hijos.
     dentro de sí mismo.

     La altura intrínseca mínima de un algoritmo de anchura en altura,
     como el diseño de texto en inglés, sería la altura del texto en el
     ancho que se utilizaría dadas las restricciones. Así, por ejemplo,
     dado el texto "hola mundo", si las restricciones fueran tales que
     tenía que envolver en el espacio, entonces la altura intrínseca mínima sería
     la altura de dos líneas (y el interlineado apropiado). Si
     las restricciones eran tales que todo encajaba en una sola línea, 
     sería la altura de una línea.

   * `double getMaxIntrinsicHeight(BoxConstraints constraints)` 
     devuelve la altura que se ajuste dentro de las restricciones dadas arriba
     lo que hacer la restricción de altura más grande no disminuiría el
     ancho resultante. Si la altura depende exclusivamente del ancho,
     y el ancho no depende de la altura, entonces
     `getMinIntrinsicHeight()` y `getMaxIntrinsicHeight()` devolverán el
     mismo número dado las mismas restricciones.

     En el caso del texto en inglés, la altura intrínseca máxima es la
     Igual que la altura intrínseca mínima.

* El cuadro debe tener un método `performLayout()` que encapsule el
  Algoritmo de diseño que esta clase representa. Es responsable de
  decirle a los hijos que coloquen, posicionando a los hijos, y, si
  sizedByParent es falso, dimensionando el objeto.

  Específicamente, el método debe caminar sobre los hijos del objeto, si
  cualquiera, y para cada llamada, `child.layout()` con un objeto BoxConstraints
  como el primer argumento, y un segundo argumento llamado
  `parentUsesSize` que se establece en verdadero si el tamaño resultante del hijo
  influirá de alguna manera en el diseño, y se omite (o se establece en falso)
  si se ignora el tamaño resultante del hijo. Las posiciones de los hijos.
  (`child.parentData.position`) entonces debe ser establecido.

  (Llamar a `layout()` puede resultar en el propio método `performLayout()` del hijo
  se llame recursivamente, si el hijo también necesita ser puesto
  afuera. Si las restricciones del hijo no han cambiado y el hijo no está
  marcado como que necesita diseño, esto será omitido.)

  El padre no debe establecer el `tamaño` de un hijo directamente. Si el padre
  quiere influir en el tamaño del hijo, debe hacerlo a través de la
  restricciones que pasa al método `layout()` del hijo.

  Si el `sizedByParent` de un objeto es falso, entonces su `performLayout()`
  también debe dimensionar el objeto (configurando `tamaño`), de lo contrario, el tamaño
  hay que dejarlo intacto.

* El objeto `size` nunca debe establecerse en un valor infinito.

* La caja también debe implementar `hitTestChildren()`.
  TODO(ianh): Definir esto mejor

* La caja también debe implementar `paint()`.
  TODO(ianh): Definir esto Mejor

#### usando RenderProxyBox

### El contrato de prueba de golpe


Reglas de rendimiento
--------------------------

* Evite usar transformaciones donde las meras matemáticas sean suficientes (p.Ej,
  dibuja tu rectángulo en x,y en lugar de traducir por x,y y
  dibujándolo a 0,0).

* Evite utilizar guardar/restaurar en lienzos.


Útiles herramientas de depuración
----------------------

Esta es una forma rápida de volcar todo el árbol de renderizado a la consola en cada fotograma.
Esto puede ser muy útil para averiguar exactamente qué está pasando cuando
trabajamos con el árbol de render.

```dart
import 'package:flutter/rendering.dart';

void main() {
  RendererBinding.instance.addPersistentFrameCallback((_) {
    // Esto vuelca todo el árbol de renderizado cada fotograma..
    debugDumpRenderTree();
  });
  // ...
}
```
