import 'package:flutter/foundation.dart';
import 'package:mg_common_game/core/systems/save_manager.dart';

enum StageState { fighting, boss, cleared }

class StageManager extends ChangeNotifier implements Saveable {
  int currentStage = 1;
  int currentWave = 1;
  int killCount = 0;

  // Configuration
  static const int killsPerStage =
      5; // Low for prototype testing (normally 10-50)

  bool isBossActive = false;

  void onMonsterKilled({bool isBoss = false}) {
    if (isBoss) {
      completeStage();
    } else if (!isBossActive) {
      killCount++;
      if (killCount >= killsPerStage) {
        spawnBoss();
      }
      notifyListeners();
    }
  }

  void spawnBoss() {
    isBossActive = true;
    notifyListeners();
  }

  void completeStage() {
    isBossActive = false;
    killCount = 0;
    currentStage++;
    // Make game harder?
    notifyListeners();
  }

  void softReset() {
    currentStage = 1;
    currentWave = 1;
    killCount = 0;
    isBossActive = false;
    notifyListeners();
  }

  // Regions
  List<RegionData> get regions => [
    RegionData(
      name: 'Plains',
      bgImage: 'bg_battle.png', // Default
      monsterImages: ['monster_basic.png'],
      unlockStage: 1,
    ),
    RegionData(
      name: 'Forest',
      bgImage: 'bg_forest.png',
      monsterImages: ['monster_orc.png'], // Placeholder until gen
      unlockStage: 21,
    ),
    RegionData(
      name: 'Desert',
      bgImage: 'bg_desert.png',
      monsterImages: ['monster_snake.png'], // Placeholder until gen
      unlockStage: 41,
    ),
  ];

  RegionData get currentRegion {
    // Find highest unlocked region
    return regions.lastWhere(
      (r) => r.unlockStage <= currentStage,
      orElse: () => regions.first,
    );
  }

  // Difficulty Scaling
  double get monsterHpScale => 1.0 + (currentStage * 0.5);
  double get monsterAtkScale => 1.0 + (currentStage * 0.2);

  // Persistence
  @override
  String get saveKey => 'stage_manager';

  @override
  Map<String, dynamic> toSaveData() {
    return {'currentStage': currentStage, 'currentWave': currentWave};
  }

  @override
  void fromSaveData(Map<String, dynamic> data) {
    currentStage = data['currentStage'] ?? 1;
    currentWave = data['currentWave'] ?? 1;
    notifyListeners();
  }
}

class RegionData {
  final String name;
  final String bgImage;
  final List<String> monsterImages;
  final int unlockStage;

  RegionData({
    required this.name,
    required this.bgImage,
    required this.monsterImages,
    required this.unlockStage,
  });
}
