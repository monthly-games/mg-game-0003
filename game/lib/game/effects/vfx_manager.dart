import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// VFX Manager for Pixel Mercenary Guild (MG-0003)
/// Idle JRPG Combat 게임 전용 이펙트 관리자
class VfxManager extends Component with HasGameRef {
  VfxManager();

  final Random _random = Random();

  // ============================================================
  // Combat Effects
  // ============================================================

  /// 일반 공격 히트
  void showHit(Vector2 position, {Color color = Colors.white}) {
    gameRef.add(
      _createHitEffect(position: position, color: color, isCritical: false),
    );
  }

  /// 크리티컬 히트
  void showCriticalHit(Vector2 position) {
    gameRef.add(
      _createHitEffect(position: position, color: Colors.yellow, isCritical: true),
    );

    // 추가 스파클
    gameRef.add(
      _createSparkleEffect(position: position, color: Colors.amber, count: 12),
    );
  }

  /// 데미지 숫자 표시
  void showDamageNumber(Vector2 position, int damage, {bool isCritical = false, bool isHeal = false}) {
    gameRef.add(
      _DamageNumber(
        position: position,
        damage: damage,
        isCritical: isCritical,
        isHeal: isHeal,
      ),
    );
  }

  /// 스킬 시전 이펙트
  void showSkillCast(Vector2 position, Color skillColor) {
    // 집중 이펙트 (안으로 모이는)
    gameRef.add(
      _createConvergeEffect(position: position, color: skillColor),
    );

    // 바닥 원형 이펙트
    gameRef.add(
      _createGroundCircle(position: position, color: skillColor),
    );
  }

  /// 스킬 적중 이펙트
  void showSkillHit(Vector2 position, Color skillColor, {double radius = 50}) {
    gameRef.add(
      _createExplosionEffect(
        position: position,
        color: skillColor,
        count: 30,
        radius: radius,
      ),
    );
  }

  /// 버프 적용
  void showBuffApply(Vector2 position, Color buffColor) {
    gameRef.add(
      _createBuffEffect(position: position, color: buffColor, isDebuff: false),
    );
  }

  /// 디버프 적용
  void showDebuffApply(Vector2 position, Color debuffColor) {
    gameRef.add(
      _createBuffEffect(position: position, color: debuffColor, isDebuff: true),
    );
  }

  /// 적 처치
  void showEnemyDeath(Vector2 position) {
    // 폭발
    gameRef.add(
      _createExplosionEffect(
        position: position,
        color: Colors.orange,
        count: 25,
        radius: 60,
      ),
    );

    // 연기
    gameRef.add(
      _createSmokeEffect(position: position, count: 8),
    );
  }

  /// 보스 처치
  void showBossDeath(Vector2 position) {
    // 대형 폭발
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (!isMounted) return;
        final offset = Vector2(
          (_random.nextDouble() - 0.5) * 80,
          (_random.nextDouble() - 0.5) * 80,
        );
        gameRef.add(
          _createExplosionEffect(
            position: position + offset,
            color: i == 1 ? Colors.purple : Colors.orange,
            count: 40,
            radius: 80,
          ),
        );
      });
    }

    // 스크린 쉐이크
    _triggerScreenShake(intensity: 10, duration: 0.8);
  }

  // ============================================================
  // Idle/Progression Effects
  // ============================================================

  /// 경험치 획득
  void showExpGain(Vector2 position, int amount) {
    gameRef.add(
      _createRisingEffect(
        position: position,
        color: Colors.lightBlue,
        count: 8,
        speed: 60,
      ),
    );

    showNumberPopup(position, '+$amount EXP', color: Colors.lightBlue);
  }

  /// 레벨업
  void showLevelUp(Vector2 position) {
    // 큰 폭발
    gameRef.add(
      _createExplosionEffect(
        position: position,
        color: Colors.amber,
        count: 50,
        radius: 100,
      ),
    );

    // 올라가는 별
    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: i * 80), () {
        if (!isMounted) return;
        gameRef.add(
          _createSparkleEffect(
            position: position + Vector2((_random.nextDouble() - 0.5) * 60, 0),
            color: Colors.yellow,
            count: 6,
          ),
        );
      });
    }

    // 텍스트
    gameRef.add(
      _LevelUpText(position: position),
    );
  }

  /// 골드 획득
  void showGoldGain(Vector2 position, int amount) {
    gameRef.add(
      _createCoinEffect(position: position, count: (amount / 10).clamp(5, 15).toInt()),
    );
  }

  /// 아이템 드롭
  void showItemDrop(Vector2 position, {bool isRare = false}) {
    final color = isRare ? Colors.purple : Colors.blue;

    gameRef.add(
      _createSparkleEffect(position: position, color: color, count: isRare ? 15 : 8),
    );

    if (isRare) {
      gameRef.add(
        _createGroundCircle(position: position, color: Colors.purple),
      );
    }
  }

  // ============================================================
  // Utility
  // ============================================================

  void showNumberPopup(Vector2 position, String text, {Color color = Colors.white}) {
    gameRef.add(
      _NumberPopup(position: position, text: text, color: color),
    );
  }

  void _triggerScreenShake({double intensity = 5, double duration = 0.3}) {
    if (gameRef.camera.viewfinder.children.isNotEmpty) {
      gameRef.camera.viewfinder.add(
        MoveByEffect(
          Vector2(intensity, 0),
          EffectController(
            duration: duration / 10,
            repeatCount: (duration * 10).toInt(),
            alternate: true,
          ),
        ),
      );
    }
  }

  // ============================================================
  // Private Effect Generators
  // ============================================================

  ParticleSystemComponent _createHitEffect({
    required Vector2 position,
    required Color color,
    required bool isCritical,
  }) {
    final count = isCritical ? 20 : 12;
    final speed = isCritical ? 150.0 : 100.0;

    return ParticleSystemComponent(
      particle: Particle.generate(
        count: count,
        lifespan: 0.4,
        generator: (i) {
          final angle = (i / count) * 2 * pi;
          final velocity = Vector2(cos(angle), sin(angle)) *
              (speed * (0.5 + _random.nextDouble() * 0.5));

          return AcceleratedParticle(
            position: position.clone(),
            speed: velocity,
            acceleration: Vector2(0, 200),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final progress = particle.progress;
                final opacity = (1.0 - progress).clamp(0.0, 1.0);
                final size = (isCritical ? 5 : 3) * (1.0 - progress * 0.5);

                canvas.drawCircle(
                  Offset.zero,
                  size,
                  Paint()..color = color.withOpacity(opacity),
                );
              },
            ),
          );
        },
      ),
    );
  }

  ParticleSystemComponent _createExplosionEffect({
    required Vector2 position,
    required Color color,
    required int count,
    required double radius,
  }) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: count,
        lifespan: 0.8,
        generator: (i) {
          final angle = _random.nextDouble() * 2 * pi;
          final speed = radius * (0.3 + _random.nextDouble() * 0.7);
          final velocity = Vector2(cos(angle), sin(angle)) * speed;

          return AcceleratedParticle(
            position: position.clone(),
            speed: velocity,
            acceleration: Vector2(0, 100),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final progress = particle.progress;
                final opacity = (1.0 - progress).clamp(0.0, 1.0);
                final size = (1.0 - progress * 0.5) * 5;

                canvas.drawCircle(
                  Offset.zero,
                  size,
                  Paint()..color = Color.lerp(color, Colors.red, progress)!.withOpacity(opacity),
                );
              },
            ),
          );
        },
      ),
    );
  }

  ParticleSystemComponent _createConvergeEffect({
    required Vector2 position,
    required Color color,
  }) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 12,
        lifespan: 0.6,
        generator: (i) {
          final startAngle = (i / 12) * 2 * pi;
          final startPos = Vector2(cos(startAngle), sin(startAngle)) * 50;

          return MovingParticle(
            from: position + startPos,
            to: position.clone(),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final opacity = (1.0 - particle.progress * 0.5).clamp(0.0, 1.0);

                canvas.drawCircle(
                  Offset.zero,
                  4,
                  Paint()..color = color.withOpacity(opacity),
                );
              },
            ),
          );
        },
      ),
    );
  }

  ParticleSystemComponent _createBuffEffect({
    required Vector2 position,
    required Color color,
    required bool isDebuff,
  }) {
    final direction = isDebuff ? 1.0 : -1.0; // 디버프는 아래로, 버프는 위로

    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 15,
        lifespan: 0.8,
        generator: (i) {
          final spreadX = (_random.nextDouble() - 0.5) * 40;

          return AcceleratedParticle(
            position: position.clone() + Vector2(spreadX, isDebuff ? -20 : 20),
            speed: Vector2(0, direction * 50),
            acceleration: Vector2(0, direction * 30),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final opacity = (1.0 - particle.progress).clamp(0.0, 1.0);

                canvas.drawCircle(
                  Offset.zero,
                  3,
                  Paint()..color = color.withOpacity(opacity * 0.7),
                );
              },
            ),
          );
        },
      ),
    );
  }

  ParticleSystemComponent _createGroundCircle({
    required Vector2 position,
    required Color color,
  }) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 1,
        lifespan: 0.8,
        generator: (i) {
          return ComputedParticle(
            renderer: (canvas, particle) {
              final progress = particle.progress;
              final opacity = (1.0 - progress).clamp(0.0, 1.0);
              final radius = 20 + progress * 40;

              canvas.drawCircle(
                Offset(position.x, position.y),
                radius,
                Paint()
                  ..color = color.withOpacity(opacity * 0.5)
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3,
              );
            },
          );
        },
      ),
    );
  }

  ParticleSystemComponent _createSparkleEffect({
    required Vector2 position,
    required Color color,
    required int count,
  }) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: count,
        lifespan: 0.6,
        generator: (i) {
          final angle = _random.nextDouble() * 2 * pi;
          final speed = 50 + _random.nextDouble() * 30;
          final velocity = Vector2(cos(angle), sin(angle)) * speed;

          return AcceleratedParticle(
            position: position.clone(),
            speed: velocity,
            acceleration: Vector2(0, 30),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final opacity = (1.0 - particle.progress).clamp(0.0, 1.0);
                final size = 3 * (1.0 - particle.progress * 0.5);

                // 별 모양
                final path = Path();
                for (int j = 0; j < 5; j++) {
                  final a = (j * 4 * pi / 5) - pi / 2;
                  final x = cos(a) * size;
                  final y = sin(a) * size;
                  if (j == 0) {
                    path.moveTo(x, y);
                  } else {
                    path.lineTo(x, y);
                  }
                }
                path.close();

                canvas.drawPath(
                  path,
                  Paint()..color = color.withOpacity(opacity),
                );
              },
            ),
          );
        },
      ),
    );
  }

  ParticleSystemComponent _createRisingEffect({
    required Vector2 position,
    required Color color,
    required int count,
    required double speed,
  }) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: count,
        lifespan: 1.0,
        generator: (i) {
          final spreadX = (_random.nextDouble() - 0.5) * 40;

          return AcceleratedParticle(
            position: position.clone() + Vector2(spreadX, 0),
            speed: Vector2(0, -speed),
            acceleration: Vector2(0, -20),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final progress = particle.progress;
                final opacity = (1.0 - progress).clamp(0.0, 1.0);

                canvas.drawCircle(
                  Offset.zero,
                  3,
                  Paint()..color = color.withOpacity(opacity),
                );
              },
            ),
          );
        },
      ),
    );
  }

  ParticleSystemComponent _createSmokeEffect({
    required Vector2 position,
    required int count,
  }) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: count,
        lifespan: 1.0,
        generator: (i) {
          final spreadX = (_random.nextDouble() - 0.5) * 30;

          return AcceleratedParticle(
            position: position.clone() + Vector2(spreadX, 0),
            speed: Vector2(
              (_random.nextDouble() - 0.5) * 20,
              -30 - _random.nextDouble() * 20,
            ),
            acceleration: Vector2(0, -10),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final progress = particle.progress;
                final opacity = (0.5 - progress * 0.5).clamp(0.0, 1.0);
                final size = 6 + progress * 10;

                canvas.drawCircle(
                  Offset.zero,
                  size,
                  Paint()..color = Colors.grey.withOpacity(opacity),
                );
              },
            ),
          );
        },
      ),
    );
  }

  ParticleSystemComponent _createCoinEffect({
    required Vector2 position,
    required int count,
  }) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: count,
        lifespan: 0.8,
        generator: (i) {
          final angle = -pi / 2 + (_random.nextDouble() - 0.5) * pi / 3;
          final speed = 150 + _random.nextDouble() * 100;
          final velocity = Vector2(cos(angle), sin(angle)) * speed;

          return AcceleratedParticle(
            position: position.clone(),
            speed: velocity,
            acceleration: Vector2(0, 400),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final opacity = (1.0 - particle.progress * 0.3).clamp(0.0, 1.0);
                final rotation = particle.progress * 4 * pi;

                canvas.save();
                canvas.rotate(rotation);

                canvas.drawOval(
                  const Rect.fromLTWH(-4, -3, 8, 6),
                  Paint()..color = Colors.amber.withOpacity(opacity),
                );

                canvas.restore();
              },
            ),
          );
        },
      ),
    );
  }
}

/// 데미지 숫자 컴포넌트
class _DamageNumber extends TextComponent {
  final int damage;
  final bool isCritical;
  final bool isHeal;

  _DamageNumber({
    required Vector2 position,
    required this.damage,
    this.isCritical = false,
    this.isHeal = false,
  }) : super(
          text: isHeal ? '+$damage' : '$damage',
          position: position,
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: TextStyle(
              fontSize: isCritical ? 28 : 20,
              fontWeight: FontWeight.bold,
              color: isHeal ? Colors.green : (isCritical ? Colors.yellow : Colors.white),
              shadows: const [
                Shadow(color: Colors.black, blurRadius: 4, offset: Offset(1, 1)),
              ],
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(MoveByEffect(
      Vector2(0, isCritical ? -60 : -40),
      EffectController(duration: 0.8, curve: Curves.easeOut),
    ));

    if (isCritical) {
      add(ScaleEffect.by(
        Vector2.all(1.3),
        EffectController(duration: 0.15, reverseDuration: 0.15),
      ));
    }

    add(OpacityEffect.fadeOut(
      EffectController(duration: 0.8, startDelay: 0.3),
    ));

    add(RemoveEffect(delay: 1.0));
  }
}

/// 레벨업 텍스트
class _LevelUpText extends TextComponent {
  _LevelUpText({required Vector2 position})
      : super(
          text: 'LEVEL UP!',
          position: position + Vector2(0, -50),
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
              letterSpacing: 2,
              shadows: [
                Shadow(color: Colors.orange, blurRadius: 10),
                Shadow(color: Colors.black, blurRadius: 4, offset: Offset(2, 2)),
              ],
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    scale = Vector2.all(0.5);
    add(ScaleEffect.to(
      Vector2.all(1.2),
      EffectController(duration: 0.3, curve: Curves.elasticOut),
    ));

    add(MoveByEffect(
      Vector2(0, -30),
      EffectController(duration: 1.5, curve: Curves.easeOut),
    ));

    add(OpacityEffect.fadeOut(
      EffectController(duration: 1.5, startDelay: 0.5),
    ));

    add(RemoveEffect(delay: 2.0));
  }
}

/// 일반 텍스트 팝업
class _NumberPopup extends TextComponent {
  _NumberPopup({
    required Vector2 position,
    required String text,
    required Color color,
  }) : super(
          text: text,
          position: position,
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
              shadows: const [
                Shadow(color: Colors.black, blurRadius: 4, offset: Offset(1, 1)),
              ],
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(MoveByEffect(
      Vector2(0, -30),
      EffectController(duration: 0.8, curve: Curves.easeOut),
    ));

    add(OpacityEffect.fadeOut(
      EffectController(duration: 0.8, startDelay: 0.3),
    ));

    add(RemoveEffect(delay: 1.0));
  }
}
