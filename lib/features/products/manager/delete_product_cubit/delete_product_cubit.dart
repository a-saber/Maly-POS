import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';

part 'delete_product_state.dart';

class DeleteProductCubit extends Cubit<DeleteProductState> {
  DeleteProductCubit(this.repo) : super(DeleteProductInitial());

  static DeleteProductCubit get(context) => BlocProvider.of(context);
  final ProductsRepo repo;

  Future<void> deleteProduct({required ProductModel product}) async {
    emit(DeleteProductLoading());
    var reponse = await repo.deleteProduct(
      product: product,
    );
    reponse.fold(
      (error) => emit(DeleteProductFailing(errMessage: error)),
      (r) => emit(DeleteProductSuccess(
        id: r,
      )),
    );
  }
}
