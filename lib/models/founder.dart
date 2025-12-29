/// Founder Decision Model
class FounderDecision {
  final String situation;
  final List<String> choices;
  final int correctIndex;
  final String whatFounderDid;
  final String whyItWorked;
  final String outcome;

  const FounderDecision({
    required this.situation,
    required this.choices,
    required this.correctIndex,
    required this.whatFounderDid,
    required this.whyItWorked,
    required this.outcome,
  });
}

/// Founder Model
class Founder {
  final String id;
  final String name;
  final String company;
  final String photo;
  final String startedWith;
  final String nowWorth;
  final String background;
  final String setup;
  final List<FounderDecision> decisions;

  const Founder({
    required this.id,
    required this.name,
    required this.company,
    required this.photo,
    required this.startedWith,
    required this.nowWorth,
    required this.background,
    required this.setup,
    required this.decisions,
  });
}

/// Quiz State for tracking user progress
class QuizState {
  final Founder? currentFounder;
  final int currentDecisionIndex;
  final List<bool> results;
  final bool isComplete;

  const QuizState({
    this.currentFounder,
    this.currentDecisionIndex = 0,
    this.results = const [],
    this.isComplete = false,
  });

  QuizState copyWith({
    Founder? currentFounder,
    int? currentDecisionIndex,
    List<bool>? results,
    bool? isComplete,
  }) {
    return QuizState(
      currentFounder: currentFounder ?? this.currentFounder,
      currentDecisionIndex: currentDecisionIndex ?? this.currentDecisionIndex,
      results: results ?? this.results,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
