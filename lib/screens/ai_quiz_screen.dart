import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../constants/theme.dart';
import '../widgets/app_button.dart';
import '../widgets/choice_button.dart';
import '../widgets/stats_bar.dart';
import '../models/simulation.dart';
import '../models/module.dart';
import '../data/modules_data.dart';

class AIQuizScreen extends StatefulWidget {
  final BusinessSetup businessSetup;
  final List<String> completedModules;
  
  const AIQuizScreen({
    super.key,
    required this.businessSetup,
    required this.completedModules,
  });

  @override
  State<AIQuizScreen> createState() => _AIQuizScreenState();
}

class _AIQuizScreenState extends State<AIQuizScreen> {
  late BusinessSetup businessSetup;
  late List<ModuleId> completedModules;
  late List<_QuizQuestion> questions;
  
  int currentIndex = 0;
  int? selectedChoice;
  bool? isAnswerRevealed;
  int correctCount = 0;

  @override
  void initState() {
    super.initState();
    businessSetup = widget.businessSetup;
    completedModules = widget.completedModules.map((e) {
      return ModuleId.values.firstWhere(
        (m) => m.name == e,
        orElse: () => ModuleId.finance,
      );
    }).toList();
    questions = _generateQuestions();
  }

  List<_QuizQuestion> _generateQuestions() {
    final allQuestions = <_QuizQuestion>[];
    final random = Random();

    // Generate questions from completed modules
    for (final moduleId in completedModules) {
      final module = getModuleById(moduleId);
      if (module == null) continue;

      for (final flashcard in module.flashcards) {
        // Create a question from flashcard
        final wrongAnswers = _generateWrongAnswers(flashcard.back, module);
        final choices = [flashcard.back, ...wrongAnswers]..shuffle(random);
        final correctIndex = choices.indexOf(flashcard.back);

        allQuestions.add(_QuizQuestion(
          question: flashcard.front,
          choices: choices,
          correctIndex: correctIndex,
          module: module.name,
        ));
      }
    }

    // Shuffle and take 12 questions
    allQuestions.shuffle(random);
    return allQuestions.take(12).toList();
  }

  List<String> _generateWrongAnswers(String correctAnswer, Module module) {
    // Get other flashcard answers from same module as wrong answers
    final wrongAnswers = module.flashcards
        .where((f) => f.back != correctAnswer)
        .map((f) => f.back)
        .take(3)
        .toList();

    // If not enough, add generic wrong answers
    while (wrongAnswers.length < 3) {
      wrongAnswers.add('This is not the correct answer');
    }

    return wrongAnswers.take(3).toList();
  }

  void _handleAnswer() {
    if (selectedChoice == null) return;
    
    final isCorrect = selectedChoice == questions[currentIndex].correctIndex;
    if (isCorrect) {
      correctCount++;
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }

    setState(() {
      isAnswerRevealed = isCorrect;
    });
  }

  void _handleNext() {
    if (currentIndex + 1 < questions.length) {
      setState(() {
        currentIndex++;
        selectedChoice = null;
        isAnswerRevealed = null;
      });
    } else {
      // Quiz complete
      final passed = correctCount >= 8;
      Navigator.pushReplacementNamed(
        context,
        '/gateway-result',
        arguments: {
          'passed': passed,
          'score': correctCount,
          'total': questions.length,
          'businessSetup': businessSetup,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Center(child: CircularProgressIndicator(color: AppColors.purple)),
      );
    }

    final question = questions[currentIndex];
    final progress = (currentIndex + 1) / questions.length;

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
                      child: const Icon(Icons.close, color: AppColors.textBright, size: 20),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🤖 AI Quiz', style: AppTextStyles.headline3),
                        const SizedBox(height: 2),
                        Text(
                          'Question ${currentIndex + 1} of ${questions.length}',
                          style: TextStyle(fontSize: 12, color: AppColors.textMid),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    ),
                    child: Text(
                      '$correctCount correct',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ProgressBar(progress: progress),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Module tag
                    ModuleTag(moduleName: question.module),
                    
                    const SizedBox(height: AppSpacing.md),

                    // Question
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.bgDarker,
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBright,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Choices
                    ...List.generate(question.choices.length, (index) {
                      bool? isCorrect;
                      if (isAnswerRevealed != null) {
                        if (index == question.correctIndex) {
                          isCorrect = true;
                        } else if (selectedChoice == index) {
                          isCorrect = false;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: QuizChoiceButton(
                          index: index,
                          text: question.choices[index],
                          isSelected: selectedChoice == index,
                          isCorrect: isCorrect,
                          isDisabled: isAnswerRevealed != null,
                          onTap: () {
                            setState(() => selectedChoice = index);
                          },
                        ),
                      );
                    }),

                    // Pass requirement hint
                    if (currentIndex >= 7 && correctCount < 8) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Text('⚠️', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                'You need ${8 - correctCount} more correct answers to pass',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.warning,
                                ),
                              ),
                            ),
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
              child: isAnswerRevealed == null
                  ? AppPrimaryButton(
                      text: selectedChoice == null ? 'Select an answer' : 'Submit Answer',
                      onPressed: selectedChoice != null ? _handleAnswer : null,
                    )
                  : AppSuccessButton(
                      text: currentIndex + 1 < questions.length
                          ? 'Next Question →'
                          : 'See Results →',
                      onPressed: _handleNext,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizQuestion {
  final String question;
  final List<String> choices;
  final int correctIndex;
  final String module;

  _QuizQuestion({
    required this.question,
    required this.choices,
    required this.correctIndex,
    required this.module,
  });
}
