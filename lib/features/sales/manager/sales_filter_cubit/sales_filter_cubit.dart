import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/sales/data/model/sort_model.dart';
import 'package:pos_app/features/selling_point/data/model/payment_method_model.dart';
import 'package:pos_app/features/selling_point/data/model/type_of_take_order_model.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';

part 'sales_filter_state.dart';

class SalesFilterCubit extends Cubit<SalesFilterState> {
  SalesFilterCubit() : super(SalesFilterInitial());

  static SalesFilterCubit get(context) => BlocProvider.of(context);

  // GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  BrancheModel? branch;
  UserModel? user;
  DiscountModel? discount;
  TaxesModel? taxes;
  ProductModel? product;
  PaymentMethodModel? paymentMethod;
  // Sort
  SortModel? sort;
  SortByModel? sortBy;

  // Date
  DateTime? from;
  DateTime? to;

  // Order Type

  TypeOfTakeOrderModel? takeOrderModel;

  void changeBranch(BrancheModel? branch) {
    if (branch?.id != this.branch?.id) {
      this.branch = branch;
      emit(SalesFilterChangeBranch());
    }
  }

  void resetBranch() {
    branch = null;
    emit(SalesFilterChangeBranch());
  }

  void changeUser(UserModel? user) {
    if (user?.id != this.user?.id) {
      this.user = user;
      emit(SalesFilterChangeUser());
    }
  }

  void resetUser() {
    user = null;
    emit(SalesFilterChangeUser());
  }

  void changeDiscount(DiscountModel? discount) {
    if (discount?.id != this.discount?.id) {
      this.discount = discount;
      emit(SalesFilterChangeDiscount());
    }
  }

  void resetDiscount() {
    discount = null;
    emit(SalesFilterChangeDiscount());
  }

  void changeTaxes(TaxesModel? taxes) {
    if (taxes?.id != this.taxes?.id) {
      this.taxes = taxes;
      emit(SalesFilterChangeTaxes());
    }
  }

  void resetTaxes() {
    taxes = null;
    emit(SalesFilterChangeTaxes());
  }

  void changeProduct(ProductModel? product) {
    if (product?.id != this.product?.id) {
      this.product = product;
      emit(SalesFilterChangeProduct());
    }
  }

  void resetProduct() {
    product = null;
    emit(SalesFilterChangeProduct());
  }

  void changePaymentMethod(PaymentMethodModel? paymentMethod) {
    if (paymentMethod?.id != this.paymentMethod?.id) {
      this.paymentMethod = paymentMethod;
      emit(SalesFilterChangePaymentMethod());
    }
  }

  void resetPaymentMethod() {
    paymentMethod = null;
    emit(SalesFilterChangePaymentMethod());
  }

  void chanegFrom(DateTime? from) {
    if (from != this.from) {
      this.from = from;
      emit(SalesFilterChangeFrom());
    }
  }

  void resetFrom() {
    from = null;
    emit(SalesFilterChangeFrom());
  }

  void changeTo(DateTime? to) {
    if (to != this.to) {
      this.to = to;
      emit(SalesFilterChangeTo());
    }
  }

  void resetTo() {
    to = null;
    emit(SalesFilterChangeTo());
  }

  void changeSortBy(SortByModel? sortBy) {
    if (sortBy?.id != this.sortBy?.id) {
      this.sortBy = sortBy;
      emit(SalesFilterChangeSortBy());
    }
  }

  void resetSortBy() {
    sortBy = null;
    emit(SalesFilterChangeSortBy());
  }

  void changeSort(SortModel? sort) {
    if (sort?.id != this.sort?.id) {
      this.sort = sort;
      emit(SalesFilterChangeSort());
    }
  }

  void resetSort() {
    sort = null;
    emit(SalesFilterChangeSort());
  }

  void changeOrderType(TypeOfTakeOrderModel? typeOfOrder) {
    if (typeOfOrder?.id != takeOrderModel?.id) {
      takeOrderModel = typeOfOrder;
      emit(SalesFilterChangeSort());
    }
  }

  void resetOrderType() {
    takeOrderModel = null;
    emit(SalesFilterChangeSort());
  }

  // void onTap() {
  //   if (formKey.currentState!.validate()) {
  //     emit(SalesFilterValidate());
  //   } else {
  //     autovalidateMode = AutovalidateMode.always;
  //     emit(SalesFilterUnValidate());
  //   }
  // }

  bool notValidateSort() {
    if ((sort == null && sortBy != null) ||
        ((sort != null && sortBy == null))) {
      return true;
    }
    return false;
  }

  bool notVlidateDate() {
    if ((from == null && to != null) || ((from != null && to == null))) {
      return true;
    }
    return false;
  }
}
