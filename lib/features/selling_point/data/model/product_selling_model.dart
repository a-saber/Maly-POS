import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';

import '../../../products/data/model/product_unit_model.dart';

class ProductSellingModel {
  final ProductModel product;
  final ProductUnit? productUnit;
  int count;
  double totalPrice() {
    if (productUnit?.salePriceWithoutTax== null) {
      return 0;
    }
    double? price = double.tryParse(productUnit?.salePriceWithoutTax??'');
    if (price == null) {
      return 0;
    }
    return price * count;
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

  ProductSellingModel({required this.product, required this.count, this.productUnit});
}
