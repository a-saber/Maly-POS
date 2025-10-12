import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/cache/custom_user_hive_box.dart';
import 'package:pos_app/core/constant/device_size.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

void selectBranch({
  required BuildContext context,
  bool selectBranch = false,
}) {
  if (MyServiceLocator.getSingleton<SellingPointProductCubit>().repo.branch !=
          null &&
      !selectBranch) {
    return;
  }
  if (CustomUserHiveBox.getUser().branches!.length == 1) {
    MyServiceLocator.getSingleton<SellingPointProductCubit>()
        .onChangeBranche(CustomUserHiveBox.getUser().branches!.first);
    return;
  }
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => SizedBox(
      width: DeviceSize.getWidth(context: context) * 0.5,
      child: AlertDialog(
        title: Text(
          S.of(context).selectBranch,
          style: AppFontStyle.appBarTitleSmall(context: context),
        ),
        content: BlocProvider.value(
          value: MyServiceLocator.getSingleton<SellingPointProductCubit>(),
          child: Builder(builder: (context) {
            return BlocBuilder<SellingPointProductCubit,
                SellingPointProductState>(
              builder: (context, state) {
                return CustomDropdown<BrancheModel>(
                  hint: S.of(context).selectBranch,
                  search: true,
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
                  value:
                      MyServiceLocator.getSingleton<SellingPointProductCubit>()
                          .repo
                          .branch,
                  items: CustomUserHiveBox.getUser().branches ?? [],
                  filterFn: (item, filter) {
                    return item.name!
                        .toLowerCase()
                        .contains(filter.toLowerCase());
                  },
                  onChanged: (BrancheModel? branch) {
                    if (branch != null) {
                      MyServiceLocator.getSingleton<SellingPointProductCubit>()
                          .onChangeBranche(branch);
                    }
                  },
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
              },
            );
          }),
        ),
        actions: [
          BlocProvider.value(
            value: MyServiceLocator.getSingleton<SellingPointProductCubit>(),
            child: Builder(builder: (context) {
              return BlocBuilder<SellingPointProductCubit,
                  SellingPointProductState>(
                builder: (context, state) {
                  return CustomFilledBtn(
                    text: S.of(context).select,
                    onPressed: MyServiceLocator.getSingleton<
                                    SellingPointProductCubit>()
                                .repo
                                .branch ==
                            null
                        ? () {
                            CustomPopUp.callMyToast(
                              context: context,
                              massage: S.of(context).selectBranch,
                              state: PopUpState.ERROR,
                            );
                          }
                        : () {
                            Navigator.pop(context);
                          },
                  );
                },
              );
            }),
          )
        ],
      ),
    ),
  );
}
