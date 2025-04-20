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

abstract class Consumable<T> extends SpriteAnimationGroupComponent<T>
    with CollisionCallbacks, HasGameReference<SpaceGame> {
  final GenomeType type;
  late final Map<Trait, int> genes;
  Future<Map<T, SpriteAnimation>> getAnimations();

  Consumable({required this.type});
}
