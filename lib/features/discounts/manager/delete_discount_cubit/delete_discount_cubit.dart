import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/data/repo/discounts_repo.dart';

part 'delete_discount_state.dart';

class DeleteDiscountCubit extends Cubit<DeleteDiscountState> {
  DeleteDiscountCubit(this.repo) : super(DeleteDiscountInitial());

  static DeleteDiscountCubit get(context) => BlocProvider.of(context);

  final DiscountsRepo repo;

  Future<void> deleteDiscount({
    required DiscountModel discount,
  }) async {
    emit(DeleteDiscountLoading());
    final response = await repo.deleteDiscount(
      discount: discount,
    );
    response.fold(
      (error) => emit(DeleteDiscountFailing(errMessage: error)),
      (r) => emit(DeleteDiscountSuccess(
        id: r,
      )),
    );
  }
}
