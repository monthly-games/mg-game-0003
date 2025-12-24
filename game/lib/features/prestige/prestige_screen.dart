import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../game/logic/prestige_manager.dart';
import '../../game/logic/stage_manager.dart';

class PrestigeScreen extends StatelessWidget {
  const PrestigeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prestigeManager = GetIt.I<PrestigeManager>();
    final stageManager = GetIt.I<StageManager>();

    return ListenableBuilder(
      listenable: Listenable.merge([prestigeManager, stageManager]),
      builder: (context, _) {
        final currentStage = stageManager.currentStage;
        final pendingRelics = prestigeManager.calculateRelicsToGain(
          currentStage,
        );
        final canPrestige = pendingRelics > 0;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.star, size: 64, color: Colors.amber),
                    const SizedBox(height: 8),
                    Text(
                      'Relics: ${prestigeManager.relics}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Prestige Action
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Current Stage: $currentStage',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ascend now to gain +$pendingRelics Relics',
                      style: TextStyle(
                        color: canPrestige ? Colors.green : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: canPrestige
                          ? () => prestigeManager.prestige()
                          : null,
                      child: const Text(
                        'ASCEND',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Requires Stage 20+',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              const Text(
                'Ancient Upgrades',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Upgrades List
              Expanded(
                child: ListView(
                  children: [
                    _buildUpgradeCard(
                      'Gold Find',
                      'Current: x${prestigeManager.goldMultiplier.toStringAsFixed(1)}',
                      prestigeManager.goldUpgradeCost,
                      () => prestigeManager.buyGoldUpgrade(),
                      prestigeManager.relics >= prestigeManager.goldUpgradeCost,
                    ),
                    _buildUpgradeCard(
                      'Damage Boost',
                      'Current: x${prestigeManager.damageMultiplier.toStringAsFixed(1)}',
                      prestigeManager.damageUpgradeCost,
                      () => prestigeManager.buyDamageUpgrade(),
                      prestigeManager.relics >=
                          prestigeManager.damageUpgradeCost,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUpgradeCard(
    String title,
    String subtitle,
    int cost,
    VoidCallback onTap,
    bool canAfford,
  ) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: canAfford ? Colors.blue : Colors.grey,
          ),
          onPressed: canAfford ? onTap : null,
          child: Text('$cost Relics'),
        ),
      ),
    );
  }
}
