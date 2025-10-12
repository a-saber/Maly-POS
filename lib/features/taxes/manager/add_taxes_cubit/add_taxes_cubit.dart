import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/data/repo/taxes_repo.dart';

part 'add_taxes_state.dart';

class AddTaxesCubit extends Cubit<AddTaxesState> {
  AddTaxesCubit(this.repo) : super(AddTaxesInitial());

  static AddTaxesCubit get(context) => BlocProvider.of(context);
  final TaxesRepo repo;
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController percentageConroller = TextEditingController();

  Future<void> addTax() async {
    emit(AddTaxesLoading());
    if (formKey.currentState!.validate()) {
      final response = await repo.addTax(
        tax: TaxesModel.createWithoutId(
          title: titleController.text,
          percentage: percentageConroller.text,
        ),
      );
      response.fold(
        (error) => emit(AddTaxesFailing(errMessage: error)),
        (r) => emit(AddTaxesSuccess(
          taxes: r,
        )),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(AddTaxesUnValid());
    }
  }

  @override
  Future<void> close() {
    titleController.dispose();
    percentageConroller.dispose();

    return super.close();
  }
}
