import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import 'features/home/main_game_screen.dart';
import 'game/logic/game_manager.dart';
import 'game/logic/stage_manager.dart';
import 'game/logic/inventory_logic.dart';
import 'game/logic/prestige_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupDI();
  runApp(const MercenaryApp());
}

Future<void> _setupDI() async {
  final getIt = GetIt.I;

  // Core
  getIt.registerSingleton<AudioManager>(AudioManager());
  await getIt<AudioManager>().initialize();

  // Logic
  getIt.registerSingleton<GoldManager>(GoldManager());
  getIt.registerSingleton<StageManager>(StageManager());
  getIt.registerSingleton<GameManager>(GameManager(getIt<GoldManager>()));
  getIt.registerSingleton<InventoryLogic>(
    InventoryLogic(getIt<GameManager>()),
  ); // Inventory depends on Game/Gold usually
  getIt.registerSingleton<PrestigeManager>(PrestigeManager());
}

class MercenaryApp extends StatelessWidget {
  const MercenaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Mercenary Guild',
      theme: ThemeData.dark(),
      home: const MainGameScreen(),
    );
  }
}
