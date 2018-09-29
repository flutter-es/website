---
layout: page
title: Actualiza tu instalación de Flutter
permalink: /upgrading/
---

Recomendamos encarecidamente el seguimiento de la rama `beta` en el repositorio de flutter, que es donde impulsamos 'buenos desarrollos conocidos' de Flutter. Si necesitas ver los últimos cambios, puedes seguir la rama `master`, pero ten en cuenta que aquí es donde hacemos nuestro desarrollo diario, por lo que la estabilidad es mucho menor.

Para ver tu rama actual, usa `flutter channel`.

Para cambiar de rama, utiliza `flutter channel beta` / `flutter channel master`.

## Especificando el SDK de Flutter para tu proyecto

Se especifican las dependencias del SDK de Flutter en el archivo `pubspec.yaml`. Por ejemplo, el siguiente fragmento especifica que los paquetes `flutter` y `flutter_test` utilizan el SDK de Flutter.

```
name: hello_world
dependencies:
  flutter:
    sdk: flutter
dev_dependencies:
  flutter_test:
    sdk: flutter
```

La línea `sdk: flutter` indica a la herramienta de línea de comandos de `flutter` que busque el paquete correcto para ti.

No uses los comandos `pub get` o `pub upgrade` para gestionar tus dependencias. En su lugar, usa los paquetes `flutter get` o `flutter packages upgrade`. Si quieres usar pub manualmente, puedes ejecutarlo directamente configurando la variable de entorno 
`FLUTTER_ROOT`.

## Actualizando Flutter channel y sus paquetes

Para actualizar tanto el SDK de Flutter como sus paquetes, usa el comando `flutter upgrade` desde la raíz de tu aplicación (el mismo directorio que contiene el archivo `pubspec.yaml`):

```
$ flutter upgrade
```

## Actualizando tus paquetes

Si has modificado tu archivo `pubspec.yaml`, o sólo quieres actualizar los paquetes de los que depende tu aplicación en lugar del propio Flutter y sus paquetes, entonces usa los siguientes comandos:
* `flutter packages get` para obtener todas las dependencias listadas en el archivo 
`pubspec.yaml`, o
* `flutter packages upgrade` para obtener las últimas versiones de todas las dependencias listadas en el archivo `pubspec.yaml`

Publicamos anuncios de cambios de última hora en nuestra 
[lista de correo](https://groups.google.com/forum/#!forum/flutter-dev). Te recomendamos encarecidamente que te suscribas para recibir nuestros anuncios.
¡Además, nos encantaría saber de ti!
