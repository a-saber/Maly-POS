import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/features/paymentmethods/data/models/paymentmodel.dart';
import 'package:pos_app/features/paymentmethods/data/repo/repo.dart';
import 'package:pos_app/features/paymentmethods/manager/state/paymentsstate.dart';

import '../../../../core/helper/my_service_locator.dart';
import '../../../selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  final PaymentMethodsRepo repo;
  List<PaymentMethodSalesModel> paymentMethods = [];
  bool isLoadingMore = false;

  PaymentMethodsCubit(this.repo) : super(PaymentMethodsInitial());

  static PaymentMethodsCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> getPaymentMethods({
    bool isFresh = false,
    String? query,
  }) async {
    if (isFresh) {
      emit(PaymentMethodsLoading());
      paymentMethods = [];
    } else if (paymentMethods.isNotEmpty) {
      emit(PaymentMethodsLoadingMore());
      isLoadingMore = true;
    } else {
      emit(PaymentMethodsLoading());
    }

    final result = await repo.getPaymentMethods(
      isFresh: isFresh,
      query: query,
    );

    result.fold(
      (error) {
        isLoadingMore = false;
        emit(PaymentMethodsFailure(error.message ?? 'حدث خطأ'));
      },
      (data) {
        if (isFresh) {
          paymentMethods = data;
        } else {
          paymentMethods.addAll(data);
        }
        isLoadingMore = false;
        emit(PaymentMethodsSuccess(paymentMethods));
      },
    );
  }

  Future<void> addPaymentMethod({
    required String name,
    required int isActive,
    required int requiresReference,
    required int isNearpay,
  }) async {
    emit(PaymentMethodsLoading());

    final result = await repo.addPaymentMethod(
      name: name,
      isActive: isActive,
      requiresReference: requiresReference,
      isNearpay: isNearpay,
    );

    result.fold(
      (error) => emit(PaymentMethodsFailure(error.message ?? 'حدث خطأ')),
      (success) {
        emit(AddPaymentMethodSuccess());

        addPaymentMethodLocal(PaymentMethodSalesModel.fromData(success));
      //  getPaymentMethods(isFresh: true);
        // MyServiceLocator.getSingleton<SellingPointProductCubit>().addPaymentMethod(PaymentMethodSalesModel.fromData(success));
        MyServiceLocator.getSingleton<SellingPointProductCubit>().loadPaymentMethods();

      },
    );
  }

  Future<void> updatePaymentMethod({
    required PaymentMethodSalesModel paymentMethod,
  }) async {
    emit(PaymentMethodsLoading());

    final result = await repo.updatePaymentMethod(
      paymentMethod: paymentMethod,
    );

    result.fold(
      (error) => emit(PaymentMethodsFailure(error.message ?? 'حدث خطأ')),
      (success) {
        emit(UpdatePaymentMethodSuccess());

        updatePaymentMethodLocal(PaymentMethodSalesModel.fromData(success));
      //  getPaymentMethods(isFresh: true);
        // MyServiceLocator.getSingleton<SellingPointProductCubit>().updatePaymentMethod(PaymentMethodSalesModel.fromData(success));
        MyServiceLocator.getSingleton<SellingPointProductCubit>().loadPaymentMethods();
      },
    );
  }
  void addPaymentMethodLocal(PaymentMethodSalesModel value){
    if(paymentMethods.isNotEmpty) paymentMethods.add(value);
    emit(PaymentMethodsUpdateLocal());
  }
  void updatePaymentMethodLocal(PaymentMethodSalesModel value){
    final index = paymentMethods.indexWhere((element) => element.id == value.id);
    if(index != -1){
      paymentMethods[index] = value;
    }
    emit(PaymentMethodsUpdateLocal());
  }
  void deletePaymentMethodLocal(int id){
    final index = paymentMethods.indexWhere((element) => element.id == id);
    if(index != -1){
      paymentMethods.removeAt(index);
    }
    emit(PaymentMethodsUpdateLocal());
  }

  Future<void> deletePaymentMethod(int id) async {
    emit(PaymentMethodsLoading());

    final result = await repo.deletePaymentMethod(id: id);

    result.fold(
      (error) => emit(PaymentMethodsFailure(error.message ?? 'حدث خطأ')),
      (deletedId) {
        paymentMethods.removeWhere((pm) => pm.id == deletedId);

        emit(DeletePaymentMethodSuccess());
        emit(PaymentMethodsSuccess(paymentMethods));
        // MyServiceLocator.getSingleton<SellingPointProductCubit>().deletePaymentMethod(id);
        MyServiceLocator.getSingleton<SellingPointProductCubit>().loadPaymentMethods();
        deletePaymentMethodLocal(id);
      },
    );
  }
}