class EnvironmentStateItem {
  final String id;
  final String? description;
  final bool active;

  EnvironmentStateItem({
    required this.id,
    required this.active,
    this.description,
  });
}
