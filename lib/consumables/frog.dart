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
import 'package:spacegame/player.dart';

enum FrogState { idle, jumping }

class Frog extends Consumable<FrogState> with Gravitation {
  @override
  final velocity = Vector2(0, 0);
  @override
  final acceleration = Vector2(0, 0);

  @override
  bool isOnGround = true;
  @override
  late final Map<Trait, int> genes = randomGene();
  Frog() : super(type: GenomeType.jump);

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoint,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoint, other);
    if (other is Earth) {
      velocity.setZero();
      acceleration.setZero();
      isOnGround = true;
      position.y = other.positionOfAnchor(Anchor.topCenter).y;
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
      FrogState.idle: SpriteAnimation.spriteList(
        [spriteSheet.getSprite(0, 0)],
        stepTime: 1,
      ),
      FrogState.jumping: SpriteAnimation.spriteList(
        [spriteSheet.getSprite(0, 1)],
        stepTime: 1,
      ),
    };
    current = FrogState.idle;

    anchor = Anchor.bottomCenter;
    size = Vector2.all(random.nextDouble() * 20 + 25);
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
      current = FrogState.idle;
    }
    if (current != FrogState.jumping &&
        isOnGround &&
        children.query<TimerComponent>().isEmpty) {
      // jump after at least half a second
      add(
        TimerComponent(
          period: Random().nextDouble() * 2,
          onTick: jump,
          removeOnFinish: true,
        ),
      );
    }
  }

  final random = Random();

  void jump() {
    if (current == FrogState.jumping) {
      return;
    }

    current = FrogState.jumping;

    // Random jump direction (x axis)
    final randomAngle = random.nextDouble() *
        ((tau / 4) - (tau / 12)) *
        (random.nextBool() ? 1 : -1);

    final direction = Vector2(0, -1)
      ..rotate(randomAngle)
      ..scale(random.nextDouble() * 300);

    add(
      MoveByEffect(
        direction,
        EffectController(duration: 0.5, curve: Curves.bounceInOut),
      ),
    );
  }
}
