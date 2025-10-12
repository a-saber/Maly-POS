import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/data/repo/taxes_repo.dart';

part 'edit_taxes_state.dart';

class EditTaxesCubit extends Cubit<EditTaxesState> {
  EditTaxesCubit(this.repo, this.tax) : super(EditTaxesInitial()) {
    titleController = TextEditingController(text: tax.title);
    percentageController = TextEditingController(text: tax.percentage);
  }

  static EditTaxesCubit get(context) => BlocProvider.of(context);
  final TaxesRepo repo;
  final TaxesModel tax;

  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController titleController;
  late TextEditingController percentageController;

  Future<void> editTax() async {
    emit(EditTaxesLoading());
    if (formKey.currentState!.validate()) {
      final response = await repo.editTax(
        tax: TaxesModel.createWithoutId(
            title: titleController.text,
            percentage: percentageController.text,
            id: tax.id),
      );
      response.fold(
        (error) => emit(EditTaxesFailing(errMessage: error)),
        (r) => emit(EditTaxesSuccess(
          tax: r,
        )),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(EditTaxesUnValid());
    }
  }

  @override
  Future<void> close() {
    titleController.dispose();
    percentageController.dispose();

    return super.close();
  }
}
