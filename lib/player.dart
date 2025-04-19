import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:spacegame/earth.dart';

class Player extends SpriteComponent
    with DragCallbacks, TapCallbacks, CollisionCallbacks, HasGameReference {
  final velocity = Vector2(0, 0);
  final acceleration = Vector2(0, 0);
  bool isOnGround = true;

  Player();

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoint, PositionComponent other) {
    super.onCollisionStart(intersectionPoint, other);

    if (other is Earth) {
      velocity.setZero();
      acceleration.setZero();
      isOnGround = true;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other is Earth) {
      isOnGround = false;
    }
  }

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('player.png');
    super.anchor = Anchor.bottomCenter;
    super.size = Vector2(35, 35);
    super.position.y = game.world.children
        .query<Earth>()
        .first
        .positionOfAnchor(Anchor.topCenter)
        .y;
    add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isOnGround) {
      return;
    }
    acceleration.y += 9.81 * dt;
    velocity.y += acceleration.y * dt;
    position += velocity * dt;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    isOnGround = false;
    acceleration.y -= 25;
    velocity.y -= 0;
  }
}
