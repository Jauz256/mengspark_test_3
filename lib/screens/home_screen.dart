import 'package:flutter/material.dart';
import '../constants/theme.dart';
import '../widgets/app_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.xl,
                bottom: AppSpacing.lg,
              ),
              child: Column(
                children: [
                  const Text(
                    '🔥 MengSpark',
                    style: AppTextStyles.headline1,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Experience Before You Invest',
                    style: AppTextStyles.dimText,
                  ),
                ],
              ),
            ),

            // Mode Cards
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    // LEARN Mode
                    ModeCard(
                      icon: '🎓',
                      title: 'LEARN',
                      subtitle: 'What Would You Do?',
                      description: 'Face the same decisions real founders faced. See how billionaires think.',
                      badgeText: 'FREE',
                      isPro: false,
                      onTap: () {
                        Navigator.pushNamed(context, '/founder-list');
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // PLAY Mode
                    ModeCard(
                      icon: '⚔️',
                      title: 'PLAY',
                      subtitle: 'Your Business Simulation',
                      description: 'Run YOUR business. Face real consequences. Survive or die.',
                      badgeText: 'PRO',
                      isPro: true,
                      onTap: () {
                        Navigator.pushNamed(context, '/business-setup');
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // PROVE Mode (Locked)
                    const ModeCard(
                      icon: '🔥',
                      title: 'PROVE',
                      subtitle: 'Stakes & Competition',
                      description: 'Put money on the line. Challenge friends. Top the leaderboard.',
                      badgeText: 'PRO',
                      isPro: true,
                      isLocked: true,
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Built from 500+ founder interviews',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textDim,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
