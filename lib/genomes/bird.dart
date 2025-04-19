import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:spacegame/consumable.dart';

class Bird extends Consumable {
  final velocity = Vector2(0, 0);
  final acceleration = Vector2(0, 0);

  Bird() : super(type: GenomeType.flight) {
    super.position = Vector2(300, 0);
    super.size = Vector2(100, 100);
  }

  @override
  FutureOr<void> onLoad() async {
    final image = await Flame.images.load('consumables/flight.png');
    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2.all(372));

    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1);
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
