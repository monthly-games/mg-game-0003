import 'package:flutter/material.dart';
import 'package:mg_common_game/core/ui/mg_ui.dart';

/// MG UI 기반 상단 바
/// 아이들 RPG 게임용 자원 표시 바
class MGTopBar extends StatelessWidget {
  final int gold;
  final int gems;
  final int? stageLevel;
  final VoidCallback? onSettings;

  const MGTopBar({
    super.key,
    required this.gold,
    this.gems = 0,
    this.stageLevel,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final safeArea = MediaQuery.of(context).padding;

    return Container(
      padding: EdgeInsets.only(
        top: safeArea.top + MGSpacing.sm,
        left: safeArea.left + MGSpacing.md,
        right: safeArea.right + MGSpacing.md,
        bottom: MGSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        border: Border(
          bottom: BorderSide(
            color: MGColors.primaryAction.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 좌측: 스테이지 레벨
          if (stageLevel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: MGColors.primaryAction.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: MGColors.primaryAction.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shield,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Stage $stageLevel',
                    style: MGTextStyles.hudSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              'Pixel Mercenary',
              style: MGTextStyles.hud.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

          // 우측: 자원 표시
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MGResourceBar(
                icon: Icons.monetization_on,
                value: _formatNumber(gold),
                iconColor: MGColors.gold,
                onTap: null,
              ),
              if (gems > 0) ...[
                MGSpacing.hSm,
                MGResourceBar(
                  icon: Icons.diamond,
                  value: _formatNumber(gems),
                  iconColor: MGColors.gem,
                  onTap: null,
                ),
              ],
              if (onSettings != null) ...[
                MGSpacing.hSm,
                MGIconButton(
                  icon: Icons.settings,
                  onPressed: onSettings,
                  size: 36,
                  backgroundColor: Colors.black54,
                  color: Colors.white,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
