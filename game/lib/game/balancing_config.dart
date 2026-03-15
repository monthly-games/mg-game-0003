import 'package:mg_common_game/systems/balancing/balancing.dart';

/// Default balancing configuration for MG-0003: Pixel Mercenary Guild.
///
/// Placeholder values for v1.2.0 pilot integration.
/// In production, override via RemoteConfig using
/// [BalancingManager.loadFromRemote].
const kDefaultBalancingConfig = BalancingConfig(
  gameId: 'mg-0003',
  version: 1,
  currencies: [
    CurrencyConfig(
      id: 'gold',
      baseEarnRate: 15.0,
      earnGrowthFactor: 1.2,
    ),
  ],
  xpCurve: XpCurveConfig(baseXp: 100, maxLevel: 100),
  difficultyScaling: DifficultyScalingConfig(scalingFactor: 0.15),
  customParams: {
    'reward_multiplier': 1.0,
    'crit_base_chance': 0.05,
    'squad_size_base': 3,
  },
);
