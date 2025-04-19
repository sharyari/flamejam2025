import 'dart:async';

import 'package:spacegame/player.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class SpaceGame extends FlameGame {
  SpaceGame() : super(world: SpaceWorld());
}

class SpaceWorld extends World {
  Player player = Player();
  @override
  FutureOr<void> onLoad() {
    add(player);
    // TODO: implement onLoad
    return super.onLoad();
  }
}
