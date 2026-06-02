import 'equipment.dart';
import '../systems/element_system.dart';

enum HeroRole { tank, archer, healer, mage, assassin }

class HeroData {
  final String id;
  final HeroRole role;
  final String name;
  final ElementType element;

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
    required this.element,
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

// Extended Hero Roster - 15 Heroes total
final List<HeroData> allHeroes = [
  // Tank Heroes (3)
  HeroData(
    id: 'knight',
    role: HeroRole.tank,
    name: '기사 레온',
    element: ElementType.fire,
    initialHp: 150,
    initialUpHp: 15,
    initialAtk: 8,
    initialUpAtk: 1,
    initialDef: 10,
    initialUpDef: 2,
  ),
  HeroData(
    id: 'paladin',
    role: HeroRole.tank,
    name: '성기사 아서',
    element: ElementType.water,
    initialHp: 140,
    initialUpHp: 14,
    initialAtk: 10,
    initialUpAtk: 2,
    initialDef: 12,
    initialUpDef: 2,
  ),
  HeroData(
    id: 'guardian',
    role: HeroRole.tank,
    name: '수호자 가브리엘',
    element: ElementType.grass,
    initialHp: 160,
    initialUpHp: 16,
    initialAtk: 6,
    initialUpAtk: 1,
    initialDef: 15,
    initialUpDef: 3,
  ),

  // Archer Heroes (3)
  HeroData(
    id: 'ranger',
    role: HeroRole.archer,
    name: '궁수 린',
    element: ElementType.grass,
    initialHp: 80,
    initialUpHp: 8,
    initialAtk: 15,
    initialUpAtk: 3,
    initialDef: 3,
    initialUpDef: 1,
  ),
  HeroData(
    id: 'sniper',
    role: HeroRole.archer,
    name: '저격수 카일',
    element: ElementType.fire,
    initialHp: 70,
    initialUpHp: 7,
    initialAtk: 20,
    initialUpAtk: 4,
    initialDef: 2,
    initialUpDef: 0,
  ),
  HeroData(
    id: 'hunter',
    role: HeroRole.archer,
    name: '사냥꾼 실바',
    element: ElementType.water,
    initialHp: 85,
    initialUpHp: 9,
    initialAtk: 14,
    initialUpAtk: 3,
    initialDef: 4,
    initialUpDef: 1,
  ),

  // Healer Heroes (3)
  HeroData(
    id: 'cleric',
    role: HeroRole.healer,
    name: '성직자 엘라',
    element: ElementType.water,
    initialHp: 90,
    initialUpHp: 9,
    initialAtk: 5,
    initialUpAtk: 1,
    initialDef: 5,
    initialUpDef: 1,
  ),
  HeroData(
    id: 'priest',
    role: HeroRole.healer,
    name: '사제 마르코',
    element: ElementType.grass,
    initialHp: 95,
    initialUpHp: 10,
    initialAtk: 6,
    initialUpAtk: 1,
    initialDef: 6,
    initialUpDef: 1,
  ),
  HeroData(
    id: 'druid',
    role: HeroRole.healer,
    name: '드루 이스 아이다',
    element: ElementType.grass,
    initialHp: 88,
    initialUpHp: 8,
    initialAtk: 7,
    initialUpAtk: 2,
    initialDef: 4,
    initialUpDef: 1,
  ),

  // Mage Heroes (3)
  HeroData(
    id: 'wizard',
    role: HeroRole.mage,
    name: '마법사 메이블',
    element: ElementType.fire,
    initialHp: 70,
    initialUpHp: 7,
    initialAtk: 18,
    initialUpAtk: 4,
    initialDef: 4,
    initialUpDef: 1,
  ),
  HeroData(
    id: 'sorcerer',
    role: HeroRole.mage,
    name: '주술사 자라',
    element: ElementType.water,
    initialHp: 75,
    initialUpHp: 8,
    initialAtk: 16,
    initialUpAtk: 3,
    initialDef: 5,
    initialUpDef: 1,
  ),
  HeroData(
    id: 'necromancer',
    role: HeroRole.mage,
    name: '강령술모르가나',
    element: ElementType.grass,
    initialHp: 65,
    initialUpHp: 6,
    initialAtk: 22,
    initialUpAtk: 5,
    initialDef: 3,
    initialUpDef: 0,
  ),

  // Assassin Heroes (3)
  HeroData(
    id: 'rogue',
    role: HeroRole.assassin,
    name: '도적 레이',
    element: ElementType.fire,
    initialHp: 75,
    initialUpHp: 8,
    initialAtk: 16,
    initialUpAtk: 4,
    initialDef: 4,
    initialUpDef: 1,
  ),
  HeroData(
    id: 'ninja',
    role: HeroRole.assassin,
    name: '닌자 켄지',
    element: ElementType.water,
    initialHp: 70,
    initialUpHp: 7,
    initialAtk: 19,
    initialUpAtk: 5,
    initialDef: 3,
    initialUpDef: 0,
  ),
  HeroData(
    id: 'vampire',
    role: HeroRole.assassin,
    name: '뱀파이어 드라쿨라',
    element: ElementType.grass,
    initialHp: 80,
    initialUpHp: 8,
    initialAtk: 17,
    initialUpAtk: 4,
    initialDef: 5,
    initialUpDef: 1,
  ),
];
