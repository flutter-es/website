---
title: Filosofía de Desarrollo Flutter
---

Flutter está escrito en base a algunos principios básicos que fueron en su mayoría
Intuitado a partir de experiencias pasadas con otras plataformas como la web.
y Android, algunos de los cuales se resumen a continuación.

Este documento es muy útil si desea contribuir a Flutter, como
Entonces esperamos que también sigas estas filosofías. Por favor lea también
nuestro [guía de 
estilo](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
para pautas más específicas con respecto a escribir código Dart para Flutter.


## Revisión de código y verificación de código.

Cada RP debe ser revisada por el código antes del check-in, incluyendo cosas como
rodando una dependencia. Obtener una revisión significa que un Flutter regular
colaborador (alguien con acceso comprometido) ha escrito un comentario diciendo
"LGTM" en su PR, y ha abordado todos sus comentarios. ("LGTM"
significa "Me parece bien".

La revisión del código tiene muchos propósitos críticos. Hay lo obvio
propósito: atrapar errores. Incluso los ingenieros más experimentados.
Con frecuencia cometen errores que son atrapados por la revisión de código. Pero hay
También muchos otros beneficios de las revisiones de código:

 * Difunde el conocimiento entre el equipo. Dado que cada línea de código será
   ha sido leído por dos personas, es más probable que una vez que te muevas
   en adelante, alguien más entenderá el código.

 * Te mantiene honesto. Sabiendo que alguien estará leyendo tu
   código, estás menos tentado a cortar esquinas y más motivado a
   escribe el código del que estás orgulloso.

 * Te expone a diferentes modos de pensar. Su revisor de código
   Probablemente no haya pensado en el problema de la misma manera que usted
   tener, y así tener una perspectiva nueva y encontrarle un mejor
   Manera de resolver el problema.

Te recomendamos que consideres
[estas sugerencias](https://testing.googleblog.com/2017/06/code-health-too-many-comments-on-your.html)
para abordar los comentarios de revisión de código en su PR.

Si estás trabajando en un gran parche, no dudes en obtener comentarios antes,
antes de que esté listo para verificar el código. Además, no dude en preguntar
varias personas para revisar su código, y no dude en proporcionar información no solicitada
comentarios sobre las relaciones públicas de otras personas. Cuantas más reseñas mejor.

Los revisores deben leer cuidadosamente el código y asegurarse de que entienden
eso. Un revisor debe verificar el código para las preocupaciones de alto nivel,
por ejemplo, si la estructura del código tiene sentido, así como
legibilidad y adherencia a la [Guía de estilo aleteo](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo).
Use [estas mejores prácticas](https://mtlynch.io/human-code-reviews-1/)
Al revisar el código y proporcionar comentarios.

Los revisores no deben dar un LGTM a menos que el parche tenga pruebas que verifiquen
todo el código afectado, o a menos que una prueba no tenga sentido. Si tu
revisa un parche, estás compartiendo la responsabilidad del parche con
su autor Solo debes dar un LGTM si te sientes confiado
respondiendo preguntas sobre el código.

Un revisor puede en algunas circunstancias considerar el código como satisfactorio.
sin haberlo revisado o comprendido en su totalidad. Si un revisor no tiene
Revisaron completamente el código, lo admiten al decir "RSLGTM" en lugar de
que sólo "LGTM". Si cree que su código necesita una revisión real, por favor
Encuentra a alguien que realmente lo revise. ("RSLGTM" significa "Sello de goma
Me parece bien ".) Si marca un parche como RSLGTM, todavía está
Compartiendo la responsabilidad del parche con su autor. Revisando un
parche como RSLGTM debería ser un evento raro.

Si realmente necesita comprobar algo en un apuro, por ejemplo
porque todo está roto y puedes arreglarlo, luego elige a alguien en
El equipo que desea que revise el código y luego marque el PR como
"TBR" con su nombre. ("TBR" significa "Para ser revisado".) Esto es solo para
ser utilizado en emergencias. (No hay nadie alrededor para revisar tus 50,000
el parche de línea a la medianoche del 31 de diciembre no es una emergencia!) Si
alguien marca un parche como TBR y da su nombre como revisor, usted
Debe revisar el parche lo antes posible. Si un revisor encuentra
problemas con un parche marcado como TBR, los problemas deben solucionarse lo antes posible
como sea posible.

Espere a que Cirrus le dé luz verde antes de fusionar un RP. Cirro
ejecuta un montón de verificaciones previas (vea las pruebas para el
[framework](https://github.com/flutter/flutter/blob/master/dev/bots/test.dart),
el [motor](https://github.com/flutter/engine/blob/master/ci/build.sh),
y el sitio web).
Estas verificaciones incluyen verificaciones en los comentarios, así que asegúrese de esperar a que
luz verde incluso si su parche es _obviamente_ bien!

Para el repositorio del motor, Travis
en realidad no construye el motor, por lo que debes asegurarte de hacerlo
que localmente primero también antes de registrar algo.

Asegúrese de que todos los árboles y tableros estén verdes antes de registrarse:
el [cascada infra](https://build.chromium.org/p/client.flutter/waterfall),
nuestro [Tablero de cirros](https://cirrus-ci.com/github/flutter/flutter/master),
nuestro [tablero de prueba](https://flutter-dashboard.appspot.com/build.html), and
nuestro [tablero de puntos de referencia](https://flutter-dashboard.appspot.com/benchmarks.html) (Google-only, sorry).

**Si los árboles o tableros muestran alguna regresión, solo corrige
Que mejoren la situación se les permite entrar.**

## Manejo de cambios de última hora.

Estamos intentando estabilizar las API para el
[paquetes en el SDK](https://github.com/flutter/flutter/tree/master/packages).
Para hacer un cambio que requerirá que los desarrolladores cambien su código:

 1. Archivo de un problema o crear una solicitud de extracción con el `severo: API break`
    etiqueta.

 2. Enviar un correo electrónico a <mailto:flutter-announce@googlegroups.com> socializar
    Su cambio propuesto. El propósito de este correo electrónico es ver si puede
    obtener consenso en torno a su cambio. ** No le estás diciendo a la gente que
    el cambio ocurrirá, usted les está pidiendo permiso. **
    El correo electrónico debe incluir lo siguiente:

    - Una línea de asunto que resume claramente el cambio propuesto y suena así
      asuntos (para que las personas puedan detectar estos correos electrónicos entre el ruido). Prefijo
      la línea de asunto con `[Cambio de ruptura]`.

    - Un resumen de cada cambio que usted proponga.

    - Una breve justificación del cambio.

    - Un enlace al problema que archivó en el paso 1, y cualquier RP que pueda tener
      publicado en relación con este cambio.

    - Pasos mecánicos claros para trasladar el código de la forma antigua a la nueva.
      forma, si es posible. Si no es posible, pasos claros para averiguar cómo
      portar el código.

    - Una oferta sincera para ayudar al código de puerto, que incluye el lugar preferido para
      contactando a la persona que hizo el cambio.

    - Una solicitud para que las personas le notifiquen si este cambio será un problema.
      quizás discutiendo el cambio en el rastreador de problemas en la solicitud de extracción.

 3. **Si la gente está de acuerdo en que los beneficios de cambiar la API superan a la estabilidad
    costos**, Puede continuar con el proceso normal de revisión de código para hacer
    cambios Debe dejar algo de tiempo entre los pasos 2 y 3 (como mínimo
    24 horas durante la semana laboral para que las personas en todas las zonas horarias hayan tenido una
    posibilidad de verlo, pero idealmente una semana más o menos).

 4. Si obtuviste un cambio de ruptura, agrega un punto de bala a la sección superior de
    la [Página de registro de cambios en la wiki](https://github.com/flutter/flutter/wiki/Changelog),
    describiendo su cambio y
    enlazando a su correo electrónico en [los archivos de la lista de correo](https://groups.google.com/forum/#!forum/flutter-dev).
    Para averiguar el rumbo de la versión correcta para la ejecución del registro de cambios
    `git fetch aguas arriba && flutter --version`. Por ejemplo, si dice
    "Flutter 0.0.23-pre.10" en la salida en la que debe estar su entrada de registro de cambios
    Título "Cambios desde 0.0.22".

Cuando sea posible, incluso los cambios de "ruptura" deben realizarse de forma compatible con versiones anteriores,
por ejemplo, introduciendo una nueva clase y marcando la clase antigua `@ deprecated`. Cuando
al hacer esto, incluya una descripción de cómo hacer la transición en el aviso de desaprobación, para
ejemplo:

<!-- skip -->
```dart
@Deprecated('FooInterface ha quedado en desuso porque ...; Se recomienda que hagas la transición al nuevo FooDelegate..')
class FooInterface {
  /// ...
}
```

Si usa `@ deprecated`, asegúrese de recordar eliminar realmente la función unos cuantos
Meses después (después del próximo lanzamiento estable), ¡no lo dejes para siempre!


### Responsabilidades solo de Google

Si trabajas para Google, tienes la responsabilidad adicional de actualizar Google
Copia interna de Flutter y reparación de cualquier sitio de llamada roto razonablemente rápido
después de fusionar el cambio aguas arriba.

## Errores

Solo asignate un error a ti mismo cuando estés trabajando activamente en ello. Si
No estás trabajando en ello, déjalo sin asignar. No asignar errores a
Personas a menos que sepan que van a trabajar en ello. Si tu encuentras
usted mismo con los errores asignados que no va a estar trabajando en
En un futuro muy cercano, desasigne el error para que otras personas se sientan
facultado para trabajar en ellos.

Es posible que escuche a los miembros del equipo referirse a "lamer la cookie". Asignando un
error para usted mismo, o indicando que trabajará en él,
le dice a otros en el equipo que no lo arreglen. Si luego no trabajas en ello
De inmediato, estás actuando como alguien que ha tomado una galleta.
lo lamí para que no fuera apetecible para otras personas, y luego no lo comí bien
lejos. Por extensión, "descomprimir la cookie" significa indicar a la
El resto del equipo que realmente no va a trabajar en el error
enseguida después de todo, por ejemplo por desasignar el error de ti mismo.

Archivo de errores para cualquier cosa que te encuentres que necesita hacer. Cuando tú
implementa algo pero sabe que no está completo, archiva los errores de lo que
no he hecho De esa manera, podemos hacer un seguimiento de lo que aún se necesita hacer.

## Regresiones

Si un check-in ha provocado una regresión en el tronco, restaure el
check-in (incluso si no es tuyo) a menos que hacerlo tomaría más tiempo
que arreglar el error. Cuando el tronco se rompe, ralentiza a todos
otra cosa en el proyecto.

Si las cosas se rompen, la prioridad de todos en el equipo debe ser
ayudando al equipo a solucionar el problema Alguien debería ser dueño del problema, y
pueden delegar responsabilidades a otros en el equipo. Una vez el
problema resuelto, escribe un
[post-mortem](https://github.com/flutter/flutter/wiki/Postmortems).
Los postmortems tratan de documentar lo que salió mal y cómo evitar la
problema (y toda la clase de problemas como él) de recurrente en
el futuro. Los postmortems no son enfáticamente sobre la asignación de la culpa.

No hay vergüenza en cometer errores.

## Preguntas

Siempre está bien hacer preguntas. Nuestros sistemas son grandes, nadie será
Un experto en todos los sistemas.

## La resolución de conflictos

Cuando varios contribuyentes no están de acuerdo en la dirección de un determinado
parche o la dirección general del proyecto, el conflicto debe ser
Resuelto por la comunicación. Las personas que no están de acuerdo deben reunirse,
tratar de entender los puntos de vista de los demás y trabajar para encontrar un diseño
que aborda las preocupaciones de todos.

Esto suele ser suficiente para resolver problemas. Si no puedes venir a un
acuerdo, solicite el consejo de un miembro de mayor rango del equipo.

Desconfíe del acuerdo por desgaste, donde una persona discute un punto repetidamente
hasta que otros participantes se den por vencidos por seguir adelante. Esto es
No resolución de conflictos, ya que no aborda las preocupaciones de todos. Sé cauteloso
de acuerdo por compromiso, donde se fusionan dos buenas soluciones de la competencia
en una solución mediocre. Se aborda un conflicto cuando los participantes.
acuerde que la solución final es mejor que todas las propuestas en conflicto.
A veces la solución es más trabajo que cualquiera de las propuestas. Por favor
vea los comentarios anteriores donde presentamos la frase "abrazar el afeitado de yak".

## Código de Conducta

Esta sección es la última sección de este documento porque debe ser
lo mas obvio. Sin embargo, también es el más importante.

Esperamos que los colaboradores de Flutter actúen profesionalmente y con respeto, y
Esperamos que nuestros espacios sociales sean ambientes seguros y dignos.

Específicamente:

* Respetar a las personas, sus identidades, su cultura y su trabajo.
* Se amable. Sé cortés. Se acogedor
* Escucha. Considerar y reconocer los puntos de la gente antes de responder.

En caso de que experimentes algo que te haga sentir incómodo en Flutter's
comunidad, por favor contacte a alguien en el equipo, por ejemplo
[Ian](mailto:ian@hixie.ch) o [Tim](mailto:timsneath@google.com). Lo haremos
no tolerar el acoso de nadie en la comunidad de Flutter, incluso fuera
De los canales de comunicación pública de Flutter.
