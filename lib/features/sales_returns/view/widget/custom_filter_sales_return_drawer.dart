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
import 'package:pos_app/features/sales_returns/manager/get_sales_return_cubit/get_sales_return_cubit.dart';
import 'package:pos_app/features/sales_returns/manager/sales_return_filter_cubit/sales_return_filter_cubit.dart';
import 'package:pos_app/features/selling_point/data/model/payment_method_model.dart';
import 'package:pos_app/features/taxes/view/widget/custom_drop_down_taxes.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomFilterSalesReturnDrawer extends StatelessWidget {
  const CustomFilterSalesReturnDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getSingleton<GetSalesReturnCubit>(),
      child: Builder(builder: (context) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child:
                  BlocBuilder<SalesReturnFilterCubit, SalesReturnFilterState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        S.of(context).salesReturnFilter,
                        style: AppFontStyle.appBarTitle(context: context),
                      ),
                      const SizedBox(height: 20),
                      // Branch
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropDownBranch(
                              value: SalesReturnFilterCubit.get(context).branch,
                              onChanged: SalesReturnFilterCubit.get(context)
                                  .changeBranch,
                            ),
                          ),
                          CustomResetDropDownButton(
                            onPressed: () => SalesReturnFilterCubit.get(context)
                                .resetBranch(),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: CustomDropDownDiscount(
                              onChanged: SalesReturnFilterCubit.get(context)
                                  .changeDiscount,
                              value:
                                  SalesReturnFilterCubit.get(context).discount,
                            ),
                          ),
                          CustomResetDropDownButton(
                            onPressed: () => SalesReturnFilterCubit.get(context)
                                .resetDiscount(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Taxes
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropDownTaxes(
                              onChange: SalesReturnFilterCubit.get(context)
                                  .changeTaxes,
                              value: SalesReturnFilterCubit.get(context).taxes,
                            ),
                          ),
                          CustomResetDropDownButton(
                            onPressed: () => SalesReturnFilterCubit.get(context)
                                .resetTaxes(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Product
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropDownProduct(
                              onChange: SalesReturnFilterCubit.get(context)
                                  .changeProduct,
                              value:
                                  SalesReturnFilterCubit.get(context).product,
                            ),
                          ),
                          CustomResetDropDownButton(
                            onPressed: () => SalesReturnFilterCubit.get(context)
                                .resetOrderType(),
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
                              value: SalesReturnFilterCubit.get(context)
                                  .paymentMethod,
                              items: AppConstant.paymentMethods(context),
                              filterFn: (item, filter) {
                                return item.name
                                    .toLowerCase()
                                    .contains(filter.toLowerCase());
                              },
                              onChanged: (PaymentMethodModel? paymentMethod) {
                                if (paymentMethod != null) {
                                  SalesReturnFilterCubit.get(context)
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
                            onPressed: () => SalesReturnFilterCubit.get(context)
                                .resetPaymentMethod(),
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
                              value: SalesReturnFilterCubit.get(context).sort,
                              items: AppConstant.sorts(context),
                              filterFn: (item, filter) {
                                return item.name
                                    .toLowerCase()
                                    .contains(filter.toLowerCase());
                              },
                              onChanged: (SortModel? sortMode) {
                                if (sortMode != null) {
                                  SalesReturnFilterCubit.get(context)
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
                                SalesReturnFilterCubit.get(context).resetSort(),
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
                              value: SalesReturnFilterCubit.get(context).sortBy,
                              items: AppConstant.sortsBySales(context),
                              filterFn: (item, filter) {
                                return item.name
                                    .toLowerCase()
                                    .contains(filter.toLowerCase());
                              },
                              onChanged: (SortByModel? sortByMode) {
                                if (sortByMode != null) {
                                  SalesReturnFilterCubit.get(context)
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
                            onPressed: () => SalesReturnFilterCubit.get(context)
                                .resetSortBy(),
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
                                visualDensity: VisualDensity(
                                    vertical: -4), // تقليل الارتفاع
                                title: SalesReturnFilterCubit.get(context)
                                            .from ==
                                        null
                                    ? Text(
                                        S.of(context).startDate,
                                        style: AppFontStyle.formText(
                                          context: context,
                                          color: AppColors.grey,
                                        ),
                                      )
                                    : Text(
                                        formatedmy(
                                            SalesReturnFilterCubit.get(context)
                                                .from!),
                                        style: AppFontStyle.formText(
                                          context: context,
                                        ),
                                      ),
                                trailing: Icon(Icons.access_time),
                                onTap: () async {
                                  SalesReturnFilterCubit.get(context)
                                      .chanegFrom(
                                    await pickDate(
                                      initalTime:
                                          SalesReturnFilterCubit.get(context)
                                              .from,
                                      context: context,
                                      endDate:
                                          SalesReturnFilterCubit.get(context)
                                              .to,
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
                                SalesReturnFilterCubit.get(context).resetFrom(),
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
                                visualDensity: VisualDensity(
                                    vertical: -4), // تقليل الارتفاع
                                title: SalesReturnFilterCubit.get(context).to ==
                                        null
                                    ? Text(
                                        S.of(context).endDate,
                                        style: AppFontStyle.formText(
                                          context: context,
                                          color: AppColors.grey,
                                        ),
                                      )
                                    : Text(
                                        formatedmy(
                                            SalesReturnFilterCubit.get(context)
                                                .to!),
                                        style: AppFontStyle.formText(
                                          context: context,
                                        ),
                                      ),
                                trailing: Icon(Icons.access_time),
                                onTap: () async {
                                  SalesReturnFilterCubit.get(context).changeTo(
                                    await pickDate(
                                      initalTime:
                                          SalesReturnFilterCubit.get(context)
                                              .to,
                                      context: context,
                                      startDate:
                                          SalesReturnFilterCubit.get(context)
                                              .from,
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
                                SalesReturnFilterCubit.get(context).resetTo(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      CustomFilledBtn(
                          text: S.of(context).filter,
                          onPressed: () {
                            if (SalesReturnFilterCubit.get(context)
                                .notValidateSort()) {
                              CustomPopUp.callMyToast(
                                  context: context,
                                  massage:
                                      S.of(context).selectBothSortAndSortBy,
                                  state: PopUpState.ERROR);
                              return;
                            }
                            if (SalesReturnFilterCubit.get(context)
                                .notVlidateDate()) {
                              CustomPopUp.callMyToast(
                                  context: context,
                                  massage:
                                      S.of(context).selectBothFromDateAndToDate,
                                  state: PopUpState.ERROR);
                              return;
                            }
                            GetSalesReturnCubit.get(context).filter(
                              typeOfTakeOrder:
                                  SalesReturnFilterCubit.get(context)
                                      .typeOfOrder,
                              branch:
                                  SalesReturnFilterCubit.get(context).branch,
                              user: SalesReturnFilterCubit.get(context).user,
                              discount:
                                  SalesReturnFilterCubit.get(context).discount,
                              taxes: SalesReturnFilterCubit.get(context).taxes,
                              product:
                                  SalesReturnFilterCubit.get(context).product,
                              paymentMethod: SalesReturnFilterCubit.get(context)
                                  .paymentMethod
                                  ?.apiKey,
                              sort: SalesReturnFilterCubit.get(context)
                                  .sort
                                  ?.apiKey,
                              sortBy: SalesReturnFilterCubit.get(context)
                                  .sortBy
                                  ?.apiKey,
                              from: SalesReturnFilterCubit.get(context).from ==
                                      null
                                  ? null
                                  : formatDateyyyymmdd(
                                      SalesReturnFilterCubit.get(context).from!,
                                    ),
                              to: SalesReturnFilterCubit.get(context).to == null
                                  ? null
                                  : formatDateyyyymmdd(
                                      SalesReturnFilterCubit.get(context).to!),
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
      }),
    );
  }
}
