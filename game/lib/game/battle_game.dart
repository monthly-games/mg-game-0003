import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:get_it/get_it.dart';
import 'logic/game_manager.dart';
import 'logic/stage_manager.dart';
import 'data/hero_data.dart';
import 'entities/hero.dart';
import 'entities/monster.dart';

class BattleGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF333333); // Dark Gray ground

  // Squad
  final List<HeroEntity> heroes = [];

  // Wave Logic
  Timer? _spawnTimer;

  @override
  Future<void> onLoad() async {
    final gameManager = GetIt.I<GameManager>();

    // Spawn Party from GameManager
    // We listen to GameManager for changes? For prototype, just load once.
    // If we Recruit, we need to refresh.
    // Ideally BattleGame listens to GameManager.
    // letting GameManager notify BattleGame?
    // Or just check in update? No.
    // For now, assume Recruit only happens between sessions or trigger reload.
    // Wait, "Recruit" button is in UI. Battle is running.
    // I need BattleGame to update when party changes.
    // I'll make a method `refreshSquad`.
    _refreshSquad();

    gameManager.addListener(_refreshSquad);

    // 2. Start Spawning Monsters
    _spawnTimer = Timer(2.0, repeat: true, onTick: _spawnMonster);
    _spawnTimer!.start();
  }

  @override
  void onRemove() {
    GetIt.I<GameManager>().removeListener(_refreshSquad);
    super.onRemove();
  }

  void _refreshSquad() {
    final gameManager = GetIt.I<GameManager>();

    // Compare counts to avoid full rebuild if just stats changed
    // But if count changed, rebuild.
    if (heroes.length == gameManager.party.length) return;

    // Clear existing
    for (final h in heroes) {
      h.removeFromParent();
    }
    heroes.clear();

    for (int i = 0; i < gameManager.party.length; i++) {
      final heroData = gameManager.party[i];
      final xPos = size.x * (0.3 - (i * 0.1));
      final hero = HeroEntity(
        data: heroData,
        position: Vector2(xPos, size.y * 0.6),
      );
      heroes.add(hero);
      add(hero);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spawnTimer?.update(dt);

    final stageManager = GetIt.I<StageManager>();

    // 1. Hero Actions (Dmg/Heal)
    for (final hero in heroes) {
      if (hero.isDead) {
        hero.respawn(); // Mock fast respawn
        continue;
      }

      if (hero.data.role == HeroRole.healer) {
        // Heal lowest HP ally
        // Simple logic: Heal 1 HP per tick (approx 60/sec)
        // Find target
        HeroEntity? target;
        double minPct = 1.0;
        for (final ally in heroes) {
          if (!ally.isDead && ally.hpPercent < minPct) {
            minPct = ally.hpPercent;
            target = ally;
          }
        }
        if (target != null && minPct < 1.0) {
          target.heal(0.2); // Small continuous heal
        }
      } else {
        // Attacker
        // Find nearest monster
        // Optimization: Don't search every frame if costly, but for < 50 entities ok.
      }
    }

    // 2. Monster Actions & Collisions
    children.whereType<MonsterEntity>().forEach((monster) {
      // Find nearest Hero
      HeroEntity? target;
      double minDst = double.infinity;

      for (final h in heroes) {
        if (h.isDead) continue;
        final dst = monster.position.distanceTo(h.position);
        if (dst < minDst) {
          minDst = dst;
          target = h;
        }
      }

      if (target != null) {
        // Monster Attack
        if (minDst < 50) {
          target.takeDamage(0.5);
          // Thorns?
          monster.takeDamage(0.5);
        }

        // Hero Range Attacks (Magic/Arrow)
        for (final h in heroes) {
          if (h.isDead) continue;
          if (h.data.role != HeroRole.healer) {
            final range = h.data.role == HeroRole.archer ? 300 : 80;
            if (monster.position.distanceTo(h.position) < range) {
              monster.takeDamage(1.5);
            }
          }
        }
      }

      if (monster.isDead) {
        stageManager.onMonsterKilled(isBoss: monster.isBoss);
        GetIt.I<GameManager>().goldManager.addGold(monster.isBoss ? 50 : 10);
        monster.removeFromParent();
      }
    });
  }

  void _spawnMonster() {
    final stageManager = GetIt.I<StageManager>();

    // If Boss active, check if boss already exists
    if (stageManager.isBossActive) {
      final hasBoss = children.whereType<MonsterEntity>().any((m) => m.isBoss);
      if (!hasBoss) {
        add(
          MonsterEntity(
            position: Vector2(size.x + 50, size.y * 0.6),
            isBoss: true,
            hpMultiplier: stageManager.monsterHpScale * 5, // Boss is tanky
          ),
        );
      }
      // Stop spawning normal mobs if boss is active -> 1vSquad
    } else {
      // Spawn Normal
      add(
        MonsterEntity(
          position: Vector2(size.x + 50, size.y * 0.6),
          isBoss: false,
          hpMultiplier: stageManager.monsterHpScale,
        ),
      );
    }
  }
}
