import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/manager/search_discount_cubit/search_discount_cubit.dart';
import 'package:pos_app/features/discounts/view/widget/search_discount_build.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomDropDownDiscount extends StatelessWidget {
  const CustomDropDownDiscount({
    super.key,
    this.value,
    required this.onChanged,
    this.prefixIcon,
  });
  final DiscountModel? value;
  final Function(DiscountModel?) onChanged;
  final Widget? prefixIcon;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getSingleton<SearchDiscountCubit>(),
      child: Builder(builder: (context) {
        return CustomDropdown<DiscountModel>(
          prefixIcon: prefixIcon,
          // search: true,
          hint: S.of(context).selectDiscount,
          compareFn: (item1, item2) {
            if (item1.title == null ||
                item2.title == null ||
                item1.title!.isEmpty ||
                item2.title!.isEmpty) {
              return false;
            } else {
              return (item1.title!
                      .toLowerCase()
                      .contains(item2.title!.toLowerCase()) ||
                  item2.title!
                      .toLowerCase()
                      .contains(item1.title!.toLowerCase()));
            }
          },

          value: value,
          items: SearchDiscountCubit.get(context).discounts,
          filterFn: (item, filter) {
            return item.title!.toLowerCase().contains(filter.toLowerCase());
          },
          onChanged: (DiscountModel? discount) {
            // if (discount != null) {
            //   SellingPointProductCubit.get(context).changeDiscount(discount);
            // }
          },
          containerBuilder: (p0, p1) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomFormField(
                    hintText: S.of(context).searchDiscount,
                    controller: TextEditingController(
                        text: SearchDiscountCubit.get(context).query),
                    onChanged: (value) =>
                        SearchDiscountCubit.get(context).onSearchChanged(
                      value,
                    ),
                  ),
                ),
                Expanded(
                  child: SearchDiscountBuild(
                    name: value?.title ?? '',
                    child: p1,
                    onTap: (p0) {
                      onChanged(p0);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
          builder: (DiscountModel? discunt) {
            if (discunt != null) {
              return Text(
                discunt.title ?? S.of(context).noName,
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
