### Actualiza tu path

Se puede actualizar tu variable PATH para sólo para la sesión actual en la línea de comandos, 
como se muestra en [Obtener Flutter SDK](#get-sdk). Probablemente necesitarás 
actualizar esta variable permanentemente, de esta manera podrás ejecutar el comando `flutter` en cualquier sesión de terminal.

Los pasos para modificar esta variable permanentemente para todas las sesiones de terminal son específicas del equipo.
Típicamente se agrega una línea al archivo que se ejecuta cada que abres 
una nueva ventana. Por ejemplo:

 1. Determine el directorio donde se encuentra el SDK de Flutter. 
   Necesitaras esto en el paso 3.
 2. Abre (o crea) `$HOME/.bash_profile`. La dirección del archivo 
   puede estar en un lugar diferente en tu equipo.
 3. Agrega la siguiente línea y cambia `[PATH_TO_FLUTTER_GIT_DIRECTORY]` para ser 
   la ruta donde has clonado el repositorio de Flutter:

   ```terminal
    $ export PATH=$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin
    ```
 4. Ejecuta `source $HOME/.bash_profile` para refrescar la ventana actual. 
 5. Verifica que el directorio de `flutter/bin` esta en tu PATH ejecutando el siguiente comando:

    ```terminal
    $ echo $PATH
    ```

Para más detalles, ver [Estas preguntas en StackExchange](https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path).
