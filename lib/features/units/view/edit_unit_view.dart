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
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/data/repo/units_repo.dart';
import 'package:pos_app/features/units/manager/edit_unit_cubit/edit_unit_cubit.dart';
import 'package:pos_app/features/units/manager/get_all_units_cubit/get_all_units_cubit.dart';
import 'package:pos_app/features/units/view/widget/show_delete_unit_confirm_dialog.dart';
import 'package:pos_app/features/units/view/widget/unit_data_build.dart';
import 'package:pos_app/generated/l10n.dart';

class EditUnitView extends StatelessWidget {
  const EditUnitView({super.key, required this.unit});
  final UnitModel unit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditUnitCubit(MyServiceLocator.getSingleton<UnitsRepo>(), unit),
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).editUnit,
          actions: [
            CustomTextBtn(
                text: S.of(context).delete,
                onPressed: () async {
                  await showDeleteUnitConfirmDialog(
                      context: context, unit: unit, goBack: true);
                }),
          ],
        ),
        body: BlocConsumer<EditUnitCubit, EditUnitState>(
          listener: (context, state) {
            if (state is EditUnitSuccess) {
              GetAllUnitsCubit.get(context).updateUnits(state.unit);
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).updatedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is EditUnitFailing) {
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
                  MyCustomScrollView(child: EditUnitMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child: EditUnitTabletAndDesktopBody(state: state)),
              desktop: MyCustomScrollView(
                  child: EditUnitTabletAndDesktopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class EditUnitMobileBody extends StatelessWidget {
  const EditUnitMobileBody({
    super.key,
    required this.state,
  });
  final EditUnitState state;
  @override
  Widget build(BuildContext context) {
    return UnitDataBuild(
      formKey: EditUnitCubit.get(context).formKey,
      autovalidateMode: EditUnitCubit.get(context).autovalidateMode,
      nameController: EditUnitCubit.get(context).nameController,
      isLoading: state is EditUnitLoading,
      onPressed: () => EditUnitCubit.get(context).editUnit(),
      isEdit: true,
    );
  }
}

class EditUnitTabletAndDesktopBody extends StatelessWidget {
  const EditUnitTabletAndDesktopBody({super.key, required this.state});
  final EditUnitState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
            flex: AppConstant.formExpandedTableandMobile,
            child: EditUnitMobileBody(state: state)),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
