---
title: Tratar con restricciones de cajas
short-title: Box constraints
---

{{site.alert.note}}
  Puede ser redirigido a esta página si el framework detecta problemas que involucren a 
  restricciones de caja (box constraints).
{{site.alert.end}}


En Flutter, los widgets son dibujados por su objeto 
[`RenderBox`]({{site.api}}/flutter/rendering/RenderBox-class.html) subyacente. Las cajas de renderizado boxes toman las restricciones dadas por 
sus padres, y se dimensionan a si mismos con estas 
restricciones. Las restricciones consisten en anchos y altos mínimos y 
máximos; las dimensiones consisten en un acho y alto específicos.

Generalmente, hay tres tipos de cajas, en términos de como manejan 
sus restricciones:

- Aquellas que tratan de ser tan grandes como sea posible.
  Por ejemplo, las cajas usadas por [`Center`]({{site.api}}/flutter/widgets/Center-class.html) y [`ListView`]({{site.api}}/flutter/widgets/ListView-class.html).
- Aquellas que tratan de ser del mismo tamaño de sus hijos.
  Por ejemplo, las cajas usadas por [`Transform`]({{site.api}}/flutter/widgets/Transform-class.html) y [`Opacity`]({{site.api}}/flutter/widgets/Opacity-class.html).
- Aquellas que tratan de ser de unas dimensiones concretas.
  Por ejemplo, las cajas usadas por [`Image`]({{site.api}}/flutter/dart-ui/Image-class.html) y [`Text`]({{site.api}}/flutter/widgets/Text-class.html).

Algunos widgets, por ejemplo [`Container`]({{site.api}}/flutter/widgets/Container-class.html), varian de tipo basándose en 
los argumentos de su constructor. En el caso de [`Container`]({{site.api}}/flutter/widgets/Container-class.html), por defecto
trata de ser tan grande como sea posible, pero si le proporcionas un `width`, por 
ejemplo, este trata de cumplir con esto y tener un tamaño concreto.

Otros, por ejemplo [`Row`]({{site.api}}/flutter/widgets/Row-class.html) y [`Column`]({{site.api}}/flutter/widgets/Column-class.html) (cajas flexibles) varían basándose en las
restricciones que se le proporcionen, como se describe abajao en la sección "Flex".

Las restricciones son algunas veces "forzadas", significando esto que estas no dejan espacio 
al Renderbox para decidir un tamaño (e.j. si el mínimo y 
el máximo ancho son el mismo, a esto se le llama tener un ancho forzado). El
principal ejemplo de esto es el widget `App`, el cual es contenido por la clase
[`RenderView`]({{site.api}}/flutter/rendering/RenderView-class.html): 
la caja usada por el hijo devuelto por la funcion 
[`build`]({{site.api}}/flutter/widgets/State/build.html) de la
aplicación toma una restricción que le fuerzaa llenar
exactamente el area de contenido de la aplicación (normalmente, la pantalla
completa). Muchas de las cajas en Flutter, especialmente aquellas que toman un 
solo hijo, pasan sus restricciones a sus hijos. Esto
significa que si anidas un manojo de cajas dentro de otras en la raiz
del árbol de renderizado de tu aplicación, todos encajaran exactamente en los
otros, obligados por estas restricciones forzadas.

Algunas cajas _aflojan_ sus restricciones, esto significa que se mantiene el máximo
pero se elimina el mínimo. Por ejemplo,
[`Center`]({{site.api}}/flutter/widgets/Center-class.html).

Restricciones ilimitadas
---------------------

En ciestas situaciones, la restricción que toma una caja es 
_ilimitada_, o infinita. Esto significa que ya sea el ancho máximo o 
la altura máxima están fijadas a `double.INFINITY`.

Una caja que trata de ser lo más grande posible no funcionará convenientemente cuando 
se le da una restricción ilimitada y, en modo de depuración, tal combinación
lanzará un aexcepción que apunta a este docuemnto.

El caso más común una caja de renderizado se encuentra con restricciones
ilimitadas son las cajas flexibles
([`Row`]({{site.api}}/flutter/widgets/Row-class.html)
y [`Column`]({{site.api}}/flutter/widgets/Column-class.html)),
y **dentro de las regiones con scroll**
([`ListView`]({{site.api}}/flutter/widgets/ListView-class.html)
y otras subclases de [`ScrollView`]({{site.api}}/flutter/widgets/ScrollView-class.html)).

En particular, [`ListView`]({{site.api}}/flutter/widgets/ListView-class.html)
trata de expandirse para llenar el espacio disponible 
en su cross-direction (ej. si es un block de scroll vertical, este trata
de ser tan ancho como su padre). Si anidas un 
[`ListView`]({{site.api}}/flutter/widgets/ListView-class.html) de scroll vertical
dentro de un [`ListView`]({{site.api}}/flutter/widgets/ListView-class.html),
de scroll horizontal, el interno trata de ser tan ancho como sea posible, 
lo cual es ancho infinito, ya que el otro tiene scroll en esta dirección.

Flex
----

Las cajas flexibles en si mismas, 
([`Row`]({{site.api}}/flutter/widgets/Row-class.html)
y [`Column`]({{site.api}}/flutter/widgets/Column-class.html))
se conforman de forma diferente 
dependiendo de si tienen restricciones limitadas o ilimitadas en 
su dirección dada.

Con restricciones limitadas, estos tratan de ser tan grandes como sea posible en esta
dirección.

Con restricciones ilimitadas, estos tratan de ajustarse a sus hijos en esta 
dirección. En este caso, no puedes fijar la propiedad `flex` en los hijos en
ora cosa que no sea 0 (su valor por defecto). En la biblioteca de widgets, esto
significa que no puedes usar [`Expanded`]({{site.api}}/flutter/widgets/Expanded-class.html)
cuando la caja flexible esta dentro de 
otra caja flexible o dentro de una caja con scroll. Si lo haces, onbtendrás un
mensaje de excepción remitiéndote a este documento.

En la dirección _cruzada_, ej. en su ancho para un [`Column`]({{site.api}}/flutter/widgets/Column-class.html) (flex vertical) y en su 
alto para un [`Row`]({{site.api}}/flutter/widgets/Row-class.html) (flex horizontal), nunca debern ser ilimitados, 
sino podrían no alinear razonablemente sus hijos.
