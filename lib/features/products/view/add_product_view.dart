import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';
import 'package:pos_app/features/products/manager/add_product_cubit/add_product_cubit.dart';
import 'package:pos_app/features/products/manager/get_all_products_cubit/get_all_products_cubit.dart';
import 'package:pos_app/features/products/view/widget/product_data_builder.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_cubit/selling_point_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddProductCubit(MyServiceLocator.getSingleton<ProductsRepo>()),
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).addProduct),
        body: BlocConsumer<AddProductCubit, AddProductState>(
          listener: (context, state) {
            if (state is AddProductSuccess) {
              GetAllProductsCubit.get(context).addProduct(state.product);
              // Selling Point
              SellingPointCubit.get(context).addProduct(state.product);
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).addedSuccess,
                  state: PopUpState.SUCCESS);

              Navigator.pop(context);
            } else if (state is AddProductFailing) {
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
              mobile:
                  MyCustomScrollView(child: AddProductMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child: AddProductTabletAndDesktopBody(state: state)),
              desktop: MyCustomScrollView(
                  child: AddProductTabletAndDesktopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class AddProductMobileBody extends StatelessWidget {
  const AddProductMobileBody({
    super.key,
    required this.state,
  });
  final AddProductState state;
  @override
  Widget build(BuildContext context) {
    return ProductDataBuilder(
      onSelectedImage: (image) => AddProductCubit.get(context).image = image,
      formKey: AddProductCubit.get(context).formKey,
      autovalidateMode: AddProductCubit.get(context).autovalidateMode,
      nameController: AddProductCubit.get(context).nameController,
      descriptionController: AddProductCubit.get(context).descriptionController,
      pricePerUnitController:
          AddProductCubit.get(context).pricePerUnitController,
      openingQuantityController:
          AddProductCubit.get(context).openingQuantityController,
      barCodeController: AddProductCubit.get(context).barCodeController,
      brandController: AddProductCubit.get(context).brandController,
      isLoading: state is AddProductLoading,
      onPressed: () => AddProductCubit.get(context).addProduct(),
      onChangedCategory: (category) =>
          AddProductCubit.get(context).onChangeCategory(category),
      category: AddProductCubit.get(context).category,
      onChangedUnit: (unit) => AddProductCubit.get(context).onChangeUnit(unit),
      unit: AddProductCubit.get(context).unit,
      onChangedBranch: (branch) =>
          AddProductCubit.get(context).onChangeBranch(branch),
      branch: AddProductCubit.get(context).branch,
      onInitialQuntitySubmit:
          AddProductCubit.get(context).onSubmitInitalQunatity,
      taxes: AddProductCubit.get(context).taxes,
      onChangedTaxes: AddProductCubit.get(context).onChangeTaxes,
      productType: AddProductCubit.get(context).productType,
      onChangedProductType: AddProductCubit.get(context).onChangeProductType,
      callInInit: () {},
      isEdit: false,
      imageUrl: null,
    );
  }
}

class AddProductTabletAndDesktopBody extends StatelessWidget {
  const AddProductTabletAndDesktopBody({super.key, required this.state});
  final AddProductState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: AddProductMobileBody(state: state),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
