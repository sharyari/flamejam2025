import 'package:flame/components.dart';
import 'package:spacegame/genome.dart';
import 'package:spacegame/game.dart';

class Hud extends RectangleComponent with HasGameReference<SpaceGame> {
  static const double padding = 8;
  @override
  Future<void> onLoad() async {
    super.onLoad();

    size = Vector2(
        Genome.genomeWidth + 2 * padding, Genome.genomeHeight + 2 * padding);
    position = Vector2(game.size.x - size.x, game.size.y - size.y);
    Genome playerGenome = Genome(game.world.player.genes);
    add(playerGenome);
  }
}
