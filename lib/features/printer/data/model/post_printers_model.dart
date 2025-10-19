class AddPrinters {
  bool? status;
  String? message;
  Printer? printer;

  AddPrinters({this.status, this.message, this.printer});

  AddPrinters.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    printer = json['printer'] != null ? Printer.fromJson(json['printer']) : null;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (printer != null) {
      data['printer_name'] = printer!.printerName?.trim();
      data['printer_type'] = printer!.printerType?.trim();

   
      if (printer!.communicationType != null) {
        data['communication_type'] =
            printer!.communicationType!.toLowerCase().trim();
      }

      
      if (printer!.categories != null && printer!.categories!.isNotEmpty) {
      data['categories'] = printer!.categories;
    } else {
      data['categories'] = [];
    }
  }

    return data;
  }
}

class Printer {
  String? printerType;
  String? printerName;
  String? communicationType;
  String? updatedAt;
  String? createdAt;
  int? id;
  dynamic categories;

  Printer({
    this.printerType,
    this.printerName,
    this.communicationType,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.categories,
  });

  Printer.fromJson(Map<String, dynamic> json) {
    printerType = json['printer_type'];
    printerName = json['printer_name'];
    communicationType = json['communication_type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];

    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['printer_type'] = printerType;
    data['printer_name'] = printerName;
    data['communication_type'] = communicationType;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? description;
  String? imagePath;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;
  Pivot? pivot;

  Categories({
    this.id,
    this.name,
    this.description,
    this.imagePath,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.pivot,
  });

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image_path'] = imagePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] = imageUrl;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['printer_id'] = printerId;
    data['category_id'] = categoryId;
    return data;
  }
}
