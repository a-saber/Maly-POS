import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/discounts/data/repo/discounts_repo.dart';
import 'package:pos_app/features/discounts/manager/add_discount_cubit/add_discount_cubit.dart';
import 'package:pos_app/features/discounts/manager/get_all_discounts_cubit/get_all_discounts_cubit.dart';
import 'package:pos_app/features/discounts/view/widget/discount_data_build.dart';
import 'package:pos_app/generated/l10n.dart';

class AddDiscountView extends StatelessWidget {
  const AddDiscountView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddDiscountCubit(MyServiceLocator.getSingleton<DiscountsRepo>()),
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).addDiscount),
        body: BlocConsumer<AddDiscountCubit, AddDiscountState>(
          listener: (context, state) {
            if (state is AddDiscountSuccess) {
              GetAllDiscountsCubit.get(context).addDiscount(
                state.discount,
              );
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).addedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is AddDiscountFailing) {
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
                  child: AddDiscountMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child: AddDiscountTabletAndDesktopBody(state: state)),
              desktop: MyCustomScrollView(
                  child: AddDiscountTabletAndDesktopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class AddDiscountMobileBody extends StatelessWidget {
  const AddDiscountMobileBody({
    super.key,
    required this.state,
  });
  final AddDiscountState state;
  @override
  Widget build(BuildContext context) {
    return DiscountDataBuild(
        autovalidateMode: AddDiscountCubit.get(context).autovalidateMode,
        formKey: AddDiscountCubit.get(context).formKey,
        titleController: AddDiscountCubit.get(context).titleController,
        // descriptionController:
        //     AddDiscountCubit.get(context).descriptionController,
        onChanged: AddDiscountCubit.get(context).onChangeDiscountType,
        discountType: AddDiscountCubit.get(context).discountType,
        value: AddDiscountCubit.get(context).value,
        isLoading: state is AddDiscountLoading,
        onPressed: () => AddDiscountCubit.get(context).addDiscount(),
        isEdit: false);
  }
}

class AddDiscountTabletAndDesktopBody extends StatelessWidget {
  const AddDiscountTabletAndDesktopBody({super.key, required this.state});
  final AddDiscountState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: AddDiscountMobileBody(state: state),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }
}
