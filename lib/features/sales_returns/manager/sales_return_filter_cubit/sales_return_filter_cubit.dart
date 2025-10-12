import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/sales/data/model/sort_model.dart';
import 'package:pos_app/features/selling_point/data/model/payment_method_model.dart';
import 'package:pos_app/features/selling_point/data/model/type_of_take_order_model.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';

part 'sales_return_filter_state.dart';

class SalesReturnFilterCubit extends Cubit<SalesReturnFilterState> {
  SalesReturnFilterCubit() : super(SalesReturnFilterInitial());

  static SalesReturnFilterCubit get(context) => BlocProvider.of(context);

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

  // Take Order
  TypeOfTakeOrderModel? typeOfOrder;

  void changeBranch(BrancheModel? branch) {
    if (branch?.id != this.branch?.id) {
      this.branch = branch;
      emit(SalesReturnFilterChangeBranch());
    }
  }

  void resetBranch() {
    branch = null;
    emit(SalesReturnFilterChangeBranch());
  }

  void changeUser(UserModel? user) {
    if (user?.id != this.user?.id) {
      this.user = user;
      emit(SalesReturnFilterChangeUser());
    }
  }

  void resetUser() {
    user = null;
    emit(SalesReturnFilterChangeUser());
  }

  void changeDiscount(DiscountModel? discount) {
    if (discount?.id != this.discount?.id) {
      this.discount = discount;
      emit(SalesReturnFilterChangeDiscount());
    }
  }

  void resetDiscount() {
    discount = null;
    emit(SalesReturnFilterChangeDiscount());
  }

  void changeTaxes(TaxesModel? taxes) {
    if (taxes?.id != this.taxes?.id) {
      this.taxes = taxes;
      emit(SalesReturnFilterChangeTaxes());
    }
  }

  void resetTaxes() {
    taxes = null;
    emit(SalesReturnFilterChangeTaxes());
  }

  void changeProduct(ProductModel? product) {
    if (product?.id != this.product?.id) {
      this.product = product;
      emit(SalesReturnFilterChangeProduct());
    }
  }

  void resetProduct() {
    product = null;
    emit(SalesReturnFilterChangeProduct());
  }

  void changePaymentMethod(PaymentMethodModel? paymentMethod) {
    if (paymentMethod?.id != this.paymentMethod?.id) {
      this.paymentMethod = paymentMethod;
      emit(SalesReturnFilterChangePaymentMethod());
    }
  }

  void resetPaymentMethod() {
    paymentMethod = null;
    emit(SalesReturnFilterChangePaymentMethod());
  }

  void chanegFrom(DateTime? from) {
    if (from != this.from) {
      this.from = from;
      emit(SalesReturnFilterChangeFrom());
    }
  }

  void resetFrom() {
    from = null;
    emit(SalesReturnFilterChangeFrom());
  }

  void changeTo(DateTime? to) {
    if (to != this.to) {
      this.to = to;
      emit(SalesReturnFilterChangeTo());
    }
  }

  void resetTo() {
    to = null;
    emit(SalesReturnFilterChangeTo());
  }

  void changeSortBy(SortByModel? sortBy) {
    if (sortBy?.id != this.sortBy?.id) {
      this.sortBy = sortBy;
      emit(SalesReturnFilterChangeSortBy());
    }
  }

  void resetSortBy() {
    sortBy = null;
    emit(SalesReturnFilterChangeSortBy());
  }

  void changeSort(SortModel? sort) {
    if (sort?.id != this.sort?.id) {
      this.sort = sort;
      emit(SalesReturnFilterChangeSort());
    }
  }

  void resetSort() {
    sort = null;
    emit(SalesReturnFilterChangeSort());
  }

  void changeTakeOrderType(TypeOfTakeOrderModel? orderType) {
    if (orderType?.id != typeOfOrder?.id) {
      typeOfOrder = orderType;
      emit(SalesReturnFilterChangeOrderType());
    }
  }

  void resetOrderType() {
    typeOfOrder = null;
    emit(SalesReturnFilterChangeOrderType());
  }

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
