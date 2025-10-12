import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_type.dart';
import 'package:pos_app/features/discounts/data/repo/discounts_repo.dart';

part 'add_discount_state.dart';

class AddDiscountCubit extends Cubit<AddDiscountState> {
  AddDiscountCubit(this.repo) : super(AddDiscountInitial());

  static AddDiscountCubit get(context) => BlocProvider.of(context);

  final DiscountsRepo repo;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  TextEditingController titleController = TextEditingController();
  DiscountType? discountType;
  TextEditingController value = TextEditingController();

  Future<void> addDiscount() async {
    emit(AddDiscountLoading());
    if (formKey.currentState!.validate()) {
      final response = await repo.addDiscount(
        discount: DiscountModel.fromJsonWithoutId(
            title: titleController.text,
            type: discountType ?? DiscountType.fixed,
            value: value.text),
      );
      response.fold(
        (error) => emit(AddDiscountFailing(errMessage: error)),
        (r) => emit(AddDiscountSuccess(
          discount: r,
        )),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(AddDiscountUnValid());
    }
  }

  void onChangeDiscountType(DiscountType? discountType) {
    if (discountType == null) return;
    this.discountType = discountType;
    emit(AddDiscountTypeChanged());
  }

  @override
  Future<void> close() {
    titleController.dispose();
    // descriptionController.dispose();
    value.dispose();
    return super.close();
  }
}
