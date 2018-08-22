---
layout: page
title: Catálogo de Widgets
permalink: /widgets/
---

Crea hermosas aplicaciones rápidamente con la
colección de widgets visuales, estructurales,
de plataforma e interactivos de Flutter.

<p>Además de navegar por los widgets por categoría, 
puedes también ver todos los widgets en el<a href="/widgets/widgetindex/">índice de widgets de Flutter</a>.</p>

<ul class="cards">
{% for section in site.data.catalog.index %}
	<li class="cards__item">
	    <div class="card">
		    <h3 class="catalog-category-title"><a class="action-link" href="/widgets/{{section.id}}">{{section.name}}</a></h3>
		    <p>{{section.description}}</p>
		    <div class="card-action">
		        <a class="action-link" href="/widgets/{{section.id}}">VISITA</a>
		    </div>
		</div>
		
	</li>
 {% endfor %}
</ul>
