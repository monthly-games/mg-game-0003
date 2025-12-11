import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../game/logic/stage_manager.dart';

class StageInfoOverlay extends StatelessWidget {
  const StageInfoOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final stageManager = GetIt.I<StageManager>();

    return ListenableBuilder(
      listenable: stageManager,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Stage ${stageManager.currentStage}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              if (stageManager.isBossActive)
                const Text(
                  '🔥 BOSS 🔥',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                Text(
                  'Kills: ${stageManager.killCount} / ${StageManager.killsPerStage}',
                  style: const TextStyle(color: Colors.white70),
                ),
            ],
          ),
        );
      },
    );
  }
}
