import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:spacegame/consumable.dart';

class Bird extends Consumable {
  Bird() : super(type: GenomeType.flight) {
    super.anchor = Anchor.topCenter;
    super.position = Vector2.all(100);
    super.size = Vector2(35, 35);
  }

  @override
  FutureOr<void> onLoad() async {
    final image =
        await Flame.images.load('consumables/' + type.genomeName + '.png');
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
