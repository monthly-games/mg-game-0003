import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/systems/progression/upgrade_manager.dart';

// ============================================================
// SquadManager — MG-0003 Mercenary Brigade
//
// Controls squad composition limits and formation bonuses.
// Upgrades: squad_size, formation_bonus
// ============================================================

class SquadManager extends ChangeNotifier {
  // ── Base squad constants ─────────────────────────────────────
  static const int baseSquadSize = 2;
  static const double baseFormationBonus = 0.0;
  static const double defenseFormationScale = 0.5;

  // ── Upgrade-derived getters ──────────────────────────────────

  /// Maximum party members allowed.
  /// Base 2 + 1 per squad_size upgrade level.
  int get maxSquadSize {
    final upgrade = GetIt.I<UpgradeManager>().getUpgrade('squad_size');
    final bonus = upgrade?.currentValue ?? 0.0;
    return baseSquadSize + bonus.round();
  }

  /// Raw formation bonus from upgrades (0.0 = none).
  double get formationBonus {
    final upgrade = GetIt.I<UpgradeManager>().getUpgrade('formation_bonus');
    return baseFormationBonus + (upgrade?.currentValue ?? 0.0);
  }

  // ── Computed multipliers ─────────────────────────────────────

  /// Damage multiplier from squad formation (1.0 = base).
  double get formationDamageMultiplier => 1.0 + formationBonus;

  /// Defense multiplier from squad formation (scales at half rate).
  double get formationDefenseMultiplier {
    return 1.0 + formationBonus * defenseFormationScale;
  }

  // ── Squad query helpers ──────────────────────────────────────

  /// Whether the squad has room for another recruit.
  bool canRecruit(int currentPartySize) => currentPartySize < maxSquadSize;

  /// Remaining open slots.
  int openSlots(int currentPartySize) {
    return (maxSquadSize - currentPartySize).clamp(0, maxSquadSize);
  }

  /// Notify listeners that upgrade values may have changed.
  void refreshFromUpgrades() {
    notifyListeners();
  }
}
