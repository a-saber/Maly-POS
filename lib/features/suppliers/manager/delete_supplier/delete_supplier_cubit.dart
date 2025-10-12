import 'package:flutter_bloc/flutter_bloc.dart';
import 'delete_supplier_state.dart';
import '../../data/repo/suppliers_repo.dart';
import '../../data/models/supplier_model.dart';

class DeleteSupplierCubit extends Cubit<DeleteSupplierState> {
  final SuppliersRepo suppliersRepo;

  DeleteSupplierCubit(this.suppliersRepo) : super(DeleteSupplierInitial());
  static DeleteSupplierCubit get(context) => BlocProvider.of(context);

  Future<void> deleteSupplier({
    required SupplierModel supplier,
  }) async {
    emit(DeleteSupplierLoading());
    final result = await suppliersRepo.deleteSupplier(
      supplier: supplier,
    );
    result.fold(
      (error) => emit(DeleteSupplierError(error)),
      (data) => emit(
        DeleteSupplierSuccess(data),
      ),
    );
  }
}
