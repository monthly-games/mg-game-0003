import 'package:flutter/foundation.dart';

enum StageState { fighting, boss, cleared }

class StageManager extends ChangeNotifier {
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

  // Difficulty Scaling
  double get monsterHpScale => 1.0 + (currentStage * 0.5);
  double get monsterAtkScale => 1.0 + (currentStage * 0.2);
}
