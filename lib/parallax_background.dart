import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/widgets.dart';
import 'package:spacegame/game.dart';

class ParallaxBackground extends PositionComponent
    with HasGameReference<SpaceGame> {
  @override
  Future<void> onLoad() async {
    final parallax = await game.loadParallax(
      [
        // ParallaxImageData('backgrounds/ground_parallax_element_3.png'),
        // ParallaxImageData('backgrounds/ground_parallax_element_4.png'),
        // ParallaxImageData('backgrounds/ground_parallax_element_1.png'),
        // ParallaxImageData('backgrounds/ground_parallax_element_2.png'),
        ParallaxImageData('backgrounds/ground_parallax_element_5.png'),
      ],
      velocityMultiplierDelta: Vector2(0, 0),
      repeat: ImageRepeat.noRepeat,
    );

    size = Vector2(2732, 700);
    game.world.player.velocity.addListener(() {
      parallax.baseVelocity.setFrom(game.world.player.velocity / 2);
    });

    final groundParallax = ParallaxComponent(parallax: parallax);
    anchor = Anchor.bottomCenter;
    position.y = game.size.y;
    add(groundParallax);
  }
}
