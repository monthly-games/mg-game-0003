import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class MonsterEntity extends SpriteComponent with HasGameRef {
  double maxHp = 50;
  double hp = 50;
  double speed = 50;
  final bool isBoss;

  MonsterEntity({
    required Vector2 position,
    this.isBoss = false,
    double hpMultiplier = 1.0,
  }) : super(
         position: position,
         size: isBoss ? Vector2.all(64) : Vector2.all(32),
         anchor: Anchor.center,
       ) {
    maxHp = (isBoss ? 500 : 50) * hpMultiplier;
    hp = maxHp;
    speed = isBoss ? 30 : 50; // Boss moves slower
  }

  @override
  Future<void> onLoad() async {
    final spriteName = isBoss ? 'monster_boss.png' : 'monster_basic.png';
    sprite = await gameRef.loadSprite(spriteName);
  }

  bool get isDead => hp <= 0;

  @override
  void update(double dt) {
    super.update(dt);
    // Move Left
    x -= speed * dt;

    // Despawn if off screen (Boss shouldn't despawn easily, but for now ok)
    if (x < -100) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // HP Bar
    final hpPct = hp / maxHp;
    canvas.drawRect(
      Rect.fromLTWH(0, -10, size.x * hpPct.clamp(0.0, 1.0), 5),
      BasicPalette.yellow.paint(),
    );
  }

  void takeDamage(double amount) {
    hp -= amount;
  }
}
