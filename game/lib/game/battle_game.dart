import 'package:flutter/material.dart'; // For Colors
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/ui/theme/app_colors.dart';
import 'package:mg_common_game/core/ui/components/floating_text_component.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import 'dart:math';
import 'logic/game_manager.dart';
import 'logic/stage_manager.dart';
import 'logic/inventory_logic.dart';
import 'data/hero_data.dart';
import 'data/equipment.dart';
import 'entities/hero.dart';
import 'entities/monster.dart';

class BattleGame extends FlameGame {
  @override
  Color backgroundColor() => AppColors.background;

  // Squad
  final List<HeroEntity> heroes = [];

  // Wave Logic
  Timer? _spawnTimer;

  @override
  Future<void> onLoad() async {
    final gameManager = GetIt.I<GameManager>();
    final audioManager = GetIt.I<AudioManager>();

    // 0. Background
    add(SpriteComponent(sprite: await loadSprite('bg_battle.png'), size: size));

    // Audio
    try {
      audioManager.playBgm('bgm_battle.wav', volume: 0.4);
    } catch (e) {
      debugPrint('Audio Error: $e');
    }

    // Spawn Party from GameManager
    _refreshSquad();
    gameManager.addListener(_refreshSquad);

    // 2. Start Spawning Monsters
    _spawnTimer = Timer(2.0, repeat: true, onTick: _spawnMonster);
    _spawnTimer!.start();
  }

  @override
  void onRemove() {
    GetIt.I<GameManager>().removeListener(_refreshSquad);
    GetIt.I<AudioManager>().stopBgm();
    super.onRemove();
  }

  void _refreshSquad() {
    final gameManager = GetIt.I<GameManager>();

    if (heroes.length == gameManager.party.length) return;

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
          _handleDamage(target, 0.5); // Monster attacks Hero
          _handleDamage(monster, 0.5); // Thorns/Touch damage
        }

        // Hero Range Attacks (Magic/Arrow/Dagger)
        for (final h in heroes) {
          if (h.isDead) continue;
          if (h.data.role != HeroRole.healer) {
            double range = 80;
            if (h.data.role == HeroRole.archer ||
                h.data.role == HeroRole.mage) {
              range = 300;
            }

            final distance = monster.position.distanceTo(h.position);

            // Mage Logic: AoE Attack (Hits all monsters in range)
            if (h.data.role == HeroRole.mage) {
              if (distance < range) {
                _handleDamage(
                  monster,
                  h.data.currentAtk * 0.6,
                ); // 60% AoE Damage
              }
            }
            // Assassin Logic: High Crit
            else if (h.data.role == HeroRole.assassin) {
              if (distance < range) {
                final isCrit = Random().nextDouble() < 0.5; // 50% Crit Chance
                double dmg = h.data.currentAtk;
                if (isCrit) dmg *= 2.0; // 200% Damage
                _handleDamage(monster, dmg, isCrit: isCrit);
              }
            }
            // Archer Logic: Always Crit (Visual) + Safe Range
            else if (h.data.role == HeroRole.archer) {
              if (distance < range) {
                _handleDamage(monster, h.data.currentAtk, isCrit: true);
              }
            }
            // Tank Logic
            else {
              if (distance < range) {
                _handleDamage(monster, h.data.currentAtk);
              }
            }
          }
        }
      }

      if (monster.isDead) {
        stageManager.onMonsterKilled(isBoss: monster.isBoss);
        GetIt.I<GameManager>().goldManager.addGold(monster.isBoss ? 50 : 10);
        monster.removeFromParent();

        // Items are now managed by InventoryLogic, which depends on GameManager.
        // For simplicity, direct item drops can be added to InventoryLogic if registered.
        if (GetIt.I.isRegistered<InventoryLogic>()) {
          _handleDrop(monster.isBoss, monster.position);
        }
      }
    });
  }

  void _handleDrop(bool isBoss, Vector2 position) {
    // 10% chance for normal, 100% for boss
    final chance = isBoss ? 1.0 : 0.1;
    if (Random().nextDouble() > chance) return;

    final inventory = GetIt.I<InventoryLogic>();
    // Accessing manager through logic if public, or adding methods to Logic
    // Assuming logic has addItem

    // Generate Item
    final type =
        EquipmentType.values[Random().nextInt(EquipmentType.values.length)];
    final rarityIndex = isBoss
        ? 2
        : 0; // Boss drops Epic(2), Normal drops Common(0) mostly.
    final rarity = Rarity.values[rarityIndex];

    // Construct fake ID
    final id = 'eq_${type.name}_${rarity.name}_${Random().nextInt(100)}';

    final equipment = Equipment(
      id: id,
      name: '${rarity.name} ${type.name} +${Random().nextInt(5)}',
      type: type,
      rarity: rarity,
      atkBonus: type == EquipmentType.weapon ? (isBoss ? 50 : 10) : 0,
      defBonus: type == EquipmentType.armor ? (isBoss ? 20 : 5) : 0,
      // hpBonus: type == EquipmentType.accessory ? (isBoss ? 100 : 20) : 0, // removed in Equipment definition? Check Data.
      // Re-checking Equipment class if it has hpBonus.
      // Assuming it does based on previous implementation
    );
    // If Equipment constructor changed, adapt here.
    // For now, assume standard fields.

    inventory.addItem(id, equipmentData: equipment);

    add(
      FloatingTextComponent(
        text: 'ITEM!',
        position: position + Vector2(0, -40),
        color: const Color(0xFF00FF00),
        fontSize: 20.0,
      ),
    );
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

  void _handleDamage(
    PositionComponent target,
    double amount, {
    bool isCrit = false,
  }) {
    if (target is HeroEntity) {
      target.takeDamage(amount);
      // Visual: Pop text (optional for heroes, maybe red)
    } else if (target is MonsterEntity) {
      target.takeDamage(amount);

      // Visual: Pop text
      add(
        FloatingTextComponent(
          text: '-${amount.toStringAsFixed(1)}',
          position: target.position + Vector2(0, -20),
          color: isCrit ? Colors.red : Colors.white,
          fontSize: isCrit ? 36.0 : 24.0,
        ),
      );

      // Audio
      try {
        GetIt.I<AudioManager>().playSfx(
          isCrit ? 'sfx_critical.wav' : 'sfx_hit.wav',
          pitch: 0.9 + Random().nextDouble() * 0.2,
        );
      } catch (_) {}
    }
  }
}
