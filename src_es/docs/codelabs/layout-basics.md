---
title: "Codelab: Layout básicos en Flutter"
description: "Un codelab que usa DartPad2 para enseñar los conceptos de layout de Flutter."
toc: false
---

{{site.alert.note}}
  El editor embebido usa una versión experimental de DartPad.
  Si encuentras un bug en DartPad o tienes sugerencias para DartPad, 
  por favor [crea un DartPad 
  issue](https://github.com/dart-lang/dart-pad/issues/new) 
  haciendo click en el icono de bug en la parte superior derecha de esta página.
{{site.alert.end}}

{{site.alert.note}}
  Este codelab actualmente ha sido desarrollado y probado 
  con Chrome. Puede haber características (en el corto plazo) que 
  funcionen en unos navegadores, pero no en otros. Si encuentras alguna, por favor siéntete libre de 
  [crear un DartPad issue](https://goo.gle/flutter_web_issue),
  etiquetando el issue con `platform-web`.
{{site.alert.end}}

`Row` y `Column` son dos widgets muy importantes en el universo Flutter.
¿Quieres poner un widget `Text` con una etiqueta junto a otro widget `Text` con el valor correspondiente? Usa un `Row`.
¿Quieres presentar múltiples parejas etiquetas y valores?
Esto es un `Column` de `Row`s. Formularios con multitud de campos,
iconos al lado de opciones de menu, botones junto a barras de búsqueda, todos estos son lugares donde son usados `Row`s y `Column`s.

Este codelab te enseña como funcionan `Row`s y `Column`s.
Como estos son muy similares, una vez hayas aprendido sobre las 
`Row`s, el codelab principalmente te muestra como los mismos conceptos se aplican 
a las `Column`s. Hay editores en linea en el camino
para que puedas jugar y probar tus conocimientos.

### Empieza con un Row y algunos hijos

El objetivo de un `Row` o `Column` es contener 
otros widgets, conocidos como hijos. En un `Row`, los hijos 
son organizados horizontalmente desde el primero hasta el último de acuerdo 
con la dirección de texto. Si tu dispositivo está configurado en 
Español u otro lenguaje de escritura de izquierda a derecha, empieza por la izquierda.
Si estas usando Árabe u otro lenguaje de escritura de derecha a izquierda, empieza 
en la derecha y se añaden hacia la izquierda.

#### Ejemplo de Código

Abajo hay un widget llamado `MyWidget` que construye una única `Row`.
Prueba a añadir tres widgets `BlueBox` a su lista de hijos.

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=76e993732820ef908ea8424744b9996d&fw=true" width="100%" height="400px"></iframe>

### Tamaño del eje principal

El eje principal de un `Row` es el horizontal (para las 
`Column`s, es el eje vertical). Cada `Row` tiene una 
propiedad llamada `mainAxisSize` que determina cuanto espacio 
debe tomar a lo largo de este eje. Por defecto,
`mainAxisSize` está fijado en `MainAxisSize.max`, lo cual 
provoca que un `Row` tome todo el espacio 
horizontal disponible. Puedes usar `MainAxisSize.min` para indicar a un 
widget `Row` que tome el menor espacio posible.

#### Ejemplo de código

Aquí está el ejemplo que acaba de terminar. Prueba a fijar la propiedad `mainAxisSize` de `Row` a `MainAxisSize.min` y observa lo que ocurre.

<iframe src="{{site.custom.dartpad.embed-flutter-prefix}}?id=009a77697460e7ec6a3c142f0dfb1b5e&theme=dark&split=60&ga_id=column" width="100%" height="400px"></iframe>

### Alineación en el eje principal

Si has fijado el `mainAxisSize` de un `Row` al mínimo,
no habrá ningún espacio adicional que los hijos puedan usar.
Si lo has fijado en `max`, sin embargo, el `Row` puede tener algún espacio adicional que usar. 
Puedes usar la propiedad `mainAxisAlignment` para controlar como el `Row` alinea sus hijos entre 
este espacio.

Hay seis valores diferentes disponibles en el 
enum `MainAxisAlignment`:

* `MainAxisAligment.start`<br>
   Coloca todos los hijos tan cerca del inicio del 
   `Row` como sea posible
   (para filas izquierda-a-derecha, este es el lado izquierdo).

* `MainAxisAligment.end`<br>
  Coloca todos lo hijos tan cerca del final del `Row` 
  como sea posible.

* `MainAxisAligment.center`<br>
  Agrupa los hijos en el centro del `Row`.

* `MainAxisAligment.spaceBetween`<br>
  Cualquier espacio extra es divido en partes iguales 
  y usado para hacer separaciones entre los hijos.

* `MainAxisAligment.spaceEvenly`<br>
  Parecido a `spaceBetween`, excepto que cuenta el espacio 
  antes del primer hijo y despues del último 
  también como separaciones.

* `MainAxisAligment.spaceAround`<br>
  Parecido a `spaceEvenly`, solo que en la primera y última separación solo 
  toma el 50% de la cantidad de espacio usada entre los hijos.

#### Ejemplo de código

El `Row` de abajo tiene su `mainAxisAlignment` fijado a 
start. Prueba a cambiarlo a los otros valores 
y volver a ejecutar el código para ver como las 
cosas se mueven.

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=0c97de625a9aa5c3194f9eecbd73ec1a&fw=true" width="100%" height="400px"></iframe>

### Alineación en el eje tranversal

El eje transversal para los widgets `Row` es el eje vertical, 
y puedes usar la propiedad `crossAxisAlignment` 
para controlar como los hijos son posicionados verticalmente.
El valro por defecto es `CrossAxisAlignment.center`,
pero hay cinco opciones en total:

* `CrossAxisAlignment.start`<br>
  Los hijos son alineados al inicio del espacio 
  vertical del `Row`
  (por defecto, la parte superior se considera 
  el inicio,
  sin embargo puedes cambiar esto con la propiedad 
  `verticalDirection`).

* `CrossAxisAlignment.end`<br>
  Los hijos son alineados al final del espacio vertical 
  del `Row` (por defecto, esto significa la parte de abajo).

* `CrossAxisAlignment.center`<br>
  Los hijos son centrados respecto al eje vertical.

* `CrossAxisAlignment.stretch`<br>
  Los hijos son forzados a tener la misma altura que el 
  `Row`, rellenado todo el espacio vertical.

* `CrossAxisAlignment.baseline`<br>
  Los hijos son alineados por sus lineas base (se explica más adelante).

#### Ejemplo de código

Este `Row` tiene dos hijos pequeños y uno más grande. Su 
propiedad `crossAxisAlignment` esta fijada a center, el valor por defecto.
Pruebas a cambiarlo a los otros valores y re-ejecuta el 
código para ver como las cosas se mueven.

Advertencia: `CrossAxisAlignment.baseline` requiere
que otra propiedad sea fijada también, verás 
un error si lo intentas.
No te preocupes, esto se verá en la siguiente sección.

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=610aa31bbd09c90b5cede790bb6c3854&fw=true" width="100%" height="400px"></iframe>

### Alineación con linea base

Algunas veces es práctico alinear widgets que 
contienen texto no por sus límites generales, 
sino por la linea base usada por sus carácteres.
Esto es lo que hace `CrossAxisAlignment.baseline`. Puedes 
usar esto en combinación con la propiedad `textBaseline` de `Row` (que indica que linea base usar) para alinear 
los hijos del `Row` a lo largo de sus lineas base.

Si fijas la propiedad `crossAxisAlignment` de `Row` 
a baseline sin fijar `textBaseline` al mismo tiempo, 
tus widgets fallarán al construirse.

#### Ejemplo de código

Este `Row` contiene tres widgets `Text` con diferentes tamaños de fuente. Prueba a cambiar la propiedad 
 `crossAxisAlignment` a `baseline`, y experimenta con los 
 diferentes valores para `textBaseline` también (hay un enum llamado `TextBaseline` que contiene los valores 
 validos para baseline).

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=8c4a0571b161755c8d9235df947d268e&fw=true" width="100%" height="400px"></iframe>

### Hijos flexibles

Hasta aquí, todos los widgets hijos usados en los ejemplos 
han tenido un tamaño fijo. Sin embargo, es posible, 
para un `Row` tener hijos flexibles,
que se adapten al espacio disponible. Para entender 
como funciona esto, es mejor echar un vistazo a 
como un `Row` se dimensiona a si mismo y a sus hijos:

1. Primero, el `Row` pregunta a todos sus hijos con tamaño 
   fijo como de grandes les gustaría ser.
1. A continuación, calcula el espacio restante en su 
   eje principal (horizontal).
1. Entonces divide este espacio restante entre sus hijos 
   flexibles de acuerdo a sus factores flex.
   Los hijos flexibles pueden usar algo o todo el espacio disponible que se les ofrece.
1. En este punto, el `Row` conoce de granes son todos sus 
   hijos, y puede alinearlos usando las propiedades de 
   tamaño del eje y alineación que viste anteriormente.

La mayoría de los widgets son considerados para tener 
un tamaño fijo.
Puedes cambiar esto envolviéndolos en un widget `Flexible`. 
Los `Flexibles` tiene dos propiedades importantes:
un factor `flex` que determina cuanto del espacio disponible debe tomar 
en comparación con los otros `Flexibles`, 
y una propiedad `fit` que determina si su hijo se ve 
forzado a tomar todo el espacio extra que se le ofrece.

#### Ejemplo de código

Prueba a envolver la caja central en este `Row` 
con un widget `Flexible` que tenga un factor `flex` de 1 
y una propiedad `fit` fijada en `FlexFit.loose`. 
Después, prueba a cambiar la propiedad fit a tight y observa lo que ocurre.

Esta combinación (un factor `flex` de 1 y un `fit` tight)
es muy popular, hay un widget específico para facilitar su uso: `Expanded`.

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=c7ba00c50151ab2e5c0c2194686fef93&fw=true" width="100%" height="400px"></iframe>

### Factores Flex

Si más de un hijo de un `Row` o `Column` tiene un 
tamaño flexible, el espacio disponible se le asigna de acuerdo a sus 
factores `flex`. Cada hijo toma espacio en proporción 
a su factor flex, dividido por el total los factores 
flex de todos los hijos:

<!-- skip -->
```dart
remainingSpace * (flex / totalOfAllFlexValues)
```

Por ejemplo, si hay dos hijos con factor flex de 1,
cada uno toma la mitad del espacio disponible. Si tiene 
dos hijos con factor flex de 1 y otro hijo con factor flex de 2, 
los dos primeros hijos toman cada uno un cuarto del espacio disponible, y el otro hijo toma la mitad.

#### Ejemplo de código

En este ejemplo, los tres hijos del `Row` son `Flexible`.
Prueba a cambiar sus valores `flex` y 
re-ejecuta el código para ver como el tamaño de los widgets se ajusta.

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=4ab5409b566272c8f2cd28feddb0a995&fw=true" width="100%" height="400px"></iframe>

### ¿Qué ocurre si te quedas sin espacio?

Como acabas de ver, cuando un `Row` pregunta a uno de sus hijos `Flexible`
como de grande quiere ser, le da al hijo el tamaño 
máximo basado en su factor `flex`. Sin embargo, 
los hijos de tamaño fijo, no tienen esta restricción. 
Esto es para que pueden determinar su propio tamaño intrínseco.

Un efecto secundario de esto es que no hay nada 
que impida a un hijo de tamaño fijo declararse a sí mismo 
para ser mayor de lo que el `Row` puede soportar.
Cuando esto ocurre, ocurre un desbordamiento. Puedes 
corregir esto cambiando el widget hijo para que tenga 
un tamaño menor, o usando un widget de scroll.

#### Ejemplo de código

El `Row` siguiente contiene un único hijo que es demasiado 
ancho para ajustarse. Ejecuta el código como está para 
ver lo que ocurre, entonces prueba a modificar el 
ancho del `Container` para hacer que se ajuste.

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=5a59d93119dc5b6eb1725235fde137cf&fw=true" width="100%" height="400px"></iframe>

### Prueba a usar SizedBox para hacer espacio

Si necesitas una cantidad específica de espacio entre dos hijos 
de un `Row`, una manera fácil de hacerlo es pegar un 
`SizedBox` del ancho apropiado entre ellos.

#### Ejemplo de código

Prueba a hacer algo de espacio entre esta lista de dos items colocando un 
`SizedBox` con un `width` de 100 entre ellos.

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=0c3e1ce8177a2f0cc8e2275d5260b348&fw=true" width="100%" height="400px"></iframe>

### Los Spacers se expande para hacer espacio

Los `Spacers` son otra manera conveniente para crear espacio entre los items en un `Row`. 
Estos son flexibles, y se expanden para rellenar cualquier espacio sobrante.

#### Ejemplo de código

Prueba a añadir un `Spacer` entre el primer y el segundo hijo del 
`Row` aquí abajo.

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=dd68c1eb491e7a22a2ceb4127d78e504&fw=true" width="100%" height="400px"></iframe>

### Espera, ¿no iba aprender también sobre Columns?

Sorpresa, ¡ya lo tienes! `Row`s y `Column`s hacen el 
mismo trabajo, solo que en dimensiones diferentes. El eje 
principal de un `Row` es horizontal, y el eje principal de un 
`Column` es vertical, pero ámbos dimensionan y posicionan 
sus hijos de la misma manera. Comparten una clase base,
`Flex`, por tanto todo lo que has aprendido sobre los  `Row` 
es aplicable también a los `Column`.

#### Ejemplo de código

Aquí hay un `Column` con algunos hijos de varios tamaños y 
con sus propiedades más importantes configuradas. 
Intenta juguetear con ellos y verás que 
`Column` funciona como un `Row` vertical.

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=6cafe7beab954e72fed2fd2393a29f6c&fw=true" width="100%" height="400px"></iframe>

### Poniéndolo todo junto

Ahora que estas versado en los `Row`, los `Column`, y las 
propiedades importantes de ambos, estas preparado para practicar 
poniéndolo todo junto para construir interfaces. 
Los siguientes ejemplos te guían para construir y 
mostrar una tarjeta de empresa.

#### Ejemplo de código

Cada tarjeta de empresa necesita un nombre y un título, por tanto empieza con esto.

* Añade un widget `Column`
* Añade dos widget de texto a la lista de hijos del 
  `Column`:
  * El primero debe ser un nombre (una corta es más fácil 
    de encajar en una ventana pequeña) y usa el estilo 
    `headline`:

<!-- skip -->
```dart
style: Theme.of(context).textTheme.headline<br>
```

  * El segundo widget de texto debe decir `Experienced App Developer`
    y usa el estilo por defecto (obvia totalmente la propiedad `style`).

* Fija el `crossAxisAlignment` del `Column` a start, por    esto los widgets de texto son alineados al 
  inicio mejor que centrados.

* Fija el `mainAxisSize` del `Column` a `MainAxisSize.min`,
  con esto la tarjeta no se expandirá hasta el alto total de la ventana.

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=5e7e9352bca878f446d4347f324e2f63&fw=true&split=60" width="100%" height="800px"></iframe>

Las tarjetas de empresa a menudo tienen un icono o logo en la esquina superior izquierda,
entonces el siguiente paso es añadir una por ti. Empieza con envolver el 
`Column` que creaste con un widget `Row`:

<!-- skip -->
```dart
Row(
  children: [
    Column( … ), // <- Este debe ser el Column que creaste en el paso previo
  ],
);
```

Ahora puedes añadir el `Icon`:

* Encime de tu `Column` en la lista de hijos del `Row`,
  añade un widget `Padding`.
  * Fija este `padding` a `const EdgeInsets.all(8)`.
  * Para el hijo del widget `Padding`, usa un `Icon`.
    * Puedes usar el recurso de icono que quieras, pero  `Icons.account_circle`
      funciona bien.
    * Fija el `size` del `Icon` a 50.

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=684e599476eef2ec4b4508e6b2186c03&fw=true&split=60" width="100%" height="800px"></iframe>

¡Tu primera `Row` esta ahora completa! Aún hay dos cosas más que hacer, 
y necesitas un `Column` para ponerlas en él.
Envuelve tu `Row` con un widget `Column` para que se vea así:

<!-- skip -->
```dart
 Column(
   children: [
     Row( … ), // <- Este debe ser el Row con tu Icon y los widgets Text.
   ],
 );
```

Entonces, finaliza tu nuevo `Column` con estos pasos:

* Fija el `mainAxisSize` del `Column` a min
  * ¡De otro modo este se expandirá para rellenar toda la pantalla!

* Fija el `crossAxisAlignment` del `Column` a stretch
  * Esto hace a todos sus hijos ocupar todo el ancho.

* Añade los hijos de abajo a tu `Row` en la lista de 
  hijos del `Column`:
  * Un `SizedBox` con un alto de 8
    * Un `Row` vacio (sin hijos ni otras propiedades)
    * Un `SizedBox` con un alto de 16
    * Otro `Row` vacio

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=19ead6db4f42ce112fc0a7d2e0922466&fw=true&split=60" width="100%" height="800px"></iframe>

Aunque quedan unos pocos pasos para seguir. A continuación la segunda fila.
Añade lo siguiente a su lista de hijos:

* Un widget `Text` con una dirección como '123 Main Street'
* Un widget `Text` con un número de telefono como '800-123-1234'

Si ejecutas el código en este punto, verás que los
dos widgets `Text` son ubicados uno contra otro en lugar de en 
los extremos opuestos de la fila del `Row`, lo cual no es correcto.
Puedes arreglar esto fijando la propiedad `mainAxisAlignment` del `Row` a `spaceBetween`, que 
pone algo de espacio extra entre los dos widgets `Text`.

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=e6e07bbe96255b762163cf3e40906944&fw=true&split=60" width="100%" height="800px"></iframe>

El último paso es colocar estos iconos en su lugar 
en la parte de abajo de la tarjeta:

* Añade cuatro widgets `Icon` a la lista de hijos del 
  último `Row` children. Puedes usar cualquier recurso de icono que te guste, 
  pero esta sería una buena manera de mostrar que su desarrollador 
  imaginario se en enfoca en accesibilidad,
  desarrollo rápido, y apps multiplataforma:
  * `Icons.accessibility`
  * `Icons.timer`
  * `Icons.phone_android`
  * `Icons.phone_iphone`

* Fija la propiedad `mainAxisAlignment` del `Row` a
  `MainAxisAlignment.spaceAround`

<iframe src="https://dartpad.dev/experimental/embed-new-flutter.html?id=2234a5ccada200eb1e018b12fa95d57d&fw=true&split=60" width="100%" height="800px"></iframe>
