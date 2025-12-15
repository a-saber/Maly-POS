import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/payment_helper.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_type.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/paymentmethods/data/models/paymentmodel.dart'
    as PaymentAdmin;
import 'package:pos_app/features/selling_point/data/model/payment_method_model.dart'
    as PaymentSales;
import 'package:pos_app/features/selling_point/data/model/print_model.dart';
import 'package:pos_app/features/selling_point/data/model/product_selling_model.dart';
import 'package:pos_app/features/selling_point/data/model/type_of_take_order_model.dart';
import 'package:pos_app/features/selling_point/data/repo/selling_point_repo.dart';
import 'package:pos_app/features/paymentmethods/data/repo/repo.dart';

import '../../../products/data/model/product_unit_model.dart';

part 'selling_point_product_state.dart';

class SellingPointProductCubit extends Cubit<SellingPointProductState> {
  SellingPointProductCubit(this.repo, this.paymentMethodsRepo)
      : super(SellingPointProductInitial());

  static SellingPointProductCubit get(context) => BlocProvider.of(context);
  final SellingPointRepo repo;
  final PaymentMethodsRepo paymentMethodsRepo;

  List<ProductSellingModel> products = [];
  DiscountModel? discount;
  TypeOfTakeOrderModel? typeOfTakeOrder;
  PaymentSales.PaymentMethodModel? paymentMethod;
  CustomerModel? user;

  TextEditingController paidController = TextEditingController();

  List<PaymentAdmin.PaymentMethodSalesModel> availablePaymentMethods = [];
  Map<int, double> selectedPaymentAmounts = {}; // {paymentMethodId: amount}
  Map<int, String> paymentReferences = {}; // {paymentMethodId: reference}

  init() {
    resetProduct();
    cashAmount = 0.0;
    madaAmount = 0.0;
    onlineAmount = 0.0;
    user = null;
    selectedPaymentAmounts = {};
    paymentReferences = {};
    if (availablePaymentMethods.isNotEmpty) {
      final firstMethod = availablePaymentMethods.first;
      selectedPaymentAmounts[firstMethod.id!] = totalPrice();
      paidController.text = totalPrice().toStringAsFixed(2);
    }
    emit(SellingPointProductInitial());
  }

  void initThePaymentOrderAndTypeOfTakeOrder({
    required BuildContext context,
  }) {
    typeOfTakeOrder = AppConstant.typesOfTakeOrder(context).first;
    paymentMethod = AppConstant.paymentMethods(context).first;
    emit(SellingPointProductInitial());
  }

  void addPaymentMethod(PaymentAdmin.PaymentMethodSalesModel value) {
    if (availablePaymentMethods.isNotEmpty) availablePaymentMethods.add(value);
    emit(SellingPointProductInitial());
  }

  void updatePaymentMethod(PaymentAdmin.PaymentMethodSalesModel value) {
    final index =
        availablePaymentMethods.indexWhere((element) => element.id == value.id);
    if (index != -1) {
      availablePaymentMethods[index] = value;
    }
    emit(SellingPointProductInitial());
  }

  void deletePaymentMethod(int id) {
    final index =
        availablePaymentMethods.indexWhere((element) => element.id == id);
    if (index != -1) {
      availablePaymentMethods.removeAt(index);
    }
    emit(SellingPointProductInitial());
  }

  Future<void> loadPaymentMethods() async {
    emit(SellingPointProductLoading());

    final result = await paymentMethodsRepo.getPaymentMethods(isFresh: true);

    result.fold(
      (apiError) {
        emit(SellingPointProductFailing(message: apiError));
      },
      (methods) {
        availablePaymentMethods =
            methods.where((m) => m.isActive == 1).toList();
        if (availablePaymentMethods.isNotEmpty) {
          final firstMethod = availablePaymentMethods.first;

          selectedPaymentAmounts[firstMethod.id!] = totalPrice();
        }
        emit(SellingPointProductPaymentMethodsLoaded());
      },
    );
  }

  double remainingAmount() {
    double paid = double.tryParse(paidController.text) ?? 0.0;
    double total = totalPrice();
    return paid > total ? paid - total : 0.0;
  }

  void confirmPayment() async {
    emit(SellingPointProductLoading());

    debugPrint(" \n ******* subtotal : ${subTotalPrice()} *************** \n");
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
      madaAmount: selectedPaymentAmounts[2] ?? 0.0,
      onlineAmount: selectedPaymentAmounts[3] ?? 0.0,
      online: selectedPaymentAmounts[3] ?? 0.0,
      subtotal: round2(subTotalPrice()),
      discounttotal: round2(discountPrice()),
      totalafterdiscount: round2(totalAfterDiscount()),
      taxtotal: round2(taxesPrice()),
      totalaftertax: round2(totalAfterTax()),
      paymentType: paymentMethod,
      discount: discount,
      customer: user,
      products: products,
      paymentAmounts: selectedPaymentAmounts,
      paymentReferences: paymentReferences,
    );

    respons.fold(
        (errMessage) => emit(SellingPointProductFailing(message: errMessage)),
        (success) {
      init();
      emit(SellingPointProductSuccess(printModel: success));
    });
  }

  bool containProduct() => products.isNotEmpty;

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

  void addProduct({required ProductModel product, ProductUnit? productUnit}) {
    bool isFound = products.any((element) =>
        element.product.id == product.id &&
        element.productUnit?.unitId == productUnit?.unitId);
    if (isFound) {
      var myproduct = products.firstWhere((element) =>
          element.product.id == product.id &&
          element.productUnit?.unitId == productUnit?.unitId);
      increaseCount(
          productId: myproduct.product.id ?? -1,
          productUnitId: productUnit?.unitId);
    } else {
      if (product.type?.toLowerCase().trim() ==
          ApiKeys.service.toLowerCase().trim()) {
        products.add(ProductSellingModel(
            product: product, count: 1, productUnit: productUnit));
        updatePaid();
        emit(SellingPointProductAddingProduct());
      } else if (product.quantity == null || product.quantity == 0) {
        updatePaid();
        emit(SellingPointProductAddingFailingProduct());
        return;
      } else {
        products.add(ProductSellingModel(
            product: product, count: 1, productUnit: productUnit));
        updatePaid();
        emit(SellingPointProductAddingProduct());
      }
    }
  }

  void increaseCount({required int productId, required int? productUnitId}) {
    var product = products.firstWhere((element) =>
        element.product.id == productId &&
        element.productUnit?.unitId == productUnitId);

    bool canIncrease = product.increaseCount();

    if (canIncrease) {
      updatePaid();
      emit(SellingPointProductIncreaseCount());
    } else {
      updatePaid();
      emit(SellingPointProductIncreaseCountFailing());
    }
  }

  void decreaseCount({required int productId, required int? productUnitId}) {
    if (products
            .firstWhere((element) =>
                element.product.id == productId &&
                element.productUnit?.unitId == productUnitId)
            .count ==
        1) {
      removeProduct(productId: productId, productUnitId: productUnitId);
    } else {
      products
          .firstWhere((element) =>
              element.product.id == productId &&
              element.productUnit?.unitId == productUnitId)
          .count--;
      updatePaid();
      emit(SellingPointProductDecreaseCount());
    }
  }

  void removeProduct({required int productId, required int? productUnitId}) {
    products.removeWhere((element) =>
        element.product.id == productId &&
        element.productUnit?.unitId == productUnitId);
    updatePaid();
    emit(SellingPointProductRemoveProduct());
  }

  void toggleShowEditPrice(
      {required int productId, required int? productUnitId}) {
    products
        .firstWhere((element) =>
            element.product.id == productId &&
            element.productUnit?.unitId == productUnitId)
        .toggleShowEditPrice();

    emit(SellingPointProductChangePrice());
  }

  void changePrice({required int productId, required int? productUnitId}) {
    final bool valid = products
        .firstWhere((element) =>
            element.product.id == productId &&
            element.productUnit?.unitId == productUnitId)
        .formKey
        .currentState!
        .validate();

    if (!valid) {
      products
          .firstWhere((element) =>
              element.product.id == productId &&
              element.productUnit?.unitId == productUnitId)
          .validatePrice();
    } else {
      products
          .firstWhere((element) =>
              element.product.id == productId &&
              element.productUnit?.unitId == productUnitId)
          .toggleShowEditPrice();
    }

    updatePaid();
    emit(SellingPointProductChangePrice());
  }

  void changeDiscount(DiscountModel? discount) {
    if (discount?.id != this.discount?.id) {
      this.discount = discount;
      updatePaid();
      emit(SellingPointProductChangeDiscount());
    }
  }

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

  void changePaymentMethod(PaymentSales.PaymentMethodModel? paymentMethod) {
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
    if (selectedPaymentAmounts.isNotEmpty && products.isNotEmpty) {
      if (selectedPaymentAmounts.length == 1) {
        final methodId = selectedPaymentAmounts.keys.first;
        selectedPaymentAmounts[methodId] = totalPrice();
      }
    } else if (selectedPaymentAmounts.isEmpty &&
        availablePaymentMethods.isNotEmpty &&
        products.isNotEmpty) {
      final firstMethod = availablePaymentMethods.first;
      selectedPaymentAmounts[firstMethod.id!] = totalPrice();
    }

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
    selectedPaymentAmounts = {};
    paymentReferences = {};
    cashAmount = 0.0;
    madaAmount = 0.0;
    onlineAmount = 0.0;
    updatePaid();
    emit(SellingPointProductResetProduct());
  }

  double cashAmount = 0.0;
  double madaAmount = 0.0;
  double onlineAmount = 0.0;

  void changePaid(String newPaidAmount, {Map<int, double>? paymentAmounts}) {
    double totalPaid = double.tryParse(newPaidAmount) ?? 0.0;

    if (double.parse(totalPaid.toStringAsFixed(2)) >=
        double.parse(totalPrice().toStringAsFixed(2))) {
      paidController.text = totalPaid.toStringAsFixed(2);

      if (paymentAmounts != null && paymentAmounts.isNotEmpty) {
        selectedPaymentAmounts = Map.from(paymentAmounts);
        debugPrint(' Saved payment amounts in Cubit: $selectedPaymentAmounts');
      }

      emit(SellingPointProductChangePaid());
    } else {
      emit(SellingPointProductChangePaidFailing());
    }
  }
  Future<void> processNearpayPayment({
  required double amount,
  required int paymentMethodId,
  required BuildContext context,
}) async {
  emit(SellingPointProductLoading());
  
  try {
  
    debugPrint(' Starting Nearpay payment for amount: $amount SAR');
    
    final result = await PaymentHelper.addTransaction(amount: amount);
    
    result.fold(
     
      (  errorMessage) {
        debugPrint(' Nearpay payment failed: $errorMessage');
         final apiError = ApiResponse(
          status: false,
          message: errorMessage,
          data: null,
          statusCode: ApiStatusCode.badResponse,
          error: null
        );
        emit(SellingPointProductFailing(message: apiError));
      },
      

      (receipt) {
        debugPrint(' Nearpay payment successful!');
        debugPrint('Transaction UUID: ${receipt.transaction_uuid}');
        
        debugPrint(' Card Scheme: ${receipt.card_scheme}');
       
        
   
        selectedPaymentAmounts.clear();
        paymentReferences.clear();
        selectedPaymentAmounts[paymentMethodId] = amount;
        paymentReferences[paymentMethodId] = receipt.transaction_uuid ?? '';
        
      
        paidController.text = amount.toStringAsFixed(2);
        
        debugPrint(' Payment data saved successfully');
        debugPrint(' selectedPaymentAmounts: $selectedPaymentAmounts');
        debugPrint(' paymentReferences: $paymentReferences');
        
      
        debugPrint(' Confirming payment and completing sale...');
        confirmPayment();
        
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
    );
    
  } catch (e) {
    debugPrint(' Unexpected Nearpay error: $e');
     final apiError = ApiResponse(
          status: false,
          message:e.toString(),
          data: null,
          statusCode: ApiStatusCode.badResponse,
          error: null
        );
        emit(SellingPointProductFailing(message: apiError));
      };
}

}
