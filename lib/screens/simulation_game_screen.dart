import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';
import '../widgets/app_button.dart';
import '../widgets/choice_button.dart';
import '../widgets/stats_bar.dart';
import '../models/simulation.dart';
import '../models/module.dart';
import '../data/scenarios_data.dart';

class SimulationGameScreen extends StatefulWidget {
  final BusinessSetup businessSetup;
  
  const SimulationGameScreen({super.key, required this.businessSetup});

  @override
  State<SimulationGameScreen> createState() => _SimulationGameScreenState();
}

class _SimulationGameScreenState extends State<SimulationGameScreen> {
  late BusinessSetup businessSetup;
  late SimulationState gameState;
  late List<Scenario> allScenarios;
  
  List<Scenario> currentScenarios = [];
  int currentScenarioIndex = 0;
  int? selectedChoice;
  bool showResult = false;
  List<String> triggeredScenarioIds = [];

  @override
  void initState() {
    super.initState();
    businessSetup = widget.businessSetup;
    gameState = SimulationState.initial(businessSetup);
    allScenarios = getScenarios(businessSetup);
    _loadWeekScenarios();
  }

  void _loadWeekScenarios() {
    final weekScenarios = allScenarios.where((s) => s.week == gameState.week).toList();
    final triggered = allScenarios.where((s) =>
        s.triggeredBy != null && triggeredScenarioIds.contains(s.id)).toList();
    
    final combined = {...weekScenarios, ...triggered}.toList();
    combined.sort((a, b) => (b.urgent ? 1 : 0) - (a.urgent ? 1 : 0));
    
    setState(() {
      currentScenarios = combined;
      currentScenarioIndex = 0;
      selectedChoice = null;
      showResult = false;
    });
  }

  void _handleConfirm() {
    if (selectedChoice == null || currentScenarios.isEmpty) return;
    
    final scenario = currentScenarios[currentScenarioIndex];
    final choice = scenario.choices[selectedChoice!];
    final consequences = choice.consequences;

    // Apply consequences
    final newCash = gameState.cash + consequences.cash;
    final newRep = (gameState.reputation + consequences.reputation).clamp(0, 100);
    final newMorale = (gameState.morale + consequences.morale).clamp(0, 100);

    // Haptic feedback
    if (consequences.cash < -10000 || consequences.reputation < -15 || consequences.morale < -15) {
      HapticFeedback.heavyImpact();
    } else if (consequences.cash > 5000 || consequences.reputation > 10 || consequences.morale > 10) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }

    // Track triggered scenarios
    if (choice.triggers != null) {
      triggeredScenarioIds.addAll(choice.triggers!);
    }

    // Update history
    final historyEntry = DecisionHistory(
      week: gameState.week,
      scenarioId: scenario.id,
      choiceIndex: selectedChoice!,
      consequences: consequences,
    );

    // Update state
    final newState = gameState.copyWith(
      cash: newCash,
      reputation: newRep,
      morale: newMorale,
      isAlive: newCash > 0 && newRep > 0 && newMorale > 0,
      history: [...gameState.history, historyEntry],
    );

    setState(() {
      gameState = newState;
      showResult = true;
    });

    // If dead, navigate to result after delay
    if (newState.deathReason != null) {
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/simulation-result',
            arguments: {
              'businessSetup': businessSetup,
              'finalState': newState,
              'deathReason': newState.deathReason,
            },
          );
        }
      });
    }
  }

  void _handleNext() {
    HapticFeedback.lightImpact();
    
    if (currentScenarioIndex + 1 < currentScenarios.length) {
      // More scenarios this week
      setState(() {
        currentScenarioIndex++;
        selectedChoice = null;
        showResult = false;
      });
    } else if (gameState.week < maxWeeks) {
      // Next week
      setState(() {
        gameState = gameState.copyWith(week: gameState.week + 1);
      });
      _loadWeekScenarios();
    } else {
      // Survived all weeks!
      Navigator.pushReplacementNamed(
        context,
        '/simulation-result',
        arguments: {
          'businessSetup': businessSetup,
          'finalState': gameState,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentScenarios.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.purple),
              const SizedBox(height: AppSpacing.md),
              Text('Loading week ${gameState.week}...', style: TextStyle(color: AppColors.textMid)),
            ],
          ),
        ),
      );
    }

    final scenario = currentScenarios[currentScenarioIndex];
    final choice = selectedChoice != null ? scenario.choices[selectedChoice!] : null;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            // Header Stats
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  WeekBadge(currentWeek: gameState.week, totalWeeks: maxWeeks),
                  const SizedBox(height: AppSpacing.sm),
                  StatsBar(
                    cash: gameState.cash,
                    reputation: gameState.reputation,
                    morale: gameState.morale,
                  ),
                ],
              ),
            ),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ProgressBar(progress: gameState.week / maxWeeks),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scenario Card
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
                              if (scenario.urgent)
                                ModuleTag(moduleName: 'URGENT', isUrgent: true)
                              else
                                ModuleTag(moduleName: scenario.module.displayName),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            scenario.situation,
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

                    // Choices
                    ...List.generate(scenario.choices.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ChoiceButton(
                          index: index,
                          text: scenario.choices[index].text,
                          isSelected: selectedChoice == index,
                          isConfirmed: showResult && selectedChoice == index,
                          isDisabled: showResult,
                          onTap: () {
                            setState(() => selectedChoice = index);
                          },
                        ),
                      );
                    }),

                    // Result
                    if (showResult && choice != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Changes
                            Wrap(
                              spacing: AppSpacing.xs,
                              runSpacing: AppSpacing.xs,
                              children: [
                                if (choice.consequences.cash != 0)
                                  ChangeTag(
                                    text: '${choice.consequences.cash > 0 ? '+' : ''}฿${(choice.consequences.cash / 1000).toStringAsFixed(0)}K',
                                    isPositive: choice.consequences.cash > 0,
                                  ),
                                if (choice.consequences.reputation != 0)
                                  ChangeTag(
                                    text: 'Rep ${choice.consequences.reputation > 0 ? '+' : ''}${choice.consequences.reputation}',
                                    isPositive: choice.consequences.reputation > 0,
                                  ),
                                if (choice.consequences.morale != 0)
                                  ChangeTag(
                                    text: 'Morale ${choice.consequences.morale > 0 ? '+' : ''}${choice.consequences.morale}',
                                    isPositive: choice.consequences.morale > 0,
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              choice.consequences.message,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textMid,
                                height: 1.5,
                              ),
                            ),
                            if (choice.triggers != null && choice.triggers!.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.md),
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                  border: Border.all(color: AppColors.warning),
                                ),
                                child: Text(
                                  '⚡ This decision will have consequences later...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.warning,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                            if (!gameState.isAlive) ...[
                              const SizedBox(height: AppSpacing.lg),
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                decoration: BoxDecoration(
                                  color: AppColors.danger.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                                  border: Border.all(color: AppColors.danger),
                                ),
                                child: Column(
                                  children: [
                                    const Text('💀', style: TextStyle(fontSize: 40)),
                                    const SizedBox(height: AppSpacing.sm),
                                    const Text(
                                      'Your business failed.',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.danger,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
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
              child: !showResult
                  ? AppPrimaryButton(
                      text: selectedChoice == null ? 'Select a choice' : 'Confirm Decision',
                      onPressed: selectedChoice != null ? _handleConfirm : null,
                    )
                  : gameState.isAlive
                      ? AppSuccessButton(
                          text: currentScenarioIndex + 1 < currentScenarios.length
                              ? 'Next Decision →'
                              : gameState.week < maxWeeks
                                  ? 'Continue to Week ${gameState.week + 1} →'
                                  : 'See Results →',
                          onPressed: _handleNext,
                        )
                      : Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Text(
                            'Loading results...',
                            style: TextStyle(color: AppColors.textDim),
                            textAlign: TextAlign.center,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
