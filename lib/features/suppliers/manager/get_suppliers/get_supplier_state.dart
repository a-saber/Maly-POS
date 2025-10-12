import 'package:pos_app/core/api/api_response.dart';

abstract class GetSuppliersState {}

class GetSuppliersInitial extends GetSuppliersState {}

class GetSuppliersLoading extends GetSuppliersState {}

class GetSuppliersSuccess extends GetSuppliersState {}

class GetSuppliersError extends GetSuppliersState {
  final ApiResponse error;
  GetSuppliersError(this.error);
}

class GetSuppliersErrorPagination extends GetSuppliersState {
  final ApiResponse errMessage;
  GetSuppliersErrorPagination(this.errMessage);
}
