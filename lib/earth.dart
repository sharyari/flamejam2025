import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Earth extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('backgrounds/ground_tile_1.png');
    sprite = Sprite(
      image,
      srcPosition: Vector2(0, 0),
      srcSize: Vector2(2732, 2048),
    );
    size = Vector2(2732, 2048);
    anchor = Anchor.bottomCenter;
    position.y = game.size.y;
    add(RectangleHitbox());
  }
}
