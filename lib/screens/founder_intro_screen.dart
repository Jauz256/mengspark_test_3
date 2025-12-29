import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../widgets/app_button.dart';
import '../data/founders_data.dart';

class FounderIntroScreen extends StatelessWidget {
  final String founderId;
  
  const FounderIntroScreen({super.key, required this.founderId});

  @override
  Widget build(BuildContext context) {
    final founder = getFounderById(founderId);

    if (founder == null) {
      return const Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Center(
          child: Text('Founder not found', style: TextStyle(color: AppColors.textBright)),
        ),
      );
    }

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
                        Icons.arrow_back,
                        color: AppColors.textBright,
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    ),
                    child: Text(
                      '${founder.decisions.length} Decisions',
                      style: AppTextStyles.tag.copyWith(color: AppColors.bgDeep),
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
                    // Profile Card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.bgDarker,
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          // Photo placeholder
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.purple.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                              border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
                            ),
                            child: const Center(
                              child: Text('👤', style: TextStyle(fontSize: 40)),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            founder.name,
                            style: AppTextStyles.headline2,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            founder.company,
                            style: AppTextStyles.subtitle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          // Stats row
                          Row(
                            children: [
                              Expanded(
                                child: _buildStat('Started with', founder.startedWith),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: AppColors.border,
                              ),
                              Expanded(
                                child: _buildStat('Now worth', founder.nowWorth, isHighlight: true),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Background
                    Text(
                      'BACKGROUND',
                      style: AppTextStyles.tag.copyWith(color: AppColors.textDim),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      founder.background,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMid,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // The Setup
                    Text(
                      'THE SETUP',
                      style: AppTextStyles.tag.copyWith(color: AppColors.textDim),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(color: AppColors.purple.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        founder.setup,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textBright,
                          height: 1.6,
                        ),
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
              child: AppPrimaryButton(
                text: 'Begin Journey →',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/decision',
                    arguments: {
                      'founderId': founder.id,
                      'decisionIndex': 0,
                      'results': <bool>[],
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, {bool isHighlight = false}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textDim,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isHighlight ? AppColors.gold : AppColors.textBright,
          ),
        ),
      ],
    );
  }
}
