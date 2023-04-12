import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:workshop_gamejam/Game/quest.dart';
import 'package:workshop_gamejam/objects/ground.dart';
import 'package:workshop_gamejam/objects/platform.dart';
import 'package:workshop_gamejam/objects/star.dart';

class EmberPlayer extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<EmberQuestGame> {
  EmberPlayer({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  final Vector2 velocity = Vector2.zero();
  final Vector2 fromAbove = Vector2(0, -1);
  final double gravity = 20;
  final double jumpSpeed = 700;
  final double moveSpeed = 40;
  final double terminalVelocity = 800;

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
  void update(double dt) {
    // Ajouter la vitesse de déplacement horizontale au vecteur de vitesse de l'EmberPlayer
    velocity.x = 50;

    // Appliquer la vitesse de déplacement des objets à la position de l'EmberPlayer

    // Prevent ember from going backwards at screen edge.
    if (position.x - 36 <= 0 && horizontalDirection < 0) {
      velocity.x = 0;
    }

    if (position.x + 300 >= game.size.x) {
      velocity.x = 0;
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
    velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity / 2);

    // Adjust ember position.
    position += velocity * dt;

    // If ember fell in pit, then game over.
    if (position.y > game.size.y + size.y) {
      game.health = 0;
    }

    if (game.health <= 0) {
      removeFromParent();
    }

    game.objectSpeed = -115;
    game.camera.position.x = position.x - (game.size.x / 4) + (size.x / 4);
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
      FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({'points': FieldValue.increment(1)});
      FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({'records': FieldValue.increment(1)});
      other.removeFromParent();
      game.starsCollected++;
    }

    super.onCollision(intersectionPoints, other);
  }
}
