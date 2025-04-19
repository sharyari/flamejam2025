import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:spacegame/game.dart';
import 'package:spacegame/player.dart';

enum GenomeType {
  flight(genomeName: 'flight'),
  jump(genomeName: 'jump');

  final String genomeName;
  const GenomeType({required this.genomeName});
}

class Consumable<T> extends SpriteAnimationGroupComponent<T>
    with CollisionCallbacks, HasGameReference<SpaceGame> {
  final GenomeType type;
  late final Map<Trait, int> genes;

  Consumable({required this.type});
}
