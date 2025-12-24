import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/systems/inventory/inventory_item.dart';
import '../../game/logic/inventory_logic.dart';
import '../../game/logic/game_manager.dart';
import '../../game/data/equipment.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inventory = GetIt.I<InventoryLogic>();
    final gameManager = GetIt.I<GameManager>();

    return ListenableBuilder(
      listenable: inventory,
      builder: (context, _) {
        final items = inventory.manager.getSortedItems();

        if (items.isEmpty) {
          return const Center(
            child: Text(
              'Inventory Empty',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildItemSlot(context, item, inventory, gameManager);
          },
        );
      },
    );
  }

  Widget _buildItemSlot(
    BuildContext context,
    InventoryItem item,
    InventoryLogic inventory,
    GameManager gameManager,
  ) {
    // Parse equipment data for display
    final equip = Equipment.fromInventoryItem(item);

    return GestureDetector(
      onTap: () =>
          _showItemDetails(context, item, equip, inventory, gameManager),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(color: _getRarityColor(equip.rarity)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getIconForType(equip.type), color: Colors.white, size: 24),
            if (item.amount > 1)
              Text(
                'x${item.amount}',
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
          ],
        ),
      ),
    );
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

  IconData _getIconForType(EquipmentType type) {
    switch (type) {
      case EquipmentType.weapon:
        return Icons.colorize; // sword-like
      case EquipmentType.armor:
        return Icons.shield;
      case EquipmentType.accessory:
        return Icons.ring_volume;
    }
  }

  void _showItemDetails(
    BuildContext context,
    InventoryItem item,
    Equipment equip,
    InventoryLogic inventory,
    GameManager gameManager,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          equip.name,
          style: TextStyle(color: _getRarityColor(equip.rarity)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type: ${equip.type.name}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'ATK: +${equip.atkBonus}',
              style: const TextStyle(color: Colors.green),
            ),
            Text(
              'DEF: +${equip.defBonus}',
              style: const TextStyle(color: Colors.green),
            ),
            Text(
              'HP: +${equip.hpBonus}',
              style: const TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text(
              'Equip to:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              width: double.maxFinite,
              child: ListView(
                children: gameManager.party
                    .map(
                      (hero) => ListTile(
                        leading: const Icon(Icons.person, color: Colors.white),
                        title: Text(
                          hero.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            inventory.equipItem(hero, item);
                            Navigator.pop(ctx);
                          },
                          child: const Text('Equip'),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
