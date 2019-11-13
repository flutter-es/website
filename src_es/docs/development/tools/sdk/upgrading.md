---
title: Actualizar Flutter
short-title: Actualizar
description: Actualizar Flutter
---

No importa cual [canal de release de Flutter][] sigas,
puedes usar el comando `flutter` para actualizar tu SDK de Flutter
y los paquetes que dependen de él.


## Configura una sola vez

Para que el comando `flutter` funcione correctamente,
el fichero `pubspec.yaml` de tu app debe requerir el SDK de Flutter.
Por ejemplo, el siguiente snippet especifica que los paquetes 
`flutter` y `flutter_test` requieren el SDK de Flutter:

```yaml
name: hello_world
dependencies:
  flutter:
    sdk: flutter
dev_dependencies:
  flutter_test:
    sdk: flutter
```

{{site.alert.warning}}
No uses los comandos `pub get` o `pub upgrade` para administrar las dependencias 
de tu apps Flutter.
En su lugar, usa `flutter pub get` o `flutter pub upgrade`.
Si quieres usar pub manualmente, puedes ejecutarlo directamente configurando la 
variable de entorno `FLUTTER_ROOT`.
{{site.alert.end}}


## Actualizando el SDK de Flutter y sus paquetes

Para actualizar tanto el SDK de Flutter como sus paquetes, 
usa el comando `flutter upgrade` desde la raíz de tu aplicación 
(el mismo directorio que contiene el archivo `pubspec.yaml`):

```terminal
$ flutter upgrade
```

Este comando primero obtiene la versión más reciente del SDK de Flutter 
que esté disponible en tu canal de Flutter.
Entonces este comando actualiza cada paquete del que dependa tu app 
a la versión compatible más reciente.

Si quieres una versión aún mas reciente del SDK de Flutter, 
cambia a un canal menos estable de Flutter 
y entonces ejecuta `flutter upgrade`.

## Cambiando entre canales de Flutter

Flutter tiene [cuatro canales de release][Flutter release channel]:
**stable**, **beta**, **dev**, y **master**.
Nosotros recomendamos usar el canal **{{site.sdk.channel}}** 
a no ser que necesites un release más reciente.

Para ver el canal actual, usa el siguiente comando:

```terminal
$ flutter channel
```

Para cambiar a otro canal, usa `flutter channel <nombre-canal>`.
Una vez hayas cambiado tu canal, usa `flutter upgrade`
para descargar el SDK de Flutter y los paquetes dependientes.
Por ejemplo:

```terminal
$ flutter channel dev
$ flutter upgrade
```

{{site.alert.note}}
Si necesitas una versión específica del SDK de Flutter,
puedes descargar este desde el [Flutter SDK archive][].
{{site.alert.end}}

## Actualizar solo paquetes

Si has modificado tu fichero `pubspec.yaml` o quieres acutalizar 
solo los paquetes de los que depende tu app (en lugar de ambos, los paquetes 
y el propio Flutter), entonces usa uno de los comandos `flutter pub`.

Para obtener todas las dependencias listadas en el fichero `pubspec.yaml`,
sin actualizaciones innecesarias, usa el comando `get`:

```terminal
$ flutter pub get
```

Para actualizar a la _última versión compatibles_ de 
todas las dependencias listadas en el fichero `pubspec.yaml`,
usa el comando `upgrade`:

```terminal
$ flutter pub upgrade
```


## Mantente informado

Publicamos anuncios de cambios de última hora en nuestra 
[lista de correo][]. Te recomendamos encarecidamente que te suscribas para recibir nuestros anuncios.
¡Además, nos encantaría saber de ti!

[Flutter SDK archive]: /docs/development/tools/sdk/archive
[Flutter release channel]: {{site.github}}/flutter/flutter/wiki/Flutter-build-release-channels
[lista de correo]: {{site.groups}}/forum/#!forum/flutter-dev
