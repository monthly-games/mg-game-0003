import 'package:flutter/foundation.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import '../data/hero_data.dart';

class GameManager extends ChangeNotifier {
  final GoldManager goldManager;
  final List<HeroData> party = [];

  GameManager(this.goldManager) {
    // Initial Party
    party.add(
      HeroData(
        id: 'h1',
        role: HeroRole.tank,
        name: 'Knight',
        initialHp: 200,
        initialAtk: 5,
      ),
    );
    party.add(
      HeroData(
        id: 'h2',
        role: HeroRole.archer,
        name: 'Ranger',
        initialHp: 80,
        initialAtk: 15,
      ),
    );

    // Initial Gold
    goldManager.addGold(100);
  }

  void upgradeHero(HeroData hero) {
    const cost = 50;
    if (goldManager.trySpendGold(cost)) {
      hero.levelUp();
      notifyListeners();
    }
  }

  void recruitHealer() {
    const cost = 1000;
    // Check if we already have a healer? For prototype, limit to 1.
    if (party.any((h) => h.role == HeroRole.healer)) return;

    if (goldManager.trySpendGold(cost)) {
      party.add(
        HeroData(
          id: 'h${party.length + 1}',
          role: HeroRole.healer,
          name: 'Cleric',
          initialHp: 60,
          initialAtk: 2, // Low dmg
        ),
      );
      notifyListeners();
    }
  }
}
