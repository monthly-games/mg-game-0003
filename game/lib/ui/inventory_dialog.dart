import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/systems/inventory/inventory_item.dart';
import '../game/data/equipment.dart';
import '../game/logic/inventory_logic.dart';

class InventoryDialog extends StatefulWidget {
  final EquipmentType? filterType;
  final Function(InventoryItem) onEquip;

  const InventoryDialog({super.key, this.filterType, required this.onEquip});

  @override
  State<InventoryDialog> createState() => _InventoryDialogState();
}

class _InventoryDialogState extends State<InventoryDialog> {
  late final InventoryLogic _inventory;

  @override
  void initState() {
    super.initState();
    _inventory = GetIt.I<InventoryLogic>();
    _inventory.addListener(_refresh);
  }

  @override
  void dispose() {
    _inventory.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    // Filter items
    final items = _inventory.manager.items.values.where((item) {
      if (widget.filterType == null) return true;
      final eq = Equipment.fromInventoryItem(item);
      return eq.type == widget.filterType;
    }).toList();

    return Dialog(
      backgroundColor: const Color(0xFF222222),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.filterType != null
                  ? 'Select ${widget.filterType!.name}'
                  : 'Inventory',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              const Text(
                'No items found.',
                style: TextStyle(color: Colors.white54),
              ),
            if (items.isNotEmpty)
              SizedBox(
                height: 300,
                width: double.maxFinite,
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.white24),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final eq = Equipment.fromInventoryItem(item);
                    return ListTile(
                      leading: _buildIcon(eq.rarity),
                      title: Text(
                        '${eq.name} +${eq.level}',
                        style: TextStyle(color: _getRarityColor(eq.rarity)),
                      ),
                      subtitle: Text(
                        _getStatsText(eq),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      trailing: _buildActionButtons(context, item, eq),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(Rarity rarity) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black45,
        border: Border.all(color: _getRarityColor(rarity), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.shield, color: Colors.white70, size: 24),
    );
  }

  Color _getRarityColor(Rarity rarity) {
    switch (rarity) {
      case Rarity.common:
        return Colors.white;
      case Rarity.rare:
        return Colors.blue;
      case Rarity.epic:
        return Colors.purple;
      case Rarity.legendary:
        return Colors.orange;
    }
  }

  String _getStatsText(Equipment eq) {
    // Show current stats (scaled by level)
    final parts = <String>[];
    if (eq.currentAtk > 0) parts.add('ATK +${eq.currentAtk.toInt()}');
    if (eq.currentDef > 0) parts.add('DEF +${eq.currentDef.toInt()}');
    if (eq.currentHp > 0) parts.add('HP +${eq.currentHp.toInt()}');
    return parts.join(', ');
  }

  Widget _buildActionButtons(
    BuildContext context,
    InventoryItem item,
    Equipment eq,
  ) {
    final cost = eq.upgradeCost;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: () {
            final success = _inventory.upgradeItem(item);
            if (!success) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Not enough gold!')));
            } else {
              // Refresh happens via listener
            }
          },
          child: Text('Up (\$$cost)'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          onPressed: () {
            widget.onEquip(item);
            Navigator.of(context).pop();
          },
          child: const Text('Equip'),
        ),
      ],
    );
  }
}
