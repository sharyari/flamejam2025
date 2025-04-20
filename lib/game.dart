import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:spacegame/background.dart';
import 'package:spacegame/consumables/bird.dart';
import 'package:spacegame/consumables/fishbird.dart';
import 'package:spacegame/consumables/frog.dart';
import 'package:spacegame/earth.dart';
import 'package:spacegame/hud.dart';
import 'package:spacegame/parallax_background.dart';
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
    camera.viewport.add(world.hud);
  }
}

class SpaceWorld extends World
    with
        HasCollisionDetection,
        TapCallbacks,
        DragCallbacks,
        HasGameReference,
        HasTimeScale {
  final earth = Earth();
  final player = Player();
  final bird = Bird();
  final fishBird = FishBird();

  late final List<Frog> frogs;
  final hud = Hud();
  final background = Background();

  @override
  FutureOr<void> onLoad() async {
    pause();
    await game.images.loadAll([
      'backgrounds/ground_parallax_element_1.png',
      'backgrounds/ground_parallax_element_2.png',
      'backgrounds/ground_parallax_element_3.png',
      'backgrounds/ground_parallax_element_4.png',
      'backgrounds/ground_tile_1.png',
    ]);
    await add(ParallaxBackground());
    await add(earth);

    add(background);

    await add(player);
    add(bird);
    add(fishBird);
    frogs = List.generate(10, (_) => Frog());
    addAll(frogs);

    // parent?.debugMode = true;
    camera?.follow(player);
    resume();
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
