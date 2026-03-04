import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import 'package:mg_common_game/systems/progression/upgrade_manager.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';
import 'features/home/main_game_screen.dart';
import 'game/logic/game_manager.dart';
import 'game/logic/stage_manager.dart';
import 'game/logic/inventory_logic.dart';
import 'game/logic/prestige_manager.dart';
import 'game/combat_manager.dart';
import 'game/squad_manager.dart';
import 'game/equipment_manager.dart';

// ============================================================
// Mercenary Brigade — MG-0003
// Genre: RPG · Battle · Squad · India Region
// Phase 1 Week 3: RPG Mechanic Enhancement
//
// Core loop: Recruit → Equip → Battle → Upgrade → Prestige
// Subsystems: Combat, Squad formation, Equipment, Upgrades (8)
// ============================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupDI();
  runApp(const MercenaryApp());
}

/// Initialize all DI-registered systems in correct dependency order.
/// Core systems first, then game logic, then combat/squad/equipment,
/// and finally the UpgradeManager with 8 registered upgrades.
Future<void> _setupDI() async {
  final getIt = GetIt.I;

  // ── Core systems ─────────────────────────────────────────────
  getIt.registerSingleton<AudioManager>(AudioManager());
  await getIt<AudioManager>().initialize();

  // ── Economy ──────────────────────────────────────────────────
  getIt.registerSingleton<GoldManager>(GoldManager());

  // ── Game logic ───────────────────────────────────────────────
  getIt.registerSingleton<StageManager>(StageManager());
  getIt.registerSingleton<GameManager>(GameManager(getIt<GoldManager>()));
  getIt.registerSingleton<InventoryLogic>(InventoryLogic());
  getIt.registerSingleton<PrestigeManager>(PrestigeManager());

  // ── Combat & squad systems ───────────────────────────────────
  getIt.registerSingleton<CombatManager>(CombatManager());
  getIt.registerSingleton<SquadManager>(SquadManager());
  getIt.registerSingleton<EquipmentManager>(EquipmentManager());

  // ── Upgrade system ───────────────────────────────────────────
  final upgradeManager = UpgradeManager();
  getIt.registerSingleton<UpgradeManager>(upgradeManager);
  _registerUpgrades(upgradeManager);
  await upgradeManager.loadUpgrades();

  // Apply saved upgrade levels to runtime managers
  _applyUpgradeEffects();
}

// ============================================================
// Upgrade Registration — 8 mercenary RPG upgrades
//
// Categories:
//   Combat (4): attack_damage, crit_chance, skill_cooldown, combo_multiplier
//   Squad  (2): squad_size, formation_bonus
//   Equip  (2): gear_slots, stat_multiplier
// ============================================================

void _registerUpgrades(UpgradeManager manager) {
  // ── Combat upgrades (4) ──────────────────────────────────────

  manager.registerUpgrade(Upgrade(
    id: 'attack_damage',
    name: 'Blade Sharpening',
    description: 'Hone mercenary weapons to increase base attack damage by 10% per level.',
    maxLevel: 15,
    baseCost: 100,
    costMultiplier: 1.4,
    valuePerLevel: 0.10, // +10% damage per level
  ));

  manager.registerUpgrade(Upgrade(
    id: 'crit_chance',
    name: 'Precision Training',
    description: 'Train mercenaries in weak-point targeting, adding 3% crit chance per level.',
    maxLevel: 10,
    baseCost: 200,
    costMultiplier: 1.5,
    valuePerLevel: 0.03, // +3% crit per level
  ));

  manager.registerUpgrade(Upgrade(
    id: 'skill_cooldown',
    name: 'Battle Reflexes',
    description: 'Sharpen reflexes to reduce skill cooldowns by 5% per level.',
    maxLevel: 8,
    baseCost: 250,
    costMultiplier: 1.6,
    valuePerLevel: 0.05, // 5% cooldown reduction per level
  ));

  manager.registerUpgrade(Upgrade(
    id: 'combo_multiplier',
    name: 'Combo Mastery',
    description: 'Master chain attacks, boosting combo damage multiplier by 15% per level.',
    maxLevel: 10,
    baseCost: 180,
    costMultiplier: 1.45,
    valuePerLevel: 0.15, // +15% combo multiplier per level
  ));

  // ── Squad upgrades (2) ───────────────────────────────────────

  manager.registerUpgrade(Upgrade(
    id: 'squad_size',
    name: 'Mercenary Barracks',
    description: 'Expand barracks to recruit one additional squad member per level.',
    maxLevel: 5,
    baseCost: 500,
    costMultiplier: 2.0,
    valuePerLevel: 1.0, // +1 squad slot per level
  ));

  manager.registerUpgrade(Upgrade(
    id: 'formation_bonus',
    name: 'Tactical Formations',
    description: 'Unlock advanced formations granting 8% damage and 4% defense per level.',
    maxLevel: 10,
    baseCost: 300,
    costMultiplier: 1.5,
    valuePerLevel: 0.08, // +8% formation bonus per level
  ));

  // ── Equipment upgrades (2) ───────────────────────────────────

  manager.registerUpgrade(Upgrade(
    id: 'gear_slots',
    name: 'Armory Expansion',
    description: 'Add one equipment slot per hero for each level.',
    maxLevel: 5,
    baseCost: 400,
    costMultiplier: 1.8,
    valuePerLevel: 1.0, // +1 gear slot per level
  ));

  manager.registerUpgrade(Upgrade(
    id: 'stat_multiplier',
    name: 'Enchanted Gear',
    description: 'Magical enchantments boost all gear stat bonuses by 12% per level.',
    maxLevel: 10,
    baseCost: 350,
    costMultiplier: 1.55,
    valuePerLevel: 0.12, // +12% stat multiplier per level
  ));
}

// ============================================================
// Apply Upgrade Effects — Sync upgrade levels to managers
// ============================================================

/// Push current upgrade values into CombatManager, SquadManager,
/// and EquipmentManager so they reflect the latest saved state.
void _applyUpgradeEffects() {
  final di = GetIt.I;

  // Managers read from UpgradeManager via getters, so refreshing
  // just notifies their listeners to rebuild dependent UI.
  di<CombatManager>().refreshFromUpgrades();
  di<SquadManager>().refreshFromUpgrades();
  di<EquipmentManager>().refreshFromUpgrades();
}

// ============================================================
// App Root — Year 1 dark theme with green/gold accents
// ============================================================

class MercenaryApp extends StatelessWidget {
  const MercenaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Mercenary Guild',
      debugShowCheckedModeBanner: false,
      theme: _buildMercenaryTheme(),
      home: const MainGameScreen(),
    );
  }

  /// Year 1 Core dark theme tuned for RPG aesthetics.
  /// Uses MGColors.year1Primary (green) with gold resource accents.
  ThemeData _buildMercenaryTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: MGColors.year1Primary,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: MGColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: MGColors.surfaceDark,
      ),
      cardTheme: CardThemeData(
        color: MGColors.cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MercenaryUpgradePanel — Upgrade display widget
//
// A self-contained widget showing all 8 upgrades grouped by
// category. Reads UpgradeManager and GoldManager from GetIt.
// Can be embedded in any screen via MercenaryUpgradePanel().
// ============================================================

class MercenaryUpgradePanel extends StatefulWidget {
  const MercenaryUpgradePanel({super.key});

  @override
  State<MercenaryUpgradePanel> createState() => _MercenaryUpgradePanelState();
}

class _MercenaryUpgradePanelState extends State<MercenaryUpgradePanel> {
  static const _combatIds = [
    'attack_damage',
    'crit_chance',
    'skill_cooldown',
    'combo_multiplier',
  ];
  static const _squadIds = ['squad_size', 'formation_bonus'];
  static const _equipIds = ['gear_slots', 'stat_multiplier'];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GetIt.I<UpgradeManager>(),
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCategoryHeader('Combat Upgrades', Icons.local_fire_department),
            ..._combatIds.map(_buildUpgradeCard),
            const SizedBox(height: 16),
            _buildCategoryHeader('Squad Upgrades', Icons.groups),
            ..._squadIds.map(_buildUpgradeCard),
            const SizedBox(height: 16),
            _buildCategoryHeader('Equipment Upgrades', Icons.shield),
            ..._equipIds.map(_buildUpgradeCard),
          ],
        );
      },
    );
  }

  Widget _buildCategoryHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: MGColors.year1Accent, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MGColors.textHighEmphasis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeCard(String upgradeId) {
    final upgradeManager = GetIt.I<UpgradeManager>();
    final goldManager = GetIt.I<GoldManager>();
    final upgrade = upgradeManager.getUpgrade(upgradeId);

    if (upgrade == null) return const SizedBox.shrink();

    final isMaxed = upgrade.currentLevel >= upgrade.maxLevel;
    final cost = upgrade.costForNextLevel;
    final canAfford = !isMaxed && goldManager.currentGold >= cost;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Info column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${upgrade.name}  Lv.${upgrade.currentLevel}/${upgrade.maxLevel}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: MGColors.textHighEmphasis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    upgrade.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: MGColors.textMediumEmphasis,
                    ),
                  ),
                  if (!isMaxed) ...[
                    const SizedBox(height: 4),
                    _buildProgressBar(upgrade),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Purchase button
            _buildPurchaseButton(
              upgrade: upgrade,
              upgradeManager: upgradeManager,
              goldManager: goldManager,
              isMaxed: isMaxed,
              canAfford: canAfford,
              cost: cost,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(Upgrade upgrade) {
    final progress = upgrade.currentLevel / upgrade.maxLevel;
    return SizedBox(
      height: 4,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: MGColors.border,
        valueColor: const AlwaysStoppedAnimation<Color>(MGColors.year1Primary),
      ),
    );
  }

  Widget _buildPurchaseButton({
    required Upgrade upgrade,
    required UpgradeManager upgradeManager,
    required GoldManager goldManager,
    required bool isMaxed,
    required bool canAfford,
    required int cost,
  }) {
    if (isMaxed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: MGColors.year1Primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'MAX',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MGColors.year1Primary,
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: canAfford
          ? () {
              final purchased = upgradeManager.purchaseUpgrade(
                upgrade.id,
                () => goldManager.currentGold,
                (spent) => goldManager.trySpendGold(spent),
              );
              if (purchased) {
                _refreshManagers();
                setState(() {});
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_upward, size: 16),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.monetization_on,
                size: 14,
                color: MGColors.gold,
              ),
              const SizedBox(width: 2),
              Text(
                _formatCost(cost),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Apply upgrade effects to runtime managers after a purchase.
  void _refreshManagers() {
    final di = GetIt.I;
    di<CombatManager>().refreshFromUpgrades();
    di<SquadManager>().refreshFromUpgrades();
    di<EquipmentManager>().refreshFromUpgrades();
  }

  /// Format large costs with K/M suffixes for readability.
  String _formatCost(int cost) {
    if (cost >= 1000000) {
      return '${(cost / 1000000).toStringAsFixed(1)}M';
    } else if (cost >= 1000) {
      return '${(cost / 1000).toStringAsFixed(1)}K';
    }
    return cost.toString();
  }
}
