import 'dart:async';

import 'package:spacegame/player.dart';
import 'package:spacegame/earth.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class SpaceGame extends FlameGame {
  SpaceGame() : super(world: SpaceWorld());
}

class SpaceWorld extends World {
  Player player = Player();
  Earth earth = Earth();
  @override
  FutureOr<void> onLoad() {
    add(player);
    add(earth);
    // TODO: implement onLoad
    return super.onLoad();
  }
}
