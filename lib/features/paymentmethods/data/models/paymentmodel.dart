class AddPaymentMethodModel {
  final int id;
  final String name;
  final int isActive;
  final int requiresReference;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  AddPaymentMethodModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.requiresReference,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddPaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return AddPaymentMethodModel(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
      requiresReference: json['requires_reference'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
      'requires_reference': requiresReference,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
