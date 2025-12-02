import 'package:pos_app/features/products/data/model/get_products_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';

class ProductSavingDataModel {
   int ?id;
  List<ProductModel>? products;
  List<ProductModel>? searchProduct;
  String? query;
  GetProductsModel? getProductsModel;
  GetProductsModel? getProductsSearchModel;

  ProductSavingDataModel({
     this.id,
    this.products,
    this.searchProduct,
    this.query,
    this.getProductsModel,
    this.getProductsSearchModel,
  });
  ProductSavingDataModel copyWith({
    int? id,
    List<ProductModel>? products,
    List<ProductModel>? searchProduct,
    String? query,
    GetProductsModel? getProductsModel,
    GetProductsModel? getProductsSearchModel,
  }) {
    return ProductSavingDataModel(
      id: id ?? this.id,
      products: products ?? this.products,
      searchProduct: searchProduct ?? this.searchProduct,
      query: query ?? this.query,
      getProductsModel: getProductsModel ?? this.getProductsModel,
      getProductsSearchModel: getProductsSearchModel ?? this.getProductsSearchModel,
    );
  }

}
