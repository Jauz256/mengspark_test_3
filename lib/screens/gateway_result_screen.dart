import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';
import '../widgets/app_button.dart';
import '../models/simulation.dart';

class GatewayResultScreen extends StatefulWidget {
  final bool passed;
  final int score;
  final BusinessSetup businessSetup;
  
  const GatewayResultScreen({
    super.key,
    required this.passed,
    required this.score,
    required this.businessSetup,
  });

  @override
  State<GatewayResultScreen> createState() => _GatewayResultScreenState();
}

class _GatewayResultScreenState extends State<GatewayResultScreen>
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
    final passed = widget.passed;
    final score = widget.score;
    final total = 12;
    final businessSetup = widget.businessSetup;

    final percentage = (score / total * 100).round();

    // Haptic feedback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (passed) {
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
                      child: Text(
                        passed ? '🎉' : '📚',
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Score
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                          vertical: AppSpacing.lg,
                        ),
                        decoration: BoxDecoration(
                          color: passed
                              ? AppColors.success.withValues(alpha: 0.15)
                              : AppColors.warning.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                          border: Border.all(
                            color: passed
                                ? AppColors.success.withValues(alpha: 0.3)
                                : AppColors.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$score/$total',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: passed ? AppColors.success : AppColors.warning,
                              ),
                            ),
                            Text(
                              '$percentage% Correct',
                              style: TextStyle(fontSize: 14, color: AppColors.textMid),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Title & Message
                    Text(
                      passed ? 'Gateway Passed!' : 'Not Quite Yet',
                      style: AppTextStyles.headline2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      passed
                          ? "You've proven you understand the basics. Time to put it into practice!"
                          : 'You need 8/12 correct to unlock the simulation. Review the modules and try again.',
                      style: TextStyle(fontSize: 14, color: AppColors.textMid, height: 1.5),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Requirements Box
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.bgDarker,
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                passed ? Icons.check_circle : Icons.info_outline,
                                color: passed ? AppColors.success : AppColors.warning,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                passed ? 'SIMULATION UNLOCKED' : 'REQUIREMENT',
                                style: AppTextStyles.tag.copyWith(
                                  color: passed ? AppColors.success : AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Minimum Score',
                                  style: TextStyle(fontSize: 14, color: AppColors.textMid),
                                ),
                              ),
                              Text(
                                '8/12 (67%)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBright,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Your Score',
                                  style: TextStyle(fontSize: 14, color: AppColors.textMid),
                                ),
                              ),
                              Text(
                                '$score/12 ($percentage%)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: passed ? AppColors.success : AppColors.danger,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // What's Next
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: passed
                            ? AppColors.purple.withValues(alpha: 0.1)
                            : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                        border: Border.all(
                          color: passed
                              ? AppColors.purple.withValues(alpha: 0.3)
                              : AppColors.border,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                passed ? '🚀' : '💡',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                passed ? "WHAT'S NEXT" : 'TIP',
                                style: AppTextStyles.tag.copyWith(
                                  color: passed ? AppColors.purple : AppColors.textDim,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            passed
                                ? 'You\'ll run a ${businessSetup.type.displayName.toLowerCase()} for 8 weeks. Every decision has consequences. Survive to win!'
                                : 'Focus on the flashcards, especially the examples. They show how concepts apply in real business situations.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textMid,
                              height: 1.5,
                            ),
                          ),
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
                  if (passed)
                    AppSuccessButton(
                      text: 'Start Simulation ⚔️',
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/simulation-game',
                          arguments: businessSetup,
                        );
                      },
                    )
                  else
                    AppPrimaryButton(
                      text: 'Review Modules',
                      onPressed: () {
                        Navigator.pop(context);
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
}
