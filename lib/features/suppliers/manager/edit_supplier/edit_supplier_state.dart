import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/suppliers/data/models/supplier_model.dart';

abstract class EditSupplierState {}

class EditSupplierInitial extends EditSupplierState {}

class EditSupplierLoading extends EditSupplierState {}

class EditSupplierSuccess extends EditSupplierState {
  final SupplierModel supplier;
  EditSupplierSuccess({required this.supplier});
}

class EditSupplierError extends EditSupplierState {
  final ApiResponse error;
  EditSupplierError(this.error);
}
