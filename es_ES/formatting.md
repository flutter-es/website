---
layout: page
title: Formateando el código Flutter

permalink: /formatting/
---

* TOC Placeholder
{:toc}

## Formateando código automáticamente

Aunque el código puede ajustarse a cualquier estilo preferido - en nuestra experiencia - los equipos de desarrolladores pueden encontrar más productivo:

1. Tener un estilo único y compartido.

1. Forzar este estilo a través del formateo automático.

La alternativa es a menudo agotadores debates de formato durante las revisiones de código, donde el tiempo puede ser mejor invertido en el funcionamiento del código en lugar de en el estilo de código.

### Formateando código automáticamente en Android Studio e IntelliJ

Instala el plugin `Dart` (consulta [Configuración del Editor](/get-started/editor/))
para obtener un formateo automático del código en Android Studio e IntelliJ.

Para formatear automáticamente el código en la ventana de código fuente actual, haz clic con el botón derecho del ratón en la ventana de código y selecciona `Reformatear Código con dartfmt`. Puedes agregar un shortcut de teclado en la sección Keymap de las Preferencias de IntelliJ.

### Formateando código automáticamente en VS Code

Instala la extensión `Flutter` (consulta [Configuración del Editor](/get-started/editor/))
para obtener el formateo automático del código en VS Code.

Para formatear automáticamente el código en la ventana de código fuente actual, haz clic con el botón derecho del ratón en la ventana de código y selecciona `Formatear documento`. Puedes agregar un shortcut de teclado en Preferencias de VS Code.

Para formatear automáticamente el código cada vez que guarde un archivo, establece la opción 
`editor.formatOnSave` en `true`.

### Formateando código automáticamente con el comando `flutter`

También puedes formatear automáticamente el código en la interfaz de la línea de comando (CLI) usando el comando `flutter format`:

```
Uso: flutter format <uno o más paths>
-h, --help    Imprimir esta información de uso.
```

### Usando 'trailing commas'

El código Flutter a menudo implica la construcción de estructuras de datos en forma de árbol bastante profundas, por ejemplo, en un método `build`. Para obtener un buen formateo automático, te recomendamos que adoptes las *trailing commas* opcionales. La guía para añadir una coma final es simple: Agrega siempre una coma al final de la lista de parámetros en funciones, métodos y constructores donde te preocupes por mantener el formato que hiciste a mano. Esto ayudará al formateador automático a insertar una cantidad apropiada de saltos de línea hacia un estilo de código Flutter.

Aquí hay un ejemplo de código formateado automáticamente *con* comas al final:

![Formateando código automáticamente con comas al final](/images/intellij/trailing-comma-with.png)

Y el mismo código para código formateado automáticamente *sin* comas al final:

![Código formateado automáticamente <s></s>in comas al final](/images/intellij/trailing-comma-without.png)
