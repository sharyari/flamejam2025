import 'dart:async';

import 'package:flame/events.dart';
import 'package:spacegame/consumable.dart';
import 'package:spacegame/genomes/bird.dart';
import 'package:spacegame/player.dart';
import 'package:spacegame/earth.dart';
import 'package:spacegame/hud.dart';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

class SpaceGame extends FlameGame with HasGameReference {
  SpaceGame()
      : super(
          world: SpaceWorld(),
          camera: CameraComponent.withFixedResolution(width: 800, height: 800),
        );

  @override
  onLoad() {
    super.onLoad();
    camera?.viewport.add(Hud(game.size.x, game.size.y));
  }
}

class SpaceWorld extends World
    with HasCollisionDetection, TapCallbacks, DragCallbacks, HasGameReference {
  final earth = Earth();
  final player = Player();
  final bird = Bird();

  @override
  FutureOr<void> onLoad() {
    add(earth);
    add(player);
    add(bird);
    parent?.debugMode = true;
    camera?.follow(player);
    //
    return super.onLoad();
  }

  CameraComponent? get camera => game.camera;

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    print("onTapDown");
    player.tapped();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    print("drag event");
    player.velocity.x += event.deviceDelta.x;
  }
}
