import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/manager/search_taxes/search_taxes_cubit.dart';
import 'package:pos_app/features/taxes/view/widget/search_taxes_build.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomDropDownTaxes extends StatelessWidget {
  const CustomDropDownTaxes({
    super.key,
    this.value,
    required this.onChange,
  });

  final TaxesModel? value;
  final Function(TaxesModel?) onChange;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getSingleton<SearchTaxesCubit>(),
      child: Builder(builder: (context) {
        return CustomDropdown<TaxesModel>(
          // search: true,
          hint: S.of(context).selectTax,
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
          // validator: (value) =>
          //     MyFormValidators.validateTypeRequired<TaxesModel>(value,
          //         context: context),
          value: value,
          items: SearchTaxesCubit.get(context).searchTaxes,
          filterFn: (item, filter) {
            return item.title!.toLowerCase().contains(filter.toLowerCase());
          },
          onChanged: (TaxesModel? tax) {
            onChange(tax);
          },
          containerBuilder: (p0, p1) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomFormField(
                    hintText: S.of(context).searchTaxes,
                    controller: TextEditingController(
                        text: SearchTaxesCubit.get(context).query),
                    onChanged: (value) =>
                        SearchTaxesCubit.get(context).onSearchChanged(
                      value,
                    ),
                  ),
                ),
                Expanded(
                  child: SearchTaxesBuild(
                    name: value?.title ?? '',
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
          builder: (TaxesModel? tax) {
            if (tax != null) {
              return Text(
                tax.title ?? '',
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
