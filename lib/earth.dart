import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';

class Earth extends PositionComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    final parallax = await game.loadParallax(
      [
        ParallaxImageData('backgrounds/ground_tile_1.png'),
      ],
      filterQuality: FilterQuality.none,
    );
    size = Vector2(2732, 50);

    final groundParallax = ParallaxComponent(parallax: parallax);
    anchor = Anchor.bottomCenter;
    position.y = game.size.y;
    add(RectangleHitbox());

    add(groundParallax);
  }
}
