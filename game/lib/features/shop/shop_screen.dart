import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import '../../game/logic/inventory_logic.dart';
import '../../game/data/equipment.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goldManager = GetIt.I<GoldManager>();
    final inventory = GetIt.I<InventoryLogic>();

    return ListenableBuilder(
      listenable: goldManager,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Equipment Shop',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 20),

              _buildGachaCard(
                context,
                'Basic Chest',
                500,
                goldManager,
                inventory,
                false,
              ),
              const SizedBox(height: 16),
              _buildGachaCard(
                context,
                'Premium Chest',
                2000,
                goldManager,
                inventory,
                true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGachaCard(
    BuildContext context,
    String title,
    int cost,
    GoldManager goldManager,
    InventoryLogic inventory,
    bool isPremium,
  ) {
    final canAfford = goldManager.currentGold >= cost;

    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.inventory_2,
              size: 48,
              color: isPremium ? Colors.purple : Colors.brown,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isPremium
                        ? 'High chance for Epic/Legendary'
                        : 'Common equipment',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: canAfford ? Colors.amber : Colors.grey,
                foregroundColor: Colors.black,
              ),
              onPressed: canAfford
                  ? () => _performSummon(
                      context,
                      cost,
                      isPremium,
                      goldManager,
                      inventory,
                    )
                  : null,
              child: Text('$cost G'),
            ),
          ],
        ),
      ),
    );
  }

  void _performSummon(
    BuildContext context,
    int cost,
    bool isPremium,
    GoldManager goldManager,
    InventoryLogic inventory,
  ) {
    if (goldManager.trySpendGold(cost)) {
      // Logic
      final random = Random();

      // Rarity Weights
      // Basic: 80% Common, 15% Rare, 5% Epic
      // Premium: 40% Rare, 40% Epic, 20% Legendary

      Rarity rarity;
      final roll = random.nextDouble();

      if (isPremium) {
        if (roll < 0.4)
          rarity = Rarity.rare;
        else if (roll < 0.8)
          rarity = Rarity.epic;
        else
          rarity = Rarity.legendary;
      } else {
        if (roll < 0.8)
          rarity = Rarity.common;
        else if (roll < 0.95)
          rarity = Rarity.rare;
        else
          rarity = Rarity.epic;
      }

      final type =
          EquipmentType.values[random.nextInt(EquipmentType.values.length)];
      final id =
          'eq_${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(100)}';

      final equip = Equipment(
        id: id,
        name: '${rarity.name} ${type.name}',
        type: type,
        rarity: rarity,
        atkBonus: type == EquipmentType.weapon ? (rarity.index + 1) * 10 : 0,
        defBonus: type == EquipmentType.armor ? (rarity.index + 1) * 5 : 0,
        hpBonus: type == EquipmentType.accessory ? (rarity.index + 1) * 50 : 0,
      );

      inventory.addItem(id, equipmentData: equip);

      // UI Feedback
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Summon Result',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: _getRarityColor(rarity), size: 64),
              const SizedBox(height: 16),
              Text(
                equip.name,
                style: TextStyle(
                  color: _getRarityColor(rarity),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Color _getRarityColor(Rarity rarity) {
    switch (rarity) {
      case Rarity.common:
        return Colors.grey;
      case Rarity.rare:
        return Colors.blue;
      case Rarity.epic:
        return Colors.purple;
      case Rarity.legendary:
        return Colors.orange;
    }
  }
}
