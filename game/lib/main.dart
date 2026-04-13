import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import 'package:mg_common_game/mg_common_game.dart';
import 'package:mg_common_game/core/engine/event_bus.dart';
import 'package:mg_common_game/core/systems/save_system.dart';
import 'features/home/main_game_screen.dart';
import 'screens/daily_quest_screen.dart';
import 'screens/achievement_screen.dart';
import 'screens/collection_screen.dart';
import 'game/logic/stage_manager.dart';
import 'game/logic/inventory_logic.dart';
import 'game/logic/prestige_manager.dart' as game_logic;
import 'game/logic/game_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupDI();
  runApp(const MercenaryApp());
}

Future<void> _setupDI() async {
  final getIt = GetIt.I;

  // Core services
  if (!getIt.isRegistered<EventBus>()) {
    getIt.registerSingleton<EventBus>(EventBus());
  }

  if (!getIt.isRegistered<SaveSystem>()) {
    final saveSystem = LocalSaveSystem();
    await saveSystem.init();
    getIt.registerSingleton<SaveSystem>(saveSystem);
  }

  if (!getIt.isRegistered<GoldManager>()) {
    getIt.registerSingleton<GoldManager>(GoldManager());
  }

  if (!getIt.isRegistered<AudioManager>()) {
    getIt.registerSingleton<AudioManager>(AudioManager());
    try {
      await getIt<AudioManager>().initialize();
    } catch (e) {
      // Audio initialization may fail in test environment
      print('Audio initialization skipped: $e');
    }
  }

  if (!getIt.isRegistered<GameManager>()) {
    getIt.registerSingleton<GameManager>(
      GameManager(getIt<GoldManager>()),
    );
  }

  // Battlepass & Gacha
  if (!getIt.isRegistered<BattlePassManager>()) {
    getIt.registerSingleton<BattlePassManager>(BattlePassManager());
  }

  if (!getIt.isRegistered<GachaManager>()) {
    getIt.registerSingleton<GachaManager>(GachaManager());
  }

  // Daily Quest
  if (!getIt.isRegistered<DailyQuestManager>()) {
    final questManager = DailyQuestManager();

    // Register Mercenary Guild themed quests
    questManager.registerQuest(DailyQuest(
      id: 'mercenary_missions_5',
      title: 'Mission Specialist',
      description: 'Complete 5 mercenary missions',
      targetValue: 5,
      goldReward: 200,
      xpReward: 50,
    ));

    questManager.registerQuest(DailyQuest(
      id: 'mercenary_hire_3',
      title: 'Squad Leader',
      description: 'Hire 3 new mercenaries',
      targetValue: 3,
      goldReward: 150,
      xpReward: 40,
    ));

    questManager.registerQuest(DailyQuest(
      id: 'mercenary_gold_1500',
      title: 'Mercenary Wealth',
      description: 'Earn 1500 gold from missions',
      targetValue: 1500,
      goldReward: 250,
      xpReward: 75,
    ));

    getIt.registerSingleton<DailyQuestManager>(questManager);
  }

  // Achievement
  if (!getIt.isRegistered<AchievementManager>()) {
    getIt.registerSingleton<AchievementManager>(AchievementManager());
  }

  // Collection
  if (!getIt.isRegistered<CollectionManager>()) {
    getIt.registerSingleton<CollectionManager>(CollectionManager());
  }

  // Game-specific managers
  if (!getIt.isRegistered<StageManager>()) {
    getIt.registerSingleton<StageManager>(StageManager());
  }

  if (!getIt.isRegistered<InventoryLogic>()) {
    getIt.registerSingleton<InventoryLogic>(InventoryLogic());
  }

  if (!getIt.isRegistered<game_logic.PrestigeManager>()) {
    getIt.registerSingleton<game_logic.PrestigeManager>(game_logic.PrestigeManager());
  }
}

class MercenaryApp extends StatelessWidget {
  const MercenaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Mercenary Guild',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        primaryColor: const Color(0xFF4CAF50),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4CAF50),
          secondary: Color(0xFF03DAC6),
        ),
      ),
      routes: {
        '/daily-quest': (_) => const DailyQuestScreen(),
        '/achievements': (_) => const AchievementScreen(),
        '/collection': (context) => CollectionScreen(
          collectionManager: GetIt.I<CollectionManager>(),
        ),
      },
      home: const MainGameScreen(),
    );
  }
}
