---
layout: page
title: "Crear y dar estilo a un campo de texto"
permalink: /cookbook/forms/text-input/
---

Los campos de texto permiten a los usuarios escribir texto en nuestras aplicaciones. Los campos de texto se pueden usar para crear formularios, aplicaciones de mensajería, experiencias de búsqueda ¡y más! En esta receta, exploraremos cómo crear y diseñar campos de texto.

Flutter proporciona dos campos de texto: [`TextField`](https://docs.flutter.io/flutter/material/TextField-class.html)
y [`TextFormField`](https://docs.flutter.io/flutter/material/TextFormField-class.html).

## `TextField`

[`TextField`](https://docs.flutter.io/flutter/material/TextField-class.html)
es el widget de entrada de texto más comúnmente utilizado.

Por defecto, un `TextField` está decorado con un subrayado. Podemos agregar una etiqueta, un icono, un hint de texto en línea, y un texto de error al suministrar un
[`InputDecoration`](https://docs.flutter.io/flutter/material/InputDecoration-class.html)
como la propiedad [`decoration`](https://docs.flutter.io/flutter/material/TextField/decoration.html) del `TextField`. Para eliminar por completo la decoración (incluido el subrayado y el espacio reservado para la etiqueta), configure la `decoration` como nula 
explícitamente.

<!-- skip -->
```dart
TextField(
  decoration: InputDecoration(
    border: InputBorder.none,
    hintText: 'Please enter a search term'
  ),
);
```

## `TextFormField`

[`TextFormField`](https://docs.flutter.io/flutter/material/TextFormField-class.html)
envuelve un `TextField` y lo integra con el 
[`Form`](https://docs.flutter.io/flutter/widgets/Form-class.html) adjunto. Esto proporciona una funcionalidad adicional, como la validación y la integración con otros widgets [`FormField`](https://docs.flutter.io/flutter/widgets/FormField-class.html).

<!-- skip -->
```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Enter your username'
  ),
);
```

Para obtener más información sobre la validación de entrada, por favor consulta la receta 
[Construyendo un formulario con validaciones](/cookbook/forms/validation/).
