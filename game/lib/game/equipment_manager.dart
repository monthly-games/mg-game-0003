import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/systems/progression/upgrade_manager.dart';

// ============================================================
// EquipmentManager — MG-0003 Mercenary Brigade
//
// Manages gear slot capacity and equipment stat bonuses.
// Upgrades: gear_slots, stat_multiplier
// ============================================================

class EquipmentManager extends ChangeNotifier {
  // ── Base equipment constants ──────────────────────────────────
  static const int baseGearSlots = 2;
  static const double baseStatMultiplier = 1.0;

  // ── Upgrade-derived getters ──────────────────────────────────

  /// Maximum gear slots each hero can equip.
  /// Base 2 + 1 per gear_slots upgrade level.
  int get maxGearSlots {
    final upgrade = GetIt.I<UpgradeManager>().getUpgrade('gear_slots');
    final bonus = upgrade?.currentValue ?? 0.0;
    return baseGearSlots + bonus.round();
  }

  /// Global stat multiplier applied to all equipped gear bonuses.
  double get statMultiplier {
    final upgrade = GetIt.I<UpgradeManager>().getUpgrade('stat_multiplier');
    return baseStatMultiplier + (upgrade?.currentValue ?? 0.0);
  }

  // ── Equipment helpers ────────────────────────────────────────

  /// Apply the stat multiplier to a base stat value from gear.
  double applyStatBonus(double baseStat) => baseStat * statMultiplier;

  /// Whether a hero can equip additional gear.
  bool canEquipMore(int currentEquipped) => currentEquipped < maxGearSlots;

  /// Remaining equippable slots for a hero.
  int availableSlots(int currentEquipped) {
    return (maxGearSlots - currentEquipped).clamp(0, maxGearSlots);
  }

  /// Calculate total gear bonus for a stat across all equipped items.
  ///
  /// [rawBonuses] — list of raw stat values from equipped gear pieces.
  double totalGearBonus(List<double> rawBonuses) {
    if (rawBonuses.isEmpty) return 0.0;
    final sum = rawBonuses.fold(0.0, (acc, v) => acc + v);
    return applyStatBonus(sum);
  }

  /// Notify listeners that upgrade values may have changed.
  void refreshFromUpgrades() {
    notifyListeners();
  }
}
