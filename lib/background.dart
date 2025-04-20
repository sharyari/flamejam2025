import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Background extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('backgrounds/space_2.png');
    anchor = Anchor.center;
    sprite = Sprite(
      image,
      srcPosition: Vector2(0, 0),
      srcSize: Vector2(2732, 2048),
    );
    position = Vector2(0, 0);
    size = Vector2(2732, 2048);
    priority = -1;
  }
}
