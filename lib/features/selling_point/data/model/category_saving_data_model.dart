import 'package:pos_app/features/products/data/model/get_products_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';

class CategorySavingDataModel {
  final int id;
  List<ProductModel>? products;
  List<ProductModel>? searchProduct;
  String? query;
  GetProductsModel? getProductsModel;
  GetProductsModel? getProductsSearchModel;

  CategorySavingDataModel({
    required this.id,
    this.products,
    this.searchProduct,
    this.query,
    this.getProductsModel,
    this.getProductsSearchModel,
  });
}
