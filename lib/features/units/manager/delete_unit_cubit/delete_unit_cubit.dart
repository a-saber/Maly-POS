import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/data/repo/units_repo.dart';

part 'delete_unit_state.dart';

class DeleteUnitCubit extends Cubit<DeleteUnitState> {
  DeleteUnitCubit(this.repo) : super(DeleteUnitInitial());

  static DeleteUnitCubit get(context) => BlocProvider.of(context);

  final UnitsRepo repo;

  Future<void> deleteUnit({
    required UnitModel unit,
  }) async {
    emit(DeleteUnitLoading());
    final result = await repo.deleteUnit(
      unit: unit,
    );
    result.fold(
      (errMessage) => emit(DeleteUnitFailing(errMessage: errMessage)),
      (r) => emit(DeleteUnitSuccess(
        id: r,
      )),
    );
  }

  @override
  void emit(DeleteUnitState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
