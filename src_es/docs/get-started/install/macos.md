---
title: Instalación en macOS
short-title: MacOS
next:
  title: Configura un editor
  path: /get-started/editor
---

{% assign os = 'macos' -%}

## Requerimiento del sistema

Para instalar y ejecutar Flutter, tu entorno de trabajo debe cumplir los siguientes requisitos mínimos:

- **Sistema Operativo**: macOS (64-bit)
- **Espacio en disco**: 700 MB (Esto no incluye el espacio en disco para IDE/tools).
- **Herramientas**: Flutter necesita que estas herramientas de línea de comando estén disponibles en tu entorno.
  - `bash`
  - `mkdir`
  - `rm`
  - `git`
  - `curl`
  - `unzip`
  - `which`

{% include_relative _get-sdk.md %}

{% include_relative _path-mac-linux.md %}

## Configurar plataforma

macOS permite desarrollar apps con Fluter para ambos iOS y Android. Termina al menos
una de las configuraciones para las plataformas ahora, para poder ser capaz de crear y ejecutar
su primera app en Flutter.

{% include_relative _ios-setup.md %}

{% include_relative _android-setup.md %}

## Siguiente paso

[Siguiente paso: Configura un editor](/get-started/editor)