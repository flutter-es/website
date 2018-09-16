---
layout: page
title: Tratando con las restricciones de cajas en Flutter

permalink: /layout/
---

Usted puede ser redirigido a esta página si el framework detecta un problema que involucre restricciones de cajas.


* Placeholder for TOC
{:toc}

## Introducción

En Flutter, los widgets son renderizados por sus objetos [`RenderBox`](https://docs.flutter.io/flutter/rendering/RenderBox-class.html) subyacentes. Los Render Boxes obtienen restricciones por parte de sus padres y se clasifican dentro de esas restricciones. 
Las restricciones consisten en valores mínimos y máximos para el ancho y alto; los tamaños consisten en un ancho y alto específicos.

En general, hay tres tipos de cajas, en términos de cómo manejar
sus restricciones:

- Aquellos que tratan de ser los más grandes posible.
  Por ejemplo, las cajas usadas por [`Center`](https://docs.flutter.io/flutter/widgets/Center-class.html) y [`ListView`](https://docs.flutter.io/flutter/widgets/ListView-class.html).
- Aquellos que tratan de tener el mismo tamaño que su hijo.
  Por ejemplo, las cajas usadas por [`Transform`](https://docs.flutter.io/flutter/widgets/Transform-class.html) y [`Opacity`](https://docs.flutter.io/flutter/widgets/Opacity-class.html).
- Aquellos que tratan de tener un tamaño en particular.
  Por ejemplo, las cajas usadas por [`Image`](https://docs.flutter.io/flutter/dart-ui/Image-class.html) y [`Text`](https://docs.flutter.io/flutter/widgets/Text-class.html).

Algunos widgets, por ejemplo [`Container`](https://docs.flutter.io/flutter/widgets/Container-class.html), varían de tipo en tipo basados en sus argumentos de construcción. En el caso de [`Container`](https://docs.flutter.io/flutter/widgets/Container-class.html), este por defecto trata de ser tan grande como sea posible, pero si tu colocas un valor en `width`, para esa instancia, trata de ajustarse a ese valor y tomar un tamaño particular.

Otras, por ejemplo [`Row`](https://docs.flutter.io/flutter/widgets/Row-class.html) y [`Column`](https://docs.flutter.io/flutter/widgets/Column-class.html) (cajas flexibles) varían basándose en las restricciones que se les otorgue, como se describe a continuación en la sección "Flex".

Las restricciones a veces son "estrictas", lo que significa que no dejan espacio para que el Render Box decida un tamaño
(ej. si el mínimo y máximo  de ancho son el mismo, se dice que tienen un ancho estricto). El ejemplo principal de esto es el widget `App`, el cual es contenido por la clase
[`RenderView`](https://docs.flutter.io/flutter/rendering/RenderView-class.html): 
la caja usada por el hijo retornado por la función [`build`](https://docs.flutter.io/flutter/widgets/State/build.html) 
de la aplicación, le da una restricción que lo fuerza a rellenar exactamente 
el área de contención de la aplicación ( normalmente, toda la pantalla). 
Muchas de las cajas en Flutter, especialmente aquellas que tienen un único hijo, 
pasan sus restricciones a sus hijos. Eso significa que si anida un grupo 
de cajas dentro de otra en la raíz del árbol de renderizado de tu aplicación, 
todas encajarán exactamente entre sí, forzadas por las restricciones estrictas.

Algunas cajas _pierden_ las restricciones, significa que el valor máximo es mantenido pero que el mínimo es removido. Por ejemplo, 
[`Center`](https://docs.flutter.io/flutter/widgets/Center-class.html).

Restricciones Ilimitadas
------------------------

En ciertas situaciones, las restricciones dadas por la caja son _ilimitadas_, o infinitas. Estos significa que el valor máximo de ancho o el máximo de alto es colocado a `double.INFINITY`.


Una caja que trata de ser tan grande como pueda, no tendrá una función útil cuando se le dan restricciones ilimitadas, y en modo depuración, esa combinación lanza una excepción que apunta a ese archivo.

Los casos más comunes en los que se encuentra una Render Box con restricciones ilimitadas están dentro de las cajas flexibles ([`Row`](https://docs.flutter.io/flutter/widgets/Row-class.html)
y [`Column`](https://docs.flutter.io/flutter/widgets/Column-class.html)), 
y **dentro de regiones scrollables** 
([`ListView`](https://docs.flutter.io/flutter/widgets/ListView-class.html) 
y otras subclases de [`ScrollView`](https://docs.flutter.io/flutter/widgets/ScrollView-class.html)).

En particular, [`ListView`](https://docs.flutter.io/flutter/widgets/ListView-class.html)
trata de expandirse para tratar de encajar en el espacio disponible en su dirección transversal (Es decir, si es un bloque de scroll vertical, trata de ser tan ancho como su padre). Si anida un
[`ListView`](https://docs.flutter.io/flutter/widgets/ListView-class.html) con scroll vertical dentro de un [`ListView`](https://docs.flutter.io/flutter/widgets/ListView-class.html) con scroll horizontal el interno trata de ser tan ancho como sea posible, el cual es infinitamente ancho, puesto que el externo es scrollable en esa dirección.

Flex
---------

Las cajas flexibles en si mismas ([`Row`](https://docs.flutter.io/flutter/widgets/Row-class.html) 
y [`Column`](https://docs.flutter.io/flutter/widgets/Column-class.html)) se comportan de forma diferente en función de si tienen restricciones limitadas o restricciones ilimitadas en su dirección dada.

En restricciones limitadas, tratan de ser lo más grande posible en esa dirección.

En las restricciones ilimitadas, tratan de adaptarse a sus hijos en esa dirección. En ese caso, tú no puedes colocar valor en `flex` en los hijos o en ningún otro que no sea 0 (el valor por defecto). En la librería de widget, esto significa que no puedes usar [`Expanded`](https://docs.flutter.io/flutter/widgets/Expanded-class.html)
cuando una caja flexible está dentro de otra caja flexible o dentro de una scrollable. Si lo haces, Obtendrás un mensaje de excepción apuntando a ese documento.

En la dirección _transversal_, es decir, en el ancho para [`Column`](https://docs.flutter.io/flutter/widgets/Column-class.html) (vertical flex) y en la altura para [`Row`](https://docs.flutter.io/flutter/widgets/Row-class.html) (horizontal flex), nunca deben ser ilimitadas, de lo contrario no serían capaces de alinear razonablemente a sus hijos.
