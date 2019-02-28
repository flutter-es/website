---
title: Dentro de Flutter
---

# Visión General

Este documento describe el funcionamiento interno del kit de herramientas de que hacen
la API de Flutter posible. Porque los widgets de Flutter están construidos usando una composición
agresiva, las interfaces de usuario construidas con Flutter tienen un gran número de
widgets. Para soportar esta carga de trabajo, Flutter utiliza algoritmos sublineales para 
el layout y construcción de los widgets, así como las estructuras de datos que hacen que el árbol
tenga una eficiencia quirúrgica y que tiene una serie de optimizaciones de factor constante.
Con algunos detalles adicionales, este diseño también hace fácil para los desarrolladores 
crear listas de desplazamiento infinitas utilizando callbacks que construyen exactamente aquellos 
widgets que son visibles para el usuario.

# Composición agresiva

Uno de los aspectos más distintivos de Flutter es su _composición 
agresiva_. Los widgets se construyen componiendo otros widgets,
que están construidos a partir de widgets progresivamente más básicos.
Por ejemplo, `Padding` es un widget en lugar de una propiedad de otros widgets.
Como resultado, las interfaces de usuario construidas con Flutter consisten en muchos,
muchos widgets.

La recursión en la creación de widgets llega al fondo en `RenderObjectWidgets`,
que son widgets que crean nodos en el árbol de renderizado subyacente.
El árbol de renderización es una estructura de datos que almacena la geometría de la interfaz
de usuario, que se calcula durante la fase _layout_ y se utiliza durante la fase de _painting_ y
_hit testing_. La mayoría de los desarrolladores de Flutter no crean objetos directamente,
en su lugar manipulan el árbol de renderizado utilizando widgets.

Con el fin de soportar una composición agresiva en la capa de widgets,
Flutter utiliza una serie de eficientes algoritmos y optimizaciones 
tanto en la capa del árbol de widget como la del de renderizado, que se describen en las
siguientes subsecciones.

## Layout sublime

Con un gran número de objetos de renderizado y de widgets, la clave para un buen
rendimiento son los algoritmos eficientes. De suma importancia es el
rendimiento de la fase de _layout_, algoritmo que determina la
geometría (por ejemplo tamaño y posición) de los objetos de renderizado.
Algunos otros kits de herramientas utilizan algoritmos de diseño que son O(N²) o peores
(por ejemplo, iteración de punto fijo en algún dominio de restricción).
Flutter apunta al rendimiento lineal para el diseño inicial, y _rendimiento
de layout sublineal_ en el caso común de actualizar posteriormente un
layout existente. Normalmente, la cantidad de tiempo empleado en el layout debería
escala más lentamente que el número de objetos renderizados.

Flutter realiza un layout por frame, y ​​el algoritmo de diseño funciona
en una sola pasada. _Las restricciones_ son pasados ​​por el árbol por los objetos 
padre que llaman al método de layout en cada uno de sus hijos.
Los hijos recursivamente realizan su propio diseño y luego regresan
_su geometría_ arriba del árbol volviendo de su método de layout. Hay que destacar que,
una vez que un objeto de render es devuelto por su método de layout, ese objeto 
render no será visitado de nuevo<sup><a href="#a1">1</a></sup>
hasta la fase de layout del siguiente frame. Este enfoque combinado evita lo que de 
otra manera sería una medida separada y layout pasadas en un único paso, y que, 
como resultado daría, que cada objeto de renderizado sea visitado dos veces, una
en el camino hacia abajo del árbol y otra en el 
camino hacia arriba.

Flutter tiene varias especializaciones de este protocolo general.
La especialización más común es `RenderBox`, que opera en
coordenadas cartesianas bidimensionales. En el layout de las cajas, las restricciones
son una anchura mínima y máxima y una altura mínima y máxima. Durante el layout,
el hijo determina su geometría eligiendo un tamaño dentro de estos límites.
Después de que el hijo regresa de la fase de layout, el padre decide la posición
del hijo en el sistema de coordenadas de su padre <sup> <a href="#a3"> 3 </a> </sup>.
Observa que el layout del hijo no puede depender de la posición del hijo
porque la posición del hijo no se determina hasta después que el hijo
vuelve desde la fase de layout. Como resultado, el padre es libre de reposicionar
al hijo sin necesidad de volver a calcular el layout del hijo.

Más generalmente, durante el layout, la información que _solo_ fluye desde
de padre a hijo son las restricciones y la _única_ información fluye 
de hijo a padre es la geometría. Estas invariantes pueden reducir
la cantidad de trabajo requerido durante el layout:

* Si el hijo no ha marcado su propio layout como dirty, el hijo puede
  volver inmediatamente de la fase de layout, acortando el camino, siempre y cuando el
  el padre le da al hijo las mismas restricciones que el hijo recibió
  durante el layout anterior.

* Cuando un padre llama al método layout de un hijo, el padre indica
  si utiliza la información de tamaño devuelta por el hijo. Si,
  como sucede a menudo, el padre no usa la información del tamaño,
  entonces el padre no necesita volver a calcular su layout si el hijo selecciona
  un nuevo tamaño porque el padre tiene la garantía de que el nuevo tamaño
  cumplie con las restricciones existentes.

* Las restricciones _forzadas_ son aquellas que solo pueden satisfacerse exactamente por una
  geometría válida. Por ejemplo, si los anchos mínimo y máximo son iguales 
  entre sí y las alturas mín. y máx. son iguales entre sí, 
  el único tamaño que satisface esas restricciones es uno con ese
  anchura y altura. Si el padre proporciona restricciones forzadas,
  entonces el padre no necesita volver a calcular su layout cada vez que el hijo
  vuelve a calcular su layout, incluso si el padre utiliza el tamaño del hijo
  en su layout, porque el hijo no puede cambiar de tamaño sin nuevas
  restricciones de su padre.

* Un objeto de render puede declarar que usa las restricciones provistas
  por el padre solo para determinar su geometría. Tal declaración
  informa al framework que el padre de ese objeto renderizado 
  no necesita volver a calcular su layout cuando el hijo vuelve a calcular su layout
  _incluso si las restricciones no son forzadas_ e _incluso si el layout del padre
  depende del tamaño del hijo_, porque el hijo no puede cambiar 
  de tamaño sin nuevas restricciones de su padre.

Como resultado de estas optimizaciones, cuando el árbol de objetos de renderización contiene
nodos dirty, solo estos nodos y una parte limitada del subárbol alrededor 
son visitados durante el layout.

## Construcción Sublinear de widgets

Similar al algoritmo de layout, el algoritmo de creación de widgets de Flutter
es sublinear. Una vez construidos, los widgets se mantienen en el _árbol de elementos _, 
que conserva la estructura lógica de la interfaz de usuario.
El árbol de elementos es necesario porque los propios widgets son
_inmutables_, lo que significa (entre otras cosas), no pueden recordar sus
relaciones de parentesgo con otros widgets. El árbol de elementos también 
contiene los objetos _state_ asociados con los stateful widgets.

En respuesta a la entrada del usuario (u otros estímulos), un elemento puede marcarse como dirty,
por ejemplo, si el desarrollador llama a `setState()` en el objecto state
asociado. El framework mantiene una lista de elementos marcados dirty y salta directamente 
a estos durante la fase _build_, saltándose los elementos limpios. Durante 
la fase de compilación, la información fluye _unidireccionalmente_ hacia abajo del árbol 
de elementos, lo que significa que cada elemento es visitado como máximo una vez durante la 
fase de _build_. Una vez limpiado, un elemento no puede marcarse dirty de nuevo porque, 
por inducción, todos sus elementos ancestros son también
limpios <sup><a href="#a4">4</a></sup>.

Debido a que los widgets son _inmutables_, si un elemento no se ha marcado a si mismo como
dirty, el elemento puede volver inmediatamente de la fase _build_, cortando el camino,
si el padre reconstruye el elemento con un widget idéntico. Además,
el elemento solo necesita comparar la identidad del objeto de los dos referencias de 
widgets con el fin de establecer que el nuevo widget es el mismo que 
el antiguo widget. Los desarrolladores explotan esta optimización para implementar el
patrón _reprojection_, en el que un widget incluye un widfet hijo precompilado
almacenado como una variable miembro en su fasde de build.

Durante la fase build, Flutter también evita caminar por la cadena principal usando
`InheritedWidgets`. Si los widgets comúnmente caminaban por su cadena de padres,
por ejemplo, para determinar el color del tema actual, la fase de build 
se convertiría en O(N²) en la profundidad del árbol, que puede ser bastante
grandes debido a la composición agresiva. Para evitar estos camnios a traves de los padres,
el framework empuja la información hacia abajo en el árbol de elementos manteniendo
una tabla hash de los `InheritedWidget` en cada elemento. Tipicamente, muchos
elementos harán referencia a la misma tabla hash, que cambia solo en
elementos que introducen un nuevo `InheritedWidget`.

## Reconciliación  Linear

Contrariamente a la creencia popular, Flutter no emplea una algoritmo de comparación 
de árbol. En cambio, el framework decide si reutilizar elementos 
examinando la lista de hijos para cada elemento independientemente usando un 
algoritmo O(N). El algoritmo de reconciliación de la lista de hijos optimiza para los
siguientes casos:

* La lista de hijos anterior está vacía.
* Las dos listas son idénticas.
* Hay una inserción o eliminación de uno o más widgets en exactamente
  un lugar en la lista.
* Si cada lista contiene un widget con la misma clave, los dos widgets son
  coincidentes.

El enfoque general es hacer coincidir el principio y el final de ambas listas 
de hijos comparando el tipo de tiempo de ejecución y la clave de cada widget,
potencialmente encontrar un rango no vacío en el medio de cada lista
que contiene todos los hijos no coincidentes. El framework entonces coloca
los hijos en el rango en la lista de hijos viejos en una tabla hash
basado en sus keys. A continuación, el framework recorre la el rango en la nueva 
lista hija y consulta la tabla hash por key para buscar coincidencias. Los hijos
sin coincidencias se descartan y se reconstruyen desde cero mientras que los hijos 
coincidentes se reconstruyen con sus nuevos widgets.

## Cirugia de arbol

La reutilización de elementos es importante para el rendimiento porque los elementos tienen
dos piezas de datos críticas: el estado de los widgets stateful y los
objetos render subyacentes. Cuando el framework es capaz de reutilizar un elemento, 
el estado para esa parte lógica de la interfaz de usuario se conserva 
y la información del layout computada previamente puede ser reutilizada,
a menudo evitando tener que recorrer todo el subárbol. De hecho, reutilizar elementos es
tan valioso que Flutter admite las mutaciones del árbol _no-locales_ que
preservan el estado y la información del layout.

Los desarrolladores pueden realizar una mutación de árbol no local mediante la asociación de un `GlobalKey`
con uno de sus widgets. Cada clave global es única en todo la 
aplicación y se registra con una tabla hash con un hilo específio.
Durante la fase build, el desarrollador puede mover un widget con una 
clave global para una ubicación arbitraria en el árbol de elementos. En lugar de construir
un elemento nuevo en esa ubicación, el framework revisará la tabla 
hash y re-emparentar el elemento existente de su ubicación anterior a
su nueva ubicación, conservando todo el subárbol.

Los objetos renderizados en el subárbol re-emparentado son capaces de preservar
su información de layout porque las restricciones de layout son la única
información que fluye de padre a hijo en el árbol de renderizado.
El nuevo padre se marca como dirty para el layout porque su lista de hijos 
a cambiado, pero si el nuevo padre pasa al hijo las mismas restricciones de layout 
que el hijo recibió de su padre anterior, el hijo puede regresar inmediatamente de 
la fase de layout, acortando el camino.

Las claves globales y las mutaciones de árbol no locales se utilizan ampliamente por
los esarrolladores para lograr efectos como transiciones hero y de navegación.

## Optimizaciones constant-factor

Además de estas optimizaciones algorítmicas, consegir una composabilidad 
ageresiva también se basa en varios optimizaciones de factor constante. 
Estas optimizaciones son las más importantes para la 
mayoria de los algoritmos discutidos anteriormente.

* **Child-model agnóstico.** A diferencia de la mayoría de los kits de herramientas, que utilizan listas de
  hijos, el árbol de renderizado de Flutter no se compromete con un modelo de hijo específico.
  Por ejemplo, la clase `RenderBox` tiene un método abstracto `visitChildren()` 
  en lugar de una interfaz concreta _firstChild_ y _nextSibling_.
  Muchas subclases solo admiten un único hijo, que se almacena directamente como 
  una variable miembro, en lugar de una lista de hijos. Por ejemplo, `RenderPadding`
  solo admite un único hijo y, como resultado, tiene un método de layout más sencillo
  que tarda menos tiempo en ejecutarse.

* **Visual render tree, logical widget tree.** En Flutter, el árbol de 
  renderizado opera en un sistema de coordenadas visuales independiente del dispositivo,
  lo que significa que los valores más pequeños en la coordenada x están siempre hacia
  la izquierda, incluso si la dirección de lectura actual es de derecha a izquierda.
  El árbol de widgets opera típicamente en coordenadas lógicas, lo que significa
  que los la interpretación de los valores valores _start_ y _end_ dependen
  de la dirección de lectura. La transformación de las coordenadas lógicas a las visuales
  se realizan en la transferencia entre el árbol de widgets y el
  árbol de renderizado. Este enfoque es más eficiente porque los calculos de layout y pintado 
  en el árbol de renderizado ocurren más a menudo que en él
  árbol de tranferencia widget-a-render y puede evitar repetidas conversiones de coordenadas.

* **Texto manejado por un objeto de render especializado.** La gran mayoría de
  los objetos de render ignoran las complejidades del texto. En lugar,
  el texto es manejado por un objeto de render especializado, `RenderParagraph`,
  que es una hoja en el árbol de render. En lugar de heredar un
  objeto de render que sepa procesar texto, los desarrolladores incorporan texto en la 
  composición del interface de usuario. Este patrón significa que `RenderParagraph`
  puede evitar volver a calcular su layout de texto siempre y cuando su padre lo suministre
  las mismas restricciones de layout, que es lo habitual, incluso durante el tratamiento de los árboles.

* **Objetos observables.** Flutter utiliza tanto el modelo de observación como 
  los paradigmas reactivos. Obviamente, el paradigma reactivo es dominante,
  pero Flutter utiliza objetos de modelo observable para algunas hojas de la estructura de datos.
  Por ejemplo, _Animations_ notifica a una lista de observadores cuando cambia sus valor.
  Flutter entrega estos objetos observables del árbol de widgets al
  arbol de renderizado, que los observa directamente e invalida solo la
  etapa apropieda del pipeline cuando cambian. Por ejemplo,
  un cambio a una _Animación <Color> _ podría desencadenarse solo en la fase de pintado
  en lugar de en las fases de pintado y de build.

Tomadas juntos y sumados sobre los grandes árboles creados por la composición 
agresiva, estas optimizaciones tienen un efecto sustancial en el rendimiento.

# Scroll infinito

Las listas de scroll infinito son notoriamente difícultosas para los kits de herramientas.
Flutter soporta scroll infinito con un interfaz simple
basado en el patrón _builder_, en el cual un `ListView` utiliza un callback 
para construir widgets bajo demandad a medida que se hacen visibles para el usuario durante
el scroll. Soportar esta característica requiere _viewport-aware layout_
y _construir widgets bajo demanda_.

## Viewport-aware layout

Como la mayoría de las cosas en Flutter, los widgets con scroll se construyen utilizando
composición. El exterior de un widget con scroll es un `Viewport`,
que es una caja que es "más grande en el interior", es decir, sus hijos
se puede extender más allá de los límites del viewport y pueden hacerse 
scroll para introducirlos en la vista. Sin embargo, en lugar de tener hijos `RenderBox`, 
un viewport tiene hijos `RenderSliver`, conocidos como _slivers_, los cuales tienen 
un protocolo de layout viewport-aware.

El protocolo de layout del sliver coincide con la estructura del protocolo de layout en cajas
en que los padres pasan restricciones abajo a sus hijos y reciben las dimensiones geométricas 
devuelta. Sin embargo, las restricciones y los datos de geometría difieren 
entre los dos protocolos. En el protocolo del sliver, a los hijos se les da información sobre el 
viewport, incluyendo la cantidad de espacio visible restante. Los datos de geometría que 
devuelven permiten una variedad de efectos vinculados con el scroll, incluyendo encabezados 
colapsables y paralaje.

Diferentes slivers llenan el espacio disponible en el viewport de diferentes
manera. Por ejemplo, un sliver que produce una lista lineal de hijos ubica a 
cada hijo en orden hasta que el sliver se quede sin hijos o
se quede sin espacio. Del mismo modo, un sliver que produce una 
cuadricula bidimensional de hijos llena solo la parte de su 
cuadrícula que es visible. Debido a que son conscientes de cuánto 
espacio es visible, los slivers pueden producir un número finito de hijos, 
incluso si tienen el potencial de producir 
un número ilimitado de hijos.

Los slivers se pueden componer para crear efectos y layouts con scroll a medida.
Por ejemplo, un único viewport puede tener un encabezado colapsable seguido
por una lista lineal y luego una cuadrícula. Los tres slivers cooperarán a través del 
protocolo de layout de los slivers para producir solo aquellos hijos que son actualmente 
visiblse a través del viewport, independientemente de si esos hijos pertenecen
al encabezado, la lista, o la cuadrícula.

## Construcción de widgets bajo demanda.

Si Flutter tenía un estricto flujo de _build-layout-pintado_,
lo anterior sería insuficiente para implementar una lista de scroll infinito 
porque la información sobre cuánto espacio es visible en el viewport 
sólo está disponible durante la fase de layout. Sin
maquinaria adicional, la fase de layout es demasiado tarde para construir los 
widgets necesarios para llenar el espacio. Flutter resuelve este problema 
intercalando las fases de build y layout del flujo. En cualquiera
punto de la fase de layout, el framework puede comenzar a construir nuevos
widgets bajo demanda _siempre que esos widgets sean descendientes del objecto 
de renderizado que actualmente está ejecutando la fase de layout_.

El entrelazado de la fase de build y de layout solo es posible debido al estricto control 
sobre la propagación de la información en los algoritmos de build y layout.
Específicamente, durante la fase build, la información solo puede propagarse
hacia abajo del árbol. Cuando un objeto de renderizado está ejecutando su fase de layout, 
el camino del layout no ha visitado el subárbol por debajo del objeto de renderizado, lo cual 
significa que las escrituras generadas por la fase de build en ese subárbol no pueden invalidar 
ninguna información que ha entrado en el cálculo del layout hasta el momento. Igualmente,
una vez que el layout ha regresado de un objeto renderizado, ese objeto de renderizado
nunca volverá a ser visitado durante este layout, lo que significa que cualquier escritura
generado por cálculos de posteriores posteriores no puede invalidar la
información utilizada para construir el subárbol del objeto renderizado.

Adicionalmente, la reconciliación lineal y la cirugía de árbol son esenciales 
para actualizar eficientemente los elementos durante el scroll y para modificar
el árbol de renderizado cuando los elementos se desplazan hacia adentro y fuera de la vista en
el borde del viewport.

# Ergonomía de API

Ser rápido solo importa si el framework se puede utilizar efectivamente.
Para guiar el diseño de la API de Flutter hacia una mayor facilidad de uso, Flutter ha sido
probado repetidamente en extensos estudios de UX con desarrolladores. Estos estudios
a veces se confirman decisiones de diseño preexistentes, a veces ayudan guiandonos 
a priorizar las características, y algunas veces cambió la dirección del
diseño de la API. Por ejemplo, las API de Flutter están muy documentadas; los 
estudio de UX confirmaron el valor de dicha documentación, pero también destacaron
la necesidad específica de códigos de ejemplo y diagramas ilustrativos.

Esta sección analiza algunas de las decisiones tomadas en el diseño de API de Flutter
en beneficio de la usabilidad.

## Especialización de las API para que coincida con la mentalidad del desarrollador

La clase base para los nodos en los árboles de `Widget`,` Element` y `RenderObject` de Flutter 
no definen un modelo hijo. Esto permite que cada nodo sea
especializado para el modelo hijo que es aplicable a ese nodo.

La mayoría de los objetos `Widget` tienen un solo` Widget` hijo, y por lo tanto solo se exponen
un parámetro `child`. Algunos widgets soportan un número arbitrario de
hijos, y exponen un parámetro `children` que toma una lista.
Algunos widgets no tienen hijos y no reservan memoria,
y no tienen parámetros para ellos. Del mismo modo, `RenderObjects` expone APIs
específicas para su modelo de hijos. `RenderImage` es un nodo "hoja", y no tiene
el concepto de hijos. `RenderPadding` toma un solo hijo, por lo que tiene almacenamiento
para un solo puntero a un solo hijo. `RenderFlex` toma un número arbitrario
de hijos y lo gestiona como una lista enlazada.

En algunos casos raros, se utilizan modelos de hijos más complicados. El constructor 
del objeto de renderizado `RenderTable` toma una array de arrays de
hijos, la clase expone getters y setters que controlan el numero de 
filas y columnas, y hay métodos específicos para reemplazar
hijos individuales por coordenadas x,y para añadir una fila, proporcionando un
nuevo array de array de hijos, y para reemplazar la lista de hijos completa
con un solo array un contador de columnas. En la implementación,
el objeto no usa una lista enlazada como la mayoría de los objetos de render, 
en su lugar utiliza un array indexable.

Los widgets `Chip` y los objetos` InputDecoration` tienen campos que coinciden
con los espacios que existen en los controles relevantes. Donde un modelo 
de hijo de talla única fuerza la semántica a colocarse encima de una lista de
hijos, por ejemplo, definiendo el primer hijo para que sea el valor de prefijo
y el segundo, para el sufijo, el modelo de hijo especifico permite
propiedades nombradas dedicadas.

Esta flexibilidad permite que cada nodo en estos árboles sea manipulado en
el modo más idiomático para su rol. Es raro querer insertar una celda 
en una tabla, haciendo que todas las otras celdas se ajusten alrededor; similarmente,
es raro querer eliminar a un hijo de una fila flexible por su índice
en lugar de por referencia.

El objeto `RenderParagraph` es el caso más extremo: tiene un hijo de
un tipo completamente diferente, `TextSpan`. En el límite `RenderParagraph`,
el árbol `RenderObject` se transforma en un árbol` TextSpan`.

El enfoque general de las API especializadas para cumplir con las expectacivas 
de los desarrolladores se aplican a más que solo el modelo de hijos.

Algunos widgets bastante triviales existen específicamente para que los desarrolladores
los encuentren al buscar una solución a un problema. Añadiendo un
el espacio en una fila o columna se hace fácilmente una vez que uno sabe cómo, usando
el widget `Expanded` y un hijo `SizedBox` de tamaño cero, pero descubriendo
ese patrón es innecesario porque buscando por  `space`
se descubre el widget `Spacer`, que usa` Expanded` y `SizedBox` directamente 
para lograr el efecto.

Del mismo modo, ocultar un subárbol de widgets se hace fácilmente al no incluir este
subárbol en la fase de build. Sin embargo, los desarrolladores suelen esperar
que haya un widget para hacer esto, y así existe el widget `Visibility` 
para envolver este patrón en un widget trivial reutilizable.

## Argumentos explícitos

Los frameworks de IU tienden a tener muchas propiedades, por lo que un desarrollador es
raramente capaz de recordar el significado semántico de cada argumento de los 
constuctores de cada clase. Como Flutter usa el paradigma reactivo,
es común que los métodos build en Flutter tengan muchas llamadas a
constructores. Al aprovechar el soporte de Dart para los argumentos con nombre,
la API de Flutter es capaz de mantener tales métodos build claros y comprensibles.

Este patrón se extiende a cualquier método con múltiples argumentos,
y, en particular, se extiende a cualquier argumento booleano, por lo que aislado
los literales `true` o` false` en las llamadas a métodos siempre son autodocumentados.
Además, para evitar confusiones comúnmente causadas por dobles negativos.
en las APIs, los argumentos booleanos y las propiedades siempre se nombran en el
forma positiva (por ejemplo, `enabled: true` en lugar de` disabled: false`).

## Allanando el camino

Una técnica utilizada en varios lugares en el framework Flutter es
definir la API tal que no existan condiciones de error. Esto elimina
completamente la consideración de clases de error.

Por ejemplo, las funciones de interpolación permiten que uno o ambos extremos de la
la interpolación sea null, en lugar de definir eso como un caso de error:
la interpolación entre dos valores null siempre es null, y la interpolación
de un valor null o hacia un valor null es el equivalente de interpolar
al valor cero análogo para el tipo dado. Esto significa que los desarrolladores
que pasen accidentalmente un valor null a una función de interpolación no desecadenará 
en un error, en su lugar obtendrá un resultado razonable.

Un ejemplo más sutil es el algoritmo de layout de `Flex`. El concepto de
este layout es que el espacio dado al objeto de renderizado flexible es
dividido entre sus hijos, por lo que el tamaño del flex debe ser 
la totalidad del espacio disponible. En el diseño original, proporcionar 
espacio infinito fallaría: implicaría que el flex debería ser
de tamaño infinito, una configuración de layout inútil. En cambio, la API
se ajustó de modo que cuando se asigna espacio infinito a la objeto de renderizado 
del flex, el tamaño propio del objeto de renderizado se ajusta al tamaño desado
de los hijos, reduciendo el posible número de casos de error.

El enfoque también se utiliza para evitar tener constructores que permitan crear
datos inconsistentes. Por ejemplo, el constructor del `PointerDownEvent` 
no permite que la propiedad `down` de` PointerEvent` 
sea `false` (una situación que sería auto-contradictoria);
en cambio, el constructor no tiene un parámetro para el campo 'down'
y siempre lo establece en `true`.

En general, el enfoque es definir interpretaciones válidas para todos
los valores en el dominio de entrada. El ejemplo más simple es el constructor de `Color`.
En lugar de tomar cuatro enteros, uno para el rojo, uno para el verde,
uno para azul y otro para alfa, cada uno de los cuales podría estar fuera de rango,
el constructor predeterminado toma un solo valor entero, y define
el significado de cada bit (por ejemplo, los ocho bits inferiores definen la
componente rojo), de modo que cualquier valor de entrada es un valor de color válido.

Un ejemplo más elaborado es la función `paintImage()`. Esta función
toma once argumentos, algunos con dominios de entrada bastante amplios, pero
han sido cuidadosamente diseñados para ser en su mayoría ortogonales entre sí,
de tal manera que hay muy pocas combinaciones inválidas.

## Reportar casos de error agresivamente

No todas las condiciones de error pueden ser diseñadas. Para los que se quedan,
en las compilaciones de depuración, Flutter generalmente intenta detectar los errores muy
temprano e inmediatamente reportarlos. Los Asserts son ampliamente utilizadas.
Los argumentos de lo constructor son verificados en detalle. Los ciclos de vida son
monitorizados y cuando se detectan inconsistencias inmediatamente
causan que se lance una excepción.

En algunos casos, esto se lleva a extremos: por ejemplo, cuando se ejecuta
pruebas unitarias, independientemente de lo que haga la prueba, cada subclase de `RenderBox`
que se presenta se inspecciona de forma agresiva si sus metodos de dimensionado intínsecos
cumplen con el contracto de dimensionado intrinseco. Esto ayuda a atrapar
errores en las API que de otro modo no se podrían encontrar.

Cuando se lanzan excepciones, incluyen tanta información como
está disponible. Algunos de los mensajes de error de Flutter sondean proactivamente la
pila asociada para determinar la ubicación más probable de la
error real. Otros recorren los árboles relevantes para determinar la fuente 
de los malos datos. Los errores más comunes incluyen instrucciones detalladas.
incluyendo en algunos casos código de ejemplo para evitar el error, o enlaces 
para más documentación.

## Paradigma reactivo

Las API mutables basadas en árboles sufren de un patrón de acceso dicotómico:
La creación del estado original del árbol normalmente utiliza una muy diferente
conjunto de operaciones que las actualizaciones posteriores. La capa de renderizado de
Flutter utiliza este paradigma, ya que es una forma efectiva de mantener un árbol persistente,
que es clave para el layout y pintado eficiente. Sin embargo, significa
que la interacción directa con la capa de representación es torpe en el mejor de los casos
y propenso a los errores en el peor de los casos.

La capa de widgets de Flutter introduce un mecanismo de composición usando el
paradigma reactivo para manipular el árbol de renderización subyacente.
Esta API abstrae la manipulación del árbol combinando los pasos de creación 
y mutación de árbol en una sola paso de descripción de árbol (build), 
donde, después de cada cambio del estado del sistema, la nueva configuración
de la interfaz de usuario es descrito por el desarrollador y el framework
calcula la serie de mutaciones de árbol necesarias para reflejar esta nueva
configuración.

## Interpolación

Dado que el framework de Flutter alienta a los desarrolladores a describir la interfaz
coincidiedno con el estado actual de la aplicación, existe un mecanismo para 
animar implícitamente entre estas configuraciones.

Por ejemplo, supongamos que en el estado S <sub>1</sub> la interfaz consiste
en un círculo, pero en el estado S <sub>2</sub> consiste en un cuadrado.
Sin un mecanismo de animación, el cambio de estado tendría un efecto discordante.
en el cambio del interfaz. Una animación implícita permite que el círculo sea 
suavemente transformado en cuadrado a través de varios frames.

Cada característica que puede ser animada implícitamente tiene un widget staeful que
mantiene un registro del valor actual de la entrada y comienza una secuencia 
de animación cada vez que cambia el valor de entrada, pasando del  valor actual 
al valor nuevo durante una duración especificada.

Esto se implementa usando las funciones `lerp` (interpolación lineal) usando
objetos inmutables. Cada estado (círculo y cuadrado, en este caso)
se representa como un objeto inmutable que se configura con 
configuraciones apropiadas (color, ancho de trazo, etc.) y sabe como pintarse a 
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
función `lerp` para doubles. Ese objeto, que implementa el
el misma interfaz que los círculos y cuadrados, sería capaz de pintar a 
sí cuando se lo solicite.

Esta técnica permite que la maquinaria de estado, el mapeo de estados de 
configuraciones, la maquinaria de animación, la maquinaria de interpolación,
y la lógica específica relativa a cómo pintar cada frame para ser
completamente separados unos de otros.

Este enfoque es ampliamente aplicable. En Flutter, tipos básicos como
`Color` y `Shape` pueden ser interpolados, pero también pueden ser tipos mucho 
más elaborados como `Decoration`,` TextStyle` o `Theme`. Estos son
típicamente construidos a partir de componentes que pueden ser interpolados,
e interpolar los objetos más complicados es a menudo tan simple como
interpolación recursiva de todos los valores que describen los objetos 
complicados.

Algunos objetos interpolables están definidos por jerarquías de clase. Por ejemplo,
las formas están representadas por la interfaz `ShapeBorder`, y existe una
variedad de formas, incluyendo `BeveledRectangleBorder`,` BoxBorder`,
`CircleBorder`,` RoundedRectangleBorder` y `StadiumBorder`. Una sola 
función `lerp` no puede tener un conocimiento a priori de todos los tipos posibles,
y por lo tanto, la interfaz en su lugar define los métodos `lerpFrom` y` lerpTo`,
que son diferidos por el método estático `lerp` . Cuando se le dice a interpolar de
de una forma A a una forma B, primero se le pregunta a B si puede 'lerpFrom` de A, luego,
si no puede, a A se le pregunta si puede `lerpTo` B. (si ninguno de los dos es
posible, entonces la función devuelve A de valores de `t` menores que 0.5,
y devuelve B de lo contrario.)

Esto permite que la jerarquía de clases se amplíe arbitrariamente, con más 
adiciones posteriores capaces de interpolar entre valores conocidos previamente.
y ellos mismos.

En algunos casos, la interpolación en sí no puede ser descrita por ninguno de
las clases disponibles, y una clase privada se define para describir la
etapa intermedia. Este es el caso, por ejemplo, al interpolar
entre un `CircleBorder` y un` RoundedRectangleBorder`.

Este mecanismo tiene una ventaja adicional: puede manejar la interpolación
desde etapas intermedias hasta nuevos valores. Por ejemplo, a mitad de camino
una transición de círculo a cuadrado, la forma podría cambiarse una vez más,
haciendo que la animación necesite interpolar a un triángulo. Mientras que
la clase triangular puede `lerpFrom` la clase intermedia redondeada cuadrada,
La transición se puede realizar sin problemas.

# Conclusión

El eslogan de Flutter, "todo es un widget", gira en torno a la construcción
interfaces de usuario mediante la composición de widgets que, a su vez, se componen de
progresivamente más widgets básicos. El resultado de esta composición 
agresiva es un gran número de widgets que requieren algoritmos cuidadosamente
diseñados y estructuras de datos para procesar eficientemente.
Con un diseño adicional, estas estructuras de datos también facilitan a 
los desarrolladores crear listas de scroll infinitas que construyen
widgets bajo demanda conforme se hacen visibles.

---
**Notas al pie:**

<sup><a name="a1">1</a></sup> Para el layout, al menos. Puede ser revisado
  para pintar, para construir el árbol de accesibilidad si es necesario,
  y para hit testing si es necesario.

<sup><a name="a2">2</a></sup> La realidad, por supuesto, es un poco más.
  complicada. Algunos layouts implican dimensiones intrínsecas o medidas de 
  línea de base, que implican un paso adicional del subárbol relevante
  (El almacenamiento en caché agresivo se utiliza para mitigar el potencial de
  rendimiento en el peor de los casos). Estos casos, sin embargo, son sorprendentemente
  raros En particular, no se requieren dimensiones intrínsecas para los
  casos comunes de envoltura.

<sup><a name="a3">3</a></sup> Técnicamente, la posición del hijo no es
  parte de la geometría de este RenderBox y por lo tanto no es necesario que sea realmente
  calculado durante el layout. Muchos objetos renderizados posicionan implícitamente
  su único hijo en 0,0 relativo a su propio origen, que
  no requiere ningún cálculo o almacenamiento en absoluto. Algunos objetos de renderizado
  evitan calcular la posición de sus hijos hasta el último 
  momento posible (por ejemplo, durante la fase de pintado), para evitar 
  el cálculo en su totalidad si no se pintan posteriormente.

<sup><a name="a4">4</a></sup>  Existe una excepción a esta regla.
  Como se discutió en la sección [Creación de widgets bajo demanda] (# building-widgets-on-demand), 
  algunos widgets se pueden reconstruir como resultado de un cambio en las restricciones 
  del layout. Si un widget se marcó a si mismo como dirty por razones no relacionadas en
  el mismo frame que también se ve afectado por un cambio en las restricciones de layout,
  se actualizará dos veces. Esta construcción redundante se limita al
  widget en sí y no afecta a sus descendientes.

<sup><a name="a5">5</a></sup> Una clave es un objeto opaco opcionalmente
  asociado con un widget cuyo operador de igualdad se utiliza para influir
  el algoritmo de reconciliación.

<sup><a name="a6">6</a></sup>  Por accesibilidad, y para dar solicitudes 
  unos pocos milisegundos adicionales entre cuando se crea un widget y cuando
  aparece en la pantalla, el viewport crea (pero no pinta)
  widgets para unos cientos de píxeles antes y después de los widgets visibles.

<sup><a name="a7">7</a></sup>  Este enfoque fue primero popularizado por
  la biblioteca de Facebook React.

<sup><a name="a8">8</a></sup>  En la práctica, se permite el valor _t_
  para extenderse más allá del rango de 0.0-1.0, y lo hace para algunas curvas. por
  Por ejemplo, las curvas "elásticas" se sobrepasan brevemente para representar
  un efecto de rebote. La lógica de interpolación típicamente puede extrapolar
  pasado el inicio o el final según corresponda. Para algunos tipos, por ejemplo,
  cuando se interpolan colores, el valor _t_ se fija efectivamente a
  El rango de 0.0-1.0.
