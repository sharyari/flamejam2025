import 'dart:async';

import 'package:spacegame/consumable.dart';
import 'package:spacegame/player.dart';
import 'package:spacegame/earth.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class SpaceGame extends FlameGame {
  SpaceGame() : super(world: SpaceWorld());
}

class SpaceWorld extends World with HasCollisionDetection {
  Earth earth = Earth();
  Player player = Player();
  Consumable consumable = Consumable(type: GenomeType.flight);
  @override
  FutureOr<void> onLoad() {
    add(earth);
    add(player);
    add(consumable);
    debugMode = true;
    return super.onLoad();
  }
}
