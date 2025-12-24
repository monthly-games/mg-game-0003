import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/systems/save_manager.dart';
import 'game_manager.dart';
import 'stage_manager.dart';

class PrestigeManager extends ChangeNotifier implements Saveable {
  // Currency
  int relics = 0;

  // Multipliers (Persistent Upgrades)
  double goldMultiplier = 1.0;
  double damageMultiplier = 1.0;

  // Upgrade Levels
  int goldUpgradeLevel = 0;
  int damageUpgradeLevel = 0;

  // Constants
  static const int minStageForPrestige = 20;

  int calculateRelicsToGain(int currentStage) {
    if (currentStage < minStageForPrestige) return 0;
    // Formula: floor((Stage - 20) * 0.5)
    // Stage 21 -> 0
    // Stage 22 -> 1
    // Stage 40 -> 10
    return ((currentStage - minStageForPrestige) * 0.5).floor();
  }

  void prestige() {
    final stageManager = GetIt.I<StageManager>();
    final gainedRelics = calculateRelicsToGain(stageManager.currentStage);

    if (gainedRelics <= 0) return;

    relics += gainedRelics;

    // Perform Soft Reset
    final gameManager = GetIt.I<GameManager>();
    gameManager.softReset(); // Resets Gold, Heroes
    stageManager.softReset(); // Resets Stage

    notifyListeners();
  }

  // Upgrades
  int get goldUpgradeCost => 10 + (goldUpgradeLevel * 5);
  int get damageUpgradeCost => 15 + (damageUpgradeLevel * 10);

  void buyGoldUpgrade() {
    if (relics >= goldUpgradeCost) {
      relics -= goldUpgradeCost;
      goldUpgradeLevel++;
      goldMultiplier += 0.1; // +10%
      notifyListeners();
    }
  }

  void buyDamageUpgrade() {
    if (relics >= damageUpgradeCost) {
      relics -= damageUpgradeCost;
      damageUpgradeLevel++;
      damageMultiplier += 0.1; // +10%
      notifyListeners();
    }
  }

  // Persistence
  @override
  String get saveKey => 'prestige_manager';

  @override
  Map<String, dynamic> toSaveData() {
    return {
      'relics': relics,
      'goldUpgradeLevel': goldUpgradeLevel,
      'damageUpgradeLevel': damageUpgradeLevel,
      'goldMultiplier': goldMultiplier,
      'damageMultiplier': damageMultiplier,
    };
  }

  @override
  void fromSaveData(Map<String, dynamic> data) {
    relics = data['relics'] ?? 0;
    goldUpgradeLevel = data['goldUpgradeLevel'] ?? 0;
    damageUpgradeLevel = data['damageUpgradeLevel'] ?? 0;
    goldMultiplier = data['goldMultiplier'] ?? 1.0;
    damageMultiplier = data['damageMultiplier'] ?? 1.0;
    notifyListeners();
  }
}
