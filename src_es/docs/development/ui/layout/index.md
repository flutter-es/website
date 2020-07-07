---
title: Layouts en Flutter
short-title: Layout
description: Aprende como trabaja el mecanismo de layout de Flutter y como construir un layout.
diff2html: true
---

{% assign api = site.api | append: '/flutter' -%}
{% capture code -%} {{site.repo.this}}/tree/{{site.branch}}/src/_includes/code {%- endcapture -%}
{% capture examples -%} {{site.repo.this}}/tree/{{site.branch}}/examples {%- endcapture -%}
{% assign rawExFile = 'https://raw.githubusercontent.com/flutter/website/master/examples' -%}
{% capture demo -%} {{site.repo.flutter}}/tree/{{site.branch}}/examples/flutter_gallery/lib/demo {%- endcapture -%}

<style>dl, dd { margin-bottom: 0; }</style>

{{site.alert.secondary}}
  <h4 class="no_toc">Lo que aprenderás</h4>

  * Los widgets son clases usadas para construir UIs.
  * Los widgets son usados tanto por el layout como por los elementos de UI.
  * Crea widgets complejos mediante composición de widgets simples.
{{site.alert.end}}

El corazón del mecanismo de layout de Flutter son los widgets. En Flutter, casi
todo es un widget&mdash;incluso los modelos de layout son widgets.
Las imágenes, iconos, y texto que ves en una app Flutter, son todo widgets.
Pero cosas que no ves también son widgets, como son filas, columnas,
y cuadrículas que organizan, restringen, y alinean los widgets visibles.

Creas un layout mediante la composición de widgets para construir widgets más complejos.
Por ejemplo, la primera captura de pantalla abajo muestra tres iconos con una etiqueta sobre cada uno de ellos:

<div class="row mb-4">
  <div class="col-12 text-center">
    {% asset ui/layout/lakes-icons.png class="border mt-1 mb-1 mw-100" alt="Sample layout" %}
    {% asset ui/layout/lakes-icons-visual.png class="border mt-1 mb-1 mw-100" alt="Sample layout with visual debugging" %}
  </div>
</div>

La segunda captura de pantalla muestra el layout visualmente, mostrando una fila de 
3 columnas donde cada columna contiene un icono y una etiqueta.

{{site.alert.note}}
  La mayoría de las capturas de pantalla en este tutorial se muestran con 
  `debugPaintSizeEnabled` fijado en true por eso puedes ver el layout visualmente.
  Para más información, mira
  [Depuración Visual](/docs/testing/debugging#visual-debugging), una sección en 
  [Depurar apps Flutter](/docs/testing/debugging).
{{site.alert.end}}

Aquí está un diagrama del árbol de widgets para este UI:

{% asset ui/layout/sample-flutter-layout.png class="mw-100" alt="Node tree" %}
{:.text-center}

La mayoría de esto podría verse como podría esperarse, pero puede que te estes preguntando 
sobre los Container (mostrados en rosa). [Container][] es una clase widget que te permite
personalizar su widget hijo. Usa un `Container` cuando quieras añadir
padding, márgenes, bordes, o color de fondo, por nombrar algunas de sus 
capacidades.

En este ejemplo, cada widget [Text][] se situa en un `Container` para añadir márgenes.
La fila entera, [Row][], también esta colocada en un `Container` para añadir padding alrededor de la 
fila.

El resto del UI en este ejemplo es controlado por propiedades.
Fija un color para [Icon][] usando su propiedad `color`.
Usa la propiedad `Text.style` para fijar la fuente, su color, tamaño, y así sucesivamente.
Columns y rows tienen propiedades que te permiten especificar como se alinearán 
sus hijos vertical u horizontalmente, y cuanto espacio deben ocupar 
los hijos.

## Da layout a un widget

¿Cómo puedes configurar el layout de un único widget? Esta sección te enseña 
como crear y mostrar un simple widget. También muestra el código completo 
para una app Hello World simple.

En Flutter, solo toma unos pocos pasos poner un texto, un icono, o una imagen 
en la pantalla.

### 1. Selecciona un widget de layout

Elige entre una variedad de [widgets de layout][] basándote 
en como quieres alinear o restringir el widget visible,
ya que estas características son normalmente pasadas al 
widget contenido.

Este ejemplo usa [Center][] el cual centra su contenido
horizontal y verticalmente.

### 2. Crea un widget visible

Por ejemplo, crea un widget [Text][]:

<?code-excerpt "layout/base/lib/main.dart (text)" replace="/child: //g"?>
```dart
Text('Hello World'),
```

Crea un widget [Image][]:

<?code-excerpt "layout/lakes/step5/lib/main.dart (Image-asset)" remove="/width|height/"?>
```dart
Image.asset(
  'images/lake.jpg',
  fit: BoxFit.cover,
),
```

Crea un widget [Icon][]:

<?code-excerpt "layout/lakes/step5/lib/main.dart (Icon)"?>
```dart
Icon(
  Icons.star,
  color: Colors.red[500],
),
```

### 3. Añade el widget visible al widget de layout

<?code-excerpt path-base="layout/base"?>

Todos los widgets de layout tiene alguna de las siguientes:

- Una propiedad `child` que toma un único hijo -- por ejemplo, `Center` o
  `Container`
- Una propiedad `children` que toma una lista de widgets -- por ejemplo, `Row`,
  `Column`, `ListView`, o `Stack`.

Añade un widget `Text` al widget `Center`:

<?code-excerpt "lib/main.dart (centered-text)" replace="/body: //g"?>
```dart
Center(
  child: Text('Hello World'),
),
```

### 4. Añade el widget de layout a la página

Una app Flutter es en si misma un widget, y la mayoría de los widgets tienen un método 
[build()][]. Instanciar y devolver un widget en el método `build()` de la app 
muestra el widget.

#### Apps Material

Para una app `Material`, puedes usar un widget [Scaffold][]; este proporciona un banner 
por defecto, color de fondo, y tiene una API para añadir drawers, snack bars, y bottom
sheets. Entonces puedes añadir el widget `Center` directamente a la propiedad `body` para 
la página principal.

<?code-excerpt path-base="layout/base"?>
<?code-excerpt "lib/main.dart (MyApp)" title?>
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter layout demo'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
```

{{site.alert.note}}
  La [biblioteca Material][] implementa widgets que siguen los principios 
  [Material Design][]. Cuando diseñas tu UI, puede usar exclusivamente 
  widgets de la [biblioteca de widgets][] estándar, o puedes usar widgets de 
  la biblioteca Material. Puedes mezclar widgets de ambas bibliotecas, puedes
  personalizar widgets existentes, o puedes construir tu propio conjunto de 
  widgets.
{{site.alert.end}}

#### Apps No-Material

Para una app no-Material, puedes añadir el widget `Center` al método build de 
la app:

<?code-excerpt path-base="layout/non_material"?>
<?code-excerpt "lib/main.dart (MyApp)" title?>
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Text(
          'Hello World',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 32,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
```

Por defecto una app no-Material no incluye un `AppBar`, título, o color de 
fondo. Si quieres estas características en una app no-Material, tienes que construirlas 
tu mismo. Esta app cambia el color de fondo a blanco y el texto a gris 
oscuro para imitar una app Material.

<div class="row">
<div class="col-md-6" markdown="1">
  ¡Esto es todo! Cuando ejecutes la app, debes ver _Hello World_.

  Código fuente de la App:
  - [Material app]({{examples}}/layout/base)
  - [Non-Material app]({{examples}}/layout/non_material)
</div>
<div class="col-md-6">
  {% include app-figure.md img-class="site-mobile-screenshot border w-75"
      image="ui/layout/hello-world.png" alt="Hello World" %}
</div>
</div>

<hr>

## Organiza multiples widgets vertical y horizontalmente

<?code-excerpt path-base=""?>

Uno de los patrones más comunes de layout es organizar los widgets vertical 
u horizontalmente. Puedes usar un widget Row para organizar widgets horizontalmente,
y un widget Column para organizar widgets verticalmente.

{{site.alert.secondary}}
  <h4 class="no_toc">Lo que aprenderás</h4>

  * Row y Column son dos de los más comúnmente usados patrones de layout.
  * Row y Column toman ambos una lista de widgets hijos.
  * Un widget hijo puede ser él mismo un Row, Column, u otro widget complejo.
  * Puedes especificar como un Row o Column alinea sus hijos, tanto vertical 
    como horizontalmente.
  * Puedes estirar o restringir widgets hijo específicos.
  * Puedes especificar como los widgets hijo usa el espacio disponible del Row o Column.
{{site.alert.end}}

Para crear una fila o columna en Flutter, añades una lista de widgets hijo a un widget
[Row][] o [Column][]. Sucesivamente, cada hijo puede ser en si mismo una fila o columna. 
El siguiente ejemplo muestra como es posible anidar filas o columnas
dentro de filas o columnas.

Este layout está organizado como un Row. La fila contiene dos hijos:
una columna en la izquierda, y una imagen en la derecha:

{% asset ui/layout/pavlova-diagram.png class="mw-100"
    alt="Screenshot with callouts showing the row containing two children" %}

El árbol de widgets de la columna izquierda anida filas y columnas.

{% asset ui/layout/pavlova-left-column-diagram.png class="mw-100"
    alt="Diagram showing a left column broken down to its sub-rows and sub-columns" %}

Implementarás algo del layout del código de Pavlova en
[Anidando filas y columnas](#anidando-filas-y-columnas).

{{site.alert.note}}
  Row y Column son widgets primitivos básicos para layout horizontales 
  y verticales&mdash;estos widgets de bajo nivel permiten una personalización 
  máxima. Flutter también ofrece widgets especializados de alto nivel 
  que deben ser suficientes para tus necesidades. Por ejemplo, en lugar de un Row
  podrías preferir 
  [ListTile]({{api}}/material/ListTile-class.html),
  un widget de fácil uso con propiedades para iconos iniciales y finales,
  y hasta 3 líneas de texto. En lugar de Column, podrías preferir
  [ListView]({{api}}/widgets/ListView-class.html),
  un layout de tipo columna que permite el scroll automático si su contenido es demasiado largo
  para ajustarse al espacio disponible. Para más información,
  mira [Widgets de layout comunes](#widgets-de-layout-comunes).
{{site.alert.end}}

### Alineación de widgets

Controlas como una fila o columna alinea sus hijos usando 
las propiedades `mainAxisAlignment` y `crossAxisAlignment`.
Para una fila, el eje principal corre horizontalmente y el eje transversal corre 
verticalmente. Para una columna, el eje principal corre verticalmente y el eje 
transversal corre horizontalmente.

<div class="mb-2 text-center">
  {% asset ui/layout/row-diagram.png class="mb-2 mw-100"
      alt="Diagram showing the main axis and cross axis for a row" %}
  {% asset ui/layout/column-diagram.png class="mb-2 mr-2 ml-2 mw-100"
      alt="Diagram showing the main axis and cross axis for a column" %}
</div>

Las clases [MainAxisAlignment]({{api}}/rendering/MainAxisAlignment-class.html)
y [CrossAxisAlignment]({{api}}/rendering/CrossAxisAlignment-class.html)
ofrecen una variedad de constantes para controlar la alineación.

{{site.alert.note}}
  Cuando añades imágenes a tu proyecto,
  necesitas actualizar el fichero pubspec para acceder a estas&mdash;este
  ejemplo usa `Image.asset` para mostrar imágenes. Para más información,
  mira este ejemplo de [fichero 
  pubspec.yaml]({{examples}}/layout/row_column/pubspec.yaml),
  o [Añadir assets e imágenes en Flutter](/docs/development/ui/assets-and-images).
  No necesitas hacer esto si estas referenciando imágenes online usando 
  `Image.network`.
{{site.alert.end}}

En el siguiente ejemplo, cada una de las 3 imágenes tiene 100 pixels de ancho.
La caja de renderizado (en este caso, la pantalla entera) tiene más de 300 pixeles de ancho,
entonces fijando la alineación del eje principal a `spaceEvenly` divide el espacio libre 
horizontal igualitariamente entre, antes, y después de cada imagen.

<div class="row">
<div class="col-lg-8">
  <?code-excerpt "layout/row_column/lib/main.dart (Row)" replace="/Row/[!$&!]/g"?>
  {% prettify dart context="html" %}
  [!Row!](
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Image.asset('images/pic1.jpg'),
      Image.asset('images/pic2.jpg'),
      Image.asset('images/pic3.jpg'),
    ],
  );
  {% endprettify %}
</div>
<div class="col-lg-4" markdown="1">
  {% asset ui/layout/row-spaceevenly-visual.png class="mw-100" alt="Row with 3 evenly spaced images" %}

  **App source:** [row_column]({{examples}}/layout/row_column)
</div>
</div>

Las columnas trabajan de la misma manera que las filas. El siguiente ejemplo muestra una columna 
de 3 imágenes, cada una de 100 pixels de alto. la altura de la caja de renderizado 
(en este caso, la pantalla entera) tiene más de 300 pixels, entonces 
fijando la alineación en el eje principal a `spaceEvenly` divide el espacio libre vertical 
igualitariamente entre, por encima, y por debajo de cada imagen.

<div class="row">
<div class="col-lg-8" markdown="1">
  <?code-excerpt "layout/row_column/lib/main.dart (Column)" replace="/Column/[!$&!]/g"?>
  {% prettify dart context="html" %}
  [!Column!](
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Image.asset('images/pic1.jpg'),
      Image.asset('images/pic2.jpg'),
      Image.asset('images/pic3.jpg'),
    ],
  );
  {% endprettify %}

  **App source:** [row_column]({{examples}}/layout/row_column)
</div>
<div class="col-lg-4 text-center">
  {% asset ui/layout/column-visual.png class="mb-4" height="250px"
      alt="Column showing 3 images spaced evenly" %}
</div>
</div>

### Dimensionando widgets

Cuando un layout es demasiado grande para ajustarse al dispositivo, una franja con un patrón 
de rayas amarillas y negras
aparece a lo largo del limite afectado. Aquí hay un [ejemplo][sizing] de una fila que es 
demasiado ancha:

{% asset ui/layout/layout-too-large.png class="mw-100" alt="Overly-wide row" %}
{:.text-center}

Los widgtets pueden ser dimensionados para encajar dentro de una fila o columna usando el widget 
[Expanded][]. Para solucionar el ejemplo anterior donde una fila de imágenes es demasiado ancha para su 
caja de renderizado, envuelve cada imagen con un widget `Expanded`.

<div class="row">
<div class="col-lg-8">
  <?code-excerpt "layout/sizing/lib/main.dart (expanded-images)" replace="/Expanded/[!$&!]/g"?>
  {% prettify dart context="html" %}
  Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      [!Expanded!](
        child: Image.asset('images/pic1.jpg'),
      ),
      [!Expanded!](
        child: Image.asset('images/pic2.jpg'),
      ),
      [!Expanded!](
        child: Image.asset('images/pic3.jpg'),
      ),
    ],
  );
  {% endprettify %}
</div>
<div class="col-lg-4" markdown="1">
  {% asset ui/layout/row-expanded-2-visual.png class="mw-100"
      alt="Row of 3 images that are too wide, but each is constrained to take only 1/3 of the space" %}

  **App source:** [sizing]({{examples}}/layout/sizing)
</div>
</div>

Talvez quieras que un widget ocupe el doble de espacio que sus hermanos. Para 
esto, usa la propiedad `flex` del widget `Expanded`, un entero que determina el 
factor flex para un widget. El factor flex por defecto es 1. El siguiente código fija 
el factor flex de la imagen de enmedio en 2:

<div class="row">
<div class="col-lg-8">
  <?code-excerpt "layout/sizing/lib/main.dart (expanded-images-with-flex)" replace="/flex.*/[!$&!]/g"?>
  {% prettify dart context="html" %}
  Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Image.asset('images/pic1.jpg'),
      ),
      Expanded(
        [!flex: 2,!]
        child: Image.asset('images/pic2.jpg'),
      ),
      Expanded(
        child: Image.asset('images/pic3.jpg'),
      ),
    ],
  );
  {% endprettify %}
</div>
<div class="col-lg-4" markdown="1">
  {% asset ui/layout/row-expanded-visual.png class="mw-100"
      alt="Row of 3 images with the middle image twice as wide as the others" %}

  **App source:** [sizing]({{examples}}/layout/sizing)
</div>
</div>

[sizing]: {{examples}}/layout/sizing

### Empaquetar widgets

Por defecto, una fila o columna ocupa tanto espacio como sea posible a lo largo de su eje 
principal, pero si quieres empaquetar los hijos todos juntos,
fija su `mainAxisSize` a `MainAxisSize.min`. El siguiente ejemplo 
usa esta propiedad para empaquetar los iconos de estrella juntos.

<div class="row">
<div class="col-lg-8">
  <?code-excerpt "layout/pavlova/lib/main.dart (stars)" replace="/mainAxisSize.*/[!$&!]/g; /\w+ \w+ = //g; /;//g"?>
  {% prettify dart context="html" %}
  Row(
    [!mainAxisSize: MainAxisSize.min,!]
    children: [
      Icon(Icons.star, color: Colors.green[500]),
      Icon(Icons.star, color: Colors.green[500]),
      Icon(Icons.star, color: Colors.green[500]),
      Icon(Icons.star, color: Colors.black),
      Icon(Icons.star, color: Colors.black),
    ],
  )
  {% endprettify %}
</div>
<div class="col-lg-4" markdown="1">
  {% asset ui/layout/packed.png class="border mw-100"
      alt="Row of 5 stars, packed together in the middle of the row" %}

  **App source:** [pavlova]({{examples}}/layout/pavlova)
</div>
</div>

### Anidar filas y columnas

El layout de flutter te permte anidar filas y columnas dentro de filas y 
columnas tan profundamente como necesites. Veamos el código para la sección bordeada 
del siguiente layout:

{% asset ui/layout/pavlova-large-annotated.png class="border mw-100"
    alt="Screenshot of the pavlova app, with the ratings and icon rows outlined in red" %}
{:.text-center}

La sección bordeada esta implementada como dos filas. La fila de valoraciones contiene 
cinco estrellas y el número de revisiones. La fila de iconos contiene tres columnas de 
iconos y texto.

El árbol de widget para la fila de valoraciones:

{% asset ui/layout/widget-tree-pavlova-rating-row.png class="mw-100" alt="Ratings row widget tree" %}
{:.text-center}

La variable `ratings` crea una fila conteniendo una fila mas pequeña de 5 iconos estrella, 
y texto:

<?code-excerpt "layout/pavlova/lib/main.dart (ratings)" replace="/ratings/[!$&!]/g"?>
```dart
var stars = Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.star, color: Colors.green[500]),
    Icon(Icons.star, color: Colors.green[500]),
    Icon(Icons.star, color: Colors.green[500]),
    Icon(Icons.star, color: Colors.black),
    Icon(Icons.star, color: Colors.black),
  ],
);

final [!ratings!] = Container(
  padding: EdgeInsets.all(20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      stars,
      Text(
        '170 Reviews',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          fontSize: 20,
        ),
      ),
    ],
  ),
);
```

{{site.alert.tip}}
  Para minimizar la confusión visual que puede resultar de código de layout 
  fuertemente anidado, implementa piezas de tu UI en variables y funciones.
{{site.alert.end}}

La fila de iconos, bajo la fila de valoraciones, contiene 3 columnas; cada columna contiene 
un icono y dos líneas de texto, como puedes ver en el árbolo de widgets:

{% asset ui/layout/widget-tree-pavlova-icon-row.png class="mw-100" alt="Icon widget tree" %}
{:.text-center}

La variable `iconList` define la fila de iconos:

<?code-excerpt "layout/pavlova/lib/main.dart (iconList)" replace="/iconList/[!$&!]/g"?>
```dart
final descTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w800,
  fontFamily: 'Roboto',
  letterSpacing: 0.5,
  fontSize: 18,
  height: 2,
);

// DefaultTextStyle.merge() te permite crear un estilo de texto por defecto
// que es heredado por sus hijos y todos los hijos subsecuentes.
final [!iconList!] = DefaultTextStyle.merge(
  style: descTextStyle,
  child: Container(
    padding: EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Icon(Icons.kitchen, color: Colors.green[500]),
            Text('PREP:'),
            Text('25 min'),
          ],
        ),
        Column(
          children: [
            Icon(Icons.timer, color: Colors.green[500]),
            Text('COOK:'),
            Text('1 hr'),
          ],
        ),
        Column(
          children: [
            Icon(Icons.restaurant, color: Colors.green[500]),
            Text('FEEDS:'),
            Text('4-6'),
          ],
        ),
      ],
    ),
  ),
);
```

La variable `leftColumn` contiene las filas de valoraciones y la de iconos, también tiene el 
título y el texto que describe el Pavlova:

<?code-excerpt "layout/pavlova/lib/main.dart (leftColumn)" replace="/leftColumn/[!$&!]/g"?>
```dart
final [!leftColumn!] = Container(
  padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
  child: Column(
    children: [
      titleText,
      subTitle,
      ratings,
      iconList,
    ],
  ),
);
```

La columna izquierda esta ubicada en un `Container` para resitringir su ancho.
Finalmente, la UI es construida con la fila entera (conteniendo la columna 
izquierda y la imagen) dentro de un `Card`.

La [imagen del Pavlova][] es de [Pixabay][].
Puedes incrustar una imagen desde la red usando `Image.network()` pero,
para este ejemplo, la imagen esta guardada en un directorio 'images' en el proyecto, 
añadido al [fichero pubspec,]({{examples}}/layout/pavlova/pubspec.yaml)
y se accede usando `Images.asset()`. Para más información, mira 
[Añadiendo assets e imágenes](/docs/development/ui/assets-and-images).

<?code-excerpt "layout/pavlova/lib/main.dart (body)"?>
```dart
body: Center(
  child: Container(
    margin: EdgeInsets.fromLTRB(0, 40, 0, 30),
    height: 600,
    child: Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 440,
            child: leftColumn,
          ),
          mainImage,
        ],
      ),
    ),
  ),
),
```

{{site.alert.tip}}
  El ejemplo Pavlova corre mejor horizontalmente en un dispositivo ancho, como una tablet.
  Si tu estas ejecutando este ejemplo en un simulador iOS, puedes seleccionar un 
  dispositivo diferente usando el menú **Hardware > Device**. Para este ejemplo, 
  recomendamos el iPad Pro. Puedes cambiar su orientación a modo landscape usando 
  **Hardware > Rotate**. También puedes cambiar el tamaño de la ventan del simulador
  (sin cambiar el número de píxeles lógicos) usando **Window > Scale**.
{{site.alert.end}}

**App source:** [pavlova]({{examples}}/layout/pavlova)

[imagen del Pavlova]: https://pixabay.com/en/photos/pavlova
[Pixabay]: https://pixabay.com/en/photos/pavlova

<hr>

## Widgets de layout comunes

Flutter tiene una rica biblioteca de widgets de layout. Aquí hay algunos de los más 
comúnmente usados. La intención es ponerte en funcionamiento lo más rápidamente posible,
antes que abrumarte con una lista completa. Para información de otros 
widgets disponibles, dirigete al [catálogo de Widgets][],
o usa la búsqueda en la [documentación de referencia de la API]({{api}}).
También, las páginas de widget en la documentación de la API a menudo ofrece sugerencias 
sobre widgets similares que tal vez satisfagan mejor tus necesidades.

Los siguientes widgets caen en dos categorías: widgets estándard de la 
[biblioteca de widgets][], y widgets especializados de la [biblioteca Material][]. Cualquier 
app puede usar la biblioteca de widgets pero solo las apps Material pueden usar la biblioteca 
Material Components.

### Widgets estándar

* [Container](#container): Añade padding, márgenes, bordes, color de fondo, o
  otras decoraciónes a un widget.
* [GridView](#gridview): Organiza widgets en una cuadrícula con scroll.
* [ListView](#listview): Organiza en una lista con scroll.
* [Stack](#stack): Superpon un widget encima de otros.

### Widgets Material

* [Card](#card): Organiza información relacionada en una caja con bordes redondeados y una 
   sombra proyectada.
* [ListTile](#listtile): Organiza hasta 3 lineas de texto, e iconos opcionales al principio o 
   al final, en una fila.

### Container

Muchos layouts hace un uso libre de [Container][]s para separar widgets usando 
padding, o para añadir bordes o márgenes. Puedes cambiar el fondo del dispositivo 
colocando el layout completo en un `Container` y cambiando su color o imagen 
de fondo.

<div class="row">
<div class="col-lg-6" markdown="1">
  <h4 class="no_toc">Resumen (Container)</h4>

  * Añade padding, márgenes, bordes
  * Cambia color o imagen de fondo
  * Contiene un único hijo, pero este hijo puede ser un Row, Column,
    o incluso la raíz del árbol de widget
</div>
<div class="col-lg-6 text-center">
  {% asset ui/layout/margin-padding-border.png class="mb-4 mw-100"
      width="230px"
      alt="Diagram showing: margin, border, padding, and content" %}
</div>
</div>

#### Ejemplos (Container)
{:.no_toc}

Este layout consiste en una columna con dos filas, cada una conteniendo 2 imágenes. Un 
[Container][] es usado para cambiar el color de fondo de la columna a un gris 
claro.

<div class="row">
<div class="col-lg-7">
  <?code-excerpt "layout/container/lib/main.dart (column)" replace="/\bContainer/[!$&!]/g;"?>
  {% prettify dart context="html" %}
  Widget _buildImageColumn() => [!Container!](
        decoration: BoxDecoration(
          color: Colors.black26,
        ),
        child: Column(
          children: [
            _buildImageRow(1),
            _buildImageRow(3),
          ],
        ),
      );
  {% endprettify %}
</div>
<div class="col-lg-5 text-center">
  {% asset ui/layout/container.png class="mb-4 mw-100" width="230px"
      alt="Screenshot showing 2 rows, each containing 2 images" %}
</div>
</div>

Un `Container` también es usado para añadir bordes redondeados y márgenes a cada imagen:

<?code-excerpt "layout/container/lib/main.dart (row)" replace="/\bContainer/[!$&!]/g;"?>
```dart
Widget _buildDecoratedImage(int imageIndex) => Expanded(
      child: [!Container!](
        decoration: BoxDecoration(
          border: Border.all(width: 10, color: Colors.black38),
          borderRadius: const BorderRadius.all(const Radius.circular(8)),
        ),
        margin: const EdgeInsets.all(4),
        child: Image.asset('images/pic$imageIndex.jpg'),
      ),
    );

Widget _buildImageRow(int imageIndex) => Row(
      children: [
        _buildDecoratedImage(imageIndex),
        _buildDecoratedImage(imageIndex + 1),
      ],
    );
```

Puedes encontrar más ejemplos con `Container` en el [tutorial][] y la [Flutter
Gallery][].

**App source:** [container]({{examples}}/layout/container)

<hr>

### GridView

Usa [GridView][] para organizar widgets como una lista bi-dimensional. `GridView`
proporciona dos listas pre-fabricadas, o puedes construir tu propia cuadrícula personalizada. Cuando un 
`GridView` detecta que su contenido es muy grande para ajustarse a la caja de renderizado, este 
automáticamante permite hacer scroll.

#### Resumen (GridView)
{:.no_toc}

* Orgniza widgets en una cuadrícula
* Detecta cuando el contenido de la columna excede la caja de renderizado y automáticamente 
  proporciona scroll
* Construye tu propia cuadrícula personalizada, o usa una de las proporcionadas:
  * `GridView.count` te permite especificar el número de columnas
  * `GridView.extent` te permite especificar el máximo número de píxeles de ancho de una celda
{% comment %}
* Usa `MediaQuery.of(context).orientation` para crear una cuadrícula que cambie su 
  layout dependiendo de que el dispositivo esté en modo landscape o portrait.
{% endcomment %}

{{site.alert.note}}
  Cuando mostramos una lista bi-dimensional en la que es importante cual fila 
  o columna ocupe una celda (por ejemplo,
  es la entrada en la columna "calorias" para la fila "aguacate"), usa
  [Table]({{api}}/widgets/Table-class.html) o
  [DataTable]({{api}}/material/DataTable-class.html).
{{site.alert.end}}

#### Ejemplos (GridView)
{:.no_toc}

<div class="row">
<div class="col-lg-6" markdown="1">
  {% asset ui/layout/gridview-extent.png class="mw-100" alt="A 3-column grid of photos" %}
  {:.text-center}

  Usa `GridView.extent` para crear una cuadrícula con celdas de un ancho máximo de 150 pixels.

  **App source:** [grid_and_list]({{examples}}/layout/grid_and_list)
</div>
<div class="col-lg-6" markdown="1">
  {% asset ui/layout/gridview-count-flutter-gallery.png class="mw-100"
      alt="A 2 column grid with footers" %}
  {:.text-center}

  Usa `GridView.count` para crear una cuadrícula que tenga dos celdas de ancho en modo portrait,
  y 3 celdas de ancho en modo landscape. Las celdas son creadas fijando la propiedad 
  `footer` para cada [GridTile][].

  **Dart code:** [grid_list_demo.dart]({{demo}}/material/grid_list_demo.dart)
  de la [Flutter Gallery][]
</div>
</div>

<?code-excerpt "layout/grid_and_list/lib/main.dart (grid)" replace="/\GridView/[!$&!]/g;"?>
```dart
Widget _buildGrid() => [!GridView!].extent(
    maxCrossAxisExtent: 150,
    padding: const EdgeInsets.all(4),
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    children: _buildGridTileList(30));

// Las imágenes estan guardadas con nombres pic0.jpg, pic1.jpg...pic29.jpg.
// El constructor List.generate() permite una forma sencilla de crear
// una lista cuando los objetos tienen un patrón de nombre predecible.
List<Container> _buildGridTileList(int count) => List.generate(
    count, (i) => Container(child: Image.asset('images/pic$i.jpg')));
```

<hr>

### ListView

[ListView]({{api}}/widgets/ListView-class.html),
un widget similiar a una columna, automáticamente proporciona scroll cuando
su contendido es demasiado grande para su caja de renderizado.

#### Resumen (ListView)
{:.no_toc}

* Un [Column][] especializado para organizar una lista de cajas
* Puede ser organizado horizontal o verticalmente
* Detecta cuando su contenido no puede ser ajustado y proporciona scroll
* Menos configurable que `Column`, pero más fácil de usar y con soporte para scroll

#### Ejemplos (ListView)
{:.no_toc}

<div class="row">
<div class="col-lg-6" markdown="1">
  {% asset ui/layout/listview.png class="border mw-100"
      alt="ListView containing movie theaters and restaurants" %}
  {:.text-center}

  Usa `ListView` para mostrar una lista de negocios usando `ListTile`s. Un `Divider`
  separa los teatros de los restaurantes.

  **App source:** [grid_and_list]({{examples}}/layout/grid_and_list)
</div>
<div class="col-lg-6" markdown="1">
  {% asset ui/layout/listview-flutter-gallery.png class="border mw-100"
      alt="ListView containing shades of blue" %}
  {:.text-center}

  Usa `ListView` para mostrar los [Colors]({{api}}/material/Colors-class.html) de
  la [paleta de Material Design]({{site.material}}/guidelines/style/color.html)
  para una familia particular de color.

  **Dart code:** [colors_demo.dart]({{demo}}/colors_demo.dart) de la 
  [Flutter Gallery][]
</div>
</div>

<?code-excerpt "layout/grid_and_list/lib/main.dart (list)" replace="/\ListView/[!$&!]/g;"?>
```dart
Widget _buildList() => [!ListView!](
      children: [
        _tile('CineArts at the Empire', '85 W Portal Ave', Icons.theaters),
        _tile('The Castro Theater', '429 Castro St', Icons.theaters),
        _tile('Alamo Drafthouse Cinema', '2550 Mission St', Icons.theaters),
        _tile('Roxie Theater', '3117 16th St', Icons.theaters),
        _tile('United Artists Stonestown Twin', '501 Buckingham Way',
            Icons.theaters),
        _tile('AMC Metreon 16', '135 4th St #3000', Icons.theaters),
        Divider(),
        _tile('K\'s Kitchen', '757 Monterey Blvd', Icons.restaurant),
        _tile('Emmy\'s Restaurant', '1923 Ocean Ave', Icons.restaurant),
        _tile(
            'Chaiya Thai Restaurant', '272 Claremont Blvd', Icons.restaurant),
        _tile('La Ciccia', '291 30th St', Icons.restaurant),
      ],
    );

ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      leading: Icon(
        icon,
        color: Colors.blue[500],
      ),
    );
```

<hr>

### Stack

Usa [Stack][] para organizar widgets encima de un widget base&mdash;a menudo una imagen.
Los widgets pueden superponerse completa o parcialmente al widget base.

#### Resumen (Stack)
{:.no_toc}

* Usado por widgets que se superponen a otro widget
* El primer widget en la lista de hijos es el widget base;
  los hijos siguientes son superpuestos encima de este widget base
* El contenido de un `Stack` no puede hacer scroll
* Puedes elegir recortar los hijos que excedan la caja de renderizado

#### Ejemplos (Stack)
{:.no_toc}

<div class="row">
<div class="col-lg-7" markdown="1">
  {% asset ui/layout/stack.png class="mw-100" width="200px" alt="Circular avatar image with a label" %}
  {:.text-center}

  Usa `Stack` para suporponer un `Container` (que muestra su `Text` en un fondo 
  negro tráslucido) encima de un `CircleAvatar`.
  El `Stack` ubica el texto usando la propiedad `alignment` y objetos 
  `Alignment`.

  **App source:** [card_and_stack]({{examples}}/layout/card_and_stack)
</div>
<div class="col-lg-5" markdown="1">
  {% asset ui/layout/stack-flutter-gallery.png class="mw-100" alt="An image with a grey gradient across the top" %}
  {:.text-center}

  Usa `Stack` para superponer un gradiente encima de la imagen. El gradiente 
  asegura que los iconos del toolbar son distintos de la imagen.

  **Dart code:** [contacts_demo.dart]({{demo}}/contacts_demo.dart)
  de la [Flutter Gallery][]
</div>
</div>

<?code-excerpt "layout/card_and_stack/lib/main.dart (Stack)" replace="/\bStack/[!$&!]/g;"?>
```dart
Widget _buildStack() => [!Stack!](
    alignment: const Alignment(0.6, 0.6),
    children: [
      CircleAvatar(
        backgroundImage: AssetImage('images/pic.jpg'),
        radius: 100,
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.black45,
        ),
        child: Text(
          'Mia B',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
```

<hr>

### Card

Un [Card][], de la [biblioteca Material][], contiene fragmentos relacionados de 
información y puede ser compuesto por casi cualquier widget, pero es a menudo usado con 
[ListTile][]. `Card` tiene un solo hijo, pero su hijo puede ser una columna, fila,
lista, cuadrícula, o otro widget que soporte múltiples hijos. Por defecto, un
`Card` encoje su tamaño a 0 por 0 píxeles. Puedes usar [SizedBox][] para restringir 
el tamaño de un card.

En Flutter, un `Card` tiene como característica esquinas ligeramente redondeadas y una 
sombra arrojada, dándole a este un efecto 3D. 
Cambiar la propiedad `elevation` de un `Card` te permite contolar 
el efecto de sombra arrojada. Configurando la elevación a 24, por ejemplo, visualmente eleva 
el `Card` de la superficie y causa que la sombra se vuelva más 
dispersa. Para una lista de valores permitidos de elevación, mira [Elevation][] en las 
[Material guidelines][Material Design]. Especificar un valor no soportado desactiva 
completamente la sombra arrojada.

#### Resumen (Card)
{:.no_toc}

* Implementa un [Material card][]
* Usado para repesentar fragementos relacionados de información
* Acepta un úncio hijo, pero este hijo puede ser un `Row`, `Column`, o otro
  widget que albergue una lista de hijos
* Mostrado con escquinas redondeadas y arroja una sombra
* El contenido de un `Card` no puede hacer scroll
* De la [biblioteca Material][]

#### Ejemplos (Card)
{:.no_toc}

<div class="row">
<div class="col-lg-6" markdown="1">
  {% asset ui/layout/card.png class="mw-100" alt="Card containing 3 ListTiles" %}
  {:.text-center}

  Un `Card` conteniendo 3 ListTiles y dimensionado envolviéndolo con un `SizedBox`. Un
  `Divider` separa el primer del segundo `ListTiles`.

  **App source:** [card_and_stack]({{examples}}/layout/card_and_stack)
</div>
<div class="col-lg-6" markdown="1">
  {% asset ui/layout/card-flutter-gallery.png class="mw-100"
      alt="Card containing an image, text and buttons" %}
  {:.text-center}

  Un `Card` conteniendo una imagen y un texto.

  **Dart code:** [cards_demo.dart]({{demo}}/material/cards_demo.dart)
  de la [Flutter Gallery][]
</div>
</div>

<?code-excerpt "layout/card_and_stack/lib/main.dart (Card)" replace="/\bCard/[!$&!]/g;"?>
```dart
Widget _buildCard() => SizedBox(
    height: 210,
    child: [!Card!](
      child: Column(
        children: [
          ListTile(
            title: Text('1625 Main Street',
                style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('My City, CA 99984'),
            leading: Icon(
              Icons.restaurant_menu,
              color: Colors.blue[500],
            ),
          ),
          Divider(),
          ListTile(
            title: Text('(408) 555-1212',
                style: TextStyle(fontWeight: FontWeight.w500)),
            leading: Icon(
              Icons.contact_phone,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text('costa@example.com'),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
        ],
      ),
    ),
  );
```
<hr>

### ListTile

Usa [ListTile][], un widget de tipo fila especializado de la [biblioteca Material][], para una 
forma sencilla de crear una fila conteniendo hasta 3 líneas de texto e iconos opcionales al inicio 
o al final. `ListTile` es mayormente usado en un [Card][] o
[ListView][], pero puede ser usado en cualquier parte.

#### Resumen (ListTile)
{:.no_toc}

* Una fila especializada que contiene hasta 3 lineas de texto e iconos opcionales
* Menos configurable que un `Row`, pero más fácil de usar
* De la [biblioteca Material][]

#### Ejemplos (ListTile)
{:.no_toc}

<div class="row">
<div class="col-lg-6" markdown="1">
  {% asset ui/layout/card.png class="mw-100" alt="Card containing 3 ListTiles" %}
  {:.text-center}

  Un `Card` conteniendo 3 `ListTiles`.

  **App source:** [card_and_stack]({{examples}}/layout/card_and_stack)
</div>
<div class="col-lg-6" markdown="1">
  {% asset ui/layout/listtile-flutter-gallery.png class="border mw-100" height="200px"
      alt="3 ListTiles, each containing a pull-down button" %}
  {:.text-center}

  Usa `ListTile` para listar 3 tipos de drop down button.<br>
  **Dart code:** [buttons_demo.dart]({{demo}}/material/buttons_demo.dart)
  de la [Flutter Gallery][]
</div>
</div>

<hr>

## Vídeos

Los siguientes vídeos, parte de la serie [Flutter in
Focus](https://www.youtube.com/watch?v=wgTBLj7rMPM&list=PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2), explican 
los widgets Stateless y Stateful.

<iframe width="560" height="315" src="https://www.youtube.com/embed/wE7khGHVkYY?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe> <iframe width="560" height="315" src="https://www.youtube.com/embed/AqCMFXEmf3w?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
[Flutter in Focus playlist](https://www.youtube.com/watch?v=wgTBLj7rMPM&list=PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2)

---

Cada episodio de la serie [Widget of the Week
series](https://www.youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)
se enfoca en un widget. Muchos de ellos incluyen widgets de layout.

<iframe width="560" height="315" src="https://www.youtube.com/embed/b_sQ9bMltGU?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
[Flutter Widget of the Week playlist](https://www.youtube.com/watch?v=yI-8QHpGIP4&index=5&list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)


## Otros Recursos

Los siguientes recursos pueden ayudar cuando escribas código de layout.

* [Tutorial de Layout](/docs/development/ui/layout/tutorial)
: Aprende como construir un layout.
* [Visión general de los Widgets](/docs/development/ui/widgets)
: Describe la mayoría de los widgets disponibles en Flutter.
* [Análogia de HTML/CSS con Flutter](/docs/get-started/flutter-for/web-devs)
: Para aquellos familiarizados con la programación web, esta página mapea las funcionalidades HTML/CSS 
  con las características de Flutter.
* [Flutter Gallery][]
: App Demo mostrando muchos widgets Material Design y otras características de Flutter.
* [Documentación de la API de Flutter]({{api}})
: Documentación de referencia para todas las bibliotecas de Flutter.
* [Tratar con restricciones de caja en Flutter](/docs/development/ui/layout/box-constraints)
: Discute como los widgets son restringidos por sus cajas de renderizado.
* [Añadir Assets e Imágenes en Flutter](/docs/development/ui/assets-and-images)
: Explica como añadir imágenes y otros assets al paquete de tu app.
* [Zero to One with Flutter]({{site.medium}}/@mravn/zero-to-one-with-flutter-43b13fd7b354)
: Una experiencia personal escribiendo su primera app Fluter.

[build()]: {{api}}/widgets/StatelessWidget/build.html
[Card]: {{api}}/material/Card-class.html
[Center]: {{api}}/widgets/Center-class.html
[Column]: {{api}}/widgets/Column-class.html
[Container]: {{api}}/widgets/Container-class.html
[Elevation]: {{site.material}}/design/environment/elevation.html
[Expanded]: {{api}}/widgets/Expanded-class.html
[Flutter Gallery]: {{site.repo.flutter}}/tree/master/examples/flutter_gallery
[GridView]: {{api}}/widgets/GridView-class.html
[GridTile]: {{api}}/material/GridTile-class.html
[Icon]: {{api}}/material/Icons-class.html
[Image]: {{api}}/widgets/Image-class.html
[widgets de layout]: /docs/development/ui/widgets/layout
[ListTile]: {{api}}/material/ListTile-class.html
[ListView]: {{api}}/widgets/ListView-class.html
[Material card]: {{site.material}}/design/components/cards.html
[Material Design]: {{site.material}}/design
[biblioteca Material]: {{api}}/material/material-library.html
[Row]: {{api}}/widgets/Row-class.html
[Scaffold]: {{api}}/material/Scaffold-class.html
[SizedBox]: {{api}}/widgets/SizedBox-class.html
[Stack]: {{api}}/widgets/Stack-class.html
[Text]: {{api}}/widgets/Text-class.html
[tutorial]: /docs/development/ui/layout/tutorial
[biblioteca de widgets]: {{api}}/widgets/widgets-library.html
[catálogo de Widgets]: /docs/development/ui/widgets
