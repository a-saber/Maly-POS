import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/show_delete_confirm_dialog.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';
import 'package:pos_app/features/products/manager/delete_product_cubit/delete_product_cubit.dart';
import 'package:pos_app/features/products/manager/get_all_products_cubit/get_all_products_cubit.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_cubit/selling_point_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

Future<bool?> showDeleteProductConfirmDialog(
    {required BuildContext context,
    required ProductModel product,
    bool goBack = false}) async {
  return await showDeleteConfirmationDialog(
      context: context,
      title: S.of(context).deleteProduct,
      content: product.name ?? S.of(context).noName,
      deleteButtonBuilder: (ctx, button, loading) => BlocProvider(
            create: (context) => DeleteProductCubit(
                MyServiceLocator.getSingleton<ProductsRepo>()),
            child: BlocConsumer<DeleteProductCubit, DeleteProductState>(
              listener: (context, state) {
                if (state is DeleteProductSuccess) {
                  deleteConfirmationDialogSuccess(ctx);
                  MyServiceLocator.getSingleton<GetAllProductsCubit>()
                      .removeProduct(state.id);
                  SellingPointCubit.get(context)
                      .deleteProduct(product, context: context);
                  if (goBack) {
                    Navigator.pop(context);
                  }
                } else if (state is DeleteProductFailing) {
                  if (context.mounted) {
                    deleteConfirmationDialogError(
                        ctx, mapStatusCodeToMessage(context, state.errMessage));
                  }
                }
              },
              builder: (context, state) {
                if (state is DeleteProductLoading) {
                  return loading;
                }
                return button(
                  context: context,
                  onPressed: () =>
                      DeleteProductCubit.get(context).deleteProduct(
                    product: product,
                  ),
                );
              },
            ),
          ));
}
