{% if os == 'linux' -%}
  {% assign unzip = 'tar xf' -%}
  {% assign file_ext = '.tar.xz' -%}
{% else -%}
  {% assign unzip = 'unzip' -%}
  {% assign file_ext = '.zip' -%}
{% endif -%}

## Obtener el SDK de Flutter {#get-sdk}

1. Descarga el siguiente paquete de instalación para obtener la versión más reciente {{site.sdk.channel}} release del 
   SDK Flutter:

   [(loading...)](#){:.download-latest-link-{{os}}.btn.btn-primary}

   Para otros release channels, y compilaciones más viejas, mira la página [SDK 
   archive](/docs/development/tools/sdk/archive).
1. Extraiga el archivo en la ubicación deseada, por ejemplo:

    {% comment %}
      Our JS also updates the filename in this template, but it doesn't include the terminal formatting:

      {% prettify shell %}
      $ cd ~/development
      $ {{unzip}} ~/Downloads/[[download-latest-link-filename]]flutter_{{os}}_vX.X.X-{{site.sdk.channel}}{{file_ext}}[[/end]]
      {% endprettify %}
    {% endcomment -%}

    ```terminal
    $ cd ~/development
    $ {{unzip}} ~/Downloads/flutter_{{os}}_vX.X.X-{{site.sdk.channel}}{{file_ext}}
    ```

1. Agrega la herramienta `flutter` a tu path:
   
    ```terminal
    $ export PATH="$PATH:`pwd`/flutter/bin"
    ```

    Este comando configura tu variable `PATH` sólo para la ventana _actual_ de terminal. 
    Para agregar Flutter permanentemente a tu path, mira [Actualiza  
    el path](#actualiza-tu-path).

¡Ahora estas preparado para ejecutar comandos de Flutter!

{{site.alert.note}}
Para actualizar una versión existente de Flutter, mira 
[Actualizando Flutter](/docs/development/tools/sdk/upgrading).
{{site.alert.end}}

### Ejecuta flutter doctor

Ejecuta el siguiente comando para verificar si existe alguna dependencia que se necesite para
completar la configuración (para una salida detallada, añade la etiqueta `-v`):

```terminal
$ flutter doctor
```

Este comando verifica tu entorno y muestra un reporte en la ventana del terminal.
El SDK de Dart esta empaquetado con Flutter, no es necesario instalar Dart por separado.
Verifica la salida con cuidado para otros programas que 
pudieras necesitar o tareas a realizar (mostradas en texto en **negrita**).

Por ejemplo:
<pre>
[-] Android toolchain - develop for Android devices
    • Android SDK at /Users/obiwan/Library/Android/sdk
    <strong>✗ Android SDK is missing command line tools; download from https://goo.gl/XxQghQ</strong>
    • Try re-installing or updating your Android SDK,
      visit https://flutter.io/setup/#android-setup for detailed instructions.
</pre>

La siguiente sección describe cómo desempeñar estas tareas y finalizar el proceso de configuración.

Una vez que tengaS instalado cualquiera de las dependencias faltantes, ejecuta el comando `flutter doctor`
de nuevo para verificar que todo se ha configurado correctamente.

{% include_relative _analytics.md %}
