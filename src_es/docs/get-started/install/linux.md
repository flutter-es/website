---
title: Instalación en Linux
short-title: Linux
# js: [{defer: true, url: /assets/archive.js}]
next:
  title: Configura un editor
  path: /get-started/editor
---

{% assign os = 'linux' -%}

## Requerimiento del Sistema

Para instalar y ejecutar Flutter, el entorno de trabajo debe estos requisitos mínimos:

- **Sistema Operativo**: Linux (64-bit)
- **Espacio en Disco**: 600 MB (no incluye espacio en disco para IDE/herramientas).
- **Herramientas**: Flutter  depende de que estas herramientas estén disponibles en tu entorno.
  - `bash`, `mkdir`, `rm`, `git`, `curl`, `unzip`, `which`
- **Bibliotecas Compartidas**: El comando `test` en Flutter  depende de que estas bibliotecas estén disponibles en tu entorno.
  * `libGLU.so.1` -  suministrada por mesa packages ej. `libglu1-mesa` en Ubuntu/Debian


{% include_relative _get-sdk.md %}

{% include_relative _path-mac-linux.md %}

{% include_relative _android-setup.md %}

## Siguiente paso

[Siguiente paso: Configura un editor](/get-started/editor)
