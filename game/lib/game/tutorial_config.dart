import 'package:mg_common_game/systems/tutorial/tutorial.dart';
import 'package:mg_common_game/systems/tutorial/tutorial_data.dart';

/// Tutorial configuration for MG-0003: Pixel Mercenary Guild (RPG).
///
/// Placeholder tutorial steps for v1.2.0 pilot integration.
/// In production, replace descriptions with localized strings
/// and add targetKey for highlight positioning.

// Tutorial disabled for now - using simple placeholder
const List<TutorialStep> kOnboardingSteps = [
  TutorialStep(
    id: 'tap_area',
    title: 'Tap to Collect',
    description: 'Tap the screen to earn gold.',
  ),
  TutorialStep(
    id: 'shop_button',
    title: 'Buy Upgrades',
    description: 'Purchase upgrades from the shop to increase income.',
  ),
];
