import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';
import '../widgets/app_button.dart';
import '../models/simulation.dart';
import '../data/scenarios_data.dart';

class SimulationResultScreen extends StatefulWidget {
  final BusinessSetup businessSetup;
  final SimulationState finalState;
  final String? deathReason;
  
  const SimulationResultScreen({
    super.key,
    required this.businessSetup,
    required this.finalState,
    this.deathReason,
  });

  @override
  State<SimulationResultScreen> createState() => _SimulationResultScreenState();
}

class _SimulationResultScreenState extends State<SimulationResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businessSetup = widget.businessSetup;
    final finalState = widget.finalState;
    final deathReason = widget.deathReason;

    final survived = deathReason == null;
    final weeksCompleted = finalState.week;

    String title;
    String subtitle;
    String emoji;
    Color accentColor;

    if (survived) {
      title = 'You Survived!';
      subtitle = 'Your ${businessSetup.type.displayName.toLowerCase()} made it through $maxWeeks weeks.';
      emoji = '🎉';
      accentColor = AppColors.gold;
    } else {
      switch (deathReason) {
        case 'bankruptcy':
          title = 'Bankrupt';
          subtitle = 'You ran out of cash in week $weeksCompleted.';
          emoji = '💸';
          accentColor = AppColors.danger;
          break;
        case 'reputation':
          title = 'Reputation Destroyed';
          subtitle = 'No one trusts your business anymore.';
          emoji = '📉';
          accentColor = AppColors.danger;
          break;
        case 'morale':
          title = 'Team Collapsed';
          subtitle = 'Your entire staff quit.';
          emoji = '😞';
          accentColor = AppColors.danger;
          break;
        default:
          title = 'Game Over';
          subtitle = 'Your business failed.';
          emoji = '💀';
          accentColor = AppColors.danger;
      }
    }

    // Haptic feedback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (survived) {
        HapticFeedback.heavyImpact();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),

            // Result Display
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    // Emoji
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Text(emoji, style: const TextStyle(fontSize: 80)),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Title
                    Text(
                      title,
                      style: AppTextStyles.headline1.copyWith(color: accentColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: AppColors.textMid),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Final Stats
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.bgDarker,
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'FINAL STATS',
                            style: AppTextStyles.tag.copyWith(color: AppColors.textDim),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildFinalStat(
                                '💰',
                                '฿${(finalState.cash / 1000).toStringAsFixed(0)}K',
                                'Cash',
                                finalState.cash <= 0,
                              ),
                              _buildFinalStat(
                                '⭐',
                                '${finalState.reputation}%',
                                'Reputation',
                                finalState.reputation <= 0,
                              ),
                              _buildFinalStat(
                                '😊',
                                '${finalState.morale}%',
                                'Morale',
                                finalState.morale <= 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Journey Summary
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.bgDarker,
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'YOUR JOURNEY',
                            style: AppTextStyles.tag.copyWith(color: AppColors.textDim),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildSummaryRow(
                            '📅',
                            'Weeks Survived',
                            '$weeksCompleted/$maxWeeks',
                          ),
                          _buildSummaryRow(
                            '🎯',
                            'Decisions Made',
                            '${finalState.history.length}',
                          ),
                          _buildSummaryRow(
                            businessSetup.type.icon,
                            'Business Type',
                            businessSetup.type.displayName,
                          ),
                          _buildSummaryRow(
                            '📍',
                            'Location',
                            businessSetup.location,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Key Decisions
                    if (finalState.history.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.bgDarker,
                          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KEY MOMENTS',
                              style: AppTextStyles.tag.copyWith(color: AppColors.textDim),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            ...finalState.history.take(5).map((h) {
                              final impact = h.consequences.cash +
                                  (h.consequences.reputation * 100) +
                                  (h.consequences.morale * 100);
                              final isPositive = impact > 0;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: isPositive
                                            ? AppColors.success.withValues(alpha: 0.15)
                                            : AppColors.danger.withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'W${h.week}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: isPositive
                                                ? AppColors.success
                                                : AppColors.danger,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Text(
                                        h.consequences.message,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textMid,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  AppPrimaryButton(
                    text: 'Try Again',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/business-setup',
                        (route) => route.settings.name == '/',
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppSecondaryButton(
                    text: 'Back to Home',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalStat(String icon, String value, String label, bool isDead) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDead ? AppColors.danger : AppColors.textBright,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppColors.textDim),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: AppColors.textMid),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textBright,
            ),
          ),
        ],
      ),
    );
  }
}
