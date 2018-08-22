---
layout: tutorial
title: "Construyendo Layouts en Flutter"

permalink: /tutorials/layout/
---

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>Lo que aprenderás:</b>

* Como trabaja el mecanismo de layout de Flutter.
* Como disponer widgets vertical y horizontalmente.
* Como construir un layout en Flutter.

</div>

Esta es una guía para construir layouts en Flutter.
Construirás el layout para la siguiente captura de pantalla:

<img src="images/lakes.jpg" style="border:1px solid black" alt="aplicación lagos terminada que construirás en 'Construyendo un Layout'">

Esta guía da un paso atrás para explicar el enfoque de Flutter para los layouts
y muestra como colocar un solo widget en la pantalla.
Después de una discusión sobre como disponer widgets horizontal y verticalmente,
algunos de los widgets de layout más comunes son cubiertos.

* [Construyendo un layout](#building)
  * [Paso 0: Preparar](#step-0)
  * [Paso 1: Esquema del layout](#step-1)
  * [Paso 2: Implementar la fila 'title'](#step-2)
  * [Paso 3: Implementar la fila 'button'](#step-3)
  * [Paso 4: Implementar la sección de texto](#step-4)
  * [Paso 5: Implementar la sección de la imagen](#step-5)
  * [Paso 6: Poner todo junto](#step-6)
* [Enfoque de los layouts en Flutter](#approach)
* [Layout de un widget](#lay-out-a-widget)
* [Layout de múltiples widgets vertical y horizontalmente](#rows-and-columns)
  * [Alineando widgets](#alignment)
  * [Dimensionando widgets](#sizing)
  * [Empaquetando widgets](#packing)
  * [Anidar filas y columnas](#nesting)
* [Widgets de layout comunes](#common-layout-widgets)
  * [Widgets Standard](#standard-widgets)
  * [Material Components](#material-components)
* [Recursos](#resources)

<a name="building"></a>
## Construyendo un layout

Si buscas tener una "visión general" para entender el mecanismo de los layouts,
empieza con [Enfoque de los layouts en Flutter](#approach).

<a name="step-0"></a>
### Paso 0: Preparar

Primero, obtén el código:

* Asegúrate de haber [configurado](/get-started/install/) tu entorno.
* [Crea una app Flutter básica](/get-started/test-drive/#create-app).

Después, añade la imagen al ejemplo:

* Crea un directorio `images` en el raíz del proyecto.
* Añade
 [`lake.jpg`](https://github.com/flutter/website/blob/master/src/_includes/code/layout/lakes/images/lake.jpg).
  (Nota: `wget` no funcionará para guardar este archivo binario.)
* Actualiza el fichero
  [`pubspec.yaml`](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/pubspec.yaml)
  para incluir una etiqueta `assets`. Esto hace que la imagen este disponible para tu código.

<hr>

<a name="step-1"></a>
### Paso 1: Esquema del layout

El primer paso es dividir el layout en sus elementos básicos:

* Identifica las filas y las columnas.
* ¿Debe el layout incluir un grid?
* ¿Tiene elementos en capas superpuestas?
* ¿Necesita el UI tabs?
* Observa que áreas requieren alineación, padding o bordes.

Primero, identifica los elementos más grandes. En este ejemplo, cuatro elementos están
organizados en una columna: una imagen, dos filas, y un bloque de texto.

<img src="images/lakes-diagram.png" alt="Esquematizando las filas en la captura de pantalla de 'lakes'">

Después, esquematiza cada fila. La primera fila, llamada 'Title section',
 tiene 3 hijos: una columna de texto, un icono estrella,
y un número. Su primer hijo, la columna, contiene 2 líneas de texto.
Esta primera columna toma mucho espacio, por lo tanto debe ser envuelto en un 
widget Expanded.

<img src="images/title-section-diagram.png" alt="esquematiza los widgets en la sección Título">

La segunda fila, llamada la 'Button section', también tiene 
3 hijos: cada hijo es una columna que contiene un icono y un texto.

<img src="images/button-section-diagram.png" alt="esquematiza los widgets en la sección button">

Cuando el layout ha sido esquematizado, es más fácil tomar un enfoque ascendente 
para implementarlo. Para reducir la confusión visual
de código de layout profundamente anidado, ubica alguna de su implementación
en variables y funciones.

<a name="step-2"></a>
### Paso 2: Implementar la fila 'title'

Primero, construirás la columna izquierda en la sección 'title'. Poniendo un Column
dentro de un widget Expanded extiendes la columna para usar todo el espacio libre 
restante en la fila. Ajustando la propiedad `crossAxisAlignment` a
`CrossAxisAlignment.start` posicionamos la columna al principio de la fila.

Poniendo la primera fila de texto dentro de un Container posibilitamos la adicción de padding.
El segundo hijo en Column, también texto, se dibuja gris.

Los dos últimos elementos en la fila 'title' son un icono estrella, dibujado rojo,
y un texto "41". Pon la fila entera en un Container y dale un padding de 32 pixels
 a lo largo de cada borde.

Aquí está el código que implementa la fila 'title'.

<aside class="alert alert-info" markdown="1">
**Nota:**
Si tienes problemas, puedes verificar tu código en
[`lib/main.dart`](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/main.dart)
en GitHub.
</aside>

<!-- code/layout/lakes/main.dart -->
<!-- skip -->
{% prettify dart %}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Oeschinen Lake Campground',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Kandersteg, Switzerland',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('41'),
        ],
      ),
    );
  //...
}
{% endprettify %}

<aside class="alert alert-success" markdown="1">
<i class="fa fa-lightbulb-o"> </i> **Consejo:**
Cuando pegas código en tu app, la identación puede estropearse.
 Puedes corregir esto en tu editor de Flutter 
 usando el [soporte de reformateado automático](/formatting/).
</aside>

<aside class="alert alert-success" markdown="1">
<i class="fa fa-lightbulb-o"> </i> **Consejo:**
Para una experiencia de desarrollo más rápida, prueba la funcionalidad hot reload de Flutter.
Hot reload te permite modificar tu código y ver los cambios sin tener que
arrancar de nuevo por completo la app. Con el soporte para Flutter de los IDEs
['hot reload on save'](/hot-reload/), o desencadenándolo por línea de comandos.
Para más información sobre recargas, mira [Hot Reloads vs. Reiniciar por completo la App](/using-ide/#hot-reloads-vs-full-application-restarts).
</aside>

<a name="step-3"></a>
### Paso 3: Implementa la fila 'button'

La sección 'button' contiene 3 columnas que usan el mismo layout&mdash;un 
icono sobre una fila de texto. Las columnas en esta fila están espaciadas uniformemente,
y el texto y los iconos están dibujados con el color primario,
que está establecido azul en el método `build()` de la app:

<!-- code/layout/lakes/main.dart -->
<!-- skip -->
{% prettify dart %}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //...

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

    //...
}
{% endprettify %}

Dado que el código para construir cada fila será casi idéntico,
es más eficiente crear una función anidada, como `buildButtonColumn()`,
que toma un Icon y un Text, y devuelve una columna con estos widgets
dibujados en el color primario.

<!-- code/layout/lakes/main.dart -->
<!-- skip -->
{% prettify dart %}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //...

    Column buildButtonColumn(IconData icon, String label) {
      Color color = Theme.of(context).primaryColor;

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }
  //...
}
{% endprettify %}

La función build añade el icono directamente a la columna. Pone
el texto en un Container para añadir padding alrededor del texto,
separándolo del icono.

Construye la fila que contiene estas columnas llamando a la función y 
pasando el [icon](https://docs.flutter.io/flutter/material/Icons-class.html)
y el texto específico de cada columna. Alinea las columnas a lo largo de su
eje principal usando `MainAxisAlignment.spaceEvenly` para organizar el espacio
 libre equitativamente antes, entre y después de cada columna.

<!-- code/layout/lakes/main.dart -->
<!-- skip -->
{% prettify dart %}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //...

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.call, 'CALL'),
          buildButtonColumn(Icons.near_me, 'ROUTE'),
          buildButtonColumn(Icons.share, 'SHARE'),
        ],
      ),
    );
  //...
}
{% endprettify %}

<a name="step-4"></a>
### Paso 4: Implementar la sección de texto

Define la sección de texto, que es bastante larga, como una variable.
Pon el texto en un Container para habilitar el poder añadir 32 pixels de padding
a lo largo de cada borde. La propiedad `softwrap` indica como deberá romperse el texto 
en saltos de línea suaves, como puntos o comas.

<!-- code/layout/lakes/main.dart -->
<!-- skip -->
{% prettify dart %}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //...
    Widget textSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Text(
        '''
Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.
        ''',
        softWrap: true,
      ),
    );
  //...
}
{% endprettify %}

<a name="step-5"></a>
### Paso 5: Implementar la sección de la imagen

Tres de las cuatro columnas están completas, solo queda la imagen.
Esta imagen está [disponible 
online](https://images.unsplash.com/photo-1471115853179-bb1d604434e0?dpr=1&amp;auto=format&amp;fit=crop&amp;w=767&amp;h=583&amp;q=80&amp;cs=tinysrgb&amp;crop=)
bajo licencia Creative Commons, pero es grande y lenta de obtener.
En el [Paso 0](#step-0) incluiste la imagen en el proyecto actualizando el 
[fichero pubspec,](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/pubspec.yaml)
ahora puedes referenciarla desde tu código:

<!-- code/layout/lakes/main.dart -->
<!-- skip -->
{% prettify dart %}
return MaterialApp(
//...
body: ListView(
  children: [
    Image.asset(
      'images/lake.jpg',
      height: 240.0,
      fit: BoxFit.cover,
    ),
    // ...
  ],
),
//...
);
{% endprettify %}

`BoxFit.cover` dice al framework que la imagen debe ser tan pequeña como sea
posible pero cubriendo enteramente su render box.

<a name="step-6"></a>
### Paso 6: Poner todo junto

En el último paso, ensamblarás todas las piezas juntas. Los widgets están organizados
en un ListView, mejor que en un Column, porque el ListView posibilita el scroll
cuando se ejecuta la aplicación en dispositivos pequeños.

<!-- skip -->
<!-- code/layout/lakes/main.dart -->
{% prettify dart %}
//...
return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Top Lakes'),
        ),
        body: ListView(
          children: [
            Image.asset(
              'images/lake.jpg',
              width: 600.0,
              height: 240.0,
              fit: BoxFit.cover,
            ),
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
      ),
    );
//...
{% endprettify %}

**Código Dart:** [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/main.dart)<br>
**Imagen:** [imágenes](https://github.com/flutter/website/tree/master/src/_includes/code/layout/lakes/images)<br>
**Pubspec:** [pubspec.yaml](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/pubspec.yaml)

!Esto es¡ Cuando la app hace hot reload, deberías ver el mismo layout
mostrado en las capturas de pantalla. Puedes añadir interactividad a este layout siguiendo 
[Agregando interactividad a Tu Aplicación Flutter](/tutorials/interactive/).

<hr>
<a name="approach"></a>
## Enfoque de los layouts en Flutter

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* Los widgets son clases usadas para construir UIs.
* Los widgets son usados por ambos, layout y elementos de la UI.
* Componer widgets simples para construir widgets complejos.

</div>

El núcleo del mecanismo de layout de Flutter son los widgets. En Flutter, casi 
todo es un widget&mdash;incluso los modelos de layout son widgets.
Las imágenes, iconos, y texto que ves en una aplicación Flutter son todos widgets.
Pero cosas que no ves son también widgets, como son los rows, columns,
y grids que organizan, restringen, y alinean los widgets visibles.

Creas un layout componiendo widgets para construir widgets más complejos.
Por ejemplo, la captura de pantalla a la izquierda muestra 3 iconos con una etiqueta bajo
cada uno:

<img src="images/lakes-icons.png" style="border:1px solid black" alt="layout de ejemplo">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/lakes-icons-visual.png" style="border:1px solid black" alt="layout de ejemplo con depuración visual encendida">

La segunda captura de pantalla muestra el layout visualmente, mostrando una fila de 
3 columnas donde cada columna contiene un icono y una etiqueta.

<aside class="alert alert-info" markdown="1">
**Nota:** La mayoría de las capturas de pantalla en este tutorial son mostrados con
`debugPaintSizeEnabled` establecido a true por eso puedes ver la representación visual del layout.
Para más información , mira
[Depuración visual](/debugging/#visual-debugging), una sección en 
[Depurando Apps en Flutter](/debugging/).
</aside>

Aquí está un diagrama del árbol de widgets para este UI:

<img src="images/sample-flutter-layout.png" alt="árbol de nodos representando el ejemplo de layout">

La mayoría de esto debería verse como es de esperar, pero es posible que te preguntes
sobre los Containers (mostrados en rosa). Container es un widget que te permite
personalizar su widget hijo. Usa un Container cuando quieras añadir 
padding, márgenes, bordes, o un color de background, por nombrar alguna de sus 
capacidades.

En este ejemplo, cada widget Text es colocado en un Container para añadir márgenes.
El Row entero está también colocado en un Container para añadir padding alrededor de la fila.

El resto del UI en este ejemplo es controlado por sus propiedades.
Establece un color para el Icon usando su propiedad `color`.
Usa la propiedad `style` de Text para fijar la fuente, su color, grosor, etc.
Columns y Rows tienen propiedades que permiten especificar como sus
hijos son alineados vertical u horizontalmente, y cuanto espacio deberían ocupar.

<hr>

<a name="lay-out-a-widget"></a>
## Layout de un widget

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

{% comment %}
* Crear un widget [imagen](https://docs.flutter.io/flutter/widgets/Image-class.html),
  [Icon](https://docs.flutter.io/flutter/widgets/Icon-class.html),
  o [Text](https://docs.flutter.io/flutter/widgets/Text-class.html).
* Añadirlo a un widget de layout, como un
  [Center](https://docs.flutter.io/flutter/widgets/Center-class.html),
  [Align](https://docs.flutter.io/flutter/widgets/Align-class.html),
  [SizedBox](https://docs.flutter.io/flutter/widgets/SizedBox-class.html),
  o [ListView](https://docs.flutter.io/flutter/widgets/ListView-class.html),
  por nombrar algunos.
* Añadir el widget de layout a la raíz del árbol de widgets.
{% endcomment %}
* Incluso la aplicación en sí es un widget.
* Es fácil crear un widget y añadirlo a un widget de layout.
* Para mostrar el widget en el dispositivo, añade el widget de layout al widget app.
* Es más fácil usar
  [Scaffold](https://docs.flutter.io/flutter/material/Scaffold-class.html),
  un widget de la biblioteca Material Components, que provée un banner por defecto,
  un color de background, y tiene una API para añadir drawers, snack bars,
  y bottom sheets.
* Si lo prefieres, puedes construir una aplicación que solo use widgets standard de 
  la biblioteca de widgets.

</div>

Como hacer el layout de un widget simple en Flutter?
Esta sección enseña como crear un widget simple y mostrarlo en la pantalla.
También muestra el código completo para una sencilla aplicación Hello World.

En Flutter,
toma solo unos pocos paso poner texto, un icono, o una imagen en la pantalla.

<ol markdown="1">

<li markdown="1"> Elige un widget de layout para sostener el objeto.<br>
    Elige entre una variedad de [widgets de layout](/widgets/) basándote
    en como quieres alinear o restringir el widget visible,
    ya que estas características generalmente se transmiten al widget contenido.
    Este ejemplo usa Center el cual centra su contenido
    horizontal y verticalmente.
</li>

<li markdown="1"> Crea un widget para sostener el objeto visible.<br>

<aside class="alert alert-info" markdown="1">
**Nota:**
Las aplicaciones en Flutter están escritas en el [lenguaje Dart](https://www.dartlang.org/).
Si conoces Java o lenguajes orientados a objetos similares, Dart
lo sentirás muy familiar. Si no, deberías probar
[DartPad](https://www.dartlang.org/tools/dartpad), un playground interactivo de Dart
que puedes usar en cualquier navegador. El 
[Language Tour](https://www.dartlang.org/guides/language) proporciona una visión general 
de las características del lenguaje Dart.
</aside>

Por ejemplo, crea un widget Text:

<!-- skip -->
{% prettify dart %}
Text('Hello World', style: TextStyle(fontSize: 32.0))
{% endprettify %}

Crea un widget Image:

<!-- skip -->
{% prettify dart %}
Image.asset('images/myPic.jpg', fit: BoxFit.cover)
{% endprettify %}

Crea un widget Icon:

<!-- skip -->
{% prettify dart %}
Icon(Icons.star, color: Colors.red[500])
{% endprettify %}

</li>

<li markdown="1"> Añade el widget visible al widget de layout.<br>
    Todos los widgets de layout tienen una propiedad `child` si este toma un único
    hijo (por ejemplo, Center o Container),
    o una propiedad `children` si este toma una lista de widgets (por ejemplo,
    Row, Column, ListView, o Stack).

Añade el widget Text al widget Center:

<!-- skip -->
{% prettify dart %}
Center(
  child: Text('Hello World', style: TextStyle(fontSize: 32.0))
{% endprettify %}

</li>

<li markdown="1"> Añade el widget de layout a la página.<br>
   Una aplicación Flutter es, en sí misma, un widget y la mayoría de los widgets tienen un
   método [build()](https://docs.flutter.io/flutter/widgets/StatelessWidget/build.html).
   Declarando el widget en el método build de la app se muestra el widget
   en el dispositivo.

   Para una aplicación Material, puedes añadir el widget Center directamente a la
  propiedad `body` de la página principal.

<!-- code/layout/hello-world/main.dart -->
<!-- skip -->
{% prettify dart %}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('Hello World', style: TextStyle(fontSize: 32.0)),
      ),
    );
  }
}
{% endprettify %}

<aside class="alert alert-info" markdown="1">
**Nota:**
La biblioteca Material Components implementa widgets que siguen los
[principios de Material Design](https://material.io/guidelines/).
Cuando diseñas tu UI, puedes usar widgets exclusivamente de la
[biblioteca de widgets](https://docs.flutter.io/flutter/widgets/widgets-library.html) standard,
o puedes usar widgets de [Material Components](https://docs.flutter.io/flutter/material/material-library.html).
Puedes mezclar widgets de ambas bibliotecas,
puedes personalizar widgets existentes,
o puedes construir tu propio conjunto de widgets personalizados.
</aside>

Para una app no basada en Material, puedes añadir el widget Center al método `build()`
de la app:

<!-- code/layout/widgets-only/main.dart -->
<!-- skip -->
{% prettify dart %}
// Esta app no usa Material Components, como es Scaffold.
// Normalmente, una app que no usa Scaffold tiene un fondo negro
// y el color por defecto del texto es negro. Esta app cambia su fondo
// a blanco y el color de su texto a gris oscuro para imitar una app Material.
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Text('Hello World',
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 40.0, color: Colors.black87)),
      ),
    );
  }
}
{% endprettify %}

Note que, por defecto, las aplicaciones que no usan Material no tienen un AppBar, título,
o color de fondo. Si tú quieres estas características en una aplicación que no usa Material,
tienes que construirlas tú mismo. Esta app cambia el color de fondo a blanco
y el texto a gris oscuro para imitar una app Material.

</li>

</ol>

!Esto es todo¡ Cuando ejecutas la app, deberías ver:

<img src="images/hello-world.png" style="border:1px solid black" alt="captura de pantalla de un fondo blanco con 'Hello World' en gris.">

**Código Dart** (Material app): [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/hello-world/main.dart)<br>
**Código Dart** (widgets-only app): [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/widgets-only/main.dart)

<hr>

<a name="rows-and-columns"></a>
## Layout de múltiples widgets horizontal y verticalmente

Uno de los patrones de layout más comunes es organizar los widgets vertical
u horizontalmente. Puedes usar un widget Row para organizar widgets horizontalmente,
and a Column widget to arrange widgets vertically.

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* Row y Column son dos de los patrones de layout más comúnmente usados.
* Ambos, Row y Column, toman una lista de widgets hijos.
* Un widget hijo puede ser así mismo un Row, Column, u otro widget complejo.
* Puedes especificar como un Row o un Column alinea sus hijos, vertical
  y horizontalmente.
* Puedes especificar ajustes o restricciones a los widgets hijos.
* Puedes especificar como los widgets hijos, del Row o Column, usan el espacio disponible.

</div>

### Contenidos

* [Alineando widgets](#alignment)
* [Dimensionando widgets](#sizing)
* [Empaquetando widgets](#packing)
* [Anidando filas y columnas](#nesting)

Para crear una fila o una columna en Flutter, añades una lista de widgets hijos a un 
widget [Row](https://docs.flutter.io/flutter/widgets/Row-class.html) o
[Column](https://docs.flutter.io/flutter/widgets/Column-class.html).
A su vez, cada hijo puede ser en sí mismo una fila o una columna, y así sucesivamente.
El ejemplo siguiente muestra como es posible anidar filas o columnas dentro de otras filas o columnas.

Este layout esta orginzado como un Row. La fila contiene dos hijos:
una columna en la izquierda, y una imagen en la derecha:


<center><img src="images/pavlova-diagram.png" alt="captura de pantalla con llamadas mostrando la fila conteniendo dos hijos: una columna y una imagen."></center><br>

El árbol de widgets de la columna izquierda anida filas y columnas.

<center><img src="images/pavlova-left-column-diagram.png" alt="diagrama mostrando una columna izquierda dividida en sus sub-filas y sub-columnas"></center><br>

Implementarás algo del código del layout de Pavlova en
[Anidando filas y columnas](#nesting).

<aside class="alert alert-info" markdown="1">
**Nota:** Row y Column son widgets primarios básicos para hacer layouts
horizontales y verticales&mdash;estos widgets de bajo nivel permiten una 
personalización máxima. Flutter también ofrece widgets especializados de alto nivel,
que deben ser suficientes para tus necesidades. Por ejemplo, en lugar de un Row
quizás prefieras 
[ListTile](https://docs.flutter.io/flutter/material/ListTile-class.html),
un widget fácil de usar con propiedades para iconos delanteros y traseros,
y hasta 3 líneas de texto. En lugar de Column, quizás prefieras
[ListView](https://docs.flutter.io/flutter/widgets/ListView-class.html),
un layout similar a una columna que permite automáticamente el scroll si su contenido 
es demasiado largo para el espacio disponible. Par más información,
mira [Widgets de layout comunes](#common-layout-widgets).
</aside>

<a name="alignment"></a>
### Alineando widgets

Tu controlas como una fila o una columna alinea sus hijos usando las propiedades 
`mainAxisAlignment` y `crossAxisAlignment`.
Para una fila, el eje principal, _Main Axis_, discurre horizontalmente y el eje transversal, _Cross Axis_, discurre verticalmente.
Para una columna, el eje principal, _Main Axis_, discurre verticalmente y el eje transversal, _Cross Axis_, discurre horizontalmente.

<div class="row"> <div class="col-md-6" markdown="1">

<p></p>
<img src="images/row-diagram.png" alt="diagrama mostrando el eje principal y transversal de una fila">

</div> <div class="col-md-6" markdown="1">

<img src="images/column-diagram.png" alt="diagrama mostrando el eje principal y transversal de una columna">

</div> </div>

Las clases [MainAxisAlignment](https://docs.flutter.io/flutter/rendering/MainAxisAlignment-class.html)
y [CrossAxisAlignment](https://docs.flutter.io/flutter/rendering/CrossAxisAlignment-class.html)
ofrecen una variedad de constantes para controlar el alineamiento.

<aside class="alert alert-info" markdown="1">
**Nota:** Cuando añades imágenes a tu proyecto,
necesitas actualizar el fichero pubspec para acceder a ellas&mdash;este
ejemplo usa `Image.asset` para mostrar las imágenes. Para más información,
mira este ejemplo del [fichero pubspec.yaml](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/row/pubspec.yaml),
o [Añadir Assets e imágenes en Flutter](/assets-and-images).
No necesitas hacer esto si estas referenciando imágenes online usando
`Image.network`.
</aside>

En el siguiente ejemplo, cada una de las 3 imágenes tiene 100 píxeles de ancho.
El _render box_ (en este caso, la pantalla entera) tiene más de 300 píxeles de ancho,
entonces fijando la alineación en el _main axis_ a `spaceEvenly` divides el espacio horizontal 
libre equitativamente entre, después y antes de cada imagen.

<div class="row"> <div class="col-md-8" markdown="1">

{% include includelines filename="code/layout/row/main.dart" start=40 count=8 %}

</div> <div class="col-md-3" markdown="1">

<center><img src="images/row-spaceevenly-visual.png" style="border:1px solid black" alt="una fila mostrando 3 imágenes repartidas equitativamente en la fila"></center>

**Código Dart:** [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/row/main.dart)<br>
**Imágenes:** [imágenes](https://github.com/flutter/website/tree/master/src/_includes/code/layout/row/images)<br>
**Pubspec:** [pubspec.yaml](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/row/pubspec.yaml)

</div> </div>

Las columnas trabajan de la misma manera que las filas. El siguiente ejemplo muestra una columna 
de 3 imágenes, cada una tiene 100 píxeles de alto. La altura del _render box_
(en este caso, la pantalla entera) tiene más de 300 píxeles, entonces 
fijando el _main axis_ a `spaceEvenly` divides el espacio vertical
libre equitativamente entre, por encima, y por debajo de cada imagen.

<div class="row"> <div class="col-md-8" markdown="1">

{% include includelines filename="code/layout/column/main.dart" start=40 count=8 %}

**Código Dart:** [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/column/main.dart)<br>
**Imágenes:** [imágenes](https://github.com/flutter/website/tree/master/src/_includes/code/layout/column/images)<br>
**Pubspec:** [pubspec.yaml](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/column/pubspec.yaml)

</div> <div class="col-md-3" markdown="1">

<img src="images/column-visual.png" style="border:1px solid black" alt="una columna mostrando 3 imágenes espaciadas equitativamente en la columna">

</div> </div>

<aside class="alert alert-info" markdown="1">
**Nota:**
Cuando un layout es demasiado grande para ajustarse al dispositivo, una tira roja aparece a lo largo del borde afectado. Por ejemplo, la fila en la siguiente captura de pantalla es demasiado ancho para 
la pantalla del dispositivo:

<center><img src="images/layout-too-large.png" style="border:1px solid black" alt="una fila que es demasiado ancha, mostrando una tira roja a lo largo de su borde derecho"></center>

Los widgets pueden ser dimensionados para caber dentro de una fila o una columna usando un widget Expanded, 
que es descrito en la sección [Dimensionando widgets](#sizing) más abajo.
</aside>

<a name="sizing"></a>
### Dimensionando widgets

Quizás quieras que un widget ocupe el doble de espacio que sus hermanos.
Puedes situar el hijo de una fila o una columna en un widget 
[Expanded](https://docs.flutter.io/flutter/widgets/Expanded-class.html)
para controlar el dimensionado del widget a lo largo del _main axis_.
El widget Expanded widget tiene una propiedad `flex`, un entero que determina
el factor _flex_ para un widget. El valor por defecto del factor _flex_ 
para un widget Expanded es 1.

Por ejemplo, para crear una fila de tres widgets en la cual el widget central es el doble
de ancho que los otros dos widgets, establece el factor _flex_ del widget central a 2:

<div class="row"> <div class="col-md-8" markdown="1">

{% include includelines filename="code/layout/row-expanded/main.dart" start=40 count=15 %}

</div> <div class="col-md-3" markdown="1">

<img src="images/row-expanded-visual.png" style="border:1px solid black" alt="una fila de 3 imágenes con la imagen del cenro el doble de ancho que las otras">

**Código Dart:** [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/row-expanded/main.dart)<br>
**Imágenes:** [imágenes](https://github.com/flutter/website/tree/master/src/_includes/code/layout/row-expanded/images)<br>
**Pubspec:** [pubspec.yaml](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/row-expanded/pubspec.yaml)

</div> </div>

Para corregir en el ejemplo anterior donde la fila de 3 imágenes fue 
demasiado ancho para su _render box_, y resulto en una tira roja,
envuelve cada widget en un widget Expanded.
Por defecto, cada widget tiene un factor _flex_ de 1, asignando un tercio de la fila 
a cada widget.

<div class="row"> <div class="col-md-8" markdown="1">

{% include includelines filename="code/layout/row-expanded-2/main.dart" start=40 count=14 %}

</div> <div class="col-md-3" markdown="1">

<img src="images/row-expanded-2-visual.png" style="border:1px solid black" alt="una fila de 3 imágenes que son demasiado anchas, pero cada una está restringida para coger solo 1/3 del espacio disponible de su fila">

**Código Dart:** [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/row-expanded-2/main.dart)<br>
**Imágenes:** [imágenes](https://github.com/flutter/website/tree/master/src/_includes/code/layout/row-expanded-2/images)<br>
**Pubspec:** [pubspec.yaml](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/row-expanded-2/pubspec.yaml)

</div> </div>

<a name="packing"></a>
### Empaquetando widgets

Por defecto, una fila o columna ocupa tanto espacio a lo largo de su _main axis_ 
como sea posible, pero si quieres empaquetar a los hijos más juntos,
establece su `mainAxisSize` a `MainAxisSize.min`. El siguiente ejemplo 
usa esta propiedad para empaquetas los iconos estrella juntos.

<div class="row"> <div class="col-md-8" markdown="1">

<!-- code/layout/packed/main.dart -->
<!-- skip -->
{% prettify dart %}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var packedRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.green[500]),
        Icon(Icons.star, color: Colors.green[500]),
        Icon(Icons.star, color: Colors.green[500]),
        Icon(Icons.star, color: Colors.black),
        Icon(Icons.star, color: Colors.black),
      ],
    );

  // ...
}
{% endprettify %}

</div> <div class="col-md-3" markdown="1">

<img src="images/packed.png" style="border:1px solid black" alt="una fila de 5 estrellas, empaquetadas juntas en el medio de una fila">

**Código Dart:** [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/packed/main.dart)<br>
**Iconos:** [Icons class](https://docs.flutter.io/flutter/material/Icons-class.html)<br>
**Pubspec:** [pubspec.yaml](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/packed/pubspec.yaml)

</div> </div>

<a name="nesting"></a>
### Anidando filas y columnas

El framework de layouts te permite anidar filas y columnas dentro de otras filas 
y columnas tan profundamente como necesites. Echa un vistazo al código para la 
sección enmarcada del siguiente layout:

<img src="images/pavlova-large-annotated.png" style="border:1px solid black" alt="una captura de pantallas de la app pavlova, con las filas de puntuaciones e iconos remarcados en rojo">

La sección remarcada está implementada como dos filas. La fila de puntuaciones contiene 
cinco estrellas y el número de opiniones. La fila de iconos contiene tres columnas 
de iconos y texto.

El árbol de widgets para la fila de puntuaciones:

<center><img src="images/widget-tree-pavlova-rating-row.png" alt="un árbol de nodos mostrando los widgets en la fila de puntuaciones"></center><br>

La variable `ratings` crea una fila conteniendo un fila más pequeña de 5 iconos estrella, 
y texto:

<!-- code/layout/pavlova/main.dart -->
<!-- skip -->
{% prettify dart %}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //...

    var ratings = Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.black),
              Icon(Icons.star, color: Colors.black),
              Icon(Icons.star, color: Colors.black),
              Icon(Icons.star, color: Colors.black),
              Icon(Icons.star, color: Colors.black),
            ],
          ),
          Text(
            '170 Reviews',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
    //...
  }
}
{% endprettify %}

<aside class="alert alert-success" markdown="1">
<i class="fa fa-lightbulb-o"> </i> **Consejo:**
Para minimizar la confusión visual que puede resultar del código para un layout 
fuertemente anidado, implementa piezas de la UI en variables y funciones.
</aside>

La fila de iconos, bajo la fila de puntuaciones, contiene 3 columnas; cada columna contiene 
un icono y dos líneas de texto, como puedes ver en el árbol de widgets:

<img src="images/widget-tree-pavlova-icon-row.png" alt="un árbol de nodes para los widgets en la fila de iconos">

La variable `iconList` define la fila de iconos:

<!-- code/layout/pavlova/main.dart -->
<!-- skip -->
{% prettify dart %}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // ...

    var descTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 18.0,
      height: 2.0,
    );

    // DefaultTextStyle.merge te permite crear un estilo de texto
    // por defecto que es heredado por este hijo y sus subsiguientes hijos.
    var iconList = DefaultTextStyle.merge(
      style: descTextStyle,
      child: Container(
        padding: EdgeInsets.all(20.0),
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
    // ...
  }
}
{% endprettify %}

La variable `leftColumn` contiene las filas de puntuaciones e iconos, y también tiene 
el título y el texto que describe la Pavlova:

<!-- code/layout/pavlova/main.dart -->
<!-- skip -->
{% prettify dart %}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //...

    var leftColumn = Container(
      padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
      child: Column(
        children: [
          titleText,
          subTitle,
          ratings,
          iconList,
        ],
      ),
    );
    //...
  }
}
{% endprettify %}

La columna izquierda esta colocada en un Container para restringir su ancho.
Finalmente, la UI es construida con la fila entera (conteniendo la columna 
izquierda y la imagen) dentro de un Card.

<a name="adding-images"></a>
La imagen de la Pavlova es de
[Pixabay](https://pixabay.com/en/photos/?q=pavlova&image_type=&cat=&min_width=&min_height=)
y esta disponible bajo la licencia Creative Commons.
Puedes insertar una imagen de la red usando `Image.network` pero,
para este ejemplo, la imagen es guardada en un directorio de imágenes en el proyecto,
añadido al [fichero pubspec,](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/pavlova/pubspec.yaml)
y accedida usando `Images.asset`. Para más información, mira
[Añadir Assets e imágenes en Flutter](/assets-and-images).

<!-- code/layout/pavlova/main.dart -->
<!-- skip -->
{% prettify dart %}
body: Center(
  child: Container(
    margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 30.0),
    height: 600.0,
    child: Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 440.0,
            child: leftColumn,
          ),
          mainImage,
        ],
      ),
    ),
  ),
),
{% endprettify %}

<div class="row"> <div class="col-md-3" markdown="1">

**Código Dart:** [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/pavlova/main.dart)<br>
**Imágenes:** [imágenes](https://github.com/flutter/website/tree/master/src/_includes/code/layout/pavlova/images)<br>
**Pubspec:** [pubspec.yaml](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/pavlova/pubspec.yaml)

</div> <div class="col-md-9" markdown="1">

<aside class="alert alert-success" markdown="1">
<i class="fa fa-lightbulb-o"> </i> **Consejo:**
El ejemplo Pavlova se ejecuta mejor horizontalmente en un dispositivo ancho, como una tablet.
Si estas ejecutando este ejemplo en el simulador de iOS, puedes elegir un
dispositivo diferente usando el menú **Hardware > Device**. Para este ejemplo, 
recomendamos el iPad Pro. Puedes cambiar la orientación a modo landscape usando 
**Hardware > Rotate**. También puedes cambiar el tamaño de la ventana del simulador 
(sin cambiar el número de pixeles lógicos) usando **Window > Scale**.
</aside>

</div> </div>

<hr>

<a name="common-layout-widgets"></a>
## Widgets de layout comunes

Flutter tiene una rica biblioteca de widgtes de layout, pero aquí estan algunos de 
los más comúnmente usados. La intención es hacerte avanzar lo más rápido posible, 
en lugar de abrumarte con una lista completa. Para información sobre otros 
widgets disponibles, te referimos a [Visión general de Widgets](/widgets/),
o usa la caja de búsqueda en la [documentación de referencia de la API](https://docs.flutter.io/).
También, las páginas de los widgets en la documentación de la API a menudo hace sugerencias 
sobre widgets similares que podrían adaptarse mejor a tus necesidades.

Los siguientes widgets entran en dos categorías: widgtes standard de la 
[biblioteca de widgets,](https://docs.flutter.io/flutter/widgets/widgets-library.html)
y widgets especializados de la
[biblioteca Material Components](https://docs.flutter.io/flutter/material/material-library.html).
Cualquier app puede usar la biblioteca de widgets pero solo las aplicaciones Material pueden usar la
biblioteca Material Components.

### Widgets Standard

* [Container](#container)
: Añade padding, margins, borders, background color,
  o otras decoraciones a un widget.
* [GridView](#gridview)
: Organiza los widgets como un grid scrollable.
* [ListView](#listview)
: Organiza los widgets como una lista scrollable.
* [Stack](#stack)
: Sobrepone los widgets encima de los otros.

### Material Components

* [Card](#card)
: Organiza información relacionada en una caja con esquinas redondeadas que arroja una sombra.

* [ListTile](#listtile)
: Organiza hasta 3 líneas de texto, y opcionalmente iconos al principio o al final,
  dentro de una fila.

### Container

Muchos layouts hacen un libre uso de los Containers para separar widgets con padding,
o para añadir bordes o márgenes. Puedes cambiar el fondo del dispositivo colocando 
todo el layout dentro de un Container y cambiando su color o imagen de fondo.

<div class="row"> <div class="col-md-6" markdown="1">

#### Resumen de Container:

* Añade padding, márgenes, bordes
* Cambia color o imagen de fondo
* Contiene un único widget hijo, pero este hijo puede ser un Row, Column,
  o ser la raíz de un árbol de widgets

</div> <div class="col-md-6" markdown="1">

<img src="images/margin-padding-border.png" alt="un diagrama que muestra los márgenes, los bordes y el relleno, que rodean el contenido en un contenedor">

</div> </div>

#### Ejemplos con Container:

Además de los ejemplos más abajo,
la mayoría de ejemplos en este tutorial usan Container. Puedes encontrar más 
ejemplos con Container en [Flutter
Gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery).

<div class="row"> <div class="col-md-6" markdown="1">

Este layout consiste en una columna y dos filas, cada una conteniendo 2 imágenes.
Cada imagen usa un Container para añadir un borde redondeado gris y márgenes.
El Column, que contiene las filas de imágenes,
usa un Container para cambiar el color de fondo a gris claro.

**Código Dart:** [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/container/main.dart), resumido abajo<br>
**Imágenes:** [imágenes](https://github.com/flutter/website/tree/master/src/_includes/code/layout/container/images)<br>
**Pubspec:** [pubspec.yaml](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/container/pubspec.yaml)

</div> <div class="col-md-6" markdown="1">

<img src="images/container.png" alt="una captura de pantalla mostrando 2 filas, cada una conteniendo 2 imágenes; las imágenes tienen un borde gris redondeado y un color de fondo gris claro">

</div> </div>

<!-- code/layout/container/main.dart -->
<!-- skip -->
{% prettify dart %}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    var container = Container(
      decoration: BoxDecoration(
        color: Colors.black26,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 10.0, color: Colors.black38),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0)),
                  ),
                  margin: const EdgeInsets.all(4.0),
                  child: Image.asset('images/pic1.jpg'),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 10.0, color: Colors.black38),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0)),
                  ),
                  margin: const EdgeInsets.all(4.0),
                  child: Image.asset('images/pic2.jpg'),
                ),
              ),
            ],
          ),
          // ...
          // [[highlight]]Mira la definición de la segunda fila en GitHub:[[/highlight]]
          // [[highlight]]https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/container/main.dart[[/highlight]]
        ],
      ),
    );
    //...
  }
}
{% endprettify %}

<hr>

### GridView

Usa [GridView](https://docs.flutter.io/flutter/widgets/GridView-class.html)
para organizar los widgets en una lista bidimensional. GridView proporciona dos 
listas prefabricadas, o puedes construir tu propio grid personalizado.
Cuando un GridView detecta que sus contenidos son demasiado largos para ajustarse al _render box_,
este habilita el scroll automáticamente.

#### Resumen de GridView:

* Organiza widgets en un grid
* Detecta cuando el contenido de la columna sobrepasa el _render box_ y automaticamente 
  proporciona scroll
* Construye tu propio grid personalizado, o usa uno de los grids proveidos:
  * `GridView.count` permite especificar el número de columnas
  * `GridView.extent` permite especificar el ancho máximo en pixels de un elemento
{% comment %}
* Usa `MediaQuery.of(context).orientation` para crear un grid que cambia su layout 
  dependiendo de si el dispositivo esta en modo landscape o portrait.
{% endcomment %}

<aside class="alert alert-info" markdown="1">
**Nota:** Cuando mostramos una lista bidimensional en la que nos importa que fila y columna 
ocupa una celda (por ejemplo, es la entrada de la columna "calorías" para la fila de "aguacate"), usa 
[Table](https://docs.flutter.io/flutter/widgets/Table-class.html) o
[DataTable](https://docs.flutter.io/flutter/material/DataTable-class.html).
</aside>

#### Ejemplos de GridView:

<div class="row"> <div class="col-md-6" markdown="1">

<img src="images/gridview-extent.png" style="border:1px solid black" alt="un grid de 3 columnas de fotos">

Usa `GridView.extent` para crear un grid con elementos de 150 píxeles de ancho máximo.<br>
**Código Dart:** [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/grid/main.dart), resumido abajo<br>
**Imágenes:** [imágenes](https://github.com/flutter/website/tree/master/src/_includes/code/layout/grid/images)<br>
**Pubspec:** [pubspec.yaml](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/grid/pubspec.yaml)

</div> <div class="col-md-6" markdown="1">

<img src="images/gridview-count-flutter-gallery.png" style="border:1px solid black" alt="un gri de 2 columnas con footers conteniendo títulos en un fondo parcialmente transparente">

Usa `GridView.count` para crear un grid que tiene 2 elementos de ancho en modo portrait, 
y 3 elementos de ancho en modo landscape. Los títulos son creados asignando la propiedad 
`footer` para cada GridTile.<br>
**Código Dart:** [grid_list_demo.dart](https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/grid_list_demo.dart)
de la [Flutter
Gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)

</div> </div>

<!-- code/layout/grid/main.dart -->
<!-- skip -->
{% prettify dart %}
// Las imágenes están guardadas con nombres pic1.jpg, pic2.jpg...pic30.jpg.
// El contructor List.generate permite crear de una manera sencilla
// una lista cuando los objetos tienen un patrón de nombrado predecible.
List<Container> _buildGridTileList(int count) {

  return List<Container>.generate(
      count,
      (int index) =>
          Container(child: Image.asset('images/pic${index+1}.jpg')));
}

Widget buildGrid() {
  return GridView.extent(
      maxCrossAxisExtent: 150.0,
      padding: const EdgeInsets.all(4.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      children: _buildGridTileList(30));
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: buildGrid(),
      ),
    );
  }
}
{% endprettify %}


<hr>

### ListView

[ListView](https://docs.flutter.io/flutter/widgets/ListView-class.html),
un widget similar a una columna, proporciona automáticamente cuando su contenido 
es demasiado largo para su _render box_.

#### Resumen de ListView:

* Una columna especializada en organizar listas de cajas
* Puede organizarse horizontal o verticalmente
* Detecta cuando su contenido no puede ajustarse y proporciona la capacidad de hacer scroll
* Menos configurable que un Column, pero más fácil de usar y dar soporte al scroll

#### Ejemplos de ListView:

<div class="row"> <div class="col-md-6" markdown="1">

<img src="images/listview.png" style="border:1px solid black" alt="un ListView conteniendo peliculas, teatros y restaurantes">

Usa un ListView para mostrar una lista de negocios usando ListTiles.
Un Divider separa los teatros de los restaurantes.<br>
**Código Dart:** [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/listview/main.dart), resumido abajo<br>
**Iconos:** [Icons class](https://docs.flutter.io/flutter/material/Icons-class.html)<br>
**Pubspec:** [pubspec.yaml](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/listview/pubspec.yaml)

</div> <div class="col-md-6" markdown="1">

<img src="images/listview-flutter-gallery.png" style="border:1px solid black" alt="un ListView conteniendo containing sombras de azul de la paleta de colores de Material Design">

Usa un ListView para mostrar 
[Colors](https://docs.flutter.io/flutter/material/Colors-class.html)
de la
[paleta de Material Design](https://material.io/guidelines/style/color.html)
para una familia de color en particular.<br>
**Código Dart:** [colors_demo.dart](https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/colors_demo.dart)
de la [Flutter
Gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)

</div> </div>

<!-- code/layout/listview/main.dart -->
<!-- skip -->
{% prettify dart %}
List<Widget> list = <Widget>[
  ListTile(
    title: Text('CineArts at the Empire',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
    subtitle: Text('85 W Portal Ave'),
    leading: Icon(
      Icons.theaters,
      color: Colors.blue[500],
    ),
  ),
  ListTile(
    title: Text('The Castro Theater',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
    subtitle: Text('429 Castro St'),
    leading: Icon(
      Icons.theaters,
      color: Colors.blue[500],
    ),
  ),
  // ...
  // [[highlight]]Mira el resto de la definición de la columna en GitHub:[[/highlight]]
  // [[highlight]]https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/listview/main.dart[[/highlight]]
];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      body: Center(
        child: ListView(
          children: list,
        ),
      ),
    );
  }
}
{% endprettify %}

<hr>

### Stack

Usa [Stack](https://docs.flutter.io/flutter/widgets/Stack-class.html)
para organizar widgets encima de un widget base &mdash;quizás una imagen.
Los widgets pueden solapar completa o parcialmente el widget base.

#### Resumen de Stack:

* Usado para widgets que se sobreponen sobre otro widget
* El primer widget en la lista de hijos es el widget base;
  los hijos subsiguientes son sobrepuestos encima de este widget base
* El contenido de un Stack's no puede hacer scroll
* Puedes elegir recortar los hijos que excedan el _render box_

#### Ejemplos de Stack:

<div class="row"> <div class="col-md-6" markdown="1">

<img src="images/stack.png" style="border:1px solid black" alt="un avatar cirular conteniendo la etiqueta 'Mia B' en la posicion inferior derecha del círculo">

Usa Stack para solapar un Container (que muestra su widget Text en un fondo negro 
tráslucido) encima de un Avatar Circular.
Stack aplica un offset al texto usando la propiedad `alignment` y Alignments.<br>
**Código Dart:** [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/stack/main.dart), resumido abajo<br>
**Imágen:** [imágenes](https://github.com/flutter/website/tree/master/src/_includes/code/layout/stack/images)<br>
**Pubspec:** [pubspec.yaml](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/stack/pubspec.yaml)


</div> <div class="col-md-6" markdown="1">

<img src="images/stack-flutter-gallery.png" style="border:1px solid black" alt="una imagen con un gradiente gris sobre él encima del gradiente están las herramientas pintadas en blanco">

Usa Stack para sobreponer un gradiente encima de la imagen. El gradiente asegura 
que el color de los iconos de la barra de herramientas se distinguen de la imagen.<br>
**Código Dart:** [contacts_demo.dart](https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/contacts_demo.dart)
de la [Flutter
Gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)

</div> </div>

<!-- code/layout/stack/main.dart -->
<!-- skip -->
{% prettify dart %}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var stack = Stack(
      alignment: const Alignment(0.6, 0.6),
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('images/pic.jpg'),
          radius: 100.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black45,
          ),
          child: Text(
            'Mia B',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
    // ...
  }
}
{% endprettify %}

<hr>

### Card

Un Card, de la biblioteca Material Components, contiene porciones de información relacionada 
y puede ser compuesto por casi cualquier widget, pero es a menudo usado con ListTile.
Card tiene un único hijo, pero este hijo puede ser una columna, fila, lista, grid, 
u otro widget que soporte múltiples hijos. Por defecto, un Card encoje 
su tamaño a 0 por 0 píxeles. Puedes usar 
[SizedBox](https://docs.flutter.io/flutter/widgets/SizedBox-class.html) para 
restringir el tamaño de un Card.

En Flutter, un Card presenta esquinas ligeramente redondeadas 
y arroja una sombra, dándole un efecto 3D.
Cambiando la propiedad `elevation` de Card
te permite controlar el efecto de la sombra arrojada.
Fijando la elevación a 24.0, por ejemplo, visualmente levanta el Card desde 
la superficie y provoca que la sombra se vuelva más dispersa.
Para una lista de los valores soportados por `elevation`, mira
[Elevation y
Shadows](https://material.io/guidelines/material-design/elevation-shadows.html)
en las [Material guidelines](https://material.io/guidelines/).
Especificar un valor no soportado deshabilita completamente la sombra.

#### Resumen de Card:

* Implementa un [Material Design
  card](https://material.io/guidelines/components/cards.html)
* Usado para presentar porciones relacionadas de información
* Acepta un único hijo, pero este hijo puede ser un Row, Column, u otro 
  widget que sostenga una lista de hijos
* Mostrado con esquinas redondeadas y sombra
* El contenido de un Card no soporta scroll
* De la biblioteca de Material Components

#### Ejemplos de Card:

<div class="row"> <div class="col-md-6" markdown="1">

<img src="images/card.png" style="border:1px solid black" alt="un Card conteniendo 3 ListTiles">

Un Card conteniendo 3 ListTiles y dimensionado envolviéndolo con un SizedBox.
Un Divider separa el primer y el segundo ListTiles.

**Código Dart:** [main.dart](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/card/main.dart), resumido abajo<br>
**Iconos:** [Icons class](https://docs.flutter.io/flutter/material/Icons-class.html)<br>
**Pubspec:** [pubspec.yaml](https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/card/pubspec.yaml)

</div> <div class="col-md-6" markdown="1">

<img src="images/card-flutter-gallery.png" style="border:1px solid black" alt="un Card conteniendo una imagen ,un texto y botones bajo la imagen">

Un Card conteniendo una imagen y texto.<br>
**Código Dart:** [cards_demo.dart](https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/cards_demo.dart)
de la [Flutter
Gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)

</div> </div>

<!-- code/layout/card/main.dart -->
<!-- skip -->
{% prettify dart %}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var card = SizedBox(
      height: 210.0,
      child: Card(
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
  //...
}
{% endprettify %}

<hr>

### ListTile

Usa
ListTile, un widget de fila especializado de la librería Material Components, para crear fácilmente
una fila conteniendo hasta 3 líneas de texto y opcionalmente iconos al principio o al final. 
ListTile es normalmente usado en Card o ListView,
pero puede ser usado en cualquier parte.

#### Resumen de ListTile:

* Una fila especializada que contiene hasta 3 líneas de texto y opcionalmente iconos
* Menos configurable que un Row, pero más fácil de usar
* De la biblioteca Material Components

#### ListTile examples:

<div class="row"> <div class="col-md-6" markdown="1">

<img src="images/card.png" style="border:1px solid black" alt="un Card conteniendo 3 ListTiles">

Un Card conteniendo 3 ListTiles.<br>
**Código Dart:** Mira [ejemplos de Card](#card-examples).

</div> <div class="col-md-6" markdown="1">

<img src="images/listtile-flutter-gallery.png" style="border:1px solid black" alt="3 ListTiles, cada uno conteniendo un botón deplegble">

Usa ListTile para listar 3 botones de tipo desplegable.<br>
**Código Dart:** [buttons_demo.dart](https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/buttons_demo.dart)
de la [Flutter
Gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)

</div> </div>

<hr>

<a name="resources"></a>
## Recursos

Los siguientes recursos pueden ayudar cuando escribes código de layout.

* [Visión general de los Widget](/widgets)<br>
  Describe muchos de los widgets disponibles en Flutter.
* [Analogías de Flutter con HTML/CSS](/web-analogs)<br>
  Para aquellos familiarizados con la programación web, esta página compara las funcionalidades HTML/CSS 
  con las características de Flutter.
* [Flutter
  Gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)<br>
  Aplicaciones Demo que muestran casos de uso de muchos widgets Material Design widgets y otras 
  características de Flutter.
* [Documentación de la API de Flutter](https://docs.flutter.io/)<br>
  Documentación de referencia para todas las bibliotecas de Flutter.
* [Tratando con las Box Constraints en Flutter](/layout)<br>
  Discute como los widgets son restringidos en sus _render boxes_.
* [Añadir Assets e imágenes en Flutter](/assets-and-images)<br>
  Explica como añadir imágenes y otros assets en el paquete de tu app.
* [Zero to One with
  Flutter](https://medium.com/@mravn/zero-to-one-with-flutter-43b13fd7b354#.z86tsq4ld)<br>
  Una experiencia personal escribiendo su primera app con Flutter.
