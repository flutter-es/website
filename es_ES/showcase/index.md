---
layout: page
title: Portafolio

permalink: /showcase/
---

Flutter es utilizado por Google y por desarrolladores y organizaciones de todo el mundo para ofrecer increíbles aplicaciones nativas en iOS y Android.
Aquí tienes una pequeña selección de aplicaciones hechas con Flutter.
Si deseas ser presentado, [háznoslo saber][]!

[háznoslo saber]: https://docs.google.com/forms/d/e/1FAIpQLScP5iDNGrlVXdGxmRDzjCnqXS0KUDld-3cR-njAL0kDO2ULFg/viewform

Para una lista más larga de aplicaciones, visita [itsallwidgets.com](https://itsallwidgets.com/flutter-apps).

<div class="showcase-grid__row row">

{% for case in site.data.showcases %}
    {% capture modulo4 %}{{ forloop.index0 | modulo:4 }}{% endcapture %}

    {% if modulo4 == '0' %}
     <div class="clearfix visible-lg"></div>
    {% endif %}

    {% capture modulo3 %}{{ forloop.index0 | modulo:3 }}{% endcapture %}

    {% if modulo3 == '0' %}
     <div class="clearfix visible-md"></div>
    {% endif %}

    {% capture modulo2 %}{{ forloop.index0 | modulo:2 }}{% endcapture %}

    {% if modulo2 == '0' %}
     <div class="clearfix visible-sm"></div>
    {% endif %}

    <div class="showcase-grid__item col-lg-3 col-md-4 col-sm-6">
        <h2>{{case.name}}</h2>

        <div class="showcase-grid__screenshot">
            <div class="showcase-grid__screenshot--top"></div>
            <img
                 src="{{case.screenshot}}" alt="{{case.name}} screenshot">
            <div class="showcase-grid__screenshot--bottom"></div>
        </div>

        <p>{{case.description}}</p>

        {% if case.ios_download and case.android_download %}
        <p>
            Download:
            <a href="{{case.ios_download}}">iOS</a>,
            <a href="{{case.android_download}}">Android</a>
        </p>
        {% elsif case.ios_download %}
        <p>
            Download:
            <a href="{{case.ios_download}}">iOS</a>
        </p>
        {% elsif case.android_download %}
        <p>
            Download:
            <a href="{{case.android_download}}">Android</a>
        </p>
        {% endif %}

        {% if case.learn_more_link %}
        <p><a href="{{case.learn_more_link}}">Learn more</a></p>
        {% endif %}
    </div>
{% endfor %}

</div> <!-- end of showcase--grid__row -->
