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
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/data/repo/discounts_repo.dart';
import 'package:pos_app/features/discounts/manager/edit_discount_cubit/edit_discount_cubit.dart';
import 'package:pos_app/features/discounts/manager/get_all_discounts_cubit/get_all_discounts_cubit.dart';
import 'package:pos_app/features/discounts/view/widget/discount_data_build.dart';
import 'package:pos_app/features/discounts/view/widget/show_delete_discount_confirm_dialog.dart';
import 'package:pos_app/generated/l10n.dart';

class EditDiscountView extends StatelessWidget {
  const EditDiscountView({super.key, required this.discount});
  final DiscountModel discount;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditDiscountCubit(
          MyServiceLocator.getSingleton<DiscountsRepo>(), discount),
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).editDiscount,
          actions: [
            CustomTextBtn(
                text: S.of(context).delete,
                onPressed: () async {
                  await showDeleteDiscountConfirmDialog(
                      context: context, discount: discount, goBack: true);
                }),
          ],
        ),
        body: BlocConsumer<EditDiscountCubit, EditDiscountState>(
          listener: (context, state) {
            if (state is EditDiscountSuccess) {
              GetAllDiscountsCubit.get(context).editDiscount(state.discount);

              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).updatedSuccess,
                  state: PopUpState.SUCCESS);
              Navigator.pop(context);
            } else if (state is EditDiscountFailing) {
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
                  child: EditDiscountMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child: EditDiscountTabletAndDesktopBody(state: state)),
              desktop: MyCustomScrollView(
                  child: EditDiscountTabletAndDesktopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class EditDiscountMobileBody extends StatelessWidget {
  const EditDiscountMobileBody({
    super.key,
    required this.state,
  });
  final EditDiscountState state;
  @override
  Widget build(BuildContext context) {
    return DiscountDataBuild(
      autovalidateMode: EditDiscountCubit.get(context).autovalidateMode,
      formKey: EditDiscountCubit.get(context).formKey,
      titleController: EditDiscountCubit.get(context).titleController,
      discountType: EditDiscountCubit.get(context).discountType,
      onChanged: EditDiscountCubit.get(context).onChangeDiscountType,
      value: EditDiscountCubit.get(context).value,
      isLoading: state is EditDiscountLoading,
      onPressed: () => EditDiscountCubit.get(context).editDiscount(),
      isEdit: true,
    );
  }
}

class EditDiscountTabletAndDesktopBody extends StatelessWidget {
  const EditDiscountTabletAndDesktopBody({super.key, required this.state});
  final EditDiscountState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: EditDiscountMobileBody(state: state),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }
}
