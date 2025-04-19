import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';

class Player extends SpriteComponent with DragCallbacks, TapCallbacks {
  Player() {
    super.anchor = Anchor.center;
    super.size = Vector2(35, 35);
  }
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('player.png');
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(
      MoveByEffect(
        Vector2(0, -20),
        EffectController(duration: 0.2),
      ),
    );
    super.onTapDown(event);
  }
}
