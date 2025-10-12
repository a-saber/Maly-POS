import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/suppliers/data/models/supplier_model.dart';

abstract class AddSupplierState {}

class AddSupplierInitial extends AddSupplierState {}

class AddSupplierUnValidate extends AddSupplierState {}

class AddSupplierLoading extends AddSupplierState {}

class AddSupplierSuccess extends AddSupplierState {
  final SupplierModel supplier;
  AddSupplierSuccess({required this.supplier});
}

class AddSupplierError extends AddSupplierState {
  final ApiResponse error;
  AddSupplierError(this.error);
}
