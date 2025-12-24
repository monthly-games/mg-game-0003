import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import '../game/logic/game_manager.dart';

import '../game/data/hero_data.dart';
import '../game/data/equipment.dart';
import '../game/logic/inventory_logic.dart';
import 'inventory_dialog.dart';

class HeroManagementPanel extends StatefulWidget {
  const HeroManagementPanel({super.key});

  @override
  State<HeroManagementPanel> createState() => _HeroManagementPanelState();
}

class _HeroManagementPanelState extends State<HeroManagementPanel> {
  late final GameManager _gameManager;
  late final GoldManager _goldManager;

  @override
  void initState() {
    super.initState();
    _gameManager = GetIt.I<GameManager>();
    _goldManager = GetIt.I<GoldManager>();
    _gameManager.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _gameManager.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF222222),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Gold & Recruit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Squad',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_gameManager.party.any(
                      (h) => h.role == HeroRole.healer,
                    ))
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: ElevatedButton(
                          onPressed: () => _gameManager.recruitHealer(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: const Size(60, 30),
                          ),
                          child: const Text(
                            'Heal (1k)',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    if (!_gameManager.party.any((h) => h.role == HeroRole.mage))
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: ElevatedButton(
                          onPressed: () => _gameManager.recruitMage(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: const Size(60, 30),
                          ),
                          child: const Text(
                            'Mage (3k)',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    if (!_gameManager.party.any(
                      (h) => h.role == HeroRole.assassin,
                    ))
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: ElevatedButton(
                          onPressed: () => _gameManager.recruitAssassin(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: const Size(60, 30),
                          ),
                          child: const Text(
                            'Asn (2k)',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    const SizedBox(width: 4),
                    StreamBuilder<int>(
                      stream: _goldManager.onGoldChanged,
                      initialData: _goldManager.currentGold,
                      builder: (context, snapshot) {
                        return Text(
                          'Gold: ${snapshot.data}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // List of Heroes
          Expanded(
            child: ListView.separated(
              itemCount: _gameManager.party.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final hero = _gameManager.party[index];

                // Role Color
                Color roleColor = Colors.grey;
                if (hero.role.name == 'tank') {
                  roleColor = Colors.blue;
                } else if (hero.role.name == 'archer') {
                  roleColor = Colors.green;
                } else if (hero.role.name == 'healer') {
                  roleColor = Colors.purpleAccent;
                }

                return Card(
                  color: const Color(0xFF333333),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // 1. Hero Info
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: roleColor,
                            child: Text(
                              hero.id.length > 1
                                  ? hero.id[1].toUpperCase()
                                  : 'H',
                            ),
                          ),
                          title: Text(
                            '${hero.name} (Lv.${hero.level})',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'HP: ${hero.currentHp.toInt()} / ATK: ${hero.currentAtk.toInt()} / DEF: ${hero.currentDef.toInt()}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _gameManager.upgradeHero(hero),
                            child: const Text('UP (50G)'),
                          ),
                        ),
                        const Divider(color: Colors.white24),
                        // 2. Equipment Slots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildEquipmentSlot(
                              context,
                              hero,
                              EquipmentType.weapon,
                            ),
                            _buildEquipmentSlot(
                              context,
                              hero,
                              EquipmentType.armor,
                            ),
                            _buildEquipmentSlot(
                              context,
                              hero,
                              EquipmentType.accessory,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentSlot(
    BuildContext context,
    HeroData hero,
    EquipmentType type,
  ) {
    final equipped = hero.equipment[type];
    final bool isEmpty = equipped == null;

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => InventoryDialog(
            filterType: type,
            onEquip: (item) {
              final invLogic = GetIt.I<InventoryLogic>();
              invLogic.equipItem(hero, item);
              setState(() {}); // Refresh UI
            },
          ),
        );
      },
      onLongPress: !isEmpty
          ? () {
              // Unequip
              final invLogic = GetIt.I<InventoryLogic>();
              invLogic.unequipItem(hero, type);
              setState(() {});
            }
          : null,
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black26,
          border: Border.all(
            color: isEmpty ? Colors.grey : _getRarityColor(equipped.rarity),
            width: isEmpty ? 1 : 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getTypeIcon(type),
              color: isEmpty ? Colors.white24 : Colors.white,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              isEmpty ? 'Empty' : equipped.name,
              style: TextStyle(
                color: isEmpty ? Colors.grey : Colors.white,
                fontSize: 10,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(EquipmentType type) {
    switch (type) {
      case EquipmentType.weapon:
        return Icons.golf_course;
      case EquipmentType.armor:
        return Icons.shield;
      case EquipmentType.accessory:
        return Icons.ring_volume;
    }
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
}
