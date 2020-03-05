## Configuración de Android 

{{site.alert.note}}
  Flutter requiere de una completa instalación de Android Studio para proveer
  las dependencias de la plataforma de Android. De cualquier manera, puede desarrollar sus
  apps de Flutter en diferentes editores; hablaremos de ello en un paso siguiente.
{{site.alert.end}}

### Instalar Android Studio

1. Descarga e instala [Android Studio]({{site.android-dev}}/studio).
1. Inicia Android Studio, y sigue todo el 'Android Studio Setup Wizard'. Este
Instalará la versión más reciente de Android SDK, Android SDK Platform-Tools y 
Android SDK Build-Tools, Las cuales son requeridas por Flutter cuando se desarrolla para Android.

### Configurar tu dispositivo Android

Prepara la ejecución y pruebas de app de Flutter en un dispositivo de Android, necesitará
un dispositivo Android ejecutando Android 4.1 (API nivel 16) o superior.

1. Habilita **Opciones de desarrollador** y **Depurador por USB** en tu dispositivo. Instrucciones detalladas
 están disponibles en la [Documentación de Android]({{site.android-dev}}/studio/debug/dev-options).
1. Solo en Windows: Instala [Google USB Driver]({{site.android-dev}}/studio/run/win-usb)
1. Utilizando el cable USB, conecta tu móvil de la computadora, de requerirse en tu 
dispositivo, autoriza el acceso de la computadora a tu dispositivo.
1. En terminal, ejecuta el comando `flutter devices`  para verificar que Flutter ha reconocido 
tu dispositivo Android conectado.

Por defecto, Flutter utiliza la versión SDK de Android donde se encuentren las herramientas `adb`. Si
quieres que Flutter utilice alguna instalación diferente del SDK de Android, deberás configurar
la variable de entorno `ANDROID_HOME` en el directorio de instalación.

### Configurar el emulador de Android

Prepare la ejecución y pruebas de app de Flutter en el emulador de Android, siguiendo estos pasos:

1. Habilita [VM acceleration]({{site.android-dev}}/studio/run/emulator-acceleration) en tu equipo.
1. Abra **Android Studio>Tools>Android>AVD Manager** y selecciona
**Create Virtual Device**. (El submenú **Android** está presente solo
cuando se encuentra dentro de un proyecto de Android.)
1. Elija un dispositivo y seleccione **Next**.
1. Selecciona una o más imágenes del sistema que quieres emular,
   y selecciona **Next**. Una imagen _x86_ o _x86\_64_ es recomendada.
1. Dentro de Emulated Performance, selecciona **Hardware - GLES 2.0** para habilitarlo
[aceleración de hardware]({{site.android-dev}}/studio/run/emulator-acceleration).
1. Verifica que la configuración de AVD es correcta, y selecciona **Finish**.

   Para mayor detalle de los pasos de arriba, vea [Administrando AVDs]({{site.android-dev}}/studio/run/managing-avds.html).
1. En el Administrador de Dispositivos Virtuales de Android (AVD), da clic en la barra de herramienta **Run**.
   El emulador iniciará el arranque y mostrara el lienzo (canvas) por defecto para la versión del SO y dispositivo seleccionado.
