import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:spacegame/consumable.dart';
import 'package:spacegame/earth.dart';
import 'package:spacegame/player.dart';

enum FrogState { idle, jumping }

class Frog extends Consumable<FrogState> {
  final velocity = Vector2(0, 0);
  final acceleration = Vector2(0, 0);

  bool isOnGround = true;

  Frog() : super(type: GenomeType.jump) {
    size = Vector2(50, 50);
  }

  @override
  FutureOr<void> onLoad() async {
    final image = await Flame.images.load('consumables/frog.png');

    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2(281, 300));

    animations = {
      FrogState.idle: SpriteAnimation.spriteList([spriteSheet.getSprite(0, 0)],
          stepTime: 1),
      FrogState.jumping: spriteSheet.createAnimation(row: 0, stepTime: 0.1),
    };
    current = FrogState.idle;

    anchor = Anchor.bottomCenter;
    size = Vector2(50, 50);
    position.y = game.world.children
        .query<Earth>()
        .first
        .positionOfAnchor(Anchor.topCenter)
        .y;

    position.x = Random().nextInt(800).toDouble();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
