import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/hud.dart';
import 'package:spacegame/player.dart';

class Genome extends RowComponent with HasGameReference {
  int num = 0;
  static const int numGenes = 3;
  static const double geneHeight = 64;
  static const double genomeWidth = numGenes * geneHeight;
  static const double genomeHeight = geneHeight;
  Map<Trait, int> genes;

  Genome(this.genes);

  @override
  Future<void> onLoad() async {
    position = Vector2(Hud.padding, Hud.padding);
    size = Vector2(0, genomeHeight);
    priority = 10;
    int i = 0;
    for (int v in genes.values) {
      final genePosition = Vector2(
        i * geneHeight,
        0,
      );
      add(Gene(i, v));
    }
  }
}

class Gene extends RectangleComponent {
  var listPos = 0;
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
