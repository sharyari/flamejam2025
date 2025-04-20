import 'package:flame/components.dart';
import 'package:flutter/material.dart';

mixin Gravitation on PositionComponent {
  final velocity = Vector2(0, 0);
  final acceleration = Vector2(0, 0);
  bool isOnGround = true;

  @override
  @mustCallSuper
  void update(double dt) {
    super.update(dt);

    if (isOnGround) {
      return;
    }

    acceleration.y += 37 * dt;
    velocity.y += acceleration.y * dt * 40;
    position += velocity * dt;
  }
}
