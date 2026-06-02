import 'equipment.dart';

class EquipmentEnhancementManager {
  static final EquipmentEnhancementManager _instance =
      EquipmentEnhancementManager._internal();
  factory EquipmentEnhancementManager() => _instance;
  EquipmentEnhancementManager._internal();

  // Enhancement success rates by rarity
  final Map<Rarity, double> _successRates = {
    Rarity.common: 0.95,    // 95% success rate
    Rarity.rare: 0.85,      // 85% success rate
    Rarity.epic: 0.70,      // 70% success rate
    Rarity.legendary: 0.50, // 50% success rate
  };

  // Enhancement costs
  int getEnhancementCost(Equipment equipment) {
    final baseCost = _getBaseCost(equipment.rarity);
    final levelMultiplier = _getLevelMultiplier(equipment.level);
    return (baseCost * levelMultiplier).round();
  }

  int _getBaseCost(Rarity rarity) {
    switch (rarity) {
      case Rarity.common:
        return 100;
      case Rarity.rare:
        return 500;
      case Rarity.epic:
        return 2000;
      case Rarity.legendary:
        return 10000;
    }
  }

  double _getLevelMultiplier(int level) {
    // Exponential cost scaling
    return pow(1.5, level - 1).toDouble();
  }

  // Enhancement attempt
  EnhancementResult enhanceEquipment(Equipment equipment) {
    final cost = getEnhancementCost(equipment);
    final successRate = _successRates[equipment.rarity] ?? 0.5;

    // Random success/fail
    final random = _random.nextDouble();
    final success = random < successRate;

    if (success) {
      return EnhancementResult(
        success: true,
        newLevel: equipment.level + 1,
        cost: cost,
        message: '강화 성공! Lv.${equipment.level} → Lv.${equipment.level + 1}',
      );
    } else {
      return EnhancementResult(
        success: false,
        newLevel: equipment.level,
        cost: cost,
        message: '강화 실패. 레벨 유지.',
      );
    }
  }

  // Safe enhancement (with protection item)
  EnhancementResult enhanceSafe(Equipment equipment) {
    final cost = getEnhancementCost(equipment) * 2; // Double cost for safety
    final successRate = _successRates[equipment.rarity] ?? 0.5;

    final random = _random.nextDouble();
    final success = random < successRate;

    if (success) {
      return EnhancementResult(
        success: true,
        newLevel: equipment.level + 1,
        cost: cost.toInt(),
        message: '강화 성공! Lv.${equipment.level} → Lv.${equipment.level + 1}',
      );
    } else {
      return EnhancementResult(
        success: false,
        newLevel: equipment.level,
        cost: cost.toInt(),
        message: '강화 실패 (안전 모드). 레벨 유지.',
      );
    }
  }

  // Get max enhancement level for rarity
  int getMaxLevel(Rarity rarity) {
    switch (rarity) {
      case Rarity.common:
        return 10;
      case Rarity.rare:
        return 15;
      case Rarity.epic:
        return 20;
      case Rarity.legendary:
        return 25;
    }
  }

  // Check if equipment can be enhanced
  bool canEnhance(Equipment equipment) {
    return equipment.level < getMaxLevel(equipment.rarity);
  }
}

class EnhancementResult {
  final bool success;
  final int newLevel;
  final int cost;
  final String message;

  EnhancementResult({
    required this.success,
    required this.newLevel,
    required this.cost,
    required this.message,
  });
}

// Helper for random generation
final _random = _Random();

class _Random {
  double nextDouble() {
    return DateTime.now().millisecondsSinceEpoch % 1000 / 1000;
  }
}

// Power function for cost calculation
double pow(double base, int exponent) {
  double result = 1.0;
  for (int i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}
