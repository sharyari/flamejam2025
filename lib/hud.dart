import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/player.dart';

class Hud extends RectangleComponent with HasGameReference {
  int num = 0;
  static int numGenes = 4;
  static double innerPadding = 8;
  static double geneHeight = 64;
  double hudWidth = 80;
  double hudHeight = (numGenes * geneHeight + 2 * innerPadding).toDouble();
  int xPadding = 30;
  int yPadding = 30;

  List genes = [0, 0, 0, 0];

  @override
  Future<void> onLoad() async {
    position = Vector2(
        game.size.x - hudWidth - xPadding, game.size.y - hudHeight - yPadding);
    size = Vector2(hudWidth, hudHeight);
    paint.color = Colors.blue;
    priority = 10;
    for (int i = 0; i < numGenes; i++) {
      Vector2 genePosition =
          Vector2(innerPadding, innerPadding + i * geneHeight);
      print("adding small box");
      add(RectangleComponent(
          position: genePosition,
          size: Vector2(geneHeight, geneHeight),
          paint: Paint()..color = Colors.red,
          priority: 100));
    }
  }

  @override
  void update(double dt) {
    final players = game.world.children.query<Player>();
    if (players.isEmpty) {
      return;
    }

    num = players.first.energy;

    super.update(dt);
  }
}
