import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';
import '../widgets/app_button.dart';
import '../widgets/choice_button.dart';
import '../widgets/stats_bar.dart';
import '../data/founders_data.dart';

class DecisionScreen extends StatefulWidget {
  final String founderId;
  final int decisionIndex;
  
  const DecisionScreen({
    super.key,
    required this.founderId,
    required this.decisionIndex,
  });

  @override
  State<DecisionScreen> createState() => _DecisionScreenState();
}

class _DecisionScreenState extends State<DecisionScreen> {
  int? selectedChoice;

  @override
  Widget build(BuildContext context) {
    final founderId = widget.founderId;
    final decisionIndex = widget.decisionIndex;
    final results = <bool>[];
    
    final founder = getFounderById(founderId);
    if (founder == null) {
      return const Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Center(child: Text('Founder not found')),
      );
    }

    final decision = founder.decisions[decisionIndex];
    final totalDecisions = founder.decisions.length;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.textBright,
                        size: 20,
                      ),
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
                          founder.company,
                          style: AppTextStyles.subtitle,
                        ),
                      ],
                    ),
                  ),
                  WeekBadge(
                    currentWeek: decisionIndex + 1,
                    totalWeeks: totalDecisions,
                  ),
                ],
              ),
            ),

            // Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ProgressBar(
                progress: (decisionIndex + 1) / totalDecisions,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Situation Card
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
                          Row(
                            children: [
                              const Text('📖', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Decision ${decisionIndex + 1}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textBright,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            decision.situation,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textBright,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // What would YOU do?
                    Text(
                      'WHAT WOULD YOU DO?',
                      style: AppTextStyles.tag.copyWith(color: AppColors.gold),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Choices
                    ...List.generate(decision.choices.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ChoiceButton(
                          index: index,
                          text: decision.choices[index],
                          isSelected: selectedChoice == index,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => selectedChoice = index);
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppPrimaryButton(
                text: selectedChoice == null ? 'Select a choice' : 'Lock In My Choice →',
                onPressed: selectedChoice != null
                    ? () {
                        HapticFeedback.mediumImpact();
                        Navigator.pushNamed(
                          context,
                          '/reveal',
                          arguments: {
                            'founderId': founderId,
                            'decisionIndex': decisionIndex,
                            'userChoice': selectedChoice,
                            'results': results,
                          },
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
