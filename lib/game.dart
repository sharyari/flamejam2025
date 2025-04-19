import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:spacegame/background.dart';
import 'package:spacegame/consumables/frog.dart';
import 'package:spacegame/consumables/bird.dart';
import 'package:spacegame/earth.dart';
import 'package:spacegame/hud.dart';
import 'package:spacegame/player.dart';

class SpaceGame extends FlameGame<SpaceWorld> {
  SpaceGame()
      : super(
          world: SpaceWorld(),
          camera: CameraComponent.withFixedResolution(width: 800, height: 800),
        );

  @override
  void onLoad() {
    super.onLoad();
    camera.viewport.add(Hud());
  }
}

class SpaceWorld extends World
    with HasCollisionDetection, TapCallbacks, DragCallbacks, HasGameReference {
  final earth = Earth();
  final player = Player();
  final bird = Bird();
  final frog1 = Frog();
  final frog2 = Frog();
  final frog3 = Frog();
  final frog4 = Frog();
  final frog5 = Frog();
  final background = Background();

  @override
  FutureOr<void> onLoad() {
    add(earth);
    add(player);
    add(bird);
    add(frog1);
    add(frog2);
    add(frog3);
    add(frog4);
    add(frog5);
    add(background);
    parent?.debugMode = true;
    camera?.follow(player);
    //
    return super.onLoad();
  }

  CameraComponent? get camera => game.camera;

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    player.tapped();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    player.velocity.x += event.deviceDelta.x;
  }
}
