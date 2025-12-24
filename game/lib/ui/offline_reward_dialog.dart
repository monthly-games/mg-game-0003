import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../game/logic/game_manager.dart';

class OfflineRewardDialog extends StatelessWidget {
  final int goldEarned;

  const OfflineRewardDialog({super.key, required this.goldEarned});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF222222),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time_filled, color: Colors.amber, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Welcome Back!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'While you were away, your mercenaries\ncollected some loot.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('💰', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
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
            const SizedBox(height: 24),
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
