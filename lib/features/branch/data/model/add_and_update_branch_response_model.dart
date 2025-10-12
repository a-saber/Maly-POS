import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';

class AddAndUpdateBranchResponseModel {
  final bool? status;
  final String? message;
  final BrancheModel? branch;

  AddAndUpdateBranchResponseModel(
      {required this.status, required this.message, required this.branch});

  factory AddAndUpdateBranchResponseModel.fromJson(Map<String, dynamic> json) {
    return AddAndUpdateBranchResponseModel(
        status: json[ApiKeys.status],
        message: json[ApiKeys.message],
        branch: json[ApiKeys.branch] != null
            ? BrancheModel.fromJson(json[ApiKeys.branch])
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.status] = status;
    data[ApiKeys.message] = message;
    data[ApiKeys.branch] = branch;
    return data;
  }
}
