import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';

// 1. Define the Enum
enum GenomeType {
  // Example types - replace with your actual genome types
  flight(genomeName: 'flight'),
  speed(genomeName: 'speed');

  // Field to store the part of the filename specific to this genome type
  final String genomeName;

  const GenomeType({required this.genomeName});
}

class Consumable extends SpriteAnimationComponent with CollisionCallbacks {
  final GenomeType type;

  Consumable({required this.type}) {
    //TODO Decide how to position them
    super.anchor = Anchor.topCenter;
    super.position = Vector2.all(100);
    super.size = Vector2(35, 35);
  }
  @override
  FutureOr<void> onLoad() async {
    final image =
        await Flame.images.load("consumables/" + type.genomeName + ".png");
    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2.all(372));

    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1);
    add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
  }
}
