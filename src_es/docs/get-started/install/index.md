---
title: Instalación
next:
  title: Configura un editor
  path: /get-started/editor
toc: false
---

Selecciona el sistema operativo en el que estés instalando Flutter:

{{site.alert.note}}
  **¿Estas en Chrome OS?**

  Si es así, !mira la [documentación de instalación de Flutter en Chrome!](/docs/get-started/install/chromeos)
{{site.alert.end}}

<div class="card-deck mb-8">
{% for os in site.os-list %}
  <a class="card" href="/get-started/install/{{os | downcase}}">
    <div class="card-body">
      <header class="card-title text-center m-0">
        {{os}}
        <i class="fab fa-{{os | downcase}}"></i>
      </header>
    </div>
  </a>
{% endfor %}
</div>

{{site.alert.important}}
  Si estas en China, lee primero [Usando  Flutter en China](/community/china).
{{site.alert.end}}

