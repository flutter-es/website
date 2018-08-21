---
layout: page
title: "Display images from the internet"
permalink: /cookbook/images/network-image/
---

Displaying images is fundamental for most mobile apps. Flutter provides the 
[`Image`](https://docs.flutter.io/flutter/widgets/Image-class.html) Widget to 
display different types of images.

In order to work with images from a URL, use the [`Image.network`](https://docs.flutter.io/flutter/widgets/Image/Image.network.html) 
constructor.

<!-- skip -->
```dart
Image.network(
  'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg',
)
```

## Bonus: Animated Gifs

One amazing thing about the `Image` Widget: It also supports animated gifs out
of the box!

<!-- skip -->
```dart
Image.network(
  'https://github.com/flutter/plugins/raw/master/packages/video_player/doc/demo_ipod.gif?raw=true',
);
```

## Placeholders and Caching

The default `Image.network` constructor does not handle more advanced 
functionality, such as fading images in after loading or caching images
to the device after they're downloaded. To achieve these tasks, please see
the following recipes:

  * [Fade in images with a placeholder](/cookbook/images/fading-in-images/)
  * [Working with cached images](/cookbook/images/cached-images/) 

## Complete example

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var title = 'Web Images';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Image.network(
          'https://github.com/flutter/website/blob/master/src/_includes/code/layout/lakes/images/lake.jpg?raw=true',
        ),
      ),
    );
  }
}
```

![Network Image Demo](/images/cookbook/network-image.png)