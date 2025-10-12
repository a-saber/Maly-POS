import 'package:pos_app/core/api/api_response.dart';

abstract class DeleteSupplierState {}

class DeleteSupplierInitial extends DeleteSupplierState {}

class DeleteSupplierLoading extends DeleteSupplierState {}

class DeleteSupplierSuccess extends DeleteSupplierState {
  final int id;
  DeleteSupplierSuccess(this.id);
}

class DeleteSupplierError extends DeleteSupplierState {
  final ApiResponse error;
  DeleteSupplierError(this.error);
}
