import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/units/data/repo/units_repo.dart';
import 'package:pos_app/features/units/manager/add_unit_cubit/add_unit_cubit.dart';
import 'package:pos_app/features/units/manager/get_all_units_cubit/get_all_units_cubit.dart';
import 'package:pos_app/features/units/view/widget/unit_data_build.dart';
import 'package:pos_app/generated/l10n.dart';

class AddUnitView extends StatelessWidget {
  const AddUnitView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddUnitCubit(MyServiceLocator.getSingleton<UnitsRepo>()),
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).addUnit),
        body: BlocConsumer<AddUnitCubit, AddUnitState>(
          listener: (context, state) {
            if (state is AddUnitSuccess) {
              GetAllUnitsCubit.get(context).addUnits(state.unit);
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).addedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is AddUnitFailing) {
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
                  MyCustomScrollView(child: AddUnitMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child: AddUnitTabletAndDesktopBody(state: state)),
              desktop: MyCustomScrollView(
                  child: AddUnitTabletAndDesktopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class AddUnitMobileBody extends StatelessWidget {
  const AddUnitMobileBody({
    super.key,
    required this.state,
  });
  final AddUnitState state;
  @override
  Widget build(BuildContext context) {
    return UnitDataBuild(
        autovalidateMode: AddUnitCubit.get(context).autovalidateMode,
        formKey: AddUnitCubit.get(context).formKey,
        nameController: AddUnitCubit.get(context).nameController,
        isLoading: state is AddUnitLoading,
        onPressed: () => AddUnitCubit.get(context).addUnit(),
        isEdit: false);
  }
}

class AddUnitTabletAndDesktopBody extends StatelessWidget {
  const AddUnitTabletAndDesktopBody({super.key, required this.state});
  final AddUnitState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: AddUnitMobileBody(state: state),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }
}
