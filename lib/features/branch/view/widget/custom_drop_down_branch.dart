import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/manager/search_branch_cubit/search_branch_cubit.dart';
import 'package:pos_app/features/branch/view/widget/search_branch_builder.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomDropDownBranch extends StatelessWidget {
  const CustomDropDownBranch({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final BrancheModel? value;
  final void Function(BrancheModel? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getSingleton<SearchBranchCubit>(),
      child: Builder(builder: (context) {
        return CustomDropdown<BrancheModel>(
          // search: true,
          enabled: true,
          hint: S.of(context).selectBranch,
          compareFn: (item1, item2) {
            if (item1.name == null ||
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
          value: value,
          items: SearchBranchCubit.get(context).searchBranches,

          filterFn: (item, filter) {
            return item.name!.toLowerCase().contains(filter.toLowerCase());
          },
          containerBuilder: (p0, p1) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomFormField(
                    hintText: S.of(context).searchBranch,
                    controller: TextEditingController(
                        text: SearchBranchCubit.get(context).query),
                    onChanged: (value) =>
                        SearchBranchCubit.get(context).onChangeSearch(
                      value,
                    ),
                  ),
                ),
                Expanded(
                  child: SearchBranchBuilder(
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
          onChanged: (p0) {},
          builder: (BrancheModel? branch) {
            if (branch != null) {
              return Text(
                branch.name ?? S.of(context).noName,
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
