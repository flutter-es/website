---
title: Tutorial de layout
short-title: Tutorial
description: Aprende a construir un layout.
diff2html: true
---

{% assign api = '{{site.api}}/flutter' -%}
{% capture examples -%} {{site.repo.this}}/tree/{{site.branch}}/examples {%- endcapture -%}
{% assign rawExFile = 'https://raw.githubusercontent.com/flutter/website/master/examples' -%}
{% capture demo -%} {{site.repo.flutter}}/tree/{{site.branch}}/examples/flutter_gallery/lib/demo {%- endcapture -%}

<style>dl, dd { margin-bottom: 0; }</style>

{{site.alert.secondary}}
  <h4 class="no_toc">Lo que aprenderás</h4>

  * Cómo funciona el mecanismo de layout de Flutter.
  * Cómo distribuir los widgets verticalmente y horizontalmente.
  * Cómo construir un layout Flutter.
{{site.alert.end}}

Esta es una guía para construir layouts en Flutter. 
Construirás el layout para la siguiente aplicación:

{% include app-figure.md img-class="site-mobile-screenshot border"
    image="ui/layout/lakes.jpg" caption="The finished app" %}

Esta guía da un paso atrás para explicar el enfoque de Flutter sobre el layout y muestra cómo colocar un único widget en la pantalla. Después de una discusión sobre cómo colocar los widgets horizontalmente y verticalmente, se tratan algunos de los widgets de layout más comunes.

Si deseas una visión general del mecanismo de layout,
comienza con el [enfoque de Flutter sobre el layout](/docs/development/ui/layout).

## Paso 0: Crear el código base de la aplicación

Asegúrate de haber [configurado](/docs/get-started/install) tu entorno y luego haz lo siguiente:

 1. [Crea una aplicación básica Flutter "Hello World"][hello-world].
 2. Cambia el título de la barra de aplicaciones y el título de la aplicación como sigue:

    <?code-excerpt "{codelabs/startup_namer/step1_base,layout/base}/lib/main.dart"?>
    ```diff
    --- codelabs/startup_namer/step1_base/lib/main.dart
    +++ layout/base/lib/main.dart
    @@ -6,10 +6,10 @@
       @override
       Widget build(BuildContext context) {
         return MaterialApp(
    -      title: 'Welcome to Flutter',
    +      title: 'Flutter layout demo',
           home: Scaffold(
             appBar: AppBar(
    -          title: Text('Welcome to Flutter'),
    +          title: Text('Flutter layout demo'),
             ),
             body: Center(
               child: Text('Hello World'),
    ```

[hello-world]: /docs/get-started/codelab#step-1-create-the-starter-flutter-app

## Paso 1: Diagrama del layout

El primer paso es desglosar el layout en sus elementos básicos:

* Identificar las filas y columnas.
* ¿El layout incluye una cuadrícula?
* ¿Hay elementos que se superponen?
* ¿Necesita pestañas la interfaz de usuario?
* Observe las áreas que requieren alineación, padding o bordes.

Primero, identifica los elementos más grandes. En este ejemplo, cuatro elementos están
dispuestos en una columna: una imagen, dos filas y un bloque de texto.

{% include app-figure.md img-class="site-mobile-screenshot border"
    image="ui/layout/lakes-column-elts.png" caption="Column elements (circled in red)" %}

A continuación, diagrama cada fila. La primera fila, llamada sección Título, 
tiene 3 hijos: una columna de texto, un icono de estrella y un número. 
Su primer hijo, la columna, contiene 2 líneas de texto. Esa primera columna 
ocupa mucho espacio, por lo que debe estar envuelta en un widget Expanded.

{% include app-figure.md image="ui/layout/title-section-parts.png" alt="Title section" %}

La segunda fila, llamada sección Botón, también tiene 3 hijos: 
cada hijo es una columna que contiene un icono y un texto.

{% include app-figure.md image="ui/layout/button-section-diagram.png" alt="Button section" %}

Una vez que se ha diagramado el layout, lo más fácil es adoptar un enfoque 
ascendente para implementarlo. Para minimizar la confusión visual del 
código de layout profundamente anidado, coloca parte de la implementación 
en variables y funciones.

## Paso 2: Implementar la fila de título

<?code-excerpt path-base="layout/lakes/step2"?>

Primero, construirás la columna izquierda en la sección de título. Agrega el siguiente código en la parte superior del método `build()` de la clase `MyApp`:

<?code-excerpt "lib/main.dart (titleSection)" title?>
```dart
Widget titleSection = Container(
  padding: const EdgeInsets.all(32),
  child: Row(
    children: [
      Expanded(
        /*1*/
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
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
      /*3*/
      Icon(
        Icons.star,
        color: Colors.red[500],
      ),
      Text('41'),
    ],
  ),
);
```

{:.numbered-code-notes}
 1. Al colocar una columna dentro de un widget Expanded, se estira la columna 
    para utilizar todo el espacio libre que queda en la fila. Al establecer 
    la propiedad `crossAxisAlignment` a
    `CrossAxisAlignment.start` se posiciona la columna al principio de la fila.
 2. Poner la primera fila de texto dentro de un Container te permite añadir 
    padding. El segundo hijo en la Columna, también texto, se visualiza como gris.
 3. Los dos últimos elementos de la fila del título son un icono de estrella, 
    pintado de rojo, y el texto "41". Toda la fila está en un Container y con 
    padding a lo largo de cada borde por 32 píxeles.

Añade la sección de título al cuerpo de la aplicación de esta manera:

<?code-excerpt path-base="layout/lakes"?>
<?code-excerpt "{../base,step2}/lib/main.dart" from="return MaterialApp"?>
```diff
--- ../base/lib/main.dart
+++ step2/lib/main.dart
@@ -8,11 +46,13 @@
     return MaterialApp(
       title: 'Flutter layout demo',
       home: Scaffold(
         appBar: AppBar(
           title: Text('Flutter layout demo'),
         ),
-        body: Center(
-          child: Text('Hello World'),
+        body: Column(
+          children: [
+            titleSection,
+          ],
         ),
       ),
     );
```

{{site.alert.tip}}
  - Al pegar el código en la aplicación, la indentación se puede desviar. Puedes 
    arreglar esto en tu editor Flutter usando el 
    [soporte de reformateo automático](/docs/development/tools/formatting).
  - Para una experiencia de desarrollo más rápida, prueba la función [hot reload][] 
    de Flutter.
  - Si tienes problemas, compara tu código con [lib/main.dart][].

  [hot reload]: /docs/development/tools/hot-reload
  [lib/main.dart]: {{examples}}/layout/lakes/step2/lib/main.dart
{{site.alert.end}}

## Paso 3: Implementar la fila de botones

<?code-excerpt path-base="layout/lakes/step3"?>

La sección de botones contiene 3 columnas que utilizan la misma disposición: 
un icono sobre una línea de texto. Las columnas de esta fila están espaciadas 
uniformemente, y el texto y los iconos están pintados con el color primario.

Como el código para construir cada columna es casi idéntico, crea un método 
de ayuda privado llamado `buildButtonColumn()`, que toma un color, un Icono 
y Texto, y devuelve una columna con sus widgets pintados con el color dado.

<?code-excerpt "lib/main.dart (_buildButtonColumn)" title?>
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ···
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
```

La función añade el icono directamente a la columna. El texto se encuentra dentro de un Container con un margen superior, separando el texto del icono.

Construye la fila que contiene estas columnas llamando a la función y pasando el color, 
`Icon`, y el texto específico de esa columna. Alinea las columnas a lo largo del eje principal utilizando `MainAxisAlignment.spaceEvenly` para organizar el espacio libre uniformemente antes, entre y después de cada columna. Agrega el siguiente código justo debajo de la declaración `titleSection` dentro del método `build()`:

<?code-excerpt "lib/main.dart (buttonSection)" title?>
```dart
Color color = Theme.of(context).primaryColor;

Widget buttonSection = Container(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildButtonColumn(color, Icons.call, 'CALL'),
      _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
      _buildButtonColumn(color, Icons.share, 'SHARE'),
    ],
  ),
);
```

Añade la sección de botones al body:

<?code-excerpt path-base="layout/lakes"?>
<?code-excerpt "{step2,step3}/lib/main.dart" from="return MaterialApp" to="}"?>
```diff
--- step2/lib/main.dart
+++ step3/lib/main.dart
@@ -46,3 +59,3 @@
     return MaterialApp(
       title: 'Flutter layout demo',
       home: Scaffold(
@@ -52,8 +65,9 @@
         body: Column(
           children: [
             titleSection,
+            buttonSection,
           ],
         ),
       ),
     );
   }
```

## Paso 4: Implementar la sección de texto

<?code-excerpt path-base="layout/lakes/step4"?>

Define la sección de texto como una variable. Pon el texto en un Container y 
agrega padding a lo largo de cada borde. Añade el siguiente código justo 
debajo de la declaración `buttonSection`:

<?code-excerpt "lib/main.dart (textSection)" title?>
```dart
Widget textSection = Container(
  padding: const EdgeInsets.all(32),
  child: Text(
    'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
        'Alps. Situated 1,578 meters above sea level, it is one of the '
        'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
        'half-hour walk through pastures and pine forest, leads you to the '
        'lake, which warms to 20 degrees Celsius in the summer. Activities '
        'enjoyed here include rowing, and riding the summer toboggan run.',
    softWrap: true,
  ),
);
```

Al establecer `softwrap` a true, las líneas de texto rellenarán el ancho de 
la columna antes de ajustarla al límite de una palabra.

Añade la sección de texto al body:

<?code-excerpt path-base="layout/lakes"?>
<?code-excerpt "{step3,step4}/lib/main.dart" from="return MaterialApp"?>
```diff
--- step3/lib/main.dart
+++ step4/lib/main.dart
@@ -59,3 +72,3 @@
     return MaterialApp(
       title: 'Flutter layout demo',
       home: Scaffold(
@@ -66,6 +79,7 @@
           children: [
             titleSection,
             buttonSection,
+            textSection,
           ],
         ),
       ),
```

## Paso 5: Implementar la sección de imagen

Tres de los cuatro elementos de la columna están ahora completos, dejando sólo la imagen. Añade el archivo de imagen al ejemplo:

* Crea un directorio `images` en la parte superior del proyecto.
* Añade [`lake.jpg`]({{rawExFile}}/layout/lakes/step5/images/lake.jpg).

  {{site.alert.info}}
    Observa que `wget` no funciona para guardar este archivo binario. La imagen original 
    esta [disponible en linea][] bajo una licencia Creative Commons, pero es grande y lenta de obtener.

    [disponible en linea]: https://images.unsplash.com/photo-1471115853179-bb1d604434e0?dpr=1&amp;auto=format&amp;fit=crop&amp;w=767&amp;h=583&amp;q=80&amp;cs=tinysrgb&amp;crop=
  {{site.alert.end}}

* Actualice el archivo `pubspec.yaml` para incluir una etiqueta `assets`. Esto hace 
  que la imagen esté disponible para tu código.

  <?code-excerpt "{step4,step5}/pubspec.yaml"?>
  ```diff
  --- step4/pubspec.yaml
  +++ step5/pubspec.yaml
  @@ -17,3 +17,5 @@

   flutter:
     uses-material-design: true
  +  assets:
  +    - images/lake.jpg
  ```

Ahora puedes referenciar la imagen de tu código:

<?code-excerpt "{step4,step5}/lib/main.dart"?>
```diff
--- step4/lib/main.dart
+++ step5/lib/main.dart
@@ -77,6 +77,12 @@
         ),
         body: Column(
           children: [
+            Image.asset(
+              'images/lake.jpg',
+              width: 600,
+              height: 240,
+              fit: BoxFit.cover,
+            ),
             titleSection,
             buttonSection,
             textSection,
```

`BoxFit.cover` le dice al framework que la imagen debe ser lo más pequeña posible pero que debe cubrir toda su caja de render.

## Paso 6: El toque final

En este paso final, ordena todos los elementos en un `ListView`, en lugar de una
`Column`, porque un `ListView` soporta el desplazamiento del body de la aplicación 
cuando la aplicación se ejecuta en un dispositivo pequeño.

<?code-excerpt "{step5,step6}/lib/main.dart" diff-u="6" from="return MaterialApp"?>
```diff
--- step5/lib/main.dart
+++ step6/lib/main.dart
@@ -72,13 +77,13 @@
     return MaterialApp(
       title: 'Flutter layout demo',
       home: Scaffold(
         appBar: AppBar(
           title: Text('Flutter layout demo'),
         ),
-        body: Column(
+        body: ListView(
           children: [
             Image.asset(
               'images/lake.jpg',
               width: 600,
               height: 240,
               fit: BoxFit.cover,
```

**Dart code:** [main.dart]({{examples}}/layout/lakes/step6/lib/main.dart)<br>
**Image:** [images]({{examples}}/layout/lakes/step6/images)<br>
**Pubspec:** [pubspec.yaml]({{examples}}/layout/lakes/step6/pubspec.yaml)

¡Eso es todo! Cuando recargas la aplicación en caliente, deberías ver el mismo layout de la aplicación como la de la captura de pantalla en la parte superior de esta página.

Puedes añadir interactividad a este layout siguiendo el enlace 
[Agregando interactividad a tu aplicación Flutter](/docs/development/ui/interactive).
