---
layout: page
title: JSON y serialización
permalink: /json/
---

Es difícil imaginar una aplicación móvil que no necesite comunicarse con un 
web server o que no tenga que almacenar fácilmente datos estructurados en algún 
momento. Cuando creamos apps conectadas a la red, lo más probable es que tengas que 
consumir algún JSON, tarde o temprano.

Esta guía va sobre las maneras de usar JSON con Flutter. Cubre que 
solución JSON usar en diferentes escenarios, y porqué.

<aside class="alert alert-info" markdown="1">
**Terminología:** _Codificar_ y _serializar_ son la misma cosa&mdash;convertir 
una estructura de datos en una cadena de texto. _Descodificar_ y _deserializar_ son el 
proceso opuesto&mdash;convertir una cadena en una estructura de datos.
Sin embargo, la _serialización_ también se refiere comúnmente a todo el proceso de 
trasladar estructuras de datos hacia y desde un formato más fácil de leer.

Para evitar confusiones, este documento usa "serialización" cuando se hace referencia al 
proceso general, y "codificar" y "descodificar" cuando se hace referencia específicamente 
a estos procesos.
</aside>

* TOC Placeholder
{:toc}

## ¿Cual método de serialización JSON es el adecuado para mí?

Este artículo cubre dos estrategias generales para trabajar con JSON:

* Serialización manual
* Serialización automática usando auto-generación de código

Diferentes proyectos tienen diferente complejidad y casos de uso. Para proyectos 
pequeños de prueba de concepto o prototipos rápidos, usar auto-generación de código puede ser
exagerado. Para apps con varios modelos JSON con más complejidad, codificar 
a mano puede volverse rápidamente tedioso, repetitivo, y se presta a muchos 
pequeños errores.

### Usar serialización manual para pequeños proyectos

La decodificación manual de JSON se refiere a usar el decodificador JSON incluido en 
`dart:convert`. Esto implica pasar una cadena JSON en bruto a el método `json.decode()` 
, y luego buscar los valores que necesita en el `Map<String, dynamic>` que devuelve el 
método. Esto no tiene dependencias externas ni un proceso de configuración, 
y esto es bueno para una prueba de concepto rápida.

La decodificación manual no funciona bien cuando su proyecto se hace más grande. 
Escribir lógica de decodificación a mano puede convertirse en difícil de manejar 
y ser propenso a errores.
Si tienes un error tipográfico accediendo a un campo inexistente del JSON, tu 
código lanzará un error en tiempo de ejecución.

Si no tienes muchos modelos JSON en tu proyecto y estás buscando probar un 
concepto rápidamente, la serialización manual puede ser el camino por él que empezar.
Para un ejemplo de codificación manual, mira
[Serialización manual de JSON usando dart:convert](#manual-encoding).

### Usar auto-generación de código para proyectos medianos o grandes

La serialización JSON con auto-generación de código significa tener una biblioteca externa 
que genera el _boilerplate_ de codificación para tí. 
Después de alguna configuración inicial,
ejecutas un _file watcher_ que genera el código para las clases de tu modelo.
Por ejemplo,
[json_serializable](https://pub.dartlang.org/packages/json_serializable) y
[built_value](https://pub.dartlang.org/packages/built_value)
son de este tipo de bibliotecas.

Esta aproximación escala mejor para un proyecto grande. Ningún _boilerplate_ 
escrito a mano es necesario, y los errores tipográficos cuando se accede 
a los campos del JSON son capturados en tiempo de compilación. 
La desventaja con la auto-generación de código es que esta necesita alguna 
configuración inicial. También, el fichero fuente generado puede producir 
desorden visual en tu navegador del proyecto.

Es posible que desees usar auto-generación de código para serializar JSON 
cuando tengas proyectos medianos o grandes. Para ver un ejemplo de auto-generación 
de código basada en codificación de JSON, mira
[Serializar un JSON usando bibliotecas de auto-generación](#code-generation).

## Hay algo equivalente a GSON/Jackson/Moshi en Flutter?

La respuesta simple es no.

Estas librerías necesitarían usar reflexión en tiempo de ejecución, que está desactivada en 
Flutter. La reflexión en tiempo de ejecución interfiere con _tree shaking_, que es soportado 
por Dart desde hace bastante tiempo. Con _tree shaking_, puedes hacer “shake off” del 
código no utilizado de tus release builds. Esto optimiza significativamente el tamaño de la app.

Como la reflexión hace que todo el código se usado de forma implícita por defecto, esto hace 
el tree shaking difícil. La herramientas no pueden conocer que partes del código no son usadas 
en tiempo de ejecución, entonces es difícil eliminar el código redundante. El tamaño de la app 
no puede ser fácilmente optimizado cuando se usa reflexión.

<aside class="alert alert-info" markdown="1">
**¿Qué hay acerca de dartson?**

La biblioteca [dartson](https://pub.dartlang.org/packages/dartson) usa reflexión en tiempo 
de ejecución, lo que la hace incompatible con Flutter.
</aside>

Aunque no puedes usar reflexión en tiempo de ejecución con Flutter, algunas bibliotecas te dan 
APIs similares, fáciles de usar, pero están basadas en auto-generación de código en su lugar. Esta 
aproximación es cubierta con más detalle en la sección [bibliotecas de auto-generación de código](#code-generation).

<a name="manual-encoding"></a>
## Serialización manual de JSON usando dart:convert

La codificación básica de un JSON es muy simple en Flutter. Flutter tiene la biblioteca 
`dart:convert` que incluye un sencillo codificador y decodificador JSON.

Aquí hay un ejemplo de un JSON para un modelo sencillo.

```json
{
  "name": "John Smith",
  "email": "john@example.com"
}
```

Con `dart:convert`, puedes codificar este modelo JSON de dos maneras.

### Serializar un JSON en línea

Mirando en [la documentación JSON de dart:convert](https://api.dartlang.org/stable/dart-convert/JsonCodec-class.html), verás que puedes decodificar el JSON llamando al método `json.decode`,
con la cadena JSON como argumento del método.

<!-- skip -->
```dart
Map<String, dynamic> user = json.decode(json);

print('Howdy, ${user['name']}!');
print('We sent the verification link to ${user['email']}.');
```

Desafortunadamente, `json.decode()` simplemente devuelve un `Map<String, dynamic>`, significando 
que no conoces los tipos de valores hasta el tiempo de ejecución. Con esta aproximación, 
pierdes la mayoría de las características del tipado estático del lenguaje: seguridad de tipos,
autocompletado y mucho más importante, las excepciones en tiempo de compilación. Tu código 
será más propenso a los errores instantáneamente.

Por ejemplo, cuando accedes a los campos `name` o `email`, podrías rápidamente 
introducir un error tipográfico. Un error tipográfico que el compilador no conoce 
desde que el JSON vive en una estructura de mapa.

### Serializar un JSON en una clase modelo

Combate los problemas mencionados previamente introduciendo una clase de modelo plana, 
llamada `User` en este ejemplo. Dentro de la clase `User`, encontrarás:

* Un constructor `User.fromJson`, para construir una nueva instancia de `User` desde una 
  estructura de mapa.
* Un método `toJson`, que convierte una instancia `User` en un mapa.

Con esta aproximación, el _calling code_, puede tener seguridad de tipos, 
autocompletado para los campos `name` y `email`, y excepciones en tiempo de compilación.
Si cometes errores tipográficos o tratas los campos como `int` en lugar de `String`,
la app no compilará, en lugar de fallar en tiempo de ejecución.

**user.dart**

<!-- skip -->
```dart
class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() =>
    {
      'name': name,
      'email': email,
    };
}
```

La responsabilidad de la lógica de decodificación esta ahora situada dentro del propio modelo. 
Con esta aproximación, puedes decodificar un usuario fácilmente.

<!-- skip -->
```dart
Map userMap = json.decode(json);
var user = new User.fromJson(userMap);

print('Howdy, ${user.name}!');
print('We sent the verification link to ${user.email}.');
```

Para codificar un usuario, pasa el objeto `User` al método `json.encode`.
No necesitas llamar al método `toJson`, porque `json.encode`
ya hace esto por ti.

<!-- skip -->
```dart
String json = json.encode(user);
```

Con esta aproximación, el código _llamable_ no tiene que preocuparse acerca de la 
serialización JSON para nada. Sin embargo, la clase modelo definitivamente debe hacerlo.
En una app en producción, querrás asegurarte que la serialización trabaja correctamente. 
En la práctica, los métodos `User.fromJson` y `User.toJson` 
necesitan ambos tener test unitarios para verificar un comportamiento correcto.

Sin embargo, los escenarios del mundo real no son normalmente tan simples.
Es poco probable que use respuestas JSON tan pequeñas.
También se usan habitualmente Objetos JSON anidados.

Sería bueno que hubiese algo que manejar la codificación y decodificación JSON por ti. 
Afortunadamente, ¡lo hay!

<a name="code-generation"></a>
## Serializar JSON usando librerías de auto-generación de código

Aunque hay otras bibliotecas disponibles, esta guía usa el 
[paquete json_serializable](https://pub.dartlang.org/packages/json_serializable),
un generador de código automatizado que genera el _boilerplate_ del JSON serializado por ti.

Dado que el código de serialización no esta más, escrito ni mantenido manualmente, 
minimizas el riesgo de tener excepciones por la serialización JSON en tiempo de ejecución.

### Configurando json_serializable en un proyecto

Para incluir `json_serializable` en tu proyecto, necesitas una dependencia regular, 
y dos _dev dependencies_. Abreviando, _dev dependencies_
son dependencias que no están incluidas en el código fuente de tu app&mdash;estas 
solo son usadas en el entorno de desarrollo.

Las últimas versiones de estas dependencias requeridas pueden verse 
en el siguiente [fichero pubspec](https://raw.githubusercontent.com/dart-lang/json_serializable/master/example/pubspec.yaml)
en el ejemplo de serialización JSON.

**pubspec.yaml**

```yaml
dependencies:
  # Tus otras dependencias regulares aquí
  json_annotation: ^0.2.3

dev_dependencies:
  # Tus otras dev_dependencies aquí
  build_runner: ^0.9.0
  json_serializable: ^0.5.4
```

Ejecuta `flutter packages get` dentro de la carpeta raíz de tu proyecto (o haz clic
en **Packages Get** en tu editor) para hacer estas nuevas dependencias diponibles 
en tu proyecto.

### Creando las clases del modelo a la manera de json_serializable

Lo siguiente muestra como convertir una clase `User` en una clase `json_serializable`. 
En aras de la simplicidad, este código usa el modelo JSON simplificado de los ejemplos 
previos.

**user.dart**

<!-- skip -->
{% prettify dart %}
import 'package:json_annotation/json_annotation.dart';

/// Esto permite a la clase `User` acceder a las propiedades privadas 
/// en el fichero generado. El valor para esto es *.g.dart, donde 
/// el asterisco denota el nombre del fichero fuente.
part '[[highlight]]user[[/highlight]].g.dart';

/// Una anotación para el auto-generador de código para que sepa que en esta clase
/// necesita generarse lógica de serialización JSON.
[[highlight]]@JsonSerializable()[[/highlight]]

/// Todas las clases json_serializable deben tener el serializer mixin.
/// Esto hace que sea usable el método toJson() para la clase.
/// Los nombres de los mixin siguen al de la clase fuente, en este caso, User.
class User extends Object with _$[[highlight]]User[[/highlight]]SerializerMixin {
  User(this.name, this.email);

  String name;
  String email;

  /// Un método constructor de tipo factory es necesario para crear una nueva instancia User
  /// desde un mapa. Pasa el mapa al constructor auto-generado _$UserFromJson.
  /// El constructor es nombrado después de la clase fuente, en este caso User.
  factory User.fromJson(Map<String, dynamic> json) => _$[[highlight]]User[[/highlight]]FromJson(json);
}
{% endprettify %}

Con esta configuración, el auto-generador de código fuente, genera código para codificar 
y decodificar los campos `name` y `email` desde JSON.

Si se necesita, es también fácil de personalizar la estrategia de nombrado. Por ejemplo, si la 
API devuelve objetos con with _snake\_case_, y to quieres usar _lowerCamelCase_ en tus modelos,
puedes usar la anotación `@JsonKey` con un parámetro nombre:

<!-- skip -->
```dart
/// Dice a json_serializable como "registration_date_millis" debe ser
/// mapeado para este proyecto.
@JsonKey(name: 'registration_date_millis')
final int registrationDateMillis;
```

### Ejecutando la utilidad de auto-generación de código

Cuando creas las clases `json_serializable` por primera vez, obtendrás errores 
similares a los mostrados en la imagen abajo.

![Warning del IDE cuando el código auto-generado para una clase modelo no existe aún.](/images/json/ide_warning.png)

Estos errores son completamente normales y es simplemente porque el código auto-generado para 
la clase modelo no existe aún. Para resolver esto, ejecuta el auto-generador 
de código que genera los _boilerplate_ de serialización.

Hay dos maneras de ejecutar el auto-generador de código.

#### Auto-generación de código una única vez

Ejecutando `flutter packages pub run build_runner build` en la raíz del proyecto,
generas el código de serialización JSON para tus modelos, siempre que sea necesario.
Esto desencadena una única compilación que pasa por los ficheros fuente, elige los 
relevantes, y genera el código de serialización necesario para ellos.

Si bien, esto es conveniente, sería bueno no tener que ejecutar la compilación 
manualmente cada vez que haces cambios en tus clases modelo.

#### Auto-generación contínua de código

Un _watcher_ hace nuestro proceso de auto-generación de código más conveniente. Este 
observa cambios en los ficheros de nuestro proyecto y compila automáticamente los 
archivos necesarios cuando se necesita. Inicia el watcher ejecutando 
`flutter packages pub run build_runner watch` en la raíz del proyecto.

Es seguro ejecutar el watcher una vez y dejarlo funcionando en segundo plano.

### Consumiendo modelos json_serializable

Para decodificar una cadena JSON a la manera de `json_serializable`, 
no tienes que hacer ningún cambio a tu código anterior.

<!-- skip -->
```dart
Map userMap = json.decode(json);
var user = User.fromJson(userMap);
```
Lo mismo ocurre para codificar. La API a llamar es la misma que antes.

<!-- skip -->
```dart
String json = json.encode(user);
```

Con `json_serializable`, puedes olvidarte de cualquier serialización manual en la clase 
`User`. El auto-generador de código fuente crea un fichero llamado `user.g.dart`,
que tiene toda la lógica de serialización necesaria. Ya no tienes 
que escribir más, pruebas automatizadas para asegurar que la serailización 
funciona&mdash;ahora es _responsabilidad de la biblioteca_ asegurar que la serialización 
funciona apropiadamente.

## Referencias adicionales

Para más información, mira los siguientes recursos:

* [Documentación JsonCodec](https://api.dartlang.org/stable/dart-convert/JsonCodec-class.html)
* [El paquete json_serializable en Pub](https://pub.dartlang.org/packages/json_serializable)
* [Ejemplos de json_serializable en GitHub](https://github.com/dart-lang/json_serializable/blob/master/example/lib/example.dart)
* [Discusion sobre about dart:mirrors en Flutter](https://github.com/flutter/flutter/issues/1150)
