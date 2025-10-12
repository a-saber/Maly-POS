import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/categories/data/repo/category_repo.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';
import 'package:pos_app/features/products/manager/edit_product_cubit/edit_product_cubit.dart';
import 'package:pos_app/features/products/manager/get_all_products_cubit/get_all_products_cubit.dart';
import 'package:pos_app/features/products/view/widget/product_data_builder.dart';
import 'package:pos_app/features/products/view/widget/show_delete_product_confirm_dialog.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_cubit/selling_point_cubit.dart';
import 'package:pos_app/features/units/data/repo/units_repo.dart';
import 'package:pos_app/generated/l10n.dart';

class EditProductView extends StatelessWidget {
  const EditProductView({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProductCubit(
        unitsRepo: MyServiceLocator.getSingleton<UnitsRepo>(),
        categoryRepo: MyServiceLocator.getSingleton<CategoryRepo>(),
        repo: MyServiceLocator.getSingleton<ProductsRepo>(),
        // context: context,
        product: product,
      ),
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).editProduct,
          actions: [
            CustomTextBtn(
                text: S.of(context).delete,
                onPressed: () async {
                  await showDeleteProductConfirmDialog(
                      context: context, product: product, goBack: true);
                })
          ],
        ),
        body: BlocConsumer<EditProductCubit, EditProductState>(
          listener: (context, state) {
            if (state is EditProductSuccess) {
              GetAllProductsCubit.get(context).updateProduct(state.product);
              SellingPointCubit.get(context).updateProduct(state.product,
                  context: context, oldCayegoryId: product.categoryId);
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).updatedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is EditProductFailing) {
              if (context.mounted) {
                CustomPopUp.callMyToast(
                    context: context,
                    massage: mapStatusCodeToMessage(context, state.errMessage),
                    state: PopUpState.ERROR);
              }
            }
          },
          builder: (context, state) {
            return CustomLayoutBuilder(
              mobile: MyCustomScrollView(
                child: EditProductMobileBody(
                  state: state,
                ),
              ),
              tablet: MyCustomScrollView(
                child: EditProductTabletAndDesktopBody(
                  state: state,
                ),
              ),
              desktop: MyCustomScrollView(
                child: EditProductTabletAndDesktopBody(
                  state: state,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EditProductMobileBody extends StatelessWidget {
  const EditProductMobileBody({
    super.key,
    required this.state,
  });
  final EditProductState state;
  @override
  Widget build(BuildContext context) {
    return ProductDataBuilder(
      callInInit: () => EditProductCubit.get(context).init(context: context),
      onSelectedImage: (image) => EditProductCubit.get(context).image = image,
      formKey: EditProductCubit.get(context).formKey,
      autovalidateMode: EditProductCubit.get(context).autovalidateMode,
      nameController: EditProductCubit.get(context).nameController,
      descriptionController:
          EditProductCubit.get(context).descriptionController,
      pricePerUnitController:
          EditProductCubit.get(context).pricePerUnitController,
      openingQuantityController:
          EditProductCubit.get(context).openingQuantityController,
      barCodeController: EditProductCubit.get(context).barCodeController,
      brandController: EditProductCubit.get(context).brandController,
      isLoading: state is EditProductLoading,
      onPressed: () => EditProductCubit.get(context).editProduct(),
      onChangedCategory: (category) =>
          EditProductCubit.get(context).onChangeCategory(category),
      category: EditProductCubit.get(context).category,
      onChangedUnit: (unit) => EditProductCubit.get(context).onChangeUnit(unit),
      unit: EditProductCubit.get(context).unit,
      onChangedBranch: (branch) =>
          EditProductCubit.get(context).onChangeBranch(branch),
      branch: EditProductCubit.get(context).branch,
      onInitialQuntitySubmit:
          EditProductCubit.get(context).onSubmitInitalQunatity,
      taxes: EditProductCubit.get(context).taxes,
      onChangedTaxes: EditProductCubit.get(context).onChangeTaxes,
      productType: EditProductCubit.get(context).productType,
      onChangedProductType: EditProductCubit.get(context).onChangeProductType,
      isEdit: true,
      imageUrl: EditProductCubit.get(context).product.imageUrl,
    );
  }
}

class EditProductTabletAndDesktopBody extends StatelessWidget {
  const EditProductTabletAndDesktopBody({super.key, required this.state});
  final EditProductState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: EditProductMobileBody(state: state),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
