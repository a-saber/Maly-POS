import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/sales/data/repo/sales_repo.dart';

part 'return_sales_state.dart';

class ReturnSalesCubit extends Cubit<ReturnSalesState> {
  ReturnSalesCubit(this.repo) : super(ReturnSalesInitial());

  static ReturnSalesCubit get(context) => BlocProvider.of(context);

  final SalesRepo repo;
  TextEditingController reasonController = TextEditingController();

  void returnSales({
    required int id,
  }) async {
    emit(ReturnSalesLoading());
    var response =
        await repo.returnSales(id: id, reason: reasonController.text);
    response.fold((l) => emit(ReturnSalesFailing(message: l)),
        (r) => emit(ReturnSalesSuccess()));
  }

  @override
  Future<void> close() {
    reasonController.dispose();
    return super.close();
  }
}
