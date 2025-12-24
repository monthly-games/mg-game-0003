import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/ui/theme/app_colors.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import '../../game/battle_game.dart';
import '../../game/logic/stage_manager.dart';
import '../../ui/hud/mg_top_bar.dart';
import '../heroes/hero_management_screen.dart';
import '../prestige/prestige_screen.dart';
import '../inventory/inventory_screen.dart';
import '../shop/shop_screen.dart';
import '../guild/guild_screen.dart';

class MainGameScreen extends StatefulWidget {
  const MainGameScreen({super.key});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  int _selectedIndex = 0;

  // We want the Game to run continuously, so we keep it in a Stack or IndexedStack
  // However, FlameGame widget needs to be alive.
  // Best pattern: Game as background, UI as overlay?
  // Design says: [Main Screen] -> [Heroes] is a separate section.
  // But usually Idle RPGs show battle at top or bottom while managing.
  // Let's go with: PageView logic where Battle is one tab or valid persistent widget.
  // For simplicity: Simple BottomNav switching full screens, but Battle state is preserved in Logic classes.

  // BattleGame widget itself might reload if completely removed from tree.
  // Let's use IndexedStack to keep BattleGame alive.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false, // MGTopBar handles top safe area
        child: Column(
          children: [
            // Top Bar (Currency)
            _buildTopBar(),

            // Content
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  // Tab 0: Battle
                  const GameWidget.controlled(gameFactory: BattleGame.new),

                  // Tab 1: Heroes
                  const HeroManagementScreen(),

                  // Tab 2: Inventory
                  const InventoryScreen(),

                  // Tab 3: Shop
                  const ShopScreen(),

                  // Tab 4: Guild
                  const GuildScreen(),

                  // Tab 5: Prestige
                  const PrestigeScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed, // Needed for >3 items
        onTap: (idx) => setState(() => _selectedIndex = idx),
        backgroundColor: Colors.black87,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.colorize), // Sword-like
            label: 'Battle',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Heroes'),
          BottomNavigationBarItem(icon: Icon(Icons.backpack), label: 'Bag'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Guild'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Prestige'),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return StreamBuilder<int>(
      stream: GetIt.I<GoldManager>().onGoldChanged,
      initialData: GetIt.I<GoldManager>().currentGold,
      builder: (ctx, snapshot) {
        final stageManager = GetIt.I<StageManager>();
        return MGTopBar(
          gold: snapshot.data ?? 0,
          stageLevel: stageManager.currentStage,
        );
      },
    );
  }
}
