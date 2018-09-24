---
layout: page
title: Desarrollar aplicaciones de Flutter en un IDE

permalink: /using-ide-vscode/
---

<div id="tab-set-install">

<ul class="tabs__top-bar">
    <li class="tab-link" data-tab-href="/using-ide/">Android Studio / IntelliJ</li>
    <li class="tab-link current">VS Code</li>
</ul>

<div class="tabs__content current" markdown="1">

La [extensión de Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) proporciona una experiencia de desarrollo completamente integrada en Visual Studio Code.

* TOC Placeholder
{:toc}

## Instalación y configuración

Por favor sigue las instrucciones de la [Configuración del editor](/get-started/editor/#vscode) para instalar la extensión
Flutter (que incluye la funcionalidad de Flutter).

### Actualizando la extensión

Las actualizaciones de la extensión se envían regularmente. Por defecto, 
VS Code actualiza automáticamente las extensiones cuando hay actualizaciones 
disponibles.

Para instalar actualizaciones manualmente:

1. Haga clic sobre el botón Extensions Side Bar
1. Si se muestra la extensión de Flutter con una actualización disponible, haga clic en el botón 
de actualización y luego en el botón de recarga

## Creando proyectos

### Creando un nuevo proyecto

Para crear un nuevo proyecto de Flutter a partir de la plantilla de la aplicación de inicio Flutter:

1. Abre la paleta de comandos (`Ctrl`+`Shift`+`P` (`Cmd`+`Shift`+`P` en macOS)).
1. Seleccione el comando **Flutter: New Project** y presione `Enter`.
1. Ingrese tu **nombre de proyecto** deseado.
1. Seleccione un **Project location**.

### Abriendo un proyecto desde el código fuente existente

Para abrir un proyecto Flutter existente:

1. Clic en **File>Open...** desde la ventana principal del IDE.
1. Navegue al directorio que contiene tus archivos de código fuente existentes de Flutter.
1. Clic en **Open**.

## Edición de código y problemas de visualización

La extensión de Flutter realiza análisis de código que permite:

* Resaltado de sintaxis.
* Completado de código basado en análisis de tipo enriquecido.
* Navegando para escribir declaraciones (**Go to Definition** or `F12`), y buscar tipo
  de usos (**Find All References** o `Shift`+`F12`).
* Visualización de todos los problemas actuales del código fuente (**View>Problems** or `Ctrl`+`Shift`+`M` (`Cmd`+`Shift`+`M` en macOS)).
  Cualquier problema de analisis se muestra en el palen Problemas:<br>
  <img src="/images/vscode/problems.png" style="width:660px;height:141px" alt="Problems pane" />

## Ejecución y depuración

Comience a depurar haciendo clic en **Debug>Start Debugging** desde la ventana principal del IDE o presione `F5`.

### Seleccionar un dispositivo de destino

Cuando se abre un proyecto Flutter en VS Code, debería ver un conjunto de entradas 
específicas de Flutter en la barra de estado, incluida una versión de Flutter SDK 
y un nombre de dispositivo (o el mensaje **Sin dispositivos**).

<img src="/images/vscode/device_status_bar.png" style="width:477px;height:73px" alt="Flutter device" />

*Nota*: si no ve el número de versión de Flutter o la información del dispositivo, es 
posible que su proyecto no se haya detectado como un proyecto de Flutter. Asegúrate de 
que la carpeta que contiene tu `pubspec.yaml` está dentro de una **Carpeta del espacio de trabajo**
de VS Code.

*Nota*: si la barra de estado dice **Sin dispositivos** Flutter no ha sido
capaz de descubrir cualquier dispositivo o simulador conectado con iOS o Android.
Necesita conectar un dispositivo o iniciar un simulador para continuar.

La extensión Flutter selecciona automáticamente el último dispositivo conectado.
Sin embargo, si tiene varios dispositivos/simuladores conectados, haga clic en
**dispositivo** en la barra de estado para ver una lista de selección
en la parte superior de la pantalla Selecciona el dispositivo que desea usar para
ejecutar o depurar.

### Ejecuta la aplicación sin puntos de interrupción

1. Clic en **Debug>Start Without Debugging** en la ventana principal del IDE, o
  presiona `Ctrl`+`F5`.
* La barra de estado se vuelve naranja para mostrar que se encuentra en una sesión de depuración.<br>
<img src="/images/vscode/debug_console.png" style="width:490px;height:208px" alt="Debug Console" />

### Ejecutar aplicación con puntos de interrupción

1. Si lo deseas, establezca puntos de interrupción en tu código fuente.
1. Clic en **Debug>Start Debugging** en la ventana principal del IDE, o presiona `F5`.
* La parte derecha de **Debug Sidebar** muestra stack frames y variables.
* El panel inferior de **Debug Console** muestra la salida de registros detallados.
* La depuración se basa en una configuración de inicio predeterminada. Para personalizar esto,
  haz clic en el el engranaje en la parte superior de **Debug Sidebar** para crear un archivo 
  `launch.json`. Luego puede modificar los valores.

## Edición rápida y actualización en ciclo de desarrollo

Flutter ofrece el mejor ciclo de desarrollo de su clase, permitiéndote ver 
el efecto de tus cambios casi instantáneamente con la función de "hot reload". Mira
[Usando Hot reloading Flutter Apps](/hot-reload/) para más detalles.


## Depuración avanzada

### Depuración de problemas de diseño visual

Durante una sesión de depuración, se agregan varios comandos de depuración adicionales a la
[Paleta de Comandos](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette),
incluyendo:

* 'Toggle Baseline Painting': Hace que cada RenderBox dibuje una línea en cada línea de base.

* 'Toggle Repaint Rainbow': Muestra colores rotativos en las capas cuando vuelva a pintar.

* 'Toggle Slow Animations': Reduce la velocidad de las animaciones para permitir la inspección visual.

* 'Toggle Slow-Mode Banner': Ocultar el banner de "slow mode" incluso cuando se ejecuta una compilación de depuración.

### Depurando con Observatory

Observatory es una herramienta adicional de depuración y creación de perfiles presentada 
con una interfaz de usuario basada en html. Para detalles vea la [página Observatory](https://dart-lang.github.io/observatory/).

Para abrir Observatory:

1. Ejecute su aplicación en modo de depuración.
1. Ejecute el comando **Open Observatory** desde la [Paleta de Comandos](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette).

## Consejos de edición para el código Flutter

### Asistencias y soluciones rápidas

Las asistencias son cambios de código relacionados con un determinado identificador 
de código. Varias de ellas están disponibles cuando el cursor se coloca en un 
identificador de widget Flutter, como se indica mediante el icono de bombilla amarilla. 
La asistencia se puede invocar haciendo clic en la bombilla o usando el atajo de teclado 
`Ctrl`+`Enter`, como se ilustra aquí:

<img src="/images/vscode/assists.png" style="width:467px;height:234px" alt="Code Assists" />

Las soluciones rápidas son similares, solo se muestran con un código que tiene un error y 
pueden ayudar a corregirlo.

#### Ajustar con la nueva asistencia de widgets
Esto se puede usar cuando tiene un widget que desea envolver en un widget circundante, 
por ejemplo, si desea envolver un widget en un `Row` o un `Column`.

####  Ajustar la lista de widgets con la nueva asistencia de widgets
Similar a la asistencia anterior, pero para envolver una lista existente de widgets en 
lugar de un widget individual.

#### Asistencia para convertir child a children
Cambiar un argumento child a un argumento children, y ajustar el valor del argumento en
una lista.

### Snippets

Los snippets se pueden usar para acelerar la entrada a las estructuras de código típicas. 
Se invocan escribiendo su 'prefijo' y luego seleccionando desde la ventana de finalización del código:

<img src="/images/vscode/snippets.png" style="width:706px;height258px" alt="Snippets" />

La extensión de Flutter incluye los siguientes snippets:

* Prefijo `stless`: Crea una nueva subclase de `StatelessWidget`.
* Prefijo `stful`: Crea una nueva subclase de `StatefulWidget` y su subclase State asociada.
* Prefijo `stanim`: Crea una nueva subclase de `StatefulWidget`, y su subclase State asociada
 incluyendo un campo inicializado con un `AnimationController`.

Puedes también definir snippets personalizados ejecutando **Configure User Snippets** desde
la [Paleta de Comandos](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette).

### Atajos de teclado

**Hot Reload**

Durante una sesión de depuración, haciendo clic en el botón **Restart** sobre **Debug
Toolbar**, o presionando `Ctrl`+`Shift`+`F5` (`Cmd`+`Shift`+`F5` en macOS)
realiza un hot reload.

Las asignaciones de teclado puede ser cambiado ejecutando el comando **Open Keyboard Shortcuts**
desde la [Paleta de Comandos](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette).

**Hot Restart**

### 'Hot Reloads' vs 'Hot Restarts'

Hot reload funciona inyectando archivos actualizados de código fuente en la 
máquina virtual Dart en ejecución. Esto incluye no solo agregar nuevas 
clases, sino también agregar métodos y campos a las clases existentes, y cambiar las 
funciones existentes. Sin embargo, algunos tipos de cambios de código no se reflejarán con 
hot reload:

* Inicializadores variables globales.
* Inicializadores de campo estáticos.
* El método `main()` de la aplicación.

Para estos cambios, puedes reiniciar completamente tu aplicación, sin tener que finalizar 
tu sesión de depuración. Para realizar un hot restart, ejecute el comando
**Flutter: Hot Restart** desde la 
[Paleta de Comandos](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette), o presiona `Ctrl`+`F5`.

## Solución de problemas

### Problemas conocidos y comentarios

Todos los errores conocidos se siguen en los issue trackers:

  * Extensiones Dart and Flutter: [GitHub issue
   tracker](https://github.com/Dart-Code/Dart-Code/issues).

Todos los comentarios son bien recibidos, tanto sobre errores/problemas como sobre solicitudes de 
funciones. Antes de presentar nuevos problemas, por favor:

  * Haga una búsqueda rápida en los issue trackers para ver si el problema ya fue rastreado.
  * Asegúrese de tener [actualizado](#updating) la versión más reciente del plugin.

Cuando presente nuevos problemas, por favor incluya la salida de [`flutter doctor`](https://flutter.io/bug-reports/#provide-some-flutter-diagnostics).

</div>

</div>
