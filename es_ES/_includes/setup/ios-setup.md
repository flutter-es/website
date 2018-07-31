## Configuración de iOS 

### Instalar Xcode

Para desarrollar apps con Flutter en iOS, necesitaras una MAC con Xcode 9.0 o mas nuevo:

1. Instalar Xcode 9.0 o mas nuevo (via [descarga web](https://developer.apple.com/xcode/) o
[Mac App Store](https://itunes.apple.com/us/app/xcode/id497799835)).
1. Configurar la linea de comandos de Xcode para usar el recien version recien instalada de Xcode 
ejecutando `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer` desde 
la linea de comandos.

   Esta es el directorio correcto la mayoria de casos, cuando quiera hacer uso de la version mas reciente de Xcode.
   Si necesita usar una version siferente, especifique esa direccion en su lugar.

1. Asegurese de firmar el acuerdo de licenci de Xcode abriendo por primera vez y confirmando o
ejecutando `sudo xcodebuild -license` desde la linea de comando.

Con Xcode, seras capaz de ejecutar apps de Flutter en un dispositivo o un simulador.

### Configurar el simulador iOS

Para preparar la ejecución y probar tu app de Flutter en el simulador de iOS, siga estos pasos:

1. En su Mac, Encuente el simulador via Sporlight o utilizando el siguiente comando:

{% commandline %}
open -a Simulator
{% endcommandline %}

2. Asegura que el simulador utilizado este utilizando in dispositivo de 64-bit (iPhone 5s o superior)  verificando la configuracion en el menu del simulador **Hardware > Device**.
3. Dependiendo de el tamaño de la pantalla de la maquina de desarrolo, se simulara la calidad en la pantalla de tu dispositivo iOS el cual podria desbordar la pantalla, configura la escala del dispositivoen el menu **Window > Scale** en el simulador.
4. Inicia tu app ejecutando `flutter run`.


### Desplegar en dispositivos iOS

Para desplegar tu app de Flutter en un dispositivo fisico de iOS, necesitaras algunas herramientas extras y una cuenta de Apple. Tambien necesitaras configurar el dispositivo fisico para desplegarlo en Xcode.


1. Instalar [homebrew](http://brew.sh/).
1. Abrir la terminar y ejecutar estos comandos para instalar las herramientas para desplegar las apps de Flutter en dispositivos iOS

{% commandline %}
brew update
brew install --HEAD libimobiledevice
brew install ideviceinstaller ios-deploy cocoapods
pod setup
{% endcommandline %}

   Si cualquiera de estos comandos falla con error, ejecuta `brew doctor` y sigue las instrucciones
   para resolver el problema.

1. Continua con el flujo de registro en Xcode para provisionar tu proyecto:
    1. Abre el espacio de trabajo por defecto en tu proyecto ejecutando `open ios/Runner.xcworkspace`  en una ventana de terminal del directorio donde esta el proyecto de Flutter.
    1. En Xcode, seleccina el proyecto `Runner` en  el panel de navegación del lado izquierdo.
    1. En la pagina de configuración de `Runner`, asegurate que tu Equipo de Desarroolo esta seleccionado debajo de **General > Signing > Team**. Cuando seleccionas un equipo, code crea y descarga un Certificado de Desarrollo, registra tu dispositivo a tu cuenta, y crea y descarga un perfil provisional (de necesitarse).
        * Para empezar tu primer proyecto de desarrollo en iOS, necesitaras regitrarte en Xcode con tu ID de Apple.<br>
        ![Agregar cuenta en Xcode](/images/setup/xcode-account.png)<br>
        Hay soporte para sesarrollo y pruebas para cualquier ID de apple. Enrrolarte en el programa de desarrolladores de Apple es necesario para distribuir tu app en el App Store. Ver la [diferencias entre los tipos de membrecias de Apple](https://developer.apple.com/support/compare-memberships).
        * La primera ocaciones que utilices un dispositivo físico para desarrollo iOS, necesitaras autorizar ambas tu Mac y tu Certificado de desarrollo en el dispositivo. Selecciona `Trust` en la ventana que te muestra la primera vez que es conectado tu dispositivo iOs a tu Mac.<br>
        ![Autorizar Mac](/images/setup/trust-computer.png)<br>
        Ahora, ve a la configuracion de la app en el dispositivo iOS, selecciona **General > Device Management**  y autoriza el Certificado.
        * Si tu registro automatico falla en Xcode, verifica que elvalor del proyecto sea único **General > Identity > Bundle Identifier**.<br>
        ![Compruebe el ID del paquete de la app](/images/setup/xcode-unique-bundle-id.png)
1. Inicia tu app ejecutando el comando `flutter run`.
