import 'package:flame/components.dart';
import 'package:workshop_gamejam/actors/enemy.dart';
import 'package:workshop_gamejam/objects/ground.dart';
import 'package:workshop_gamejam/objects/platform.dart';

import '../objects/star.dart';

class Block {
  // gridPosition position is always segment based X,Y.
  // 0,0 is the bottom left corner.
  // 10,10 is the upper right corner.
  final Vector2 gridPosition;
  final Type blockType;
  Block(this.gridPosition, this.blockType);
}

final segments = [
  segment0,
  segment1,
  segment2,
  segment3,
  segment4,
];

final segment0 = [
  Block(Vector2(0, 0), Ground),
  Block(Vector2(1, 0), Ground),
  Block(Vector2(2, 0), Ground),
  Block(Vector2(3, 0), Ground),
  Block(Vector2(4, 0), Ground),
  Block(Vector2(5, 0), Ground),
  Block(Vector2(5, 1), Enemy),
  Block(Vector2(5, 3), Platform),
  Block(Vector2(6, 0), Ground),
  Block(Vector2(6, 3), Platform),
  Block(Vector2(7, 0), Ground),
  Block(Vector2(7, 3), Platform),
  Block(Vector2(8, 0), Ground),
  Block(Vector2(8, 3), Platform),
  Block(Vector2(9, 0), Ground),
];

final segment1 = [
  Block(Vector2(0, 0), Ground),
  Block(Vector2(1, 0), Ground),
  Block(Vector2(1, 1), Platform),
  Block(Vector2(1, 2), Platform),
  Block(Vector2(1, 3), Platform),
  Block(Vector2(2, 6), Platform),
  Block(Vector2(3, 6), Platform),
  Block(Vector2(6, 5), Platform),
  Block(Vector2(7, 5), Platform),
  Block(Vector2(7, 7), Star),
  Block(Vector2(8, 0), Ground),
  Block(Vector2(8, 1), Platform),
  Block(Vector2(8, 5), Platform),
  Block(Vector2(8, 6), Enemy),
  Block(Vector2(9, 0), Ground),
];

final segment2 = [
  Block(Vector2(0, 0), Ground),
  Block(Vector2(1, 0), Ground),
  Block(Vector2(2, 0), Ground),
  Block(Vector2(3, 0), Ground),
  Block(Vector2(3, 3), Platform),
  Block(Vector2(4, 0), Ground),
  Block(Vector2(4, 3), Platform),
  Block(Vector2(5, 0), Ground),
  Block(Vector2(5, 3), Platform),
  Block(Vector2(5, 4), Enemy),
  Block(Vector2(6, 0), Ground),
  Block(Vector2(6, 3), Platform),
  Block(Vector2(6, 4), Platform),
  Block(Vector2(6, 5), Platform),
  Block(Vector2(6, 7), Star),
  Block(Vector2(7, 0), Ground),
  Block(Vector2(8, 0), Ground),
  Block(Vector2(9, 0), Ground),
];

final segment3 = [
  Block(Vector2(0, 0), Ground),
  Block(Vector2(1, 0), Ground),
  Block(Vector2(1, 1), Enemy),
  Block(Vector2(2, 0), Ground),
  Block(Vector2(2, 1), Platform),
  Block(Vector2(2, 2), Platform),
  Block(Vector2(4, 4), Platform),
  Block(Vector2(6, 6), Platform),
  Block(Vector2(7, 0), Ground),
  Block(Vector2(7, 1), Platform),
  Block(Vector2(8, 0), Ground),
  Block(Vector2(8, 8), Star),
  Block(Vector2(9, 0), Ground),
];

final segment4 = [
  Block(Vector2(0, 0), Ground),
  Block(Vector2(1, 0), Ground),
  Block(Vector2(2, 0), Ground),
  Block(Vector2(2, 3), Platform),
  Block(Vector2(3, 0), Ground),
  Block(Vector2(3, 1), Enemy),
  Block(Vector2(3, 3), Platform),
  Block(Vector2(4, 0), Ground),
  Block(Vector2(5, 0), Ground),
  Block(Vector2(5, 5), Platform),
  Block(Vector2(6, 0), Ground),
  Block(Vector2(6, 5), Platform),
  Block(Vector2(6, 7), Star),
  Block(Vector2(7, 0), Ground),
  Block(Vector2(8, 0), Ground),
  Block(Vector2(8, 3), Platform),
  Block(Vector2(9, 0), Ground),
  Block(Vector2(9, 1), Enemy),
  Block(Vector2(9, 3), Platform),
];