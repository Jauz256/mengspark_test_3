import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';
import '../widgets/app_button.dart';
import '../data/founders_data.dart';

class RevealScreen extends StatefulWidget {
  final String founderId;
  final int decisionIndex;
  final int userChoice;
  
  const RevealScreen({
    super.key,
    required this.founderId,
    required this.decisionIndex,
    required this.userChoice,
  });

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    
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
    final decisionIndex = widget.decisionIndex;
    final userChoice = widget.userChoice;
    final results = <bool>[];

    final founder = getFounderById(founderId);
    if (founder == null) {
      return const Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Center(child: Text('Founder not found')),
      );
    }

    final decision = founder.decisions[decisionIndex];
    final isCorrect = userChoice == decision.correctIndex;
    final newResults = [...results, isCorrect];

    // Haptic feedback based on result
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isCorrect) {
        HapticFeedback.lightImpact();
      } else {
        HapticFeedback.heavyImpact();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? AppColors.success.withValues(alpha: 0.15)
                              : AppColors.danger.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppBorderRadius.round),
                          border: Border.all(
                            color: isCorrect ? AppColors.success : AppColors.danger,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isCorrect ? '✓' : '✗',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isCorrect ? AppColors.success : AppColors.danger,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              isCorrect ? 'You thought like a founder!' : 'Different path taken',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isCorrect ? AppColors.success : AppColors.danger,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // What they actually did
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.bgDarker,
                            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                            border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.purple,
                                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                    ),
                                    child: Text(
                                      'WHAT ${founder.name.split(' ').first.toUpperCase()} DID',
                                      style: AppTextStyles.tag.copyWith(color: AppColors.textBright),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                decision.whatFounderDid,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textBright,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Why it worked
                        Text(
                          'WHY IT WORKED',
                          style: AppTextStyles.tag.copyWith(color: AppColors.textDim),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            decision.whyItWorked,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textMid,
                              height: 1.6,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // The Outcome
                        Text(
                          'THE OUTCOME',
                          style: AppTextStyles.tag.copyWith(color: AppColors.textDim),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('💡', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  decision.outcome,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textBright,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Your choice comparison (if wrong)
                        if (!isCorrect) ...[
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'YOUR CHOICE',
                            style: AppTextStyles.tag.copyWith(color: AppColors.textDim),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.danger.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppBorderRadius.md),
                              border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              decision.choices[userChoice],
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textMid,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),

                // Footer
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: AppPrimaryButton(
                    text: decisionIndex + 1 < founder.decisions.length
                        ? 'Next Decision →'
                        : 'See Final Score →',
                    onPressed: () {
                      if (decisionIndex + 1 < founder.decisions.length) {
                        Navigator.pushReplacementNamed(
                          context,
                          '/decision',
                          arguments: {
                            'founderId': founderId,
                            'decisionIndex': decisionIndex + 1,
                            'results': newResults,
                          },
                        );
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          '/score',
                          arguments: {
                            'founderId': founderId,
                            'results': newResults,
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
