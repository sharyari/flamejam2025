import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:spacegame/consumable.dart';
import 'package:spacegame/earth.dart';

class Player extends SpriteComponent with CollisionCallbacks, HasGameReference {
  final velocity = Vector2(0, 0);
  final acceleration = Vector2(0, 0);

  // traits
  var energy = 100;
  var max_energy = 100;
  var jump_acceleration = 25;
  var flap_acceleration = 5;

  bool isOnGround = true;

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoint, PositionComponent other) {
    super.onCollisionStart(intersectionPoint, other);

    if (other is Earth) {
      velocity.setZero();
      acceleration.setZero();
      isOnGround = true;
    } else if (other is Consumable) {}
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
    super.onLoad();
    sprite = await Sprite.load('player.png');
    super.anchor = Anchor.bottomCenter;
    super.size = Vector2(35, 35);
    super.position.y = game.world.children
        .query<Earth>()
        .first
        .positionOfAnchor(Anchor.topCenter)
        .y;
    add(RectangleHitbox());
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

  void tapped() {
    if (isOnGround) {
      isOnGround = false;
      acceleration.y -= jump_acceleration;
      velocity.y -= 0;
    } else {
      acceleration.y -= flap_acceleration;
    }
  }
}
