---
title: Gestión sencilla del estado de las aplicaciones
prev:
  title: Efímero vs estado de aplicación
  path: /docs/development/data-and-backend/state-mgmt/ephemeral-vs-app
next:
  title: Lista de enfoques
  path: /docs/development/data-and-backend/state-mgmt/options
---

Ahora que conoces la [programación declarativa de UI](/docs/development/data-and-backend/state-mgmt/declarative) y la diferencia entre [efímero y app state](/docs/development/data-and-backend/state-mgmt/ephemeral-vs-app), estás listo para aprender acerca de la gestión de estado una app sencilla.

En esta página, vamos a usar el paquete `scoped_model`. Si eres nuevo en Flutter y no tienes una razón de peso para elegir otro enfoque (Redux, Rx, hooks, etc.), este es probablemente el enfoque con el que deberías empezar. El `scoped_model` es fácil de entender y no utiliza mucho código. También utiliza conceptos que son aplicables en todos los demás enfoques.

Dicho esto, si tienes una formación sólida en gestión de estados de otros frameworks reactivos, encontrarás paquetes y tutoriales en la [página siguiente](/docs/development/data-and-backend/state-mgmt/options).

## Nuestro ejemplo {% asset development/data-and-backend/state-mgmt/model-shopper-screencast alt="Un gif animado que muestra una aplicación Flutter en uso. Comienza con el usuario en una pantalla de inicio de sesión. Se conectan y se les lleva a la pantalla del catálogo, con una lista de artículos. Al hacer clic en varios elementos, y al hacerlo, los elementos se marcan como "añadidos". El usuario hace clic en un botón y es llevado a la vista del carro. Ellos ven los artículos allí. Vuelven al catálogo, y los artículos que compraron siguen mostrando "añadidos". Fin de la animación." class='site-image-right' %}

A modo de ejemplo, considera la siguiente aplicación sencilla.

La aplicación tiene tres pantallas separadas: una ventana de inicio de sesión, un catálogo y un carrito (representados por los widgets `MyLoginScreen`, `MyCatalog`, y `MyCart`, respectivamente). Podría ser una aplicación de compras, pero puedes imaginarte la misma estructura en una simple aplicación de redes sociales (reemplaza el catálogo por " muro " y el carrito por " favoritos ").

La pantalla del catálogo incluye una barra de aplicaciones personalizada (`MyAppBar`) y una vista de desplazamiento de muchos elementos de la lista (`MyListItems`).

Aquí está la aplicación visualizada como un árbol de widgets.

{% asset development/data-and-backend/state-mgmt/simple-widget-tree alt="A widget tree with MyApp at the top, and MyLoginScreen, MyCatalog and MyCart below it. MyLoginScreen and MyCart area leaf nodes, but MyCatalog have two children: MyAppBar and a list of MyListItems." %}

{% comment %}
  Source drawing for the png above: https://docs.google.com/drawings/d/1KXxAl_Ctxc-avhR4uE58BXBM6Tyhy0pQMCsSMFHVL_0/edit?zx=y4m1lzbhsrvx
{% endcomment %}

Así que tenemos al menos 6 subclases de `Widget`. Muchos de ellos necesitarán acceso a un estado que "pertenece" a otra parte. Por ejemplo, cada `MyListItem` podrá añadir a la carrito. También podrías querer ver si el artículo que está mostrando ya está en el carrito.

Esto nos lleva a nuestra primera pregunta: ¿dónde debemos poner el estado actual del carro? 


## Estado de elevación

En Flutter, tiene sentido mantener el estado por encima de los widgets que lo utilizan.

Por qué? En frameworks declarativos como Flutter, si quieres cambiar la interfaz de usuario, tienes que reconstruirla. No hay una manera fácil de tener `MyCart.updateWith(somethingNew)`. En otras palabras, es difícil cambiar imperativamente un widget desde fuera, llamando a un método en él. E incluso si pudieras hacer que esto funcione, estarías luchando contra el framework en lugar de dejar que te ayude.

<!-- skip -->
```dart
// MALO: NO HAGA ESTO
void myTapHandler() {
  var cartWidget = somehowGetMyCartWidget();
  cartWidget.updateWith(item);
}
```

Incluso si consigues que el código anterior funcione, tendrás que ocuparte de lo siguiente en el widget `MyCart`:

<!-- skip -->
```dart
// MALO: NO HAGA ESTO
Widget build(BuildContext context) {
  return SomeWidget(
    // The initial state of the cart.
  );
}

void updateWith(Item item) {
  // Somehow you need to change the UI from here.
}
```

Necesitarás tener en cuenta el estado actual de la interfaz de usuario y aplicarle los nuevos datos. Es difícil evitar los errores de esta manera.

En Flutter, construyes un nuevo widget cada vez que su contenido cambia. En lugar de `MyCart.updateWith(somethingNew)` (una llamada de método) usas `MyCart(contents)` (un constructor). Debido a que sólo puedes construir nuevos widgets en los métodos de construcción de sus padres, si quieres cambiar los `contenidos`, necesita vivir en el padre de `MyCart` o superior.

<?code-excerpt "state_mgmt/simple/lib/src/scoped_model.dart (myTapHandler)"?>
```dart
// CORRECTO
void myTapHandler(BuildContext context) {
  var cartModel = somehowGetMyCartModel(context);
  cartModel.add(item);
}
```

Ahora `MyCart` tiene sólo una ruta de código para construir cualquier versión de la interfaz de usuario.

<?code-excerpt "state_mgmt/simple/lib/src/scoped_model.dart (build)"?>
```dart
// CORRECTO
Widget build(BuildContext context) {
  var cartModel = somehowGetMyCartModel(context);
  return SomeWidget(
    // Just construct the UI once, using the current state of the cart.
    // ···
  );
}
```

En nuestro ejemplo, `contents` necesitan vivir en `MyApp`. Cada vez que cambie, recontruye `MyCart` desde arriba (hablaremos más de esto despues). Debido a esto, `MyCart` no necesita preocuparse por el ciclo de vida&mdash;soló declara qué mostrar para cualquier `contents` dado. Cuando eso cambia, el widget `MyCart` viejo desaparecer y es completamente reemplazado por uno nuevo.


{% asset development/data-and-backend/state-mgmt/simple-widget-tree-with-cart alt="Same widget tree as above, but now we show a small 'cart' badge next to MyApp, and there are two arrows here. One comes from one of the MyListItems to the 'cart', and another one goes from the 'cart' to the MyCart widget." %}

{% comment %}
  Source drawing for the png above: https://docs.google.com/drawings/d/1ErMyaX4fwfbIW9ABuPAlHELLGMsU6cdxPDFz_elsS9k/edit?zx=j42inp8903pt
{% endcomment %}

Esto es lo que queremos decir cuando decimos que los widgets son inmutables. No cambian&mdash;son reemplazados.

Ahora que sabemos dónde poner el estado del carro, veamos cómo acceder a él.

## Acceso al estado

Cuando el usuario hace clic en uno de los artículos del catálogo, se añade al carrito. Pero ya que el carro vive encima de `MyListItem`, ¿cómo lo hacemos?

Una opción simple es proporcionar un callback a la que `MyListItem` puede llamar cuando se hace clic en el. Las funciones de Dart son objetos de primera clase, por lo que puedes compartirlos como quieras. Así, dentro de `MiCatálogo` puedes tener lo siguiente:

<?code-excerpt "state_mgmt/simple/lib/src/passing_callbacks.dart (methods)"?>
```dart
@override
Widget build(BuildContext context) {
  return SomeWidget(
    // Contruye el widget, pasando la referencia al método de superior.
    MyListItem(myTapCallback),
  );
}

void myTapCallback(Item item) {
  print('user tapped on $item');
}
```

Esto funciona bien, pero para el estado de la aplicación que necesitas modificar desde muchos lugares diferentes, tendrías que pasar un montón de llamadas de retorno&mdash;lo que envejece bastante rápido.

Afortunadamente, Flutter tiene mecanismos para que los widgets proporcionen datos y servicios a sus descendientes (en otras palabras, no sólo a sus hijos, sino a cualquier widget que se encuentre debajo de ellos). Como es de esperar de Flutter, donde _Everything es un Widget™_, estos mecanismos son sólo tipos especiales de widgets&mdash;`InheritedWidgets`, `InheritedNotifier`, `InheritedModel`, y más. No los cubriremos aquí, porque son un poco de bajo nivel para lo que estamos tratando de hacer.

En su lugar, vamos a usar un paquete que funciona con los widgets de bajo nivel pero que es fácil de usar. Se llama `scoped_model`.

Con `scoped_model`, no tienes que preocuparte por las llamadas de retorno o `InheritedWidgets`. Pero necesitas entender 3 conceptos:

* Modelo
* ScopedModel
* ScopedModelDescendant


## Modelo

En `scoped_model`, el `Modelo` encapsula el estado de su aplicación. En los complejos, tendrás varios modelos.

En nuestro ejemplo de aplicación de compras, queremos gestionar el estado del carro en un `Modelo`. Creamos una nueva clase que extiende Model. De esta manera

<?code-excerpt "state_mgmt/simple/lib/src/scoped_model.dart (model)"?>
```dart
class CartModel extends Model {
  /// Internal, private state of the cart.
  final List<Item> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  /// The current total price of all items (assuming all items cost $1).
  int get totalPrice => _items.length;

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(Item item) {
    _items.add(item);
    // This call tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }
}
```

El único código que es específico de `Model` es la llamada a `notifyListeners()`. Llama a este método cada vez que el modelo cambie de una manera que pueda cambiar la interfaz de usuario de tu aplicación. Todo lo demás en `CartModel` es el modelo mismo y su lógica de negocio.

El modelo no depende de ninguna clase de alto nivel en Flutter, por lo que es fácilmente comprobable (ni siquiera necesitas usar [widget testing](/docs/testing#widget-testing) para ello). Por ejemplo, he aquí una sencilla prueba unitaria de CartModel:

<?code-excerpt "state_mgmt/simple/test/model_test.dart (test)"?>
```dart
test('adding item increases total cost', () {
  final cart = CartModel();
  final startingPrice = cart.totalPrice;
  cart.addListener(() {
    expect(cart.totalPrice, greaterThan(startingPrice));
  });
  cart.add(Item('Dash'));
});
```

Pero `Model` realmente empieza a tener sentido cuando se usa con el resto del paquete `scoped_model`.


## ScopedModel

`ScopedModel` es el widget que proporciona una instancia de `Model` a sus descendientes.

Ya sabemos dónde ponerlo: sobre los widgets que necesitaremos para acceder a él. En el caso de `CartModel`, eso significa en algún lugar por encima de `MyCart` y `MyCatalog`.

No quieres poner `ScopedModel` más alto de lo necesario (porque no quiere contaminar el alcance). Pero en nuestro caso, el único widget que está encima de `MyCart` y `MyCatalog` es `MyApp`.

<?code-excerpt "state_mgmt/simple/lib/main.dart (main)"?>
```dart
void main() {
  final cart = CartModel();

  // You could optionally connect [cart] with some database here.

  runApp(
    ScopedModel<CartModel>(
      model: cart,
      child: MyApp(),
    ),
  );
}
```

Ten en cuenta que estamos creando `ScopedModel<CartModel>` (lea: "ScopedModel of CartModel"). El paquete `scoped_model` se basa en tipos para encontrar el modelo correcto, y la parte `<CartModel>` deja claro qué tipo estamos proporcionando aquí.

Si desea proporcionar más de un modelo, necesita anidar los ScopedModels:

<!-- skip -->
```dart
ScopedModel<SomeOtherModel>(
  model: myOtherModel,
  child: ScopedModel<CartModel>(
    model: cart,
    child: MyApp(),
  ),
)
```

## ScopedModelDescendant

Ahora que `CartModel` se proporciona a los widgets de nuestra aplicación a través de la declaración `ScopedModel<CartModel>` en la parte superior, podemos empezar a usarlo.

Esto se hace a través del widget `ScopedModelDescendant`.

<?code-excerpt "state_mgmt/simple/lib/src/scoped_model.dart (descendant)"?>
```dart
return ScopedModelDescendant<CartModel>(
  builder: (context, child, cart) {
    return Text("Total price: ${cart.totalPrice}");
  },
);
```

Debemos especificar el tipo de modelo al que queremos acceder. En este caso, queremos `CartModel`, así que escribimos `ScopedModelDescendant<CartModel>`. Si no especifica el genérico (`<CartModel>`), el paquete `scoped_model` no podrá ayudarte. Como se mencionó anteriormente, `scoped_model` está basado en tipos, y sin el tipo, no sabe lo que quieres.

El único argumento requerido del widget `ScopedModelDescendant` es el constructor. Builder es una función que se llama cada vez que cambia el modelo. (En otras palabras, cuando llamas `notifyListeners()` en su modelo, todos los métodos de construcción de todos los widgets correspondientes de `ScopedModelDescendant` son llamados.)

El constructor es llamado con tres atributos. El primero es `context`, que también se obtiene en todos los métodos de construcción. 

El segundo atributo es `child`, que está ahí para la optimización. Si tienes un gran subárbol de widgets bajo tu `ScopedModelDescendant` que no cambia cuando el modelo cambia, puedes construirlo
una vez y lo consigues a través del constructor.

<?code-excerpt "state_mgmt/simple/lib/src/performance.dart (child)"?>
```dart
return ScopedModelDescendant<CartModel>(
  builder: (context, child, cart) => Stack(
        children: [
          // Use SomeExpensiveWidget here, without rebuilding every time.
          child,
          Text("Total price: ${cart.totalPrice}"),
        ],
      ),
  // Build the expensive widget here.
  child: SomeExpensiveWidget(),
);
```

El tercer argumento de la función builder es el modelo. Eso es lo que estábamos pidiendo en primer lugar. Puedes utilizar los datos del modelo para definir cómo debería ser la interfaz de usuario en un momento dado.

Es una buena práctica colocar los widgets de `ScopedModelDescendant` lo más profundo posible en el árbol. No querrás reconstruir grandes porciones de la interfaz de usuario sólo porque algún detalle haya cambiado en alguna parte.

<?code-excerpt "state_mgmt/simple/lib/src/performance.dart (nonLeafDescendant)"?>
```dart
// DON'T DO THIS
return ScopedModelDescendant<CartModel>(
  builder: (context, child, cart) {
    return HumongousWidget(
      // ...
      child: AnotherMonstrousWidget(
        // ...
        child: Text('Total price: ${cart.totalPrice}'),
      ),
    );
  },
);
```

En lugar de:

<?code-excerpt "state_mgmt/simple/lib/src/performance.dart (leafDescendant)"?>
```dart
// DO THIS
return HumongousWidget(
  // ...
  child: AnotherMonstrousWidget(
    // ...
    child: ScopedModelDescendant<CartModel>(
      builder: (context, child, cart) {
        return Text('Total price: ${cart.totalPrice}');
      },
    ),
  ),
);
```

### ScopedModel.of

A veces, no necesitas realmente los _datos_ en el modelo para cambiar la interfaz de usuario, pero aún así necesitas acceder a ella. Por ejemplo, un botón `ClearCart` quiere permitir al usuario eliminar todo del carrito. No necesitas mostrar el contenido del carrito, sólo necesita llamar al método `clear()`.

Podríamos usar `ScopedModelDescendant<CartModel>` para esto, pero eso sería un desperdicio. Estaríamos pidiendo el marco para reconstruir un widget que no necesita ser reconstruido. 

Para este caso de uso, podemos usar `ScopedModel.of`. 

<?code-excerpt "state_mgmt/simple/lib/src/performance.dart (nonRebuilding)"?>
```dart
ScopedModel.of<CartModel>(context).add(item);
```

Usar la línea anterior en un método de compilación no hará que este widget se reconstruya cuando `notifyListeners` sea llamado.

Nota: También puedes utilizar `ScopedModelDescendant<CartModel>(builder: myBuilder, rebuildOnChange: false)` pero eso es más largo y requiere que definas la función builder.

## Uniendo todo

Puedes [ver el ejemplo]({{site.github}}/filiph/samples/tree/scoped-model-shopper/model_shopper) cubierto en este artículo. Si quieres algo más simple, puedes ver cómo se ve la sencilla aplicación Counter [contruida con scoped_model](https://github.com/flutter/samples/tree/master/scoped_model_counter).

Cuando estés listo para jugar con `scoped_model` tú mismo, no olvides añadir la dependencia de él a tu `pubspec.yaml` primero.

```yaml
name: my_name
description: Blah blah blah.

# ...

dependencies:
  flutter:
    sdk: flutter

  scoped_model: ^1.0.0

dev_dependencies:
  # ...
```

Ahora puedes `import 'package:scoped_model/scoped_model.dart';`
y empezar a contruir.
