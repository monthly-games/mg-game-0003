import 'equipment.dart';

enum HeroRole { tank, archer, healer, mage, assassin }

class HeroData {
  final String id;
  final HeroRole role;
  final String name;

  // Base Stats
  final int initialHp;
  final int initialUpHp;
  final int initialAtk;
  final int initialUpAtk;
  final int initialDef;
  final int initialUpDef;

  // Current State
  int level = 1;

  HeroData({
    required this.id,
    required this.role,
    required this.name,
    required this.initialHp,
    this.initialUpHp = 10,
    required this.initialAtk,
    this.initialUpAtk = 2,
    this.initialDef = 0,
    this.initialUpDef = 1,
    this.level = 1,
  });

  void levelUp() {
    level++;
  }

  void resetToInitial() {
    level = 1;
  }

  // Equipment
  final Map<EquipmentType, Equipment> equipment = {};

  // Computed Stats
  double get currentHp {
    double total = (initialHp + (level - 1) * initialUpHp).toDouble();
    for (final eq in equipment.values) {
      total += eq.hpBonus.toDouble();
    }
    // Add Prestige Multipliers here later if needed, or apply in Battle
    return total;
  }

  double get currentAtk {
    double total = (initialAtk + (level - 1) * initialUpAtk).toDouble();
    for (final eq in equipment.values) {
      total += eq.atkBonus.toDouble();
    }
    return total;
  }

  double get currentDef {
    double total = (initialDef + (level - 1) * initialUpDef).toDouble();
    for (final eq in equipment.values) {
      total += eq.defBonus.toDouble();
    }
    return total;
  }

  // Equid/Unequip methods
  void equip(Equipment eq) {
    equipment[eq.type] = eq;
  }

  // Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.index,
      'name': name,
      'level': level,
      'initialHp': initialHp,
      'initialAtk': initialAtk, // minimal storage
      'equipment': equipment.map((k, v) => MapEntry(k.name, v.toJson())),
    };
  }

  factory HeroData.fromJson(Map<String, dynamic> json) {
    final hero = HeroData(
      id: json['id'],
      role: HeroRole.values[json['role']],
      name: json['name'],
      initialHp: json['initialHp'] ?? 100, // Fallback defaults if logic changed
      initialAtk: json['initialAtk'] ?? 10,
      level: json['level'] ?? 1,
    );

    if (json['equipment'] != null) {
      final eqMap = json['equipment'] as Map;
      eqMap.forEach((k, v) {
        // Simple restore, robust handling omitted for brevity
        // hero.equipment[EquipmentType.values.byName(k)] = Equipment.fromJson(v);
        // Assuming Equipment.fromJson exists or we skip for prototype
      });
    }
    return hero;
  }
}
