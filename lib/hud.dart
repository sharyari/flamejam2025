import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/player.dart';

class Hud extends RectangleComponent with HasGameReference {
  int num = 0;
  @override
  Future<void> onLoad() async {
    add(TextComponent(text: 'Energy: $num'));
    position = Vector2(0, game.size.y - 150);
    size = Vector2(game.size.x, 150);
    paint.color = Colors.blueGrey;
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
