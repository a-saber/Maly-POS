import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';

import '../../../products/data/model/product_unit_model.dart';

class ProductSellingModel {
  final ProductModel product;
  final ProductUnit? productUnit;
  int count;
  late final TextEditingController priceController;
  late final double minPrice;
  late final   GlobalKey<FormState> formKey;
   bool showEditPrice=false;




  double totalPrice() {
    // Use the price from the controller instead of productUnit
    return currentPrice * count;
  }
  double get currentPrice {
    double? price = double.tryParse(priceController.text);
    return price ?? 0;
  }

  bool increaseCount() {
    // print("product quantity : ${product.quantity}");
    // print("count : ${count}");
    if (product.quantity == null ||
        product.type?.toLowerCase().trim() ==
            ApiKeys.service.toLowerCase().trim()) {
      count++;
    } else if (count < product.quantity!) {
      count++;
    } else {
      return false;
    }
    return true;
  }

  bool decreaseCount() {
    if (count > 1) {
      count--;
    } else {
      return false;
    }
    return true;
  }

  ProductSellingModel({required this.product, required this.count, this.productUnit}){
    final initialPrice =double.tryParse(productUnit?.salePriceWithoutTax ?? '0')?.toStringAsFixed(2) ;
    minPrice = double.tryParse(productUnit?.minPriceWithoutTax ?? '0') ?? 0;

    priceController = TextEditingController(text: initialPrice);
    formKey=GlobalKey<FormState>();
    showEditPrice=false;
   }
   void toggleShowEditPrice(){
    showEditPrice=!showEditPrice;
    validatePrice();
   }

 void   validatePrice() {
    if(currentPrice < minPrice){
      priceController.text = double.tryParse(productUnit?.salePriceWithTax ?? '0')!.toStringAsFixed(2);
    }

  }


  Map<String, dynamic> toJson() {

    return {
      ApiKeys.productid: product.id,
      ApiKeys.quantity: count,
      ApiKeys.unitId: productUnit?.unitId,
      ApiKeys.pricePerUnitWithTax: (currentPrice + (((double.tryParse((product.tax?.percentage ?? '0')) ?? 0)/100) * currentPrice)) ,

    };
  }
}

