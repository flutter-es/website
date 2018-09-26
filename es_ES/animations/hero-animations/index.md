---
layout: page
title: "Animaciones Hero"
permalink: /animations/hero-animations/
---

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>Lo que aprenderás:</b>

* El _hero_ se refiere al widget que se traslada entre las pantallas.
* Crea una animación de hero usando el widget Hero de Flutter.
* Vuela al hero de una pantalla a otra.
* Animar la transformación de la forma de un hero de circular a rectangular mientras vuela de una pantalla a otra.
* El widget Hero en Flutter implementa un estilo de animación comúnmente conocido como _transiciones de elementos compartidos_ o _animaciones de elementos compartidos_.
</div>

Probablemente has visto animaciones hero muchas veces. Por ejemplo, una pantalla muestra una lista de miniaturas que representan artículos en venta.  Al seleccionar un elemento, éste pasa a una nueva pantalla, que contiene más detalles y un botón "Comprar".
En Flutter, trasladar una imagen de una pantalla a otra se denomina _animación hero_, aunque el mismo movimiento a veces se denomina _transición de elemento compartido_.

Esta guía demuestra cómo construir animaciones hero estándar y animaciones de hero que transforman la imagen de una forma circular a una forma cuadrada durante el traslado.

<aside class="alert alert-info" markdown="1">
**Ejemplos**<br>

Esta guía proporciona ejemplos de cada estilo de animación hero en estos enlaces:

* [Código de animación hero estándar](#standard-hero-animation-code)
* [Código de animación hero radial](#radial-hero-animation-code)
</aside>

* TOC Placeholder
{:toc}

<aside class="alert alert-info" markdown="1">
**Nuevo en Flutter?**<br>
Esta página asume que sabes cómo crear un layout usando los widgets de Flutter. Para más información, ver [Construyendo Layouts en Flutter](/tutorials/layout/).
</aside>

<aside class="alert alert-info" markdown="1">
**Terminologia:**
Un [_Route_](/cookbook/navigation/navigation-basics/) describe una página o pantalla en una aplicación Flutter.
</aside>

Puedes crear esta animación en Flutter con widgets Hero. A medida que el hero se anima desde la pantalla de origen hasta la de destino, la pantalla de destino (menos el hero) va apareciendo con un efecto fade dentro de la vista. Normalmente, los heros son pequeñas partes de la interfaz de usuario, como las imágenes, que ambas pantallas tienen en común. Desde la perspectiva del usuario, el hero se "traslada" entre las pantallas. Esta guía muestra cómo crear las siguientes animaciones hero:

**Animaciones hero estándar**<br>

Una _animación hero estándar_ transporta al hero de una pantalla a otra, normalmente aterrizando en un lugar diferente y con un tamaño diferente.

El siguiente video (grabado a baja velocidad) muestra un ejemplo típico. Golpeando las aletas en el centro de la pantalla las lleva a la esquina superior izquierda de una nueva pantalla azul, en un tamaño más pequeño. Al tocar las aletas en la ruta azul (o utilizando el gesto de vuelta a la pantalla anterior del dispositivo), las aletas regresan a la pantalla original.

<!--
  Use this instead of the default YouTube embed code so that the embed
  is reposnisve.
-->
<div class="embed-container"><iframe src="https://www.youtube.com/embed/CEcFnqRDfgw?rel=0" frameborder="0" allowfullscreen></iframe></div>

**Animaciones hero radiales**<br>

En la animación hero radial, cuando el hero vuela entre pantallas, su forma parece cambiar de circular a rectangular.

El siguiente video (grabado a baja velocidad), muestra un ejemplo de animación hero radial. Al principio, una fila de tres imágenes circulares aparece en la parte inferior de la pantalla. Si pulsa sobre cualquiera de las imágenes circulares, esa imagen se trasladara a una nueva pantalla que la mostrará en forma cuadrada. Al tocar la imagen cuadrada, el hero regresa a la pantalla original, mostrada con una forma circular.

<div class="embed-container"><iframe src="https://www.youtube.com/embed/LWKENpwDKiM?rel=0" frameborder="0" allowfullscreen></iframe></div>

Antes de pasar a las secciones específicas de animaciones [estándar](#standard-hero-animations) o [radiales](#radial-hero-animations), lee la [estructura básica de la animación](#basic-structure) hero para aprender a estructurar el código de animación hero, y [entre bastidores](#behind-the-scenes) para entender cómo Flutter realiza una animación hero.


<a name="basic-structure"></a>
## Estructura básica de la animación hero

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* Usa dos widgets hero en pantallas diferentes pero con etiquetas coincidentes para implementar la animación.
* El Navigator gestiona una pila que contiene las routes de la aplicación.
* Hacer push de una route o hacer pop desde una route de la pila de Navigator, desencadena la animación.
* El framework Flutter calcula un [rectangle tween](https://docs.flutter.io/flutter/animation/RectTween-class.html) que define el límite del hero mientras se traslada desde la pantalla origen hasta la pantalla destino. Durante su traslado, el hero es movido a una capa sobrepuesta a la aplicación, de modo que parezca estar por encima de ambas pantallas.
</div>

<aside class="alert alert-info" markdown="1">
**Terminologia:**
Si el concepto de tweens o tweening es nuevo para ti, por favor vea el [tutorial de Animaciones en Flutter.](/tutorials/animation/)

</aside>

Las animaciones hero se implementan usando dos widgets [Hero](https://docs.flutter.io/flutter/widgets/Hero-class.html): uno describiendo el widget en la pantalla de origen, y otro describiendo el widget en la pantalla de destino.
Desde el punto de vista del usuario, el hero parece ser compartido, y sólo el programador necesita entender este detalle de implementación..

<aside class="alert alert-info" markdown="1">
**Nota sobre los diálogos:**
Los hero vuelan de un PageRoute a otro. Dialogs
(mostrado con `showDialog()`, por ejemplo) usa PopupRoutes, que no son PageRoutes.  Al menos por ahora, no puedes animar a un hero a un Dialog.
Para más desarrollos (y una posible solución), [ver este issue.](https://github.com/flutter/flutter/issues/10667)
</aside>

El código de una animación Hero tiene la siguiente estructura:

1. Define un widget Hero inicial, al que se le conoce como el _hero fuente_. El hero especifica su representación gráfica (normalmente una imagen) y una etiqueta de identificación, y se encuentra en el árbol de widgets que se muestra actualmente, tal y como se define en la ruta de origen.
1. Defina un widget Hero final, al que se hace referencia como el _hero de destino_. Este hero también especifica su representación gráfica y la misma etiqueta que el hero fuente. <strong>Es esencial que ambos widgets hero se creen con la misma etiqueta</strong>, normalmente un objeto que representa los datos subyacentes. Para obtener los mejores resultados, los heros deben tener árboles de widgets prácticamente idénticos.
1. Crea una pantalla que contenga el hero de destino. La pantalla de destino define el árbol de widgets que existe al final de la animación. 
1. Activa la animación haciendo push de la pantalla de destino en la pila de Navigator. Las operaciones push y pop de Navigator desencadenan una animación hero para cada pareja de heros con etiquetas coincidentes en las pantallas de origen y destino.

Flutter calcula la interpolación que anima los límites del Hero desde el punto de partida hasta el punto final (interpolando tamaño y posición), y realizando la animación en una capa sobrepuesta.

La siguiente sección describe el proceso de Flutter con más detalle.

## Entre bastidores

A continuación se describe cómo Flutter realiza la transición de una pantalla a otra.

<img src="images/hero-transition-0.png" alt="Before the transition the source hero appears in the source route">

Antes de la transición, el hero de origen espera en él árbol de widgets de la pantalla origen. La pantalla de destino todavía no existe y la capa sobrepuesta todavía esta vacía.

---

<img src="images/hero-transition-1.png" alt="La transición empieza">

Hacer push de una pantalla en Navigator desencadena la animación.
En t=0.0, Flutter hace lo siguiente:

* Calcula el camino hasta el destino del hero, fuera de la pantalla, usando el movimiento curvo como se describe en las especificaciones sobre movimiento curvo de Material.
Ahora Flutter sabe donde para el hero.

* Coloca al hero de destino en la superposición, en la misma ubicación y tamaño que el hero de origen. Añadir un hero a la capa sobrepuesta cambia su Z-order para que parezca por encima de todas las pantallas.

* Mueve el hero de origen fuera de la pantalla.

---

<img src="images/hero-transition-2.png" alt="El hero se traslada en la capa sobrepuesta a su posición y tamaño final">

A medida que el hero se traslada, sus límites rectangulares se animan usando [Tween&lt;Rect&gt;,](https://docs.flutter.io/flutter/animation/Tween-class.html) especificado en la propiedad [`createRectTween`](https://docs.flutter.io/flutter/widgets/CreateRectTween.html) de Hero. Por defecto, Flutter utiliza una instancia de [MaterialRectArcTween,](https://docs.flutter.io/flutter/material/MaterialRectArcTween-class.html), que anima las esquinas opuestas del rectángulo a lo largo de una trayectoria curva. (Mira [Animaciones hero radiales](#radial-hero-animations) radiales para un ejemplo que utiliza una animación Tween diferente.

---

<img src="images/hero-transition-3.png" alt="Cuando la transición se completa, el hero es movido de la capa sobrepuesta a la pantalla de destino">

Cuando el traslado termine:

* Flutter mueve el widget hero de la capa sobrepuesta a la pantalla de destino. La capa sobrepuesta está ahora vacía.

* El hero de destino se muestra en su posición final en la pantalla de destino.

* El hero original es restaurado en su pantalla.

---

Hacer pop de la pantalla realiza el mismo proceso animando al hero a volver a su tamaño y ubicación en la pantalla de origen.

### Clases esenciales

Los ejemplos de esta guía utilizan las siguientes clases para implementar animaciones heros:

[Hero](https://docs.flutter.io/flutter/widgets/Hero-class.html)
: El widget que vuela desde la pantalla de origen a la de destino.
  Defina un Hero para la pantalla de origen y otro para la pantalla destino, y asigna a cada uno la misma etiqueta.
  Flutter anima parejas de heros con las etiquetas coincidentes.

[Inkwell](https://docs.flutter.io/flutter/material/InkWell-class.html)
: Especifica lo que sucede cuando se pulsa sobre el hero. El método `onTap()` de InkWell construye la nueva pantalla y hace push de ella en la pila de Navigator.

[Navigator](https://docs.flutter.io/flutter/widgets/Navigator-class.html)
: El Navegador gestiona una pila de rutas. Hacer push de una route o hacer pop desde una route de la pila de Navigator, desencadena la animación.

[Route](https://docs.flutter.io/flutter/widgets/Route-class.html)
: Especifica una pantalla o página. La mayoría de las aplicaciones, más allá de las más básicas, tienen múltiples pantallas.

## Animaciones hero estándar

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* Especifique una route con MaterialPageRoute, CupertinoPageRoute o cree una ruta personalizada con PageRouteBuilder. Los ejemplos de esta sección utilizan MaterialPageRoute.
* Cambie el tamaño de la imagen al final de la transición envolviendo la imagen de destino en un SizedBox.
* Cambie la ubicación de la imagen colocando la imagen del destino en un widget de layout. Estos ejemplos utilizan Container.
</div>

<a name="standard-hero-animation-code"></a>
<aside class="alert alert-info" markdown="1">
**Código de animación hero estándar**<br>

Cada uno de los siguientes ejemplos muestra cómo trasladar una imagen de una pantalla a otra. Esta guía describe el primer ejemplo.<br><br>

[hero_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/hero_animation/)
: Encapsula el código del hero en un widget PhotoHero personalizado.
  Anima el movimiento del hero a lo largo de una trayectoria curva, como se describe en las especificaciones de movimiento de Material.

[basic_hero_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/basic_hero_animation/)
: Usa el widget hero directamente.
  Este ejemplo más básico, proporcionado para su referencia, no se describe en esta guía.
</aside>

### ¿Qué está pasando?

Trasladar una imagen de una pantalla a otra es fácil de implementar usando el widget hero de Flutter. Cuando se utiliza MaterialPageRoute para especificar la nueva route, la imagen se traslada a lo largo de un trayecto curvilíneo, como se describe en la sección [especificación de movimiento de Material Design](https://material.io/guidelines/motion/movement.html).

[Crea un nuevo ejemplo](/get-started/test-drive/) de Flutter y actualízalo usando los archivos del [directorio GitHub](https://github.com/flutter/website/tree/master/src/_includes/code/animation/hero_animation/).

Para ejecutar el ejemplo:

* Pulsa sobre la foto de la pantalla de inicio para llevar la imagen a una nueva pantalla que muestre la misma foto en una ubicación y escala diferentes.
* Vuelve a la pantalla anterior tocando la imagen o utilizando el gesto "volver a la pantalla anterior" del dispositivo.
* Puede ralentizar aún más la transición utilizando la propiedad `timeDilation`.

### Clase PhotoHero

La clase PhotoHero personalizada mantiene la imagen del hero y su tamaño, y el comportamiento al ser tocado. El PhotoHero construye el siguiente árbol de widgets:

<img src="images/photohero-class.png" alt="widget tree for the PhotoHero class">

Aquí está el código:

<!-- skip -->
{% prettify dart %}
class PhotoHero extends StatelessWidget {
  const PhotoHero({ Key key, this.photo, this.onTap, this.width }) : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
{% endprettify %}

Información clave:

* MaterialApp hace push de forma implícita de la route de inicio cuando se ha proporcionado HeroAnimation como la propiedad home de la app.
* Un InkWell envuelve la imagen, haciendo trivial añadir un gesto de tap a los heros de origen y destino.
* Definir el widget Material con un color transparente permite que la imagen "salga" del fondo mientras vuela a su destino.
* El SizedBox especifica el tamaño del hero al principio y al final de la animación.
* Ajustando la propiedad `fit` de la imagen a `BoxFit.contain`, se asegura que la imagen sea lo más grande posible durante la transición sin cambiar su relación de aspecto.

### Clase HeroAnimation

La clase HeroAnimation crea los PhotoHeroes de origen y destino, y establece la transición.

Aquí está el código:

<!-- skip -->
{% prettify dart %}
class HeroAnimation extends StatelessWidget {
  Widget build(BuildContext context) {
    [[highlight]]timeDilation = 5.0; // 1.0 significa velocidad normal de animación.[[/highlight]]

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Hero Animation'),
      ),
      body: Center(
        [[highlight]]child: PhotoHero([[/highlight]]
          photo: 'images/flippers-alpha.png',
          width: 300.0,
          [[highlight]]onTap: ()[[/highlight]] {
            [[highlight]]Navigator.of(context).push(MaterialPageRoute<Null>([[/highlight]]
              [[highlight]]builder: (BuildContext context)[[/highlight]] {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Flippers Page'),
                  ),
                  body: Container(
                    // el fondo azul enfatiza que esta es una nueva ruta.
                    color: Colors.lightBlueAccent,
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.topLeft,
                    [[highlight]]child: PhotoHero([[/highlight]]
                      photo: 'images/flippers-alpha.png',
                      width: 100.0,
                      [[highlight]]onTap: ()[[/highlight]] {
                        [[highlight]]Navigator.of(context).pop();[[/highlight]]
                      },
                    ),
                  ),
                );
              }
            ));
          },
        ),
      ),
    );
  }
}
{% endprettify %}

Información clave:

* Cuando el usuario toca el InkWell que contiene el hero fuente, el código crea la ruta de destino utilizando MaterialPageRoute. Haciendo push de la pantalla de destino a la pila de Navigator, se activa la animación.
* El Contenedor posiciona el PhotoHero en la esquina superior izquierda de la pantalla de destino, debajo de la AppBar.
* El método `onTap()` para el PhotoHero de destino hace pop en la pila del Navigator activando la animación que lleva al Hero de vuelta a la pantalla original.
* Utilice la propiedad `timeDilation` para ralentizar la transición durante la depuración.

---

## Animaciones hero radiales

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Qué aprenderás?</b>

* Una _transformación radial_ anima una forma circular a una forma cuadrada.
* Una animación de _hero_ radial realiza una transformación radial mientras traslada el hero desde la pantalla de origen a la pantalla destino.
* MaterialRectCenterArcTween define la animación tween.
* Crea el route de destino utilizando PageRouteBuilder.
</div>


Trasladar un hero desde una pantalla a otra mientras se transforma de una forma circular a una forma rectángular es un efecto ingenioso que puedes implementar usando los widgets Hero. Para lograr esto, el código anima la intersección de dos formas clip: un círculo y un cuadrado. A lo largo de la animación, el clip circular (y la imagen) se escalan de `minRadius` a `maxRadius`, mientras que el clip cuadrado mantiene su tamaño constante. Al mismo tiempo, la imagen se traslada desde su posición en la pantalla de origen a su posición en la pantalla de destino. Para ejemplos visuales de esta transición, consulta la <a href="https://material.io/guidelines/motion/transforming-material.html#transforming-material-radial-transformation">Transformación radial</a> en las especificaciones de movimiento Material


Esta animación puede parecer compleja (y lo es), pero puedes **personalizar el ejemplo proporcionado a sus necesidades.** El trabajo pesado se hace por ti.


<a name="radial-hero-animation-code"></a>
<aside class="alert alert-info" markdown="1">
**Código de animación hero radial**<br>

Cada uno de los siguientes ejemplos muestra una animación hero radial. Esta guía describe el primer ejemplo.<br><br>

[radial_hero_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/radial_hero_animation)
: Una animación hero radial como se describe en la especificación de movimiento del material.

[basic_radial_hero_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/basic_radial_hero_transition)
: El ejemplo más simple de una animación hero radial. La ruta de destino no tiene Scaffold, Card, Column o Text. Este ejemplo básico, provisto como referencia, no se describe en esta guía.

[radial_hero_animation_animate_rectclip](https://github.com/flutter/website/tree/master/src/_includes/code/animation/radial_hero_animation_animate_rectclip)
: Extiende radial_hero_animaton animando también el tamaño del clip rectangular. Este ejemplo más avanzado, provisto para tu referencia, no se describe en esta guía.
</aside>

<aside class="alert alert-info" markdown="1">
**Pro tip:**
La animación hero radial implica la intersección de una forma redonda con una forma cuadrada. Esto puede ser difícil de ver, incluso cuando se ralentiza la animación con `timeDilation`, por lo que puede considerar activar el [modo de depuración visual](/debugging/#visual-debugging) de Flutter durante el desarrollo.

</aside>

### ¿Qué está pasando?

El siguiente diagrama muestra la imagen recortada al principio (`t = 0,0`) y al final (`t = 1,0`) de la animación.

<img src="images/radial-hero-animation.png" alt="Diagrama visual de la transformación radial desde el principio hasta el final">

El gradiente azul (que representa la imagen), indica dónde se cruzan las formas clip. Al principio de la transición, el resultado de la intersección es un clip circular ([ClipOval](https://docs.flutter.io/flutter/widgets/ClipOval-class.html)). Durante la transformación, el ClipOval pasa de `minRadius` a `maxRadius` mientras que el [ClipRect](https://docs.flutter.io/flutter/widgets/ClipRect-class.html) mantiene un tamaño constante. Al final de la transición, la intersección de los clips circulares y rectangulares produce un rectángulo del mismo tamaño que el widget hero. En otras palabras, al final de la transición la imagen ya no es recortada.

[Crea un nuevo ejemplo de Flutter](/get-started/test-drive/)  y actualícelo usando los archivos del [directorio GitHub](https://github.com/flutter/website/tree/master/src/_includes/code/animation/radial_hero_animation).

Para ejecutar el ejemplo:

* Toca una de las tres thumbnails circulares para animar la imagen a un cuadrado más grande situado en el centro de una nueva ruta que oscurece la pantalla original.
* Vuelva a la pantalla anterior tocando la imagen o utilizando el gesto "volver a la pantalla anterior" del dispositivo.
* Puedes ralentizar aún más la transición utilizando la propiedad `timeDilation`.

### Clase Photo

La clase Photo construye el árbol de widgets que contiene la imagen:

<!-- skip -->
{% prettify dart %}
class Photo extends StatelessWidget {
  Photo({ Key key, this.photo, this.color, this.onTap }) : super(key: key);

  final String photo;
  final Color color;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return [[highlight]]Material([[/highlight]]
      // Aparece un color ligeramente opaco donde la imagen tiene transparencia.
      [[highlight]]color: Theme.of(context).primaryColor.withOpacity(0.25),[[/highlight]]
      child: [[highlight]]InkWell([[/highlight]]
        onTap: [[highlight]]onTap,[[/highlight]]
        child: [[highlight]]Image.asset([[/highlight]]
            photo,
            fit: BoxFit.contain,
          )
      ),
    );
  }
}
{% endprettify %}

Información clave:

* El Inkwell captura el gesto tap. La función invocada pasa la función `onTap()` al constructor de la Photo.
* Durante el traslado, el InkWell dibuja su efecto splash sobre el primer antecesor Material.
* El widget Material tiene un color ligeramente opaco, por lo que las partes transparentes de la imagen se renderizan con color. Esto asegura que la transición de circulo a cuadrado sea fácil de ver, incluso para imágenes con transparencia.
* La clase Photo no incluye al Hero en su árbol de widgets. Para que la animación funcione, el hero envuelve el widget RadialExpansion.

### Clase RadialExpansion 

El widget RadialExpansion, el núcleo de la demo construye el árbol de widgets que corta la imagen durante la transición. La forma recortada resulta de la intersección de un clip circular (que crece durante la transición), con un clip rectangular (que permanece de tamaño constante en todo momento).

Para ello, construye el siguiente árbol de widgets:

<img src="images/radial-expansion-class.png" alt="árbol de widgets para el widget RadialExpansion">

Aquí está el código:

<!-- skip -->
{% prettify dart %}
class RadialExpansion extends StatelessWidget {
  RadialExpansion({
    Key key,
    this.maxRadius,
    this.child,
  }) : [[highlight]]clipRectSize = 2.0 * (maxRadius / math.sqrt2),[[/highlight]]
       super(key: key);

  final double maxRadius;
  final clipRectSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {[[/highlight]]
    return [[highlight]]ClipOval([[/highlight]]
      child: [[highlight]]Center([[/highlight]]
        child: [[highlight]]SizedBox([[/highlight]]
          width: clipRectSize,
          height: clipRectSize,
          child: [[highlight]]ClipRect([[/highlight]]
            child: [[highlight]]child,[[/highlight]]  // Photo
          ),
        ),
      ),
    );
  }
}
{% endprettify %}

Información clave:

<ul markdown="1">
<li markdown="1">El hero envuelve el widget RadialExpansion.
</li>
<li markdown="1">A medida que el hero se traslada, su tamaño cambia y, debido a que limita el tamaño de su hijo, el widget RadialExpansion cambia de tamaño para que coincida.
</li>
<li markdown="1">La animación RadialExpansion se crea mediante dos clips superpuestos.
</li>
<li markdown="1">En el ejemplo se define la interpolación de tweening mediante [MaterialRectCenterArcTween.](https://docs.flutter.io/flutter/material/MaterialRectCenterArcTween-class.html). La ruta de vuelo predeterminada para una animación de hero interpola a los tweens utilizando las esquinas de los heros. Este enfoque afecta a la relación de aspecto del hero durante la transformación radial, por lo que el nuevo camino de traslado utiliza MaterialRectCenterArcTween para interpolar a los tweens utilizando el punto central de cada hero.

Aquí está el código:

<!-- skip -->
{% prettify dart %}
static RectTween _createRectTween(Rect begin, Rect end) {
  return MaterialRectCenterArcTween(begin: begin, end: end);
}
{% endprettify %}

El camino de traslado del hero sigue un arco, pero la relación de aspecto de la imagen permanece constante.
</li>
</ul>

---

## Recursos

Los siguientes recursos pueden ayudar a escribir animaciones:

[Página de inicio de animaciones](/animations/)
: Enumera la documentación disponible para las animaciones de Flutter.
Si los tweens son nuevos para ti, echa un vistazo al [tutorial de Animaciones](/tutorials/animation/).

[Documentación de la API de Flutter](https://docs.flutter.io/)
: Documentación de referencia para todas las bibliotecas de Flutter.
En particular, consulta la documentación de la [biblioteca de animación](https://docs.flutter.io/flutter/animation/animation-library.html).

[Galería Flutter](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)
: Aplicación de demostración que muestra muchos widgets de Material Design y otras características de Flutter. La [demo Shrine](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery/lib/demo/shrine) implementa una animación hero. 

[Especificaciones del movimiento material](https://material.io/guidelines/motion/) 
: Describe el movimiento de las aplicaciones Material Design.