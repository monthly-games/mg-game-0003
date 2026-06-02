/// Element System for MG-0003 Pixel Mercenary RPG
/// Implements Fire/Water/Grass rock-paper-scissors mechanics
enum ElementType {
  fire,
  water,
  grass;

  /// Get elemental advantage multiplier against another element
  /// Returns 1.5 for advantage, 0.67 for disadvantage, 1.0 for neutral
  double getAdvantageMultiplier(ElementType other) {
    if (this == other) return 1.0; // Same element = neutral

    // Fire > Grass > Water > Fire
    if (this == ElementType.fire && other == ElementType.grass) return 1.5;
    if (this == ElementType.grass && other == ElementType.water) return 1.5;
    if (this == ElementType.water && other == ElementType.fire) return 1.5;

    // Disadvantage cases
    if (this == ElementType.fire && other == ElementType.water) return 0.67;
    if (this == ElementType.water && other == ElementType.grass) return 0.67;
    if (this == ElementType.grass && other == ElementType.fire) return 0.67;

    return 1.0; // Default neutral
  }

  /// Check if this element has advantage against another
  bool hasAdvantageAgainst(ElementType other) {
    return getAdvantageMultiplier(other) > 1.0;
  }

  /// Check if this element has disadvantage against another
  bool hasDisadvantageAgainst(ElementType other) {
    return getAdvantageMultiplier(other) < 1.0;
  }

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case ElementType.fire:
        return '불';
      case ElementType.water:
        return '물';
      case ElementType.grass:
        return '풀';
    }
  }

  /// Get color for UI representation
  String get colorHex {
    switch (this) {
      case ElementType.fire:
        return '#FF5722'; // Orange-red
      case ElementType.water:
        return '#2196F3'; // Blue
      case ElementType.grass:
        return '#4CAF50'; // Green
    }
  }
}