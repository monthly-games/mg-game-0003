import 'package:mg_common_game/core/systems/rpg/stat_system/base_stat.dart';

enum HeroRole { tank, archer, healer }

class HeroData {
  final String id;
  final HeroRole role;
  String name;

  // Stats
  late final BaseStat hp;
  late final BaseStat atk;
  late final BaseStat def;

  int level = 1;

  HeroData({
    required this.id,
    required this.role,
    required this.name,
    double initialHp = 100,
    double initialAtk = 10,
    double initialDef = 0,
  }) {
    hp = BaseStat(initialHp);
    atk = BaseStat(initialAtk);
    def = BaseStat(initialDef);
  }

  void levelUp() {
    level++;
    // Simple linear growth
    hp.baseValue *= 1.1; // +10%
    atk.baseValue *= 1.1;
    def.baseValue += 1;
  }
}
