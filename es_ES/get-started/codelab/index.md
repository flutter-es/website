---
layout: tutorial
title: Escribe tu primer app en Flutter
permalink: /get-started/codelab/
image: /get-started/codelab/images/step7-themes.png
---

<figure class="right-figure" style="max-width: 260px; padding-right: 10px">
    <img src="images/startup-namer-app.gif"
         alt="Animated GIF of the app that you will be building."
         style="border: 10px solid #333; border-radius: 10px; margin-bottom: 10px" >
</figure>

Esta es una guia para crear tu primer app en Flutter. Si la
programación orientada a objetos te es familiar y conceptos básicos
de programación como variables, ciclos y condicionales,
podras completar este tutorial. No se necesita
experiencia previa con Dart o programación móvil.

{% comment %}
TODO: (maybe, but later)
- Retake screenshots on the Android emulator? (Tao)
  Maybe alternate between Android and iOS emulators?
- Somehow cross link from code to text so people can restart
  and find their place more easily? (Tao)
{% endcomment %}

* TOC
{:toc}

## Que haremos
{:.no_toc}

Se implementara una app móvil sencilla que generara nombres propuestos para un
empresa que inicia. El usuario puede seleccionar o deseleccionar nombres,
almacenando los mejores. El código genera nombres de diez en diez.
Mientras el usuario busca, nuevos juegos de nombres son generados.
El user puede puede tocar el icono de lista en la orilla superior derecha en la barra de la app
para moverse a una nueva ruta que muestra únicamente los nombre favoritos.

El GIF animado muestra como se vera el producto terminado.

<div class="whats-the-point" markdown="1">
  <h4>Que aprenderemos</h4>

  * Estructura básica de una app en Flutter.
  * Encontrar y utilizar paquetes para extender funcionalidades.
  * Usar hot reload para un ciclo de desarrollo mas rápido.
  * Como implementar un "stateful widget".
  * Como crear una lista de carga lenta e infinita.
  * Como crear y navegar a una segunda pantalla.
  * Como cambiar el estilo de una app utilizando "Themes".
</div>

<div class="whats-the-point" markdown="1">
  <h4>Que usaremos</h4>

  Necesitaremos instalar lo siguiente:

  - Flutter SDK<br>
    El SDK de Flutter incluye el motor de Flutter, framework, widgets, herramientas,
    y un SDK de Dart. Este laboratorio necesita v0.1.4 o superior.

  - Android Studio IDE<br>
    Este laboratorio utiliza el IDE de Android Studio, Peropuedes utilizar otro
    IDE, o trabajar de la linea de comandos.

  - Complementos para el IDE<br>
    Los complementes de Flutter y Dart deber ser instalado por separado para el
    IDE. Ademas Android Studio, los complementos Flutter y Dart tambien estan disponibles
    para los IDEs [VS Code](https://code.visualstudio.com/download) e
    [IntelliJ](https://www.jetbrains.com/idea/download/#section=mac).

  Vea [Instalación y configuración de Flutter](/get-started/install/) para mas informacion de
  como configurar el ambiente de trabajo.
</div>

# Paso 1: Crear la app inicial de Flutter

Crear un app sencilla desde una plantilla de Flutter, utilizando las intrucciones en
[Iniciando con tu primer app de Flutter.](/get-started/test-drive/#create-app)
Nombre del proyecto **startup_namer** (en lugar de _myapp_).
Modificaras esta app de inicial para crear el app final.

En este laboratorio, mayormente estaras editando **lib/main.dart**,
donde el codigo Dart vive.

{{site.alert.tip}}
  Cuando se pega código dentro de tu app, los margenes pueden
  moverse. Puedes corregir esto automaticamente con las herramientas de Flutter:

  * Android Studio / IntelliJ IDEA: Clic derecho en el código Dart 
  y elige **Reformat Code with dartfmt**.
  * VS Code: Clic derecho y seleccionar **Format Document**.
  * Terminal: Ejecuta el comando `flutter format <filename>`.
{{site.alert.end}}

 1. Reemplaza `lib/main.dart`.<br>
    Borra todo el codigo de **lib/main.dart**.
    Reemplaza con el siguiente código, el cual muestra "Hello World" en el centro
    de la pantalla. 

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

 2. Ejecuta el app. Deberas ver la siguiente pantalla.

    <center><img src="images/hello-world-screenshot.png" alt="screenshot of hello world app"></center>


## Observations
{:.no_toc}

- Este ejemplo crea una "Material app".
  [Material](https://material.io/guidelines/) es un lenguaje de diseño visual
  el cual es un estandar en web y móvil. Flutter ofrece un gran conjunto
  de "Material widgets".
- El metodo main especifíca con la siguiente notación de flecha (`=>`),
  la cual es una manera corta usada para funciones o metodos de una linea.
- La app hereda de `StatelessWidget` el cual hace a la app misma un
  widget. En Flutter, casi todo es un widget, incluyendo
  alignment, padding, y layout.
- El widget `Scaffold`, de la libreria de Material,
  provee una "app bar" por defecto, "title", y una propiedad "body" el cual
  soporta el arbol de widget para la pantalla de inicio. El subarbol de widget
  puede ser bastante complejo.
- El trabajo principal de un widget es proveer un metodo `build()`
  el cual describe como mostrar un widget en termino de otro,
  widgets de bajo nivel.
- El árbol de widget para este ejemplo consisteen un widget `Center`
  que contiene un child widget `Text`. El widget `Center` alinea un subárbol de 
  widgets al centro de la pantalla.

{% comment %}
  Removing this for now. A) It might be confusing and B) the code as shown here is wrong.
  <li markdown="1"> Moving the “hello world” text into a separate widget,
      HelloWorld, results in an identical widget tree as the code above.
      (This code is informational only. You are starting with the Hello
      World code above.)

  <!-- skip -->
  {% prettify dart %}
  import 'package: flutter/material.dart';

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
           child: Text('Hello World')
         ),
       ),
     );
   }
  }
  {% endprettify %}

  Actualiza con el siguiente código:

  class HelloWorld extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return Center(
       child: Text('Hello World'),
     );
   }
  }
  </li>
{% endcomment %}

---

# Paso 2: Usar un paquete externo

En este paso, empezaras utilizando un paquete de código libre llamado
**english_words**, el cual contiene uno cuantos de miles de las palabras
en Ingles mas utilizadas ademas de otras funciones de utilidad.

Puedes encontrar el paquete
[english_words](https://pub.dartlang.org/packages/english_words),
asi como muchas otros paquetes de código libre en
[pub.dartlang.org](https://pub.dartlang.org/flutter/).

 1. El archivo pubspec gestiona los activos para una app Flutter.
    En **pubspec.yaml**, agrega **english_words** (3.1.0 o mayor)
    a las lista de dependencias.
    La nueva linea es resaltada abajo:

    {% prettify yaml %}
      dependencies:
        flutter:
          sdk: flutter

        cupertino_icons: ^0.1.0
        [[highlight]]english_words: ^3.1.0[[/highlight]]
    {% endprettify %}

 2. Mientras vez el pubspec en el editor de Android Studio,
    clic **Packages get** arriba a la derecha. Esto trae los paquetes dentro
    del proyecto. Se debera ver lo siguiente en la consola:

    ```terminal
    > flutter packages get
    Running "flutter packages get" in startup_namer...
    Process finished with exit code 0
    ```

 3. En **lib/main.dart**, agrega el "import" para `english_words`,
    como se muestra resaltado en la linea:

    <!-- skip -->
    {% prettify dart %}
      import 'package:flutter/material.dart';
      [[highlight]]import 'package:english_words/english_words.dart';[[/highlight]]
    {% endprettify %}

    Mientras tecleas, Android Studio da sugerencias para las librerias a
    importar. Entonces renderiza el texto de "import" en gris, haciendote 
    saber que la libreria importada no ha sido utilizada (hasta el momento).

 4. Usa el paquete de palabras en Ingles para generar texto en lugar de
    utilizar el texto "Hello World".

    {{site.alert.note}}
      "Pascal case" (tambien conocido como "upper camel case"),
      significa que cada palabra en el texto, incluyendo la primera, 
      empezara con letra mayúscula. Entonces, "uppercamelcase" se convierte
      "UpperCamelCase".
    {{site.alert.end}}

    Realiza los siguientes cambios, como se resalta abajo:

    <!-- skip -->
    {% prettify dart %}
      import 'package:flutter/material.dart';
      import 'package:english_words/english_words.dart';

      void main() => runApp(MyApp());

      class MyApp extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
          [[highlight]]final wordPair = WordPair.random();[[/highlight]]
          return MaterialApp(
            title: 'Welcome to Flutter',
            home: Scaffold(
              appBar: AppBar(
                title: Text('Welcome to Flutter'),
              ),
              body: Center(
                //child: Text([[highlight]]'Hello World'[[/highlight]]), // Replace the highlighted text...
                child: Text([[highlight]]wordPair.asPascalCase[[/highlight]]),  // With this highlighted text.
              ),
            ),
          );
        }
      }
    {% endprettify %}

 5. Si la app esta ejecutandose, utilice el boton de hot reload
    (<img src="images/hot-reload-button.png" alt="lightning bolt icon">)
    para actualizar el app. Cada vez que se presione hot reload
    o se guarde el proyecto, debera verse una diferente palabra,
    eligida aleatoreamente, en la app.
    Esto es debido a que las palabras generadas dentro de el metodo "build",
    el cual se ejecuta cada vez que la MaterialApp requiere renderizar
    o cuando
    This is because the word pairing is generated inside the build
    method, which is run each time the MaterialApp requires rendering,
    o al alternar la plataforma en el inspector de Flutter .

<center><img src="images/step2-screenshot.png" alt="screenshot at completion of second step"></center>


## Problemas?
{:.no_toc}

Si tu app no esta ejecutandoce correctamente, busque por errores al teclear. De ser necesario,
use el código en el siguiente enlace, para hacer una revisión hacia atras.

* [**pubspec.yaml**](https://gist.githubusercontent.com/Sfshaza/bb51e3b7df4ebbf3dfd02a4a38db2655/raw/57c25b976ec34d56591cb898a3df0b320e903b99/pubspec.yaml)
(El archivo **pubspec.yaml** no cambiara de nuevo.)
* [**lib/main.dart**](https://gist.githubusercontent.com/Sfshaza/bb51e3b7df4ebbf3dfd02a4a38db2655/raw/57c25b976ec34d56591cb898a3df0b320e903b99/main.dart)

---

# Paso 3: Agregar un Stateful widget

State<em>less</em> widgets son inmutables, esto quiere decir que
sus propiedades no puedes cambiar&mdash;todos sus valores son finales.

State<em>ful</em> widgets mantienes un estado que puede cambiar
durente el tiempo de vida del widget. Implementar un stateful
widget necesira al menos dos clases: 1) una clase StatefulWidget
la cual crea la instancia 2) una clase State. La clase StatefulWidget es,
a si misma, inmutable, pero la clase State persiste sobre el tiempo de
vida de el widget.

En este paso, agregaras un stateful widget, RandomWords, el cual crea su clase
State, RandomWordsState. La clase State eventualmente
mantendra las palabras propuestas y favoritas para el widget.

 1. Agrega el stateful RandomWords widget a main.dart.
    Puede ir en cualquier lugar del archivo, fuera de MyApp, pero la solución
    la coloca al final del archivo. El RandomWords widget hace poco ademas de 
    crear su clase State:

    <!-- skip -->
    {% prettify dart %}
    class RandomWords extends StatefulWidget {
      @override
      createState() => RandomWordsState();
    }
    {% endprettify %}

 2. Agrega la clase RandomWordsState. La mayorias de el código de la
    app se encuentra en esta clase, la cual mantiene el estado para el
    RandomWords widget. Esta clase salvara las palabras generadas,
    el cual crece infinitamente mientra el usuario de desplaza, y tambien las palabras
    favoritas, mientras el uduario agregue o elimine de la lista
    seleccionando el icono de corazón.

    Contruira esta clase poco a poco. Para empezar, creando una clase pequeña
    y agregando el texto resaltado:

    <!-- skip -->
    {% prettify dart %}
    [[highlight]]class RandomWordsState extends State<RandomWords> {[[/highlight]]
    [[highlight]]}[[/highlight]]
    {% endprettify %}

 3. Despues de agregar esta clase de estado, el IDE se quejara que
    a la clase le hace falta el metodo build. Siguiente, agregar un metodo
    build basico que genera el juego de palabras moviendo la
    generacion de códigog de MyApp a RandomWordsState.

    Agregar el metodo build a RandomWordState, como se muestra
    en el siguiente texto resaltado:

    <!-- skip -->
    {% prettify dart %}
    class RandomWordsState extends State<RandomWords> {
      [[highlight]]@override[[/highlight]]
      [[highlight]]Widget build(BuildContext context) {[[/highlight]]
        [[highlight]]final wordPair = WordPair.random();[[/highlight]]
        [[highlight]]return Text(wordPair.asPascalCase);[[/highlight]]
      [[highlight]]}[[/highlight]]
    }
    {% endprettify %}

 4. Elimine la generación de código de MyApp haciendo los
    cambios resaltados como es la parte de abajo:

    <!-- skip -->
    {% prettify dart %}
    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        [[strike]]final wordPair = WordPair.random();[[/strike]]  // Delete this line

        return MaterialApp(
          title: 'Welcome to Flutter',
          home: Scaffold(
            appBar: AppBar(
              title: Text('Welcome to Flutter'),
            ),
            body: Center(
              //child: [[highlight]]Text(wordPair.asPascalCase),[[/highlight]] // Change the highlighted text to...
              child: [[highlight]]RandomWords(),[[/highlight]] // ... this highlighted text
            ),
          ),
        );
      }
    }
    {% endprettify %}

Reinicia la app. Si se intenta un hot reload, podria ver el siguiente mensaje de precaución:

```nocode
Reloading...
Not all changed program elements ran during view reassembly; consider
restarting.
```

Podria ser un falso positivo, pero considere reiniciar en orden de asegurar estos
cambios sean refrejados en la UI de la app.

La app debera mostrar el comportamiento de antes, mostrando un juego de palabras
cada vez que que se haga un hot reload o guarde la app.

<center><img src="images/step3-screenshot.png" alt="screenshot at completion of third step"></center>

## Problemas?
{:.no_toc}

Si tu app no esta corriendo correctamente, puede utilizar este código
de el siguiente enlace para regresar a la normalidad.

* [**lib/main.dart**](https://gist.githubusercontent.com/Sfshaza/d7f13ddd8888556232476be8578efe40/raw/329c397b97309ce99f834bf70ebb90778baa5cfe/main.dart)

---

# Paso 4: Crear un ListView de scroll infinito

In this step, you'll expand RandomWordsState to generate
and display a list of word pairings. As the user scrolls, the list
displayed in a ListView widget, grows infinitely. ListView's
`builder` factory constructor allows you to build a list view
lazily, on demand.

 1. Add a `_suggestions` list to the RandomWordsState
    class for saving suggested word pairings. The variable begins with
    an underscore (`_`)&mdash;prefixing an identifier with an underscore enforces
    privacy in the Dart language.

    Also, add a `biggerFont` variable for making the font size larger.

    <!-- skip -->
    {% prettify dart %}
    class RandomWordsState extends State<RandomWords> {
      [[highlight]]final _suggestions = <WordPair>[];[[/highlight]]

      [[highlight]]final _biggerFont = const TextStyle(fontSize: 18.0);[[/highlight]]
      ...
    }
    {% endprettify %}

 2. Add a `_buildSuggestions()` function to the RandomWordsState
    class. This method builds the ListView that displays the suggested word
    pairing.

    The ListView class provides a builder property, `itemBuilder`,
    a factory builder and callback function specified as an anonymous function.
    Two parameters are passed to the function&mdash;the BuildContext,
    and the row iterator, `i`. The iterator begins at 0 and increments
    each time the function is called, once for every suggested word pairing.
    This model allows the suggested list to grow infinitely as the user scrolls.

    Add the highlighted lines below:

    <!-- skip -->
    {% prettify dart %}
    class RandomWordsState extends State<RandomWords> {
      ...
      [[highlight]]Widget _buildSuggestions() {[[/highlight]]
        [[highlight]]return ListView.builder([[/highlight]]
          [[highlight]]padding: const EdgeInsets.all(16.0),[[/highlight]]
          // The itemBuilder callback is called once per suggested word pairing,
          // and places each suggestion into a ListTile row.
          // For even rows, the function adds a ListTile row for the word pairing.
          // For odd rows, the function adds a Divider widget to visually
          // separate the entries. Note that the divider may be difficult
          // to see on smaller devices.
          [[highlight]]itemBuilder: (context, i) {[[/highlight]]
            // Add a one-pixel-high divider widget before each row in theListView.
            [[highlight]]if (i.isOdd) return Divider();[[/highlight]]

            // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
            // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
            // This calculates the actual number of word pairings in the ListView,
            // minus the divider widgets.
            [[highlight]]final index = i ~/ 2;[[/highlight]]
            // If you've reached the end of the available word pairings...
            [[highlight]]if (index >= _suggestions.length) {[[/highlight]]
              // ...then generate 10 more and add them to the suggestions list.
              [[highlight]]_suggestions.addAll(generateWordPairs().take(10));[[/highlight]]
            [[highlight]]}[[/highlight]]
            [[highlight]]return _buildRow(_suggestions[index]);[[/highlight]]
          [[highlight]]}[[/highlight]]
        [[highlight]]);[[/highlight]]
      [[highlight]]}[[/highlight]]
    }
    {% endprettify %}

 3. The `_buildSuggestions` function calls `_buildRow` once per
    word pair. This function displays each new pair in a ListTile,
    which allows you to make the rows more attractive in the next step.

    Add a `_buildRow` function to RandomWordsState:

    <!-- skip -->
    {% prettify dart %}
    class RandomWordsState extends State<RandomWords> {
      ...

      [[highlight]]Widget _buildRow(WordPair pair) {[[/highlight]]
        [[highlight]]return ListTile([[/highlight]]
          [[highlight]]title: Text([[/highlight]]
            [[highlight]]pair.asPascalCase,[[/highlight]]
            [[highlight]]style: _biggerFont,[[/highlight]]
          [[highlight]]),[[/highlight]]
        [[highlight]]);[[/highlight]]
      [[highlight]]}[[/highlight]]
    }
    {% endprettify %}

 4. Update the build method for RandomWordsState to use
    `_buildSuggestions()`, rather than directly calling the word
    generation library. Make the highlighted changes:

    <!-- skip -->
    {% prettify dart %}
    class RandomWordsState extends State<RandomWords> {
      ...
      @override
      Widget build(BuildContext context) {
        [[strike]]final wordPair = WordPair.random();[[/strike]] // Delete these two lines.
        [[strike]]return Text(wordPair.asPascalCase);[[/strike]]
        [[highlight]]return Scaffold ([[/highlight]]
          [[highlight]]appBar: AppBar([[/highlight]]
            [[highlight]]title: Text('Startup Name Generator'),[[/highlight]]
          [[highlight]]),[[/highlight]]
          [[highlight]]body: _buildSuggestions(),[[/highlight]]
        [[highlight]]);[[/highlight]]
      }
      ...
    }
    {% endprettify %}

 5. Update the build method for MyApp.
    Remove the Scaffold and AppBar instances from MyApp.
    These will be managed by RandomWordsState, which makes it easier to
    change the name of the route in the app bar as the user
    navigates from one screen to another in the next step.

    Replace the original method with the highlighted build method below:

    <!-- skip -->
    {% prettify dart %}
    class MyApp extends StatelessWidget {
      @override
      [[highlight]]Widget build(BuildContext context) {[[/highlight]]
        [[highlight]]return MaterialApp([[/highlight]]
          [[highlight]]title: 'Startup Name Generator',[[/highlight]]
          [[highlight]]home: RandomWords(),[[/highlight]]
        [[highlight]]);[[/highlight]]
      [[highlight]]}[[/highlight]]
    }
    {% endprettify %}

Restart the app. You should see a list of word pairings. Scroll down
as far as you want and you will continue to see new word pairings.

<center><img src="images/step4-screenshot.png" alt="screenshot at completion of fourth step"></center>

## Problems?
{:.no_toc}

If your app is not running correctly, you can use the code
at the following link to get back on track.

* [**lib/main.dart**](https://gist.githubusercontent.com/Sfshaza/d6f9460a04d3a429eb6ac0b0f07da564/raw/34fe240f4122435c871bb737708ee0357741801c/main.dart)

---

# Step 5: Add interactivity

In this step, you'll add tappable heart icons to each row.
When the user taps an entry in the list, toggling its
"favorited" state, that word pairing is added or removed from a
set of saved favorites.

 1. Add a `_saved` Set to RandomWordsState. This Set stores
    the word pairings that the user favorited. Set is preferred to List
    because a properly implemented Set does not allow duplicate entries.

    <!-- skip -->
    {% prettify dart %}
    class RandomWordsState extends State<RandomWords> {
      final _suggestions = <WordPair>[];

      [[highlight]]final _saved = Set<WordPair>();[[/highlight]]

      final _biggerFont = const TextStyle(fontSize: 18.0);
      ...
    }
    {% endprettify %}

 2. In the `_buildRow` function, add an `alreadySaved`
    check to ensure that a word pairing has not already been added to
    favorites.

    <!-- skip -->
    {% prettify dart %}
      Widget _buildRow(WordPair pair) {
        [[highlight]]final alreadySaved = _saved.contains(pair);[[/highlight]]
        ...
      }
    {% endprettify %}

 3. Also in `_buildRow()`, add heart-shaped icons to the
    ListTiles to enable favoriting. Later, you'll add the ability to
    interact with the heart icons.

    Add the highlighted lines below:

    <!-- skip -->
    {% prettify dart %}
      Widget _buildRow(WordPair pair) {
        final alreadySaved = _saved.contains(pair);
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          [[highlight]]trailing: Icon([[/highlight]]
            [[highlight]]alreadySaved ? Icons.favorite : Icons.favorite_border,[[/highlight]]
            [[highlight]]color: alreadySaved ? Colors.red : null,[[/highlight]]
          [[highlight]]),[[/highlight]]
        );
      }
    {% endprettify %}

 4. Restart the app. You should now see open hearts on
    each row, but they are not yet interactive.

 5. Make the name suggestion tiles tappable in the `_buildRow`
    function. If a word entry has already been added to favorites,
    tapping it again removes it from favorites.
    When a tile has been tapped, the function calls
    `setState()` to notify the framework that state has changed.

    Add the highlighted lines:

    <!-- skip -->
    {% prettify dart %}
      Widget _buildRow(WordPair pair) {
        final alreadySaved = _saved.contains(pair);
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          trailing: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
          ),
          [[highlight]]onTap: () {[[/highlight]]
            [[highlight]]setState(() {[[/highlight]]
              [[highlight]]if (alreadySaved) {[[/highlight]]
                [[highlight]]_saved.remove(pair);[[/highlight]]
              [[highlight]]} else {[[/highlight]]
                [[highlight]]_saved.add(pair);[[/highlight]]
              [[highlight]]}[[/highlight]]
            [[highlight]]});[[/highlight]]
          [[highlight]]},[[/highlight]]
        );
      }
    {% endprettify %}

{{site.alert.tip}}
  In Flutter's react style framework, calling `setState()`
  triggers a call to the `build()` method for the State object, resulting in an
  update to the UI.
{{site.alert.end}}

Hot reload the app. You should be able to tap any tile to favorite, or unfavorite,
the entry. Note that tapping a tile generates an implicit ink splash animation
that emanates from wherever you tapped.

<center><img src="images/step5-screenshot.png" alt="screenshot at completion of 5th step"></center>

## Problems?
{:.no_toc}

If your app is not running correctly, you can use the code
at the following link to get back on track.

* [**lib/main.dart**](https://gist.githubusercontent.com/Sfshaza/936ce0059029a8c6e88aaa826a3789cd/raw/a3065d5c681a81eff32f75a9cd5f4d9a5b24f9ff/main.dart)

---

# Step 6: Navigate to a new screen

In this step, you'll add a new screen (called a _route_ in Flutter) that
displays the favorites. You'll learn how to navigate between the home route
and the new route.

In Flutter, the Navigator manages a stack containing the app's routes.
Pushing a route onto the Navigator's stack, updates the display to that route.
Popping a route from the Navigator's stack, returns the display to the previous
route.

 1. Add a list icon to the AppBar in the build method
    for RandomWordsState.  When the user clicks the list icon, a new
    route that contains the favorites items is pushed to the Navigator,
    displaying the icon.

    {{site.alert.tip}}
      Some widget properties take a single widget (`child`), and other properties,
      such as `action`, take an array of widgets (`children`),
      as indicated by the square brackets (`[]`).
    {{site.alert.end}}

    Add the icon and its corresponding action to the build method:

    <!-- skip -->
    {% prettify dart %}
    class RandomWordsState extends State<RandomWords> {
      ...
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Startup Name Generator'),
            [[highlight]]actions: <Widget>[[[/highlight]]
              [[highlight]]IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),[[/highlight]]
            [[highlight]]],[[/highlight]]
          ),
          body: _buildSuggestions(),
        );
      }
      ...
    }
    {% endprettify %}

 2. Add a `_pushSaved()` function to the RandomWordsState class.

    <!-- skip -->
    {% prettify dart %}
    class RandomWordsState extends State<RandomWords> {
      ...
      [[highlight]]void _pushSaved() {[[/highlight]]
      [[highlight]]}[[/highlight]]
    }
    {% endprettify %}

    Hot reload the app. The list icon appears in the app bar.
    Tapping it does nothing yet, because the `_pushSaved` function is empty.

 3. When the user taps the list icon in the app bar,
    build a route and push it to the Navigator's stack.
    This action changes the screen to display the new route.

    The content for the new page is built in MaterialPageRoute's `builder`
    property, in an anonymous function.

    Add the call to Navigator.push, as shown by the highlighted code,
    which pushes the route to the Navigator's stack.

    <!-- skip -->
    {% prettify dart %}
      [[highlight]]void _pushSaved() {[[/highlight]]
        [[highlight]]Navigator.of(context).push([[/highlight]]
        [[highlight]]);[[/highlight]]
      [[highlight]]}[[/highlight]]
    {% endprettify %}

 4. Add the MaterialPageRoute and its builder. For now,
    add the code that generates the ListTile rows. The `divideTiles()`
    method of ListTile adds horizontal spacing between each ListTile.
    The `divided` variable holds the final rows, converted to a list
    by the convenience function, `toList()`.

    <!-- skip -->
    {% prettify dart %}
      void _pushSaved() {
        Navigator.of(context).push(
          [[highlight]]MaterialPageRoute([[/highlight]]
            [[highlight]]builder: (context) {[[/highlight]]
              [[highlight]]final tiles = _saved.map([[/highlight]]
                [[highlight]](pair) {[[/highlight]]
                  [[highlight]]return ListTile([[/highlight]]
                    [[highlight]]title: Text([[/highlight]]
                      [[highlight]]pair.asPascalCase,[[/highlight]]
                      [[highlight]]style: _biggerFont,[[/highlight]]
                    [[highlight]]),[[/highlight]]
                  [[highlight]]);[[/highlight]]
                [[highlight]]},[[/highlight]]
              [[highlight]]);[[/highlight]]
              [[highlight]]final divided = ListTile[[/highlight]]
                [[highlight]].divideTiles([[/highlight]]
                  [[highlight]]context: context,[[/highlight]]
                  [[highlight]]tiles: tiles,[[/highlight]]
                [[highlight]])[[/highlight]]
                [[highlight]].toList();[[/highlight]]
            [[highlight]]},[[/highlight]]
          [[highlight]]),[[/highlight]]
        );
      }
    {% endprettify %}

 5. The builder property returns a Scaffold,
    containing the app bar for the new route, named
    "Saved Suggestions." The body of the new route
    consists of a ListView containing the ListTiles rows;
    each row is separated by a divider.

    Add the highlighted code below:

    <!-- skip -->
    {% prettify dart %}
      void _pushSaved() {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              final tiles = _saved.map(
                (pair) {
                  return ListTile(
                    title: Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
                },
              );
              final divided = ListTile
                .divideTiles(
                  context: context,
                  tiles: tiles,
                )
                .toList();

              [[highlight]]return Scaffold([[/highlight]]
                [[highlight]]appBar: AppBar([[/highlight]]
                  [[highlight]]title: Text('Saved Suggestions'),[[/highlight]]
                [[highlight]]),[[/highlight]]
                [[highlight]]body: ListView(children: divided),[[/highlight]]
              [[highlight]]);[[/highlight]]
            },
          ),
        );
      }
    {% endprettify %}

 6. Hot reload the app. Favorite some of the selections and
    tap the list icon in the app bar. The new route appears containing
    the favorites. Note that the Navigator adds a "Back" button to the
    app bar. You did not have to explicitly implement `Navigator.pop`.
    Tap the back button to return to the home route.

<center>
  <img src="images/step6a-screenshot.png" alt="screenshot at completion of 6th step">
  <img src="images/step6b-screenshot.png" alt="second route">
</center>

## Problems?
{:.no_toc}

If your app is not running correctly, you can use the code
at the following link to get back on track.

* [**lib/main.dart**](https://gist.github.com/Sfshaza/bc5547e112e4dc3a1aa87afdf917caeb)

---

# Step 7: Change the UI using Themes

In this final step, you'll play with the app's theme. The
_theme_ controls the look and feel of your app. You can use
the default theme, which is dependent on the physical device
or emulator, or you can customize the theme to reflect your branding.

 1. You can easily change an app's theme by configuring
    the ThemeData class.  Your app currently uses the default theme,
    but you'll be changing the primary color to be white.

    Change the app's theme to white by adding the highlighted code to MyApp:

    <!-- skip -->
    {% prettify dart %}
    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Startup Name Generator',
          [[highlight]]theme: ThemeData([[/highlight]]
            [[highlight]]primaryColor: Colors.white,[[/highlight]]
          [[highlight]]),[[/highlight]]
          home: RandomWords(),
        );
      }
    }
    {% endprettify %}

 2. Hot reload the app. Notice that the entire background is white,
    even the app bar.

 3. As an exercise for the reader, use
    [ThemeData](https://docs.flutter.io/flutter/material/ThemeData-class.html)
    to change other aspects of the  UI. The
    [Colors](https://docs.flutter.io/flutter/material/Colors-class.html)
    class in the Material library provides many color constants you can play with,
    and hot reload makes experimenting with the UI quick and easy.

<center><img src="images/step7-themes.png" alt="screenshot at completion of 7th step"></center>

## Problems?
{:.no_toc}

If you've gotten off track, use the code from the following link
to see the code for the final app.

* [**lib/main.dart**](https://gist.githubusercontent.com/Sfshaza/c07c91a4061fce4b5eacaaf4d82e4993/raw/4001a72c0133b97c8e16bdeb3195ca03525696bd/main.dart)

---

# Bien hecho!

Has escrito una app interactiva en Flutter que se ejecuta en ambos iOS y Android
En este laboratorio, tu has:

* Created a Flutter app from the ground up.
* Written Dart code.
* Leveraged an external, third party library.
* Used hot reload for a faster development cycle.
* Implemented a stateful widget, adding interactivity to your app.
* Created a lazily loaded, infinite scrolling list displayed with a
  ListView and ListTiles.
* Created a route and added logic for moving between the home route
  and the new route.
* Learned about changing the look of your app's UI using Themes.

## Next step
{:.no_toc}

[Learn More](/get-started/learn-more/)
