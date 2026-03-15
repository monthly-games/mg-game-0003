import 'package:mg_common_game/systems/tutorial/tutorial.dart';

/// Tutorial configuration for MG-0003: Pixel Mercenary Guild (RPG).
///
/// Placeholder tutorial steps for v1.2.0 pilot integration.
/// In production, replace descriptions with localized strings
/// and add targetSelector for highlight positioning.
const kOnboardingTutorial = TutorialConfig(
  id: 'onboarding',
  name: 'Mercenary Guild Tutorial',
  steps: [
    TutorialStep(
      id: 'welcome',
      title: 'Welcome, Commander!',
      description: 'Lead your mercenary guild to glory.',
      actionHint: 'Tap to continue',
    ),
    TutorialStep(
      id: 'recruit_mercenary',
      title: 'Recruit a Mercenary',
      description: 'Visit the barracks and recruit your first mercenary.',
      actionHint: 'Tap recruit',
      targetSelector: 'recruit_button',
    ),
    TutorialStep(
      id: 'first_battle',
      title: 'Enter Battle',
      description:
          'Send your squad into combat. '
          'Mercenaries fight automatically based on their formation.',
      actionHint: 'Tap battle',
      targetSelector: 'battle_button',
    ),
    TutorialStep(
      id: 'equip_gear',
      title: 'Equip Your Squad',
      description: 'Equip weapons and armor to boost mercenary stats.',
      actionHint: 'Tap to continue',
    ),
  ],
  skippable: true,
  showOnFirstLaunch: true,
  trigger: TutorialTrigger.firstLaunch,
);
