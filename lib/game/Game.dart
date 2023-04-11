import 'dart:ui';

import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:workshop_gamejam/actors/enemy.dart';
import 'package:workshop_gamejam/objects/platform.dart';

import '../managers/segment_manager.dart';
import '../objects/ground.dart';
import '../objects/star.dart';
import 'Player.dart';

class EmberGame extends FlameGame with HasKeyboardHandlerComponents {
  late Player _ember;
  double objectSpeed = 0.0;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;
  EmberGame();

  @override
  Color backgroundColor() {
    // TODO: implement backgroundColor
    return const Color.fromARGB(255, 173, 223, 247);
  }

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);
    initializeGame();
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case Ground:
          add(Ground(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case Platform:
          add(Platform(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case Star:
          add(Star(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case Enemy:
          add(Enemy(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
      }
    }
  }

  void initializeGame() {
    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    _ember = Player(
      position: Vector2(128, canvasSize.y - 70),
    );
    add(_ember);
  }
}