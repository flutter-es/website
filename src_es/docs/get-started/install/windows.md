---
title: Windows install
short-title: Windows
# js: [{defer: true, url: /assets/archive.js}]
next:
  title: Configurar un editor
  path: /get-started/editor
---

{% assign os = 'windows' -%}

## Requerimientos del Sistema

Para instalar y ejecutar Flutter, el ambiente de trabajo debe de cumplir al menos con los siguientes requerimientos:

- **Sistema Operativo**: Windows 7 SP1 o superior (64-bit)
- **Espacio en Disco**: 400 MB (no incluye espacio en disco para IDE/herramientas).
- **Herramientas**: Flutter depende de que estas herramientas estén disponibles en tu entorno.
  - [Windows PowerShell 5.0][] o superior (este es pre-instalado con Windows 10)
  - [Git para Windows][] con la opción **Use Git from the Windows Command Prompt**

     Si Git para Windows está ya instalado, asegúrate de poder correr comandos con `git` desde el 
     Command Prompt o PowerShell.

{% include_relative _get-sdk-win.md %}

{% include_relative _android-setup.md %}

## Siguiente paso

[Siguiente paso: Configura el editor](/get-started/editor)

[Git para Windows]: https://git-scm.com/download/win
[Windows PowerShell 5.0]: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell
