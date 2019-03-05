---
title: Probando Apps en Flutter
---

Mientras más funciones tenga tu app, mas difícil será probarla manualmente. Un
buen conjunto de pruebas automatizadas te ayudarán a asegurarte que tu app funcione 
correctamente antes de publicarla, mientras conservas tus funciones y corriges errores a mayor
velocidad.

Las pruebas automatizadas se dividen en pocas categorías:

- Un [_unit test_](#unit-tests) prueba una sola función, método o clase. 
- Un [_widget test_](#widget-tests) (en otros frameworks de UI se refieren a ellas como
  _component test_) prueba un único widget. 
- Un [_integration test_](#integration-tests)
  prueba una app completa o una gran parte de la app.
  
En términos generales, una aplicación bien probada tiene muchas pruebas unitarias y de widgets, seguidas por 
[code coverage](https://en.wikipedia.org/wiki/Code_coverage), además de suficientes pruebas de integración para cubrir todos los casos de uso importantes. Este consejo se basa en el hecho de que hay compensaciones entre los diferentes tipos de pruebas, como se muestra a continuación.

|                      | Unit   | Widget | Integration |
|----------------------|--------|--------|-------------|
| **Confianza**       | Low    | Higher | Highest     |
| **Costo de Mantenimiento** | Low    | Higher | Highest     |
| **Dependencias**     | Few    | More   | Most        |
| **Rapidez de ejecución**  | Quick  | Slower | Slowest     |
{:.table.table-striped} 


## Pruebas Unitarias

Un _unit test_ prueba una sola función, método o clase. El objetivo de una prueba 
unitaria es verificar la exactitud de una unidad lógica bajo una variedad de condiciones. 
Las dependencias externas de la unidad bajo prueba son generalmente [mocked
out](/cookbook/testing/mocking). Las pruebas unitarias generalmente no leen ni escriben en disco, ni se renderizan en pantalla, ni reciben acciones del usuario desde fuera del proceso que ejecuta la prueba.

### Recetas

{% include testing_toc.md type='unit' %} 

## Pruebas de Widget

Un _widget test_ (en otros frameworks de UI se conoce como _component test_) prueba un solo widget. El objetivo de una prueba de widgets es verificar que la UI del widget se vea e interactúe como se espera. Probar un widget implica múltiples clases y requiere un entorno de prueba que proporcione el contexto apropiado del ciclo de vida del widget. 

Por ejemplo, el Widget que se está probando debería ser capaz de recibir y responder a las acciones y eventos del usuario, realizar el diseño e instanciar widgets child. Por lo tanto, un test de widgets es más completo que un test unitario. Sin embargo, al igual que una prueba unitaria, el entorno de una prueba de widgets se sustituye por una implementación mucho más simple que un sistema de UI completo.

### Recetas

{% include testing_toc.md type='widget' %} 

## Pruebas de integración

Un _integration test_ prueba una app completa o una gran parte de ella. El objetivo de una prueba de integración es verificar que todos los widgets y servicios que se están probando funcionan juntos de la forma esperada. Además, puedes usar pruebas de integración para verificar el rendimiento de tu aplicación.

Generalmente, un _integration test_ se ejecuta en un dispositivo real o en un emulador de SO, como iOS Simulator o Android Emulator. La aplicación bajo prueba se aísla típicamente del código del controlador de la prueba para evitar sesgar los resultados.

### Recetas

{% include testing_toc.md type='integration' %}
  
## Servicios de integración continua

Los servicios de integración continua (CI) te permiten ejecutar tus pruebas automáticamente al introducir nuevos cambios de código. Esto proporciona una retroalimentación oportuna sobre si los cambios en el código funcionan como se espera y no introducen errores.

Para obtener información sobre la ejecución de pruebas en varios servicios de integración continua, consulta la siguiente información:

* [Entrega continua usando Fastlane con
  Flutter](/docs/deployment/fastlane-cd/)
* [Probar Flutter apps en
  Travis]({{site.flutter-medium}}/test-flutter-apps-on-travis-3fd5142ecd8c)
* [Integración Continua en GitLab 
  (GitLab CI/CD)](https://docs.gitlab.com/ee/ci/README.html#doc-nav).
  Necesitarás crear y configurar un archivo `.gitlab-ci.yml`. Puedes 
  [encontrar un ejemplo](https://raw.githubusercontent.com/brianegan/flutter_redux/master/.gitlab-ci.yml)
  en la [biblioteca flutter_redux]({{site.github}}/brianegan/flutter_redux).
* [Codemagic CI/CD para Flutter](https://blog.codemagic.io/getting-started-with-codemagic/)
* [Flutter CI/CD con Bitrise](https://devcenter.bitrise.io/getting-started/getting-started-with-flutter-apps/)
