import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/genome.dart';
import 'package:spacegame/game.dart';
import 'package:spacegame/player.dart';

class Hud extends RectangleComponent with HasGameReference<SpaceGame> {
  static const double padding = 8;
  late Vector2 initialSize, initialPosition;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(
        Genome.genomeWidth + 2 * padding, Genome.genomeHeight + 2 * padding);
    position = Vector2(game.size.x - size.x, game.size.y - size.y);
    initialPosition = position.clone();
    initialSize = size.clone();

    return game.world.player.loaded.then((_) {
      Genome playerGenome = Genome(game.world.player.genes);
      add(playerGenome);
    });
  }

  void popup(List<Map<Trait, int>> genePool, Map<Trait, int> candidate) async {
    final newPos = game.size / 2;
    Vector2 buttonSize = Vector2(200, 50);
    Vector2 targetSize = Vector2(
      size.x,
      (genePool.length + 1) * (Genome.genomeHeight + padding) +
          2 * padding +
          buttonSize.y,
    );

    game.world.pause();
    for (int i = 1; i < genePool.length; i++) {
      Genome gen = Genome(genePool[i]);
      gen.mounted.then((_) {
        gen.position.y += (Genome.genomeHeight + padding) * i;
      });
      add(gen);
      print('Position: $gen.position');
    }
    Genome otherGen = Genome(candidate);
    otherGen.mounted.then((_) async {
      otherGen.position.y += (Genome.genomeHeight + padding) * genePool.length;
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
    add(Genome(game.world.player.genes));
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
      AnchorToEffect(Anchor.topLeft, EffectController(duration: 1),
          onComplete: game.world.resume),
    );
  }
}
