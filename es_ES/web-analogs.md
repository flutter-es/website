---
layout: page
title: Flutter para Desarrolladores Web (HTML/CSS) 
permalink: /web-analogs/
---

<link rel="stylesheet" href="/css/two_column.css">

Contents:
* TOC Placeholder
{:toc}

<div class="begin-examples"></div>
Esta página es para usuarios familiarizados con la sintaxis HTML y CSS para la organización de componentes de UI de una aplicación. Esta contrasta ejemplos de código en HTML/CSS con su código equivalente en Flutter/Dart.

Este ejemplo asume:


* El documento HTML inicia con `<!DOCTYPE html>`, y el modelo de caja CSS se establece para todos los elementos HTML en [`border-box`](https://css-tricks.com/box-sizing/), para obtener consistencia con el modelo de Flutter.

  ```css
  {
    box-sizing: border-box;
  }
  ```
* En Flutter, el estilo predeterminado del texto "Lorem ipsum" se define mediante la variable `bold24Roboto` de la siguiente manera, para mantener la sintaxis simple: 

  ```dart
  TextStyle bold24Roboto = TextStyle(
    color: Colors.white,
    fontSize: 24.0,
    fontWeight: FontWeight.w900,
  );
  ```

## Realizando operaciones básicas de diseño

Los siguientes ejemplos muestran cómo realizar las tareas más comunes de diseño de IU.

### Estilos y alineación de texto

El estilo de fuente, tamaño y otros atributos del texto que CSS controla con la propiedad font y color son propiedades individuales de un [TextStyle](https://docs.flutter.io/flutter/painting/TextStyle-class.html) elemento secundario de un widget [Text](https://docs.flutter.io/flutter/widgets/Text-class.html)


Tanto en HTML como en Flutter, los elementos secundarios o widgets están anclados en la parte superior izquierda, por defecto.

<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
    Lorem ipsum
</div>

.greybox {
      background-color: #e0e0e0; /* grey 300 */
      width: 320px;
      height: 240px;
[[highlight]]      font: 900 24px Georgia;[[/highlight]]
    }
{% endprettify %}
</div>
<div class="righthighlight">
{% prettify dart %}
  var container = Container( // grey box
    child: Text(
      "Lorem ipsum",
      style: [[highlight]]TextStyle(
        fontSize: 24.0
        fontWeight: FontWeight.w900,
        fontFamily: "Georgia",
      ),[[/highlight]]
    ),
    width: 320.0,
    height: 240.0,
    color: Colors.grey[300],
  );
{% endprettify %}
</div>

### Ajuste del color de fondo

En Flutter, se establece el color de fondo utilizando la propiedad `decoration` de un [Container](https://docs.flutter.io/flutter/widgets/Container-class.html)’.


Los ejemplos CSS utilizan los colores equivalentes en hexadecimal de la Material color palette.
<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  Lorem ipsum
</div>

.greybox {
[[highlight]]      background-color: #e0e0e0; [[/highlight]] /* grey 300 */
      width: 320px;
      height: 240px;
      font: 900 24px Roboto;
    }
{% endprettify %}
</div>

<div class="righthighlight">
{% prettify dart %}
  var container = Container( // grey box
    child: Text(
      "Lorem ipsum",
      style: bold24Roboto,
    ),
    width: 320.0,
    height: 240.0,
[[highlight]]    color: Colors.grey[300],[[/highlight]]
  );
{% endprettify %}
</div>

### Centrar componentes

Un widget [Center](https://docs.flutter.io/flutter/widgets/Center-class.html) centra a su elemento interno tanto horizontal como verticalmente.

Para lograr un efecto similar en CSS, el elemento primario utiliza un comportamiento de visualización table-cell o flex. Los ejemplos de esta página muestran el comportamiento de Flex.


<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  Lorem ipsum
</div>

.greybox {
  background-color: #e0e0e0; /* grey 300 */
  width: 320px;
  height: 240px;
  font: 900 24px Roboto;
[[highlight]]  display: flex;
  align-items: center;
  justify-content: center; [[/highlight]]
}
{% endprettify %}
</div>

<div class="righthighlight">
{% prettify dart %}
var container = Container( // grey box
  child: [[highlight]] Center(
    child: [[/highlight]] Text(
      "Lorem ipsum",
      style: bold24Roboto,
    ),
  ),
  width: 320.0,
  height: 240.0,
  color: Colors.grey[300],
);
{% endprettify %}
</div>

### Configuración del ancho del contendor

Para especificar el ancho de un widget [Container](https://docs.flutter.io/flutter/widgets/Container-class.html), utiliza su propiedad `width`. Este es un ancho fijo, a diferencia de la propiedad CSS Max-width que ajusta el ancho del contenedor hasta un valor máximo.
Para imitar ese efecto Flutter, usa las propiedades `constraints` del Container.

Crea un nuevo widget [BoxConstraints](https://docs.flutter.io/flutter/rendering/BoxConstraints-class.html) con un `minWidth` o `maxWidth`.

En el caso de los contenedores anidados, si el ancho de los padres es menor que el ancho del hijo, el Contenedor hijo se dimensiona a sí mismo para que coincida con el padre.

<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  <div class="redbox">
    Lorem ipsum
  </div>
</div>

.greybox {
  background-color: #e0e0e0; /* grey 300 */
[[highlight]]  width: 320px; [[/highlight]]
  height: 240px;
  font: 900 24px Roboto;
  display: flex;
  align-items: center;
  justify-content: center;
}
.redbox {
  background-color: #ef5350; /* red 400 */
  padding: 16px;
  color: #ffffff;
[[highlight]]    width: 100%;
  max-width: 240px; [[/highlight]]
}
{% endprettify %}
</div>

<div class="righthighlight">
{% prettify dart %}
var container = Container( // grey box
  child: Center(
    child: Container( // red box
      child: Text(
        "Lorem ipsum",
        style: bold24Roboto,
      ),
      decoration: BoxDecoration(
        color: Colors.red[400],
      ),
      padding: EdgeInsets.all(16.0),
[[highlight]]      width: 240.0, [[/highlight]]//max-width is 240.0
    ),
  ),
[[highlight]]  width: 320.0, [[/highlight]]
  height: 240.0,
  color: Colors.grey[300],
);
{% endprettify %}
</div>

## Manipulando posición y tamaño

En los ejemplos siguientes se muestra cómo realizar operaciones más complejas en la posición, el tamaño y el fondo del widget.

### Configuración de posición absoluta

De forma predeterminada, los widgets son posicionados de forma relativa a su padre.


Para especificar una posición absoluta para un widget como coordenadas x-y, anídelo en un widget [Positioned](https://docs.flutter.io/flutter/widgets/Positioned-class.html) que, a su vez, está anidado en un widget [Stack](https://docs.flutter.io/flutter/widgets/Stack-class.html).


<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  <div class="redbox">
    Lorem ipsum
  </div>
</div>

.greybox {
  background-color: #e0e0e0; /* grey 300 */
  width: 320px;
  height: 240px;
  font: 900 24px Roboto;
[[highlight]]  position: relative; [[/highlight]]
}
.redbox {
  background-color: #ef5350; /* red 400 */
  padding: 16px;
  color: #ffffff;
[[highlight]]  position: absolute;
  top: 24px;
  left: 24px; [[/highlight]]
}
{% endprettify %}
</div>

<div class="righthighlight">
{% prettify dart %}
var container = Container( // grey box
[[highlight]]  child: Stack(
    children: [
      Positioned( // red box
        child: [[/highlight]] Container(
          child: Text(
            "Lorem ipsum",
            style: bold24Roboto,
          ),
          decoration: BoxDecoration(
            color: Colors.red[400],
          ),
          padding: EdgeInsets.all(16.0),
        ),
[[highlight]]        left: 24.0,
        top: 24.0,
      ),
    ],
  ), [[/highlight]]
  width: 320.0,
  height: 240.0,
  color: Colors.grey[300],
);
{% endprettify %}
</div>

### Girando componentes


Para rotar un widget, anídalo en un widget [Transform](https://docs.flutter.io/flutter/widgets/Transform-class.html). Utiliza las propiedades `alignment` y `origin` del widget de transformación para especificar el origen de la transformación (Fulcrum) en términos relativos y absolutos, respectivamente.

Para una rotación 2D simple, el widget se gira en el eje Z utilizando radianes.
(grados × π/180)

<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  <div class="redbox">
    Lorem ipsum
  </div>
</div>

.greybox {
  background-color: #e0e0e0; /* grey 300 */
  width: 320px;
  height: 240px;
  font: 900 24px Roboto;
  display: flex;
  align-items: center;
  justify-content: center;
}
.redbox {
  background-color: #ef5350; /* red 400 */
  padding: 16px;
  color: #ffffff;
[[highlight]]  transform: rotate(15deg); [[/highlight]]
}
{% endprettify %}
</div>

<div class="righthighlight">
{% prettify dart %}
var container = Container( // gray box
  child: Center(
    child: [[highlight]] Transform(
      child: [[/highlight]] Container( // red box
        child: Text(
          "Lorem ipsum",
          style: bold24Roboto,
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
          color: Colors.red[400],
        ),
        padding: EdgeInsets.all(16.0),
      ),
[[highlight]]      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateZ(15 * 3.1415927 / 180),
    ), [[/highlight]]
  ),
  width: 320.0,
  height: 240.0,
  color: Colors.grey[300],
);
{% endprettify %}
</div>
 
### Escalando componentes

Para escalar un widget arriba o abajo, anidarlo en un widget [Transform](https://docs.flutter.io/flutter/widgets/Transform-class.html). Use las propiedades `alignment` y `origin` del widget Transform para especificar el origen (fulcrum) de la transformación en términos relativos o absolutos respectivamente.

Para una operacion de escalamiento simple a lo largo del eje x crea un nuevo objeto de identidad [Matrix4](https://docs.flutter.io/flutter/vector_math_64/Matrix4-class.html) y utilice su método scale() para especificar el factor de escala.

Cuando se escala un widget primario, los widgets secundarios se escalan en consecuencia.
<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  <div class="redbox">
    Lorem ipsum
  </div>
</div>

.greybox {
  background-color: #e0e0e0; /* grey 300 */
  width: 320px;
  height: 240px;
  font: 900 24px Roboto;
  display: flex;
  align-items: center;
  justify-content: center;
}
.redbox {
  background-color: #ef5350; /* red 400 */
  padding: 16px;
  color: #ffffff;
[[highlight]]  transform: scale(1.5); [[/highlight]]
}
{% endprettify %}
</div>

<div class="righthighlight">
{% prettify dart %}
var container = Container( // gray box
  child: Center(
    child: [[highlight]] Transform(
      child: [[/highlight]] Container( // red box
        child: Text(
          "Lorem ipsum",
          style: bold24Roboto,
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
          color: Colors.red[400],
        ),
        padding: EdgeInsets.all(16.0),
      ),
[[highlight]]      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..scale(1.5),
     ), [[/highlight]]
  width: 320.0,
  height: 240.0,
  color: Colors.grey[300],
);
{% endprettify %}
</div>

### Aplicando linear gradient

Para aplicar linear gradient a un background de un widget, anidarlo en un widget [Container](https://docs.flutter.io/flutter/widgets/Container-class.html)
Entonces use la propiedad `decoration` del widget Container crea un objeto [BoxDecoration](https://docs.flutter.io/flutter/painting/BoxDecoration-class.html), y usa la propiedad `gradient` de BoxDecoration para transformar el relleno del background.
 
El "ángulo" del gradient se basa en los valores de alineación (x, y):

* Si los valores de "x" iniciales y finales son iguales, el gradiente es vertical (0° | 180°).
* Si los valores de "y" iniciales y finales son iguales, el gradiente es horizontal (90° | 270°).

#### Vertical gradient

<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  <div class="redbox">
    Lorem ipsum
  </div>
</div>

.greybox {
  background-color: #e0e0e0; /* grey 300 */
  width: 320px;
  height: 240px;
  font: 900 24px Roboto;
  display: flex;
  align-items: center;
  justify-content: center;
}
.redbox {
  padding: 16px;
  color: #ffffff;
[[highlight]]  background: linear-gradient(180deg, #ef5350, rgba(0, 0, 0, 0) 80%); [[/highlight]]
}
{% endprettify %}
</div>
<div class="righthighlight">
{% prettify dart %}
var container = Container( // grey box
  child: Center(
    child: Container( // red box
      child: Text(
        "Lorem ipsum",
        style: bold24Roboto,
      ),
[[highlight]]      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.0, -1.0),
          end: const Alignment(0.0, 0.6),
          colors: <Color>[
            const Color(0xffef5350),
            const Color(0x00ef5350)
          ],
        ),
      ), [[/highlight]]
      padding: EdgeInsets.all(16.0),
    ),
  ),
  width: 320.0,
  height: 240.0,
  color: Colors.grey[300],
);
{% endprettify %}
</div>

#### Horizontal gradient
<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  <div class="redbox">
    Lorem ipsum
  </div>
</div>

.greybox {
  background-color: #e0e0e0; /* grey 300 */
  width: 320px;
  height: 240px;
  font: 900 24px Roboto;
  display: flex;
  align-items: center;
  justify-content: center;
}
.redbox {
  padding: 16px;
  color: #ffffff;
[[highlight]]  background: linear-gradient(90deg, #ef5350, rgba(0, 0, 0, 0) 80%); [[/highlight]]
}
{% endprettify %}
</div>
<div class="righthighlight">
{% prettify dart %}
var container = Container( // grey box
  child: Center(
    child: Container( // red box
      child: Text(
        "Lorem ipsum",
        style: bold24Roboto,
      ),
[[highlight]]      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-1.0, 0.0),
          end: const Alignment(0.6, 0.0),
          colors: <Color>[
            const Color(0xffef5350),
            const Color(0x00ef5350)
          ],
        ),
      ), [[/highlight]]
      padding: EdgeInsets.all(16.0),
    ),
  ),
  width: 320.0,
  height: 240.0,
  color: Colors.grey[300],
);
{% endprettify %}
</div>

## Manipulando Shapes

Los siguientes ejemplos muestran cómo crear y personalizar formas.

### Redondeo de esquinas

Para redondear esquinas de un shape, use la propiedad `borderRadius` de un objeto [BoxDecoration](https://docs.flutter.io/flutter/painting/BoxDecoration-class.html). Crea un objeto [BorderRadius](https://docs.flutter.io/flutter/painting/BorderRadius-class.html) que especifica los radios para redondear cada esquina.

<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  <div class="redbox">
    Lorem ipsum
  </div>
</div>

.greybox {
  background-color: #e0e0e0; /* gray 300 */
  width: 320px;
  height: 240px;
  font: 900 24px Roboto;
  display: flex;
  align-items: center;
  justify-content: center;
}
.redbox {
  background-color: #ef5350; /* red 400 */
  padding: 16px;
  color: #ffffff;
[[highlight]]  border-radius: 8px; [[/highlight]]
}
{% endprettify %}
</div>
<div class="righthighlight">
{% prettify dart %}
var container = Container( // grey box
  child: Center(
    child: Container( // red circle
      child: Text(
        "Lorem ipsum",
        style: bold24Roboto,
      ),
      decoration: BoxDecoration(
        color: Colors.red[400],
[[highlight]]        borderRadius: BorderRadius.all(
          const Radius.circular(8.0),
        ), [[/highlight]]
      ),
      padding: EdgeInsets.all(16.0),
    ),
  ),
  width: 320.0,
  height: 240.0,
  color: Colors.grey[300],
);
{% endprettify %}
</div>

### Agregando sombras a las cajas

En CSS puedes especificar el desplazamiento de las sombras y la difuminación de forma abreviada usando la propiedad box-shadow. Este ejemplo muestra dos sombras de caja, con las propiedades:


*  `xOffset: 0px, yOffset: 2px, blur: 4px, color: black @80% alpha`
*  `xOffset: 0px, yOffset: 06x, blur: 20px, color: black @50% alpha`


En Flutter, cada propiedad y valor es especificado separadamente. Use la propiedad `boxShadow` de BoxDecoration para crear una lista de [BoxShadow](https://docs.flutter.io/flutter/painting/BoxShadow-class.html) widgets. Puedes definir uno o múltiples widgets BoxShadow, puedes aplicarlos para customizar la profundidad de las sombras, el color, etc.

<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  <div class="redbox">
    Lorem ipsum
  </div>
</div>

.greybox {
  background-color: #e0e0e0; /* grey 300 */
  width: 320px;
  height: 240px;
  font: 900 24px Roboto;
  display: flex;
  align-items: center;
  justify-content: center;
}
.redbox {
  background-color: #ef5350; /* red 400 */
  padding: 16px;
  color: #ffffff;
[[highlight]]  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.8),
              0 6px 20px rgba(0, 0, 0, 0.5);[[/highlight]]
}
{% endprettify %}
</div>
<div class="righthighlight">
{% prettify dart %}
var container = Container( // grey box
  child: Center(
    child: Container( // red box
      child: Text(
        "Lorem ipsum",
        style: bold24Roboto,
      ),
      decoration: BoxDecoration(
        color: Colors.red[400],
[[highlight]]        boxShadow: <BoxShadow>[
          BoxShadow (
            color: const Color(0xcc000000),
            offset: Offset(0.0, 2.0),
            blurRadius: 4.0,
          ),
          BoxShadow (
            color: const Color(0x80000000),
            offset: Offset(0.0, 6.0),
            blurRadius: 20.0,
          ),
        ], [[/highlight]]
      ),
      padding: EdgeInsets.all(16.0),
    ),
  ),
  width: 320.0,
  height: 240.0,
  decoration: BoxDecoration(
    color: Colors.grey[300],
  ),
  margin: EdgeInsets.only(bottom: 16.0),
);
{% endprettify %}
</div>

### Haciendo círculos y elipses

Hacer círculos en CSS requiere aplicar una solución alternativa aplicando un border-radius de 50% para todos los lados de un rectángulo, aunque hay [formas básicas](https://developer.mozilla.org/en-US/docs/Web/CSS/basic-shape).

Si bien este enfoque es compatible con la propiedad `borderRadius` de [BoxDecoration](https://docs.flutter.io/flutter/painting/BoxDecoration-class.html), Flutter provee una propiedad `shape` con [BoxShape enum](https://docs.flutter.io/flutter/painting/BoxShape-class.html) para este propósito.

<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  <div class="redcircle">
    Lorem ipsum
  </div>
</div>

.greybox {
  background-color: #e0e0e0; /* gray 300 */
  width: 320px;
  height: 240px;
  font: 900 24px Roboto;
  display: flex;
  align-items: center;
  justify-content: center;
}
.redcircle {
  background-color: #ef5350; /* red 400 */
  padding: 16px;
  color: #ffffff;
[[highlight]]  text-align: center;
  width: 160px;
  height: 160px;
  border-radius: 50%; [[/highlight]]
}
{% endprettify %}
</div>
<div class="righthighlight">
{% prettify dart %}
var container = Container( // grey box
  child: Center(
    child: Container( // red circle
      child: Text(
        "Lorem ipsum",
        style: bold24Roboto,
[[highlight]]        textAlign: TextAlign.center, [[/highlight]]
      ),
      decoration: BoxDecoration(
        color: Colors.red[400],
[[highlight]]        shape: BoxShape.circle, [[/highlight]]
      ),
      padding: EdgeInsets.all(16.0),
[[highlight]]      width: 160.0,
      height: 160.0, [[/highlight]]
    ),
  ),
  width: 320.0,
  height: 240.0,
  color: Colors.grey[300],
);
{% endprettify %}
</div>

## Manipulando texto

Los siguientes ejemplos muestran cómo especificar fuentes y otros atributos de texto. También muestran cómo transformar cadenas de texto, personalizar el espaciado y crear extractos.


### Ajustando el espacio del texto

En CSS se especifica la cantidad de espacio en blanco entre cada letra o palabra dando un valor de longitud para las propiedades de espaciado de letras y de palabras, respectivamente. La cantidad de espacio puede ser en px, pt, cm, em, etc.

En Flutter, especificas el espacio en blanco como pixeles lógicos (valores negativos están permitidos) para las propiedades `letterSpacing` y `wordSpacing` de un [TextStyle](https://docs.flutter.io/flutter/painting/TextStyle-class.html) hijo de un widget Text.

<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  <div class="redbox">
    Lorem ipsum
  </div>
</div>

.greybox {
  background-color: #e0e0e0; /* grey 300 */
  width: 320px;
  height: 240px;
  font: 900 24px Roboto;
  display: flex;
  align-items: center;
  justify-content: center;
}
.redbox {
  background-color: #ef5350; /* red 400 */
  padding: 16px;
  color: #ffffff;
[[highlight]]  letter-spacing: 4px; [[/highlight]]
}
{% endprettify %}
</div>
<div class="righthighlight">
{% prettify dart %}
var container = Container( // grey box
  child: Center(
    child: Container( // red box
      child: Text(
        "Lorem ipsum",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
[[highlight]]          letterSpacing: 4.0, [[/highlight]]
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.red[400],
      ),
      padding: EdgeInsets.all(16.0),
    ),
  ),
  width: 320.0,
  height: 240.0,
  color: Colors.grey[300],
);
{% endprettify %}
</div>

### Haciendo cambios de formato en línea

Un widget [Text](https://docs.flutter.io/flutter/widgets/Text-class.html) te permite mostrar texto con las mismas características de formato. Para mostrar texto que use múltiples estilos (en este ejemplo, una simple palabra con énfasis), usa en su lugar un widget [RichText](https://docs.flutter.io/flutter/widgets/RichText-class.html). 
Su propiedad `text` puede especificar uno o más widgets [TextSpan](https://docs.flutter.io/flutter/painting/TextSpan-class.html) a los cuales pueden ser estilizados individualmente.

En el siguiente ejemplo, "Lorem" está en un widget TextSpan con el estilo de texto predeterminado (heredado), y "ipsum" está en un TextSpan separado con estilo personalizado.


<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  <div class="redbox">
[[highlight]]    Lorem <em>ipsum</em> [[/highlight]]
  </div>
</div>

.greybox {
  background-color: #e0e0e0; /* grey 300 */
  width: 320px;
  height: 240px;
[[highlight]]  font: 900 24px Roboto; [[/highlight]]
  display: flex;
  align-items: center;
  justify-content: center;
}
.redbox {
  background-color: #ef5350; /* red 400 */
  padding: 16px;
  color: #ffffff;
}
[[highlight]] .redbox em {
  font: 300 48px Roboto;
  font-style: italic;
} [[/highlight]]
{% endprettify %}
</div>
<div class="righthighlight">
{% prettify dart %}
var container = Container( // grey box
  child: Center(
    child: Container( // red box
      child: [[highlight]] RichText(
        text: TextSpan(
          style: bold24Roboto,
          children: <TextSpan>[
            TextSpan(text: "Lorem "),
            TextSpan(
              text: "ipsum",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                fontSize: 48.0,
              ),
            ),
          ],
        ),
      ), [[/highlight]]
      decoration: BoxDecoration(
        backgroundColor: Colors.red[400],
      ),
      padding: EdgeInsets.all(16.0),
    ),
  ),
  width: 320.0,
  height: 240.0,
  color: Colors.grey[300],
);
{% endprettify %}
</div>

### Creación de extractos de texto

Un extracto muestra la línea(s) iniciales de un párrafo de texto y maneja el desbordamiento de texto, a menudo usando puntos suspensivos. En HTML/CSS un extracto no puede ser más largo que una línea. Truncar después de múltiples líneas requiere algo de código JavaScript.

En Flutter, use la propiedad `maxLines` de un widget [Text](https://docs.flutter.io/flutter/widgets/Text-class.html) para especificar el número de líneas para incluir en un extracto, y la propiedad `overflow` para manejar el desbordamiento del texto.

<div class="lefthighlight">
{% prettify css %}
<div class="greybox">
  <div class="redbox">
    Lorem ipsum dolor sit amet, consec etur
  </div>
</div>

.greybox {
  background-color: #e0e0e0; /* grey 300 */
  width: 320px;
  height: 240px;
  font: 900 24px Roboto;
  display: flex;
  align-items: center;
  justify-content: center;
}
.redbox {
  background-color: #ef5350; /* red 400 */
  padding: 16px;
  color: #ffffff;
[[highlight]]  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap; [[/highlight]]
}
{% endprettify %}
</div>
<div class="righthighlight">
{% prettify dart %}
var container = Container( // grey box
  child: Center(
    child: Container( // red box
      child: Text(
        "Lorem ipsum dolor sit amet, consec etur",
        style: bold24Roboto,
[[highlight]]        overflow: TextOverflow.ellipsis,
        maxLines: 1, [[/highlight]]
      ),
      decoration: BoxDecoration(
        backgroundColor: Colors.red[400],
      ),
      padding: EdgeInsets.all(16.0),
    ),
  ),
  width: 320.0,
  height: 240.0,
  color: Colors.grey[300],
);
{% endprettify %}
</div>
<div class="end-examples"></div>
