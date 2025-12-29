/// Module ID Enum
enum ModuleId {
  finance,
  marketing,
  hr,
  operations,
  legal,
  sales,
  product,
  partnerships,
  customerService,
  facilities,
  technology,
  strategy,
}

/// Flashcard Model
class Flashcard {
  final String front;
  final String back;
  final String? example;

  const Flashcard({
    required this.front,
    required this.back,
    this.example,
  });
}

/// Learning Module Model
class Module {
  final ModuleId id;
  final String name;
  final String icon;
  final List<Flashcard> flashcards;

  const Module({
    required this.id,
    required this.name,
    required this.icon,
    required this.flashcards,
  });
}

/// Extension to get display name from ModuleId
extension ModuleIdExtension on ModuleId {
  String get displayName {
    switch (this) {
      case ModuleId.finance:
        return 'Finance';
      case ModuleId.marketing:
        return 'Marketing';
      case ModuleId.hr:
        return 'HR & Team';
      case ModuleId.operations:
        return 'Operations';
      case ModuleId.legal:
        return 'Legal';
      case ModuleId.sales:
        return 'Sales';
      case ModuleId.product:
        return 'Product';
      case ModuleId.partnerships:
        return 'Partnerships';
      case ModuleId.customerService:
        return 'Customer Service';
      case ModuleId.facilities:
        return 'Facilities';
      case ModuleId.technology:
        return 'Technology';
      case ModuleId.strategy:
        return 'Strategy';
    }
  }

  String get icon {
    switch (this) {
      case ModuleId.finance:
        return '💰';
      case ModuleId.marketing:
        return '📢';
      case ModuleId.hr:
        return '👥';
      case ModuleId.operations:
        return '📦';
      case ModuleId.legal:
        return '📄';
      case ModuleId.sales:
        return '🛒';
      case ModuleId.product:
        return '🛠';
      case ModuleId.partnerships:
        return '🤝';
      case ModuleId.customerService:
        return '💬';
      case ModuleId.facilities:
        return '🏢';
      case ModuleId.technology:
        return '💻';
      case ModuleId.strategy:
        return '📊';
    }
  }
}
