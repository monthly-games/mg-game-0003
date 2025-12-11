import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import '../game/logic/game_manager.dart';

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
                    if (!_gameManager.party.any((h) => h.role.name == 'healer'))
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () => _gameManager.recruitHealer(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: const Text(
                            'Hire (1k)',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
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

                // Color logic
                Color roleColor = Colors.grey;
                if (hero.role.name == 'tank')
                  roleColor = Colors.blue;
                else if (hero.role.name == 'archer')
                  roleColor = Colors.green;
                else if (hero.role.name == 'healer')
                  roleColor = Colors.purpleAccent;

                return Card(
                  color: const Color(0xFF333333),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: roleColor,
                      child: Text(
                        hero.id.length > 1 ? hero.id[1].toUpperCase() : 'H',
                      ),
                    ),
                    title: Text(
                      '${hero.name} (Lv.${hero.level})',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'HP: ${hero.hp.value.toInt()} / ATK: ${hero.atk.value.toInt()}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _gameManager.upgradeHero(hero),
                      child: const Text('UP (50G)'),
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
}
