---
title: Dentro de Flutter
---

# Visión General

Este documento describe el funcionamiento interno del kit de herramientas de
la API Flutter. Porque los widgets de Flutter están construidos usando una Composición
agresiva, Las interfaces de usuario construidas con Flutter tienen un gran número de
widgets.  Para soportar esta carga de trabajo, Flutter utiliza algoritmos sublineales para
Los widgets de diseño y construcción, así como las estructuras de datos que hacen que el árbol
tenga una eficiencia quirúrgica y que tiene una serie de optimizaciones de factor constante.
Con algunos detalles adicionales, este diseño también lo hace fácil para los desarrolladores
al crear listas de desplazamiento infinitas utilizando devoluciones de llamada que crean exactamente esos
Widgets que son visibles para el usuario.

# Composabilidad agresiva

Uno de los aspectos más distintivos de Flutter es su _Composabilidad
agresiva_. Los widgets se construyen componiendo otros widgets,
que están construidos a partir de widgets progresivamente más básicos.
Por ejemplo, `Padding` es un widget en lugar de una propiedad de otros widgets.
Como resultado, las interfaces de usuario construidas con Flutter consisten en muchos,
muchos widgets.

El widget de creación de recursión llega al fondo en `RenderObjectWidgets`,
que son widgets que crean nodos en el árbol subyacente _render_.
El árbol de renderización es una estructura de datos que almacena la geometría de la interfaz
de usuario, que se calcula durante _layout_ y se utiliza durante _painting_ y
_hit testing_. La mayoría de los desarrolladores de Flutter no crean objetos directamente,
pero en su lugar manipular la representación del árbol utilizando widgets.

Con el fin de soportar una composición agresiva en la capa de widgets,
Flutter utiliza una serie de eficientes algoritmos y optimizaciones en
tanto el widget como las capas de árbol de representación, que se describen en el
siguientes subsecciones.

## Diseño sublime

Con un largo número de Widgets y Objetos en render, la clave para un buen
performance es algoritmos eficientes. De suma importancia es el
rendimiento de _layout_, algoritmo que determina la
geometría (por ejemplo tamaño y posición) de los objetos en el render.
Algunos otros kits de herramientas utilizan algoritmos de diseño que son O(N²) o peores
(por ejemplo, iteración de punto fijo en algún dominio de restricción).
Flutter apunta al rendimiento lineal para el diseño inicial, y _rendimiento
del diseño sublineal_ en el caso común de actualizar posteriormente un
diseño existente. Normalmente, la cantidad de tiempo empleado en el diseño debería
escala más lentamente que el número de objetos renderizados.

Flutter realiza un diseño por fotograma, y ​​el algoritmo de diseño funciona
en una sola pasada _Constraints_ son pasados ​​por el árbol por el Objeto 
padre que llaman al método de diseño en cada uno de sus hijos.
Los hijos recursivamente realizan su propio diseño y luego regresan
_geometry_ arriba del árbol volviendo de su método de diseño. En tono rimbombante,
Una vez que un objeto de render ha regresado de su método de diseño, ese render
objeto no será visitado de nuevo<sup><a href="#a1">1</a></sup>
hasta el diseño para el siguiente cuadro. Este enfoque combina lo que puede
de lo contrario, la medida y el diseño se pasa a una sola pasada y,
como resultado, cada objeto de renderizado es visitado
dos veces_<sup><a href="#a2">2</a></sup> durante el diseño: una vez camino
abajo del árbol, y una vez camino arriba del árbol.

Flutter tiene varias especializaciones de este protocolo general.
La especialización más común es `RenderBox`, que opera en
coordenadas cartesianas bidimensionales. En el diseño del cuadro, las restricciones
son una anchura mínima y máxima y una altura mínima y máxima. Durante el diseño,
el hijo determina su geometría eligiendo un tamaño dentro de estos límites.
Después de que el hijo regresa del diseño, el padre decide la posición
del hijo en el sistema de coordenadas de los padres <sup> <a href="#a3"> 3 </a> </sup>.
Observe que el diseño del hijo no puede depender de la posición del hijo
porque la posición del hijo no se determina hasta después que el hijo
vuelve desde el diseño. Como resultado, el padre es libre de reposicionar
al hijo sin necesidad de volver a calcular el diseño del hijo.

Más generalmente, durante el diseño, la información que _solo_ fluye desde
de padre a hijo son las restricciones y la información que _solo_ 
fluye de hijo a padre es la geometría. Estas invariantes pueden reducir
la cantidad de trabajo requerido durante el diseño:

* Si el hijo no ha marcado su propio diseño como sucio, el hijo puede
  volver inmediatamente de la disposición, cortando el paseo, siempre y cuando el
  el padre le da al hijo las mismas restricciones que el hijo recibió
  durante el diseño anterior.

* Cuando un padre llama al método de diseño de un hijo, el padre indica
  si utiliza la información de tamaño devuelta por el hijo. Si,
  como sucede a menudo, el padre no usa la información del tamaño,
  entonces el padre no necesita volver a calcular su diseño si el hijo selecciona
  un nuevo tamaño porque el padre tiene la garantía de que el nuevo tamaño
  Cumplir con las restricciones existentes.

* Las restricciones _Tight_ son aquellas que pueden satisfacerse exactamente por una
  Geometría válida. Por ejemplo, si los anchos mínimo y máximo son iguales a
  entre sí y las alturas mín. y máx. son iguales entre sí,
  El único tamaño que satisface esas restricciones es uno con ese
  anchura y altura. Si el padre proporciona restricciones estrictas,
  entonces el padre no necesita volver a calcular su diseño cada vez que el hijo
  vuelve a calcular su diseño, incluso si el padre utiliza el tamaño del hijo
  en su diseño, porque el hijo no puede cambiar de tamaño sin nuevo
  restricciones de su padre.

* Un objeto de render puede declarar que usa las restricciones provistas
  por el padre solo para determinar su geometría. Tal declaración
  informa al marco que el padre de ese objeto renderizado
  No es necesario volver a calcular su diseño cuando el hijo vuelve a calcular su diseño
  _even si las restricciones no son estrictas_ y _even si los padres
  El diseño depende del tamaño del hijo, porque el hijo no puede cambiar
  Tamaño sin nuevas restricciones de su padre.

Como resultado de estas optimizaciones, cuando el árbol de objetos de renderización contiene
nodos sucios, solo aquellos nodos y una parte limitada del subárbol alrededor
Ellos son visitados durante el diseño.

## Construcción Sublinear de widgets

Similar al algoritmo de diseño, el algoritmo de creación de widgets de Flutter
es sublinear. Una vez construidos, los widgets se mantienen en el elemento _elemento.
tree_, que conserva la estructura lógica de la interfaz de usuario.
El árbol de elementos es necesario porque los propios widgets son
_inmutable_, lo que significa (entre otras cosas), no pueden recordar sus
Relaciones padres o hijos con otros widgets. El árbol de elementos también.
contiene los objetos _state_ asociados con los widgets con estado.

En respuesta a la entrada del usuario (u otros estímulos), un elemento puede ensuciarse,
por ejemplo, si el desarrollador llama a `setState ()` en el estado asociado
objeto. El marco mantiene una lista de elementos sucios y saltos directamente.
para ellos durante la fase _build_, saltándose los elementos limpios. Durante
La fase de compilación, la información fluye de forma básica hacia abajo del elemento.
árbol, lo que significa que cada elemento es visitado como máximo una vez durante la construcción
fase. Una vez limpiado, un elemento no puede ensuciarse de nuevo porque,
Por inducción, todos sus elementos ancestros son también
limpiar <sup><a href="#a4">4</a></sup>.

Debido a que los widgets son _inmutables_, si un elemento no se ha marcado como
sucio, el elemento puede volver inmediatamente de la construcción, cortando el paseo,
si el padre reconstruye el elemento con un widget idéntico. Además,
el elemento solo necesita comparar la identidad del objeto de los dos widgets
referencias con el fin de establecer que el nuevo widget es el mismo que
El antiguo widget. Los desarrolladores explotan esta optimización para implementar el
_reprueba_ patrón, en el que un widget incluye un hijo precompilado
Widget almacenado como una variable miembro en su compilación.

Durante la compilación, Flutter también evita caminar por la cadena principal usando
`Heredados de los Widgets`. Si los widgets comúnmente caminaban su cadena padre,
por ejemplo, para determinar el color del tema actual, la fase de construcción
se convertiría en O (N²) en la profundidad del árbol, que puede ser bastante
Grandes debido a la composición agresiva. Para evitar estos paseos de padres,
El marco empuja la información hacia abajo en el árbol de elementos manteniendo
una tabla hash de `InheritedWidget`s en cada elemento. Tipicamente muchos
Los elementos harán referencia a la misma tabla hash, que cambia solo en
Elementos que introducen un nuevo `InheritedWidget`.

## Reconciliación  Linear

Contrariamente a la creencia popular, Flutter no emplea una diferencia de árbol
algoritmo. En cambio, el marco decide si reutilizar elementos por
examinar la lista de hijos para cada elemento independientemente usando una O(N)
algoritmo. El algoritmo de reconciliación de la lista de hijos optimiza para el
siguientes casos:

* La lista de hijos viejos está vacía.
* Las dos listas son idénticas.
* Hay una inserción o eliminación de uno o más widgets en exactamente
  un lugar en la lista.
* Si cada lista contiene un widget con la misma clave, los dos widgets son
  emparejado

El enfoque general es hacer coincidir el principio y el final de ambos hijos.
listas comparando el tipo de tiempo de ejecución y la clave de cada widget,
potencialmente encontrar un rango no vacío en el medio de cada lista
que contiene todos los hijos sin igual. El marco entonces coloca
Los hijos en el rango en la lista de hijos viejos en una tabla hash
basado en sus llaves. A continuación, el marco recorre la gama en el nuevo.
La lista secundaria y consulta la tabla hash por clave para coincidencias. Sin par
Los hijos se descartan y se reconstruyen desde cero mientras que los hijos emparejados
Se reconstruyen con sus nuevos widgets.

## Cirugia de arbol

La reutilización de elementos es importante para el rendimiento porque los elementos son propios.
dos datos críticos: el estado de los widgets con estado y el
objetos de render subyacente. Cuando el marco es capaz de reutilizar un elemento,
El estado para esa parte lógica de la interfaz de usuario se conserva.
y la información de diseño computada previamente puede ser reutilizada,
A menudo evitando todo el subárbol. De hecho, reutilizar elementos es
tan valioso que Flutter admite las mutaciones del árbol _non-local_ que
preservar el estado y la información de diseño.

Los desarrolladores pueden realizar una mutación de árbol no local mediante la asociación de un `GlobalKey`
con uno de sus widgets. Cada clave global es única en todo el
aplicación completa y se registra con una tabla hash específica de hilo.
Durante la fase de compilación, el desarrollador puede mover un widget con una
Clave para una ubicación arbitraria en el árbol de elementos. En lugar de construir
un elemento nuevo en esa ubicación, el marco revisará el hash
Tabla y reparent el elemento existente de su ubicación anterior a
Su nueva ubicación, conservando todo el subárbol.

Los objetos renderizados en el subárbol reparado son capaces de preservar
su información de diseño porque las restricciones de diseño son los únicos
información que fluye de padre a hijo en el árbol de procesamiento.
El nuevo padre está marcado como sucio para el diseño porque su lista secundaria tiene
cambiado, pero si el nuevo padre pasa al hijo el mismo diseño
restricciones que el hijo recibió de su padre anterior, el hijo puede
Regrese inmediatamente del trazado, cortando el paseo.

Las claves globales y las mutaciones de árbol no locales se utilizan ampliamente por
Desarrolladores para lograr efectos como transiciones de héroes y navegación.

## Optimizaciones de Factor-constante

Además de estas optimizaciones algorítmicas, logran agresivos.
La composabilidad también se basa en varios factores constantes importantes.
optimizaciones Estas optimizaciones son las más importantes a las hojas de
Los principales algoritmos discutidos anteriormente.

* **Modelo-hijo agnostico.** A diferencia de la mayoría de los kits de herramientas, que utilizan listas secundarias,
  El árbol de renderizado de Flutter no se compromete con un modelo secundario específico.
  Por ejemplo, la clase `RenderBox` tiene un resumen `visitChildren ()`
  método en lugar de una interfaz concreta _firstChild_ y _nextSibling_.
  Muchas subclases solo admiten un único hijo, que se mantiene directamente como miembro
  Variable, en lugar de una lista de hijos. Por ejemplo, `RenderPadding`
  solo admite un único hijo y, como resultado, tiene un diseño más sencillo
  Método que tarda menos tiempo en ejecutarse.

* **Renderizado visual del arbol, Arbol lógico de Widgets.** En Flutter, el render
  de árbol opera en un sistema de coordenadas visuales independiente del dispositivo,
  lo que significa que los valores más pequeños en la coordenada x están siempre hacia
  la izquierda, incluso si la dirección de lectura actual es de derecha a izquierda.
  El árbol de widgets opera típicamente en coordenadas lógicas, lo que significa
  con los valores _start_ y _end_ cuya interpretación visual depende
  en la dirección de lectura. La transformación de lo lógico a lo visual.
  Las coordenadas se realizan en el traspaso entre el árbol de widgets y el
  árbol de render. Este enfoque es más eficiente porque el diseño y
  los cálculos de pintura en el árbol de render ocurren más a menudo que el
  la transferencia del árbol de widget a render y puede evitar repetidas conversiones de coordenadas.

* **Texto manejado por un objeto de render especializado.** La gran mayoría
  Los objetos de render son ignorantes de las complejidades del texto. En lugar,
  el texto es manejado por un objeto de render especializado, `RenderParagraph`,
  que es una hoja en el arbol de render. En lugar de subclasificar un
  objeto de procesamiento con reconocimiento de texto, los desarrolladores incorporan texto en sus
  interfaz de usuario utilizando la composición. Este patrón significa `RenderParagraph`
  puede evitar volver a calcular su diseño de texto siempre y cuando su padre lo suministre
  Las mismas restricciones de diseño, que son comunes, incluso durante la cirugía de árboles.

* **Objetos observables.** Flutter utiliza tanto el modelo de observación y
  Los paradigmas reactivos. Obviamente, el paradigma reactivo es dominante,
  pero Flutter utiliza objetos de modelo observable para algunas estructuras de datos de hoja.
  Por ejemplo, _Animaciones_ notifica a una lista de observadores cuando cambia su valor.
  Flutter entrega estos objetos observables del árbol de widgets al
  render tree, que los observa directamente e invalida solo el
  Etapa apropiada de la tubería cuando cambian. Por ejemplo,
  un cambio a una _Animación <Color> _ podría desencadenar solo la fase de pintura
  En lugar de las fases de construcción y pintura.

Tomados juntos y resumidos sobre los grandes árboles creados por agresivos
Composición, estas optimizaciones tienen un efecto sustancial en el rendimiento.

# Desplazamiento infinito

Las listas de desplazamiento infinito son notoriamente difíciles para los juegos de herramientas.
Flutter admite listas de desplazamiento infinitas con una interfaz simple
basado en el patrón _builder_, en el que un `ListView` utiliza una devolución de llamada
para construir widgets a pedido a medida que se hacen visibles para el usuario durante
desplazamiento Para admitir esta función se requiere _visión con reconocimiento de diseño_
y _construyendo widgets a pedido_.

## Diseño con vista al puerto

Como la mayoría de las cosas en Flutter, los widgets desplazables se construyen utilizando
composición. El exterior de un widget desplazable es un `Viewport`,
que es una caja que es "más grande en el interior", es decir, sus hijos
se puede extender más allá de los límites de la ventana gráfica y se puede desplazar a
ver. Sin embargo, en lugar de tener hijos `RenderBox`, una ventana gráfica tiene
Los hijos `RenderSliver`, conocidos como _slivers_, que tienen una vista en cuenta
protocolo de diseño

El protocolo de diseño de la astilla coincide con la estructura del diseño de la caja.
protocolo en el que los padres pasan las limitaciones a sus hijos y
recibir geometría a cambio. Sin embargo, la restricción y los datos de geometría.
Difiere entre los dos protocolos. En el protocolo de la astilla, los hijos.
se les da información sobre la ventana gráfica, incluyendo la cantidad de
Espacio visible restante. Los datos de geometría que devuelven permiten una
variedad de efectos vinculados por desplazamiento, incluidos encabezados plegables y
paralaje.

Diferentes astillas llenan el espacio disponible en la ventana gráfica en diferentes
formas. Por ejemplo, una astilla que produce una lista lineal de hijos establece
a cada hijo en orden hasta que la astilla se quede sin hijos o
se queda sin espacio. Del mismo modo, una astilla que produce un bidimensional.
La cuadrícula de hijos llena solo la parte de su cuadrícula que es visible.
Debido a que son conscientes de cuánto espacio es visible, las astillas pueden producir
un número finito de hijos, incluso si tienen el potencial de producir
Un número ilimitado de hijos.

Las astillas se pueden componer para crear diseños y efectos desplazables a medida.
Por ejemplo, una sola vista puede tener un encabezado plegable seguido
por una lista lineal y luego una cuadrícula. Las tres astillas cooperarán a través de
El protocolo de diseño de la astilla para producir solo aquellos hijos que son en realidad
visible a través de la ventana, independientemente de si esos hijos pertenecen
al encabezado, la lista, o la cuadrícula.

## Construcción de widgets a pedido.

Si Flutter tenía un estricto sistema de construcción, luego distribución y luego pintura,
Lo anterior sería insuficiente para implementar un desplazamiento infinito.
Lista porque la información sobre cuánto espacio es visible a través de
La ventana gráfica solo está disponible durante la fase de diseño. Sin
maquinaria adicional, la fase de diseño es demasiado tarde para construir el
Widgets necesarios para llenar el espacio. El alboroto resuelve este problema.
intercalando las fases de construcción y diseño de la tubería. A cualquiera
punto en la fase de diseño, el marco puede comenzar a construir nuevos
widgets a pedido _siempre que esos widgets sean descendientes de la
renderizar el objeto que actualmente está ejecutando diseño_.

La creación y distribución de intercalado solo es posible debido a la estricta
Controles sobre la propagación de la información en los algoritmos de construcción y diseño.
Específicamente, durante la fase de construcción, la información solo puede propagarse
abajo del arbol Cuando un objeto renderizado está ejecutando un diseño, el diseño
walk no ha visitado el subárbol de abajo que representa el objeto, lo que significa
Las escrituras generadas por la construcción en ese subárbol no pueden invalidar ningún
Información que ha entrado en el cálculo del diseño hasta el momento. Similar,
una vez que el diseño ha regresado de un objeto renderizado, ese objeto renderizado
Nunca volverá a ser visitado durante este diseño, lo que significa que cualquier escritura
generado por cálculos de diseño posteriores no puede invalidar el
información utilizada para construir el subárbol del objeto renderizado.

Adicionalmente, la reconciliación lineal y la cirugía arbórea son esenciales.
para actualizar eficientemente los elementos durante el desplazamiento y para modificar
el árbol de procesamiento cuando los elementos se desplazan hacia adentro y fuera de la vista en
El borde de la ventana.

# Ergonomía de API

Ser rápido solo importa si el marco se puede utilizar efectivamente.
Para guiar el diseño API de Flutter hacia una mayor facilidad de uso, Flutter ha sido
Probado repetidamente en extensos estudios de UX con desarrolladores. Estos estudios
A veces se confirman decisiones de diseño preexistentes, a veces se ayuda la guía.
La priorización de características, y algunas veces cambió la dirección de la
Diseño de la API. Por ejemplo, las API de Flutter están muy documentadas; UX
estudios confirmaron el valor de dicha documentación, pero también destacaron
La necesidad específica de código de ejemplo y diagramas ilustrativos.

Esta sección analiza algunas de las decisiones tomadas en el diseño de API de Flutter
en beneficio de la usabilidad.

## Especialización de las API para que coincida con la mentalidad del desarrollador

La clase base para nodos en `Widget`,` Element` y `RenderObject` de Flutter
Los árboles no definen un modelo hijo. Esto permite que cada nodo sea
Especializado para el modelo hijo que es aplicable a ese nodo.

La mayoría de los objetos `Widget` tienen un solo` Widget` hijo, y por lo tanto solo se exponen
un solo parámetro `child`. Algunos widgets soportan un número arbitrario de
children, y expone un parámetro `children` que toma una lista.
Algunos widgets no tienen hijos y no reservan memoria.
y no tienen parámetros para ellos. Del mismo modo, `RenderObjects` expone APIs
Específicos para su modelo infantil. `RenderImage` es un nodo de hoja, y no tiene
concepto de los hijos. `RenderPadding` toma un solo hijo, por lo que tiene almacenamiento
para un solo puntero a un solo hijo. `RenderFlex` toma un arbitrario
Número de hijos y lo gestiona como una lista enlazada.

En algunos casos raros, se utilizan modelos infantiles más complicados. los
El constructor del objeto de renderizado `RenderTable` toma una matriz de matrices de
los hijos, la clase expone a los captadores y setters que controlan el número
de filas y columnas, y hay métodos específicos para reemplazar
hijos individuales por x, coordenada y, para agregar una fila, para proporcionar un
Nueva matriz de matrices de hijos, y para reemplazar la lista de hijos completa
con una sola matriz y un recuento de columnas. En la implementación,
El objeto no usa una lista enlazada como la mayoría de los objetos de render, pero
en su lugar utiliza una matriz indexable.

Los widgets `Chip` y los objetos` InputDecoration` tienen campos que coinciden
Las ranuras que existen en los controles relevantes. Donde una talla única para todos
modelo infantil obligaría a la semántica a colocarse encima de una lista de
hijos, por ejemplo, definiendo el primer hijo para que sea el valor de prefijo
y el segundo, el sufijo, el modelo infantil dedicado permite
propiedades nombradas dedicadas para ser utilizadas en su lugar.

Esta flexibilidad permite que cada nodo en estos árboles sea manipulado en
El modo más idiomático para su papel. Es raro querer insertar una celda.
en una mesa, haciendo que todas las otras celdas se envuelvan alrededor; similar,
es raro querer eliminar a un hijo de una fila flexible por índice
de por referencia.

El objeto `RenderParagraph` es el caso más extremo: tiene un hijo de
un tipo completamente diferente, `TextSpan`. En el límite `RenderParagraph`,
el árbol `RenderObject` se transforma en un árbol` TextSpan`.

El enfoque general de las API especializadas para cumplir con los desarrolladores
Las expectativas se aplican a más que solo modelos infantiles.

Algunos widgets bastante triviales existen específicamente para que los desarrolladores
Los encontraremos al buscar una solución a un problema. Añadiendo un
el espacio en una fila o columna se hace fácilmente una vez que uno sabe cómo, usando
el widget `Expandido` y un hijo` SizedBox` de tamaño cero, pero descubriendo
ese patrón es innecesario porque buscar `espacio`
descubre el widget `Spacer`, que usa` Expanded` y `SizedBox` directamente
Para lograr el efecto.

Del mismo modo, ocultar un subárbol de widgets se hace fácilmente al no incluir el
widget de subárbol en la construcción en absoluto. Sin embargo, los desarrolladores suelen esperar
hay un widget para hacer esto, y así existe el widget `Visibility`
Para envolver este patrón en un widget trivial reutilizable.

## Argumentos explícitos

Los marcos de IU tienden a tener muchas propiedades, por lo que un desarrollador es
Raramente capaz de recordar el significado semántico de cada constructor.
Argumento de cada clase. Como Flutter usa el paradigma reactivo,
es común que los métodos de compilación en Flutter tengan muchas llamadas a
constructores Al aprovechar el soporte de Dart para los argumentos con nombre,
La API de Flutter es capaz de mantener tales métodos de construcción claros y comprensibles.

Este patrón se extiende a cualquier método con múltiples argumentos,
y, en particular, se extiende a cualquier argumento booleano, por lo que aislado
Los literales `true` o` false` en las llamadas a métodos siempre son autodocumentados.
Además, para evitar confusiones comúnmente causadas por dobles negativos.
en las API, los argumentos booleanos y las propiedades siempre se nombran en el
forma positiva (por ejemplo, `enabled: true` en lugar de` disabled: false`).

## Pavimentación sobre escollos

Una técnica utilizada en varios lugares en el marco de Flutter es
Defina la API tal que no existan condiciones de error. Esto elimina
Clases completas de errores de consideración.

Por ejemplo, las funciones de interpolación permiten uno o ambos extremos de la
la interpolación es nula, en lugar de definir eso como un caso de error:
la interpolación entre dos valores nulos siempre es nula, y la interpolación
de un valor nulo o de un valor nulo es el equivalente de interpolar
al análogo cero para el tipo dado. Esto significa que los desarrolladores
quien accidentalmente pase nulo a una función de interpolación no golpeará
un caso de error, pero en su lugar obtendrá un resultado razonable.

Un ejemplo más sutil es el algoritmo de diseño `Flex`. El concepto de
este diseño es que el espacio dado al objeto de renderizado flexible es
dividido entre sus hijos, por lo que el tamaño de la flexión debe ser el
La totalidad del espacio disponible. En el diseño original, proporcionando
El espacio infinito fallaría: implicaría que la flexión debería ser
De tamaño infinito, una configuración de diseño inútil. En cambio, la API
Se ajustó de modo que cuando se asigna espacio infinito a la flexión.
renderizar el objeto, el mismo renderizar el tamaño para que se ajuste al deseado
Tamaño de los hijos, reduciendo el posible número de casos de error.

El enfoque también se utiliza para evitar tener constructores que permitan
datos inconsistentes a crear. Por ejemplo, el `PointerDownEvent`
el constructor no permite que la propiedad `down` de` PointerEvent`
configurarse como `falso` (una situación que sería auto-contradictoria);
en cambio, el constructor no tiene un parámetro para el 'abajo'
campo y siempre lo establece en `true`.

En general, el enfoque es definir interpretaciones válidas para todos
Valores en el dominio de entrada. El ejemplo más simple es el constructor `Color`.
En lugar de tomar cuatro enteros, uno para el rojo, uno para el verde,
uno para azul y otro para alfa, cada uno de los cuales podría estar fuera de rango,
el constructor predeterminado toma un solo valor entero, y define
el significado de cada bit (por ejemplo, los ocho bits inferiores definen la
componente rojo), de modo que cualquier valor de entrada es un valor de color válido.

Un ejemplo más elaborado es la función `paintImage ()`. Esta función
toma once argumentos, algunos con dominios de entrada bastante amplios, pero
han sido cuidadosamente diseñados para ser en su mayoría ortogonales entre sí,
de tal manera que hay muy pocas combinaciones inválidas.

## Reportar casos de error agresivamente

No todas las condiciones de error pueden ser diseñadas. Para los que se quedan,
En las versiones de depuración, Flutter generalmente intenta detectar los errores muy
temprano e inmediatamente los denuncia. Las afirmaciones son ampliamente utilizadas.
Argumentos de constructor son la cordura verificada en detalle. Los ciclos de vida son
monitoreado y cuando se detectan inconsistencias inmediatamente
hacer que se lance una excepción.

En algunos casos, esto se lleva a extremos: por ejemplo, cuando se ejecuta
Pruebas unitarias, independientemente de lo que haga la prueba, cada `RenderBox`
subclase que se presenta de forma agresiva inspecciona si su intrínseca
Los métodos de dimensionamiento cumplen con el contrato de dimensionamiento intrínseco. Esto ayuda a atrapar
errores en las API que de otro modo no se podrían ejercer.

Cuando se lanzan excepciones, incluyen tanta información como
está disponible. Algunos de los mensajes de error de Flutter sondean proactivamente la
seguimiento de pila asociado para determinar la ubicación más probable de la
error real Otros caminan los árboles relevantes para determinar la fuente.
de malos datos. Los errores más comunes incluyen instrucciones detalladas.
Incluyendo en algunos casos código de ejemplo para evitar el error, o enlaces.
Para más documentación.

## Paradigma reactivo

Las API mutables basadas en árboles sufren de un patrón de acceso dicotómico:
La creación del estado original del árbol normalmente utiliza una muy diferente
conjunto de operaciones que las actualizaciones posteriores. Capa de representación del aleteo
utiliza este paradigma, ya que es una forma efectiva de mantener un árbol persistente,
que es clave para el diseño eficiente y la pintura. Sin embargo, significa
que la interacción directa con la capa de representación es torpe en el mejor de los casos
y propenso a los errores en el peor de los casos.

La capa de widgets de Flutter introduce un mecanismo de composición usando el
Paradigma reactivo para manipular el árbol de renderización subyacente.
Esta API abstrae la manipulación del árbol combinando el árbol
pasos de creación y mutación de árbol en una sola descripción de árbol (compilación)
paso, donde, después de cada cambio al estado del sistema, la nueva configuración
de la interfaz de usuario es descrito por el desarrollador y el marco
calcula la serie de mutaciones de árbol necesarias para reflejar esta nueva
configuración.

## Interpolación

Dado que el marco de Flutter alienta a los desarrolladores a describir la interfaz
Configuración que coincide con el estado actual de la aplicación, existe un mecanismo.
Animar implícitamente entre estas configuraciones.

Por ejemplo, supongamos que en el estado S <sub>1</sub> la interfaz consiste
de un círculo, pero en el estado S <sub>2</sub> consiste en un cuadrado.
Sin un mecanismo de animación, el cambio de estado tendría un efecto discordante.
cambio de interfaz Una animación implícita permite que el círculo sea suave
al cuadrado sobre varios cuadros.

Cada característica que puede ser animada implícitamente tiene un widget con estado que
mantiene un registro del valor actual de la entrada y comienza una animación
secuencia cada vez que cambia el valor de entrada, pasando de la corriente
valor al nuevo valor sobre una duración especificada.

Esto se implementa usando las funciones `lerp` (interpolación lineal) usando
Objetos inmutables. Cada estado (círculo y cuadrado, en este caso)
se representa como un objeto inmutable que se configura con
Configuraciones apropiadas (color, ancho de trazo, etc.) y sabe pintar.
sí mismo. Cuando es tiempo de dibujar los pasos intermedios durante la animación,
los valores de inicio y final se pasan a la función `lerp` apropiada
junto con un valor _t_ que representa el punto a lo largo de la animación,
donde 0.0 representa el comienzo y 1.0 representa el final
y la función devuelve un tercer objeto inmutable que representa el
etapa intermedia.

Para la transición de círculo a cuadrado, la función `lerp` regresaría
un objeto que representa un "cuadrado redondeado" con un radio descrito como
una fracción derivada del valor _t_, un color interpolado usando el
La función `lerp` para los colores, y un ancho de trazo interpolado usando el
Función `lerp` para dobles. Ese objeto, que implementa el
La misma interfaz que los círculos y cuadrados, sería capaz de pintar.
sí cuando se lo solicite.

Esta técnica permite que la maquinaria estatal, el mapeo de estados a
Configuraciones, la maquinaria de animación, la maquinaria de interpolación,
y la lógica específica relativa a cómo pintar cada cuadro para ser
completamente separados unos de otros.

Este enfoque es ampliamente aplicable. En Flutter, tipos básicos como
`Color` y` Forma` pueden ser interpolados, pero también pueden ser mucho más elaborados.
tipos como `Decoration`,` TextStyle` o `Theme`. Estos son
Típicamente construidos a partir de componentes que pueden ser interpolados,
e interpolar los objetos más complicados es a menudo tan simple como
interpolación recursiva de todos los valores que describen lo complicado
objetos.

Algunos objetos interpolables están definidos por jerarquías de clase. Por ejemplo,
las formas están representadas por la interfaz `ShapeBorder`, y existe una
variedad de formas, incluyendo `BeveledRectangleBorder`,` BoxBorder`,
`CircleBorder`,` RoundedRectangleBorder` y `StadiumBorder`. Una sola
La función `lerp` no puede tener un conocimiento a priori de todos los tipos posibles,
y por lo tanto, la interfaz en su lugar define los métodos `lerpFrom` y` lerpTo`,
que el método estático `lerp` difiere a. Cuando se le dice a interpolar de
de una forma A a una forma B, primero se le pregunta a B si puede 'lerpFrom` de A, luego,
si no puede, a A se le pregunta si puede `lerpTo` B. (si ninguno de los dos es
posible, entonces la función devuelve A de valores de `t` menores que 0.5,
y devuelve B de lo contrario.)

Esto permite que la jerarquía de clases se amplíe arbitrariamente, con más adelante
Adiciones capaces de interpolar entre valores conocidos previamente.
y ellos mismos.

En algunos casos, la interpolación en sí no puede ser descrita por ninguno de
las clases disponibles, y una clase privada se define para describir la
etapa intermedia. Este es el caso, por ejemplo, al interpolar
entre un `CircleBorder` y un` RoundedRectangleBorder`.

Este mecanismo tiene una ventaja adicional: puede manejar la interpolación
Desde etapas intermedias hasta nuevos valores. Por ejemplo, a mitad de camino
una transición de círculo a cuadrado, la forma podría cambiarse una vez más,
haciendo que la animación necesite interpolar a un triángulo. Tan largo como
la clase triangular puede `lerpFrom` la clase intermedia redondeada cuadrada,
La transición se puede realizar sin problemas.

# Conclusión

El eslogan de Flutter, "todo es un widget", gira en torno a la construcción
interfaces de usuario mediante la composición de widgets que, a su vez, se componen de
progresivamente más widgets básicos. El resultado de este agresivo.
La composición es un gran número de widgets que requieren cuidadosamente
Diseñé algoritmos y estructuras de datos para procesar eficientemente.
Con un diseño adicional, estas estructuras de datos también lo hacen
Fácil para los desarrolladores crear listas de desplazamiento infinitas que construyen
Widgets bajo demanda cuando se hacen visibles.

---
**Notas al pie:**

<sup><a name="a1">1</a></sup> Para el diseño, al menos. Puede ser revisado
  para pintar, para construir el árbol de accesibilidad si es necesario,
  y para pruebas de impacto si es necesario.

<sup><a name="a2">2</a></sup> La realidad, por supuesto, es un poco más.
  Complicado. Algunos diseños implican dimensiones intrínsecas o línea de base
  Mediciones, que implican un paseo adicional del subárbol relevante
  (El almacenamiento en caché agresivo se utiliza para mitigar el potencial de
  rendimiento en el peor de los casos). Estos casos, sin embargo, son sorprendentemente
  raro. En particular, no se requieren dimensiones intrínsecas para la
  Caso común de retractilado.

<sup><a name="a3">3</a></sup> Técnicamente, la posición del hijo no es
  parte de su geometría RenderBox y por lo tanto no es necesario que sea realmente
  calculado durante el diseño. Muchos objetos renderizados posicionan implícitamente
  su único hijo en 0,0 relativo a su propio origen, que
  No requiere ningún cálculo o almacenamiento en absoluto. Algunos objetos de render
  Evitar computar la posición de sus hijos hasta el último.
  momento posible (por ejemplo, durante la fase de pintura), para evitar
  El cálculo en su totalidad si no se pintan posteriormente.

<sup><a name="a4">4</a></sup>  Existe una excepción a esta regla.
  Como se discutió en [Creación de widgets a pedido] (# building-widgets-on-demand)
  En esta sección, algunos widgets se pueden reconstruir como resultado de un cambio en el diseño.
  restricciones Si un widget se marcó sucio por razones no relacionadas en
  el mismo marco que también se ve afectado por un cambio en las restricciones de diseño,
  Se actualizará dos veces. Esta compilación redundante se limita a la
  Widget en sí y no afecta a sus descendientes.

<sup><a name="a5">5</a></sup> Una clave es un objeto opaco opcionalmente
  asociado con un widget cuyo operador de igualdad se utiliza para influir
  El algoritmo de reconciliación.

<sup><a name="a6">6</a></sup>  Por accesibilidad, y para dar solicitudes.
  unos pocos milisegundos adicionales entre cuando se crea un widget y cuando
  aparece en la pantalla, la ventana gráfica crea (pero no pinta)
  Widgets para unos cientos de píxeles antes y después de los widgets visibles.

<sup><a name="a7">7</a></sup>  Este enfoque fue primero popularizado por
  La biblioteca de Facebook de React.

<sup><a name="a8">8</a></sup>  En la práctica, se permite el valor _t_
  para extenderse más allá del rango de 0.0-1.0, y lo hace para algunas curvas. por
  Por ejemplo, las curvas "elásticas" se sobrepasan brevemente para representar
  Un efecto de rebote. La lógica de interpolación típicamente puede extrapolar
  Pasado el inicio o el final según corresponda. Para algunos tipos, por ejemplo,
  cuando se interpolan colores, el valor _t_ se fija efectivamente a
  El rango de 0.0-1.0.
