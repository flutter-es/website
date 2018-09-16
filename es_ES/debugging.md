---
layout: page
title: Depurando aplicaciónes Flutter

permalink: /debugging/
---

Hay una amplia variedad de herramientas y funcionalidades que ayudan a depurar 
las aplicaciones en Flutter.

* TOC Placeholder
{:toc}

<aside class="alert alert-info" markdown="1">
**Nota:** Si el UI de tu app no se ejecuta con la suavidad que esperas,
revisa [Perfiles de Rendimiento en Flutter](/ui-performance/).
</aside>

## Dart Analyzer

Antes de ejecutar tus aplicaciones, prueba tu código con `flutter analyze`. Esta 
herramienta (la cual es una envoltura de la herramienta `dartanalyzer`) analiza tu código 
y te ayuda a encontrar posibles errores. Si estás usando un [IDE/editor que soporte Flutter](/get-started/editor/),
esto ya esta ocurriendo para tí.

Dart analyzer hace un uso intenso de las anotaciones de tipos que pones 
en tu código para ayudar a evitar problemas. Te animamos a usarlo en todas 
partes (evitando `var`, argumentos sin tipo, listas sin tipo,
etc) ya que esta es la forma más rápida y menos dolorosa de rastrear problemas.

## Dart Observatory (depurador y perfilador "statement-level single-stepping")

Si inicias tu aplicación usando `flutter run`, entonces,
mientras se está ejecutando, puedes abrir la página web en la URL de Observatory 
impresa en la consola (ej., `Observatory listening on http://127.0.0.1:8100/`), para 
conectar tu aplicación directamente con un depurador "statement-level single-stepping". 
Si estas usando un [IDE/editor que soporte Flutter](/get-started/editor/),
puedes también depurar tu aplicación usando su depurador incorporado.

Observatory tambien soporta creación de perfiles, examinar el heap, etc. Para mas 
información sobre Observatory, mira la 
[documentación de Observatory](https://dart-lang.github.io/observatory/).

Si usas Observatory para generar perfiles, asegúrate de ejecutar tu 
aplicación en modo profile, pasando `--profile` al comando `flutter run`. 
De otra manera, lo principal que aparecen en tu perfil 
son las aserciones de depuración verificando varias 
invariantes del framework (mira "Aserciones de modo depuración" más abajo).

### Declaración `debugger()`

Cuando usas Dart Observatory (o otro depurador Dart integrado en 
un IDE/editor con soporte para Flutter), puedes insertar 
puntos de interrupción programáticos usando la declaración `debugger()`. 
Para usar esto, tienes que poner `import
'dart:developer';` en la parte superior del fichero relevante.

La declaración `debugger()` toma un argumento opcional `when` en el cual 
puedes especificar que solo se interrumpa cuando una cierta
condición sea cierta, como en:

<!-- import 'dart:developer'; -->
<!-- skip -->
```dart
void someFunction(double offset) {
  debugger(when: offset > 30.0);
  // ...
}
```

## `print` y `debugPrint` con `flutter logs`

La función Dart `print()` sale por la consola del sistema, la cual
puedes ver usando `flutter logs` (que es básicamente una envoltura sobre 
`adb logcat`).

Si la salida es demasiada al mismo tiempo, entonces Android a veces descarta 
algunas lineas de registro. Para evitar esto, puedes usar [`debugPrint()`](https://docs.flutter.io/flutter/foundation/debugPrint.html),
de la biblioteca `foundation` de Flutter. Esto es una envoltura sobre 
`print` que acelera la salida a un nivel que evita que sea descartada 
por el kernel de Android.

La mayoría de las clases en el framework Flutter tienen una útil 
implementación de `toString`. Por convención, este imprime una 
única linea incluyendo usualmente el `runtimeType` del objeto, 
típicamente en la forma 
`ClassName(mas información sobre esta instancia...)`. Algunas clases 
que son usadas en árboles también tienen la función `toStringDeep`, 
que devuelve una descripción en varias líneas del sub-árbol entero en 
este punto. Algunas clases que tienen una implementación del método 
de ayuda `toString` particularmente ~~verbose~~, tienen su correspondiente 
`toStringShort` que devuelve solo el tipo o alguna otra descripción 
muy breve (una o dos palabras) del objeto.

## Aserciones en modo depuración

Durante el desarrollo, se recomienda encarecidamente usar el modo "debug" 
de Flutter. Este es lo predeterminado si usas `flutter run` o el icono 
bug en Android Studio. Algunas herramientas soportan declaraciones de 
aserción a través de la opción por linea de comando `--enable-asserts`.
En este modo, las declaraciones de aserción de Dart están habilitadas, 
y el framework Flutter evalúa el argumento a cada declaración 
de aserción encontrada durante la ejecución, lanzando una excepción 
si el resultado es falso. Esto permite a los desarrolladores habilitar o 
deshabilitar la comprobación de invariantes, de tal manera que el costo 
de rendimiento asociado solo se paga durante las sesiones de depuración.

Cuando una invariante es violada, esto es reportado a la consola, con 
algo de información de contexto para ayudar a encontrar la fuente 
del problema.

Para apagar el modo debug, y usar el modo release, ejecuta tu aplicación 
usando `flutter run --release`. Esto también apaga el depurador Observatory. 
Un modo intermedio que apaga todas las ayudas de depuración _excepto_ 
Observatory, conocido como "profile mode", está disponible también,
usando `--profile` en lugar de `--release`.

## Capas de depuración de la aplicación

Cada capa del framework Flutter proporciona una función para volcar 
su estado o eventos actuales a la consola (usando `debugPrint`).

### Capa de Widgets

Para volcar el estado de la biblioteca de Widgets, llama a 
[`debugDumpApp()`](https://docs.flutter.io/flutter/widgets/debugDumpApp.html).
Puedes llamarlo más o menos en cualquier momento que la aplicación no 
este en medio de la ejecución de la fase de construcción (en otras palabras, 
en cualquier parte que no sea dentro de un método `build()`), siempre que la 
aplicación se haya construido al menos una vez 
(es decir en cualquier momento después de llamar a `runApp()`).

Por ejemplo, esta aplicación:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: AppHome(),
    ),
  );
}

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: FlatButton(
          onPressed: () {
            debugDumpApp();
          },
          child: Text('Dump App'),
        ),
      ),
    );
  }
}
```

...imprime algo parecido a esto (los detalles precisos varían 
con la version del framework, el tamaño del dispositivo, etc.):

```
I/flutter ( 6559): WidgetsFlutterBinding - CHECKED MODE
I/flutter ( 6559): RenderObjectToWidgetAdapter<RenderBox>([GlobalObjectKey RenderView(497039273)]; renderObject: RenderView)
I/flutter ( 6559): └MaterialApp(state: _MaterialAppState(1009803148))
I/flutter ( 6559):  └ScrollConfiguration()
I/flutter ( 6559):   └AnimatedTheme(duration: 200ms; state: _AnimatedThemeState(543295893; ticker inactive; ThemeDataTween(ThemeData(Brightness.light Color(0xff2196f3) etc...) → null)))
I/flutter ( 6559):    └Theme(ThemeData(Brightness.light Color(0xff2196f3) etc...))
I/flutter ( 6559):     └WidgetsApp([GlobalObjectKey _MaterialAppState(1009803148)]; state: _WidgetsAppState(552902158))
I/flutter ( 6559):      └CheckedModeBanner()
I/flutter ( 6559):       └Banner()
I/flutter ( 6559):        └CustomPaint(renderObject: RenderCustomPaint)
I/flutter ( 6559):         └DefaultTextStyle(inherit: true; color: Color(0xd0ff0000); family: "monospace"; size: 48.0; weight: 900; decoration: double Color(0xffffff00) TextDecoration.underline)
I/flutter ( 6559):          └MediaQuery(MediaQueryData(size: Size(411.4, 683.4), devicePixelRatio: 2.625, textScaleFactor: 1.0, padding: EdgeInsets(0.0, 24.0, 0.0, 0.0)))
I/flutter ( 6559):           └LocaleQuery(null)
I/flutter ( 6559):            └Title(color: Color(0xff2196f3))
I/flutter ( 6559):             └Navigator([GlobalObjectKey<NavigatorState> _WidgetsAppState(552902158)]; state: NavigatorState(240327618; tracking 1 ticker))
I/flutter ( 6559):              └Listener(listeners: down, up, cancel; behavior: defer-to-child; renderObject: RenderPointerListener)
I/flutter ( 6559):               └AbsorbPointer(renderObject: RenderAbsorbPointer)
I/flutter ( 6559):                └Focus([GlobalKey 489139594]; state: _FocusState(739584448))
I/flutter ( 6559):                 └Semantics(container: true; renderObject: RenderSemanticsAnnotations)
I/flutter ( 6559):                  └_FocusScope(this scope has focus; focused subscope: [GlobalObjectKey MaterialPageRoute<Null>(875520219)])
I/flutter ( 6559):                   └Overlay([GlobalKey 199833992]; state: OverlayState(619367313; entries: [OverlayEntry@248818791(opaque: false; maintainState: false), OverlayEntry@837336156(opaque: false; maintainState: true)]))
I/flutter ( 6559):                    └_Theatre(renderObject: _RenderTheatre)
I/flutter ( 6559):                     └Stack(renderObject: RenderStack)
I/flutter ( 6559):                      ├_OverlayEntry([GlobalKey 612888877]; state: _OverlayEntryState(739137453))
I/flutter ( 6559):                      │└IgnorePointer(ignoring: false; renderObject: RenderIgnorePointer)
I/flutter ( 6559):                      │ └ModalBarrier()
I/flutter ( 6559):                      │  └Semantics(container: true; renderObject: RenderSemanticsAnnotations)
I/flutter ( 6559):                      │   └GestureDetector()
I/flutter ( 6559):                      │    └RawGestureDetector(state: RawGestureDetectorState(39068508; gestures: tap; behavior: opaque))
I/flutter ( 6559):                      │     └_GestureSemantics(renderObject: RenderSemanticsGestureHandler)
I/flutter ( 6559):                      │      └Listener(listeners: down; behavior: opaque; renderObject: RenderPointerListener)
I/flutter ( 6559):                      │       └ConstrainedBox(BoxConstraints(biggest); renderObject: RenderConstrainedBox)
I/flutter ( 6559):                      └_OverlayEntry([GlobalKey 727622716]; state: _OverlayEntryState(279971240))
I/flutter ( 6559):                       └_ModalScope([GlobalKey 816151164]; state: _ModalScopeState(875510645))
I/flutter ( 6559):                        └Focus([GlobalObjectKey MaterialPageRoute<Null>(875520219)]; state: _FocusState(331487674))
I/flutter ( 6559):                         └Semantics(container: true; renderObject: RenderSemanticsAnnotations)
I/flutter ( 6559):                          └_FocusScope(this scope has focus)
I/flutter ( 6559):                           └Offstage(offstage: false; renderObject: RenderOffstage)
I/flutter ( 6559):                            └IgnorePointer(ignoring: false; renderObject: RenderIgnorePointer)
I/flutter ( 6559):                             └_MountainViewPageTransition(animation: AnimationController(⏭ 1.000; paused; for MaterialPageRoute<Null>(/))➩ProxyAnimation➩Cubic(0.40, 0.00, 0.20, 1.00)➩Tween<Offset>(Offset(0.0, 1.0) → Offset(0.0, 0.0))➩Offset(0.0, 0.0); state: _AnimatedState(552160732))
I/flutter ( 6559):                              └SlideTransition(animation: AnimationController(⏭ 1.000; paused; for MaterialPageRoute<Null>(/))➩ProxyAnimation➩Cubic(0.40, 0.00, 0.20, 1.00)➩Tween<Offset>(Offset(0.0, 1.0) → Offset(0.0, 0.0))➩Offset(0.0, 0.0); state: _AnimatedState(714726495))
I/flutter ( 6559):                               └FractionalTranslation(renderObject: RenderFractionalTranslation)
I/flutter ( 6559):                                └RepaintBoundary(renderObject: RenderRepaintBoundary)
I/flutter ( 6559):                                 └PageStorage([GlobalKey 619728754])
I/flutter ( 6559):                                  └_ModalScopeStatus(active)
I/flutter ( 6559):                                   └AppHome()
I/flutter ( 6559):                                    └Material(MaterialType.canvas; elevation: 0; state: _MaterialState(780114997))
I/flutter ( 6559):                                     └AnimatedContainer(duration: 200ms; has background; state: _AnimatedContainerState(616063822; ticker inactive; has background))
I/flutter ( 6559):                                      └Container(bg: BoxDecoration())
I/flutter ( 6559):                                       └DecoratedBox(renderObject: RenderDecoratedBox)
I/flutter ( 6559):                                        └Container(bg: BoxDecoration(backgroundColor: Color(0xfffafafa)))
I/flutter ( 6559):                                         └DecoratedBox(renderObject: RenderDecoratedBox)
I/flutter ( 6559):                                          └NotificationListener<LayoutChangedNotification>()
I/flutter ( 6559):                                           └_InkFeature([GlobalKey ink renderer]; renderObject: _RenderInkFeatures)
I/flutter ( 6559):                                            └AnimatedDefaultTextStyle(duration: 200ms; inherit: false; color: Color(0xdd000000); family: "Roboto"; size: 14.0; weight: 400; baseline: alphabetic; state: _AnimatedDefaultTextStyleState(427742350; ticker inactive))
I/flutter ( 6559):                                             └DefaultTextStyle(inherit: false; color: Color(0xdd000000); family: "Roboto"; size: 14.0; weight: 400; baseline: alphabetic)
I/flutter ( 6559):                                              └Center(alignment: Alignment.center; renderObject: RenderPositionedBox)
I/flutter ( 6559):                                               └FlatButton()
I/flutter ( 6559):                                                └MaterialButton(state: _MaterialButtonState(398724090))
I/flutter ( 6559):                                                 └ConstrainedBox(BoxConstraints(88.0<=w<=Infinity, h=36.0); renderObject: RenderConstrainedBox relayoutBoundary=up1)
I/flutter ( 6559):                                                  └AnimatedDefaultTextStyle(duration: 200ms; inherit: false; color: Color(0xdd000000); family: "Roboto"; size: 14.0; weight: 500; baseline: alphabetic; state: _AnimatedDefaultTextStyleState(315134664; ticker inactive))
I/flutter ( 6559):                                                   └DefaultTextStyle(inherit: false; color: Color(0xdd000000); family: "Roboto"; size: 14.0; weight: 500; baseline: alphabetic)
I/flutter ( 6559):                                                    └IconTheme(color: Color(0xdd000000))
I/flutter ( 6559):                                                     └InkWell(state: _InkResponseState<InkResponse>(369160267))
I/flutter ( 6559):                                                      └GestureDetector()
I/flutter ( 6559):                                                       └RawGestureDetector(state: RawGestureDetectorState(175370983; gestures: tap; behavior: opaque))
I/flutter ( 6559):                                                        └_GestureSemantics(renderObject: RenderSemanticsGestureHandler relayoutBoundary=up2)
I/flutter ( 6559):                                                         └Listener(listeners: down; behavior: opaque; renderObject: RenderPointerListener relayoutBoundary=up3)
I/flutter ( 6559):                                                          └Container(padding: EdgeInsets(16.0, 0.0, 16.0, 0.0))
I/flutter ( 6559):                                                           └Padding(renderObject: RenderPadding relayoutBoundary=up4)
I/flutter ( 6559):                                                            └Center(alignment: Alignment.center; widthFactor: 1.0; renderObject: RenderPositionedBox relayoutBoundary=up5)
I/flutter ( 6559):                                                             └Text("Dump App")
I/flutter ( 6559):                                                              └RichText(renderObject: RenderParagraph relayoutBoundary=up6)
```

Esto es el árbol "aplanado", mostrando todos los widgets proyectados 
a través de sus diversas funciones `build`. (Este es el árbol que obtienes 
si llamas `toStringDeep` en la raíz del árbol de widgets.) Verás 
muchos widgets en este que no aparecen en el código de tu aplicación, 
porque estos son insertados por las funciones build de los widgets del 
framework. Por ejemplo,
[`InkFeature`](https://docs.flutter.io/flutter/material/InkFeature-class.html)
es un detalle de implementación del widget 
[`Material`](https://docs.flutter.io/flutter/material/Material-class.html).

Ya que la llamada a `debugDumpApp()` es invocada cuando el botón cambia 
de _being pressed_ a _being released_, esto coincide con la llamada del 
objeto 
[`FlatButton`](https://docs.flutter.io/flutter/material/FlatButton-class.html)
a 
[`setState()`](https://docs.flutter.io/flutter/widgets/State/setState.html)
marcandose como "dirty". Es por esto que cuando miras el volcado 
deberías ver este objeto especifico marcado como "dirty". También puedes ver 
que _gesture listeners_ han sido registrados; en este caso, un único 
GestureDetector es listado, y este solo está escuchando por un gesto 
"tap" ("tap" es la salida de la función `toStringShort` de un `TapGestureDetector`).

Si escribes tus propios widgets, puedes añadir información sobreescribiendo 
[`debugFillProperties()`](https://docs.flutter.io/flutter/widgets/Widget/debugFillProperties.html).
Añade objetos [DiagnosticsProperty](https://docs.flutter.io/flutter/foundation/DiagnosticsProperty-class.html)
a los argumentos del método, y llama al método de la superclase.
Esta función es la que el método `toString` usa para rellenar en la 
descripción del widget.

### Capa de renderizado

Si estas tratando de depurar un problema de layout, entonces la capa 
del árbol de Widgets puede tener insuficientes detalles. En este caso, 
puedes volcar el árbol de renderizado llamando a 
[`debugDumpRenderTree()`](https://docs.flutter.io/flutter/rendering/debugDumpRenderTree.html).
Como con `debugDumpApp()`, puedes llamar esto mas o menos en cualquier momento 
excepto durante la fase de pintado del layout. Como regla general, llamarlo desde 
un [frame callback](https://docs.flutter.io/flutter/scheduler/SchedulerBinding/addPersistentFrameCallback.html) 
o un manejador de eventos es la mejor solución.

Para llamar a `debugDumpRenderTree()`, necesitas añadir `import
'package:flutter/rendering.dart';` a tu archivo fuente.

La salida para este pequeño ejemplo anterior, podría verse algo 
parecido a esto:

```
I/flutter ( 6559): RenderView
I/flutter ( 6559):  │ debug mode enabled - android
I/flutter ( 6559):  │ window size: Size(1080.0, 1794.0) (in physical pixels)
I/flutter ( 6559):  │ device pixel ratio: 2.625 (physical pixels per logical pixel)
I/flutter ( 6559):  │ configuration: Size(411.4, 683.4) at 2.625x (in logical pixels)
I/flutter ( 6559):  │
I/flutter ( 6559):  └─child: RenderCustomPaint
I/flutter ( 6559):    │ creator: CustomPaint ← Banner ← CheckedModeBanner ←
I/flutter ( 6559):    │   WidgetsApp-[GlobalObjectKey _MaterialAppState(1009803148)] ←
I/flutter ( 6559):    │   Theme ← AnimatedTheme ← ScrollConfiguration ← MaterialApp ←
I/flutter ( 6559):    │   [root]
I/flutter ( 6559):    │ parentData: <none>
I/flutter ( 6559):    │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):    │ size: Size(411.4, 683.4)
I/flutter ( 6559):    │
I/flutter ( 6559):    └─child: RenderPointerListener
I/flutter ( 6559):      │ creator: Listener ← Navigator-[GlobalObjectKey<NavigatorState>
I/flutter ( 6559):      │   _WidgetsAppState(552902158)] ← Title ← LocaleQuery ← MediaQuery
I/flutter ( 6559):      │   ← DefaultTextStyle ← CustomPaint ← Banner ← CheckedModeBanner ←
I/flutter ( 6559):      │   WidgetsApp-[GlobalObjectKey _MaterialAppState(1009803148)] ←
I/flutter ( 6559):      │   Theme ← AnimatedTheme ← ⋯
I/flutter ( 6559):      │ parentData: <none>
I/flutter ( 6559):      │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):      │ size: Size(411.4, 683.4)
I/flutter ( 6559):      │ behavior: defer-to-child
I/flutter ( 6559):      │ listeners: down, up, cancel
I/flutter ( 6559):      │
I/flutter ( 6559):      └─child: RenderAbsorbPointer
I/flutter ( 6559):        │ creator: AbsorbPointer ← Listener ←
I/flutter ( 6559):        │   Navigator-[GlobalObjectKey<NavigatorState>
I/flutter ( 6559):        │   _WidgetsAppState(552902158)] ← Title ← LocaleQuery ← MediaQuery
I/flutter ( 6559):        │   ← DefaultTextStyle ← CustomPaint ← Banner ← CheckedModeBanner ←
I/flutter ( 6559):        │   WidgetsApp-[GlobalObjectKey _MaterialAppState(1009803148)] ←
I/flutter ( 6559):        │   Theme ← ⋯
I/flutter ( 6559):        │ parentData: <none>
I/flutter ( 6559):        │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):        │ size: Size(411.4, 683.4)
I/flutter ( 6559):        │ absorbing: false
I/flutter ( 6559):        │
I/flutter ( 6559):        └─child: RenderSemanticsAnnotations
I/flutter ( 6559):          │ creator: Semantics ← Focus-[GlobalKey 489139594] ← AbsorbPointer
I/flutter ( 6559):          │   ← Listener ← Navigator-[GlobalObjectKey<NavigatorState>
I/flutter ( 6559):          │   _WidgetsAppState(552902158)] ← Title ← LocaleQuery ← MediaQuery
I/flutter ( 6559):          │   ← DefaultTextStyle ← CustomPaint ← Banner ← CheckedModeBanner ←
I/flutter ( 6559):          │   ⋯
I/flutter ( 6559):          │ parentData: <none>
I/flutter ( 6559):          │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):          │ size: Size(411.4, 683.4)
I/flutter ( 6559):          │
I/flutter ( 6559):          └─child: _RenderTheatre
I/flutter ( 6559):            │ creator: _Theatre ← Overlay-[GlobalKey 199833992] ← _FocusScope ←
I/flutter ( 6559):            │   Semantics ← Focus-[GlobalKey 489139594] ← AbsorbPointer ←
I/flutter ( 6559):            │   Listener ← Navigator-[GlobalObjectKey<NavigatorState>
I/flutter ( 6559):            │   _WidgetsAppState(552902158)] ← Title ← LocaleQuery ← MediaQuery
I/flutter ( 6559):            │   ← DefaultTextStyle ← ⋯
I/flutter ( 6559):            │ parentData: <none>
I/flutter ( 6559):            │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            │ size: Size(411.4, 683.4)
I/flutter ( 6559):            │
I/flutter ( 6559):            ├─onstage: RenderStack
I/flutter ( 6559):            ╎ │ creator: Stack ← _Theatre ← Overlay-[GlobalKey 199833992] ←
I/flutter ( 6559):            ╎ │   _FocusScope ← Semantics ← Focus-[GlobalKey 489139594] ←
I/flutter ( 6559):            ╎ │   AbsorbPointer ← Listener ←
I/flutter ( 6559):            ╎ │   Navigator-[GlobalObjectKey<NavigatorState>
I/flutter ( 6559):            ╎ │   _WidgetsAppState(552902158)] ← Title ← LocaleQuery ← MediaQuery
I/flutter ( 6559):            ╎ │   ← ⋯
I/flutter ( 6559):            ╎ │ parentData: not positioned; offset=Offset(0.0, 0.0)
I/flutter ( 6559):            ╎ │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎ │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎ │
I/flutter ( 6559):            ╎ ├─child 1: RenderIgnorePointer
I/flutter ( 6559):            ╎ │ │ creator: IgnorePointer ← _OverlayEntry-[GlobalKey 612888877] ←
I/flutter ( 6559):            ╎ │ │   Stack ← _Theatre ← Overlay-[GlobalKey 199833992] ← _FocusScope
I/flutter ( 6559):            ╎ │ │   ← Semantics ← Focus-[GlobalKey 489139594] ← AbsorbPointer ←
I/flutter ( 6559):            ╎ │ │   Listener ← Navigator-[GlobalObjectKey<NavigatorState>
I/flutter ( 6559):            ╎ │ │   _WidgetsAppState(552902158)] ← Title ← ⋯
I/flutter ( 6559):            ╎ │ │ parentData: not positioned; offset=Offset(0.0, 0.0)
I/flutter ( 6559):            ╎ │ │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎ │ │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎ │ │ ignoring: false
I/flutter ( 6559):            ╎ │ │ ignoringSemantics: implicitly false
I/flutter ( 6559):            ╎ │ │
I/flutter ( 6559):            ╎ │ └─child: RenderSemanticsAnnotations
I/flutter ( 6559):            ╎ │   │ creator: Semantics ← ModalBarrier ← IgnorePointer ←
I/flutter ( 6559):            ╎ │   │   _OverlayEntry-[GlobalKey 612888877] ← Stack ← _Theatre ←
I/flutter ( 6559):            ╎ │   │   Overlay-[GlobalKey 199833992] ← _FocusScope ← Semantics ←
I/flutter ( 6559):            ╎ │   │   Focus-[GlobalKey 489139594] ← AbsorbPointer ← Listener ← ⋯
I/flutter ( 6559):            ╎ │   │ parentData: <none>
I/flutter ( 6559):            ╎ │   │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎ │   │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎ │   │
I/flutter ( 6559):            ╎ │   └─child: RenderSemanticsGestureHandler
I/flutter ( 6559):            ╎ │     │ creator: _GestureSemantics ← RawGestureDetector ← GestureDetector
I/flutter ( 6559):            ╎ │     │   ← Semantics ← ModalBarrier ← IgnorePointer ←
I/flutter ( 6559):            ╎ │     │   _OverlayEntry-[GlobalKey 612888877] ← Stack ← _Theatre ←
I/flutter ( 6559):            ╎ │     │   Overlay-[GlobalKey 199833992] ← _FocusScope ← Semantics ← ⋯
I/flutter ( 6559):            ╎ │     │ parentData: <none>
I/flutter ( 6559):            ╎ │     │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎ │     │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎ │     │
I/flutter ( 6559):            ╎ │     └─child: RenderPointerListener
I/flutter ( 6559):            ╎ │       │ creator: Listener ← _GestureSemantics ← RawGestureDetector ←
I/flutter ( 6559):            ╎ │       │   GestureDetector ← Semantics ← ModalBarrier ← IgnorePointer ←
I/flutter ( 6559):            ╎ │       │   _OverlayEntry-[GlobalKey 612888877] ← Stack ← _Theatre ←
I/flutter ( 6559):            ╎ │       │   Overlay-[GlobalKey 199833992] ← _FocusScope ← ⋯
I/flutter ( 6559):            ╎ │       │ parentData: <none>
I/flutter ( 6559):            ╎ │       │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎ │       │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎ │       │ behavior: opaque
I/flutter ( 6559):            ╎ │       │ listeners: down
I/flutter ( 6559):            ╎ │       │
I/flutter ( 6559):            ╎ │       └─child: RenderConstrainedBox
I/flutter ( 6559):            ╎ │           creator: ConstrainedBox ← Listener ← _GestureSemantics ←
I/flutter ( 6559):            ╎ │             RawGestureDetector ← GestureDetector ← Semantics ← ModalBarrier
I/flutter ( 6559):            ╎ │             ← IgnorePointer ← _OverlayEntry-[GlobalKey 612888877] ← Stack ←
I/flutter ( 6559):            ╎ │             _Theatre ← Overlay-[GlobalKey 199833992] ← ⋯
I/flutter ( 6559):            ╎ │           parentData: <none>
I/flutter ( 6559):            ╎ │           constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎ │           size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎ │           additionalConstraints: BoxConstraints(biggest)
I/flutter ( 6559):            ╎ │
I/flutter ( 6559):            ╎ └─child 2: RenderSemanticsAnnotations
I/flutter ( 6559):            ╎   │ creator: Semantics ← Focus-[GlobalObjectKey
I/flutter ( 6559):            ╎   │   MaterialPageRoute<Null>(875520219)] ← _ModalScope-[GlobalKey
I/flutter ( 6559):            ╎   │   816151164] ← _OverlayEntry-[GlobalKey 727622716] ← Stack ←
I/flutter ( 6559):            ╎   │   _Theatre ← Overlay-[GlobalKey 199833992] ← _FocusScope ←
I/flutter ( 6559):            ╎   │   Semantics ← Focus-[GlobalKey 489139594] ← AbsorbPointer ←
I/flutter ( 6559):            ╎   │   Listener ← ⋯
I/flutter ( 6559):            ╎   │ parentData: not positioned; offset=Offset(0.0, 0.0)
I/flutter ( 6559):            ╎   │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎   │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎   │
I/flutter ( 6559):            ╎   └─child: RenderOffstage
I/flutter ( 6559):            ╎     │ creator: Offstage ← _FocusScope ← Semantics ←
I/flutter ( 6559):            ╎     │   Focus-[GlobalObjectKey MaterialPageRoute<Null>(875520219)] ←
I/flutter ( 6559):            ╎     │   _ModalScope-[GlobalKey 816151164] ← _OverlayEntry-[GlobalKey
I/flutter ( 6559):            ╎     │   727622716] ← Stack ← _Theatre ← Overlay-[GlobalKey 199833992] ←
I/flutter ( 6559):            ╎     │   _FocusScope ← Semantics ← Focus-[GlobalKey 489139594] ← ⋯
I/flutter ( 6559):            ╎     │ parentData: <none>
I/flutter ( 6559):            ╎     │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎     │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎     │ offstage: false
I/flutter ( 6559):            ╎     │
I/flutter ( 6559):            ╎     └─child: RenderIgnorePointer
I/flutter ( 6559):            ╎       │ creator: IgnorePointer ← Offstage ← _FocusScope ← Semantics ←
I/flutter ( 6559):            ╎       │   Focus-[GlobalObjectKey MaterialPageRoute<Null>(875520219)] ←
I/flutter ( 6559):            ╎       │   _ModalScope-[GlobalKey 816151164] ← _OverlayEntry-[GlobalKey
I/flutter ( 6559):            ╎       │   727622716] ← Stack ← _Theatre ← Overlay-[GlobalKey 199833992] ←
I/flutter ( 6559):            ╎       │   _FocusScope ← Semantics ← ⋯
I/flutter ( 6559):            ╎       │ parentData: <none>
I/flutter ( 6559):            ╎       │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎       │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎       │ ignoring: false
I/flutter ( 6559):            ╎       │ ignoringSemantics: implicitly false
I/flutter ( 6559):            ╎       │
I/flutter ( 6559):            ╎       └─child: RenderFractionalTranslation
I/flutter ( 6559):            ╎         │ creator: FractionalTranslation ← SlideTransition ←
I/flutter ( 6559):            ╎         │   _MountainViewPageTransition ← IgnorePointer ← Offstage ←
I/flutter ( 6559):            ╎         │   _FocusScope ← Semantics ← Focus-[GlobalObjectKey
I/flutter ( 6559):            ╎         │   MaterialPageRoute<Null>(875520219)] ← _ModalScope-[GlobalKey
I/flutter ( 6559):            ╎         │   816151164] ← _OverlayEntry-[GlobalKey 727622716] ← Stack ←
I/flutter ( 6559):            ╎         │   _Theatre ← ⋯
I/flutter ( 6559):            ╎         │ parentData: <none>
I/flutter ( 6559):            ╎         │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎         │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎         │ translation: Offset(0.0, 0.0)
I/flutter ( 6559):            ╎         │ transformHitTests: true
I/flutter ( 6559):            ╎         │
I/flutter ( 6559):            ╎         └─child: RenderRepaintBoundary
I/flutter ( 6559):            ╎           │ creator: RepaintBoundary ← FractionalTranslation ←
I/flutter ( 6559):            ╎           │   SlideTransition ← _MountainViewPageTransition ← IgnorePointer ←
I/flutter ( 6559):            ╎           │   Offstage ← _FocusScope ← Semantics ← Focus-[GlobalObjectKey
I/flutter ( 6559):            ╎           │   MaterialPageRoute<Null>(875520219)] ← _ModalScope-[GlobalKey
I/flutter ( 6559):            ╎           │   816151164] ← _OverlayEntry-[GlobalKey 727622716] ← Stack ← ⋯
I/flutter ( 6559):            ╎           │ parentData: <none>
I/flutter ( 6559):            ╎           │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎           │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎           │ metrics: 83.3% useful (1 bad vs 5 good)
I/flutter ( 6559):            ╎           │ diagnosis: this is a useful repaint boundary and should be kept
I/flutter ( 6559):            ╎           │
I/flutter ( 6559):            ╎           └─child: RenderDecoratedBox
I/flutter ( 6559):            ╎             │ creator: DecoratedBox ← Container ← AnimatedContainer ← Material
I/flutter ( 6559):            ╎             │   ← AppHome ← _ModalScopeStatus ← PageStorage-[GlobalKey
I/flutter ( 6559):            ╎             │   619728754] ← RepaintBoundary ← FractionalTranslation ←
I/flutter ( 6559):            ╎             │   SlideTransition ← _MountainViewPageTransition ← IgnorePointer ←
I/flutter ( 6559):            ╎             │   ⋯
I/flutter ( 6559):            ╎             │ parentData: <none>
I/flutter ( 6559):            ╎             │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎             │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎             │ decoration:
I/flutter ( 6559):            ╎             │   <no decorations specified>
I/flutter ( 6559):            ╎             │ configuration: ImageConfiguration(bundle:
I/flutter ( 6559):            ╎             │   PlatformAssetBundle@367106502(), devicePixelRatio: 2.625,
I/flutter ( 6559):            ╎             │   platform: android)
I/flutter ( 6559):            ╎             │
I/flutter ( 6559):            ╎             └─child: RenderDecoratedBox
I/flutter ( 6559):            ╎               │ creator: DecoratedBox ← Container ← DecoratedBox ← Container ←
I/flutter ( 6559):            ╎               │   AnimatedContainer ← Material ← AppHome ← _ModalScopeStatus ←
I/flutter ( 6559):            ╎               │   PageStorage-[GlobalKey 619728754] ← RepaintBoundary ←
I/flutter ( 6559):            ╎               │   FractionalTranslation ← SlideTransition ← ⋯
I/flutter ( 6559):            ╎               │ parentData: <none>
I/flutter ( 6559):            ╎               │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎               │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎               │ decoration:
I/flutter ( 6559):            ╎               │   backgroundColor: Color(0xfffafafa)
I/flutter ( 6559):            ╎               │ configuration: ImageConfiguration(bundle:
I/flutter ( 6559):            ╎               │   PlatformAssetBundle@367106502(), devicePixelRatio: 2.625,
I/flutter ( 6559):            ╎               │   platform: android)
I/flutter ( 6559):            ╎               │
I/flutter ( 6559):            ╎               └─child: _RenderInkFeatures
I/flutter ( 6559):            ╎                 │ creator: _InkFeature-[GlobalKey ink renderer] ←
I/flutter ( 6559):            ╎                 │   NotificationListener<LayoutChangedNotification> ← DecoratedBox
I/flutter ( 6559):            ╎                 │   ← Container ← DecoratedBox ← Container ← AnimatedContainer ←
I/flutter ( 6559):            ╎                 │   Material ← AppHome ← _ModalScopeStatus ← PageStorage-[GlobalKey
I/flutter ( 6559):            ╎                 │   619728754] ← RepaintBoundary ← ⋯
I/flutter ( 6559):            ╎                 │ parentData: <none>
I/flutter ( 6559):            ╎                 │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎                 │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎                 │
I/flutter ( 6559):            ╎                 └─child: RenderPositionedBox
I/flutter ( 6559):            ╎                   │ creator: Center ← DefaultTextStyle ← AnimatedDefaultTextStyle ←
I/flutter ( 6559):            ╎                   │   _InkFeature-[GlobalKey ink renderer] ←
I/flutter ( 6559):            ╎                   │   NotificationListener<LayoutChangedNotification> ← DecoratedBox
I/flutter ( 6559):            ╎                   │   ← Container ← DecoratedBox ← Container ← AnimatedContainer ←
I/flutter ( 6559):            ╎                   │   Material ← AppHome ← ⋯
I/flutter ( 6559):            ╎                   │ parentData: <none>
I/flutter ( 6559):            ╎                   │ constraints: BoxConstraints(w=411.4, h=683.4)
I/flutter ( 6559):            ╎                   │ size: Size(411.4, 683.4)
I/flutter ( 6559):            ╎                   │ alignment: Alignment.center
I/flutter ( 6559):            ╎                   │ widthFactor: expand
I/flutter ( 6559):            ╎                   │ heightFactor: expand
I/flutter ( 6559):            ╎                   │
I/flutter ( 6559):            ╎                   └─child: RenderConstrainedBox relayoutBoundary=up1
I/flutter ( 6559):            ╎                     │ creator: ConstrainedBox ← MaterialButton ← FlatButton ← Center ←
I/flutter ( 6559):            ╎                     │   DefaultTextStyle ← AnimatedDefaultTextStyle ←
I/flutter ( 6559):            ╎                     │   _InkFeature-[GlobalKey ink renderer] ←
I/flutter ( 6559):            ╎                     │   NotificationListener<LayoutChangedNotification> ← DecoratedBox
I/flutter ( 6559):            ╎                     │   ← Container ← DecoratedBox ← Container ← ⋯
I/flutter ( 6559):            ╎                     │ parentData: offset=Offset(156.7, 323.7)
I/flutter ( 6559):            ╎                     │ constraints: BoxConstraints(0.0<=w<=411.4, 0.0<=h<=683.4)
I/flutter ( 6559):            ╎                     │ size: Size(98.0, 36.0)
I/flutter ( 6559):            ╎                     │ additionalConstraints: BoxConstraints(88.0<=w<=Infinity, h=36.0)
I/flutter ( 6559):            ╎                     │
I/flutter ( 6559):            ╎                     └─child: RenderSemanticsGestureHandler relayoutBoundary=up2
I/flutter ( 6559):            ╎                       │ creator: _GestureSemantics ← RawGestureDetector ← GestureDetector
I/flutter ( 6559):            ╎                       │   ← InkWell ← IconTheme ← DefaultTextStyle ←
I/flutter ( 6559):            ╎                       │   AnimatedDefaultTextStyle ← ConstrainedBox ← MaterialButton ←
I/flutter ( 6559):            ╎                       │   FlatButton ← Center ← DefaultTextStyle ← ⋯
I/flutter ( 6559):            ╎                       │ parentData: <none>
I/flutter ( 6559):            ╎                       │ constraints: BoxConstraints(88.0<=w<=411.4, h=36.0)
I/flutter ( 6559):            ╎                       │ size: Size(98.0, 36.0)
I/flutter ( 6559):            ╎                       │
I/flutter ( 6559):            ╎                       └─child: RenderPointerListener relayoutBoundary=up3
I/flutter ( 6559):            ╎                         │ creator: Listener ← _GestureSemantics ← RawGestureDetector ←
I/flutter ( 6559):            ╎                         │   GestureDetector ← InkWell ← IconTheme ← DefaultTextStyle ←
I/flutter ( 6559):            ╎                         │   AnimatedDefaultTextStyle ← ConstrainedBox ← MaterialButton ←
I/flutter ( 6559):            ╎                         │   FlatButton ← Center ← ⋯
I/flutter ( 6559):            ╎                         │ parentData: <none>
I/flutter ( 6559):            ╎                         │ constraints: BoxConstraints(88.0<=w<=411.4, h=36.0)
I/flutter ( 6559):            ╎                         │ size: Size(98.0, 36.0)
I/flutter ( 6559):            ╎                         │ behavior: opaque
I/flutter ( 6559):            ╎                         │ listeners: down
I/flutter ( 6559):            ╎                         │
I/flutter ( 6559):            ╎                         └─child: RenderPadding relayoutBoundary=up4
I/flutter ( 6559):            ╎                           │ creator: Padding ← Container ← Listener ← _GestureSemantics ←
I/flutter ( 6559):            ╎                           │   RawGestureDetector ← GestureDetector ← InkWell ← IconTheme ←
I/flutter ( 6559):            ╎                           │   DefaultTextStyle ← AnimatedDefaultTextStyle ← ConstrainedBox ←
I/flutter ( 6559):            ╎                           │   MaterialButton ← ⋯
I/flutter ( 6559):            ╎                           │ parentData: <none>
I/flutter ( 6559):            ╎                           │ constraints: BoxConstraints(88.0<=w<=411.4, h=36.0)
I/flutter ( 6559):            ╎                           │ size: Size(98.0, 36.0)
I/flutter ( 6559):            ╎                           │ padding: EdgeInsets(16.0, 0.0, 16.0, 0.0)
I/flutter ( 6559):            ╎                           │
I/flutter ( 6559):            ╎                           └─child: RenderPositionedBox relayoutBoundary=up5
I/flutter ( 6559):            ╎                             │ creator: Center ← Padding ← Container ← Listener ←
I/flutter ( 6559):            ╎                             │   _GestureSemantics ← RawGestureDetector ← GestureDetector ←
I/flutter ( 6559):            ╎                             │   InkWell ← IconTheme ← DefaultTextStyle ←
I/flutter ( 6559):            ╎                             │   AnimatedDefaultTextStyle ← ConstrainedBox ← ⋯
I/flutter ( 6559):            ╎                             │ parentData: offset=Offset(16.0, 0.0)
I/flutter ( 6559):            ╎                             │ constraints: BoxConstraints(56.0<=w<=379.4, h=36.0)
I/flutter ( 6559):            ╎                             │ size: Size(66.0, 36.0)
I/flutter ( 6559):            ╎                             │ alignment: Alignment.center
I/flutter ( 6559):            ╎                             │ widthFactor: 1.0
I/flutter ( 6559):            ╎                             │ heightFactor: expand
I/flutter ( 6559):            ╎                             │
I/flutter ( 6559):            ╎                             └─child: RenderParagraph relayoutBoundary=up6
I/flutter ( 6559):            ╎                               │ creator: RichText ← Text ← Center ← Padding ← Container ←
I/flutter ( 6559):            ╎                               │   Listener ← _GestureSemantics ← RawGestureDetector ←
I/flutter ( 6559):            ╎                               │   GestureDetector ← InkWell ← IconTheme ← DefaultTextStyle ← ⋯
I/flutter ( 6559):            ╎                               │ parentData: offset=Offset(0.0, 10.0)
I/flutter ( 6559):            ╎                               │ constraints: BoxConstraints(0.0<=w<=379.4, 0.0<=h<=36.0)
I/flutter ( 6559):            ╎                               │ size: Size(66.0, 16.0)
I/flutter ( 6559):            ╎                               ╘═╦══ text ═══
I/flutter ( 6559):            ╎                                 ║ TextSpan:
I/flutter ( 6559):            ╎                                 ║   inherit: false
I/flutter ( 6559):            ╎                                 ║   color: Color(0xdd000000)
I/flutter ( 6559):            ╎                                 ║   family: "Roboto"
I/flutter ( 6559):            ╎                                 ║   size: 14.0
I/flutter ( 6559):            ╎                                 ║   weight: 500
I/flutter ( 6559):            ╎                                 ║   baseline: alphabetic
I/flutter ( 6559):            ╎                                 ║   "Dump App"
I/flutter ( 6559):            ╎                                 ╚═══════════
I/flutter ( 6559):            ╎
I/flutter ( 6559):            └╌no offstage children

```

Estas la salida de la función `toStringDeep` del objeto ráiz `RenderObject`.

Cuando depuramos problemas de layout, los campos clave a mirar son los campos 
`size` y `constraints`. El flujo de restricciones (constraints) bajan por el árbol, 
y los tamaños (sizes) fluyen de vuelta hacia arriba.

Por ejemplo, en el volcado anterior puedes ver que el tamaño de la ventana,
`Size(411.4, 683.4)`, es usado para forzar todas las cajas por debajo de 
[`RenderPositionedBox`](https://docs.flutter.io/flutter/rendering/RenderPositionedBox-class.html para tener el tamaño de la pantalla, con la restriccion de 
`BoxConstraints(w=411.4, h=683.4)`. El `RenderPositionedBox`, que este 
volcado dice, fue creado por un widget [`Center`](https://docs.flutter.io/flutter/widgets/Center-class.html) 
(como es descrito por el campo `creator`), configura las restricciones 
de sus hijos a esto: `BoxConstraints(0.0<=w<=411.4,
0.0<=h<=683.4)`. El hijo, un
[`RenderPadding`](https://docs.flutter.io/flutter/rendering/RenderPadding-class.html),
inserta estas restricciones para asegurar que hay espacio para el padding, y así el 
[`RenderConstrainedBox`](https://docs.flutter.io/flutter/rendering/RenderConstrainedBox-class.html) 
tiene una restricción de `BoxConstraints(0.0<=w<=395.4,0.0<=h<=667.4)`. 
Este objeto, de cuyo campo `creator` te hablamos es probablemente 
parte de la definición de 
[`FlatButton`](https://docs.flutter.io/flutter/material/FlatButton-class.html), 
fija un ancho mínimo de 88 a su contenido y una altura especifica de 
36.0. (Esta es la clase `FlatButton` implementando 
las guias de Material Design respecto a las dimensiones de los botones.)

El `RenderPositionedBox` más interno aplica las restricciones de nuevo, 
esta vez para centrar el texto en el botón. El 
[`RenderParagraph`](https://docs.flutter.io/flutter/rendering/RenderParagraph-class.html)
toma su tamaño basándose en su contenido. Si ahora sigues los tamaños hacia 
arriba de la cadena, verás como el tamaño del texto es el que influencia el 
ancho de todas las cajas que forman el botón, como todos ellos toman las dimensiones de 
su hijo para dimensionarse a si mismos.

Otra manera de notar esto es mirando la parte "relayoutSubtreeRoot" de 
la descripción de cada caja, que escencialmente te dice como 
muchos ancestros dependen del tamaño de este elemento de alguna manera. 
Así el `RenderParagraph` que tiene un `relayoutSubtreeRoot=up8`, significa que 
cuando el `RenderParagraph` sea marcado como "dirty", ocho ancestros tambien 
tienen que ser marcados como "dirty" para que puedan ser afectados por las 
nuevas dimensiones.

Si escribes tu propio objecto de renderizado, puedes añadir información para 
el volcado sobreescribiendo 
[`debugFillProperties()`](https://docs.flutter.io/flutter/rendering/Layer/debugFillProperties.html).
Añade objetos [DiagnosticsProperty](https://docs.flutter.io/flutter/foundation/DiagnosticsProperty-class.html)
a los argumentos del método, y llama al método de la supercalse.

### Capas

Si estas tratando de depurar un problema de composición, puedes usar 
[`debugDumpLayerTree()`](https://docs.flutter.io/flutter/rendering/debugDumpLayerTree.html).
Para el ejemplo anterior, esta podría ser la salida:

```
I/flutter : TransformLayer
I/flutter :  │ creator: [root]
I/flutter :  │ offset: Offset(0.0, 0.0)
I/flutter :  │ transform:
I/flutter :  │   [0] 3.5,0.0,0.0,0.0
I/flutter :  │   [1] 0.0,3.5,0.0,0.0
I/flutter :  │   [2] 0.0,0.0,1.0,0.0
I/flutter :  │   [3] 0.0,0.0,0.0,1.0
I/flutter :  │
I/flutter :  ├─child 1: OffsetLayer
I/flutter :  │ │ creator: RepaintBoundary ← _FocusScope ← Semantics ← Focus-[GlobalObjectKey MaterialPageRoute(560156430)] ← _ModalScope-[GlobalKey 328026813] ← _OverlayEntry-[GlobalKey 388965355] ← Stack ← Overlay-[GlobalKey 625702218] ← Navigator-[GlobalObjectKey _MaterialAppState(859106034)] ← Title ← ⋯
I/flutter :  │ │ offset: Offset(0.0, 0.0)
I/flutter :  │ │
I/flutter :  │ └─child 1: PictureLayer
I/flutter :  │
I/flutter :  └─child 2: PictureLayer
```

Esto es la salida de llamar a `toStringDeep` en el objeto `Layer` raíz.

La transformación en la raíz es la transformación que aplica la 
relación de aspecto en pixels del dispositivo; en este caso, una relación de 3.5 pixeles 
de dispositivo por cada pixel lógico.

El widget `RepaintBoundary`, que crea un `RenderRepaintBoundary`
en el árbol de renderizado, crea una nueva capa en el árbol de capas. Esto se 
usa para reducir cuanto necesita ser repintando.

### Semántica

Puedes tambien obtener un volcado del árbol de Semántica (el árbol 
presentado a las APIs de accesibilidad del sistema) usando
[`debugDumpSemanticsTree()`](https://docs.flutter.io/flutter/rendering/debugDumpSemanticsTree.html).
Para usar esto, primero debes habilitar la accesibilidad, por ejemplo habilitando 
una herramienta de accesibilidad del sistema o el `SemanticsDebugger`
(discutido más abajo).

Para el ejemplo anterior, la salida podría ser:

```
I/flutter : SemanticsNode(0; Rect.fromLTRB(0.0, 0.0, 411.4, 683.4))
I/flutter :  ├SemanticsNode(1; Rect.fromLTRB(0.0, 0.0, 411.4, 683.4))
I/flutter :  │ └SemanticsNode(2; Rect.fromLTRB(0.0, 0.0, 411.4, 683.4); canBeTapped)
I/flutter :  └SemanticsNode(3; Rect.fromLTRB(0.0, 0.0, 411.4, 683.4))
I/flutter :    └SemanticsNode(4; Rect.fromLTRB(0.0, 0.0, 82.0, 36.0); canBeTapped; "Dump App")
```

<!-- this tree is bad, see https://github.com/flutter/flutter/issues/2476 -->

### Scheduling

Para encontrar donde ocurren sus eventos relativo al frame 
de inicio/fin del mismo, puedes alternar entre los booleanos 
[`debugPrintBeginFrameBanner`](https://docs.flutter.io/flutter/scheduler/debugPrintBeginFrameBanner.html) y   [`debugPrintEndFrameBanner`](https://docs.flutter.io/flutter/scheduler/debugPrintEndFrameBanner.html) 
para imprirmir el principio y el final de los frames a la consola.

Por ejemplo:

```
I/flutter : ▄▄▄▄▄▄▄▄ Frame 12         30s 437.086ms ▄▄▄▄▄▄▄▄
I/flutter : Debug print: Am I performing this work more than once per frame?
I/flutter : Debug print: Am I performing this work more than once per frame?
I/flutter : ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
```

[`debugPrintScheduleFrameStacks`](https://docs.flutter.io/flutter/scheduler/debugPrintScheduleFrameStacks.html) puede 
también ser usado para imprimir la pila de llamadas que causan que el frame actual 
haya sido programado.

## Depuración visual

Puedes también depurar un problema de layout visualmente, configurando 
[`debugPaintSizeEnabled`](https://docs.flutter.io/flutter/rendering/debugPaintSizeEnabled.html)
a `true`. Este es un booleano de la biblioteca `rendering`. Este puede ser 
habilitado en cualquier momento y afectas todos los pintados mientras este 
sea _true_. La manera más sencilla de fijar esto es al principio de tu punto 
de entrada `void main()`. Mira el código más abajo:

<!-- skip -->
```dart
//add import to rendering library
import 'package:flutter/rendering.dart';

void main() {
  debugPaintSizeEnabled=true;
  runApp(MyApp());
}
```

Cuando esto se habilita, todas las cajas toman un borde verde azulado, el 
padding (de widgets como `Padding`) son mostrados en azul tráslucido 
con una caja de un azul más oscuro alrededor del hijo, alineaciones 
(de widgets como `Center` y `Align`)
se muestra con flechas amarillas, y espaciadores (de widgets como 
`Container` cuando este no tiene hijo) se muestran en gris.

El 
[`debugPaintBaselinesEnabled`](https://docs.flutter.io/flutter/rendering/debugPaintBaselinesEnabled.html)
hace algo parecido pero para objectos con lineas base. La linea base
alfabética se muestra en verde brillante y la linea base ideografica 
en naranja.

La etiqueta 
[`debugPaintPointersEnabled`](https://docs.flutter.io/flutter/rendering/debugPaintPointersEnabled.html) 
cambia a un modo especial mediante el cual cualquier objeto 
que sea pulsado es resaltado en color verde azulado. Esto puede ayudarte a 
determinar cuando un objeto esta de alguna manera 
esta fallando en hacer correctamenta el _hit test_ (cosa que podría ocurrir si, 
por ejemplo, este está actualmente fuera de los límites de su 
padre y así no es considerado para el _hit testing_ en primer lugar).

Si estas tratando de depurar capas de composición, por ejemplo para determinar 
cuando y donde añadir los widgets `RepaintBoundary`, puedes usar la etiqueta [`debugPaintLayerBordersEnabled`](https://docs.flutter.io/flutter/rendering/debugPaintLayerBordersEnabled.html)
, que pinta los limites de cada capa en naranja, o la etiqueta 
[`debugRepaintRainbowEnabled`](https://docs.flutter.io/flutter/rendering/debugRepaintRainbowEnabled.html)
, que provoca que se sobrepongan capas con un conjunto de colores rotativos 
cuando son repintados.

Todas estas etiquetas solo funcionan en modo depuración. En general, cualquier cosa 
en el framework Flutter que empiza con "`debug...`" solo funciona en modo 
depuración.

## Depurando animaciones

La forma mas sencilla de depurar animaciones es disminuir su 
velocidad. Para hacer esto, fija la variable 
[`timeDilation`](https://docs.flutter.io/flutter/scheduler/timeDilation.html)
(de la biblioteca `scheduler`) a un número mayor que 1.0,
por ejemplo, 50.0. Esto es mejor hacerlo solo una vez en el inicio de la app. Si 
cambias esto al vuelo, especialmente si lo reduces cuando las animaciones 
estan ejecutándose, es posible que el framework observe que el tiempo retrocede, 
lo que probablemente resultará en aserciones y generalmente interfere 
con tus esfuerzos.

## Depurando problemas de rendimiento

Para ver porque en tu aplicación se están provocando _relayout_ o _repaints_, puedes fijar 
las etiquetas 
[`debugPrintMarkNeedsLayoutStacks`](https://docs.flutter.io/flutter/rendering/debugPrintMarkNeedsLayoutStacks.html)
y
[`debugPrintMarkNeedsPaintStacks`](https://docs.flutter.io/flutter/rendering/debugPrintMarkNeedsPaintStacks.html)
respectivamente. Esto registra un seguimiento de la pila en la consola 
cada vez que una caja de renderizado es llamada a ejecutar un relayout 
y un repaint. Puedes usar el método `debugPrintStack()` de la biblioteca 
`services` para imprimir tu propio seguimiento de la pila bajo demanda, 
si este tipo de aproxmación es útil para ti.

### Medir el tiempo de inicio de tu app

Para recopilar información detallada sobre el tiempo que toma tu app 
Flutter para arrancar, puedes ejecutar el comando `flutter run` con 
las opcioens `trace-startup` y `profile`.

```
$ flutter run --trace-startup --profile
```
La salida del seguimiento es guardada como un fichero JSON llamado `start_up_info.json` bajo el 
directorio `build` de tu proyecto Flutter. La salida muestra el tiempo transcurrido 
desde el arranca de la app hasta estos eventos trazados (capturados en microsegundos):

+ Tiempo para entrar el código del engine de Flutter.
+ Tiempo para renderizar el primer frame de la app.
+ Tiempo para inicializar el framework Flutter.
+ Tiempo para completar la inicialización del framework Flutter.

Por ejemplo:

```
{
  "engineEnterTimestampMicros": 96025565262,
  "timeToFirstFrameMicros": 2171978,
  "timeToFrameworkInitMicros": 514585,
  "timeAfterFrameworkInitMicros": 1657393
}
```

### Rastreando el rendimiento de cualquier código Dart

Para realizar rastreos de rendimiento personalizados y medir tiempos reloj/CPU 
de segmentos arbitrarios de código Dart de forma similar a como lo harías en 
Android con [systrace](https://developer.android.com/studio/profile/systrace.html), usa 
las utilidades [Timeline](https://api.dartlang.org/stable/dart-developer/Timeline-class.html) de 
`dart:developer` para envolver el código que quieres medir como:

<!-- import 'dart:developer'; -->
<!-- skip -->
```dart
Timeline.startSync('interesting function');
// iWonderHowLongThisTakes();
Timeline.finishSync();
```

Entonces abre la página de timeline de Observatory de tu app, revisa la opción 
de grabación de 'Dart' y ejecuta la función que quieres medir.

Refrescar la página muestra el timeline cronológico de registros de tu 
app en la herramienta [tracing tool](https://www.chromium.org/developers/how-tos/trace-event-profiling-tool) 
de Chrome.

Asegúrate que ejecutas `flutter run` en tu app con la opción `--profile` para asegurar 
que las características de rendimiento en tiempo de ejecución se ajustan lo máximo posible 
a tu producto final.

## PerformanceOverlay

Para obtener una representación gráfica del rendimiento de tu aplicación, fija 
el argumento `showPerformanceOverlay` del constructor de 
[`MaterialApp`](https://docs.flutter.io/flutter/material/MaterialApp/MaterialApp.html)
a true. El constructor de 
[`WidgetsApp`](https://docs.flutter.io/flutter/widgets/WidgetsApp-class.html)
tiene un argumento similar. (Si no usas `MaterialApp`
o `WidgetsApp`, puedes obtener el mismo efecto envolviendo tu aplicación 
en un stack y añadiendo un widget a tu stack que sea creado 
llamando a [`PerformanceOverlay.allEnabled()`](https://docs.flutter.io/flutter/widgets/PerformanceOverlay/PerformanceOverlay.allEnabled.html).)

Esto muestra dos gráficas. La de arriba es el tiempo empleado 
en el hilo de la GPU, la de abajo es el tiempo empleado en el hilo 
de la CPU. Las líneas blancas que cruzan las gráficas 
muestran incrementos de 16ms a lo largo del eje vertical;
si el gráfico pasa alguna vez por una de estas líneas entonces 
estas ejecutando a menos de 60Hz. El eje horizontal representa frames. La gráfica solo 
es actualizada cuando tu aplicación se pinta, por tanto si esta inactiva la gráfica 
se detiene.

Esto debe hacerse siempre en modo release, ya que en modo debug 
el rendimiento es sacrificado intencionalmente a cambio de 
costosas aserciones que están destinadas a ayudar al desarrollo, y 
así los resultdos son engañosos.

## Material grid

Cuando se desarrollan aplicaciones que implementan 
[Material Design](https://www.google.com/design/spec/material-design/introduction.html),
puede ser de ayuda sobreponer una [Material Design baseline
grid](https://www.google.com/design/spec/layout/metrics-keylines.html)
sobre la aplicación para ayudar a verificar alineaciones. Para este fin, el 
constructor de [`MaterialApp`](https://docs.flutter.io/flutter/material/MaterialApp/MaterialApp.html) 
tiene un argumento `debugShowMaterialGrid` el cual, cuando se fija a `true` en modo 
debug, se superpone un grid.

También puedes sobreponer un grid en aplicaciones no basadas en Material usando 
el widget [`GridPaper`](https://docs.flutter.io/flutter/widgets/GridPaper-class.html) 
directamente.

## Problemas comunes

{% comment %}
Rewrite the following when we have a larger collection of problems.
{% endcomment %}
El siguiente es un problema que algunos han encontrado en MacOS.

### "Too many open files" exception (MacOS)

El limite de ficheros que se pueden tener abiertos por defecto para MacOS es 
más bien bajo.  Si te encuentras con este limite,
incrementa el numero de manejadores de ficheros disponibles usando 
el comando `ulimit`:

```
ulimit -S -n 2048
```

Si usas Travis para pruebas, incrementa el número de manejadores de ficheros disponibles 
que Travis puede abrir añadiendo la misma linea al fichero flutter/travis.yml.

