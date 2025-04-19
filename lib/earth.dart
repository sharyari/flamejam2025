import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Earth extends RectangleComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    size = Vector2(game.size.x * 20, game.size.y * 0.3);
    anchor = Anchor.bottomCenter;
    position.y = game.size.y;
    paint.color = Colors.green;
    add(RectangleHitbox());
  }
}
