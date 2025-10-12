import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_type.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/selling_point/data/model/payment_method_model.dart';
import 'package:pos_app/features/selling_point/data/model/print_model.dart';
import 'package:pos_app/features/selling_point/data/model/product_selling_model.dart';
import 'package:pos_app/features/selling_point/data/model/type_of_take_order_model.dart';
import 'package:pos_app/features/selling_point/data/repo/selling_point_repo.dart';

part 'selling_point_product_state.dart';

class SellingPointProductCubit extends Cubit<SellingPointProductState> {
  SellingPointProductCubit(this.repo) : super(SellingPointProductInitial());

  static SellingPointProductCubit get(context) => BlocProvider.of(context);
  final SellingPointRepo repo;

  List<ProductSellingModel> products = [];
  // TaxesModel? taxes;
  DiscountModel? discount;
  TypeOfTakeOrderModel? typeOfTakeOrder;
  PaymentMethodModel? paymentMethod;
  CustomerModel? user;
  // BrancheModel? branche;

  // String? valuePaid;
  TextEditingController paidController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  init() {
    // formKey = GlobalKey<FormState>();
    resetProduct();
    // typeOfTakeOrder = null;
    // taxes = null;
    // value = '';
    // discount = null;
    autovalidateMode = AutovalidateMode.disabled;

    user = null;
    // paymentController = TextEditingController();
    emit(SellingPointProductInitial());
  }

  void initThePaymentOrderAndTypeOfTakeOrder({
    required BuildContext context,
  }) {
    typeOfTakeOrder = AppConstant.typesOfTakeOrder(context).first;
    paymentMethod = AppConstant.paymentMethods(context).first;
    emit(SellingPointProductInitial());
  }

  void confirmPayment() async {
    if (formKey.currentState!.validate()) {
      emit(SellingPointProductLoading());
      debugPrint(
          " \n ******* subtotal : ${subTotalPrice()} *************** \n");
      debugPrint(
          " \n ******* discounttotal : ${discountPrice()} *************** \n");
      debugPrint(
          " \n ******* totalafterdiscount : ${totalAfterDiscount()} *************** \n");
      debugPrint(" \n ******* taxtotal : ${taxesPrice()} *************** \n");
      debugPrint(
          " \n ******* totalaftertax : ${totalAfterTax()} *************** \n");
      var respons = await repo.newSales(
        typeOfTakeOrder: typeOfTakeOrder!,
        paid: double.parse(
          (paidController.text.isEmpty)
              ? (round2(totalPrice()).toString())
              : paidController.text,
        ),

        subtotal: round2(subTotalPrice()),
        discounttotal: round2(discountPrice()),
        totalafterdiscount: round2(totalAfterDiscount()),
        taxtotal: round2(taxesPrice()),
        totalaftertax: round2(totalAfterTax()),
        paymentType: paymentMethod,
        // taxes: taxes!,
        discount: discount,

        customer: user,
        products: products,
      );
      respons.fold(
          (errMessage) => emit(SellingPointProductFailing(message: errMessage)),
          (success) {
        init();
        emit(SellingPointProductSuccess(printModel: success));
      });
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(SellingPointProductUnvalidTextField());
    }
  }

  bool containProduct() => products.isNotEmpty;

  /////////////////////////////////////////////////////
  /// Calculation Function

  double round2(double value) {
    return ((value * 100).round() / 100.0);
  }

  double subTotalPrice() {
    double total = 0;

    for (var element in products) {
      total += element.totalPrice();
    }

    return total;
  }

  double discountPrice() {
    if (discount == null) {
      return 0;
    } else if (discount!.type == DiscountType.percentage) {
      double? percentage = double.tryParse(discount!.value ?? '');
      if (percentage == null) {
        return 0;
      } else {
        return subTotalPrice() * (percentage / 100.0);
      }
    } else {
      double? value = double.tryParse(discount!.value ?? '');
      if (value == null) {
        return 0;
      } else {
        return value;
      }
    }
  }

  double totalAfterDiscount() {
    return subTotalPrice() - discountPrice();
  }

  double priceOfProductAfterDicount(ProductSellingModel product) {
    if (discount == null) {
      return product.totalPrice();
    }

    double percentageOfParticipation = (product.totalPrice() / subTotalPrice());
    debugPrint(
        " \n ******* percentage ${product.totalPrice()} : ${(product.totalPrice() / subTotalPrice())} *************** \n");
    debugPrint(
        " \n ******* priceOfProductAfterDicount ${product.totalPrice()} : ${totalAfterDiscount() * (percentageOfParticipation)} *************** \n");
    return totalAfterDiscount() * (percentageOfParticipation);
  }

  double taxesPrice() {
    double total = 0;

    for (var element in products) {
      if (element.product.tax != null) {
        double? taxes = double.tryParse(element.product.tax!.percentage ?? '');
        if (taxes != null) {
          total += (priceOfProductAfterDicount(element) * (taxes / 100.0));
        }
      }
    }

    return total;
  }

  double totalAfterTax() {
    return totalAfterDiscount() + taxesPrice();
  }

  double totalPrice() {
    return totalAfterTax();
  }

  /////// end of calculation function
  /////////////////////////////////////////////////////////////////////////////////

  void addProduct(ProductModel product) {
    bool isfound = products.any((element) => element.product.id == product.id);
    if (isfound) {
      var myproduct =
          products.firstWhere((element) => element.product.id == product.id);
      increaseCount(myproduct.product.id ?? -1);
    } else {
      if (product.type?.toLowerCase().trim() ==
          ApiKeys.service.toLowerCase().trim()) {
        products.add(ProductSellingModel(product: product, count: 1));
        updatePaid();
        emit(SellingPointProductAddingProduct());
      } else if (product.quantity == null || product.quantity == 0) {
        updatePaid();
        emit(SellingPointProductAddingFailingProduct());
        return;
      } else {
        products.add(ProductSellingModel(product: product, count: 1));
        updatePaid();
        emit(SellingPointProductAddingProduct());
      }
    }
  }

  void increaseCount(int id) {
    var product = products.firstWhere((element) => element.product.id == id);

    bool canIncrease = product.increaseCount();

    if (canIncrease) {
      updatePaid();
      emit(SellingPointProductIncreaseCount());
    } else {
      updatePaid();
      emit(SellingPointProductIncreaseCountFailing());
    }
  }

  void decreaseCount(int id) {
    if (products.firstWhere((element) => element.product.id == id).count == 1) {
      removeProduct(id);
    } else {
      products.firstWhere((element) => element.product.id == id).count--;
      updatePaid();
      emit(SellingPointProductDecreaseCount());
    }
  }

  void removeProduct(int id) {
    products.removeWhere((element) => element.product.id == id);
    updatePaid();
    emit(SellingPointProductRemoveProduct());
  }

  // Function Change

  void changeDiscount(DiscountModel? discount) {
    if (discount?.id != this.discount?.id) {
      this.discount = discount;
      updatePaid();
      emit(SellingPointProductChangeDiscount());
    }
  }

  // void changeTaxes(TaxesModel? taxes) {
  //   if (taxes?.id != this.taxes?.id) {
  //     this.taxes = taxes;
  //     emit(SellingPointProductChangeTaxes());
  //   }
  // }

  void onChangeBranche(BrancheModel? branche) {
    if (branche?.id != repo.branch?.id) {
      repo.branch = branche;
      emit(SellingPointProductChangeBranche());
    }
  }

  void changeTypeOfTakeOrder(TypeOfTakeOrderModel? typeOfTakeOrder) {
    if (typeOfTakeOrder?.id != this.typeOfTakeOrder?.id) {
      this.typeOfTakeOrder = typeOfTakeOrder;
      emit(SellingPointProductChangeTypeOfTakeOrder());
    }
  }

  void changePaymentMethod(PaymentMethodModel? paymentMethod) {
    if (paymentMethod?.id != this.paymentMethod?.id) {
      this.paymentMethod = paymentMethod;
      emit(SellingPointProductChangePayment());
    }
  }

  void changeUser(CustomerModel? user) {
    if (user?.id != this.user?.id) {
      this.user = user;
      emit(SellingPointProductChangeUser());
    }
  }

  void updateProduct(ProductModel product) {
    int index =
        products.indexWhere((element) => element.product.id == product.id);

    if (index != -1) {
      int count = products[index].count;

      products[index] = ProductSellingModel(product: product, count: count);
      updatePaid();
      emit(SellingPointProductUpdateProduct());
    }
  }

  double roundTotolPrice() {
    return round2(totalPrice());
  }

  void updatePaid() {
    paidController.text = roundTotolPrice().toString();
  }

  void deleteProduct(ProductModel product) {
    int index =
        products.indexWhere((element) => element.product.id == product.id);

    if (index != -1) {
      products.removeAt(index);
      emit(SellingPointProductDeleteProduct());
    }
  }

  void resetProduct() {
    products = [];
    user = null;
    discount = null;
    updatePaid();
    emit(SellingPointProductResetProduct());
  }

  void changePaid(String? value) {
    emit(SellingPointProductChangePaid());
  }
}
