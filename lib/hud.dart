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
          Genome(game.world.player.genes, game.world.player.animation!);
      add(playerGenome);
    });
  }

  Future<void> popup(List<Consumable> genePool, Consumable candidate) async {
    final newPos = game.size / 2;
    final buttonSize = Vector2(200, 50);
    final targetSize = Vector2(size.x,
        (genePool.length + 2) * (Genome.genomeHeight + padding) + 1 * padding);

    game.world.pause();
    print("current gene $genePool");

    for (var i = 0; i < genePool.length; i++) {
      var pos = i + 1;
      final gen = Genome(
          genePool[i].genes, (await genePool[i].getAnimations()).values.first);
      gen.mounted.then((_) {
        gen.position.y += (Genome.genomeHeight + padding) * pos;
      });
      add(gen);
    }
    final otherGen = Genome(candidate.genes, candidate.animation!);
    otherGen.mounted.then((_) async {
      otherGen.position.y +=
          (Genome.genomeHeight + padding) * (genePool.length + 1);
      add(
        SpriteButtonComponent(
          button: await Sprite.load('player.png'),
          size: buttonSize,
          position: otherGen.position + Vector2(0, otherGen.size.y + padding),
          onPressed: popDown,
        ),
      );
    });
    add(otherGen);
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

  void popDown() {
    removeAll(children.query<Genome>());
    removeAll(children.query<SpriteButtonComponent>());
    add(Genome(game.world.player.genes, game.world.player.animation!));
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
