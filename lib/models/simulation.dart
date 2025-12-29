import 'module.dart';

/// Business Type Enum
enum BusinessType {
  coffee,
  restaurant,
  ecommerce,
  service,
}

extension BusinessTypeExtension on BusinessType {
  String get displayName {
    switch (this) {
      case BusinessType.coffee:
        return 'Coffee Shop';
      case BusinessType.restaurant:
        return 'Restaurant';
      case BusinessType.ecommerce:
        return 'E-commerce Store';
      case BusinessType.service:
        return 'Service Agency';
    }
  }

  String get icon {
    switch (this) {
      case BusinessType.coffee:
        return '☕';
      case BusinessType.restaurant:
        return '🍽️';
      case BusinessType.ecommerce:
        return '🛒';
      case BusinessType.service:
        return '💼';
    }
  }

  String get staffName {
    switch (this) {
      case BusinessType.coffee:
        return 'barista';
      case BusinessType.restaurant:
        return 'chef';
      case BusinessType.ecommerce:
        return 'fulfillment staff';
      case BusinessType.service:
        return 'account manager';
    }
  }

  String get productName {
    switch (this) {
      case BusinessType.coffee:
        return 'coffee';
      case BusinessType.restaurant:
        return 'food';
      case BusinessType.ecommerce:
        return 'products';
      case BusinessType.service:
        return 'services';
    }
  }

  String get supplyName {
    switch (this) {
      case BusinessType.coffee:
        return 'beans';
      case BusinessType.restaurant:
        return 'ingredients';
      case BusinessType.ecommerce:
        return 'inventory';
      case BusinessType.service:
        return 'tools';
    }
  }
}

/// Business Setup Model
class BusinessSetup {
  final BusinessType type;
  final int budget;
  final String location;

  const BusinessSetup({
    required this.type,
    required this.budget,
    required this.location,
  });
}

/// Consequences Model
class Consequences {
  final int cash;
  final int reputation;
  final int morale;
  final String message;

  const Consequences({
    required this.cash,
    required this.reputation,
    required this.morale,
    required this.message,
  });
}

/// Scenario Choice Model
class ScenarioChoice {
  final String text;
  final Consequences consequences;
  final List<String>? triggers; // IDs of scenarios this choice triggers

  const ScenarioChoice({
    required this.text,
    required this.consequences,
    this.triggers,
  });
}

/// Scenario Model
class Scenario {
  final String id;
  final int week;
  final ModuleId module;
  final bool urgent;
  final String situation;
  final List<ScenarioChoice> choices;
  final String? triggeredBy; // ID of scenario that triggers this

  const Scenario({
    required this.id,
    required this.week,
    required this.module,
    required this.urgent,
    required this.situation,
    required this.choices,
    this.triggeredBy,
  });

  /// Create a copy with adapted text for business type
  Scenario adaptForBusinessType(BusinessType type) {
    if (type == BusinessType.coffee) return this;
    
    return Scenario(
      id: id,
      week: week,
      module: module,
      urgent: urgent,
      situation: situation
          .replaceAll('coffee shop', type.displayName.toLowerCase())
          .replaceAll('barista', type.staffName)
          .replaceAll('coffee', type.productName)
          .replaceAll('beans', type.supplyName),
      choices: choices.map((c) => ScenarioChoice(
        text: c.text
            .replaceAll('coffee shop', type.displayName.toLowerCase())
            .replaceAll('barista', type.staffName)
            .replaceAll('coffee', type.productName)
            .replaceAll('beans', type.supplyName),
        consequences: Consequences(
          cash: c.consequences.cash,
          reputation: c.consequences.reputation,
          morale: c.consequences.morale,
          message: c.consequences.message
              .replaceAll('coffee shop', type.displayName.toLowerCase())
              .replaceAll('barista', type.staffName)
              .replaceAll('coffee', type.productName)
              .replaceAll('beans', type.supplyName),
        ),
        triggers: c.triggers,
      )).toList(),
      triggeredBy: triggeredBy,
    );
  }
}

/// Decision History Entry
class DecisionHistory {
  final int week;
  final String scenarioId;
  final int choiceIndex;
  final Consequences consequences;

  const DecisionHistory({
    required this.week,
    required this.scenarioId,
    required this.choiceIndex,
    required this.consequences,
  });
}

/// Simulation State Model
class SimulationState {
  final int week;
  final int cash;
  final int reputation;
  final int morale;
  final bool isAlive;
  final List<DecisionHistory> history;

  const SimulationState({
    required this.week,
    required this.cash,
    required this.reputation,
    required this.morale,
    required this.isAlive,
    required this.history,
  });

  SimulationState copyWith({
    int? week,
    int? cash,
    int? reputation,
    int? morale,
    bool? isAlive,
    List<DecisionHistory>? history,
  }) {
    return SimulationState(
      week: week ?? this.week,
      cash: cash ?? this.cash,
      reputation: reputation ?? this.reputation,
      morale: morale ?? this.morale,
      isAlive: isAlive ?? this.isAlive,
      history: history ?? this.history,
    );
  }

  /// Check death condition
  String? get deathReason {
    if (cash <= 0) return 'bankruptcy';
    if (reputation <= 0) return 'reputation';
    if (morale <= 0) return 'morale';
    return null;
  }

  /// Factory to create initial state from setup
  factory SimulationState.initial(BusinessSetup setup) {
    return SimulationState(
      week: 1,
      cash: setup.budget,
      reputation: 50,
      morale: 50,
      isAlive: true,
      history: [],
    );
  }
}
