import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages, unnecessary_import
import 'package:meta/meta.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/data/repo/units_repo.dart';

part 'add_unit_state.dart';

class AddUnitCubit extends Cubit<AddUnitState> {
  AddUnitCubit(this.repo) : super(AddUnitInitial());
  static AddUnitCubit get(context) => BlocProvider.of(context);
  final UnitsRepo repo;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  TextEditingController nameController = TextEditingController();

  Future<void> addUnit() async {
    emit(AddUnitLoading());

    if (formKey.currentState!.validate()) {
      var reponse = await repo.addUnit(
        unit: UnitModel.createWithoutId(name: nameController.text),
      );

      reponse.fold(
        (error) => emit(AddUnitFailing(errMessage: error)),
        (r) => emit(AddUnitSuccess(
          unit: r,
        )),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(AddUnitUnVaild());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }

  @override
  void emit(AddUnitState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
