---
layout: page
title: Desarrollar aplicaciones de Flutter en un IDE

permalink: /using-ide/
---

<div id="tab-set-install">

<ul class="tabs__top-bar">
    <li class="tab-link current" >Android Studio / IntelliJ</li>
    <li class="tab-link" data-tab-href="/using-ide-vscode/">VS Code</li>
</ul>

<div class="tabs__content current" markdown="1">

El plugin Flutter proporciona una experiencia de desarrollo completamente 
integrada en los IDE de Android Studio o IntelliJ.

* TOC Placeholder
{:toc}

## Instalación y configuración

Por favor sigue las instrucciones de la [Configuración del Editor](/get-started/editor/)
para instalar los plugins Dart y Flutter.

### Actualizando los plugins<a name="updating"/>

Las actualizaciones de los plugins se envían regularmente. Deberías recibir un aviso 
en IntelliJ cuando haya una actualización disponible.

Para buscar actualizaciones manualmente:

1. Abre preferencias (**Android Studio>Check for Updates...** en macOS,
**Help>Check for Updates...** en Linux).
1. Si `dart` o `flutter` están instalados, actualízalos.

## Creando proyectos

### Creando un nuevo proyecto

Para crear un nuevo proyecto de Flutter a partir de la plantilla de la aplicación de inicio Flutter:

1. En el IDE, haz clic **Create New Project** desde la ventana 'Welcome' o
**File>New>Project...** desde la ventana principal del IDE.
1. Selecciona **Flutter** en el menú, y clic en **Next**.
1. Ingresa tu **Project name** y **Project location** deseado.
1. Si piensas publicar esta aplicación, [establece el dominio de la compañía](#note).
1. Clic en **Finish**.

<div>
<a name="note"></a>
<aside class="alert alert-info" markdown="1">
**Estableciendo el dominio de la compañía**<br>
Al crear una nueva aplicación, algunos plugins de IDE de Flutter piden un
nombre de la organización en orden de dominio inverso,
algo así como `com.example`. Junto con el nombre de la aplicación,
esto se usa como el nombre del paquete para Android y el ID del paquete para iOS
cuando se lanza la aplicación. Si crees que alguna vez lanzarás esta aplicación,
es mejor especificar estos ahora. No se pueden cambiar una vez que la aplicación
sea lanzada. El nombre de su organización debe ser único.
</aside>
</div>

### Creando un nuevo proyecto a partir de código fuente existente

Para crear un nuevo proyecto de Flutter que contenga los archivos de código fuente 
de Flutter existente:

1. En el IDE, clic **Create New Project** desde la ventana 'Welcome' o
**File>New>Project...** desde la ventana principal del IDE.
  - **Nota**: *No* uses la opción **New>Project from existing sources...** para proyectos Flutter.
1. Seleccione **Flutter** en el menú, y clic en **Next**.
1. En **Project location**, ingresa o navega hasta el directorio que contiene tus
archivos de código fuente existentes de Flutter.
1. Clic en **Finish**.

## Edición de código y visualización de problemas de código

El plugin Dart realiza análisis de código que permite:

* Resaltado de sintaxis
* Completado de código basado en análisis de tipo enriquecido.
* Navegando para escribir declaraciones (**Navigate>Declaration**) y buscar tipo
  de usos (**Edit>Find>Find Usages**).
* Visualización de todos los problemas actuales del código fuente 
  (**View>Tool Windows>Dart Analysis**).
  Cualquier problema de análisis se muestra en el panel Análisis de Dart:<br>
  ![Dart Analysis pane](/images/intellij/dart-analysis.png)

## Ejecución y depuración

La ejecución y la depuración se controlan desde la barra de herramientas principal:

![Main IntelliJ toolbar](/images/intellij/main-toolbar.png)

### Seleccionando un objetivo

Cuando se abre un proyecto de Flutter en el IDE, debería ver un conjunto de botones 
específicos de Flutter en el lado derecho de la barra de herramientas.

*Nota*: si los botones Ejecutar y Depurar están desactivados y no hay ningún objetivo
 en la lista, Flutter no ha podido descubrir ningún dispositivo o simulador iOS o 
 Android conectado. Necesita conectar un dispositivo o iniciar un simulador para continuar.

1. Ubica el botón desplegable **Flutter Target Selector**. Esto muestra una lista de 
   objetivos disponibles. Selecciona el destino en el que deseas que se inicie tu aplicación.
* Cuando conectas dispositivos o inicias simuladores, aparecen entradas adicionales.

### Ejecuta la aplicación sin puntos de interrupción

1. Clic en **Play icon** en la barra de herramientas, o invoca **Run>Run**.
* El panel inferior **Run** muestra el resultado de los registros:<br>
![Log pane](/images/intellij/log.png)

### Ejecutar aplicación con puntos de interrupción

1. Si lo deseas, establezca puntos de interrupción en tu código fuente.
1. Clic en **Debug icon** en la barra de herramientas, o invoca **Run>Debug**.
* El panel inferior **Debugger** muestra Stack Frames y Variables.
* El panel inferior **Console** muestra la salida de registros detallados.
* La depuración se basa en una configuración de inicio predeterminada. Para 
  personalizar esto, haz clic en el botón desplegable a la derecha del 
  selector de dispositivo, y selecciona **Edit configuration**.

## Edición rápida y actualización en ciclo de desarrollo

Flutter ofrece el mejor ciclo de desarrollo de su clase, permitiéndote ver 
el efecto de tus cambios casi instantáneamente con la función de "hot reload". Mira
[Usando Hot reloading Flutter Apps](/hot-reload/) para más detalles.

## Depuración avanzada

### Depuración de problemas de diseño visual

Para depurar un problema visual, inicia la aplicación con 'Debbuger', y luego abre la
ventana de la herramienta Flutter Inspector usando 'View> Tool Windows> Flutter Inspector'.

![Flutter Inspector Window](/images/intellij/visual-debugging.png)

Esto ofrece muchas herramientas de depuración; para detalles sobre estos, por favor mira
[Depura tu app](https://flutter-es.io/debugging/).

* 'Toggle Select Widget Mode': Selecciona un widget en el dispositivo para inspeccionarlo en el
  [Flutter Inspector](/inspector/).

* 'Toggle Debug Paint': Agregue sugerencias de depuración visual a la presentación que muestra 
  bordes, relleno, alineación y espaciadores.

* 'Toggle Platform Mode': Alternar entre renderizado para Android o iOS.

* 'Toggle Performance Overlay': Mostrar gráficos de rendimiento para los hilos de la GPU y la CPU.

* 'Open Timeline View': Analiza la actividad de la aplicación mientras se ejecuta.

* 'Open Observatory': Un perfilador para aplicaciones Dart.

También disponible en el menú de acciones adicionales:

* 'Show Paint Baselines': Hace que cada RenderBox dibuje una línea en cada línea de base.

* 'Enable Repaint Rainbow': Muestra colores rotativos en las capas cuando vuelva a pintar.

* 'Enable Slow Animations': Reduce la velocidad de las animaciones para permitir la inspección visual.

* 'Hide Debug Banner': Ocultar el banner 'debug' incluso cuando se ejecuta una compilación de depuración.


### Depurando con Observatory

Observatory es una herramienta adicional de depuración y creación de perfiles presentada 
con una interfaz de usuario basada en html. Para detalles vea la [página Observatory](https://dart-lang.github.io/observatory/).

Para abrir Observatory:

1. Ejecute su aplicación en modo de depuración.
1. Seleccione la acción 'open observatory' del panel Depurar (ver la captura de pantalla a continuación), 
click en **Stopwatch icon** ('Open Observatory').

![Debugging panel](/images/intellij/debug-panel.png)

## Consejos de edición para el código Flutter

### Asistencias y soluciones rápidas

Las asistencias son cambios de código relacionados con un determinado identificador 
de código. Varias de ellas están disponibles cuando el cursor se coloca en un 
identificador de widget Flutter, como se indica mediante el icono de bombilla amarilla. 
La asistencia se puede invocar haciendo clic en la bombilla o usando el atajo de teclado 
(`Alt` +`Enter` en Linux y Windows, `Option` +`Return` en macOS), como se ilustra aquí:

![IntelliJ editing assists](/images/intellij/assists.gif)

Las soluciones rápidas son similares, solo se muestran con un código que tiene un error 
y pueden ayudar a corregirlo. Están indicados con una bombilla roja.

#### Ajustar con la nueva asistencia de widgets
Esto se puede usar cuando tiene un widget que desea envolver en un widget circundante, 
por ejemplo, si desea envolver un widget en un `Row` o un `Column`.

####  Ajustar la lista de widgets con la nueva asistencia de widgets
Similar a <label></label> asistencia anterior, pero para envolver una lista existente de widgets en 
lugar de un widget individual.

#### Asistencia para convertir child a children
Cambiar un argumento child a un argumento children, y ajustar el valor del argumento en
una lista.

### Plantillas en vivo

Las plantillas en vivo se pueden usar para acelerar la entrada a estructuras de código 
típicas. Se invocan al escribir su 'prefijo' y luego seleccionarlo en la ventana de 
finalización del código:

![IntelliJ live templates](/images/intellij/templates.gif)

El plugin Flutter incluye las siguientes plantillas:

* Prefijo `stless`: Crea una nueva subclase de `StatelessWidget`.
* Prefijo `stful`: Crea una nueva subclase de `StatefulWidget` y su subclase State 
  asociada.
* Prefijo `stanim`: Crea una nueva subclase de `StatefulWidget`, y su subclase de 
  estado asociada que incluye un campo inicializado con un `AnimationController`.

Puedes también definir plantillas personalizadas en **Settings > Editor > Live Templates**.

### Atajos de teclado

**Hot reload**

En Linux (keymap _Por defecto para XWin_) y windows los atajos de teclado
son `Controle`+`Alt`+`;` y `Control`+`Backslash`.

En macOS (keymap _Mac OS X 10.5+ copy_) los atajos de teclado son `Command`+`Option`;
y `Command`+`Backslash`.

Las asignaciones de teclado se pueden cambiar en las Preferencias / Configuraciones de 
IDE: Seleccione *Mapa de teclas*, luego ingrese _flutter_ en el cuadro de búsqueda en 
la esquina superior derecha. Haga clic derecho en el enlace que desea cambiar y 
_Agregue acceso directo al teclado_.

![IntelliJ Settings Keymap](/images/intellij/keymap-settings-flutter-plugin.png)

### 'Hot reload' vs 'Full Application Restarts'

Hot reload funciona inyectando archivos actualizados de código fuente en la 
máquina virtual Dart en ejecución (máquina virtual). Esto incluye no solo agregar nuevas 
clases, sino también agregar métodos y campos a las clases existentes, y cambiar las 
funciones existentes. Sin embargo, algunos tipos de cambios de código no pueden ser 
recargados en caliente:

* Inicializadores variables globales.
* Inicializadores de campo estáticos.
* El método `main()` de la aplicación.

Para estos cambios, puedes reiniciar completamente tu aplicación, sin tener que finalizar 
tu sesión de depuración:

1. No hagas clic en el botón Detener; simplemente vuelve a hacer clic en el botón Ejecutar 
(si estás en una sesión de ejecución) o en el botón Depurar (si estás en una sesión de depuración), 
o haga clic y haz clic en el botón 'recargar en caliente'.

## Edición de código de Android en IntelliJ IDEA {#edit-android-code}

Para habilitar la edición del código de Android en IntelliJ IDEA, debes configurar la ubicación 
del SDK de Android:

1. En Preferences->Plugins, habilita **Android Support** si aún no lo has hecho.
1. Clic Derecho en la carpeta **android** en la vista Project, y selecciona **Open
Module Settings**.
1. En la pestaña **Sources**, localiza el campo **Language level**, y selecciona nivel '8'
o superior.
1. En la pestaña **Dependencies**, localiza el campo **Module SDK**, y selecciona un
SDK de Android. Si ningún SDK es listado, haga clic en **New...** y especifica la localización del
SDK de Android. Asegúrate de seleccionar un SDK de Android que coincida con el utilizado por Flutter 
(según lo informado por `flutter doctor`).
1. Clic en **OK**.

## Consejos y trucos

Por favor revisa estos 'cheat sheet':

  * [Flutter IDE cheat sheet, MacOS version](/downloads/Flutter-IntelliJ-cheat-sheet-MacOS.pdf)
  * [Flutter IDE cheat sheet, Windows & Linux version](/downloads/Flutter-IntelliJ-cheat-sheet-WindowsLinux.pdf)

## Solución de problemas

### Problemas conocidos y comentarios

Los problemas conocidos importantes que pueden afectar a tu experiencia están documentados en el archivo 
[README del plugin de Flutter](https://github.com/flutter/flutter-intellij/blob/master/README.md).

Todos los errores conocidos se siguen en los issue trackers:

  * Plugin de Flutter: [GitHub issue
   tracker](https://github.com/flutter/flutter-intellij/issues).
  * Dart plugin: [JetBrains
   YouTrack](https://youtrack.jetbrains.com/issues?q=%23dart%20%23Unresolved).

Todos los comentarios son bien recibidos, tanto sobre errores/problemas como sobre solicitudes de 
funciones. Antes de presentar nuevos problemas, por favor:

  * Haga una búsqueda rápida en los issue trackers para ver si el problema ya fue rastreado.
  * Asegúrese de tener [actualizado](#updating) la versión más reciente del plugin.

Cuando presente nuevos problemas, incluya el resultado de 
[`flutter doctor`](https://flutter-es.io/bug-reports/#provide-some-flutter-diagnostics).

</div>

</div>
