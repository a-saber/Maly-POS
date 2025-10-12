import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/data/repo/taxes_repo.dart';

part 'delete_taxes_state.dart';

class DeleteTaxesCubit extends Cubit<DeleteTaxesState> {
  DeleteTaxesCubit(this.repo) : super(DeleteTaxesInitial());

  static DeleteTaxesCubit get(context) => BlocProvider.of(context);

  final TaxesRepo repo;

  Future<void> deleteTax({
    required TaxesModel tax,
  }) async {
    emit(DeleteTaxesLoading());
    final result = await repo.deleteTax(
      tax: tax,
    );
    result.fold(
        (errMessage) => emit(DeleteTaxesFailing(errMessage: errMessage)),
        (r) => emit(DeleteTaxesSuccess(
              id: r,
            )));
  }
}
