---
title: Escribe tu primera app en Flutter, parte 1
short-title: Escribe tu primera app
prev:
  title: Test inicial
  path: /docs/get-started/test-drive
next:
  title: Aprende más
  path: /docs/get-started/learn-more
diff2html: true
---

{% assign code-url = 'https://raw.githubusercontent.com/flutter/codelabs/master' -%}

{% asset get-started/startup-namer-part-1 alt="La app que construirás" class='site-image-right' %}

{%- comment %}
  Code highlights in this page are green, to match diff additions.
{% endcomment -%}
<style>pre .highlight { background-color: #dfd; }</style>

Esta es una guía para crear tu primera app en Flutter. Si estás familiarizado con la 
programación orientada a objetos y con conceptos básicos de programación como 
variables, bucles y condicionales podrás completar este tutorial. 
No se necesita experiencia previa con Dart o programación móvil.

Esta guía es la parte 1 de un codelab de dos partes. Puedes encontrar la 
[parte 2]({{site.codelabs}}/codelabs/first-flutter-app-pt2)
en [Google Developers]({{site.codelabs}}).
La [Parte 1]({{site.codelabs}}/codelabs/first-flutter-app-pt1)
también se puede encontrar en [Google Developers]({{site.codelabs}}).

## Lo que haremos en la parte 1
{:.no_toc}

Se implementará una app móvil sencilla que generará nombres propuestos para un
startup. El usuario puede seleccionar o deseleccionar nombres,
almacenando los mejores. El código genera nombres de forma "vaga".
A medida que el usuario se desplaza por la pantalla, nuevos nombres son generados.
No hay límite a cuán lejos puede un usuario hacer scroll.

El GIF animado muestra como trabaja la app al completar la parte 1.

{{site.alert.secondary}}
  <h4 class="no_toc">Lo que aprenderemos en la parte 1</h4>


  * Como escribir una aplicación Flutter que se vea natural en iOS y Android.
  * Estructura básica de una app en Flutter.
  * Encontrar y utilizar paquetes para extender funcionalidades.
  * Usar hot reload para un ciclo de desarrollo más rápido.
  * Cómo implementar un "stateful widget".
  * Cómo crear una lista de carga "vaga" e infinita.

  En la [parte 2]({{site.codelabs}}/codelabs/first-flutter-app-pt2)
  de este codelab, añadirás interactividad, modificarás el theme de la app, y 
  añadirás la habilidad de navegar a una nueva pantalla (llamada una _ruta_ en Flutter).
{{site.alert.end}}

{{site.alert.secondary}}
  <h4 class="no_toc">Lo que vamos a usar</h4>

  Necesitas dos piezas de software para completar este "lab": el
  [SDK de Flutter](/docs/get-started/install) y [un editor](/docs/get-started/editor).
  Este codelab presupone Android Studio, pero puedes usar el editor que 
  prefieras.

  Puedes ejecutar este codelab usando cualquiera de los siguientes dispositivos:

  * Un dispositivo físico ([Android](/setup-macos/#set-up-your-android-device)
    o [iOS](/setup-macos/#deploy-to-ios-devices)) conectado a tu ordenador 
    y configurado en modo desarrollo.
  * El [simulador de iOS](/setup-macos/#set-up-the-ios-simulator).
  * El [emulador de Android](/setup-macos/#set-up-the-android-emulator).
{{site.alert.end}}

# Paso 1: Crear la app inicial de Flutter

<?code-excerpt path-base="codelabs/startup_namer/step1_base"?>

Crear un app sencilla desde una plantilla de Flutter, utilizando las instrucciones en
[Iniciando con tu primer app de 
Flutter.](/docs/get-started/test-drive#create-app)
Nombre del proyecto **startup_namer** (en lugar de _myapp_).

{{site.alert.tip}}
  Si no ves "New Flutter Project" como opción en tu IDE, asegúrate 
  que tienes [instalados los plugins para Flutter y 
  Dart](/docs/get-started/editor)
{{site.alert.end}}

En este codelab, en su mayoría editarás **lib/main.dart**,
donde se encuentra el código Dart.

 1. Reemplaza el contenido de `lib/main.dart`.<br>
    Borra todo el código de **lib/main.dart**.
    Reemplaza con el siguiente código, el cual muestra "Hello World" en el centro
    de la pantalla.

    <?code-excerpt "lib/main.dart" title?>
    ```dart
    import 'package:flutter/material.dart';

    void main() => runApp(MyApp());

    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Welcome to Flutter',
          home: Scaffold(
            appBar: AppBar(
              title: Text('Welcome to Flutter'),
            ),
            body: Center(
              child: Text('Hello World'),
            ),
          ),
        );
      }
    }
    ```

    {{site.alert.tip}}
      Cuando copias código en tu app, la identación puede romperse.
      Puedes corregirla automáticamente con las herramientas de Flutter:

      * Android Studio / IntelliJ IDEA: Clic derecho sobre el código y elige
        **Reformat Code with dartfmt**.
      * VS Code: Clic derecho y elige **Format Document**.
      * Terminal: Ejecuta `flutter format <filename>`.
    {{site.alert.end}}

 2. Ejecuta la app [de la forma que describe tu IDE](/docs/get-started/test-drive).
    Deberías ver la salida Android o iOS, dependiendo de tu dispositivo.    

    {% indent %}
      {% include android-ios-figure-pair.md image="hello-world.png" alt="Hello world app" %}
    {% endindent %}

    {{site.alert.tip}}
      La primera vez que ejecutas en un dispositivo físico, tomará un poco la carga.
      Después de esto, puedes usar hot reload para actualizaciones rápidas. **Save** también
      realiza un hot reload si la app esta en ejecución.
    {{site.alert.end}}

## Observaciones
{:.no_toc}

* Este ejemplo crea una "Material app".
  [Material]({{site.material}}/guidelines/) es un lenguaje de diseño visual
  el cual es un estándar en web y móvil. Flutter ofrece un gran conjunto
  de "Material widgets".
* El método main usa la anotación fat arrow (`=>`).
  Usa anotación fat arrow para funciones o métodos de una sola linea.
* La app hereda de `StatelessWidget` el cual hace la app un widget en sí misma.
  En Flutter, casi todo es un widget, incluido alineaciones, 
  padding y layouts.
* El widget `Scaffold`, de la librería de Material,
  provee una AppBar por defecto, "title", y una propiedad "body" el cual
  soporta el árbol de widget para la pantalla de inicio. El subárbol de widget
  puede ser bastante complejo.
* El trabajo principal de un widget es proporcionar un método build()
  que describa cómo mostrar el widget en términos de otros widgets 
  de nivel inferior.
* El body en este ejemplo consiste en un widget `Center` conteniendo un 
  widget `Text` hijo. El widget Center alinea su sub-árbol de widgets 
  en el centro de la pantalla.

# Paso 2: Usar un paquete externo

En este paso, empezarás utilizando un paquete de código libre llamado
[english_words]({{site.pub}}/packages/english_words),
el cual contiene unos cuantos de miles de las palabras
en Inglés más utilizadas, además de otras funciones de utilidad.

Puedes encontrar el paquete `english_words` package, así como muchos otros paquetes
open source, en [pub.dartlang.org]({{site.pub}}/flutter/).

 1. El archivo pubspec gestiona los assets y dependencias para una app Flutter.
    En `pubspec.yaml`, agrega `english_words` (3.1.0 o mayor)
    a las lista de dependencias.
    Añade la línea resaltada abajo:

   <?code-excerpt path-base="codelabs/startup_namer"?>
    <?code-excerpt "{step1_base,step2_use_package}/pubspec.yaml" diff-u="4" from="dependencies" to="english"?>
    ```diff
    --- step1_base/pubspec.yaml
    +++ step2_use_package/pubspec.yaml
    @@ -5,4 +5,5 @@
     dependencies:
       flutter:
         sdk: flutter
       cupertino_icons: ^0.1.2
    +  english_words: ^3.1.0
    ```

 2. Mientras vez el pubspec en el editor de Android Studio,
    clic **Packages get**. Esto trae los paquetes dentro
    del proyecto. Se deberá ver lo siguiente en la consola:

    ```terminal
    $ flutter pub get
    Running "flutter pub get" in startup_namer...
    Process finished with exit code 0
    ```

    Realizando `Packages get` también auto-generas el fichero `pubspec.lock`
    con una lista de todos los paquetes añadidos al proyecto y 
    sus números de version.

 3. En `lib/main.dart`, importa el nuevo paquete:

    <!-- skip -->
    <?code-excerpt path-base="codelabs/startup_namer/step2_use_package"?>
    <?code-excerpt "lib/main.dart" title retain="/^import/" replace="/import.*?english.*/[!$&!]/g" indent-by="2"?>
    ```dart
      import 'package:flutter/material.dart';
      [!import 'package:english_words/english_words.dart';!]
    ```

    Mientras tecleas, Android Studio da sugerencias para las bibliotecas a
    importar. Entonces renderiza el texto de "import" en gris, haciéndote 
    saber que la librería importada no ha sido utilizada (hasta el momento).

 4. Usa el paquete de palabras en inglés para generar texto en lugar de
    utilizar el texto "Hello World".

       <?code-excerpt path-base="codelabs/startup_namer"?>
    <?code-excerpt "{step1_base,step2_use_package}/lib/main.dart" from="class"?>
    ```diff
    --- step1_base/lib/main.dart
    +++ step2_use_package/lib/main.dart
    @@ -5,6 +6,7 @@
     class MyApp extends StatelessWidget {
       @override
       Widget build(BuildContext context) {
    +    final wordPair = WordPair.random();
         return MaterialApp(
           title: 'Welcome to Flutter',
           home: Scaffold(
    @@ -12,7 +14,7 @@
               title: Text('Welcome to Flutter'),
             ),
             body: Center(
    -          child: Text('Hello World'),
    +          child: Text(wordPair.asPascalCase),
             ),
           ),
         );
    ```

     {{site.alert.note}}
      "Pascal case" (también conocido como "upper camel case"),
      significa que cada palabra en el texto, incluyendo la primera, 
      empezará con letra mayúscula. Entonces, "uppercamelcase" se convierte
      "UpperCamelCase".
    {{site.alert.end}}

 5. Si la app está ejecutándose, haz [hot reload](/docs/get-started/test-drive)
    para actualizar la app. Cada vez que se presione hot reload
    o se guarde el proyecto, deberá verse una palabra diferente,
    elegida aleatoriamente, en la app.
    Esto es debido a que las palabras generadas dentro del método "build",
    el cual se ejecuta cada vez que la MaterialApp requiere renderizar
    o al alternar la plataforma en el inspector de Flutter.

    {% indent %}
           {% include android-ios-figure-pair.md image="step2.png" alt="App at completion of second step" %}
    {% endindent %}
   
## ¿Problemas?
{:.no_toc}

Si tu app no se está ejecutando correctamente, busca por errores al teclear. De ser necesario,
usa el código en el siguiente enlace y continuar.

* [pubspec.yaml]({{code-url}}/startup_namer/step2_use_package/pubspec.yaml)
* [lib/main.dart]({{code-url}}/startup_namer/step2_use_package/lib/main.dart)


# Paso 3: Agregar un Stateful widget

<?code-excerpt path-base="codelabs/startup_namer/step3_stateful_widget"?>

Los widgets State<em>less</em> son inmutables, esto quiere decir que
sus propiedades no se pueden cambiar&mdash;todos sus valores son finales.

Con widgets State<em>ful</em> mantienes un estado que puede cambiar
durante el tiempo de vida del widget. Implementar un stateful
widget requerirá al menos dos clases: 1) una clase StatefulWidget
la cual crea la instancia 2) una clase State. La clase StatefulWidget es,
a si misma, inmutable, pero la clase State persiste sobre el tiempo de
vida de el widget.

En este paso, agregarás un stateful widget, `RandomWords`, el cual crea su clase
`State`, `RandomWordsState`. Entonces usarás `RandomWords` como 
un hijo dentro del existente stateless widget `MyApp`.

 1. Crea una state class mínima. Añade lo siguiente al final 
 de `main.dart`:

    <?code-excerpt "lib/main.dart (RandomWordsState)" title region="RWS-class-only" plaster="// TODO Add build() method" indent-by="2"?>
    ```dart
      class RandomWordsState extends State<RandomWords> {
        // TODO Add build() method
      }
    ```

    Nota la declaración `State<RandomWords>`. Esto indica que estamos 
    usando una clase 
    [State]({{site.api}}/flutter/widgets/State-class.html)
    genérica especializada para usar `RandomWords`. La mayoría de la lógica y el estado 
    de la app residen aquí&mdash;esto mantiene el estado para el widget `RandomWords`.
    Esta clase guarda el par de palabras generados, que crecen infinitamente cuando el 
    usuario hace scrolls, y los pares de palabras favoritos (en la
    [parte 2]({{site.codelabs}}/codelabs/first-flutter-app-pt2)),
    que el usuario añade o elimina de la lista alternando con el icon del corazón.

    `RandomWordsState` depende de la clase `RandomWords`. La añadirás a continuación.

 2. Añade el widget stateful `RandomWords` a `main.dart`.
    El widget `RandomWords` hace poco más aparte de crear su clase State:

    <?code-excerpt "lib/main.dart (RandomWords)" title indent-by="2"?>
    ```dart
      class RandomWords extends StatefulWidget {
        @override
        RandomWordsState createState() => new RandomWordsState();
      }
    ```

    Después de agregar esta clase de estado, el IDE mostrará que
    a la clase le hace falta el método build. Siguiente, agregar un método
    build básico que genera el juego de palabras moviendo la
    generación de código de `MyApp` a `RandomWordsState`.

 3. Añade el método `build()` a `RandomWordsState`:

    <?code-excerpt "lib/main.dart (RandomWordsState)" title indent-by="2" replace="/(\n  )(.*)/$1[!$2!]/g"?>
    ```dart
      class RandomWordsState extends State<RandomWords> {
        [!@override!]
        [!Widget build(BuildContext context) {!]
        [!  final wordPair = WordPair.random();!]
        [!  return Text(wordPair.asPascalCase);!]
        [!}!]
      }
    ```

 4. Elimina el código de generación de palabras de `MyApp` haciendo los cambios que se muestran en el siguiente diff:

     <?code-excerpt path-base="codelabs/startup_namer"?>
    <?code-excerpt "{step2_use_package,step3_stateful_widget}/lib/main.dart" to="}"?>
    ```diff
    --- step2_use_package/lib/main.dart
    +++ step3_stateful_widget/lib/main.dart
    @@ -6,7 +6,6 @@
     class MyApp extends StatelessWidget {
       @override
       Widget build(BuildContext context) {
    -    final wordPair = WordPair.random();
         return MaterialApp(
           title: 'Welcome to Flutter',
           home: Scaffold(
    @@ -14,8 +13,8 @@
               title: Text('Welcome to Flutter'),
             ),
             body: Center(
    -          child: Text(wordPair.asPascalCase),
    +          child: RandomWords(),
             ),
           ),
         );
       }
    ```

 5. Reinicia la app.
    La app debería comportarse como antes, mostrando una palabra 
    emparejada cada vez que haces hot reload o guardas la app.

{{site.alert.tip}}
  Si ves la siguiente advertencia en el hot reload, considera reiniciar la app:
   **Reloading...<br>

  Some program elements were changed during reload but did not run when
  the view was reassembled; you may need to restart the app (by pressing "R")
  for the changes to have an effect.**

  Podría ser un falso positivo, pero considere reiniciar en orden de asegurar estos
  cambios sean reflejados en la UI de la app.

{{site.alert.end}}


## ¿Problemas?
{:.no_toc}

Si tu app no esta corriendo correctamente, puedes utilizar este código
del siguiente enlace y continuar.

* [lib/main.dart]({{code-url}}/startup_namer/step3_stateful_widget/lib/main.dart)


# Paso 4: Crear un ListView de scroll infinito

<?code-excerpt path-base="codelabs/startup_namer/step4_infinite_list"?>

En este paso, extenderemos la clase `RandomWordsState` para generar
y desplegar una lista de palabras. Mientras el usuario se desplaza, la lista
lo desplegara en un widget `ListView`, que crecerá infinitamente. El `builder` factory 
constructor del  `ListView` permite construir una lista de carga 
retrasada, a petición.

 1. Añade una lista `_suggestions` a la clase `RandomWordsState`
    para guardar pares de palabras sugeridas.
    También, agrega una variable `_biggerFont` para hacer el tamaño de la fuente más grande.
    
    <?code-excerpt "lib/main.dart" title region="RWS-var" indent-by="2" replace="/final .*/[!$&!]/g"?>
    ```dart
      class RandomWordsState extends State<RandomWords> {
        [!final _suggestions = <WordPair>[];!]
        [!final _biggerFont = const TextStyle(fontSize: 18.0);!]
        // ···
      }
    ```

    {{site.alert.note}}
      Prefijar un identificador con guion bajo [lo fuerza a ser 
      privado]({{site.dart-site}}/guides/language/language-tour)
      in the Dart language.
    {{site.alert.end}}

    A continuación añade una función `_buildSuggestions()` a la clase `RandomwordsState`.
    Este método construirá el `ListView` que muestra las 
    palabras sugeridas.

    La clase `ListView` provee una propiedad builder, `itemBuilder`,
    un factory builder y un función callback especificada como función anónima,
    dos parámetros se pasan a la función&mdash;el `BuildContext`, 
    y un fila de iteración , `i`. El iterador empieza desde 0 e incrementa
    cada vez que la función es llamada. Este incrementa dos veces por cada pareja de palabras sugeridas: 
    una para el ListTile, y una para el Divider. Este modelo permite a la lista de sugerencias crecer infinitamente cuando el usuario hace scroll.

 2. Añade una función `_buildSuggestions()`, mostrada 
    abajo, a la clase `RandomWordsState` (borra los comentarios, si lo prefieres).

    <?code-excerpt "lib/main.dart (_buildSuggestions)" title indent-by="2"?>
    ```dart
      Widget _buildSuggestions() {
        return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: /*1*/ (context, i) {
              if (i.isOdd) return Divider(); /*2*/

              final index = i ~/ 2; /*3*/
              if (index >= _suggestions.length) {
                _suggestions.addAll(generateWordPairs().take(10)); /*4*/
              }
              return _buildRow(_suggestions[index]);
            });
      }
    ```
    {:.numbered-code-notes}
     1. El callback `itemBuilder` es llamado una vez por cada par de palabras sugeridas,
        y coloca cada sugerencia en una fila `ListTile`. Por cada fila, la
        función añade una fila `ListTile` para las parejas de 
        palabras. Para las filas impares, la
        función añade un widget `Divider` para separar visualmente 
        las entradas. Nota
        que este divisor puede ver ser difícil de ver en los
        dispositivos más pequeños.
     2. Añade un widget divisor de un pixel de altura antes de
      cada fila en el `ListView`.
     3. La expresión `i ~/ 2` divide `i` entre 2 y devuelve un 
     resultado entero.
        Por ejemplo: 1, 2, 3, 4, 5 dan como resultado 0, 1, 1, 2, 2. Esto calcula el actual numero de palabras emparejadas en el `ListView`, menos los widgests 
        divisores.
     4. Si has alcanzado el final de los pares de palabras disponibles, entonces genera
        10 más y añade estos a la lista de sugerencias.

    La función `_buildSuggestions()` llama a `_buildRow()` una vez por
    cada pareja de palabras. Esta función muestra cada pareja en un `ListTile`,
    que te permite hacer las filas más atractivas en el siguiente paso.

 3. Añade una función `_buildRow()` a `RandomWordsState`:

    <?code-excerpt "lib/main.dart (_buildRow)" title indent-by="2"?>
    ```dart
      Widget _buildRow(WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      }
    ```

 4. En la clase `RandomWordsState`, actualiza el método `build` 
    para usar `_buildSuggestions()`, mejor que llamar directamente a la 
    biblioteca de generación de palabras.
    ([Scaffold]({{site.api}}/flutter/material/Scaffold-class.html)
    implementa el layout visual básico de Material Design.)

    Reemplaza el cuerpo del método con el código marcado:

    <?code-excerpt "lib/main.dart (build)" title region="RWS-build" replace="/(\n  )(return.*|  .*|\);)/$1[!$2!]/g" indent-by="2"?>
    ```dart
      @override
      Widget build(BuildContext context) {
        [!return Scaffold(!]
        [!  appBar: AppBar(!]
        [!    title: Text('Startup Name Generator'),!]
        [!  ),!]
        [!  body: _buildSuggestions(),!]
        [!);!]
      }
    ```

 5. Actualiza el método `build` de `MyApp`, cambiando el `title`,
    y cambiando home para ser el widget `RandomWords`.

    Reemplaza el método original con el método `build` remarcado abajo:
      
   <?code-excerpt path-base="codelabs/startup_namer"?>
    <?code-excerpt "{step3_stateful_widget,step4_infinite_list}/lib/main.dart" diff-u="4" from="class MyApp" to="}"?>
    ```diff
    --- step3_stateful_widget/lib/main.dart
    +++ step4_infinite_list/lib/main.dart
    @@ -6,15 +6,8 @@
     class MyApp extends StatelessWidget {
       @override
       Widget build(BuildContext context) {
         return MaterialApp(
    -      title: 'Welcome to Flutter',
    -      home: Scaffold(
    -        appBar: AppBar(
    -          title: Text('Welcome to Flutter'),
    -        ),
    -        body: Center(
    -          child: RandomWords(),
    -        ),
    -      ),
    +      title: 'Startup Name Generator',
    +      home: RandomWords(),
         );
       }
    ```

 6. Reinicia la app. Deberías ver una lista de palabras emparejadas, no importa lo lejos
    que hagas scroll.

    {% indent %}
         {% include android-ios-figure-pair.md image="step4-infinite-list.png" alt="App at completion of fourth step" %}
    {% endindent %}

## ¿Problemas?
{:.no_toc}

Si tu app no está funcionando correctamente, puedes ver el código
en el siguiente enlace y continuar.

* [lib/main.dart]({{code-url}}/startup_namer/step4_infinite_list/lib/main.dart)


# Siguientes pasos
{:.no_toc}

{% include app-figure.md class="site-image-right" img-class="border"
    image="get-started/startup-namer.gif" caption="The app from part 2" %}

Enhorabuena!

Has escrito una app interactiva en Flutter que se ejecuta en ambos iOS y Android
En este laboratorio, tú has:

* Creado una app de Flutter desde cero.
* Escrito código Dart.
* Utilizado una librería externa de terceros.
* Usado hot reload para un ciclo de desarrollo más rápido.
* Implementado un widget stateful.
* Creado una lista de scroll infinito, de carga retrasada.

Si deseas extender esta app, procede con la
[parte 2]({{site.codelabs}}/codelabs/first-flutter-app-pt2)
en el sitio 
[Google Developers Codelabs]({{site.codelabs}}/),
donde añadirás la siguiente funcionalidad:
 * Implementar interactividad añadiendo un icono corazón pulsable para guardar 
 tus parejas de palabras favoritas.
* Implementar navegación a una nueva ruta añadiendo una nueva pantalla 
conteniendo los favoritos guardados.
* Modificar el color del tema, fabricando una app todo-blanco.
