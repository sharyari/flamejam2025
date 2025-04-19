import 'package:flame/components.dart';
import 'package:spacegame/Player.dart';

class Hud extends RectangleComponent with HasGameReference {
  int num = 0;
  Hud(double width, double height)
      : super(
          position: Vector2(0, height - 150),
          size: Vector2(width, 150),
        );

  @override
  void onLoad() {
    add(TextComponent(text: 'Energy: '));
    super.onLoad();
  }

  @override
  void update(double dt) {
    Player player = game.world.children.query<Player>().first;
    num = player.energy;

    super.update(dt);
  }
}
