import 'package:mg_common_game/systems/inventory/inventory_item.dart';
import 'dart:math';

enum EquipmentType { weapon, armor, accessory }

enum Rarity { common, rare, epic, legendary }

class Equipment {
  final String id;
  final String name;
  final EquipmentType type;
  final Rarity rarity;

  // Stats
  // Stats (Base values at level 1)
  final double atkBonus;
  final double defBonus;
  final double hpBonus;

  final int level;

  const Equipment({
    required this.id,
    required this.name,
    required this.type,
    required this.rarity,
    this.atkBonus = 0,
    this.defBonus = 0,
    this.hpBonus = 0,
    this.level = 1,
  });

  // Level Logic
  double get _levelMultiplier => 1.0 + 0.1 * (level - 1);
  double get currentAtk => atkBonus * _levelMultiplier;
  double get currentDef => defBonus * _levelMultiplier;
  double get currentHp => hpBonus * _levelMultiplier;

  int get upgradeCost {
    int baseCost = 100;
    switch (rarity) {
      case Rarity.common:
        baseCost = 100;
        break;
      case Rarity.rare:
        baseCost = 500;
        break;
      case Rarity.epic:
        baseCost = 2000;
        break;
      case Rarity.legendary:
        baseCost = 10000;
        break;
    }
    return (baseCost * pow(1.5, level - 1)).floor();
  }

  static Equipment fromId(String id) {
    // Placeholder for static generation
    return const Equipment(
      id: 'unknown',
      name: 'Unknown Item',
      type: EquipmentType.weapon,
      rarity: Rarity.common,
    );
  }

  InventoryItem toInventoryItem() {
    return InventoryItem(
      id: id,
      amount: 1,
      metadata: {
        'type': type
            .index, // Using index to match existing pattern, or switch to name?
        // Existing used index. Let's stick to index or migrate.
        // Migrating to name is safer.
        'type_name': type.name, // redundant but safe
        'rarity': rarity.index,
        'rarity_name': rarity.name,
        'atk': atkBonus,
        'def': defBonus,
        'hp': hpBonus,
        'name': name,
        'level': level,
      },
    );
  }

  factory Equipment.fromInventoryItem(InventoryItem item) {
    final meta = item.metadata ?? {};

    // Handle both index (legacy) and name
    EquipmentType eType = EquipmentType.weapon;
    if (meta['type_name'] != null) {
      eType = EquipmentType.values.firstWhere(
        (e) => e.name == meta['type_name'],
        orElse: () => EquipmentType.weapon,
      );
    } else if (meta['type'] is int) {
      eType =
          EquipmentType.values[(meta['type'] as int).clamp(
            0,
            EquipmentType.values.length - 1,
          )];
    }

    Rarity eRarity = Rarity.common;
    if (meta['rarity_name'] != null) {
      eRarity = Rarity.values.firstWhere(
        (e) => e.name == meta['rarity_name'],
        orElse: () => Rarity.common,
      );
    } else if (meta['rarity'] is int) {
      eRarity = Rarity
          .values[(meta['rarity'] as int).clamp(0, Rarity.values.length - 1)];
    }

    return Equipment(
      id: item.id,
      name: meta['name'] ?? 'Unknown',
      type: eType,
      rarity: eRarity,
      atkBonus: (meta['atk'] ?? 0).toDouble(),
      defBonus: (meta['def'] ?? 0).toDouble(),
      hpBonus: (meta['hp'] ?? 0).toDouble(),
      level: (meta['level'] ?? 1) as int,
    );
  }
}
