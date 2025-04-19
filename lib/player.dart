import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Player extends SpriteComponent with KeyboardHandler {
  Player() {
    super.anchor = Anchor.center;
    super.size = Vector2(35, 35);
  }
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('player.png');
    return super.onLoad();
  }
}
