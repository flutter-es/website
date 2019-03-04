---
title: Persistencia de datos con SQLite
prev:
  title: Trabajando con WebSockets
  path: /docs/cookbook/networking/web-sockets
next:
  title: Leer y escribir archivos
  path: /docs/cookbook/persistence/reading-writing-files
---

Si escribes una aplicación que necesita persistir y consultar grandes cantidades de datos en el dispositivo local, considera usar una base de datos en lugar de un archivo local o un almacén de clave-valor. En general, las bases de datos proporcionan inserciones, actualizaciones y consultas más rápidas en comparación con otras soluciones de persistencia local.

Las aplicaciones de Flutter pueden hacer uso de las bases de datos SQLite a través del complemento [`sqflite`](https://pub.dartlang.org/packages/sqflite) disponible en el pub. ¡Esta receta muestra los conceptos básicos de uso de `sqflite` para insertar, leer, actualizar y eliminar datos sobre varios Dogs(perros)!

Si eres nuevo en SQLite y en las sentencias de SQL, revisa el [sitio SQLite Tutorial](http://www.sqlitetutorial.net/) para aprender lo básico antes de completar este cookbok.

## Instrucciones

  1. Añade las dependencias
  2. Definir el modelo de datos `Dog`
  3. Abrir la base de datos
  4. Crear la tabla `Dogs`
  5. Insertar un `Dog` en la base de datos
  6. Recuperar la lista de Dogs
  7. Actualizar un `Dog` en la base de datos
  7. Eliminar un `Dog` de la base de datos

## 1. Añadir las dependencias

Para trabajar con bases de datos SQLite, importa los complementos `sqflite` y `path`. 

  - El complemento `sqflite` proporciona clases y funciones que te permiten interactuar con una base de datos SQLite. 
  - El complemento `path` proporciona funciones que te permiten definir correctamente la ubicación para almacenar la base de datos en el disco.

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite:
  path:
```

## 2. Definir el modelo de datos del Dog.

Antes de crear la tabla para almacenar información en Dogs, tómate unos minutos para definir los datos que deben almacenarse. Para este ejemplo, define una clase Dog que contenga tres datos: Un `id` único, el nombre (`name`), y la edad (`age`) del perro.

<!-- skip -->
```dart
class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});
}
``` 

## 3. Abre la base de datos

Antes de leer y escribir en la base de datos, debe abrir una conexión a dicha base de datos. Esto implica dos pasos:

  1. Define la ruta al archivo de base de datos utilizando `getDatabasesPath` del complemento `sqflite` combinado con la función `path` del complemento `path`.
  2. Abra la base de datos con la función `openDatabase` de `sqflite`

<!-- skip -->
```dart
// Abre la base de datos y guarda la referencia.
final Future<Database> database = openDatabase(
  // Establecer la ruta a la base de datos. Nota: Usando la función `join` del
  // complemento `path` es la mejor práctica para asegurar que la ruta sea correctamente
  // construida para cada plataforma.
  join(await getDatabasesPath(), 'doggie_database.db'),
);
```

## 4. Crea la tabla `dogs`

A continuación, debes crear una tabla para almacenar información sobre varios perros. Para este ejemplo, crea una tabla llamada `dogs` que defina los datos que se pueden almacenar. En este caso, cada `Dog` contiene `id`, `name`, y `age`. Por lo tanto, estos serán representados como tres columnas en la tabla `dogs`.

  1. El `id` es de tipo `int` en Dart, y se almacenará como tipo `INTEGER` en SQLite. También es una buena práctica usar `id` como clave principal de la tabla para mejorar los tiempos de consulta y actualización.
  2. El `name` es de tipo `String` en Dart, y se almacenará como tipo `TEXT` en SQLite.
  3. El `age` es de tipo `int` en Dart, y se almacenará como tipo `INTEGER` en SQLite.

Para obtener más información sobre los tipos de datos disponibles que se pueden almacenar en una base de datos SQLite, consulta [la documentación oficial de tipos de datos de SQLite](https://www.sqlite.org/datatype3.html).

<!-- skip -->
```dart
final Future<Database> database = openDatabase(
  // Establece la ruta a la base de datos. 
  join(await getDatabasesPath(), 'doggie_database.db'),
  // Cuando la base de datos se crea por primera vez, crea una tabla para almacenar dogs
  onCreate: (db, version) {
    // Ejecuta la sentencia CREATE TABLE en la base de datos
    return db.execute(
      "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
    );
  },
  // Establece la versión. Esto ejecuta la función onCreate y proporciona una
  // ruta para realizar actualizacones y defradaciones en la base de datos.
  version: 1,
);
``` 

## 5. Inserta un Dog en la base de datos

Ahora que tienes una base de datos con una tabla adecuada para almacenar información sobre varios dogs, ¡es hora de leer y escribir datos!

Primero, inserta un `Dog` en la tabla `dogs`. Esto implica dos pasos:

  1. Convertir la clase `Dog` en un `Map`
  2. Usar el método [`insert`](https://pub.dartlang.org/documentation/sqflite/latest/sqlite_api/DatabaseExecutor/insert.html) para almacenar el `Map` en la tabla `dogs`

<!-- skip -->
```dart
// Primero, actualiza la clase Dog para incluir el método `toMap`.
class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});

  // Convierte en un Map. Las llaves deben corresponder con los nombres de las 
  // columnas en la base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }
}

// A continuación, define la función para insertar dogs en la base de datos
Future<void> insertDog(Dog dog) async {
  // Obtiene una referencia de la base de datos
  final Database db = await database;

  // Inserta el Dog en la tabla correcta. También puede especificar el
  // `conflictAlgorithm` para usar en caso de que el mismo Dog se inserte dos veces.
  // En este caso, reemplaza cualquier dato anterior.
  await db.insert(
    'dogs',
    dog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Ahora, puedes crear un Dog y agregarlo a la tabla dogs!
final fido = Dog(
  id: 0, 
  name: 'Fido', 
  age: 35,
);

await insertDog(fido);
```

## 6. Recuperar la lista de Dogs

Ahora que tienes un `Dog` almacenado en la base de datos, puedes consultar la base de datos por un Dog específico o una lista de dogs! Esto implica dos pasos:

  1. Ejecutar una consulta (`query`) sobre la tabla `dogs`. Esto deberá retornar `List<Map>`
  2. Convertir `List<Map>` en `List<Dog>` 
  
<!-- skip -->
```dart
// Un método que recupera todos los dogs de la tabla dogs
Future<List<Dog>> dogs() async {
  // Obtiene una referencia de la base de datos
  final Database db = await database;

  // Consulta la tabla por todos los Dogs.
  final List<Map<String, dynamic>> maps = await db.query('dogs');

  // Convierte List<Map<String, dynamic> en List<Dog>.
  return List.generate(maps.length, (i) {
    return Dog(
      id: maps[i]['id'],
      name: maps[i]['name'],
      age: maps[i]['age'],
    );
  });
}

// Ahora, puedes usar el método anterior para recuperar todos los dogs!
print(await dogs()); // Imprime una lista que contiene a Fido
```

## 7. Actualizar un `Dog` en la base de datos

Después de haber insertado alguna información en la base de datos, es posible que desees actualizar esa información más adelante. Para ello, utiliza el método [`update`](https://pub.dartlang.org/documentation/sqflite/latest/sqlite_api/DatabaseExecutor/update.html) del complemento `sqflite`.

Esto implica dos pasos:

  1. Convertir el Dog en un Map
  2. Usar una cláusula `where` para asegurarse de actualizar el Dog correcto

<!-- skip -->
```dart
Future<void> updateDog(Dog dog) async {
  // Obtiene una referencia de la base de datos
  final db = await database;

  // Actualiza el Dog dado
  await db.update(
    'dogs',
    dog.toMap(),
    // Aseguúrate de que solo actualizarás el Dog con el id coincidente
    where: "id = ${dog.id}",
  );
}

// Ahora, puedes actualzar la edad de Fido!
await updateDog(Dog(
  id: 0, 
  name: 'Fido', 
  age: 42,
));

// Y puedes imprimir los resultados actualizados
print(await dogs()); // Imprime a Fido con 42 años.
```

## 8. Eliminar un `Dog` de la base de datos

Además de insertar y actualizar información sobre perros, también puedes eliminar perros de la base de datos. Para borrar datos, usa el método [`delete`](https://pub.dartlang.org/documentation/sqflite/latest/sqlite_api/DatabaseExecutor/delete.html) del complemento `sqflite`. 

En esta parte, crea una función que tome una identificación y elimina el perro con un id coincidente de la base de datos. Para hacer que esto funcione, debes proporcionar una cláusula `where` para limitar los registros que se eliminen.

<!-- skip -->
```dart
Future<void> deleteDog(int id) async {
  // Obtiene una referencia de la base de datos
  final db = await database;

  // Elimina el Dog de la base de datos
  await db.delete(
    'dogs',
    // Utiliza la cláusula `where` para eliminar un dog específico
    where: "id = $id",
  );
}
```

## Ejemplo

Para ejecutar el ejemplo:

  1. Crear un nuevo proyecto de Flutter
  2. Agregar los complementos `sqfite` y `path` a tu `pubspec.yaml`
  3. Pegue el siguiente código en un nuevo archivo llamado `lib/db_test.dart`
  4. Ejecuta el código con `flutter run lib/db_test.dart`

```dart
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  final database = openDatabase(
    // Establecer la ruta a la base de datos. Nota: Usando la función `join` del
    // complemento `path` es la mejor práctica para asegurar que la ruta sea correctamente
    // construida para cada plataforma.
    join(await getDatabasesPath(), 'doggie_database.db'),
    // Cuando la base de datos se crea por primera vez, crea una tabla para almacenar dogs
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
      );
    },
    // Establece la versión. Esto ejecuta la función onCreate y proporciona una
    // ruta para realizar actualizacones y defradaciones en la base de datos.
    version: 1,
  );

  Future<void> insertDog(Dog dog) async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Inserta el Dog en la tabla correcta. También puede especificar el
    // `conflictAlgorithm` para usar en caso de que el mismo Dog se inserte dos veces.
    // En este caso, reemplaza cualquier dato anterior.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> dogs() async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Consulta la tabla por todos los Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convierte List<Map<String, dynamic> en List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<void> updateDog(Dog dog) async {
    // Obtiene una referencia de la base de datos
    final db = await database;

    // Actualiza el Dog dado
    await db.update(
      'dogs',
      dog.toMap(),
      // Aseguúrate de que solo actualizarás el Dog con el id coincidente
      where: "id = ${dog.id}",
    );
  }

  Future<void> deleteDog(int id) async {
    // Obtiene una referencia de la base de datos
    final db = await database;

    // Elimina el Dog de la base de datos
    await db.delete(
      'dogs',
      // Utiliza la cláusula `where` para eliminar un dog específico
      where: "id = $id",
    );
  }

  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );

  // Inserta un dog en la base de datos
  await insertDog(fido);

  // Imprime la lista de dogs (solamente Fido por ahora)
  print(await dogs());

  // Actualiza la edad de Fido y lo guarda en la base de datos
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await updateDog(fido);

  // Imprime la información de Fido actualizada
  print(await dogs());

  // Elimina a Fido de la base de datos
  await deleteDog(fido.id);

  // Imprime la lista de dos (vacía)
  print(await dogs());
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implementa toString para que sea más fácil ver información sobre cada perro
  // usando la declaración de impresión.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
```

