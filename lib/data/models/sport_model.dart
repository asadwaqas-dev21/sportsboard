import "package:cloud_firestore/cloud_firestore.dart";
import "package:sportsboard/domain/entities/sport.dart";

/// Firestore-aware model for Sport entity.
class SportModel extends Sport {
  const SportModel({
    required super.id,
    required super.name,
    required super.type,
    super.iconName,
    super.isActive,
    super.order,
  });

  factory SportModel.fromEntity(Sport sport) {
    return SportModel(
      id: sport.id,
      name: sport.name,
      type: sport.type,
      iconName: sport.iconName,
      isActive: sport.isActive,
      order: sport.order,
    );
  }

  factory SportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return SportModel(
      id: doc.id,
      name: data["name"] as String? ?? "",
      type: data["type"] as String? ?? "",
      iconName: data["iconName"] as String? ?? "",
      isActive: data["isActive"] as bool? ?? true,
      order: data["order"] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "type": type,
      "iconName": iconName,
      "isActive": isActive,
      "order": order,
    };
  }
}
