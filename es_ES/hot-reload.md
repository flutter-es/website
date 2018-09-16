---
layout: page
title: Usando Hot Reload
permalink: /hot-reload/
---

* TOC
{:toc}

## Usando hot reload

La funcionalidad hot reload de Flutter te ayuda a rápida y fácilmente  experimentar, 
construir UIS, añadir funcionalidades y arreglar bugs. Hot reload trabaja inyectando ficheros 
de código fuente actualizados en la Máquina Virtual(VM) Dart en ejecución. Después de que VM 
actualiza clases con la nueva version de campos y funciones, el framework Flutter 
automáticamente reconstruye el árbol de widgets, permitiendo ver rápidamente los efectos de 
tus cambios.

Para usar hot reload en una app Flutter:

1.  Ejecuta la app desde un [editor Flutter](/get-started/editor/) soportado 
o desde una ventana de terminal. El target puede ser tanto un dispositivo físico como uno virtual. Solo
las apps en modo depuración pueden usar hot reload.
1.  Modifica uno de los ficheros Dart en tu proyecto. La mayoría de los tipos de cambios en código pueden 
hacer que se ejecute hot reload; para ver una lista de los cambios que requiere un reinicio 
completo, hot restart, mira [Limitaciones](#limitations).
1.  Si estas trabajando en un IDE/editor que soporta las herramientas para IDE de Flutter,
selecciona **Save All** (`cmd-s`/`ctrl-s`), o haz clic en el botón Hot Reload en la barra de herramientas:

   ![alt_text](/images/intellij/hot-reload.gif "image_tooltip")

   Si estas ejecutando la app por línea de comandos usando `flutter run`, escribe `r`
   en la ventana del terminal.

Después de ejecutarse con éxito la operación de hot reload, verás un mensaje en la consola 
similar a:

```
Performing hot reload...
Reloaded 1 of 448 libraries in 2,777ms.
```
La app se actualiza para reflejar tus cambios, y el estado actual de la app
— el valor de la variable counter en el ejemplo anterior — se conserva. Tu 
app continua ejecutándose desde donde estaba antes de ejecutar el comando 
hot reload. El código se ha actualizado y la ejecución continua.

Un cambio en el código solo tiene un efecto visible si el código Dart modificado 
se ejecuta de nuevo después del cambio. Especificamente, un hot reload causa que todos 
los widgets existentes ejecuten un rebuild. Solo el código involucrado en el 
rebuild de los widgets es automáticamente re-ejecutado.

La siguiente sección describe situaciones comunes en las que 
las modificaciones en el código no se ejecutarían de nuevo después 
de un hot reload. En algunos casos,
pequeños cambios en el código Dart te permitirán seguir usando hot reload 
para tu app.

## Errores de compilación

Cuando un cambio de código introduce un error de compilación, hot reload siempre genera 
un mensaje de error similar a:
```
Hot reload was rejected:
'/Users/obiwan/Library/Developer/CoreSimulator/Devices/AC94F0FF-16F7-46C8-B4BF-218B73C547AC/data/Containers/Data/Application/4F72B076-42AD-44A4-A7CF-57D9F93E895E/tmp/ios_testWIDYdS/ios_test/lib/main.dart': warning: line 16 pos 38: unbalanced '{' opens here
  Widget build(BuildContext context) {
                                     ^
'/Users/obiwan/Library/Developer/CoreSimulator/Devices/AC94F0FF-16F7-46C8-B4BF-218B73C547AC/data/Containers/Data/Application/4F72B076-42AD-44A4-A7CF-57D9F93E895E/tmp/ios_testWIDYdS/ios_test/lib/main.dart': error: line 33 pos 5: unbalanced ')'
    );
    ^
 ```
En esta situación, simplemente corrija los errores en las lineas especificas 
del código Dart para mantenerse usando hot reload.

## Estado previo se combina con nuevo código

La funcionalidad hot reload de Flutter, algunas veces descritas como _stateful hot reload_,
preservan el estado de tu app. Este diseño te permite ver el 
efecto de los cambios más recientes, sin perder el estado actual. 
Por ejemplo, si tu app requiere que un usuario haga login, puedes 
modificar y hacer hot reload de una pagina múltiples niveles abajo
en la jerarquía de navegación, sin tener que volver a introducir las
credenciales del usuario. El estado se mantiene, que es 
generalmente el comportamiento deseado.

Si los cambios de código afectan al estado de tu app (o sus dependencias),
los datos que tiene tu app para trabajar podrían no ser totalmente 
consistentes con los datos que deberían tener si se ejecutan desde 
el principio. El resultado podría ser un comportamiento diferente
después de un hot reload que con un hot restart.

Por ejemplo, si modificas la definición de una clase para heredar desde StatelessWidget
a StatefulWidget (o viceversa), después de hacer hot reload el estado previo de tu 
app es conservado. Sin embargo, el estado podría no ser compatible con 
los nuevos cambios.

Considera el siguiente código:

```
class myWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => print('T'));
  }
}
```
Después de ejecutar la app, si haces el siguiente cambio:

```
class myWidget extends StatefulWidget {
  @override
  State createState() => myWidgetState();
}
class myWidgetState {
...
...
}
```

y entonces haces hot reload, la consola muestra un _assertion failure_ parecido a:

```
myWidget is not a subtype of StatelessWidget
```

Es estas situaciones, es necesario un hot restart para ver la app actualizada.

## Cambio del código reciente se incluye pero el estado de la app se excluye

En Dart, [los campos estáticos son inicializados de forma "lazy"](https://news.dartlang.org/2012/02/static-variables-no-longer-have-to-be.html). Esto significa que la 
primera vez que ejecutas una app Flutter y un campo estático es leído, este se ajusta al valor que sea 
que marque la evaluación de su inicializador.
Las variables Globales y los campos estáticos son tratados como estados, y por lo tanto 
no se reinicializan durante un hot reload.

Si cambias los inicializadores de una variable global o de un campo estático, es necesario
reiniciar por completo para ver estos cambios. Por ejemplo, considera el 
siguiente código:

```
final sampleTable = [
  Table("T1"),
  Table("T2"),
  Table("T3"),
  Table("T4"),
];
```
Despues de ejecutar la app, si haces el siguiente cambio:
```
final sampleTable = [
  Table("T1"),
  Table("T2"),
  Table("T3"),
  Table("T10"),    //modificado
];
```
y entonces haces hot reload, el cambio no se refleja.

A la inversa, en el siguiente ejemplo:
```
const foo = 1;
final bar = foo;
void onClick(){
  print(foo);
  print(bar);
}
```
ejcutar la app por primera vez imprime `1` y `1`. Entonces si haces el siguiente
cambio:

```
const foo = 2;    //modificado
final bar = foo;
void onClick(){
  print(foo);
  print(bar);
}
```
y haces hot reload, ahora imprime `2` y `1`. Mientras que los de valor para campos `const` 
son siempre recargados, el inicializador del campo estático no se re-ejecuta.
Conceptualmente, los campos `const` son tratados como alias en lugar de estados.

La VM Dart detecta los cambios en inicializadores y etiqueta cuando un conjunto 
de cambios necesitan de un hot restart para hacer efecto. El mecanismo de etiquetado 
se lanza para la mayoría de los trabajos de inicializacion en el ejemplo anterior 
pero no para casos como:

```
final bar = foo;
```

Para poder actualizar `foo` y ver el cambio después de hacer hot reload, considera
redefinir el campo como `const` o usar un getter para devolver el valor, mejor que
usar `final`. Por ejemplo:

```
const bar = foo;
```
o:

```
get bar => foo;
```

Lee más sobre las [diferencias entre las palabras clave `const` y `final`](https://news.dartlang.org/2012/06/const-static-final-oh-my.html) en Dart.

## Cambio reciente de la UI es excluido

Incluso cuando una operación de hot reload parece exitosa y no genera excepciones,
algún cambio de código podría no ser visible en la UI actualizada. Este comportamiento 
es común después de cambios en el método `main()` de la app.

Como regla general, si el código modificado es descendiente del método build del 
widget raíz. Entonces hot reload se comporta del modo esperado. Sin embargo, si el código
modificado no se volvería a ejecutar como resultado de la reconstrucción del árbol
de widgets, entonces no verás sus efectos después de hacer hot reload.

Por ejemplo, considera el siguiente código:
```
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('tapped'));
  }
}
```

Después de ejecutar esta app, podrías cambiar el código como sigue:

```
import 'package:flutter/widgets.dart';
void main() {
  runApp(
    const Center(
      child: const Text('Hello', textDirection: TextDirection.ltr)));
  }
```


Con un hot restart, el programa empieza por el principio, ejecuta la nueva 
versión de `main()`, y construye un árbol de widgets que muestra el texto `Hello`.

Sin embargo, si haces hot reload de la app después de este cambio, `main()` no se 
vuelve a ejecutar, y el árbol de widget es reconstruido con la instancia inalterada 
de `MyApp` como widget raíz. El resultado es que no hay cambios visibles después del hot reload.

## Limitaciones

Podrías encontrate también el caso raro de que hot reload no sea soportado en absoluto. Esto incluye:

*  Cuando tipos enumerados se cambian a clases regulares o clases regulares se cambian a 
tipos enumerados. Por ejemplo, si cambias:

    ```
    enum Color {
      red,
      green,
      blue
    }

    ```
a:

   ```
    class Color {
      Color(this.i, this.j);
      final Int i;
      final Int j;
    	}
    ```

*   Cuando se modifican declaraciones de tipo en genéricos. Por ejemplo, si cambias:
    ```
    class A<T> {
      T i;
    }
    ```
	a:

    ```
    class A<T, V> {
      T i;
      V v;
    }
    ```

En estas situaciones, hot reload genera un mensaje de diagnóstico y falla sin realizar 
ningún cambio.

## Así funciona

Cuando hot reload es invocado, la máquina host, mira en el código editado desde la 
última compilación. Las siguientes bibliotecas son recompiladas:

 * Cualquier biblioteca con cambios en código.
 * La biblioteca main de la aplicación.
 * Las bibliotecas de la biblioteca principal que conducen a las bibliotecas afectadas.

En Dart 2, el código fuente de estas librerias de Dart, son convertidas en 
[ficheros de kernel](https://github.com/dart-lang/sdk/tree/master/pkg/kernel) y 
enviadas a la VM Dart del dipositivo móvil.

La VM Dart recarga todas las bibliotecas desde el nuevo fichero kernel. Hasta ahora no 
hay código re-ejecutado.

El mecanismo hot reload entonces provoca que el framework Flutter lance 
un "rebuild/re-layout/repaint" de todos los widgets y objetos renderizados existentes.
