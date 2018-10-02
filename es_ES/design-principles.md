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
intuidos a partir de experiencias pasadas con otras plataformas como la Web
y Android, algunos de los cuales se resumen a continuación.

Este documento es muy útil si quieres contribuir a Flutter, ya que esperamos que también sigas estas filosofías. Por favor, lee también nuestra [guía de estilo](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
para obtener pautas más específicas sobre cómo escribir código Dart para Flutter.


Revisión y comprobación de código
--------------------------------

Antes del check-in, se debe revisar el código de cada PR, incluyendo cosas como la existencia de una dependencia. Obtener una reseña significa que un colaborador regular de Flutter (alguien con acceso al commit) ha escrito un comentario diciendo "LGTM" en tu PR, y tú has respondido a todos sus comentarios. "LGTM" significa "Look Good To Me" ("Luce bien para mí"). 

La revisión del código sirve para muchos propósitos críticos. Hay un propósito obvio: detectar errores. Incluso los ingenieros más experimentados frecuentemente cometen errores que son detectados por la revisión de código. Pero también hay muchos otros beneficios de las revisiones de código:

 * Difunde el conocimiento entre el equipo. Como cada línea de código habrá sido leída por dos personas, es más probable que una vez que sigas adelante, alguien más entienda el código.

 * Te mantiene honesto. Sabiendo que alguien va a leer tu código, estas menos tentado de hacer mal código, tomando atajos en lugar de hacer un código legible.

 * Te expone a diferentes modos de pensar. Tu revisor de código probablemente no ha pensado en el problema de la misma manera que tú, y por lo tanto puede tener una perspectiva fresca y puede encontrar una mejor manera de resolver el problema.

Te recomendamos que consideres
[estas sugerencias](https://testing.googleblog.com/2017/06/code-health-too-many-comments-on-your.html)
para abordar los comentarios de revisión de código en tu PR.

Si estás realizando una gran modificación al código, no dudes en obtener revisiones antes de que estés listo para comprobar el código. Además, no dudes en pedir a varias personas que revisen tu código, y no dudes en proporcionar comentarios no solicitados sobre los PRs de otras personas. Cuantas más revisiones, mejor.

Los revisores deben leer cuidadosamente el código y asegurarse de que lo entienden. Un revisor debe revisar el código para ver si tiene sentido, por ejemplo, si la estructura del código tiene sentido, así como la legibilidad y la adherencia a la [guía de estilo flutter](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo).
Aplicar [usar estas mejores prácticas](https://mtlynch.io/human-code-reviews-1/)
cuando revises el código y envíes comentarios.

Los revisores no deben dar un LGTM a menos que el parche tenga pruebas que verifiquen todo el código afectado, o a menos que una prueba no tenga sentido. Si revisas un parche, estás compartiendo la responsabilidad del parche con su autor. Debes dar un LGTM sólo si te sientes seguro respondiendo preguntas sobre el código.

Un revisor puede en algunas circunstancias considerar el código satisfactorio sin haberlo revisado o entendido completamente. Si un revisor no ha revisado completamente el código, lo admite diciendo "RSLGTM" en lugar de "LGTM". Si sientes que tu código necesita una revisión real, por favor encuentra a alguien que realmente lo revise. "Si marcas un parche como RSLGTM, sigues compartiendo la responsabilidad del parche con su autor. Revisar un parche como RSLGTM debería ser un evento raro.
(RSLGTM : "Rubber stamp looks good to me", se usa cuando el revisor simplemente está otorgando la aprobación sin realizar una revisión de código adecuada.

Si realmente necesitas revisar algo a toda prisa, por ejemplo, porque todo está roto y puedes arreglarlo, entonces elige a alguien del equipo que quieras que revise el código, y luego marca al RP como "TBR" con su nombre. "("TBR" significa "To Be Reviewed".) Esto sólo debe usarse en emergencias. (¡No es una emergencia que no haya nadie alrededor para revisar tu parche de 50,000 líneas a la medianoche del 31 de diciembre!. Si alguien marca un parche como TBR y te nombra como revisor, debe revisar el parche lo antes posible. Si alguien marca un parche como TBR y te nombra revisor, los problemas deben solucionarse tan pronto como sea posible.

Espera a que Cirrus dé luz verde antes de hacer merge a un PR. Cirrus realiza un montón de comprobaciones previas (ver las pruebas para el
[framework](https://github.com/flutter/flutter/blob/master/dev/bots/test.dart),
los [engine](https://github.com/flutter/engine/blob/master/ci/build.sh),
y el sitio web).
!Estas comprobaciones incluyen comprobaciones de los comentarios, así que asegúrate de esperar la luz verde incluso si tu parche está _obviamente_ bien!

Para el repositorio del engine, Travis no compila realmente el engine, así que deberías asegurarse de hacerlo localmente antes de comprobar nada.

Asegúrate de que todos los árboles y tableros estén verdes antes de realizar el check-in:
la [infra waterfall](https://build.chromium.org/p/client.flutter/waterfall),
nuestro [Cirrus dashboard](https://cirrus-ci.com/github/flutter/flutter/master),
nuestro [test dashboard](https://flutter-dashboard.appspot.com/build.html), y
nuestro [benchmarks dashboard](https://flutter-dashboard.appspot.com/benchmarks.html) (Exclusivo de Google, lo sentimos).

**Si los árboles o los cuadros de mando muestran alguna regresión, sólo se permiten las correcciones que mejoren la situación.**


Manejo de breaking changes
-------------------------

Estamos tratando de estabilizar las APIs para los
[paquetes en el SDK](https://github.com/flutter/flutter/tree/master/packages).
Para hacer un cambio que requiera que los desarrolladores cambien su código:

 1. Crea un issue o crea un pull request con la etiqueta `prod: API break`.

 2. Envía un correo electrónico a <mailto:{{site.email}}> para socializar el cambio propuesto. El propósito de este correo electrónico es ver si puedes obtener consenso en torno a su cambio. **No le dices a la gente que el cambio ocurrirá, les pides permiso.**
    El correo electrónico debe incluir lo siguiente:

    - Una asunto que resuma claramente el cambio propuesto y suene como si fuera importante (para que la gente pueda detectar estos correos electrónicos entre el ruido). Ponle al asunto el prefijo `[Breaking Change]`.

    - Un resumen de cada cambio que propongas.

    - Una breve justificación del cambio.

    - Un enlace al asunto que presentaste en el paso 1, y a cualquier PR que ya hayas publicado relacionado con este cambio.

    - Aclara los pasos mecánicos para portar el código de la forma antigua a la forma nueva, si es posible. Si no es posible, sigue pasos claros para averiguar cómo portar el código.

    - Una propuesta sincera que ayude a portar el código que incluye el canal preferido para contactar a la persona que hizo el cambio.

    - Una solicitud para que la gente te notifique si este cambio va a ser un problema, tal vez discutiendo el cambio en el issue tracker o en el pull request.

 3. **Si la gente está de acuerdo en que los beneficios de cambiar la API superan los costos de estabilidad**, puedes continuar con el proceso normal de revisión de código para realizar cambios. Debes dejar algún tiempo entre los pasos 2 y 3 (como mínimo 24 horas durante la semana laboral para que la gente de todas las zonas horarias hayan tenido la oportunidad de verlo, pero lo ideal sería una semana más o menos).

 4. Si has conseguido un breaking change, añade un punto a la sección superior de la [página Changelog en la wiki](https://github.com/flutter/flutter/wiki/Changelog),
    describiendo tu cambio y enlazándolo a tu correo electrónico en [los archivos de la lista de correo](https://groups.google.com/forum/#!forum/flutter-dev).
    Para averiguar la versión correcta dirígete al changelog y ejecuta
    `git fetch upstream && flutter --version`. Por ejemplo, si dice “Flutter 0.0.23-pre.10” en la salida, tu entrada en el changelog debe estar bajo el encabezado “Changes since 0.0.22”.

En la medida de lo posible, incluso los “breaking” changes deben hacerse a modo de compatibilidad retroactiva, por ejemplo, introduciendo una nueva clase y marcando la antigua clase `@deprecated`. Al hacerlo, incluye una descripción de cómo realizar la transición en la notificación de depreciación, por ejemplo:

<!-- skip -->
```dart
@deprecated('FooInterface has been deprecated because ...; it is recommended that you transition to the new FooDelegate.')
class FooInterface {
/// ...
}
```

Si usas `@deprecated`, asegúrate de recordar eliminar realmente la funcionalidad unas semanas más tarde (después de la próxima versión beta), ¡no la dejes para siempre!


#### Responsabilidades exclusivas de Google

Si trabajas para Google, tienes la responsabilidad adicional de actualizar la copia interna de Flutter de Google y arreglar cualquier enlace roto a otros sitios web de forma razonablemente rápida después de realizar el merge de los cambios en el upstream.

Programación lazy
----------------

Escribe lo que necesites y nada más, pero cuando lo escribas, hazlo bien.

Evita implementar funciones que no necesites. No se puede diseñar una funcionalidad sin saber cuáles son las restricciones. La implementación de funcionalidades "por completar" resulta en código sin usar que es costoso de mantener, conocer, documentar, probar, etc.

Cuando implementes una funcionalidad, hazlo de la manera correcta. Evita los workarounds. Los workarounds no hacen más que agravar el problema, pero a un coste más elevado: alguien tendrá que volver a estudiar el problema, averiguar cómo solucionarlo y desmontarlo (y todos los lugares que ahora lo utilizan), e implementar la funcionalidad. Es mucho mejor tomarse más tiempo para arreglar un problema correctamente, que ser el que arregla todo rápidamente pero de una manera que requerirá de una posterior limpieza.

Es posible que escuches a los miembros del equipo decir "embrace the [yak
shave](http://www.catb.org/jargon/html/Y/yak-shaving.html)!". Esto es un estímulo para tomar el esfuerzo más grande necesario para realizar una solución adecuada para un problema en lugar de simplemente aplicar soluciones paliativas.


Pruebas
-----

**Escribe Pruebas, Encuentra Errores**

Cuando arregles un error, primero escribe una prueba que falle, luego arregla el error y verifica que la prueba pasa.

Cuando implementes una nueva característica, escribe pruebas para ella.


Documentación
-------------

Cuando trabajes en Flutter, si te encuentras haciendo una pregunta sobre nuestros sistemas, por favor coloca la respuesta que descubras en la documentación en el mismo lugar donde buscaste la respuesta por primera vez.

Tratamos de evitar la dependencia de la "tradición oral". Debería ser posible para cualquiera empezar a contribuir sin haber tenido que aprender todos los secretos de los actuales miembros del equipo. Para ello, todos los procesos deben estar documentados (normalmente en los wikis), el código debe ser auto explicativo o comentado, y las convenciones deben estar escritas, por ejemplo, en nuestra guía de estilo.

Hay una excepción: es mejor no documentar algo en nuestros documentos de la API que documentarlo pobremente. Esto se debe a que si no la documentas, sigue apareciendo en nuestra lista de cosas por documentar. Siéntete libre de eliminar la documentación que viole nuestra
[guía de estilo](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo),
para que vuelva a aparecer en la lista.


Diseño de APIs
----------

Hemos aprendido varias lecciones a lo largo de los años.

* No debe haber objetos que representen el estado real que reflejen algún estado de otra fuente, ya que son costosos de mantener. (El objeto `HTMLCollection` de la Web es un ejemplo de dicho objeto.) En otras palabras, **mantenga sólo una fuente de verdad**, y **no replique el estado real**.

* Los constructores getters deben ser eficientes (por ejemplo, sólo devolver un valor en caché o una tabla O(1) de búsqueda).  Si una operación es ineficiente, debe ser un método a cambio. p.e.g. `document.getForms()`, no `document.forms` (pasea por todo el árbol).

  - Las operaciones asíncronas costosas pueden ser representadas por futures. Un método puede iniciar el trabajo y devolver un future; un getter puede devolver un future correspondiente al trabajo en curso. Un getter no debe iniciar el trabajo y devolver el future, ya que los getters parecen idempotentes y sin efectos secundarios.

* No debería haber APIs que requieran completar sincrónicamente una operación costosa (por ejemplo, calcular un layout completo fuera de la fase de diseño). El trabajo costoso debe ser asincrónico.

* Utilizamos un framework diseñado por niveles, en el que cada nivel aborda un problema de alcance limitado y luego es utilizado por el siguiente nivel para resolver un problema de mayor envergadura. Esto es cierto tanto a un alto nivel (los widgets que se basan en la renderización se basan en el pintado) como a nivel de clases y métodos individuales (por ejemplo, en la librería de renderización, teniendo una clase para el clipping y una clase para la opacidad en lugar de una clase que haga las dos cosas a la vez).

  - Las APIs de conveniencia pertenecen a la capa superior a la que están simplificando.

  - Tener APIs dedicadas por razones de rendimiento está bien. Si una operación específica, por ejemplo, hacer clipping a un rectángulo redondeado, es costoso utilizando la API genérica pero podría ser implementada más eficientemente usando una API dedicada, en ese caso, una API dedicada es suficiente.

* Las APIs que fomentan las malas prácticas no deberían existir, p.e.g., `document.write()`, `innerHTML`, `insertAdjacentHTML()`, etc.

  - Es una mala práctica la manipulación de Strings para generar datos o código que posteriormente serán interpretados o analizados, ya que conduce a vulnerabilidades de inyección de código.

  - Si una operación es costosa, ese coste debe representarse en la API (por ejemplo, devolviendo un `Future` o un `Stream`). Evita proporcionar APIs que oculten el coste de las tareas.

* Las APIs de conveniencia que envuelven algún aspecto de un servicio de un entorno para su exposición en otro entorno (por ejemplo, exponer una API Android en Dart), deberían exponer/envolver la API completa, de modo que no haya abismos cognoscitivos a la hora de interactuar con ese servicio (en el que está bien usar la API expuesta hasta cierto punto, pero más allá de eso debe aprender todo sobre el servicio subyacente).

* Las APIs que envuelven los servicios subyacentes, pero impiden el acceso directo a la API subyacente (por ejemplo, cómo se expone Skia en `dart:ui`) deben exponer cuidadosamente sólo las mejores partes de la API subyacente. Esto puede requerir funcionalidades de refactorización para que sean más útiles. Puede significar el evitar exponer funcionalidades de conveniencia que se abstraen sobre operaciones costosas, a menos que haya una clara ganancia de rendimiento al hacerlo. Una superficie API más pequeña es más fácil de entender.

  - Es por eso que `dart:ui` no expone `Path.fromSVG()`: lo comprobamos, y es igual de rápido hacer ese trabajo directamente en Dart, así que no hay beneficio en exponerlo. De esta manera, evitamos los costes (las estructuras de API más grandes son más caras de mantener, documentar y probar, y suponen una carga de compatibilidad para la API subyacente).


Errores
----

Asígnate un error sólo cuando estés trabajando activamente en él. Si no estás trabajando en ello, déjalo sin asignar. No asignes errores a las personas a menos que sepas que van a trabajar en ello. Si te encuentras con errores asignados en los que no vas a trabajar en un futuro muy cercano, desasigna los errores para que otras personas se sientan facultadas para trabajar en ellos.

Puedes escuchar a los miembros del equipo referirse a "licking the cookie". Asignarse un error a sí mismo, o indicar que se va a trabajar en él, les dice a otros miembros del equipo que no lo solucionen. Si entonces no trabajas en ello inmediatamente, estás actuando como alguien que ha tomado una galleta, la ha lamido para no hacerla agradable a otras personas, y luego no se la ha comido de inmediato. Por otra parte, “unlicking the cookie” significa indicar al resto del equipo que no vas a trabajar en el error de inmediato, por ejemplo, desasignándote el error.

Registra los errores de cualquier cosa que encuentres y que necesites hacer. Cuando implementas algo, pero sabes que no está completo, registras errores por aquello que no has hecho. De esa manera, podemos seguir la pista de lo que todavía hay que hacer.


Regresiónes
-----------

Si un check-in ha causado una regresión en el árbol, retrocede el check-in (incluso si no es el tuyo) a menos que hacerlo lleve más tiempo que arreglar el error. Cuando el árbol se daña, ralentiza a todos los demás en el proyecto.


Si las cosas se estropean, la prioridad de todos los miembros del equipo debe ser ayudar al equipo a solucionar el problema. Alguien debe ser el dueño del tema y puede delegar responsabilidades a otros miembros del equipo. Una vez que se resuelva el problema, escribe un informe
[post-mortem](https://github.com/flutter/flutter/wiki/Postmortems).
 Los post-mortem son para documentar lo que salió mal y cómo evitar que el problema (y toda la clase de problemas como éste) se repita en el futuro. Los postmortem no se refieren en absoluto a la asignación de culpas.

No hay nada vergonzoso en cometer errores.


Preguntas
---------

Siempre está bien hacer preguntas. Nuestros sistemas son grandes, nadie será un experto en todos los sistemas.


Resolución de conflictos
-------------------

Cuando varios colaboradores no están de acuerdo en la dirección de un parche en particular o en la dirección general del proyecto, el conflicto debe resolverse mediante la comunicación. Las personas que no están de acuerdo deben reunirse, tratar de entender los puntos de vista de los demás y trabajar para encontrar un diseño que responda a las preocupaciones de todos.

Por lo general, esto es suficiente para resolver los problemas. Si no puedes llegar a un acuerdo, pidae consejo a un miembro senior del equipo.

Desconfía del acuerdo por agotamiento, en el que una persona argumenta un punto repetidamente hasta que otros participantes se rinden en interés de seguir adelante. No se trata de una resolución de conflictos, ya que no aborda las preocupaciones de todos. Desconfía del acuerdo por compromiso, en el que dos buenas soluciones competidoras se fusionan en una solución mediocre. Un conflicto se resuelve cuando los participantes están de acuerdo en que la solución final es mejor que todas las propuestas en conflicto. A veces la solución requiere más trabajo que cualquiera de las otras propuestas. Por favor, ve los comentarios anteriores donde introducimos la frase “embrace the yak shave”.


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