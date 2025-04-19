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
    final image = await Flame.images.load('consumables/frog.png');

    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2(281, 300));

    animations = {
      FrogState.idle: SpriteAnimation.spriteList([spriteSheet.getSprite(0, 0)],
          stepTime: 1),
      FrogState.jumping: spriteSheet.createAnimation(row: 0, stepTime: 0.1),
    };
    current = FrogState.idle;

    anchor = Anchor.bottomCenter;
    size = Vector2(25, 25);
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
    if (!isOnGround && current == FrogState.idle) {
      current = FrogState.jumping;
    }
    if (isOnGround) {
      current = FrogState.idle;
      return;
    }
    if (current != FrogState.jumping && isOnGround) {
      // jump after at least half a second
      print("Frog might jump!");
      Future.delayed(
        Duration(milliseconds: Random().nextInt(1000) + 1000),
        () {
          print("Frog jumping!");

          jump(dt);
        },
      );
      current = FrogState.idle;
    }
  }

  void jump(double dt) {
    if (current == FrogState.jumping) {
      return;
    }

    current = FrogState.jumping;

    // Random jump direction (x axis)
    double randomDirection = Random().nextDouble() * 2 - 1; // Between -1 and 1

    // Horizontal jump component - frogs jump outward, not just up
    acceleration.x = randomDirection * 25 * dt;

    // Vertical jump component - frogs have powerful legs
    acceleration.y = 50 * dt; // Stronger upward force than the angel

    // Apply acceleration to velocity
    velocity.x += acceleration.x * dt * 40;
    velocity.y += acceleration.y * dt * 40;

    // Apply velocity to position
    position += velocity * dt;

    // Optional: Add some rotation for more natural frog movement
    // rotation += randomDirection * 0.2;
  }
}
