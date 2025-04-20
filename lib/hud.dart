import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/consumable.dart';
import 'package:spacegame/game.dart';
import 'package:spacegame/genome.dart';

class Hud extends RectangleComponent with HasGameReference<SpaceGame> {
  static const double padding = 8;
  late Vector2 initialSize;
  late Vector2 initialPosition;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(
      Genome.genomeWidth + 2 * padding,
      Genome.genomeHeight + 2 * padding,
    );
    position = Vector2(game.size.x - size.x, game.size.y - size.y);
    initialPosition = position.clone();
    initialSize = size.clone();

    return game.world.player.loaded.then((_) {
      final playerGenome =
          Genome(game.world.player.genes, game.world.player.animation!, -1);
      add(playerGenome);
    });
  }

  Future<void> popup(List<Consumable> genePool) async {
    final newPos = game.size / 2;
    final targetSize = Vector2(size.x,
        (genePool.length + 1) * (Genome.genomeHeight + padding) + 1 * padding);

    game.world.pause();

    for (var i = 0; i < genePool.length; i++) {
      var pos = i + 1;
      final gen = Genome(
        genePool[i].genes,
        (await genePool[i].getAnimations()).values.first,
        pos,
      );
      gen.mounted.then((_) {
        gen.position.y += (Genome.genomeHeight + padding) * pos;
      });
      add(gen);
    }
    add(AnchorToEffect(Anchor.center, EffectController(duration: 1)));
    add(
      MoveToEffect(
        newPos,
        EffectController(duration: 1, curve: Curves.decelerate),
      ),
    );
    add(
      SizeEffect.to(
        targetSize,
        EffectController(duration: 1),
      ),
    );
  }

  void popDown(int pos) {
    removeAll(children.query<Genome>());
    game.world.player.genePool.removeAt(pos - 1);
    game.world.player.genes = game.world.player.calcGenes();
    add(Genome(game.world.player.genes, game.world.player.animation!, -1));
    add(
      MoveToEffect(
        initialPosition,
        EffectController(duration: 1.5, curve: Curves.decelerate),
      ),
    );
    add(
      SizeEffect.to(
        initialSize,
        EffectController(duration: 1),
      ),
    );
    add(
      AnchorToEffect(
        Anchor.topLeft,
        EffectController(duration: 1),
        onComplete: game.world.resume,
      ),
    );
    game.world.player.isColliding = false;
  }
}
