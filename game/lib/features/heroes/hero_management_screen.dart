import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../game/logic/game_manager.dart';
import '../../game/data/hero_data.dart';

class HeroManagementScreen extends StatelessWidget {
  const HeroManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameManager = GetIt.I<GameManager>();

    return ListenableBuilder(
      listenable:
          gameManager, // Rebuild when party changes or gold changes (if notifying)
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'My Party',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            ...gameManager.party.map(
              (hero) => _buildHeroCard(context, hero, gameManager),
            ),

            const Divider(color: Colors.grey),
            const Text(
              'Recruitment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            _buildRecruitButton(
              context,
              'Healer (1000g)',
              () => gameManager.recruitHealer(),
              gameManager.party.any((h) => h.role == HeroRole.healer),
            ),
            _buildRecruitButton(
              context,
              'Assassin (2000g)',
              () => gameManager.recruitAssassin(),
              gameManager.party.any((h) => h.role == HeroRole.assassin),
            ),
            _buildRecruitButton(
              context,
              'Mage (3000g)',
              () => gameManager.recruitMage(),
              gameManager.party.any((h) => h.role == HeroRole.mage),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    HeroData hero,
    GameManager gameManager,
  ) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.person, color: Colors.white, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${hero.name} (Lv.${hero.level})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ATK: ${hero.currentAtk.toInt()}  HP: ${hero.currentHp.toInt()}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => gameManager.upgradeHero(hero),
              child: const Text('LvUp (50g)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecruitButton(
    BuildContext context,
    String label,
    VoidCallback onTap,
    bool isOwned,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isOwned ? Colors.grey : Colors.blue,
          padding: const EdgeInsets.all(16),
        ),
        onPressed: isOwned ? null : onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            if (isOwned) const Icon(Icons.check),
          ],
        ),
      ),
    );
  }
}
