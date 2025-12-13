class PaymentMethodData {
  int? id;
  String? name;
  int? isActive;
  int? requiresReference;
  int? isNearpay;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  PaymentMethodData({
    this.id,
    this.name,
    this.isActive,
    this.requiresReference,
    this.isNearpay,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  PaymentMethodData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
    requiresReference = json['requires_reference'];
    isNearpay = json['is_nearpay'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['is_active'] = isActive;
    data['requires_reference'] = requiresReference;
    data['is_nearpay'] = isNearpay;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  int? page;
  bool? active;

  Links({this.url, this.label, this.page, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    page = json['page'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['url'] = url;
    data['label'] = label;
    data['page'] = page;
    data['active'] = active;
    return data;
  }
}
