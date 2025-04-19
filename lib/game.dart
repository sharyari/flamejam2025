import 'dart:async';

import 'package:flame/events.dart';
import 'package:spacegame/consumable.dart';
import 'package:spacegame/player.dart';
import 'package:spacegame/earth.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class SpaceGame extends FlameGame {
  SpaceGame() : super(world: SpaceWorld());
}

class SpaceWorld extends World
    with HasCollisionDetection, TapCallbacks, DragCallbacks {
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

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    print("onTapDown");
    if (player.isOnGround) {
      player.isOnGround = false;
      player.acceleration.y -= 25;
      player.velocity.y -= 0;
    } else {
      player.acceleration.y -= 5;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    print("drag event");
    player.velocity.x += event.deviceDelta.x;
  }
}
