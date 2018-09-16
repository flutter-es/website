---
layout: tutorial
title: "Internacionalizando aplicaciones Flutter"

permalink: /tutorials/internationalization/
---

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>Lo que aprenderás:</b>

* Como rastrear la configuración regional del dispositivo (el idioma preferido del usuario).
* Como administrar valores regionales específicos de la app.
* Como definir las regiones que una app soporta.

</div>

Su tu aplicación podría implementarse para usuarios que hablan otro lenguaje 
entonces necesitarás "internacionalizarla". Esto significa que necesitarás escribir 
tu app de una manera que haga posible "regionalizar" valores como textos 
y layouts para cada lenguaje o "región" que la app soporte. 
Flutter provee widgets y clases que ayudan con la internacionalización y las bibliotecas 
de Flutter están en sí mismas internacionalizadas.

El tutorial que sigue está escrito en gran parte en términos de la clase de Flutter 
MaterialApp, ya que la mayoría de las aplicaciones están escritas de esta manera.
Las aplicaciones escritas en términos de la clase de más bajo nivel WidgetsApp 
también pueden ser internacionalizadas usando la mismas clases y lógica.

### Contenidos

* [Configura una app internacionalizada: el paquete flutter_localizations](#setting-up)
* [Rastrea la región: La clase Locale y el widget Localizations](#tracking-locale)
* [Cargando y obteniendo valores regionales](#loading-and-retrieving)
* [Usar el bundled LocalizationsDelegates](#using-bundles)
* [Definir una clase para los recursos regionales de la app](#defining-class)
* [Especificar el parámetro  supportedLocales de la app](#specifying-supportedlocales)
* [Una clase alternativa para los recursos regionales de la app](#alternative-class)
* [Apéndice: Usar la herramienta intl de Dart](#dart-tools)
* [Apéndice: Actualizando el app bundle de iOS](#ios-specifics)

<aside class="alert alert-info" markdown="1">
**Ejemplos de apps internacionalizadas**<br>

Si quieres empezar primero leyendo el código de una app Flutter internacionalizada, 
aquí hay dos pequeños ejemplos. El primero pretende ser los más simple 
posible, y el segundo usa las APIs y herramientas proporcionadas por 
el paquete [intl](https://pub.dartlang.org/packages/intl).
Si el paquete intl de Dart es nuevo para tí, mira [Usar la herramienta intl de Dart.](#dart-tools)

* [Internacionalización mínima](https://github.com/flutter/website/tree/master/src/_includes/code/internationalization/minimal/)
* [Internacionalización basada en el paquete `intl`](https://github.com/flutter/website/tree/master/src/_includes/code/internationalization/intl/)
</aside>

<a name="setting-up"></a>
## Configura una app internacionalizada: el paquete flutter_localizations

Por defecto Flutter solo proporciona localizaciones para US English. Para añadir 
soporte para otros idiomas, una aplicación debe especificar propiedades
adicionales de MaterialApp, e incluir un paquete separado llamado `flutter_localizations`. 
A Mayo de 2018, este paquete soporta 24 idiomas.

Para usar flutter_localizations, añade el paquete como dependencia a tu fichero 
`pubspec.yaml`:

{% prettify yaml %}
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
{% endprettify %}

A continuación, importa la biblioteca flutter_localizations y especifica 
`localizationsDelegates` y `supportedLocales` para MaterialApp:

{% prettify dart %}
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
 localizationsDelegates: [
   // ... delegado[s] de localización específicos de la app aquí
   GlobalMaterialLocalizations.delegate,
   GlobalWidgetsLocalizations.delegate,
 ],
 supportedLocales: [
    const Locale('en', 'US'), // Inglés
    const Locale('es', 'ES'), // Español
    // ... otras regiones que la app soporte
  ],
  // ...
)
{% endprettify %}

Las aplicaciones basadas en WidgetsApp son similares excepto en que no necesita el `GlobalMaterialLocalizations.delegate`.

Los elementos de la lista `localizationsDelegates` son factorías que producen 
colecciones de valores localizados. `GlobalMaterialLocalizations.delegate`
proporciona cadenas de texto y otros valores localizados para la biblioteca 
Material Components. `GlobalWidgetsLocalizations.delegate` define la dirección del 
texto por defecto, ya sea izquierda a derecha o derecha a izquierda, para la biblioteca 
de widgets.

Más información sobre estas propiedades de la app, los tipos de que dependen, 
y como las aplicaciones internacionalizadas en Flutter son normalmente 
estructuradas, puedes encontrarla abajo.

<a name="tracking-locale"></a>
## Rastrea la región: La clase Locale y el widget Localizations

La clase [`Locale`](https://docs.flutter.io/flutter/dart-ui/Locale-class.html) 
es usada para identificar el idioma del usuario. Los dispositivos móviles soportan 
configurar la región para todas las aplicaciones, usualmente a través del menu 
de configuración del sistema. Las apps internacionalizadas responden mostrando 
valores que son específicos de la región. Por ejemplo, si el usuario cambia la 
región del dispositivo de Inglés a Francés, entonces un widget Text que muestra 
"Hello World" deberia reconstruirse con "Bonjour le monde".

El widget [`Localizations`](https://docs.flutter.io/flutter/widgets/Localizations-class.html)
define la región para sus hijos y los recursos localizados de los que el hijo depende. El 
widget [WidgetsApp](https://docs.flutter.io/flutter/widgets/WidgetsApp-class.html) 
crea un widget Localizations y lo reconstruye si la región del sistema cambia.

Siempre puedes buscar la región actual con `Localizations.localeOf()`:

{% prettify dart %}
Locale myLocale = Localizations.localeOf(context);
{% endprettify %}

<a name="loading-and-retrieving"></a>
## Cargando y obteniendo valores regionales

El widget Localizations es usado para cargar y buscar objetos que 
contienen colecciones de valores localizados. Las apps hacen referencia a estos objetos 
con [`Localizations.of(context,type)`](https://docs.flutter.io/flutter/widgets/Localizations/of.html). 
Si la región del dispositivo cambia, el widget Localizations automáticamente 
carga valores para la nueva región y reconstruye los widgets que usan estos.
Esto ocurre porque Localizations trabaja como un 
[InheritedWidget](https://docs.flutter.io/flutter/widgets/InheritedWidget-class.html).
Cuando una función build hace referencia a un widget inherited, se crea una dependencia implícita 
a este. Cuando un widget inherited widget cambia 
(cuando la región del widget Localizations cambia), sus contextos dependientes son reconstruidos.

Los valores localizados son cargados por los widgets Localizations de la lista 
[LocalizationsDelegate](https://docs.flutter.io/flutter/widgets/LocalizationsDelegate-class.html)s.
Cada delegado debe definir un método async
[`load()`](https://docs.flutter.io/flutter/widgets/LocalizationsDelegate/load.html)
método que produce un objeto, el cual encapsula una colección de valores localizados. 
Normalmente estos objetos definen on método por valor localizado.

En una app grande, diferentes módulos o paquetes podrían tener bundled con sus propias 
localizaciones. Esto es porque el widget Localizations widget administra una tabla de 
objetos, uno por LocalizationsDelegate. Para obtener el objeto producido por
uno de los métodos `load` de los LocalizationsDelegate,
especificas un BuildContext y un tipo de objeto.

Por ejemplo, las cadenas de texto localizadas para los widgets Material Components widgets estan definidas por la clase 
[MaterialLocalizations](https://docs.flutter.io/flutter/material/MaterialLocalizations-class.html). 
Instancias de esta clase son creadas por un LocalizationDelegate
proporcionado por la clase [MaterialApp](https://docs.flutter.io/flutter/material/MaterialApp-class.html). 
Este puede ser obtenido con `Localizations.of`:

{% prettify dart %}
Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);
{% endprettify %}

Esta particular expresion, `Localizations.of()` es usada frecuentemente, por eso la clase 
MaterialLocalizations proporciona un atajo conveniente:

{% prettify dart %}
static MaterialLocalizations of(BuildContext context) {
  return Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);
}

/// References to the localized values defined by MaterialLocalizations
/// are typically written like this:

tooltip: MaterialLocalizations.of(context).backButtonTooltip,
{% endprettify %}

<a name="using-bundles">
## Usar el bundled LocalizationsDelegates

Para mantener las cosas lo menos complicadas posible, el paquete flutter 
incluye implementaciones de los interfaces MaterialLocalizations y
WidgetsLocalizations que solo proporcionan valores para la 
US English. Estas clases de implementación se llaman
DefaultMaterialLocalizations y DefaultWidgetsLocalizations, respectivamente.
Ellas están incluidas automaticamente a menos que un delegate diferente
del mismo tipo base sea especificado en el parámetro `localizationsDelegates` 
de la app.

El paquete flutter_localizations incluye implementaciones multi-idioma 
de los interfaces de localizacion llamadas GlobalMaterialLocalizations
y GlobalWidgetsLocalizations. Las apps internacionales deben especificar 
localization delegates para estas clases como se describe en
[configura una app internacionalizada.](#setting-up)

{% prettify dart %}
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
 localizationsDelegates: [
   // ... app-specific localization delegate[s] here
   GlobalMaterialLocalizations.delegate,
   GlobalWidgetsLocalizations.delegate,
 ],
 supportedLocales: [
    const Locale('en', 'US'), // English
    const Locale('es', 'es_ES'), // Español
    // ... otras regiones que la app soporte
  ],
  // ...
)
{% endprettify %}

El localization delegate global, construye instancias especificas de región 
de las clases correspondientes. Por ejemplo,
`GlobalMaterialLocalizations.delegate` es un LocalizationsDelegate
que produce una instancia de GlobalMaterialLocalizations.

A mayo de 2018, las clases global localization soportan [alrededor de 24
idiomas.](https://github.com/flutter/flutter/tree/master/packages/flutter_localizations/lib/src/l10n)

<a name="defining-class"></a>
## Definir una clase para los recursos regionales de la app

Poner todo esto junto para una app internacionalizada usualmente 
empieza con la clase que encapsula los valores localizados de la app. 
El ejemplo que sigue es típico de tales clases.

[Código fuente completo](https://github.com/flutter/website/tree/master/src/_includes/code/internationalization/intl/)
para este ejemplo.

Este ejemplo esta basado en las APIs y herramientas proporcionadas por el 
paquete [intl](https://pub.dartlang.org/packages/intl). [Una clase alternativa para los recursos 
localizados de la app](#alternative-class) describe
[un ejemplo](https://github.com/flutter/website/tree/master/src/_includes/code/internationalization/minimal/)
que no depende del paquete intl.

La clase DemoLocalizations contiene las cadenas de texto de la app (solo para el ejemplo)
traducidas en las regiones que la app soporta. Este usa la función `initializeMessages()`
generada por el paquete de Dart [intl](https://pub.dartlang.org/packages/intl)
para cargar las cadenas de texto traducidas, y 
[`Intl.message()`](https://www.dartdocs.org/documentation/intl/0.15.1/intl/Intl/message.html)
para buscarlas.

{% prettify dart %}
class DemoLocalizations {
  static Future<DemoLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return DemoLocalizations();
    });
  }

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  String get title {
    return Intl.message(
      'Hello World',
      name: 'title',
      desc: 'Title for the Demo application',
    );
  }
}
{% endprettify %}

Una clase basada en el paquete `intl` importa un catálogo de mensajes generales 
que proveen la función `initializeMessages()` y el almacenamiento para las localizaciones para `Intl.message()`.
El catálogo de mensajes es producido por la herramienta [`intl`](#dart-tools) que analiza el código fuente 
buscando clases que contienen llamadas a `Intl.message()`.
En este caso, este sería justamente la clase DemoLocalizations.

<a name="specifying-supportedlocales"></a>
## Especificar el parámetro  supportedLocales de la app

Aunque la biblioteca de Flutter, Material Components, incluye soporte para aproximandamente 
16 idiomas, solo las traducciones en Inglés están disponibles por defecto.
Depende del desarrollador decidir exactamente que idiomas soportar, ya que no tendría sentido
para las bibliotecas del toolkit soportar un conjunto diferente de localizaciones que las que 
la app soporta.

El parámetro 
[`supportedLocales`](https://docs.flutter.io/flutter/material/MaterialApp/supportedLocales.html)
de MaterialApp limita los cambios de región. Cuando el usuario cambia la región 
configurandola en su dispositivo, el widget de la app `Localizations` widget solamente 
sigue el ejemplo si la nueva region es un miembro de su lista.
Si no se encuentra una coincidencia exacta para la región del dispositivo, entonces se usa la primera región soportada que con un [`languageCode`](https://docs.flutter.io/flutter/dart-ui/Locale/languageCode.html)
coincidente. Si esto falla, se usa el primer elemento de la lista de `supportedLocales`.

En términos de el ejemplo DemoApp previo, la app solo acepta las regiones 
US English o French Canadian, y sustituye por US
English (la primera region en la lista) en cualquier otro caso.

Una app que quiera usar un método diferente para determinar la región puede proporcionar un 
[`localeResolutionCallback`.](https://docs.flutter.io/flutter/widgets/LocaleResolutionCallback.html)
Por ejemplo, para hacer que tu app acepte incondicionalmente cualquier region que el 
usuario seleccione:

{% prettify dart %}
class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       localeResolutionCallback(Locale locale, Iterable<Locale> supportedLocales) {
         return locale;
       }
       // ...
    );
  }
}
{% endprettify %}

<a name="alternative-class"></a>
## Una clase alternativa para los recursos regionales de la app

El ejemplo anterior, DemoApp, fue definido en términos del paquete de Dart `intl`. 
Los desarrolladores pueden elegir su propia aproximación para administrar valores localizados por el bien de la 
simplicidad o quizás para integrar un framework i18n diferente.

[Código fuente completo](https://github.com/flutter/website/tree/master/src/_includes/code/internationalization/minimal/)
para esta app de ejemplo.

En esta versión de DemoApp la clase que contiene las localizaciones de la app, 
DemoLocalizations, incluye todas sus traducciones directamente en un Map 
por lenguaje.


{% prettify dart %}
class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Hello World',
    },
    'es': {
      'title': 'Hola Mundo',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }
}
{% endprettify %}

En la app minima el DemoLocalizationsDelegate es ligeramente 
diferente. Su método `load` devuelve un 
[SynchronousFuture](https://docs.flutter.io/flutter/foundation/SynchronousFuture-class.html)
porque no es necesario que una carga asincrona tenga lugar.


{% prettify dart %}
class DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
{% endprettify %}

<a name="dart-tools"></a>
## Apéndice: Usar la herramienta intl de Dart

Después de construir una API usando el paquete 
[`intl`](https://pub.dartlang.org/packages/intl) de Dart 
querrás revisar la documantación del paquete `intl`. Aquí está un resumen del proceso 
para localizar una app dependiente del paquete `intl`.

La app demo depende de archivo fuente generado llamado `l10n/messages_all.dart`
el cual define todas las cadenas de texto localizables usadas por la app.

Recompilar `l10n/messages_all.dart` requiere dos pasos.

<ol markdown="1">
<li markdown="1">Con el directorio raíz de la app como el directorio actual, genera
`l10n/intl_messages.arb` desde `lib/main.dart`:

{% prettify sh %}
$ flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/main.dart
{% endprettify %}

El fichero `intl_messages.arb` es un mapa en formato JSON con una entrada por
cada función `Intl.message()` definida en `main.dart`. Este
fichero sirve como una plantilla para las traducciones en Inglés y en en Español,
`intl_en.arb` y `intl_es.arb`. Estas traducciones son creadas por ti, el desarrollador.
</li>

<li markdown="1">Con el directorio raíz de la app como directorio actual, genera
`intl_messages_<locale>.dart` por cada fichero `intl_<locale>.arb` y
`intl_messages_all.dart`, el cual importa todo los ficheros de mensajes:

{% prettify sh %}
$ flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n \
   --no-use-deferred-loading lib/main.dart lib/l10n/intl_*.arb
{% endprettify %}

La clase DemoLocalizations usa la función generada `initializeMessages()` 
(definida en `intl_messages_all.dart`) para cargar los mensajes localizados y 
`Intl.message()` para buscarlos.
</li>

</ol>

<a name="ios-specifics"></a>
### Apéndice: Actualizando el app bundle de iOS

En las aplicaciones iOS se definen "key application metadata", inluyendo las regiones 
soportadas, en un fichero `Info.plist` que es construido dentro del "aplication bundle". 
Para configurar las regiones soportadas por tu app, necesitarás editar este fichero.

Primero, abré el fichero Xcode workspace `ios/Runner.xcworkspace` de tu proyecto, entonces 
en el Project Navigator, abre el fichero `Info.plist` bajo la carpeta `Runner` del proyecto 
`Runner`.

A continuación, selecciona el item `Information Property List`, elige *Add Item* en el 
menú *Editor*, entonces selecciona `Localizations` en el menú emergente.

Selecciona y expande el item recien creado `Localizations` entonces, para cada región 
que soporte tu aplicación, añade un nuevo item y elige la región que quieres añadir 
del menu emergente en el campo *Value*. Esta lista debe coincidir con los lenguajes 
listados en el parámetro [supportedLocales](#specifying-supportedlocales).

Cuando estén añadidos todas las regiones, guarda el fichero.