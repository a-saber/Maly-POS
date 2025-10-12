import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/formate_date_time.dart';
import 'package:pos_app/core/helper/is_mobile.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/helper/pick_time.dart';
import 'package:pos_app/core/utils/app_boarder_raduis.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/custom_reset_drop_down_button.dart';
import 'package:pos_app/features/branch/view/widget/custom_drop_down_branch.dart';
import 'package:pos_app/features/discounts/view/widget/custom_drop_down_discount.dart';
import 'package:pos_app/features/products/view/widget/custom_drop_down_product.dart';
import 'package:pos_app/features/sales/data/model/sort_model.dart';
import 'package:pos_app/features/sales/manager/get_sales_cubit/get_sales_cubit.dart';
import 'package:pos_app/features/sales/manager/sales_filter_cubit/sales_filter_cubit.dart';
import 'package:pos_app/features/selling_point/data/model/payment_method_model.dart';
import 'package:pos_app/features/selling_point/data/model/type_of_take_order_model.dart';
import 'package:pos_app/features/taxes/view/widget/custom_drop_down_taxes.dart';
import 'package:pos_app/features/users/view/widget/custom_drop_down_user.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomSalesFilterDrawer extends StatelessWidget {
  const CustomSalesFilterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: BlocBuilder<SalesFilterCubit, SalesFilterState>(
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    S.of(context).salesFilter,
                    style: AppFontStyle.appBarTitle(context: context),
                  ),
                  const SizedBox(height: 20),
                  // Branch
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropDownBranch(
                          value: SalesFilterCubit.get(context).branch,
                          onChanged: SalesFilterCubit.get(context).changeBranch,
                        ),
                      ),
                      CustomResetDropDownButton(
                        onPressed: () =>
                            SalesFilterCubit.get(context).resetBranch(),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),

                  // user
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropDownUser(
                          onChanged: SalesFilterCubit.get(context).changeUser,
                          user: SalesFilterCubit.get(context).user,
                        ),
                      ),
                      CustomResetDropDownButton(
                        onPressed: () =>
                            SalesFilterCubit.get(context).resetUser(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Discount
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropDownDiscount(
                          value: SalesFilterCubit.get(context).discount,
                          onChanged:
                              SalesFilterCubit.get(context).changeDiscount,
                        ),
                      ),
                      CustomResetDropDownButton(
                        onPressed: () =>
                            SalesFilterCubit.get(context).resetDiscount(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Taxes
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropDownTaxes(
                          value: SalesFilterCubit.get(context).taxes,
                          onChange: SalesFilterCubit.get(context).changeTaxes,
                        ),
                      ),
                      CustomResetDropDownButton(
                        onPressed: () =>
                            SalesFilterCubit.get(context).resetTaxes(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Product
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropDownProduct(
                          value: SalesFilterCubit.get(context).product,
                          onChange: SalesFilterCubit.get(context).changeProduct,
                        ),
                      ),
                      CustomResetDropDownButton(
                        onPressed: () =>
                            SalesFilterCubit.get(context).resetProduct(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Type Of Take Order Method
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown<TypeOfTakeOrderModel>(
                          search: true,
                          hint: S.of(context).selectTypeOfTakeOrder,
                          compareFn: (item1, item2) {
                            return (item1.name
                                    .toLowerCase()
                                    .contains(item2.name.toLowerCase()) ||
                                item2.name
                                    .toLowerCase()
                                    .contains(item1.name.toLowerCase()));
                          },
                          value: SalesFilterCubit.get(context).takeOrderModel,
                          items: AppConstant.typesOfTakeOrder(context),
                          filterFn: (item, filter) {
                            return item.name
                                .toLowerCase()
                                .contains(filter.toLowerCase());
                          },
                          onChanged: (TypeOfTakeOrderModel? typeOfOrder) {
                            if (typeOfOrder != null) {
                              SalesFilterCubit.get(context)
                                  .changeOrderType(typeOfOrder);
                            }
                          },
                          builder: (TypeOfTakeOrderModel? typeOfOrder) {
                            if (typeOfOrder != null) {
                              return Text(
                                typeOfOrder.name,
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
                            SalesFilterCubit.get(context).resetOrderType(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Payment Method
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown<PaymentMethodModel>(
                          search: true,
                          hint: S.of(context).selectPaymentMethod,
                          compareFn: (item1, item2) {
                            return (item1.name
                                    .toLowerCase()
                                    .contains(item2.name.toLowerCase()) ||
                                item2.name
                                    .toLowerCase()
                                    .contains(item1.name.toLowerCase()));
                          },
                          value: SalesFilterCubit.get(context).paymentMethod,
                          items: AppConstant.paymentMethods(context),
                          filterFn: (item, filter) {
                            return item.name
                                .toLowerCase()
                                .contains(filter.toLowerCase());
                          },
                          onChanged: (PaymentMethodModel? paymentMethod) {
                            if (paymentMethod != null) {
                              SalesFilterCubit.get(context)
                                  .changePaymentMethod(paymentMethod);
                            }
                          },
                          builder: (PaymentMethodModel? paymentMethod) {
                            if (paymentMethod != null) {
                              return Text(
                                paymentMethod.name,
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
                            SalesFilterCubit.get(context).resetPaymentMethod(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

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
                          value: SalesFilterCubit.get(context).sort,
                          items: AppConstant.sorts(context),
                          filterFn: (item, filter) {
                            return item.name
                                .toLowerCase()
                                .contains(filter.toLowerCase());
                          },
                          onChanged: (SortModel? sortMode) {
                            if (sortMode != null) {
                              SalesFilterCubit.get(context)
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
                            SalesFilterCubit.get(context).resetSort(),
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
                          value: SalesFilterCubit.get(context).sortBy,
                          items: AppConstant.sortsBySales(context),
                          filterFn: (item, filter) {
                            return item.name
                                .toLowerCase()
                                .contains(filter.toLowerCase());
                          },
                          onChanged: (SortByModel? sortByMode) {
                            if (sortByMode != null) {
                              SalesFilterCubit.get(context)
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
                            SalesFilterCubit.get(context).resetSortBy(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // From
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
                            title: SalesFilterCubit.get(context).from == null
                                ? Text(
                                    S.of(context).startDate,
                                    style: AppFontStyle.formText(
                                      context: context,
                                      color: AppColors.grey,
                                    ),
                                  )
                                : Text(
                                    formatedmy(
                                        SalesFilterCubit.get(context).from!),
                                    style: AppFontStyle.formText(
                                      context: context,
                                    ),
                                  ),
                            trailing: Icon(Icons.access_time),
                            onTap: () async {
                              SalesFilterCubit.get(context).chanegFrom(
                                await pickDate(
                                  initalTime:
                                      SalesFilterCubit.get(context).from,
                                  context: context,
                                  endDate: SalesFilterCubit.get(context).to,
                                ),
                              );
                            },
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                          ),
                        ),
                      ),
                      CustomResetDropDownButton(
                        onPressed: () =>
                            SalesFilterCubit.get(context).resetFrom(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // To
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
                            title: SalesFilterCubit.get(context).to == null
                                ? Text(
                                    S.of(context).endDate,
                                    style: AppFontStyle.formText(
                                      context: context,
                                      color: AppColors.grey,
                                    ),
                                  )
                                : Text(
                                    formatedmy(
                                        SalesFilterCubit.get(context).to!),
                                    style: AppFontStyle.formText(
                                      context: context,
                                    ),
                                  ),
                            trailing: Icon(Icons.access_time),
                            onTap: () async {
                              SalesFilterCubit.get(context).changeTo(
                                await pickDate(
                                  initalTime: SalesFilterCubit.get(context).to,
                                  context: context,
                                  startDate: SalesFilterCubit.get(context).from,
                                ),
                              );
                            },
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                          ),
                        ),
                      ),
                      CustomResetDropDownButton(
                        onPressed: () =>
                            SalesFilterCubit.get(context).resetTo(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  CustomFilledBtn(
                      text: S.of(context).filter,
                      onPressed: () {
                        if (SalesFilterCubit.get(context).notValidateSort()) {
                          CustomPopUp.callMyToast(
                              context: context,
                              massage: S.of(context).selectBothSortAndSortBy,
                              state: PopUpState.ERROR);
                          return;
                        }
                        if (SalesFilterCubit.get(context).notVlidateDate()) {
                          CustomPopUp.callMyToast(
                              context: context,
                              massage:
                                  S.of(context).selectBothFromDateAndToDate,
                              state: PopUpState.ERROR);
                          return;
                        }
                        MyServiceLocator.getSingleton<GetSalesCubit>().filter(
                          branch: SalesFilterCubit.get(context).branch,
                          user: SalesFilterCubit.get(context).user,
                          discount: SalesFilterCubit.get(context).discount,
                          taxes: SalesFilterCubit.get(context).taxes,
                          product: SalesFilterCubit.get(context).product,
                          typeOfTakeOrder:
                              SalesFilterCubit.get(context).takeOrderModel,
                          paymentMethod: SalesFilterCubit.get(context)
                              .paymentMethod
                              ?.apiKey,
                          sort: SalesFilterCubit.get(context).sort?.apiKey,
                          sortBy: SalesFilterCubit.get(context).sortBy?.apiKey,
                          from: SalesFilterCubit.get(context).from == null
                              ? null
                              : formatDateyyyymmdd(
                                  SalesFilterCubit.get(context).from!,
                                ),
                          to: SalesFilterCubit.get(context).to == null
                              ? null
                              : formatDateyyyymmdd(
                                  SalesFilterCubit.get(context).to!),
                          context: context,
                        );
                        if (isMobile(context: context)) {
                          Navigator.pop(context);
                        }
                      }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
