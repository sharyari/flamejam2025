import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:spacegame/consumable.dart';
import 'package:spacegame/player.dart';

enum FishBirdState { flying }

class FishBird extends Consumable<FishBirdState> {
  final velocity = Vector2(0, 0);
  final acceleration = Vector2(0, 0);
  @override
  late Map<Trait, int> genes = randomGene();

  FishBird() : super(type: GenomeType.flight) {
    super.position = Vector2(300, -100);
    super.size = Vector2(300, 300);
  }

  @override
  Future<Map<FishBirdState, SpriteAnimation>> getAnimations() async {
    final flyImage = await Flame.images.load('consumables/fishbird.png');

    final flySpriteSheet =
        SpriteSheet.fromColumnsAndRows(image: flyImage, columns: 3, rows: 1);

    return {
      FishBirdState.flying:
          flySpriteSheet.createAnimation(row: 0, stepTime: 0.1),
    };
  }

  @override
  FutureOr<void> onLoad() async {
    animations = await getAnimations();
    current = FishBirdState.flying;

    add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    acceleration.x = 10; // Set acceleration instead of adding to it
    velocity.x += acceleration.x * dt; // Apply acceleration with time scaling

    // Use sin function for oscillating movement
    position.x -= velocity.x * dt;
    position.y = sin(position.x * 0.1) *
        5.0; // Adjust multipliers for amplitude/frequency
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
  }
}

Map<Trait, int> randomGene() {
  return {
    Trait.maxEnergy: 4,
    Trait.jumpAcceleration: 4,
    Trait.flapAcceleration: 4,
  };
}
