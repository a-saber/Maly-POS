import 'package:pos_app/core/constant/constant.dart';

class PermissionModel {
  int? id;
  String? name;
  String? description;
  late List<PermissionItemModel> items;

  factory PermissionModel.from(PermissionModel source) {
    return PermissionModel(
        id: source.id, name: source.name, description: source.description)
      ..items = source.items.map((e) => e.copy()).toList();
  }

  PermissionModel.asAdmin() {
    id = 1;
    name = 'Admin';
    description = 'Admin permission';
    items = List.from(AppConstant.allPermissions(asAdmin: true));
  }
  PermissionModel({this.id, this.name, this.description}) {
    items = List.from(AppConstant.allPermissions());
  }
}

class PermissionItemModel {
  // int? id;
  String? name;
  bool isSelected;

  PermissionItemModel copy() =>
      PermissionItemModel(name: name, isSelected: isSelected);

  PermissionItemModel({required this.name, this.isSelected = false});
}
