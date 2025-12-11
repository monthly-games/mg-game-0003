import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flame/game.dart';
import 'package:mg_common_game/core/ui/theme/game_theme.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import 'game/battle_game.dart';
import 'game/logic/game_manager.dart';
import 'game/logic/stage_manager.dart';
import 'ui/hero_management_panel.dart';
import 'ui/stage_info_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const PixelMercenaryApp());
}

void setupDependencies() {
  final getIt = GetIt.instance;

  final goldManager = GoldManager();
  getIt.registerSingleton<GoldManager>(goldManager);

  final gameManager = GameManager(goldManager);
  getIt.registerSingleton<GameManager>(gameManager);

  final stageManager = StageManager();
  getIt.registerSingleton<StageManager>(stageManager);
}

class PixelMercenaryApp extends StatelessWidget {
  const PixelMercenaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Mercenary',
      theme: GameTheme.darkTheme,
      home: const MainGameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainGameScreen extends StatelessWidget {
  const MainGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. Battle Area (Top 60%)
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                GameWidget(game: BattleGame()),
                const Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Center(child: StageInfoOverlay()),
                ),
              ],
            ),
          ),

          // 2. Management Area (Bottom 40%)
          const Expanded(flex: 4, child: HeroManagementPanel()),
        ],
      ),
    );
  }
}
