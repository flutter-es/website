## Obtener el SDK de Flutter

1. Descarga el siguiente paquete de instalación para obtener la versión más reciente {{site.sdk.channel}} release del 
   SDK Flutter:

   [(loading...)](#){:.download-latest-link-{{os}}.btn.btn-primary}

   Para otros release channels, y compilaciones más viejas, mira la página [SDK 
   archive](/docs/development/tools/sdk/archive).
1. Extraiga el archivo zip y coloque el contenido de `flutter` en la ubicación
   deseada de instalación para el Flutter SDK (ej. `C:\src\flutter`; no instale
   flutter en un directorio como `C:\Program Files\` que requiere permisos 
   de administrador).
1. Localice el archivo `flutter_console.bat` dentro del directorio de `flutter`. Inícialo 
   con doble clic.

¡Ahora está todo listo para ejecutar los comandos de Flutter en la consola de Flutter!

Para actualizar una versión existente de Flutter, vea [Actualizando Flutter](/docs/development/tools/sdk/upgrading).

### Actualizando tu "path"

Si deseas ejecutar los comandos de Flutter en un ventana de comandos regular de Windows, siga
estos pasos y agregue Flutter a las variables de entorno en el `PATH`:

* Desde la barra de busqueda en Inicio, escribe 'env' y selecciona **Editar variables de 
entorno para tu cuenta**
* Debajo de **Variables de usuario** verifica si existe una entrada llamada **Path**:
    * Si la entrada existe, agrega la ruta completa a `flutter\bin` usando `;`
      como separador de los valores existentes.
    * Si la entrada no existe, crea una nueva variable de usuario llamada `Path` 
      con la ruta completa `flutter\bin` como su valor.

Ten en cuenta que tendrás que cerrar y reabrir cualquier ventana de consola 
existente para que estos cambios surtan efecto.

### Ejecuta `flutter doctor`

Desde una ventana de consola que tenga el directorio Flutter en su path (ver arriba), 
ejecuta el siguiente comando para ver si hay algunas dependencias de la plataforma que 
necesites para completar la configuración:

```console
C:\src\flutter>flutter doctor
```

Este comando verifica tu entorno y muestra un reporte del estado de tu 
instalación de Flutter. Verifica la salida con cuidado para otros programas que 
pudieras necesitar o tareas a realizar (mostradas en texto en **negrita**).

Por Ejemplo:

<pre>
[-] Android toolchain - develop for Android devices
    • Android SDK at D:\Android\sdk
    <strong>✗ Android SDK is missing command line tools; download from https://goo.gl/XxQghQ</strong>
    • Try re-installing or updating your Android SDK,
      visit https://flutter.io/setup/#android-setup for detailed instructions.
</pre>

La siguiente sección describe como desempeñar estas tareas y finalizar el proceso de 
configuración. Una vez que tenga instalado cualquiera de las dependencias faltantes, 
puedes ejecutar el comando `flutter doctor` de nuevo para verificar que todo se ha configurado correctamente.

{% include_relative _analytics.md %}