// import 'package:mg_common_game/core/assets/asset_types.dart'; // SpineAssetMeta not available

/// Spine 통합 플래그. `--dart-define=SPINE_ENABLED=true`로 활성화.
const kSpineEnabled = bool.fromEnvironment(
  'SPINE_ENABLED',
  defaultValue: false,
);

// ── Mercenary Leader ─────────────────────────────────────────

// const kMercenaryLeaderMeta = SpineAssetMeta(
//   key: 'mercenary_leader',
//   path: 'spine/characters/mercenary_leader',
//   atlasPath:
//       'assets/spine/characters/mercenary_leader/mercenary_leader.atlas',
//   skeletonPath:
//       'assets/spine/characters/mercenary_leader/mercenary_leader.json',
//   animations: ['idle', 'walk', 'attack', 'hit'],
//   defaultAnimation: 'idle',
//   defaultMix: 0.2,
// );

// ── Mercenary Healer ─────────────────────────────────────────

// const kMercenaryHealerMeta = SpineAssetMeta(
//   key: 'mercenary_healer',
//   path: 'spine/characters/mercenary_healer',
//   atlasPath:
//       'assets/spine/characters/mercenary_healer/mercenary_healer.atlas',
//   skeletonPath:
//       'assets/spine/characters/mercenary_healer/mercenary_healer.json',
//   animations: ['idle', 'walk', 'attack', 'hit'],
//   defaultAnimation: 'idle',
//   defaultMix: 0.2,
// );

// ── Mercenary Tank ───────────────────────────────────────────

// const kMercenaryTankMeta = SpineAssetMeta(
//   key: 'mercenary_tank',
//   path: 'spine/characters/mercenary_tank',
//   atlasPath:
//       'assets/spine/characters/mercenary_tank/mercenary_tank.atlas',
//   skeletonPath:
//       'assets/spine/characters/mercenary_tank/mercenary_tank.json',
//   animations: ['idle', 'walk', 'attack', 'hit'],
//   defaultAnimation: 'idle',
//   defaultMix: 0.2,
// );
