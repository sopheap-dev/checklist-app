extension ChecklistStatsX on Map<String, int> {
  int get totalItems => this['total'] ?? 0;
  int get completedItems => this['completed'] ?? 0;
  int get incompleteItems => this['incomplete'] ?? 0;

  int get lowPriority => this['low'] ?? 0;
  int get mediumPriority => this['medium'] ?? 0;
  int get highPriority => this['high'] ?? 0;
  int get urgentPriority => this['urgent'] ?? 0;
}
