import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';
import '../widgets/app_button.dart';
import '../widgets/stats_bar.dart';
import '../models/module.dart';
import '../models/simulation.dart';
import '../data/modules_data.dart';

class FlashcardsScreen extends StatefulWidget {
  final String moduleId;
  final BusinessSetup businessSetup;
  
  const FlashcardsScreen({
    super.key,
    required this.moduleId,
    required this.businessSetup,
  });

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  int currentIndex = 0;
  bool isFlipped = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moduleId = ModuleId.values.firstWhere(
      (e) => e.name == widget.moduleId,
      orElse: () => ModuleId.finance,
    );
    final module = getModuleById(moduleId);

    if (module == null) {
      return const Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Center(child: Text('Module not found')),
      );
    }

    final flashcards = module.flashcards;
    final isLastCard = currentIndex == flashcards.length - 1;

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
                    onTap: () => Navigator.pop(context, false),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.close, color: AppColors.textBright, size: 20),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(module.icon, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: AppSpacing.xs),
                            Text(module.name, style: AppTextStyles.headline3),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${currentIndex + 1} of ${flashcards.length} cards',
                          style: TextStyle(fontSize: 12, color: AppColors.textMid),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ProgressBar(
                progress: (currentIndex + 1) / flashcards.length,
              ),
            ),

            // Flashcard
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => isFlipped = !isFlipped);
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: _buildCard(flashcards[currentIndex], isFlipped),
                  ),
                ),
              ),
            ),

            // Navigation hint
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app, size: 16, color: AppColors.textDim),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      isFlipped ? 'Tap to see question' : 'Tap to reveal answer',
                      style: TextStyle(fontSize: 12, color: AppColors.textDim),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Footer Navigation
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  // Previous
                  if (currentIndex > 0)
                    Expanded(
                      child: AppSecondaryButton(
                        text: '← Previous',
                        onPressed: () {
                          setState(() {
                            currentIndex--;
                            isFlipped = false;
                          });
                        },
                      ),
                    ),
                  if (currentIndex > 0) const SizedBox(width: AppSpacing.sm),
                  // Next / Complete
                  Expanded(
                    flex: currentIndex > 0 ? 1 : 2,
                    child: isLastCard
                        ? AppSuccessButton(
                            text: 'Complete Module ✓',
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              Navigator.pop(context, true);
                            },
                          )
                        : AppPrimaryButton(
                            text: 'Next →',
                            onPressed: () {
                              setState(() {
                                currentIndex++;
                                isFlipped = false;
                              });
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Flashcard flashcard, bool showBack) {
    return Container(
      key: ValueKey(showBack),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: showBack ? AppColors.purple.withValues(alpha: 0.15) : AppColors.bgDarker,
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        border: Border.all(
          color: showBack ? AppColors.purple : AppColors.border,
          width: showBack ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Card side indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
            decoration: BoxDecoration(
              color: showBack ? AppColors.purple : AppColors.bgCard,
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: Text(
              showBack ? 'ANSWER' : 'QUESTION',
              style: AppTextStyles.tag.copyWith(
                color: showBack ? AppColors.textBright : AppColors.purple,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Content
          Text(
            showBack ? flashcard.back : flashcard.front,
            style: TextStyle(
              fontSize: showBack ? 18 : 22,
              fontWeight: showBack ? FontWeight.w500 : FontWeight.w700,
              color: AppColors.textBright,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          // Example (only on back)
          if (showBack && flashcard.example != null) ...[
            const SizedBox(height: AppSpacing.xl),
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
                  const Text('💡', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      flashcard.example!,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMid,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
