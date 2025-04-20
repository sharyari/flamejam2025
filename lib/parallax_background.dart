import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';

class ParallaxBackground extends PositionComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    final parallax = await game.loadParallax(
      [
        ParallaxImageData('backgrounds/background_paralax_element_1.png'),
        ParallaxImageData('backgrounds/background_paralax_element_2.png'),
        ParallaxImageData('backgrounds/background_paralax_element_3.png'),
        ParallaxImageData('backgrounds/background_paralax_element_4.png'),
      ],
      filterQuality: FilterQuality.none,
    );
    size = Vector2(2732, 700);

    final groundParallax = ParallaxComponent(parallax: parallax);
    anchor = Anchor.bottomCenter;
    position.y = game.size.y;
    add(groundParallax);
  }
}
