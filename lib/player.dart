import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:spacegame/consumable.dart';
import 'package:spacegame/earth.dart';
import 'package:spacegame/game.dart';
import 'package:spacegame/gravitation.dart';

enum PlayerState { idle, jumping, falling, flying }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with CollisionCallbacks, HasGameReference<SpaceGame>, Gravitation {
  List<Map<Trait, int>> genePool = [];
  Map<Trait, int> calcGenes() {
    final result = <Trait, int>{
      Trait.maxEnergy: 0,
      Trait.jumpAcceleration: 0,
      Trait.flapAcceleration: 0,
    };
    for (final g in genePool) {
      for (final trait in g.keys) {
        result[trait] = (result[trait] ?? 0) + g[trait]!;
      }
    }
    return result;
  }

  late Map<Trait, int> genes = calcGenes();

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
    } else if (other is Consumable) {
      if (genePool.length < 3) {
        genePool.add(other.genes);
        game.world.remove(other);
      } else {
        game.world.hud.popup(genePool, other.genes);
        game.world.remove(other);
      }
    }

    position.y = other.positionOfAnchor(Anchor.topCenter).y;
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
    final genes = <Trait, int>{
      Trait.maxEnergy: 100,
      Trait.flapAcceleration: 5,
      Trait.jumpAcceleration: 25,
    };
    genePool.add(genes);

    final flySpriteSheet =
        SpriteSheet.fromColumnsAndRows(image: flyImage, columns: 3, rows: 1);
    final idleSpriteSheet =
        SpriteSheet.fromColumnsAndRows(image: idleImage, columns: 3, rows: 1);

    animations = {
      PlayerState.idle: SpriteAnimation.spriteList(
        [idleSpriteSheet.getSprite(0, 0)],
        stepTime: 1,
      ),
      PlayerState.jumping:
          flySpriteSheet.createAnimation(row: 0, stepTime: 0.1),
      PlayerState.flying: flySpriteSheet.createAnimation(row: 0, stepTime: 0.1),
      PlayerState.falling:
          flySpriteSheet.createAnimation(row: 0, stepTime: 0.2),
    };
    current = PlayerState.idle;

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

    if (velocity.y > 0) {
      current = PlayerState.falling;
    }
  }

  void tapped() {
    if (isOnGround) {
      isOnGround = false;
      acceleration.y -= genes[Trait.jumpAcceleration]!;
      velocity.y -= 0;
    } else {
      acceleration.y -= genes[Trait.flapAcceleration]!;
    }
  }
}

enum Trait {
  maxEnergy,
  jumpAcceleration,
  flapAcceleration,
}
