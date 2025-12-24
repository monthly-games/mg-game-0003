import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import 'package:mg_common_game/core/systems/save_manager.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import 'stage_manager.dart';
import '../data/hero_data.dart';

class GameManager extends ChangeNotifier implements Saveable {
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
      try {
        GetIt.I<AudioManager>().playSfx('ui_level_up.wav');
      } catch (_) {}
    }
  }

  void recruitHealer() {
    const cost = 1000;
    if (party.any((h) => h.role == HeroRole.healer)) return;

    if (goldManager.trySpendGold(cost)) {
      party.add(
        HeroData(
          id: 'h${party.length + 1}',
          role: HeroRole.healer,
          name: 'Cleric',
          initialHp: 60,
          initialAtk: 2,
        ),
      );
      notifyListeners();
      try {
        GetIt.I<AudioManager>().playSfx('ui_click.wav');
      } catch (_) {}
    }
  }

  void recruitMage() {
    const cost = 3000;
    if (party.any((h) => h.role == HeroRole.mage)) return;

    if (goldManager.trySpendGold(cost)) {
      party.add(
        HeroData(
          id: 'h${party.length + 1}',
          role: HeroRole.mage,
          name: 'Wizard',
          initialHp: 80,
          initialAtk: 30, // High AoE
          initialDef: 2,
        ),
      );
      notifyListeners();
      try {
        GetIt.I<AudioManager>().playSfx('ui_click.wav');
      } catch (_) {}
    }
  }

  void recruitAssassin() {
    const cost = 2000;
    if (party.any((h) => h.role == HeroRole.assassin)) return;

    if (goldManager.trySpendGold(cost)) {
      party.add(
        HeroData(
          id: 'h${party.length + 1}',
          role: HeroRole.assassin,
          name: 'Rogue',
          initialHp: 90,
          initialAtk: 35, // High Crit
          initialDef: 3,
        ),
      );
      notifyListeners();
      try {
        GetIt.I<AudioManager>().playSfx('ui_click.wav');
      } catch (_) {}
    }
  }

  // Persistence
  @override
  String get saveKey => 'game_manager';

  @override
  Map<String, dynamic> toSaveData() {
    return {'party': party.map((h) => h.toJson()).toList()};
  }

  @override
  void fromSaveData(Map<String, dynamic> data) {
    if (data['party'] != null) {
      party.clear();
      final list = data['party'] as List;
      for (final item in list) {
        party.add(HeroData.fromJson(item));
      }
      notifyListeners();
    }
  }

  int offlineGoldEarned = 0;

  void checkOfflineRewards(DateTime? lastSaveTime) {
    if (lastSaveTime == null) return;

    final diff = DateTime.now().difference(lastSaveTime);
    final minutes = diff.inMinutes;

    if (minutes >= 1) {
      // Min 1 minute
      final stageManager = GetIt.I<StageManager>();
      // Formula: Stage * 100 per hour (approx Stage * 1.6 per minute)
      // Let's use: (Stage * 100 * minutes) / 60
      final earned = (stageManager.currentStage * 100 * (minutes / 60)).floor();

      if (earned > 0) {
        offlineGoldEarned = earned;
        // Do NOT add gold instantly. Wait for user to claim in UI.
        // goldManager.addGold(earned);
        debugPrint('Offline: ${minutes}m passed. Earned $earned gold.');
        notifyListeners();
      }
    }
  }

  void consumeOfflineRewards() {
    if (offlineGoldEarned > 0) {
      goldManager.addGold(offlineGoldEarned);
      offlineGoldEarned = 0;
      notifyListeners();
    }
  }

  void softReset() {
    goldManager.setGold(0); // Reset Gold

    // Reset Heroes to Level 1, Base Stats
    for (final hero in party) {
      hero.level = 1;
      // We might want to keep some persistent "Stars" or "Evolution" later
      // For now, reset to initial
      hero.resetToInitial();
    }
    notifyListeners();
  }
}
