import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages, unnecessary_import
import 'package:meta/meta.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/data/repo/units_repo.dart';

part 'edit_unit_state.dart';

class EditUnitCubit extends Cubit<EditUnitState> {
  EditUnitCubit(this.repo, this.unit) : super(EditUnitInitial()) {
    nameController = TextEditingController(text: unit.name);
  }

  static EditUnitCubit get(context) => BlocProvider.of(context);

  final UnitsRepo repo;
  final UnitModel unit;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController nameController;

  Future<void> editUnit() async {
    emit(EditUnitLoading());

    if (formKey.currentState!.validate()) {
      var reponse = await repo.editUnit(
        newUnit:
            UnitModel.createWithoutId(name: nameController.text, id: unit.id),
      );

      reponse.fold(
        (error) => emit(EditUnitFailing(errMessage: error)),
        (r) => emit(EditUnitSuccess(
          unit: r,
        )),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(EditUnitUnVaild());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();

    return super.close();
  }

  @override
  void emit(EditUnitState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
