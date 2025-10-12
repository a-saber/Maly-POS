import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/manager/search_product_cubit/search_product_cubit.dart';
import 'package:pos_app/features/products/view/widget/search_product_build.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomDropDownProduct extends StatelessWidget {
  const CustomDropDownProduct({
    super.key,
    this.value,
    required this.onChange,
  });
  final ProductModel? value;
  final void Function(ProductModel?) onChange;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getSingleton<SearchProductCubit>(),
      child: Builder(builder: (context) {
        return CustomDropdown<ProductModel>(
          // search: true,
          hint: S.of(context).selectProduct,
          compareFn: (item1, item2) {
            if (item1.name == null || item2.name == null) {
              return false;
            } else {
              return (item1.name!
                      .toLowerCase()
                      .contains(item2.name!.toLowerCase()) ||
                  item2.name!
                      .toLowerCase()
                      .contains(item1.name!.toLowerCase()));
            }
          },
          value: value,
          items: SearchProductCubit.get(context).products,
          filterFn: (item, filter) {
            return item.name?.toLowerCase().contains(filter.toLowerCase()) ??
                false;
          },
          onChanged: (ProductModel? product) {
            // if (product != null) {
            //   FilterStoreMoveCubit.get(context)
            //       .changeProduct(product);
            // }
          },
          containerBuilder: (p0, p1) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomFormField(
                    hintText: S.of(context).searchProduct,
                    controller: TextEditingController(
                        text: SearchProductCubit.get(context).query),
                    onChanged: (value) =>
                        SearchProductCubit.get(context).onSearchChanged(
                      value,
                    ),
                  ),
                ),
                Expanded(
                  child: SearchProductBuild(
                    name: value?.name ?? '',
                    child: p1,
                    onTap: (p0) {
                      onChange(p0);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
          builder: (ProductModel? product) {
            if (product != null) {
              return Text(
                product.name ?? S.of(context).noName,
                style: AppFontStyle.formText(
                  context: context,
                ),
              );
            } else {
              return SizedBox();
            }
          },
        );
      }),
    );
  }
}
