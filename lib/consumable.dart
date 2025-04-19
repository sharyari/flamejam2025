import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

enum GenomeType {
  flight(genomeName: 'flight'),
  jump(genomeName: 'jump');

  final String genomeName;
  const GenomeType({required this.genomeName});
}

class Consumable extends SpriteAnimationComponent with CollisionCallbacks {
  final GenomeType type;

  Consumable({required this.type});
}
