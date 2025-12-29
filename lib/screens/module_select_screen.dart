import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';
import '../widgets/app_button.dart';
import '../widgets/stats_bar.dart';
import '../models/simulation.dart';
import '../models/module.dart';
import '../data/modules_data.dart';

class ModuleSelectScreen extends StatefulWidget {
  final BusinessSetup businessSetup;
  
  const ModuleSelectScreen({super.key, required this.businessSetup});

  @override
  State<ModuleSelectScreen> createState() => _ModuleSelectScreenState();
}

class _ModuleSelectScreenState extends State<ModuleSelectScreen> {
  List<ModuleId> completedModules = [];

  @override
  Widget build(BuildContext context) {
    final setup = widget.businessSetup;
    final progress = getModuleProgress(completedModules);
    final requiredModules = 3; // Must complete at least 3 modules

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
                      child: const Icon(Icons.arrow_back, color: AppColors.textBright, size: 20),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📚 Gateway Training', style: AppTextStyles.headline3),
                        const SizedBox(height: 2),
                        Text(
                          'Complete $requiredModules+ modules to unlock simulation',
                          style: TextStyle(fontSize: 12, color: AppColors.textMid),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${completedModules.length}/${modulesData.length} modules',
                        style: TextStyle(fontSize: 12, color: AppColors.textMid),
                      ),
                      Text(
                        '${progress.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: completedModules.length >= requiredModules
                              ? AppColors.success
                              : AppColors.textMid,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ProgressBar(
                    progress: progress / 100,
                    color: completedModules.length >= requiredModules
                        ? AppColors.success
                        : AppColors.purple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Module Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 0.9,
                ),
                itemCount: modulesData.length,
                itemBuilder: (context, index) {
                  final module = modulesData[index];
                  final isCompleted = completedModules.contains(module.id);
                  return _buildModuleCard(context, module, isCompleted, setup);
                },
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: completedModules.length >= requiredModules
                  ? AppSuccessButton(
                      text: 'Take AI Quiz →',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/ai-quiz',
                          arguments: {
                            'businessSetup': setup,
                            'completedModules': completedModules,
                          },
                        );
                      },
                    )
                  : Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Text('🔒', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Complete ${requiredModules - completedModules.length} more module(s) to unlock AI Quiz',
                              style: TextStyle(fontSize: 12, color: AppColors.textMid),
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

  Widget _buildModuleCard(BuildContext context, Module module, bool isCompleted, BusinessSetup setup) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        final result = await Navigator.pushNamed(
          context,
          '/flashcards',
          arguments: {
            'moduleId': module.id,
            'businessSetup': setup,
          },
        );
        if (result == true && !completedModules.contains(module.id)) {
          setState(() => completedModules.add(module.id));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.success.withValues(alpha: 0.15) : AppColors.bgDarker,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
            color: isCompleted ? AppColors.success : AppColors.border,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Text(module.icon, style: const TextStyle(fontSize: 32)),
                if (isCompleted)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.bgDarker, width: 2),
                      ),
                      child: const Icon(Icons.check, size: 12, color: AppColors.textBright),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              module.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isCompleted ? AppColors.success : AppColors.textMid,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
