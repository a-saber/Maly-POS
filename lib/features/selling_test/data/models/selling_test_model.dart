import 'package:pos_app/features/products/data/model/product_model.dart';

class SellingTestModel
{
  int categoryId;
  List<ProductModel> products;
  String? error;

  SellingTestModel({required this.categoryId, required this.products});

  static bool isCategoryExist(List<SellingTestModel> sellingTestModels, int id)
  {
    for (int i = 0; i < sellingTestModels.length; i++) {
      if (sellingTestModels[i].categoryId == id) {
        if(sellingTestModels[i].products.isNotEmpty) {
          return true;
        }
        return false;
      }
    }
    return false;
  }

  static int getIndexByCategoryId( List<SellingTestModel> sellingTestModels, int id)
  {
    for (int i = 0; i < sellingTestModels.length; i++) {
      if (sellingTestModels[i].categoryId == id) {
        return i;
      }
    }
    return -1;
  }


}