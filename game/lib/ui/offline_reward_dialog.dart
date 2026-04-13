import 'package:mg_common_game/core/ui/layout/mg_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../game/logic/game_manager.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';

class OfflineRewardDialog extends StatelessWidget {
  final int goldEarned;

  const OfflineRewardDialog({super.key, required this.goldEarned});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF222222),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(MGSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time_filled, color: Colors.amber, size: 48),
            const SizedBox(height: MGSpacing.md),
            const Text(
              'Welcome Back!',
              style: TextStyle(
                color: MGColors.textHighEmphasis,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: MGSpacing.xs),
            const Text(
              'While you were away, your mercenaries\ncollected some loot.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: MGSpacing.lg),
            Container(
              padding: const EdgeInsets.all(MGSpacing.md),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('💰', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: MGSpacing.xs),
                  Text(
                    '$goldEarned G',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: MGSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  GetIt.I<GameManager>().consumeOfflineRewards();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('CLAIM REWARDS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
