import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/consumable.dart';
import 'package:spacegame/earth.dart';
import 'package:spacegame/gravitation.dart';

enum FrogState { idle, jumping }

class Frog extends Consumable<FrogState> with Gravitation {
  final velocity = Vector2(0, 0);
  final acceleration = Vector2(0, 0);

  bool isOnGround = true;
  late final Map<Trait, int> genes = randomGene();
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
      FrogState.jumping: SpriteAnimation.spriteList(
          [spriteSheet.getSprite(0, 1)],
          stepTime: 1),
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

  Map<Trait, int> randomGene() {
    return {
      Trait.maxEnergy: 4,
      Trait.jumpAcceleration: 4,
      Trait.flapAcceleration: 4,
    };
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isOnGround && current == FrogState.jumping) {
      print("Frog landed!");
      current = FrogState.idle;
    }
    if (current != FrogState.jumping &&
        isOnGround &&
        children.query<TimerComponent>().isEmpty) {
      // jump after at least half a second
      print("Frog might jump!");
      add(
        TimerComponent(
          period: Random().nextDouble() * 2,
          onTick: () {
            print("Frog jumping!");
            jump();
          },
          removeOnFinish: true,
        ),
      );
    }
  }

  final random = Random();

  void jump() {
    if (current == FrogState.jumping) {
      print("Frog already jumping!");
      return;
    }

    current = FrogState.jumping;

    // Random jump direction (x axis)
    double randomAngle = random.nextDouble() *
        ((tau / 4) - (tau / 12)) *
        (random.nextBool() ? 1 : -1);

    Vector2 direction = Vector2(0, -1)
      ..rotate(randomAngle)
      ..scale(130);

    add(
      MoveByEffect(
        direction,
        EffectController(duration: 0.5, curve: Curves.bounceInOut),
      ),
    );
  }
}
