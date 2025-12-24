import 'package:flutter/foundation.dart';
import 'package:mg_common_game/systems/inventory/inventory_manager.dart';
import 'package:mg_common_game/systems/inventory/inventory_item.dart';
import 'package:mg_common_game/core/systems/save_manager.dart';
import '../data/hero_data.dart';
import '../data/equipment.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import 'package:get_it/get_it.dart';

class InventoryLogic extends ChangeNotifier implements Saveable {
  final InventoryManager manager;

  InventoryLogic() : manager = InventoryManager(maxSlots: 50);

  // Persistence
  @override
  String get saveKey => 'user_inventory';

  @override
  Map<String, dynamic> toSaveData() => manager.toJson();

  @override
  void fromSaveData(Map<String, dynamic> data) {
    manager.fromJson(data);
    notifyListeners();
  }

  // Convenience Methods
  void addItem(String id, {int amount = 1, Equipment? equipmentData}) {
    manager.addItem(
      id,
      amount,
      metadata: equipmentData?.toInventoryItem().metadata,
    );
    notifyListeners();
  }

  bool equipItem(HeroData hero, InventoryItem item) {
    // 1. Verify item exists in inventory
    if (!manager.hasItem(item.id)) return false;

    // 2. Parse Equipment Data
    final equip = Equipment.fromInventoryItem(item);

    // 3. Unequip existing if any
    if (hero.equipment.containsKey(equip.type)) {
      unequipItem(hero, equip.type);
    }

    // 4. Remove from Inventory
    final result = manager.removeItem(item.id, 1);
    if (!result.success) return false;

    // 5. Add to Hero
    hero.equipment[equip.type] = equip;

    notifyListeners();
    return true;
  }

  void unequipItem(HeroData hero, EquipmentType slot) {
    if (!hero.equipment.containsKey(slot)) return;

    final equip = hero.equipment[slot]!;

    // Add back to inventory
    manager.addItem(equip.id, 1, metadata: equip.toInventoryItem().metadata);

    // Remove from hero
    hero.equipment.remove(slot);

    notifyListeners();
  }

  bool upgradeItem(InventoryItem item) {
    if (!manager.hasItem(item.id)) return false;

    final equip = Equipment.fromInventoryItem(item);
    final goldManager = GetIt.I<GoldManager>();

    // 1. Check Cost
    final cost = equip.upgradeCost;
    if (goldManager.currentGold < cost) return false;

    // 2. Try Spend Gold
    if (!goldManager.trySpendGold(cost)) return false;

    // 3. Upgrade Item (Level Up)
    // manager.items is Map<String, InventoryItem>
    // 3. Upgrade Item (Level Up)
    // InventoryItem fields are final. We must replace the item to update metadata.

    final oldAmount = manager.getAmount(item.id);

    // Remove old item
    manager.removeItem(item.id, oldAmount);

    // Create new metadata
    final newMeta = Map<String, dynamic>.from(
      equip.toInventoryItem().metadata ?? {},
    );
    newMeta['level'] = equip.level + 1;

    // Re-add with new metadata
    manager.addItem(item.id, oldAmount, metadata: newMeta);

    notifyListeners();
    return true;
  }
}
