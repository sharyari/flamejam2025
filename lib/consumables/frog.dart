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
import 'package:spacegame/ground.dart';
import 'package:spacegame/gravitation.dart';
import 'package:spacegame/player.dart';

enum FrogState { idle, jumping }

class Frog extends Consumable<FrogState> with Gravitation {
  @override
  bool isOnGround = true;
  @override
  late Map<Trait, int> genes = randomGene();
  Frog() : super(type: GenomeType.jump);

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoint,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoint, other);
    if (other is Ground) {
      velocity.setZero();
      acceleration.setZero();
      isOnGround = true;
      position.y = other.positionOfAnchor(Anchor.topCenter).y;
    } else if (other is Consumable) {}
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other is Ground) {
      isOnGround = false;
    }
  }

  @override
  Future<Map<FrogState, SpriteAnimation>> getAnimations() async {
    final image = await Flame.images.load('consumables/frog.png');

    final spriteSheet =
        SpriteSheet.fromColumnsAndRows(image: image, columns: 2, rows: 1);

    return {
      FrogState.idle: SpriteAnimation.spriteList(
        [spriteSheet.getSprite(0, 0)],
        stepTime: 1,
      ),
      FrogState.jumping: SpriteAnimation.spriteList(
        [spriteSheet.getSprite(0, 1)],
        stepTime: 1,
      ),
    };
  }

  @override
  FutureOr<void> onLoad() async {
    animations = await getAnimations();
    current = FrogState.idle;

    anchor = Anchor.bottomCenter;
    size = Vector2.all(random.nextDouble() * 20 + 25);

    position.x = Random().nextInt(800).toDouble();
    position.y = game.world.ground.positionOfAnchor(Anchor.topCenter).y;

    print('Frog initial pos: $position');
    add(RectangleHitbox());
  }

  Map<Trait, int> randomGene() {
    final random = Random();
    return {
      Trait.maxEnergy: random.nextInt(6) + 1,
      Trait.jumpAcceleration: random.nextInt(6) + 1,
      Trait.flapAcceleration: random.nextInt(6) + 1,
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
