import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../actors/player.dart';
import '../managers/segment_manager.dart';
import '../objects/ground.dart';
import '../objects/platform.dart';
import '../objects/star.dart';
import '../overlays/hud.dart';

class EmberQuestGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents,TapCallbacks {
  EmberQuestGame();

  late EmberPlayer _ember;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;

  int starsCollected = 0;
  int health = 3;
  double cloudSpeed = 0.0;
  double objectSpeed = 0.0;

  @override
  Future<void> onLoad() async {
    //debugMode = true; //Uncomment to see the bounding boxes
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
    ]);
    initializeGame(true);
  }

  @override
  void update(double dt) {
    if (health <= 0) {
      overlays.add('GameOver');
    }
    super.update(dt);
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case GroundBlock:
          add(
            GroundBlock(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
        case PlatformBlock:
          add(
            PlatformBlock(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
        case Star:
          add(
            Star(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
      }
    }
  }

  void initializeGame(bool loadHud) {
    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    _ember = EmberPlayer(
      position: Vector2(128, canvasSize.y - 128),
    );
    add(_ember);
    if (loadHud) {
      add(Hud());
    }
  }

  void reset() {
    FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'points': 0});
    starsCollected = 0;
    health = 3;
    initializeGame(false);
  }

  @override
  bool onTapUp(TapUpEvent event) {
    _ember.horizontalDirection = 0;
    _ember.horizontalDirection +=
    (event.continuePropagation || event.continuePropagation) ? -1 : 0;
    // horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
    //     keysPressed.contains(LogicalKeyboardKey.arrowRight))
    //     ? 1
    //     : 0;

    _ember.hasJumped = event.continuePropagation;
    return true;
  }
}