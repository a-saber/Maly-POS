import 'package:dartz/dartz.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/products/data/model/get_products_model.dart';
import 'package:pos_app/features/selling_test/data/models/selling_test_model.dart';

class SellingTestRepo
{
  final ApiHelper api;
  SellingTestRepo({required this.api});
  List<SellingTestModel> sellingTestModels = [];

  Future<List<SellingTestModel>> getData({
    String search = '',
    int categoryId = -1,
    required int branchId,
})async
  {
    try
    {
      if(!SellingTestModel.isCategoryExist(sellingTestModels, categoryId))
      {
        String apiUrl = await ApiEndPoints.getProducts();
        ApiResponse response = await api.get(
          url: apiUrl,
          queryParameters: {
            ApiKeys.search: search,
            ApiKeys.branchid: branchId,
            if(categoryId != -1) ApiKeys.categoryId: categoryId,
          }
        );
        if(response.status)
        {
          GetProductsModel getProductsModel = GetProductsModel.fromJson(response.data as Map<String, dynamic>);
          sellingTestModels.add(
              SellingTestModel(
                  categoryId: categoryId,
                  products: getProductsModel.data!.data!
              )
          );
        }
        else
        {
          sellingTestModels[SellingTestModel.getIndexByCategoryId(sellingTestModels, categoryId)].error =
              response.message;
        }
        return sellingTestModels;

      }
      else
      {
        // exist
        // todo: test for pagination
        return sellingTestModels;
      }
    }
    catch(e)
    {
      sellingTestModels[SellingTestModel.getIndexByCategoryId(sellingTestModels, categoryId)].error =
          ApiResponse.errorResonse(e.toString(), statusCode: 400).message;
      return sellingTestModels;
    }
  }
}