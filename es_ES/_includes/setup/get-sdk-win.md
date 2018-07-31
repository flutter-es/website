## Obetener el SDK de Flutter

1. Descarga la siguiente paquete de instalación para obtener la version beta mas reciente de 
Flutter SDK (para otros lanzamientos, y paquetes viejos, véase la pagina [SDK
archive](/sdk-archive/)):
    * [(cargando...)](#){:.download-latest-link-windows}
1. Extraiga el archivo zip y coloque el contenido de `flutter` en la locacion
   deseada de instalación para el Flutter SDK (ej. `C:\src\flutter`; no instale
   flutter en un directorio como `C:\Program Files\` que requiere permisos de administrador).
1. Localice el archivo `flutter_console.bat` dentro del directorio de `flutter`. Inicielo con doble click.

Ahora esta todo listo para ejecutar los commando de Flutter en la consola de Flutter!

Para actualizar una version existente de Flutter, vea [Actualizando Flutter](/upgrading/).

### Actualizando tu "path"

Si desea ejecutar los comandos de Flutter en un ventana de comandos regular de Windows, siga
estos pasos y agrege Flutter a las variables de ambiente en el PATH:

* Entra a "Panel de Control > Cuentas de usuario > Cuentas de usuario > Cambiar mis variables de entorno"
* Debajo de "Variables de usuario" verifica si existe una entrada llamada "Path":
    * Si el directorio de glutter no existe, agrega el directorio completo `flutter\bin` usando `;`
      como separador de los valores existentes.
    * Si la entrada `Path` no existe, crea una nueva variable llamada `Path` con el 
      directorio completo a `flutter\bin` como su valor.

Reinicia Windows para aplicar los cambios completamente.

### Ejecutar flutter doctor

Enl a consola de FLutter, ejecuta el siguiente comando para
ver si existe alguna dependencia que necesite instalar para completar la configuración:

{% commandline %}
flutter doctor
{% endcommandline %}

Este comando verifica tu ambiente y muestra un reporte en la terminal de windows.
El SDK de Dart esta empaquetado con Flutter, no es necesario instalar Dart por separado.
Verifica la salida con cuidad para otros programas que pudieras necesitar o para 
desempeñar otras tareas mas adelante (mostradas en texto en **negrita**).

Por Ejemplo:
<pre>
[-] Android toolchain - develop for Android devices
    • Android SDK at D:\Android\sdk
    <strong>✗ Android SDK is missing command line tools; download from https://goo.gl/XxQghQ</strong>
    • Try re-installing or updating your Android SDK,
      visit https://flutter.io/setup/#android-setup for detailed instructions.
</pre>

La siguiente seccion describe como desempeñar estas tareas y finalizar el proceso de configuración.
Uva vez que tenga instalado cualquiera de las dependencias faltantes, ejecute el comando `flutter doctor`
de nuevo para verificar que todo se ha configurado correctamente.

Las herramientas de Flutter usan Google Analytics para anonimamente reportar estadistica de 
caracteristicas de uso y repostes basicos de fallas. Estos datos son utilizados para ayudar 
a mejorar las herramientas de flutter con el tiempo.
Analytics no envia cada ejecución o cualquier ejecucion dentro del `flutter config`,
por lo que puede optar por no participar en los análisis antes de enviar los datos. 
Para deshabilitar los reportes, teclee `flutter config --no-analytics` y para desplegar la
configuracion actual, teclee `flutter config`. 
Vea la politica de privacidad de Google: [www.google.com/intl/en/policies/privacy](https://www.google.com/intl/en/policies/privacy/).
{: .alert-warning}
