import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/systems/progression/upgrade_manager.dart';
import 'systems/element_system.dart';
import 'systems/combo_system.dart';

// ============================================================
// CombatManager -- MG-0003 Mercenary Brigade
//
// Manages combat stat bonuses derived from UpgradeManager levels.
// Upgrades: attack_damage, crit_chance, skill_cooldown, combo_multiplier
// Now includes: Element system advantages and Chain combo detection
// ============================================================

class CombatManager extends ChangeNotifier {
  // ── Base combat constants ────────────────────────────────────
  static const double baseAttackDamage = 10.0;
  static const double baseCritChance = 0.05;
  static const double baseSkillCooldown = 10.0; // seconds
  static const double baseComboMultiplier = 1.0;
  static const double critDamageMultiplier = 2.0;
  static const double comboScaling = 0.1; // per combo hit

  // ── System instances ─────────────────────────────────────────
  final ComboSystem _comboSystem = ComboSystem();

  // ── Upgrade-derived getters ──────────────────────────────────

  /// Total attack damage multiplier (1.0 = base, 1.1 = +10%).
  double get attackDamageMultiplier {
    final upgrade = GetIt.I<UpgradeManager>().getUpgrade('attack_damage');
    return 1.0 + (upgrade?.currentValue ?? 0.0);
  }

  /// Current critical hit probability.
  double get critChance {
    final upgrade = GetIt.I<UpgradeManager>().getUpgrade('crit_chance');
    return baseCritChance + (upgrade?.currentValue ?? 0.0);
  }

  /// Fractional cooldown reduction (0.0 = none, 0.4 = 40% faster).
  double get skillCooldownReduction {
    final upgrade = GetIt.I<UpgradeManager>().getUpgrade('skill_cooldown');
    return upgrade?.currentValue ?? 0.0;
  }

  /// Effective cooldown in seconds after reduction.
  double get effectiveSkillCooldown {
    final reduced = baseSkillCooldown * (1.0 - skillCooldownReduction);
    return reduced.clamp(1.0, baseSkillCooldown);
  }

  /// Combo damage multiplier from upgrades.
  double get comboMultiplier {
    final upgrade = GetIt.I<UpgradeManager>().getUpgrade('combo_multiplier');
    return baseComboMultiplier + (upgrade?.currentValue ?? 0.0);
  }

  /// Get current combo system instance
  ComboSystem get comboSystem => _comboSystem;

  // ── Combat calculations ──────────────────────────────────────

  /// Calculate total damage output for a single hit with element and combo support.
  ///
  /// [baseHeroDamage] -- raw ATK stat from the hero.
  /// [attackerElement] -- element type of the attacking hero.
  /// [targetElement] -- element type of the target monster.
  /// [heroId] -- unique ID of the attacking hero (for combo tracking).
  /// [isCrit] -- whether this hit is a critical strike.
  double calculateDamage(
    double baseHeroDamage,
    ElementType attackerElement,
    ElementType targetElement,
    String heroId, {
    bool isCrit = false,
  }) {
    double damage = baseHeroDamage * attackDamageMultiplier;

    // Apply elemental advantage/disadvantage
    final elementMultiplier = attackerElement.getAdvantageMultiplier(targetElement);
    damage *= elementMultiplier;

    // Apply critical hit multiplier
    if (isCrit) {
      damage *= critDamageMultiplier;
    }

    // Apply combo system
    final comboMultiplier = _comboSystem.recordAttack(heroId, DateTime.now());
    damage *= comboMultiplier;

    return damage;
  }

  /// Legacy damage calculation method (for backward compatibility).
  ///
  /// [baseHeroDamage] -- raw ATK stat from the hero.
  /// [isCrit] -- whether this hit is a critical strike.
  /// [comboCount] -- current combo chain length (0 = no combo).
  @deprecated
  double calculateLegacyDamage(
    double baseHeroDamage, {
    bool isCrit = false,
    int comboCount = 0,
  }) {
    double damage = baseHeroDamage * attackDamageMultiplier;

    if (isCrit) {
      damage *= critDamageMultiplier;
    }

    if (comboCount > 0) {
      damage *= comboMultiplier * (1.0 + comboCount * comboScaling);
    }

    return damage;
  }

  /// Notify listeners that upgrade values may have changed.
  void refreshFromUpgrades() {
    notifyListeners();
  }

  /// Reset combo system (call when combat ends or heroes die).
  void resetCombo() {
    _comboSystem.resetCombo();
  }

  /// Get current combo count for UI display.
  int get currentComboCount => _comboSystem.currentCombo;

  /// Get current combo tier for UI display.
  ComboTier get currentComboTier => _comboSystem.comboTier;
}
