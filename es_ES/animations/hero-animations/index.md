---
layout: page
title: "Animaciones Hero"
permalink: /animations/hero-animations/
---

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>Lo que aprenderás:</b>

* El _hero_ se refiere al widget que vuela entre las pantallas.
* Crea una animación de hero usando el widget Hero de Flutter.
* Vuela al hero de una pantalla a otra.
* Animar la transformación de la forma de un hero de circular a rectangular mientras vuela de una pantalla a otra.
* El widget Hero en Flutter implementa un estilo de animación comúnmente conocido como transiciones de _elementos compartidos_ o _animaciones de elementos compartidos_.
</div>

Probablemente has visto animaciones de héroes muchas veces. Por ejemplo, una pantalla muestra una lista de miniaturas que representan artículos en venta.  Al seleccionar un elemento, éste pasa a una nueva pantalla, que contiene más detalles y un botón "Buy".
En Flutter, volar una imagen de una pantalla a otra se denomina _animación de hero_, aunque el mismo movimiento a veces se denomina _transición de elemento compartido_.

Esta guía demuestra cómo construir animaciones de héroe estándar y animaciones de hero que transforman la imagen de una forma circular a una forma cuadrada durante el vuelo.

<aside class="alert alert-info" markdown="1">
**Ejemplos**<br>

Esta guía proporciona ejemplos de los estilos de animación de cada hero en estos enlaces:

* [Código de animación hero estándar](#standard-hero-animation-code)
* [Código de animación hero radial](#radial-hero-animation-code)
</aside>

* TOC Placeholder
{:toc}

<aside class="alert alert-info" markdown="1">
**Nuevo en Flutter?**<br>
Esta página asume que sabes cómo crear un diseño usando los widgets de Flutter. Para más información, ver [Construyendo Layouts en Flutter](/tutorials/layout/).
</aside>

<aside class="alert alert-info" markdown="1">
**Terminologia:**
Un [_Route_](/cookbook/navigation/navigation-basics/) describe una página o pantalla en una aplicación Flutter.
</aside>

Puedes crear esta animación en Flutter with Hero widgets. A medida que el hero se anima desde el origen hasta el route de destino, el route de destino (menos el hero) se desvanece a la vista. Normalmente, los heros son pequeñas partes de la interfaz de usuario, como las imágenes, que ambas rutas tienen en común. Desde la perspectiva del usuario, el hero "vuela" entre las rutas. Esta guía muestra cómo crear las siguientes animaciones de heros:

**Animaciones hero estándar**<br>

Una _animación hero estándar_ transporta al hero de una ruta a otra, normalmente aterrizando en un lugar diferente y con un tamaño diferente.

El siguiente video (grabado a baja velocidad) muestra un ejemplo típico. Golpeando las aletas en el centro del ruta las lleva a la esquina superior izquierda de una nueva ruta azul, en un tamaño más pequeño. Al tocar las aletas en la ruta azul (o utilizando el gesto de vuelta a la ruta anterior del dispositivo), las aletas regresan a la ruta original.

<!--
  Use this instead of the default YouTube embed code so that the embed
  is reposnisve.
-->
<div class="embed-container"><iframe src="https://www.youtube.com/embed/CEcFnqRDfgw?rel=0" frameborder="0" allowfullscreen></iframe></div>

**Animaciones hero radiales**<br>

En la animación hero radial, cuando el hero vuela entre rutas, su forma parece cambiar de circular a rectangular.

El siguiente video (grabado a baja velocidad), muestra un ejemplo de animación hero radial. Al principio, una fila de tres imágenes circulares aparece en la parte inferior de la ruta. Si pulsa sobre cualquiera de las imágenes circulares, esa imagen volará a una nueva ruta que la mostrará en forma cuadrada. Al tocar la imagen cuadrada, el hero regresa a la ruta original, mostrada con una forma circular.

<div class="embed-container"><iframe src="https://www.youtube.com/embed/LWKENpwDKiM?rel=0" frameborder="0" allowfullscreen></iframe></div>

Antes de pasar a las secciones específicas de animaciones [estándar](#standard-hero-animations) o [radiales](#radial-hero-animations), leer la [estructura básica de la animación](#basic-structure) de un héroe para aprender a estructurar el código de animación de un héroe, y [entre bastidores](#behind-the-scenes) para entender cómo Flutter realiza una animación de un hero.


<a name="basic-structure"></a>
## Estructura básica de la animación hero

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Cuál es el punto??</b>

* Utilice dos widgets de hero en rutas diferentes pero con etiquetas coincidentes para implementar la animación.
* El Navegador gestiona una pila que contiene las rutas de la aplicación.
* Si pulsa una ruta o hace estallar una ruta de la pila del Navegador, se dispara la animación. 
* El framework Flutter calcula un [rectángulo](https://docs.flutter.io/flutter/animation/RectTween-class.html) intermedio que define el límite del héroe mientras vuela desde la fuente hasta la ruta de destino. Durante su vuelo, el héroe es movido a una sobreimpresión de aplicación, de modo que aparezca en la parte superior de ambas rutas.
</div>

<aside class="alert alert-info" markdown="1">
**Terminologia:**
Si el concepto de tweens o tweening es nuevo para usted, por favor vea el [tutorial de Animaciones en Flutter.](/tutorials/animation/)

</aside>

Las animaciones de hero se implementan usando dos widgets [Hero](https://docs.flutter.io/flutter/widgets/Hero-class.html): uno describiendo el widget en la ruta de origen, y otro describiendo el widget en la ruta de destino.
Desde el punto de vista del usuario, el hero parece ser compartido, y sólo el programador necesita entender este detalle de implementación..

<aside class="alert alert-info" markdown="1">
**Nota sobre los diálogos:**
Los hero vuelan de un PageRoute a otro. Dialogs
(mostrado con `showDialog()`, por ejemplo) usa PopupRoutes, que no son PageRoutes.  Al menos por ahora, no puedes animar a un hero a un Diálogo.
Para más desarrollos (y una posible solución), [ver este issue.](https://github.com/flutter/flutter/issues/10667)
</aside>

El código de animación Hero tiene la siguiente estructura:

1. Define un widget Hero inicial, al que se le conoce como el _hero fuente_. El hero especifica su representación gráfica (normalmente una imagen) y una etiqueta de identificación, y se encuentra en el árbol de widgets que se muestra actualmente, tal y como se define en la ruta de origen.
1. Defina un widget Hero final, al que se hace referencia como el _hero de destino_. Este hero también especifica su representación gráfica y la misma etiqueta que el hero fuente. <strong>Es esencial que ambos widgets hero se creen con la misma etiqueta</strong>, normalmente un objeto que representa los datos subyacentes. Para obtener los mejores resultados, los heros deben tener árboles de widgets prácticamente idénticos.
1. Cree una ruta que contenga el hero de destino. La ruta de destino define el árbol de widgets que existe al final de la animación. 
1. Activa la animación pulsando la ruta de destino en la pila del Navigator. Las operaciones push y pop del Navigator activan una animación de hero para cada par de heros con etiquetas coincidentes en las rutas de origen y destino.

Flutter calcula el tween que anima los límites del Hero desde el punto de partida hasta el punto final (interpolando tamaño y posición), y realiza la animación en un overlay.

La siguiente sección describe el proceso de Flutter con más detalle.

## Entre bastidores

A continuación se describe cómo Flutter realiza la transición de una ruta a otra.

<img src="images/hero-transition-0.png" alt="Before the transition the source hero appears in the source route">

Antes de la transición, el hero de la fuente espera en el árbol de widgets de la ruta de la fuente. La ruta de destino todavía no existe y la sobreimpresión está vacía.

---

<img src="images/hero-transition-1.png" alt="The transition begins">

Si se pulsa una ruta hasta el Navigator, se activa la animación.
En t=0.0, Flutter hace lo siguiente:

* Calcula la ruta del hero de destino, fuera de la pantalla, utilizando el movimiento curvo como se describe en la especificación de movimiento del material.
Ahora Flutter sabe dónde termina el hero.

* Coloca al hero de destino en la superposición, en la misma ubicación y tamaño que el hero de origen. La adición de un hero a la sobreimpresión cambia su orden Z para que aparezca en la parte superior de todas las rutas.

* Mueve el hero fuente fuera de la pantalla.

---

<img src="images/hero-transition-2.png" alt="The hero flies in the overlay to its final position and size">

A medida que el héroe vuela, sus límites rectangulares se animan usando [Tween&lt;Rect&gt;,](https://docs.flutter.io/flutter/animation/Tween-class.html) especificado en la propiedad [`createRectTween`](https://docs.flutter.io/flutter/widgets/CreateRectTween.html) de Hero. Por defecto, Flutter utiliza una instancia de [MaterialRectArcTween,](https://docs.flutter.io/flutter/material/MaterialRectArcTween-class.html), que anima las esquinas opuestas del rectángulo a lo largo de una trayectoria curva. (Vea [Animaciones hero radiales](#radial-hero-animations) radiales para un ejemplo que utiliza una animación de Tween diferente.

---

<img src="images/hero-transition-3.png" alt="When the transition is complete, the hero is moved from the overlay to the destination route">

Cuando el vuelo termine:

* Flutter mueve el widget de hero de la sobreimpresión a la ruta de destino. La sobreimpresión está ahora vacía.

* El hero de destino aparece en su posición final en la ruta de destino.

* El hero fuente es restaurado a su ruta.

---

Al abrir la ruta se realiza el mismo proceso, animando al hero a volver a su tamaño y ubicación en la ruta de origen.

### Clases esenciales

Los ejemplos de esta guía utilizan las siguientes clases para implementar animaciones de heros:

[Hero](https://docs.flutter.io/flutter/widgets/Hero-class.html)
: El widget que vuela desde la fuente hasta la ruta de destino.
  Defina un Hero para la ruta de origen y otro para la ruta de destino, y asigne a cada uno la misma etiqueta.
  Flutter anima parejas de heros con las etiquetas correspondientes.

[Inkwell](https://docs.flutter.io/flutter/material/InkWell-class.html)
: Especifica lo que sucede cuando se pulsa sobre el hero. El método `onTap()` de InkWell construye la nueva ruta y la empuja a la pila del Navigator.

[Navigator](https://docs.flutter.io/flutter/widgets/Navigator-class.html)
: El Navegador gestiona una pila de rutas. Si pulsa una ruta o hace estallar una ruta de la pila del Navigator, se dispara la animación.

[Route](https://docs.flutter.io/flutter/widgets/Route-class.html)
: Especifica una pantalla o página. La mayoría de las aplicaciones, más allá de las más básicas, tienen múltiples rutas.

## Animaciones hero estándar

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Cuál es el punto?</b>

* Especifique una ruta con MaterialPageRoute, CupertinoPageRoute o cree una ruta personalizada con PageRouteBuilder. Los ejemplos de esta sección utilizan MaterialPageRoute.
* Cambie el tamaño de la imagen al final de la transición envolviendo la imagen de destino en un SizedBox.
* Cambie la ubicación de la imagen colocando la imagen del destino en un widget de diseño. Estos ejemplos utilizan Container.
</div>

<a name="standard-hero-animation-code"></a>
<aside class="alert alert-info" markdown="1">
**Código de animación hero estándar**<br>

Cada uno de los siguientes ejemplos muestra cómo volar una imagen de una ruta a otra. Esta guía describe el primer ejemplo.<br><br>

[hero_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/hero_animation/)
: Encapsula el código del hero en un widget personalizado de PhotoHero.
  Anima el movimiento del hero a lo largo de una trayectoria curva, como se describe en la especificación de movimiento del material.

[basic_hero_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/basic_hero_animation/)
: Usa el widget de hero directamente.
  Este ejemplo más básico, proporcionado para su referencia, no se describe en esta guía.
</aside>

### ¿Qué está pasando?

Volar una imagen de una ruta a otra es fácil de implementar usando el widget de hero de Flutter. Cuando se utiliza MaterialPageRoute para especificar la nueva ruta, la imagen vuela a lo largo de un trayecto curvilíneo, como se describe en la sección [especificación de movimiento de Material Design](https://material.io/guidelines/motion/movement.html).

[Cree un nuevo ejemplo](/get-started/test-drive/) de Flutter y actualícelo usando los archivos del [directorio GitHub](https://github.com/flutter/website/tree/master/src/_includes/code/animation/hero_animation/).

Para ejecutar el ejemplo:

* Pulse sobre la foto de la ruta de inicio para llevar la imagen a una nueva ruta que muestre la misma foto en una ubicación y escala diferentes.
* Vuelva a la ruta anterior punteando en la imagen o utilizando el gesto back-to-the-previous-route del dispositivo.
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

* La ruta de salida es empujada implícitamente por MaterialApp cuando se proporciona HeroAnimation como propiedad de la aplicación.
* Un InkWell envuelve la imagen, haciendo trivial añadir un gesto de toque a los heros de origen y destino.
* Definir el widget Material con un color transparente permite que la imagen "salga" del fondo mientras vuela a su destino.
* El SizedBox especifica el tamaño del héroe al principio y al final de la animación.
* Ajustando la propiedad `fit` de la imagen a `BoxFit.contain`, se asegura de que la imagen sea lo más grande posible durante la transición sin cambiar su relación de aspecto.

### Clase HeroAnimation

La clase HeroAnimation crea los PhotoHeroes de origen y destino, y establece la transición.

Aquí está el código:

<!-- skip -->
{% prettify dart %}
class HeroAnimation extends StatelessWidget {
  Widget build(BuildContext context) {
    [[highlight]]timeDilation = 5.0; // 1.0 means normal animation speed.[[/highlight]]

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
                    // The blue background emphasizes that it's a new route.
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

* Cuando el usuario toca el InkWell que contiene el hero fuente, el código crea la ruta de destino utilizando MaterialPageRoute. Presionando la ruta de destino a la pila del Navigator se dispara la animación.
* El Contenedor posiciona el PhotoHero en la esquina superior izquierda de la ruta de destino, debajo de la AppBar.
* El método `onTap()` para el PhotoHero de destino hace estallar la pila del Navegador, activando la animación que lleva al Hero de vuelta a la ruta original.
* Utilice la propiedad `timeDilation` para ralentizar la transición durante la depuración.

---

## Animaciones hero radiales

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>¿Cuál es el punto?</b>

* Una _transformación radial_ anima una forma circular a una forma cuadrada.
* Una animación de _hero_ radial realiza una transformación radial mientras vuela el héroe desde la ruta de origen a la ruta de destino.
* MaterialRectCenterArcTween define la animación tween.
* Cree la ruta de destino utilizando PageRouteBuilder.
</div>


Volar un hero de una ruta a otra mientras se transforma de una forma circular a una forma rectángular es un efecto ingenioso que puedes implementar usando los widgets Hero. Para lograr esto, el código anima la intersección de dos formas de clip: un círculo y un cuadrado. A lo largo de la animación, el clip circular (y la imagen) se escalan de `minRadius` a `maxRadius`, mientras que el clip cuadrado mantiene su tamaño constante. Al mismo tiempo, la imagen vuela desde su posición en la ruta de origen a su posición en la ruta de destino. Para ejemplos visuales de esta transición, ver <a href="https://material.io/guidelines/motion/transforming-material.html#transforming-material-radial-transformation">Transformación radial</a>  en la especificación del movimiento del material.

Esta animación puede parecer compleja (y lo es), pero tu puedes **personalizar el ejemplo proporcionado a sus necesidades.** El trabajo pesado está hecho para ti.


<a name="radial-hero-animation-code"></a>
<aside class="alert alert-info" markdown="1">
**Código de animación hero radial**<br>

Cada uno de los siguientes ejemplos muestra una animación de héroe radial. Esta guía describe el primer ejemplo.<br><br>

[radial_hero_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/radial_hero_animation)
: Una animación de hero radial como se describe en la especificación de movimiento del material.

[basic_radial_hero_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/basic_radial_hero_transition)
: El ejemplo más simple de una animación hero radial. La ruta de destino no tiene andamio, carta, columna o texto. Este ejemplo básico, proporcionado como referencia, no se describe en esta guía.

[radial_hero_animation_animate_rectclip](https://github.com/flutter/website/tree/master/src/_includes/code/animation/radial_hero_animation_animate_rectclip)
: Extiende radial_hero_animaton animando también el tamaño del clip rectangular. Este ejemplo más avanzado, proporcionado para su referencia, no se describe en esta guía.
</aside>

<aside class="alert alert-info" markdown="1">
**Pro tip:**
La animación radial del héroe implica la intersección de una forma redonda con una forma cuadrada. Esto puede ser difícil de ver, incluso cuando se ralentiza la animación con `timeDilation`, por lo que puede considerar activar el [modo de depuración visual](/debugging/#visual-debugging) de Flutter durante el desarrollo.

</aside>

### ¿Qué está pasando?

El siguiente diagrama muestra la imagen recortada al principio (`t = 0,0`) y al final (`t = 1,0`) de la animación.

<img src="images/radial-hero-animation.png" alt="visual diagram of
radial transformation from beginning to end">

El gradiente azul (que representa la imagen), indica dónde se cruzan las formas del clip. Al principio de la transición, el resultado de la intersección es un clip circular ([ClipOval](https://docs.flutter.io/flutter/widgets/ClipOval-class.html)). Durante la transformación, el ClipOval pasa de `minRadius` a `maxRadius` mientras que el [ClipRect](https://docs.flutter.io/flutter/widgets/ClipRect-class.html) mantiene un tamaño constante. Al final de la transición, la intersección de los clips circulares y rectangulares produce un rectángulo del mismo tamaño que el widget de héroe. En otras palabras, al final de la transición la imagen ya no es recortada.

[Cree un nuevo ejemplo de Flutter](/get-started/test-drive/)  y actualícelo usando los archivos del [directorio GitHub](https://github.com/flutter/website/tree/master/src/_includes/code/animation/radial_hero_animation).

Para ejecutar el ejemplo:

* Toca una de las tres miniaturas circulares para animar la imagen a un cuadrado más grande situado en el centro de una nueva ruta que oscurece la ruta original.
* Vuelva a la ruta anterior punteando en la imagen o utilizando el gesto back-to-the-previous-route del dispositivo.
* Puede ralentizar aún más la transición utilizando la propiedad `timeDilation`.

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

* El Inkwell captura el gesto del grifo. La función de llamada pasa la función `onTap()` al constructor de la foto.
* Durante el vuelo, el InkWell salpica a su primer antepasado Material.
* El widget Material tiene un color ligeramente opaco, por lo que las partes transparentes de la imagen se renderizan con color. Esto asegura que la transición de circle-to-square sea fácil de ver, incluso para imágenes con transparencia.
* La clase Photo no incluye al Hero en su árbol de widgets. Para que la animación funcione, el hero envuelve el widget RadialExpansion, que envuelve al hero.

### Clase RadialExpansion 

El widget RadialExpansion, el núcleo de la demo, construye el árbol de widgets que corta la imagen durante la transición. La forma recortada resulta de la intersección de un clip circular (que crece durante el vuelo), con un clip rectangular (que permanece de tamaño constante en todo momento).

Para ello, construye el siguiente árbol de widgets:

<img src="images/radial-expansion-class.png" alt="widget tree for the RadialExpansion widget">

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
<li markdown="1">A medida que el hero vuela, su tamaño cambia y, debido a que limita el tamaño de su hijo, el widget RadialExpansion cambia de tamaño para que coincida.
</li>
<li markdown="1">La animación RadialExpansion se crea mediante dos clips superpuestos.
</li>
<li markdown="1">En el ejemplo se define la interpolación de tweening mediante [MaterialRectCenterArcTween.](https://docs.flutter.io/flutter/material/MaterialRectCenterArcTween-class.html). La ruta de vuelo predeterminada para una animación de hero interpola a los tweens utilizando las esquinas de los héroes.  Este enfoque afecta a la relación de aspecto del héroe durante la transformación radial, por lo que la nueva trayectoria de vuelo utiliza MaterialRectCenterArcTween para interpolar a los preadolescentes utilizando el punto central de cada hero.

Aquí está el código:

<!-- skip -->
{% prettify dart %}
static RectTween _createRectTween(Rect begin, Rect end) {
  return MaterialRectCenterArcTween(begin: begin, end: end);
}
{% endprettify %}

La trayectoria de vuelo del hero sigue un arco, pero la relación de aspecto de la imagen permanece constante.
</li>
</ul>

---

## Recursos

Los siguientes recursos pueden ayudar a escribir animaciones:

[Página de destino de las animaciones](/animations/)
: Enumera la documentación disponible para las animaciones de Flutter.
Si los tweens son nuevos para ti, echa un vistazo al [tutorial de Animaciones](/tutorials/animation/).

[Documentación de la API de Flutter](https://docs.flutter.io/)
: Documentación de referencia para todas las bibliotecas de Flutter.
En particular, véase la documentación de la [biblioteca de animación](https://docs.flutter.io/flutter/animation/animation-library.html).

[Galería Flutter](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)
: Aplicación de demostración que muestra muchos widgets de Material Design y otras características de Flutter. La [demo Shrine](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery/lib/demo/shrine) implementa una animación de héroe. 

[Especificaciones del movimiento del material](https://material.io/guidelines/motion/) 
: Describe el movimiento de las aplicaciones de diseño de materiales.
