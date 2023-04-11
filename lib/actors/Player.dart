import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../game/Game.dart';

class Player extends SpriteAnimationComponent
    with TapCallbacks, HasGameRef<EmberGame> {
  int horizontalDirection = 0;
  Player({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Do something in response to a tap event
    print("ok");
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    position += velocity * dt;
    super.update(dt);
  }
}