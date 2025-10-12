import 'package:pos_app/core/api/api_keys.dart';

class LinksModel {
  final String? url;
  final String? label;
  final bool? active;

  LinksModel({required this.url, required this.label, required this.active});

  factory LinksModel.fromJson(Map<String, dynamic> json) {
    return LinksModel(
      url: json[ApiKeys.url],
      label: json[ApiKeys.label],
      active: json[ApiKeys.active],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.url] = url;
    data[ApiKeys.label] = label;
    data[ApiKeys.active] = active;
    return data;
  }
}
