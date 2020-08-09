<div class="tab-pane" id="vscode" role="tabpanel" aria-labelledby="vscode-tab" markdown="1">

## Crea la app

  1. Llama a **View > Command Palette**
  1. Teclea "flutter", y selecciona la acción **Flutter: New Project**
  1. Introducir el nombre del proyecto (como `myapp`), y presiona **Enter**
  1. Crear o seleccionar el directorio padre para el nuevo folder del proyecto
  1. Espera la creación del proyecto y completar la generación de el archivo `main.dart` y que
     aparezca.

Los comandos de arriba crean un directorio para el proyecto llamado `myapp`
el cual contiene una app demo sencilla
que utiliza [Material Components][].

{% include_relative _main-code-note.md  %}

## Ejecutar app

 1. Localizar la barra de estado de VS Code(la barra azul en la parte de abajo de la ventana):<br> ![status bar][]{:.mw-100}
 1. Seleccionar el dispositivo de el área de **Device Selector**.
    Para detalles, vea [Cambio rápido entre dispositivos de Flutter][].
    - Si no se encuentra ningún dispositivo disponible y prefieres usar un simulador,
      clic **No Devices** y lance un simulador.
    - Para configurar un dispositivo real, siga las instrucciones para el dispositivo en específico para 
    [instalar][] en el SO que utilice.
 1. Llamar a **Debug > Start Debugging** o presionar <kbd>F5</kbd>
 1. Espere que el app sea lanzada &mdash; el progreso se imprimirá en la vista de
    **Debug Console**
 
{% capture save_changes -%}
  : invoca **Save All**, o haz clic en **Hot Reload**
  <i class="material-icons align-bottom">offline_bolt</i>.
  {% comment %} O, como alternativa:
    {% asset 'get-started/hot-reload-button.png' alt='looks like a lightning bolt' %}.
  {% endcomment -%}
{% endcapture %}

{% include_relative _try-hot-reload.md save_changes=save_changes %}

[instalar]: /docs/get-started/install
[Material Components]: {{site.material}}/guidelines
[Quickly switching between Flutter devices]: https://dartcode.org/docs/quickly-switching-between-flutter-devices
[Cambio rápido entre dispositivos de Flutter]: {% asset tools/vs-code/device_status_bar.png @path %}

</div>
