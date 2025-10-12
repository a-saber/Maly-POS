import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/formate_date_time.dart';
import 'package:pos_app/core/helper/is_mobile.dart';
import 'package:pos_app/core/helper/pick_time.dart';
import 'package:pos_app/core/utils/app_boarder_raduis.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/custom_reset_drop_down_button.dart';
import 'package:pos_app/features/branch/view/widget/custom_drop_down_branch.dart';
import 'package:pos_app/features/categories/view/widget/custom_drop_down_category.dart';
import 'package:pos_app/features/products/view/widget/custom_drop_down_product.dart';
import 'package:pos_app/features/sales/data/model/sort_model.dart';
import 'package:pos_app/features/store_move/data/model/type_of_movement_model.dart';
import 'package:pos_app/features/store_move/manager/filter_store_move_cubit/filter_store_move_cubit.dart';
import 'package:pos_app/features/store_move/manager/store_move_cubit/store_move_cubit.dart';
import 'package:pos_app/features/units/view/widget/custom_drop_down_unit.dart';
import 'package:pos_app/features/users/view/widget/custom_drop_down_user.dart';
import 'package:pos_app/generated/l10n.dart';

class CutsomStoreMoveDrawer extends StatelessWidget {
  const CutsomStoreMoveDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<FilterStoreMoveCubit, FilterStoreMoveState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  S.of(context).storeMoveFilter,
                  style: AppFontStyle.appBarTitle(context: context),
                ),
                SizedBox(height: 20),

                // Category
                Row(
                  children: [
                    Expanded(
                      child: CustomDropDownCategory(
                        value: FilterStoreMoveCubit.get(context).category,
                        onChangedCategory:
                            FilterStoreMoveCubit.get(context).changeCategory,
                      ),
                    ),
                    CustomResetDropDownButton(
                      onPressed: () => FilterStoreMoveCubit.get(context)
                          .changeCategory(null),
                    )
                  ],
                ),
                SizedBox(height: 15),

                // Product
                Row(
                  children: [
                    Expanded(
                      child: CustomDropDownProduct(
                        onChange:
                            FilterStoreMoveCubit.get(context).changeProduct,
                        value: FilterStoreMoveCubit.get(context).product,
                      ),
                    ),
                    CustomResetDropDownButton(
                      onPressed: () =>
                          FilterStoreMoveCubit.get(context).changeProduct(null),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                // Unit
                Row(
                  children: [
                    Expanded(
                      child: CustomDropDownUnit(
                        onChanged: FilterStoreMoveCubit.get(context).changeUnit,
                        value: FilterStoreMoveCubit.get(context).unit,
                      ),
                    ),
                    CustomResetDropDownButton(
                      onPressed: () =>
                          FilterStoreMoveCubit.get(context).changeUnit(null),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                //  User
                Row(
                  children: [
                    Expanded(
                      child: CustomDropDownUser(
                        onChanged: FilterStoreMoveCubit.get(context).changeUser,
                        user: FilterStoreMoveCubit.get(context).user,
                      ),
                    ),
                    CustomResetDropDownButton(
                      onPressed: () =>
                          FilterStoreMoveCubit.get(context).changeUser(null),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Branch
                Row(
                  children: [
                    Expanded(
                      child: CustomDropDownBranch(
                        value: FilterStoreMoveCubit.get(context).branch,
                        onChanged:
                            FilterStoreMoveCubit.get(context).changeBranch,
                      ),
                    ),
                    CustomResetDropDownButton(
                      onPressed: () =>
                          FilterStoreMoveCubit.get(context).changeBranch(null),
                    )
                  ],
                ),
                SizedBox(height: 15),

                // Type of movement
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown<TypeOfMovementModel>(
                        search: true,
                        hint: S.of(context).selectTypeOfMove,
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
                        value: FilterStoreMoveCubit.get(context).typeOfmove,
                        items: AppConstant.typeOfMovements(context),
                        filterFn: (item, filter) {
                          return item.name!
                              .toLowerCase()
                              .contains(filter.toLowerCase());
                        },
                        onChanged: (TypeOfMovementModel? typeOfmove) {
                          if (typeOfmove != null) {
                            FilterStoreMoveCubit.get(context)
                                .changeTypeOfmove(typeOfmove);
                          }
                        },
                        builder: (TypeOfMovementModel? typeOfmove) {
                          if (typeOfmove != null) {
                            return Text(
                              typeOfmove.name ?? S.of(context).noName,
                              style: AppFontStyle.formText(
                                context: context,
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                    CustomResetDropDownButton(
                      onPressed: () => FilterStoreMoveCubit.get(context)
                          .changeTypeOfmove(null),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Sort
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown<SortModel>(
                        search: true,
                        hint: S.of(context).selectSort,
                        compareFn: (item1, item2) {
                          return (item1.name
                                  .toLowerCase()
                                  .contains(item2.name.toLowerCase()) ||
                              item2.name
                                  .toLowerCase()
                                  .contains(item1.name.toLowerCase()));
                        },
                        value: FilterStoreMoveCubit.get(context).sort,
                        items: AppConstant.sorts(context),
                        filterFn: (item, filter) {
                          return item.name
                              .toLowerCase()
                              .contains(filter.toLowerCase());
                        },
                        onChanged: (SortModel? sortMode) {
                          if (sortMode != null) {
                            FilterStoreMoveCubit.get(context)
                                .changeSort(sortMode);
                          }
                        },
                        builder: (SortModel? sortMode) {
                          if (sortMode != null) {
                            return Text(
                              sortMode.name,
                              style: AppFontStyle.formText(
                                context: context,
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                    CustomResetDropDownButton(
                      onPressed: () =>
                          FilterStoreMoveCubit.get(context).changeSort(
                        null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Sort By
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown<SortByModel>(
                        search: true,
                        hint: S.of(context).selectSortBy,
                        compareFn: (item1, item2) {
                          return (item1.name
                                  .toLowerCase()
                                  .contains(item2.name.toLowerCase()) ||
                              item2.name
                                  .toLowerCase()
                                  .contains(item1.name.toLowerCase()));
                        },
                        value: FilterStoreMoveCubit.get(context).sortBy,
                        items: AppConstant.sortsByMovements(context),
                        filterFn: (item, filter) {
                          return item.name
                              .toLowerCase()
                              .contains(filter.toLowerCase());
                        },
                        onChanged: (SortByModel? sortByMode) {
                          if (sortByMode != null) {
                            FilterStoreMoveCubit.get(context)
                                .changeSortBy(sortByMode);
                          }
                        },
                        builder: (SortByModel? sortByMode) {
                          if (sortByMode != null) {
                            return Text(
                              sortByMode.name,
                              style: AppFontStyle.formText(
                                context: context,
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                    CustomResetDropDownButton(
                      onPressed: () =>
                          FilterStoreMoveCubit.get(context).changeSortBy(null),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomFormField(
                  controller:
                      FilterStoreMoveCubit.get(context).quantityMinController,
                  labelText: S.of(context).minimumQuantity,
                ),
                const SizedBox(height: 15),
                CustomFormField(
                  controller:
                      FilterStoreMoveCubit.get(context).quantityMaxController,
                  labelText: S.of(context).maximumQuantity,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: AppBordersRaduis.btn,
                        ),
                        child: ListTile(
                          visualDensity:
                              VisualDensity(vertical: -4), // تقليل الارتفاع
                          title: FilterStoreMoveCubit.get(context).startDate ==
                                  null
                              ? Text(
                                  S.of(context).startDate,
                                  style: AppFontStyle.formText(
                                    context: context,
                                    color: AppColors.grey,
                                  ),
                                )
                              : Text(
                                  formatedmy(FilterStoreMoveCubit.get(context)
                                      .startDate!),
                                  style: AppFontStyle.formText(
                                    context: context,
                                  ),
                                ),
                          trailing: Icon(Icons.access_time),
                          onTap: () async {
                            FilterStoreMoveCubit.get(context).changeStartDate(
                              await pickDate(
                                  initalTime: FilterStoreMoveCubit.get(context)
                                      .startDate,
                                  context: context,
                                  endDate: FilterStoreMoveCubit.get(context)
                                      .endDate),
                            );
                          },
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        FilterStoreMoveCubit.get(context).changeStartDate(null);
                      },
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.error,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: AppBordersRaduis.btn,
                        ),
                        child: ListTile(
                          visualDensity:
                              VisualDensity(vertical: -4), // تقليل الارتفاع
                          title: FilterStoreMoveCubit.get(context).endDate ==
                                  null
                              ? Text(
                                  S.of(context).endDate,
                                  style: AppFontStyle.formText(
                                    context: context,
                                    color: AppColors.grey,
                                  ),
                                )
                              : Text(
                                  formatedmy(FilterStoreMoveCubit.get(context)
                                      .endDate!),
                                  style: AppFontStyle.formText(
                                    context: context,
                                  ),
                                ),
                          trailing: Icon(Icons.access_time),
                          onTap: () async {
                            FilterStoreMoveCubit.get(context).changeEndDate(
                              await pickDate(
                                initalTime:
                                    FilterStoreMoveCubit.get(context).endDate,
                                context: context,
                                startDate:
                                    FilterStoreMoveCubit.get(context).startDate,
                              ),
                            );
                          },
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        FilterStoreMoveCubit.get(context).changeEndDate(null);
                      },
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.error,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 25),
                CustomFilledBtn(
                  text: S.of(context).filter,
                  onPressed: () {
                    if (FilterStoreMoveCubit.get(context)
                        .notValidateSortAndSortBy()) {
                      CustomPopUp.callMyToast(
                        context: context,
                        massage: S.of(context).selectBothSortAndSortBy,
                        state: PopUpState.ERROR,
                      );
                      return;
                    }
                    if (FilterStoreMoveCubit.get(context).notValidateDate()) {
                      CustomPopUp.callMyToast(
                        context: context,
                        massage: S.of(context).selectBothFromDateAndToDate,
                        state: PopUpState.ERROR,
                      );
                      return;
                    }
                    if (FilterStoreMoveCubit.get(context)
                        .notValidateQuantity()) {
                      CustomPopUp.callMyToast(
                        context: context,
                        massage:
                            S.of(context).selectBothMinimumAndMaximumQuantity,
                        state: PopUpState.ERROR,
                      );
                      return;
                    }
                    StoreMoveCubit.get(context).filterData(
                      category: FilterStoreMoveCubit.get(context).category,
                      product: FilterStoreMoveCubit.get(context).product,
                      unit: FilterStoreMoveCubit.get(context).unit,
                      user: FilterStoreMoveCubit.get(context).user,
                      branch: FilterStoreMoveCubit.get(context).branch,
                      typeOfmove: FilterStoreMoveCubit.get(context).typeOfmove,
                      startDate:
                          FilterStoreMoveCubit.get(context).startDate == null
                              ? null
                              : formatDateyyyymmddHHMMSS(
                                  FilterStoreMoveCubit.get(context).startDate!),
                      endDate: FilterStoreMoveCubit.get(context).endDate == null
                          ? null
                          : formatDateyyyymmddHHMMSS(
                              FilterStoreMoveCubit.get(context).endDate!),
                      sortBy: FilterStoreMoveCubit.get(context).sortBy?.apiKey,
                      sortOrder: FilterStoreMoveCubit.get(context).sort?.apiKey,
                      quantityMin: FilterStoreMoveCubit.get(context)
                          .quantityMinController
                          .text,
                      quantityMax: FilterStoreMoveCubit.get(context)
                          .quantityMaxController
                          .text,
                    );

                    if (isMobile(context: context)) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
