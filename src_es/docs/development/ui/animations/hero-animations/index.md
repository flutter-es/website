---
title: Animaciones Hero
short-title: Hero
---

{{site.alert.secondary}}
  <h4 class="no_toc">Lo que aprenderas</h4>

  * El _hero_ se refiere al widget que vuela entre pantallas.
  * Crea una animación de hero usando el widget de Flutter's Hero.
  * Vuela el hero de una pantalla a otra.
  * Animar la transformación de la forma de un hero de circular a
    Rectangular al volarlo de una pantalla a otra.
  * El widget Hero en Flutter implementa un estilo de animación
    comúnmente conocido como transiciones del elemento _shared_ o
    animaciones de elementos compartidos.
{{site.alert.end}}

Probablemente has visto animaciones de _hero_ muchas veces. Por ejemplo,
una pantalla muestra una lista de miniaturas que representan elementos
en venta. Seleccionando un artículo lo lleva a una nueva pantalla,
Contiene más detalles y un botón "Comprar". Volando una imagen
De una pantalla a otra se llama animación _hero_.
en Flutter, aunque el mismo movimiento a veces se denomina
una transición _del elemento compartido_.

Esta guía muestra cómo construir estándar
animaciones de hero, y animaciones de hero que transforman el
Imagen desde una forma circular a una forma cuadrada durante el vuelo.

<aside class="alert alert-info" markdown="1">
**Ejemplos**<br>

Esta guía proporciona ejemplos de cada estilo de animación de hero.
en estos enlaces:

* [Código de animación de hero estándar](#standard-hero-animation-code)
* [Código de animación de hero radial.](#radial-hero-animation-code)
</aside>


<aside class="alert alert-info" markdown="1">
**Nuevo en Flutter?**<br>
Esta página asume que usted sabe cómo crear un diseño utilizando Flutter
widgets Para obtener más información, consulte [Creación de diseños en
Flutter](/docs/development/ui/layout).
</aside>

<aside class="alert alert-info" markdown="1">
**Terminología:**
Una [_Ruta_](/docs/cookbook/navigation/navigation-básico) describe una página o pantalla
en una aplicación Flutter.
</aside>

Puedes crear esta animación en Flutter con widgets de Hero.
A medida que el hero anima desde la fuente hasta la ruta de destino,
la ruta de destino (menos el hero) se desvanece a la vista.
Normalmente, los heros son pequeñas partes de la interfaz de usuario, como
Imágenes, que ambas rutas tienen en común. Desde el usuario
Perspectiva del hero "vuela" entre las rutas.
Esta guía muestra cómo crear las siguientes animaciones de hero:

**Animaciones de Hero estándar**<br>

Una _animación de Hero estándar_ vuela al hero de una ruta a una nueva.
ruta, generalmente aterrizando en un lugar diferente y con una
diferente tamaño.

El siguiente video (grabado a baja velocidad) muestra un ejemplo típico.
Al tocar las aletas en el centro de la ruta las lleva al
Esquina superior izquierda de una nueva ruta azul, en un tamaño más pequeño.
Tocando las aletas en la ruta azul.
(o usando el gesto de volver a la ruta anterior del dispositivo)
Vuela las aletas de vuelta a la ruta original.

<!--
  Use esto en lugar del código de inserción de YouTube predeterminado para que la incrustación
  es reposnisve.
-->
<div class="embed-container"><iframe src="https://www.youtube.com/embed/CEcFnqRDfgw?rel=0" frameborder="0" allowfullscreen></iframe></div>

**Animaciones radiales de heroes**<br>

En _radial hero animation_, como el hero vuela entre rutas
Su forma parece cambiar de circular a rectangular.

El siguiente video (grabado a baja velocidad),
Muestra un ejemplo de animación de un hero radial. Al principio, un
La fila de tres imágenes circulares aparece en la parte inferior de la ruta.
Al tocar cualquiera de las imágenes circulares, la imagen se desplaza a una nueva ruta.
Eso lo muestra con una forma cuadrada.
Al tocar la imagen cuadrada, el hero regresa a
La ruta original, se muestra con una forma circular.

<div class="embed-container"><iframe src="https://www.youtube.com/embed/LWKENpwDKiM?rel=0" frameborder="0" allowfullscreen></iframe></div>

Antes de pasar a las secciones específicas de
[standard](#standard-hero-animations)
o [radial](#radial-hero-animations) animaciones de hero,
leer [Estructura básica de una animación de hero](#basic-structure)
Aprender a estructurar código de animación de hero.,
y [entre bastidores](#behind-the-scenes) para comprender
cómo Flutter realiza una animación de hero.

<a name="basic-structure"></a>
## Estructura básica de una animación de hero.

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>What's the point?</b>

* Utilice dos widgets de hero en diferentes rutas pero con etiquetas coincidentes para
  Implementar la animación.
* El navegador gestiona una pila que contiene las rutas de la aplicación.
* Empujar una ruta o hacer estallar una ruta desde la pila del navegador
  activa la animación.
* El marco de Flutter calcula un [rectangle
  tween](https://docs.flutter.io/flutter/animation/RectTween-class.html)
  que define el límite del hero, ya que vuela desde la fuente hasta
  la ruta de destino. Durante su vuelo, el hero es movido a
  una aplicación superpuesta, para que aparezca en la parte superior de ambas rutas.
</div>

<aside class="alert alert-info" markdown="1">
**Terminología:**
Si el concepto de preadolescencia o interpolación es nuevo para usted, consulte la
[Tutarial de Animaciones en Flutter.](/docs/development/ui/animations/tutorial)
</aside>

Las animaciones de hero se implementan usando dos
[Hero](https://docs.flutter.io/flutter/widgets/Hero-class.html)
widgets: uno que describe el widget en la ruta de origen,
y otro describiendo el widget en la ruta de destino.
Desde el punto de vista del usuario, el hero parece ser compartido, y
solo el programador necesita entender este detalle de implementación.

<aside class="alert alert-info" markdown="1">
**Nota sobre los diálogos:**
Los hero vuelan de un PageRoute a otro. Diálogos
(mostrado con `showDialog()`, por ejemplo), use PopupRoutes,
Los cuales no son PageRoutes. Por ahora,
No puedes animar a un hero a un diálogo. Para más desarrollos (y una posible solución), [ver este
problema.](https://github.com/flutter/flutter/issues/10667)
</aside>

El código de animación del hero tiene la siguiente estructura:

1. Define un widget de Hero inicial, denominado _source
   hero_. El hero especifica su representación gráfica.
   (normalmente una imagen), y una etiqueta de identificación, y está en
   el árbol de widgets que se muestra actualmente como lo define la ruta de origen.
1. Define un widget de Hero final, conocido como _destination hero_.
   Este hero también especifica su representación gráfica,
   y la misma etiqueta que el hero fuente.
   Es <strong> esencial que ambos widgets de hero se creen con
   la misma etiqueta </strong>, típicamente un objeto que representa el
   datos subyacentes. Para obtener los mejores resultados, los hero deben tener
   Widgets virtualmente idénticos.
1. Crea una ruta que contenga el hero de destino.
   La ruta de destino define el árbol de widgets que existe.
   Al final de la animación.
1. Activa la animación empujando la ruta de destino en la
   Pila de navegante. Las operaciones de push y pop del navegador activan
   Una animación de hero para cada par de hero con etiquetas coincidentes en
   Las rutas de origen y destino.

Flutter calcula la interpolación que anima los límites del hero desde
el punto de inicio hasta el punto final (tamaño y posición de interpolación),
y realiza la animación en una superposición.

La siguiente sección describe el proceso de Flutter en mayor detalle.

## Entre bastidores

A continuación se describe cómo Flutter realiza la transición desde
una ruta a otra.

<img src="/docs/development/ui/animations/hero-animations/images/hero-transition-0.png" alt="Before the transition the source hero appears in the source route">

Antes de la transición, el hero de origen espera en el widget de la ruta de origen
árbol. La ruta de destino aún no existe, y la superposición
esta vacio.

---

<img src="/docs/development/ui/animations/hero-animations/images/hero-transition-1.png" alt="The transition begins">

Al presionar una ruta hacia el navegador se activa la animación.
En t = 0.0, Flutter hace lo siguiente:

* Calcula la ruta del hero de destino, fuera de la pantalla, usando el
  movimiento curvo como se describe en la especificación de movimiento del material.
  Flutter ahora sabe donde termina el hero.

* Coloca al hero de destino en la superposición, en la
  misma ubicación y tamaño que el hero _source_.
  Agregar un hero a la superposición cambia su orden Z para que
  aparece en la parte superior de todas las rutas.

* Mueve al hero fuente fuera de la pantalla.

---

<img src="/docs/development/ui/animations/hero-animations/images/hero-transition-2.png" alt="The hero flies in the overlay to its final position and size">

A medida que el hero vuela, sus límites rectangulares se animan usando.
[Tween&lt;Rect&gt;,](https://docs.flutter.io/flutter/animation/Tween-class.html)
especificado en Hero's
[`createRectTween`](https://docs.flutter.io/flutter/widgets/CreateRectTween.html) propiedad.
Por defecto, Flutter utiliza una instancia de
[MaterialRectArcTween,](https://docs.flutter.io/flutter/material/MaterialRectArcTween-class.html)
que anima las esquinas opuestas del rectángulo a lo largo de un camino curvo.
(Ve [Radial hero animations](#radial-hero-animations)
para un ejemplo que utiliza una animación Tween diferente.)

---

<img src="/docs/development/ui/animations/hero-animations/images/hero-transition-3.png" alt="When the transition is complete, the hero is moved from the overlay to the destination route">

Cuando el vuelo se completa:

* Flutter mueve el widget de hero de la superposición a la
  ruta de destino. La superposición ahora está vacía.

* El hero de destino aparece en su posición final en
  la ruta de destino.

* El hero fuente es restaurado a su ruta.

---

Al resaltar la ruta se realiza el mismo proceso, animando el
El hero vuelve a su tamaño y ubicación en la ruta de origen.

### Clases esenciales

Los ejemplos en esta guía usan las siguientes clases para
implementar animaciones de hero:

[Hero](https://docs.flutter.io/flutter/widgets/Hero-class.html)
: El widget que vuela desde la fuente hasta la ruta de destino.
  Define un hero para la ruta de origen y otro para la ruta.
  ruta de destino, y asigne a cada uno la misma etiqueta.
  Flutter anima parejas de hero con etiquetas coincidentes.

[Inkwell](https://docs.flutter.io/flutter/material/InkWell-class.html)
: Especifica lo que sucede al tocar el hero.
  El método `onTap()` de InkWell construye la nueva ruta y la empuja
  a la pila del Navegador.

[Navigator](https://docs.flutter.io/flutter/widgets/Navigator-class.html)
: El navegador gestiona una pila de rutas. Empujando una ruta en o
  al abrir una ruta desde la pila del navegador se activa la animación.

[Route](https://docs.flutter.io/flutter/widgets/Route-class.html)
: Especifica una pantalla o página. La mayoría de las aplicaciones, más allá de las más básicas,
  tener multiples rutas.

## Animaciones estándar de Hero

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>What's the point?</b>

* Especifique una ruta utilizando MaterialPageRoute, CupertinoPageRoute, o
  construir una ruta personalizada usando
  PageRouteBuilder. Los ejemplos en esta sección usan MaterialPageRoute.
* Cambiar el tamaño de la imagen al final de la transición por
  envolviendo la imagen del destino en un SizedBox.
* Cambia la ubicación de la imagen colocando las de destino.
  Imagen en un widget de diseño. Estos ejemplos utilizan Container.
</div>

<a name="standard-hero-animation-code"></a>
<aside class="alert alert-info" markdown="1">
**Código de animación de hero estándar**<br>

Cada uno de los siguientes ejemplos muestra cómo volar una imagen desde una
ruta a otro. Esta guía describe el primer ejemplo.<br><br>

[hero_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/hero_animation/)
: Encapsula el código de hero en un widget personalizado de PhotoHero.
  Anima el movimiento del hero a lo largo de un camino curvo,
  como se describe en la especificación de movimiento del material.

[basic_hero_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/basic_hero_animation/)
: Utiliza el widget de hero directamente.
  Este ejemplo más básico, proporcionado para su referencia, no es
  descrito en esta guía.
</aside>

### ¿Que esta pasando?

Volar una imagen de una ruta a otra es fácil de implementar
usando el widget de hero de Flutter. Cuando se utiliza MaterialPageRoute
para especificar la nueva ruta, la imagen vuela a lo largo de un camino curvo,
como lo describe el [Material Design motion
spec.](https://material.io/guidelines/motion/movement.html)

[Crear un nuevo ejemplo de Flutter.](/get-started/test-drive) y
actualízalo usando los archivos del
[Directorio GitHub.](https://github.com/flutter/website/tree/master/src/_includes/code/animation/hero_animation/)

Para ejecutar el ejemplo:

* Toque en la foto de la ruta local para volar la imagen a una nueva ruta
  Mostrando la misma foto en una ubicación y escala diferente.
* Regrese a la ruta anterior tocando la imagen, o usando la
  El gesto de volver a la ruta anterior del dispositivo.
* Puedes retardar la transición aún más usando la `timeDilation`
  propiedad.

### Clase PhotoHero

La clase personalizada de PhotoHero mantiene al hero, y su tamaño, imagen,
y el comportamiento cuando se toca. El PhotoHero construye lo siguiente
árbol de widgets:

<img src="/docs/development/ui/animations/hero-animations/images/photohero-class.png" alt="widget tree for the PhotoHero class">

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

* La ruta de inicio es empujada implícitamente por MaterialApp cuando
  HeroAnimation se proporciona como propiedad de la aplicación.
* Un InkWell envuelve la imagen, por lo que es trivial agregar un toque
  gesto a los hero tanto de origen como de destino.
* Definiendo el widget Material con un color transparente.
  permite que la imagen "salga" del fondo, ya que
  vuela a su destino.
* El SizedBox especifica el tamaño del hero al comienzo y
  Fin de la animación.
* Estableciendo la propiedad `fit` de la imagen en` BoxFit.contain`,
  asegura que la imagen sea lo más grande posible durante el
  Transición sin cambiar su relación de aspecto.

### Clase HeroAnimation

La clase HeroAnimation crea el origen y el destino.
PhotoHeroes, y configura la transición.

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

* Cuando el usuario toca el InkWell que contiene el hero de origen,
  el código crea la ruta de destino utilizando MaterialPageRoute.
  Empujando la ruta de destino a la pila del navegador
  activa la animación.
* El contenedor coloca el PhotoHero en la ruta de destino
  Esquina superior izquierda, debajo de la barra de aplicaciones.
* El método `onTap()` para el destino PhotoHero muestra el
  La pila del navegador, activando la animación que vuela.
  El hero vuelve a la ruta original.
* Usa la propiedad `timeDilation` para retardar la transición
  mientras que la depuración.

---

## Animaciones radiales de heroes

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>What's the point?</b>

* Una _radial transformation_ anima una forma circular en un cuadrado
  forma.
* Una animación radial _hero_ realiza una transformación radial mientras
  volando el hero de la ruta de origen a la ruta de destino.
* MaterialRectCenterArcTween define la animación de interpolación.
* Construye la ruta de destino usando PageRouteBuilder.
</div>

Volar un hero de una ruta a otra a medida que se transforma de una
La forma circular a una forma rectangular es un efecto resbaladizo que
Se puede implementar usando widgets de Hero. Para lograr esto,
El código anima la intersección de dos formas de clip: una
Círculo y un cuadrado.
A lo largo de la animación, el clip circular (y la imagen) se escala desde
`minRadius` a` maxRadius`, mientras que el clip cuadrado se mantiene constante
tamaño. Al mismo tiempo, la imagen vuela.
desde su posición en la ruta de origen hasta su posición en el
ruta de destino. Para ejemplos visuales de esta transición, vea
<a href="https://material.io/guidelines/motion/transforming-material.html#transforming-material-radial-transformation">Transformación
radial</a> in the Material motion spec.

Esta animación puede parecer compleja (y lo es), pero puedes
**personalizar el ejemplo proporcionado a sus necesidades.**
El levantamiento de pesas está hecho para ti.

<a name="radial-hero-animation-code"></a>
<aside class="alert alert-info" markdown="1">
**Código de animcation radial hero**<br>

Cada uno de los siguientes ejemplos muestra una animación de hero radial.
Esta guía describe el primer ejemplo..<br><br>

[radial_hero_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/radial_hero_animation)
: Una animación de hero radial como se describe en la especificación de movimiento de material.

[basic_radial_hero_animation](https://github.com/flutter/website/tree/master/src/_includes/code/animation/basic_radial_hero_transition)
: El ejemplo más simple de una animación de hero radial. El destino
  La ruta no tiene andamio, tarjeta, columna o texto.
  Este ejemplo básico, proporcionado para su referencia, no es
  descrito en esta guía.

[radial_hero_animation_animate_rectclip](https://github.com/flutter/website/tree/master/src/_includes/code/animation/radial_hero_animation_animate_rectclip)
: Extiende radial_hero_animaton animando también el tamaño de la
  clip rectangular. Este ejemplo más avanzado,
  proporcionado para su referencia, no se describe en esta guía.
</aside>

<aside class="alert alert-info" markdown="1">
**Tip pro:**
La animación radial del hero consiste en intersectar una forma redonda con
una forma cuadrada. Esto puede ser difícil de ver, incluso cuando se ralentiza
la animación con `timeDilation`, así que podrías considerar habilitar
[Modo de depuración visual] de Flutter (/docs/testing/debugging#visual-debugging)
durante el desarrollo.
</aside>

### ¿Que esta pasando?

El siguiente diagrama muestra la imagen recortada al principio.
(`t = 0.0`), y el final (` t = 1.0`) de la animación.

<img src="/docs/development/ui/animations/hero-animations/images/radial-hero-animation.png" alt="visual diagram of
Transformación radial de principio a fin">

El degradado azul (que representa la imagen) indica dónde se encuentra el clip.
Las formas se entrecruzan. Al comienzo de la transición,
El resultado de la intersección es un clip circular.
([ClipOval](https://docs.flutter.io/flutter/widgets/ClipOval-class.html)).
Durante la transformación,
el ClipOval pasa de `minRadius` a` maxRadius` mientras que
[ClipRect](https://docs.flutter.io/flutter/widgets/ClipRect-class.html)
Mantiene un tamaño constante.
Al final de la transición, la intersección de la circular y
Los clips rectangulares producen un rectángulo que es del mismo tamaño que el hero.
widget En otras palabras, al final de la transición la imagen no es
más recortado.

[Crear un nuevo ejemplo Flutter](/get-started/test-drive) and
update it using the files from the
[Directorio GitHub.](https://github.com/flutter/website/tree/master/src/_includes/code/animation/radial_hero_animation)

Para ejecutar el ejemplo:

* Toque en una de las tres miniaturas circulares para animar la imagen
  a una plaza más grande situada en medio de una nueva ruta que
  Oscurece la ruta original.
* Regrese a la ruta anterior tocando la imagen, o usando la
  El gesto de volver a la ruta anterior del dispositivo.
* Puedes retardar la transición aún más usando la `timeDilation`
  propiedad.

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
      // Slightly opaque color appears where the image has transparency.
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

* El tintero captura el gesto del grifo.
  La función de llamada pasa la función `onTap()` a la
  Constructor de fotos.

* Durante el vuelo, el InkWell dibuja su salpicadura en su primer material
  antepasado.

* El widget Material tiene un color ligeramente opaco, por lo que el
  Las partes transparentes de la imagen se renderizan con color.
  Esto asegura que la transición de círculo a cuadrado sea fácil de ver,
  Incluso para imágenes con transparencia.

* La clase de fotos no incluye al hero en su árbol de widgets.
  Para que la animación funcione, el hero.
  envuelve el widget de RadialExpansion, que envuelve al hero.

### Clase RadialExpansion

El widget RadialExpansion, el núcleo de la demostración, construye el
Árbol de widgets que recorta la imagen durante la transición.
La forma recortada resulta de la intersección de un clip circular
(que crece durante el vuelo),
Con un clip rectangular (que permanece en tamaño constante).

Para ello, construye el siguiente árbol de widgets:

<img src="/docs/development/ui/animations/hero-animations/images/radial-expansion-class.png" alt="widget tree for the RadialExpansion widget">

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

Informacion clave:

<ul markdown="1">
<li markdown="1">El hero envuelve el widget RadialExpansion.
</li>
<li markdown="1">A medida que el hero vuela, su tamaño cambia y,
porque limita el tamaño de su hijo, la Expansión Radial
El widget cambia el tamaño para que coincida.
</li>
<li markdown="1">La animación de RadialExpansion es creada por dos
Clips superpuestos.
</li>
<li markdown="1">El ejemplo define la interpolación de interpolación utilizando
[MaterialRectCenterArcTween.](https://docs.flutter.io/flutter/material/MaterialRectCenterArcTween-class.html)
La ruta de vuelo predeterminada para una animación de hero interpola las interpolaciones
Usando los rincones de los hero. Este enfoque afecta a la
relación de aspecto del hero durante la transformación radial,
por lo que la nueva ruta de vuelo utiliza MaterialRectCenterArcTween para
interpolar las interpolaciones utilizando el punto central de cada hero.

Aquí está el código:

<!-- skip -->
{% prettify dart %}
static RectTween _createRectTween(Rect begin, Rect end) {
  return MaterialRectCenterArcTween(begin: begin, end: end);
}
{% endprettify %}

La trayectoria de vuelo del hero todavía sigue un arco,
pero la relación de aspecto de la imagen permanece constante.
</li>
</ul>

---

## Resources

Los siguientes recursos pueden ayudar al escribir animaciones:

[Animations landing page](/docs/development/ui/animations)
: Enumera la documentación disponible para animaciones Flutter.
  Si las preadolescentes son nuevas para ti, echa un vistazo a la
  [Animations tutorial](/docs/development/ui/animations/tutorial).

[Flutter API documentation](https://docs.flutter.io/)
: Documentación de referencia para todas las bibliotecas de Flutter.
  En particular, ver la documentación de [animation
  library](https://docs.flutter.io/flutter/animation/animation-library.html).

[Flutter Gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)
: Aplicación de demostración que muestra muchos widgets de Material Design y otros Flutter
  caracteristicas. los [Shrine
  demo](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery/lib/demo/shrine)
  implementa una animación de hero.

[Material motion spec](https://material.io/guidelines/motion/)
: Describe el movimiento para aplicaciones de diseño de materiales.
