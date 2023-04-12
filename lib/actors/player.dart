import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import '../Game/quest.dart';
import '../objects/ground.dart';
import '../objects/platform.dart';
import '../objects/star.dart';

class EmberPlayer extends SpriteAnimationComponent
    with TapCallbacks, CollisionCallbacks, HasGameRef<EmberQuestGame> {
  EmberPlayer({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  final Vector2 velocity = Vector2.zero();
  final Vector2 fromAbove = Vector2(0, -1);
  final double gravity = 15;
  final double jumpSpeed = 600;
  final double moveSpeed = 20;
  final double terminalVelocity = 100;

  int horizontalDirection = 0;

  bool hasJumped = false;
  bool isOnGround = false;
  bool hitByEnemy = false;

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );

    add(
      CircleHitbox(),
    );

    // Set the game reference.
    game = gameRef as EmberQuestGame;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    horizontalDirection = 0;
    horizontalDirection +=
        (event.continuePropagation || event.continuePropagation) ? -1 : 0;
    // horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
    //     keysPressed.contains(LogicalKeyboardKey.arrowRight))
    //     ? 1
    //     : 0;

    hasJumped = event.continuePropagation;
    return true;
  }

  @override
  void update(double dt) {

    // Ajouter la vitesse de déplacement horizontale au vecteur de vitesse de l'EmberPlayer
    velocity.x = moveSpeed;

    // Appliquer la vitesse de déplacement des objets à la position de l'EmberPlayer

    // Prevent ember from going backwards at screen edge.
    if (position.x - 24 <= 0 && horizontalDirection < 0) {
      velocity.x = 0;
    }
    // Prevent ember from going beyond half screen.
    if (position.x + 64 >= game.size.x / 2 && horizontalDirection > 0) {
      velocity.x = 0;
      game.objectSpeed = -moveSpeed;
    }

    // Apply basic gravity.
    velocity.y += gravity;

    // Determine if ember has jumped.
    if (hasJumped) {
      if (isOnGround) {
        velocity.y = -jumpSpeed;
        isOnGround = false;
      }
      hasJumped = false;
    }

    // Prevent ember from jumping to crazy fast.
    velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity);

    // Adjust ember position.
    position += velocity * dt;

    // If ember fell in pit, then game over.
    if (position.y > game.size.y + size.y) {
      game.health = 0;
    }

    if (game.health <= 0) {
      removeFromParent();
    }

    // Flip ember if needed.
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }
    game.objectSpeed = -velocity.x;
    game.camera.position.x = position.x - (game.size.x / 6);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock || other is PlatformBlock) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collision normal is almost upwards,
        // ember must be on ground.
        if (fromAbove.dot(collisionNormal) > 0.9) {
          isOnGround = true;
        }

        // Resolve collision by moving ember along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
      }
    }

    if (other is Star) {
      other.removeFromParent();
      game.starsCollected++;
    }

    super.onCollision(intersectionPoints, other);
  }

}
