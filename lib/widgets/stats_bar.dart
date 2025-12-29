import 'package:flutter/material.dart';
import '../constants/theme.dart';

/// Stats Bar - Always visible during gameplay
/// Shows Cash, Reputation, Morale
class StatsBar extends StatelessWidget {
  final int cash;
  final int reputation;
  final int morale;
  final int? cashChange;
  final int? repChange;
  final int? moraleChange;

  const StatsBar({
    super.key,
    required this.cash,
    required this.reputation,
    required this.morale,
    this.cashChange,
    this.repChange,
    this.moraleChange,
  });

  Color _getStatColor(int value, {bool isCash = false}) {
    if (isCash) {
      if (value < 30000) return AppColors.danger;
      if (value < 60000) return AppColors.warning;
      return AppColors.textBright;
    }
    if (value < 20) return AppColors.danger;
    if (value < 40) return AppColors.warning;
    return AppColors.textBright;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgDarker,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: '💰',
            value: '฿${(cash / 1000).toStringAsFixed(0)}K',
            color: _getStatColor(cash, isCash: true),
            change: cashChange,
            isCash: true,
          ),
          _StatItem(
            icon: '⭐',
            value: '$reputation%',
            color: _getStatColor(reputation),
            change: repChange,
          ),
          _StatItem(
            icon: '😊',
            value: '$morale%',
            color: _getStatColor(morale),
            change: moraleChange,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String value;
  final Color color;
  final int? change;
  final bool isCash;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.color,
    this.change,
    this.isCash = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: AppSpacing.xs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppTextStyles.stat.copyWith(color: color),
            ),
            if (change != null)
              Text(
                isCash
                    ? '${change! > 0 ? '+' : ''}฿${(change! / 1000).toStringAsFixed(0)}K'
                    : '${change! > 0 ? '+' : ''}$change',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: change! > 0 ? AppColors.success : AppColors.danger,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Week Progress Badge
class WeekBadge extends StatelessWidget {
  final int currentWeek;
  final int totalWeeks;

  const WeekBadge({
    super.key,
    required this.currentWeek,
    required this.totalWeeks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.circular(AppBorderRadius.round),
      ),
      child: Text(
        'Week $currentWeek/$totalWeeks',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textBright,
        ),
      ),
    );
  }
}

/// Progress Bar - Thin horizontal bar
class ProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color? color;

  const ProgressBar({
    super.key,
    required this.progress,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? AppColors.purple,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// Module Tag
class ModuleTag extends StatelessWidget {
  final String moduleName;
  final bool isUrgent;

  const ModuleTag({
    super.key,
    required this.moduleName,
    this.isUrgent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: isUrgent ? AppColors.danger : AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Text(
        isUrgent ? '🚨 URGENT' : moduleName.toUpperCase(),
        style: AppTextStyles.tag.copyWith(
          color: isUrgent ? AppColors.textBright : AppColors.purple,
        ),
      ),
    );
  }
}

/// Change Tag - Shows stat changes (positive/negative)
class ChangeTag extends StatelessWidget {
  final String text;
  final bool isPositive;

  const ChangeTag({
    super.key,
    required this.text,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: isPositive
            ? AppColors.success.withValues(alpha: 0.2)
            : AppColors.danger.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textBright,
        ),
      ),
    );
  }
}

/// Badge - Small label (FREE, PRO, URGENT)
class AppBadge extends StatelessWidget {
  final String text;
  final BadgeType type;

  const AppBadge({
    super.key,
    required this.text,
    this.type = BadgeType.free,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor = AppColors.bgDeep;

    switch (type) {
      case BadgeType.free:
        bgColor = AppColors.success;
        break;
      case BadgeType.pro:
        bgColor = AppColors.gold;
        break;
      case BadgeType.urgent:
        bgColor = AppColors.danger;
        textColor = AppColors.textBright;
        break;
      case BadgeType.module:
        bgColor = AppColors.purple.withValues(alpha: 0.15);
        textColor = AppColors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Text(
        text,
        style: AppTextStyles.tag.copyWith(color: textColor),
      ),
    );
  }
}

enum BadgeType { free, pro, urgent, module }
