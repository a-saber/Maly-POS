import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/manager/search_unit_cubit/search_unit_cubit.dart';
import 'package:pos_app/features/units/view/widget/search_unit_build.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomDropDownUnit extends StatelessWidget {
  const CustomDropDownUnit({
    super.key,
    this.value,
    required this.onChanged,
  });

  final UnitModel? value;
  final Function(UnitModel? unit) onChanged;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getSingleton<SearchUnitCubit>(),
      child: Builder(builder: (context) {
        return CustomDropdown<UnitModel>(
          // search: true,
          hint: S.of(context).selectUnit,
          compareFn: (item1, item2) {
            if (item1.name == null ||
                item2.name == null ||
                item1.name!.isEmpty ||
                item2.name!.isEmpty) {
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
          validator: (value) =>
              MyFormValidators.validateTypeRequired<UnitModel>(value,
                  context: context),
          value: value,
          items: SearchUnitCubit.get(context).units,
          filterFn: (item, filter) {
            return item.name!.toLowerCase().contains(filter.toLowerCase());
          },
          containerBuilder: (p0, p1) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomFormField(
                    hintText: S.of(context).searchUnit,
                    controller: TextEditingController(
                        text: SearchUnitCubit.get(context).query),
                    onChanged: (value) =>
                        SearchUnitCubit.get(context).onChangeSearch(
                      query: value,
                    ),
                  ),
                ),
                Expanded(
                  child: SearchUnitBuild(
                    name: value?.name ?? '',
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
          onChanged: (UnitModel? unit) {
            // if (unit != null) {
            //   widget.onChangedUnit(unit);
            // }
          },
          builder: (UnitModel? unit) {
            if (unit != null) {
              return Text(
                unit.name ?? '-',
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
