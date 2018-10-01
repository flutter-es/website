---
layout: page
title: Filosofía de Desarrollo de Flutter

permalink: /design-principles/
---

* TOC Placeholder
{:toc}

Introducción
------------

Flutter está escrito sobre la base de algunos principios básicos que fueron en su mayoría
intuido a partir de experiencias pasadas con otras plataformas como la Web
y Android, algunos de los cuales se resumen a continuación.

Este documento es muy útil si quieres contribuir a Flutter, ya que esperamos que también sigas estas filosofías. Por favor, lee también nuestra [guía de estilo](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
para obtener pautas más específicas sobre cómo escribir código Dart para Flutter.


Revisión y comprobación de código
--------------------------------

Cada PR se debe revisar su código antes del check-in, incluyendo cosas como
que se extiende una dependencia. Recibir una revisión significa que un contribuidor habitual de Flutter(alguien con acceso a commit) haya escrito un comentario diciendo "LGTM" en su PR, y usted se ha hecho eco de todos sus comentarios. ("LGTM"
significa "Se ve bien para mí".)

La revisión del código sirve para muchos propósitos críticos. Hay un propósito obvio: detectar errores. Incluso los ingenieros más experimentados frecuentemente cometen errores que son detectados por la revisión de código. Pero también hay muchos otros beneficios de las revisiones de código:

 * Difunde el conocimiento entre el equipo. Como cada línea de código habrá sido leída por dos personas, es más probable que una vez que usted siga adelante, alguien más entienda el código.

 * Te mantiene honesto. Sabiendo que alguien va a leer tu código, estas menos tentado de hacer mál código, tomando atajos en lugar de hacer un código legible.

 * Te expone a diferentes modos de pensar. Tu revisor de código probablemente no ha pensado en el problema de la misma manera que tú, y por lo tanto puede tener una perspectiva fresca y puede encontrar una mejor manera de resolver el problema.

Te recomendamos que consideres
[estas sugerencias](https://testing.googleblog.com/2017/06/code-health-too-many-comments-on-your.html)
para abordar los comentarios de revisión de código en tu PR.

Si estás trabajando en un código grande, no dudes en obtener revisiones antes de que estés listo para comprobar el código. Además, no dude en pedir a varias personas que revisen tu código, y no dude en proporcionar comentarios no solicitados sobre los PRs de otras personas. Cuantas más revisiones, mejor.

Los revisores deben leer cuidadosamente el código y asegurarse de que lo entienden. Un revisor debe revisar el código para ver si tiene sentido, por ejemplo, si la estructura del código tiene sentido, así como la legibilidad y la adherencia a la [guía de estilo flutter](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo).
Aplicar [las mejores prácticas](https://mtlynch.io/human-code-reviews-1/)
al revisar el código y proporcionar comentarios.

Los revisores no deben dar un LGTM a menos que el parche tenga pruebas que verifiquen todo el código afectado, o a menos que una prueba no tenga sentido. Si revisas un parche, estás compartiendo la responsabilidad del parche con su autor. Usted sólo debe dar un LGTM si se siente seguro respondiendo preguntas sobre el código.

Un revisor puede en algunas circunstancias considerar el código satisfactorio sin haberlo revisado o entendido completamente. Si un revisor no ha revisado completamente el código, lo admite diciendo "RSLGTM" en lugar de "LGTM". Si usted siente que su código necesita una revisión real, por favor encuentre a alguien que realmente lo revise. "Si marcas un parche como RSLGTM, sigues compartiendo la responsabilidad del parche con su autor. Revisar un como RSLGTM debería ser un evento raro.

Si realmente necesitas revisar algo a toda prisa, por ejemplo porque todo está roto y puedes arreglarlo, entonces elige a alguien del equipo que quieras que revise el código, y luego marca al RP como "TBR" con su nombre. "("TBR" significa "Para revisión".) Esto sólo debe usarse en emergencias. (¡Nadie que esté cerca para revisar su parche de 50,000 líneas a la medianoche del 31 de diciembre no es una emergencia! Si alguien marca un parche como TBR y da su nombre como revisor, debe revisar el parche lo antes posible. Si un revisor encuentra problemas con un parche marcado TBR, los problemas deben solucionarse tan pronto como sea posible. como sea posible.

Espere a que Cirrus dé luz verde antes de fusionar un PR. Cirrus realiza un montón de comprobaciones previas (ver las pruebas para el
[framework](https://github.com/flutter/flutter/blob/master/dev/bots/test.dart),
los [engine](https://github.com/flutter/engine/blob/master/ci/build.sh),
y el sitio web).
Estas comprobaciones incluyen comprobaciones de los comentarios, así que asegúrese de esperar la luz verde incluso si su parche está _obviamente_ bien!

Para el repositorio de motores, Travis no construye realmente el motor, así que debería asegurarse de hacerlo localmente antes de comprobar nada.

Asegúrate de que todos los árboles y tableros estén verdes antes de realizar el check-in:
la [infra waterfall](https://build.chromium.org/p/client.flutter/waterfall),
nuestro [Cirrus dashboard](https://cirrus-ci.com/github/flutter/flutter/master),
nuestro [test dashboard](https://flutter-dashboard.appspot.com/build.html), y
nuestro [benchmarks dashboard](https://flutter-dashboard.appspot.com/benchmarks.html) (Sólo Google, lo sentimos).

**Si los árboles o cuadros de mando muestran alguna regresión, sólo se permiten las correcciones que mejoren la situación..**


Manejo de los cambios de rotura
-------------------------

Estamos tratando de establecer las APIs para el
[packages in the SDK](https://github.com/flutter/flutter/tree/master/packages).
Para hacer un cambio que requiera que los desarrolladores cambien su código:

 1. Archivar un problema o crear una solicitud de extracción con la etiqueta `prod: API break`.

 2. Envíe un correo electrónico a <mailto:{{site.email}}> para socializar el cambio propuesto. El propósito de este correo electrónico es ver si puede obtener consenso en torno a su cambio. **No le dices a la gente que el cambio ocurrirá, les pides permiso.**
    El correo electrónico debe incluir lo siguiente:

    - Una línea de asunto que resuma claramente el cambio propuesto y suene como si fuera importante (para que la gente pueda detectar estos correos electrónicos entre el ruido)). Póngale un prefijo a la línea de asunto con `[Breaking Change]`.

    - Un resumen de cada cambio que proponga.

    - Una breve justificación del cambio.

    - Un enlace al asunto que presentó en el paso 1, y a cualquier RP que ya haya publicado en relación con este cambio..

    - Aclare los pasos mecánicos para transferir el código del formulario antiguo al nuevo, si es posible. Si no es posible, pasos claros para averiguar cómo portar el código.

    - Una oferta sincera de colaboración con el código del puerto, que incluye el lugar preferido para ponerse en contacto con la persona que hizo el cambio.

    - Una solicitud para que la gente le notifique si este cambio será un problema, tal vez discutiendo el cambio en el rastreador de problemas en la solicitud de pull.

 3. **ISi la gente está de acuerdo en que los beneficios de cambiar la API superan los costos de estabilidad**, puede continuar con el proceso normal de revisión de código para realizar cambios. Debe dejar algún tiempo entre los pasos 2 y 3 (como mínimo 24 horas durante la semana laboral para que la gente de todas las zonas horarias haya tenido la oportunidad de verlo, pero lo ideal sería una semana más o menos).

 4. Si ha conseguido un cambio de ruptura, añada un punto a la sección superior de la sección de [Página de registro de cambios en el wiki](https://github.com/flutter/flutter/wiki/Changelog),
    describiendo su cambio y enlazando a su correo electrónico en [los archivos de la lista de correo](https://groups.google.com/forum/#!forum/flutter-dev).
    Para averiguar el título de la versión correcta para la ejecución del registro de cambios
    `git fetch upstream && flutter --version`. Por ejemplo, si dice
    "Flutter 0.0.23-pre.10" en la salida su entrada en el registro de cambios debe estar bajo el encabezado "Changes since 0.0.22".

En la medida de lo posible, incluso los cambios de "ruptura" deben hacerse de forma compatible con el pasado, por ejemplo, introduciendo una nueva clase y marcando la clase antigua. `@deprecated`. Al hacerlo, incluya una descripción de cómo realizar la transición en la notificación de deprecación, por ejemplo:

<!-- skip -->
```dart
@Deprecated('FooInterface ha sido descontinuada porque ...; se recomienda que haga la transición a la nueva FooDelegate.')
class FooInterface {
  /// ...
}
```

Si utiliza `@deprecated`, asegúrate de recordar quitar la característica unas semanas después (después de la próxima versión beta), ¡no la dejes para siempre!


#### Responsabilidades exclusivas de Google

Si trabajas para Google, tienes la responsabilidad añadida de actualizar la copia interna de Google de Flutter y de arreglar cualquier sitio de llamadas interrumpidas con una rapidez razonable después de fusionar los cambios en el flujo ascendente.

Programación perezosa
----------------

Escribe lo que necesites y nada más, pero cuando lo escribas, hazlo bien.

Evitar la implementación de funciones que no necesita. No se puede diseñar una característica sin saber cuáles son las restricciones. La implementación de características "para completar" resulta en código sin usar que es costoso de mantener, conocer, documentar, probar, etc.

Cuando implemente una característica, impleméntela de la manera correcta. Evite las soluciones alternativas. Las soluciones alternativas no hacen sino agravar el problema más adelante, pero a un coste mayor: alguien tendrá que volver a aprender el problema, averiguar cómo solucionarlo y desmontarlo (y todos los lugares que ahora lo utilizan), y_implementar la característica. Es mucho mejor tardar más tiempo en arreglar un problema correctamente, que ser el que lo arregla todo rápidamente, pero de una manera que requerirá una limpieza posterior.

Es posible que escuche a los miembros del equipo decir "embrace the [yak
shave](http://www.catb.org/jargon/html/Y/yak-shaving.html)!". Esto es un estímulo para tomar el esfuerzo más grande necesario para realizar una solución adecuada para un problema en lugar de simplemente aplicar una tirita.


Tests
-----

**Escribir Test, encontrar errores**

Cuando arregle un error, primero escriba una prueba que falle, luego arregle el error y verifique que la prueba pase.

Cuando implemente una nueva característica, escriba Test para ella.


Documentación
-------------

Cuando trabaje en Flutter, si te encuentra haciendo una pregunta sobre nuestros sistemas, por favor coloca cualquier respuesta que descubra posteriormente en la documentación en el mismo lugar donde buscó la respuesta por primera vez.

Tratamos de evitar la dependencia de la "tradición oral". Debería ser posible para cualquiera empezar a contribuir sin haber tenido que aprender todos los secretos de los miembros existentes del equipo. Para ello, todos los procesos deben estar documentados (normalmente en los wikis), el código debe ser autoexplicativo o comentado, y las convenciones deben estar escritas, por ejemplo, en nuestra guía de estilo.

Hay una excepción: es mejor _no_documentar algo en nuestros documentos de la API que documentarlo mal. Esto se debe a que si usted no lo documenta, todavía aparece en nuestra lista de cosas a documentar. Siéntase libre de eliminar la documentación que viole nuestras
[guía de estilo](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo),
para que reaparezca en la lista.


Diseño de APIs
----------

Hemos aprendido varias lecciones a lo largo de los años.

* No debe haber objetos que representen estado vivo que reflejen algún estado de otra fuente, ya que su mantenimiento es costoso. (El objeto `HTMLCollection` de la Web es un ejemplo de tal objeto.) En otras palabras, **mantenga sólo una fuente de verdad**, y **no replique el estado vivo**.

* Las propiedades getters deben ser eficientes (por ejemplo, sólo devolver un valor de caché, o una búsqueda de tabla O(1)). Si una operación es ineficiente, debería ser un método en su lugar. e.g. `document.getForms()`, no `document.forms` (camina por todo el árbol).

  - La operación asincrónica costosa puede ser representada por futuros. Un método puede iniciar el trabajo y devolver un futuro; un getter puede devolver un futuro correspondiente al trabajo en curso. Un getter no debe iniciar el trabajo y devolver el futuro, ya que los getters parecen idempotentes y sin efectos secundarios.

* No debería haber APIs que requieran completar sincrónicamente una operación costosa (por ejemplo, calcular un diseño de aplicación completo fuera de la fase de diseño). El trabajo caro debe ser asincrónico.

* Utilizamos un diseño de estructura por capas, en el que cada capa aborda un problema con un alcance limitado y luego es utilizada por la siguiente capa para resolver un problema mayor. Esto es cierto tanto a un alto nivel (los widgets dependen de la renderización dependiendo del cuadro) como a nivel de clases y métodos individuales (por ejemplo, en la biblioteca de renderización, tener una clase para el recorte y una clase para la opacidad en lugar de una clase que haga ambas cosas al mismo tiempo).

  - Las APIs de conveniencia pertenecen a la capa superior a la que están simplificando.

  - Tener APIs dedicadas por razones de rendimiento está bien. Si una operación específica, por ejemplo, recortar un rectángulo redondeado, es costosa utilizando la API genérica pero podría implementarse más eficientemente utilizando una API dedicada, entonces una API dedicada está bien.

* No deben existir API que fomenten las malas prácticas. e.g. no
  `document.write()`, `innerHTML`, `insertAdjacentHTML()`, etc.

  - La manipulación de cadenas para generar datos o código que posteriormente serán interpretados o analizados es una mala práctica, ya que conduce a vulnerabilidades de inyección de código.

  - Si una operación es cara, ese gasto debe ser representado en la API (por ejemplo, devolviendo un `Future` o un `Stream`).  Evite proporcionar APIs que oculten el gasto de las tareas.

* Las APIs de conveniencia que envuelven algún aspecto de un servicio de un entorno para su exposición en otro entorno (por ejemplo, exponer una API Android en Dart), deberían exponer/envolver la API completa, de modo que no haya obstáculos cognoscitivos a la hora de interactuar con ese servicio (en el que está bien usar la API expuesta hasta cierto punto, pero más allá de eso tiene que aprender todo sobre el servicio subyacente).

* Las APIs que envuelven los servicios subyacentes pero impiden el acceso directo a la API subyacente (por ejemplo, cómo `dart:ui` expone a Skia) deben exponer cuidadosamente sólo las mejores partes de la API subyacente. Esto puede requerir características de refactorización para que sean más utilizables. Puede significar evitar exponer características de conveniencia que se abstraen sobre operaciones costosas a menos que haya una clara ganancia de rendimiento al hacerlo. Una superficie API más pequeña es más fácil de entender.

  - Es por eso que `dart:ui` no expone `Path.fromSVG()`: lo comprobamos, y es igual de rápido hacer ese trabajo directamente en Dart, así que no hay beneficio en exponerlo. De esta manera, evitamos los costes (las estructuras de API más grandes son más caras de mantener, documentar y probar, y suponen una carga de compatibilidad para la API subyacente).


Bugs
----

Asigne un error a sí mismo sólo cuando esté trabajando activamente en él. Si no estás trabajando en ello, déjalo sin asignar. No asigne bugs a personas a menos que sepa que ellos van a trabajar en ello. Si se encuentra con errores asignados en los que no va a trabajar en un futuro muy cercano, desasigne el error para que otras personas se sientan capacitadas para trabajar en ellos.

Se puede escuchar a los miembros del equipo referirse a "lamer la galleta". Asignarse un error a sí mismo, o indicar que se va a trabajar en él, les dice a otros miembros del equipo que no lo solucionen. Si entonces no trabajas en ello inmediatamente, estás actuando como alguien que ha tomado una galleta, la ha lamido para no atraer a otras personas, y luego no se la ha comido de inmediato. Por extensión, "desclasificar la cookie" significa indicar al resto del equipo que no vas a trabajar en el error. inmediatamente después de todo, por ejemplo, desasignando el error de usted mismo.

Archive los errores de cualquier cosa que encuentre que necesite hacer. Cuando implementa algo pero sabe que no está completo, archive los errores por lo que no ha hecho. De esa manera, podemos seguir la pista de lo que todavía hay que hacer.


Regresiónes
-----------

Si un check-in ha causado una regresión en el tablero, retroceda el check-in (incluso si no es el suyo) a menos que hacerlo lleve más tiempo que arreglar el error. Cuando el enlace se rompe, ralentiza a todos los demás en el proyecto.


Si las cosas se rompen, la prioridad de todos en el equipo debe ser ayudar al equipo a solucionar el problema. Alguien debe ser el dueño del tema y puede delegar responsabilidades a otros miembros del equipo. Una vez resuelto el problema, escriba un
[post-mortem](https://github.com/flutter/flutter/wiki/Postmortems).
Las post-mortem son para documentar lo que salió mal y cómo evitar que el problema (y toda la clase de problemas como éste) se repita en el futuro. Los post-mortem enfáticamante no son sobre la asignación de culpas.

No hay nada vergonzoso en cometer errores.


Preguntas
---------

Siempre está bien hacer preguntas. Nuestros sistemas son grandes, nadie será un experto en todos los sistemas.


Resolución de conflictos
-------------------

Cuando varios colaboradores no están de acuerdo en la dirección de un parche en particular o en la dirección general del proyecto, el conflicto debe resolverse mediante la comunicación. Las personas que no están de acuerdo deben reunirse, tratar de entender los puntos de vista de los demás y trabajar para encontrar un diseño que responda a las preocupaciones de todos.

Por lo general, esto es suficiente para resolver los problemas. Si no puede llegar a un acuerdo, pida consejo a un miembro más veterano del equipo.

Desconfíe del acuerdo por desgaste, en el que una persona argumenta un punto repetidamente hasta que otros participantes se rinden en interés de seguir adelante. No se trata de una resolución de conflictos, ya que no aborda las preocupaciones de todos. Desconfíe del acuerdo por compromiso, en el que dos buenas soluciones competidoras se fusionan en una solución mediocre. Un conflicto se aborda cuando los participantes están de acuerdo en que la solución final es _mejor_ que todas las propuestas en conflicto. 
A veces la solución es más trabajo que cualquiera de las dos propuestas. Por favor, consulte los comentarios anteriores donde introducimos la frase "embrace the yak shave".


Código de conducta
---------------

Esta sección es la última sección de este documento porque debería ser la más obvia. Sin embargo, también es el más importante.

Esperamos que los colaboradores de Flutter actúen de manera profesional y respetuosa, y esperamos que nuestros espacios sociales sean ambientes seguros y dignos.

Específicamente:

* Respeta a las personas, sus identidades, su cultura y su trabajo.
* Sé amable. Sé cortés. Sé acogedor.
* Escucha. Considera y reconoce los puntos de vista de las personas antes de responder.

Si experimentas algo que te hace sentir mal recibido en la comunidad de Flutter, por favor contacta con alguien del equipo, por ejemplo
[Ian](mailto:ian@hixie.ch) o [Tim](mailto:timsneath@google.com). No toleraremos el acoso de nadie en la comunidad de Flutter, ni siquiera fuera de los canales de comunicación pública de Flutter.