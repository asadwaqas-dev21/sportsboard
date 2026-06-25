/// Sport entity — represents a sport category.
class Sport {
  final String id;
  final String name;
  final String type;
  final String iconName;
  final bool isActive;
  final int order;

  const Sport({
    required this.id,
    required this.name,
    required this.type,
    this.iconName = "",
    this.isActive = true,
    this.order = 0,
  });

  Sport copyWith({
    String? id,
    String? name,
    String? type,
    String? iconName,
    bool? isActive,
    int? order,
  }) {
    return Sport(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      iconName: iconName ?? this.iconName,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sport && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
