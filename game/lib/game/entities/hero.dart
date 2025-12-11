import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import '../data/hero_data.dart';

class HeroEntity extends PositionComponent {
  final HeroData data;
  double _currentHp = 0;

  HeroEntity({required this.data, required Vector2 position})
    : super(position: position, size: Vector2.all(32), anchor: Anchor.center) {
    _currentHp = data.hp.value;
  }

  bool get isDead => _currentHp <= 0;

  @override
  void render(Canvas canvas) {
    if (isDead) return;

    Paint paint;
    switch (data.role) {
      case HeroRole.tank:
        paint = BasicPalette.blue.paint();
        break;
      case HeroRole.archer:
        paint = BasicPalette.green.paint();
        break;
      case HeroRole.healer:
        paint = BasicPalette.magenta.paint();
        break;
    }

    canvas.drawRect(size.toRect(), paint);

    // HP Bar
    final hpPct = _currentHp / data.hp.value;
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
    _currentHp = (_currentHp + amount).clamp(0, data.hp.value);
  }

  double get hpPercent => _currentHp / data.hp.value;
  double get currentHp => _currentHp;

  void respawn() {
    _currentHp = data.hp.value;
  }
}
