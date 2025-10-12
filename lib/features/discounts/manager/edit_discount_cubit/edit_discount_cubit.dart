import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_type.dart';
import 'package:pos_app/features/discounts/data/repo/discounts_repo.dart';

part 'edit_discount_state.dart';

class EditDiscountCubit extends Cubit<EditDiscountState> {
  EditDiscountCubit(this.repo, this.discount) : super(EditDiscountInitial()) {
    titleController = TextEditingController(text: discount.title);
    discountType = discount.type ?? DiscountType.fixed;
    value = TextEditingController(text: discount.value);
  }

  static EditDiscountCubit get(context) => BlocProvider.of(context);
  final DiscountsRepo repo;
  final DiscountModel discount;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController titleController;
  late DiscountType discountType;
  late TextEditingController value;

  Future<void> editDiscount() async {
    emit(EditDiscountLoading());
    if (formKey.currentState!.validate()) {
      final response = await repo.editDiscount(
        discount: DiscountModel.fromJsonWithoutId(
          id: discount.id,
          title: titleController.text,
          type: discountType,
          value: value.text,
        ),
      );
      response.fold(
        (error) => emit(EditDiscountFailing(errMessage: error)),
        (r) => emit(EditDiscountSuccess(
          discount: r,
        )),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(EditDiscountUnValid());
    }
  }

  void onChangeDiscountType(DiscountType? discountType) {
    if (discountType == null) return;
    this.discountType = discountType;
    emit(EditDiscountTypeChanged());
  }

  @override
  Future<void> close() {
    titleController.dispose();
    // descriptionController.dispose();
    value.dispose();
    return super.close();
  }
}
