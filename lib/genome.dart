import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/game.dart';
import 'package:spacegame/hud.dart';
import 'package:spacegame/player.dart';

class Genome extends RowComponent
    with HasGameReference<SpaceGame>, TapCallbacks {
  int num = 0;
  static const int numGenes = 3;
  static const double geneHeight = 64;
  static const double genomeWidth = (numGenes + 1) * geneHeight;
  static const double genomeHeight = geneHeight;
  Map<Trait, int> genes = {};
  SpriteAnimation animation;
  int pos = 0;
  Genome(this.genes, this.animation, this.pos);

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    // If this genome is at position >= 1, call popdown
    if (pos >= 1) {
      final hud = game.world.hud.popDown(pos);
    }
  }

  @override
  Future<void> onLoad() async {
    position = Vector2(Hud.padding, Hud.padding);
    size =
        Vector2(genomeWidth, genomeHeight); // Set proper size for hit testing
    priority = 10;
    int i = 0;
    for (final v in genes.values) {
      add(Gene(i++, v)); // Increment i for each gene
    }

    final spriteComponent = SpriteAnimationComponent(
      animation: animation,
      size: Vector2(Genome.geneHeight, Genome.geneHeight),
      position: Vector2(0, 0),
    );
    add(spriteComponent);
  }
}

class Gene extends RectangleComponent {
  int listPos = 0;
  int value = 0;
  Gene(this.listPos, this.value);
  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(Genome.geneHeight, Genome.geneHeight);
    position = Vector2(Genome.geneHeight * listPos, 0);
    paint = Paint()..color = Colors.lightGreen;

    add(
      TextComponent(
        text: '$value',
        position: size / 2,
        anchor: Anchor.center,
      ),
    );
  }
}
