import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';
import '../widgets/app_button.dart';
import '../data/founders_data.dart';

class ScoreScreen extends StatefulWidget {
  final String founderId;
  final List<bool> results;
  
  const ScoreScreen({
    super.key,
    required this.founderId,
    required this.results,
  });

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> with SingleTickerProviderStateMixin {
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
    final founderId = widget.founderId;
    final results = widget.results;

    final founder = getFounderById(founderId);
    if (founder == null) {
      return const Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Center(child: Text('Founder not found')),
      );
    }

    final correctCount = results.where((r) => r).length;
    final totalCount = results.length;
    final percentage = (correctCount / totalCount * 100).round();
    
    String title;
    String subtitle;
    String emoji;
    Color accentColor;

    if (percentage >= 80) {
      title = 'Founder Material!';
      subtitle = 'You think like a billion-dollar entrepreneur.';
      emoji = '🏆';
      accentColor = AppColors.gold;
    } else if (percentage >= 60) {
      title = 'Promising Mindset';
      subtitle = 'You have good instincts. Keep learning!';
      emoji = '⭐';
      accentColor = AppColors.success;
    } else if (percentage >= 40) {
      title = 'Room to Grow';
      subtitle = 'Some good calls, but founders think differently.';
      emoji = '📈';
      accentColor = AppColors.warning;
    } else {
      title = 'Different Path';
      subtitle = 'Your instincts differ from this founder. That\'s OK!';
      emoji = '🎯';
      accentColor = AppColors.purple;
    }

    // Haptic feedback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (percentage >= 60) {
        HapticFeedback.heavyImpact();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            // Header spacer
            const SizedBox(height: AppSpacing.xl),

            // Score Display
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    // Emoji
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Text(
                        emoji,
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
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                          border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$correctCount/$totalCount',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: accentColor,
                              ),
                            ),
                            Text(
                              'Correct Decisions',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textMid,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Title & Subtitle
                    Text(
                      title,
                      style: AppTextStyles.headline2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMid,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Decision breakdown
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
                          ...List.generate(results.length, (index) {
                            final isCorrect = results[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: isCorrect
                                          ? AppColors.success.withValues(alpha: 0.15)
                                          : AppColors.danger.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isCorrect ? AppColors.success : AppColors.danger,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        isCorrect ? Icons.check : Icons.close,
                                        size: 16,
                                        color: isCorrect ? AppColors.success : AppColors.danger,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Text(
                                      'Decision ${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textBright,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    isCorrect ? 'Match!' : 'Different',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isCorrect ? AppColors.success : AppColors.textDim,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Founder info
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.purple.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppBorderRadius.md),
                            ),
                            child: const Center(
                              child: Text('👤', style: TextStyle(fontSize: 24)),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  founder.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textBright,
                                  ),
                                ),
                                Text(
                                  '${founder.company} • ${founder.nowWorth}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMid,
                                  ),
                                ),
                              ],
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
                  AppPrimaryButton(
                    text: 'Try Another Founder',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/founder-list',
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
}
