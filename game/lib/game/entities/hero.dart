import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import '../data/hero_data.dart';

class HeroEntity extends SpriteComponent with HasGameReference {
  final HeroData data;
  double _currentHp = 0;

  HeroEntity({required this.data, required Vector2 position})
    : super(position: position, size: Vector2.all(32), anchor: Anchor.center) {
    _currentHp = data.currentHp;
  }

  @override
  Future<void> onLoad() async {
    String spriteName;
    switch (data.role) {
      case HeroRole.tank:
        spriteName = 'hero_knight.png';
        break;
      case HeroRole.archer:
        spriteName = 'hero_ranger.png';
        break;
      case HeroRole.healer:
        spriteName = 'hero_cleric.png';
        break;
      case HeroRole.mage:
        spriteName = 'hero_mage.png';
        break;
      case HeroRole.assassin:
        spriteName = 'hero_assassin.png';
        break;
    }
    sprite = await game.loadSprite(spriteName);
  }

  bool get isDead => _currentHp <= 0;

  @override
  void render(Canvas canvas) {
    if (isDead) return;

    super.render(canvas);

    // HP Bar
    final hpPct = _currentHp / data.currentHp;
    canvas.drawRect(
      Rect.fromLTWH(0, -10, size.x * hpPct.clamp(0.0, 1.0), 5),
      BasicPalette.red.paint(),
    );
  }

  void takeDamage(double amount) {
    _currentHp -= amount;
  }

  void heal(double amount) {
    if (isDead) return;
    _currentHp = (_currentHp + amount).clamp(0, data.currentHp);
  }

  double get hpPercent => _currentHp / data.currentHp;
  double get currentHp => _currentHp;

  void respawn() {
    _currentHp = data.currentHp;
  }
}
