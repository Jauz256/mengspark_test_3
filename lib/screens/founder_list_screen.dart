import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../widgets/app_card.dart';
import '../data/founders_data.dart';

class FounderListScreen extends StatelessWidget {
  const FounderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🎓 LEARN Mode',
                          style: AppTextStyles.headline3,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Choose a founder story',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.purple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Founder List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: foundersData.length,
                separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final founder = foundersData[index];
                  return FounderCard(
                    name: founder.name,
                    company: founder.company,
                    photoUrl: founder.photo,
                    startedWith: founder.startedWith,
                    nowWorth: founder.nowWorth,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/founder-intro',
                        arguments: founder.id,
                      );
                    },
                  );
                },
              ),
            ),

            // Hint
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Each story has 5 critical decisions. Can you think like a billionaire?',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMid,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
