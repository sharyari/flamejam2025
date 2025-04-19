import 'package:flame/components.dart';
import 'package:spacegame/genome.dart';
import 'package:spacegame/game.dart';
import 'package:spacegame/player.dart';

class Hud extends RectangleComponent with HasGameReference<SpaceGame> {
  static const double padding = 8;
  @override
  Future<void> onLoad() async {
    super.onLoad();

    size = Vector2(
        Genome.genomeWidth + 2 * padding, Genome.genomeHeight + 2 * padding);
    position = Vector2(game.size.x - size.x, game.size.y - size.y);
    return game.world.player.loaded.then((_) {
      Genome playerGenome = Genome(game.world.player.genes);
      add(playerGenome);
    });
  }

  void popup(List<Map<Trait, int>> genePool, Map<Trait, int> candidate) {}
}
