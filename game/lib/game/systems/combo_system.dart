/// Chain Combo System for MG-0003 Pixel Mercenary RPG
/// Detects consecutive hero attacks and applies damage multipliers
class ComboSystem {
  // Combo state
  int _currentCombo = 0;
  String? _lastAttackerId;
  DateTime? _lastAttackTime;

  // Combo configuration
  static const Duration comboTimeout = Duration(milliseconds: 1500);
  static const double maxComboMultiplier = 3.0;
  static const int maxComboCount = 10;

  // Combo chain tracking
  final List<String> _attackChain = [];

  /// Get current combo count
  int get currentCombo => _currentCombo;

  /// Get current combo multiplier (1.0 = no combo)
  double get comboMultiplier {
    if (_currentCombo == 0) return 1.0;
    final multiplier = 1.0 + (_currentCombo * 0.1); // +10% per combo hit
    return multiplier.clamp(1.0, maxComboMultiplier);
  }

  /// Record a hero attack and update combo state
  /// Returns the combo multiplier to apply to this attack
  double recordAttack(String heroId, DateTime attackTime) {
    // Check if combo should reset (timeout or different attacker)
    if (_lastAttackTime != null) {
      final timeSinceLastAttack = attackTime.difference(_lastAttackTime!);
      if (timeSinceLastAttack > comboTimeout) {
        _resetCombo();
      }
    }

    // Check for chain bonus (different hero attacks in sequence)
    if (_lastAttackerId != null && _lastAttackerId != heroId) {
      // Different hero = chain attack
      _currentCombo++;
      _attackChain.add(heroId);
    } else if (_lastAttackerId == heroId) {
      // Same hero = continue combo but slower buildup
      _currentCombo = _currentCombo + 1;
      _attackChain.add(heroId);
    } else {
      // First attack
      _currentCombo = 1;
      _attackChain.add(heroId);
    }

    // Clamp combo to maximum
    _currentCombo = _currentCombo.clamp(0, maxComboCount);

    // Update state
    _lastAttackerId = heroId;
    _lastAttackTime = attackTime;

    return comboMultiplier;
  }

  /// Check if current hit is a chain attack (different hero than last)
  bool isChainAttack(String heroId) {
    return _lastAttackerId != null && _lastAttackerId != heroId;
  }

  /// Get the attack chain (list of hero IDs in order)
  List<String> get attackChain => List.unmodifiable(_attackChain);

  /// Get the length of unique heroes in the current chain
  int get uniqueHeroCount => _attackChain.toSet().length;

  /// Reset combo state
  void _resetCombo() {
    _currentCombo = 0;
    _lastAttackerId = null;
    _lastAttackTime = null;
    _attackChain.clear();
  }

  /// Manually reset combo (e.g., when hero dies or combat ends)
  void resetCombo() {
    _resetCombo();
  }

  /// Get combo tier for UI display
  ComboTier get comboTier {
    if (_currentCombo >= 8) return ComboTier.legendary;
    if (_currentCombo >= 6) return ComboTier.epic;
    if (_currentCombo >= 4) return ComboTier.rare;
    if (_currentCombo >= 2) return ComboTier.common;
    return ComboTier.none;
  }

  /// Get combo tier display name
  String get comboTierDisplayName {
    switch (comboTier) {
      case ComboTier.legendary:
        return '전설';
      case ComboTier.epic:
        return '에픽';
      case ComboTier.rare:
        return '레어';
      case ComboTier.common:
        return '일반';
      case ComboTier.none:
        return '';
    }
  }
}

/// Combo tiers for UI display and scaling
enum ComboTier {
  none,
  common,
  rare,
  epic,
  legendary;
}