import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:spacegame/consumable.dart';
import 'package:spacegame/earth.dart';

enum PlayerState { idle, jumping, falling, flying }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with CollisionCallbacks, HasGameReference {
  final velocity = Vector2(0, 0);
  final acceleration = Vector2(0, 0);

  // traits
  // TODO: make into a map, then use map:merge with consumable
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
  Future<void> onLoad() async {
    super.onLoad();

    final flyImage = await Flame.images.load('player/alien_fly.png');
    final idleImage = await Flame.images.load('player/alien_idle_flap.png');

    final flySpriteSheet =
        SpriteSheet(image: flyImage, srcSize: Vector2(435, 587));
    final idleSpriteSheet =
        SpriteSheet(image: idleImage, srcSize: Vector2(435, 587));

    animations = {
      PlayerState.idle: SpriteAnimation.spriteList(
          [idleSpriteSheet.getSprite(0, 0)],
          stepTime: 1),
      PlayerState.jumping:
          idleSpriteSheet.createAnimation(row: 0, stepTime: 0.1),
      PlayerState.flying: flySpriteSheet.createAnimation(row: 0, stepTime: 0.1),
      PlayerState.falling:
          flySpriteSheet.createAnimation(row: 0, stepTime: 0.2),
    };
    current = PlayerState.idle;

    add(RectangleHitbox());

    super.anchor = Anchor.bottomCenter;
    super.size = Vector2(100, 100);
    super.position.y = game.world.children
        .query<Earth>()
        .first
        .positionOfAnchor(Anchor.topCenter)
        .y;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isOnGround && current == PlayerState.idle) {
      current = PlayerState.jumping;
    }
    if (isOnGround) {
      current = PlayerState.idle;
      return;
    }

    acceleration.y += 37 * dt;
    velocity.y += acceleration.y * dt * 40;
    position += velocity * dt;

    if (velocity.y > 0) {
      current = PlayerState.falling;
    }
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
