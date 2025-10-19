class UpdatePrinters {
  bool? status;
  String? message;
  Printer? printer;

  UpdatePrinters({this.status, this.message, this.printer});

  UpdatePrinters.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    printer =
        json['printer'] != null ? new Printer.fromJson(json['printer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.printer != null) {
      data['printer'] = this.printer!.toJson();
    }
    return data;
  }
}

class Printer {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? printerName;
  String? printerType;
  String? communicationType;
  List<Categories>? categories;

  Printer(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.printerName,
      this.printerType,
      this.communicationType,
      this.categories});

  Printer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    printerName = json['printer_name'];
    printerType = json['printer_type'];
    communicationType = json['communication_type'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['printer_name'] = this.printerName;
    data['printer_type'] = this.printerType;
    data['communication_type'] = this.communicationType;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  Null? description;
  String? imagePath;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;
  Pivot? pivot;

  Categories(
      {this.id,
      this.name,
      this.description,
      this.imagePath,
      this.createdAt,
      this.updatedAt,
      this.imageUrl,
      this.pivot});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image_path'] = this.imagePath;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? printerId;
  int? categoryId;

  Pivot({this.printerId, this.categoryId});

  Pivot.fromJson(Map<String, dynamic> json) {
    printerId = json['printer_id'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['printer_id'] = this.printerId;
    data['category_id'] = this.categoryId;
    return data;
  }
}
