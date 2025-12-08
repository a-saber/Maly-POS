import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/products/data/model/update_product_model.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';
import 'package:pos_app/features/products/manager/add_product_cubit/add_product_cubit.dart';
import 'package:pos_app/features/units/view/widget/custom_drop_down_unit.dart';
import 'package:pos_app/generated/l10n.dart';
import '../../../core/helper/my_form_validators.dart';
import '../../../core/utils/app_padding.dart';
import '../../../core/widget/custom_drop_down.dart';
import '../../../core/widget/custom_loading.dart';
import '../../../core/widget/custom_reset_drop_down_button.dart';
import '../../../core/widget/image_manager_view.dart';
import '../../branch/view/widget/custom_drop_down_branch.dart';
import '../../categories/data/repo/category_repo.dart';
import '../../categories/view/widget/custom_drop_down_category.dart';
import '../../selling_point/manager/selling_point_cubit/selling_point_cubit.dart';
import '../../taxes/view/widget/custom_drop_down_taxes.dart';
import '../../units/data/repo/units_repo.dart';
import '../data/model/product_type.dart';
import '../manager/get_all_products_cubit/get_all_products_cubit.dart';

class AddProductDataView2 extends StatefulWidget {
  const AddProductDataView2({super.key});

  @override
  State<AddProductDataView2> createState() => _AddProductDataView2State();
}

class _AddProductDataView2State extends State<AddProductDataView2> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProductCubit, AddProductState>(
      listener: (context, state) {
        if (state is UpdateProductUnitsCostWarning) {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text(
                  "The New Cost Of Simple Unit is ${state.myCost / state.factory} ",
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomTextBtn(
                          text: S.of(context).cancel,
                          textColor: AppColors.primary,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      CustomTextBtn(
                          text: S.of(context).done,
                          onPressed: () {
                            // AddProductCubit.get(context).onChangeCost(
                            //     state.index,
                            //     changeCostToAll: true,
                            //     cost: (state.myCost / state.factory));
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                ],
              );
            },
          );
        }
      },
      builder: (context, state) {
        var cubit = AddProductCubit.get(context);
        return SafeArea(

          child: Form(
              key: cubit.formKey,
              autovalidateMode: cubit.autovalidateMode,
              child: Padding(
                padding: AppPaddings.defaultView,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ImageManagerView(
                      onSelected: (image) =>
                          AddProductCubit.get(context).image = image,
                      imageUrl: null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomFormField(
                      controller: cubit.nameController,
                      labelText: S.of(context).name,
                      validator: (value) => MyFormValidators.validateRequired(
                          value,
                          context: context),
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomFormField(
                      controller: cubit.descriptionController,
                      labelText: S.of(context).description,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomDropDownCategory(
                      value: cubit.category,
                      onChangedCategory: (category) => AddProductCubit.get(context).onChangeCategory(category),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomDropdown<ProductType>(
                      search: true,
                      hint: S.of(context).selectProductType,
                      compareFn: (item1, item2) {
                        if (item1.name.isEmpty || item2.name.isEmpty) {
                          return false;
                        } else {
                          return (item1.name
                                  .toLowerCase()
                                  .contains(item2.name.toLowerCase()) ||
                              item2.name
                                  .toLowerCase()
                                  .contains(item1.name.toLowerCase()));
                        }
                      },
                      value: cubit.productType,
                      items: AppConstant.producttype(context),
                      validator: (value) =>
                          MyFormValidators.validateTypeRequired<ProductType>(
                        value,
                        context: context,
                      ),
                      onChanged: (value) {
                        cubit.onChangeProductType(value);
                      },
                      builder: (ProductType? tax) {
                        if (tax != null) {
                          return Text(
                            tax.name,
                            style: AppFontStyle.formText(
                              context: context,
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomFormField(
                      controller: cubit.brandController,
                      labelText: S.of(context).brand,
                      keyboardType: TextInputType.text,
                      // validator: (value) =>
                      //     MyFormValidators.validateRequired(value, context: context),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropDownTaxes(
                            value: cubit.taxes,
                            onChange: cubit.onChangeTaxes,
                          ),
                        ),
                        CustomResetDropDownButton(
                          onPressed: () {
                            cubit.onChangeTaxes(null);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الوحدات',
                          style: AppFontStyle.formText(context: context),
                        ),
                        CustomTextBtn(
                          text: "اضافة",
                          textColor: AppColors.primary,
                          onPressed: cubit.addProductUnits,
                        ),
                      ],
                    ),
                    Builder(builder: (context) {
                      final ScrollController controller = ScrollController();

                      return Scrollbar(
                        controller: controller,
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            dataRowHeight: 80,
                            border: TableBorder.all(color: Colors.grey),
                            // decoration: const BoxDecoration(color: Colors.black12),
                            columns: const [
                              DataColumn(label: Text('الوحدة')),
                              DataColumn(label: Text('المعامل')),
                              DataColumn(label: Text('سعر التكلفة')),
                              DataColumn(label: Text('اقل سعر بيع')),
                              DataColumn(label: Text('اقل سعر بيع بالضريبة')),
                              DataColumn(label: Text('سعر البيع')),
                              DataColumn(label: Text('سعر البيع بالضريبة')),
                              DataColumn(label: Text('الباركود')),
                              DataColumn(label: Text('باركود الميزان')),
                              DataColumn(label: Text('الكميات الافتتاحية')),
                              DataColumn(label: Text('حذف')),
                            ],
                            rows:
                                List.generate(cubit.productUnits.length, (index) {
                              return DataRow(
                                cells: [
                                  // unit
                                  DataCell(
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: SizedBox(
                                          width: 150,
                                          child: CustomDropDownUnit(
                                            value: cubit.productUnits[index].unit,
                                            onChanged: (unit) {
                                              if (unit != null) {
                                                cubit.onUnitChanged(unitModel: unit, index: index);
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //factor
                                  DataCell(customTextFormFieldTable(
                                    hintText: "المعامل",
                                    enabled: index != 0,
                                    validator: (value) =>
                                        MyFormValidators.validateInteger(value,
                                            context: context, validate: true),
                                    controller: cubit
                                        .productUnits[index].factoryController,
                                    onChanged: (value) {
                                      cubit.updateUnitPrices(index);
                                    },
                                  )),
                                  DataCell(customTextFormFieldTable(
                                      hintText: "سعر التكلفة",
                                      validator: (value) =>
                                          MyFormValidators.validateDoublePrice(
                                              value,
                                              context: context,
                                              validateEmpty: true),
                                      controller: cubit.productUnits[index]
                                          .costPriceController,
                                      onChanged: (value) {
                                        if (index == 0) {
                                          cubit.onChangeCost(0);
                                        }
                                      })),

                                  DataCell(
                                    customTextFormFieldTable(
                                      hintText: "اقل سعر بيع",
                                      controller: cubit.productUnits[index]
                                          .minPriceWithoutTaxController,
                                      validator: (value) =>
                                          MyFormValidators.validateDoublePrice(
                                        value,
                                        context: context,
                                        haveMin: true,
                                        min: double.tryParse(cubit
                                                .productUnits[index]
                                                .costPriceController
                                                ?.text ??
                                            ''),
                                      ),
                                      onChanged: (newValue) {
                                        cubit.onChangeMinPriceWithoutTax(
                                            index: index, newValue: newValue);
                                        if (index == 0) {
                                          cubit.onChangeCost(0);
                                        }
                                      },
                                    ),
                                  ),

                                  DataCell(
                                    customTextFormFieldTable(
                                      hintText: "اقل سعر بيع بالضريبة",
                                      controller: cubit.productUnits[index]
                                          .minPriceWithTaxController,
                                      validator: (value) =>
                                          MyFormValidators.validateDoublePrice(
                                        value,
                                        context: context,
                                        haveMin: true,
                                        min: double.tryParse(cubit
                                                .productUnits[index]
                                                .minPriceWithoutTaxController
                                                ?.text ??
                                            ''),
                                      ),
                                      onChanged: (newValue) {
                                        if (cubit
                                                .productUnits[index]
                                                .minPriceWithTaxController!
                                                .text !=
                                            newValue) {
                                          cubit
                                              .productUnits[index]
                                              .minPriceWithTaxController!
                                              .text = newValue;
                                        }
                                        cubit.onChangeMinPriceWithTax(
                                            index: index, newValue: newValue);
                                        if (index == 0) {
                                          cubit.onChangeCost(0);
                                        }
                                      },
                                    ),
                                  ),

                                  // سعر البيع بدون الضريبة
                                  DataCell(
                                    customTextFormFieldTable(
                                      hintText: "سعر البيع",
                                      controller: cubit.productUnits[index]
                                          .salePriceWithoutTaxController,
                                      validator: (value) =>
                                          MyFormValidators.validateDoublePrice(
                                        value,
                                        context: context,
                                        haveMin: true,
                                        min: double.tryParse(cubit
                                                .productUnits[index]
                                                .minPriceWithoutTaxController
                                                ?.text ??
                                            ''),
                                      ),
                                      onChanged: (newValue) {
                                        if (cubit
                                                .productUnits[index]
                                                .salePriceWithoutTaxController!
                                                .text !=
                                            newValue) {
                                          cubit
                                              .productUnits[index]
                                              .salePriceWithoutTaxController!
                                              .text = newValue;
                                        }
                                        cubit.changeSalePriceWithoutTax(
                                            cubit.productUnits[index]);
                                        if (index == 0) {
                                          cubit.onChangeCost(0);
                                        }
                                      },
                                    ),
                                  ),

                                  DataCell(
                                    customTextFormFieldTable(
                                      hintText: "سعر البيع بالضريبة",
                                      controller: cubit.productUnits[index]
                                          .salePriceWithTaxController,
                                      validator: (value) =>
                                          MyFormValidators.validateDoublePrice(
                                        value,
                                        context: context,
                                        haveMin: true,
                                        min: double.tryParse(cubit
                                                .productUnits[index]
                                                .salePriceWithoutTaxController
                                                ?.text ??
                                            ''),
                                      ),
                                      onChanged: (newValue) {
                                        if (cubit
                                                .productUnits[index]
                                                .salePriceWithTaxController!
                                                .text !=
                                            newValue) {
                                          cubit
                                              .productUnits[index]
                                              .salePriceWithTaxController!
                                              .text = newValue;
                                        }
                                        cubit.changeSalePriceWithTax(
                                            cubit.productUnits[index]);
                                        if (index == 0) {
                                          cubit.onChangeCost(0);
                                        }
                                      },
                                    ),
                                  ),

                                  DataCell(customTextFormFieldTable(
                                    hintText: "الباركود",
                                    validator: null,
                                    controller: cubit
                                        .productUnits[index].barCodeController,
                                    onChanged: (p0) {},
                                  )),
                                  DataCell(customTextFormFieldTable(
                                    hintText: "باركود الميزان",
                                    validator: null,
                                    controller: cubit.productUnits[index]
                                        .scaleBarcodeController,
                                    onChanged: (p0) {},
                                  )),
                                  DataCell(
                                    CustomTextBtn(
                                      text: "اضافة كمية",
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            List<BranchQuantity>
                                                tempBranchQuantities = [];
                                            for (int i = 0;
                                                i <
                                                    cubit.productUnits[index]
                                                        .branchQty.length;
                                                i++) {
                                              tempBranchQuantities.add(
                                                  BranchQuantity.from(cubit
                                                      .productUnits[index]
                                                      .branchQty[i]));
                                            }

                                            return StatefulBuilder(
                                              builder: (ctx, setState) =>
                                                  AlertDialog(
                                                title: Column(
                                                  spacing: 10,
                                                  children: [
                                                    Text("اضافة كمية افتتاحية"),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        CustomTextBtn(
                                                          text: "اضافة",
                                                          textColor:
                                                              AppColors.primary,
                                                          onPressed: () {
                                                            setState(() {
                                                              tempBranchQuantities
                                                                  .add(
                                                                BranchQuantity(
                                                                  branchId: null,
                                                                  branch: null,
                                                                  qunantity: 0,
                                                                  quantityController:
                                                                      TextEditingController(),
                                                                ),
                                                              );
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    ...List.generate(
                                                      tempBranchQuantities.length,
                                                      (index) {
                                                        return Row(
                                                          spacing: 5,
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child:
                                                                  CustomDropDownBranch(
                                                                      value: tempBranchQuantities[
                                                                              index]
                                                                          .branch,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          if (value !=
                                                                              null) {
                                                                            tempBranchQuantities[index].branch =
                                                                                BrancheModel.from(value);
                                                                          }
                                                                        });
                                                                      }),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  CustomFormField(
                                                                hintText:
                                                                    "الكمية",
                                                                controller:
                                                                    tempBranchQuantities[
                                                                            index]
                                                                        .quantityController,
                                                                validator: (value) =>
                                                                    MyFormValidators
                                                                        .validateInteger(
                                                                            value,
                                                                            context:
                                                                                context),
                                                                onChanged:
                                                                    (p0) {},
                                                              ),
                                                            ),
                                                            IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    tempBranchQuantities
                                                                        .removeAt(
                                                                            index);
                                                                  });
                                                                },
                                                                icon: Icon(Icons
                                                                    .cancel_outlined))
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      CustomTextBtn(
                                                        text: "اغلاق",
                                                        textColor:
                                                            AppColors.primary,
                                                        onPressed: () =>
                                                            Navigator.pop(ctx),
                                                      ),
                                                      CustomTextBtn(
                                                        text: "حفظ",
                                                        textColor:
                                                            AppColors.primary,
                                                        onPressed: () {
                                                          cubit.assignBranchQty(
                                                              index: index,
                                                              branchQuantities:
                                                                  tempBranchQuantities);
                                                          Navigator.pop(ctx);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: AppColors.error),
                                      onPressed: index == 0
                                          ? null
                                          : () => cubit.removeProductUnit(
                                              index: index),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    Builder(builder: (context) {
                      if (state is AddProductLoading) {
                        return const CustomLoading();
                      }
                      return CustomFilledBtn(
                          text: S.of(context).add, onPressed: cubit.addProduct);
                    }),
                  ],
                ),
              )),
        );
      },
    );
  }

  Padding customTextFormFieldTable({
    required String hintText,
    double width = 150,
    required TextEditingController? controller,
    required String? Function(String?)? validator,
    required void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
    bool enabled = true,
    String? initialValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3,
      ),
      child: SizedBox(
        width: width,
        child: CustomFormField(
          enabled: enabled,
          initialValue: initialValue,
          controller: controller,
          hintText: hintText,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
        ),
      ),
    );
  }
}

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddProductCubit(
          MyServiceLocator.getSingleton<ProductsRepo>(),
        unitsRepo: MyServiceLocator.getSingleton<UnitsRepo>(),
        categoryRepo: MyServiceLocator.getSingleton<CategoryRepo>(),
      ),
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).addProduct),
        body: BlocConsumer<AddProductCubit, AddProductState>(
          listener: (context, state) {
            if (state is AddProductSuccess) {
              //  TODO : Will Add Update Product Moel Selling Point
               GetAllProductsCubit.get(context).addProduct(state.product!);
              // TODO : Will Give Update Product Model Selling Point
               MyServiceLocator.getSingleton<SellingPointCubit>().addProduct(state.product!);
                CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).addedSuccess,
                  state: PopUpState.SUCCESS);

              Navigator.pop(context);
            } else if (state is AddProductFailing) {
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
                  MyCustomScrollView(child: AddProductMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child: AddProductTabletAndDesktopBody(state: state)),
              desktop: MyCustomScrollView(child: AddProductTabletAndDesktopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class AddProductMobileBody extends StatelessWidget {
  const AddProductMobileBody({
    super.key,
    required this.state,
  });
  final AddProductState state;
  @override
  Widget build(BuildContext context) {
    return AddProductDataView2();
    //   BlocConsumer<AddProductCubit, AddProductState>(
    //   listener: (context, state) {
    //     if (state is UpdateProductUnitsCostWarning) {
    //       showDialog(
    //         context: context,
    //         builder: (ctx) {
    //           return AlertDialog(
    //             title: Text(
    //               "The New Cost Of Simple Unit is ${state.myCost / state.factory} ",
    //             ),
    //             actions: [
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.end,
    //                 children: [
    //                   CustomTextBtn(
    //                       text: S.of(context).cancel,
    //                       textColor: AppColors.primary,
    //                       onPressed: () {
    //                         Navigator.pop(context);
    //                       }),
    //                   CustomTextBtn(
    //                       text: S.of(context).done,
    //                       onPressed: () {
    //                         AddProductCubit.get(context).onChangeCost(
    //                             state.index,
    //                             changeCostToAll: true,
    //                             cost: (state.myCost / state.factory));
    //                         Navigator.pop(context);
    //                       }),
    //                 ],
    //               ),
    //             ],
    //           );
    //         },
    //       );
    //     }
    //   },
    //   builder: (context, state) {
    //     return ProductDataBuilder(
    //       baseCost: AddProductCubit.get(context).baseCost,
    //       onChangeCost: AddProductCubit.get(context).onChangeCost,
    //       addProductUnit: AddProductCubit.get(context).addProductUnits,
    //       changeMinPriceWithoutTaxes:
    //           AddProductCubit.get(context).changeMinPriceWithoutTaxes,
    //       changeSalePriceWithoutTax:
    //           AddProductCubit.get(context).changeSalePriceWithoutTax,
    //       changeMinPriceWithTaxes:
    //           AddProductCubit.get(context).changeMinPriceWithTaxes,
    //       changeSalePriceWithTax:
    //           AddProductCubit.get(context).changeSalePriceWithTax,
    //       productUnits: AddProductCubit.get(context).productUnits,
    //       branchQuantities: AddProductCubit.get(context).branchQuantities,
    //       onSelectedImage: (image) =>
    //           AddProductCubit.get(context).image = image,
    //       formKey: AddProductCubit.get(context).formKey,
    //       autovalidateMode: AddProductCubit.get(context).autovalidateMode,
    //       nameController: AddProductCubit.get(context).nameController,
    //       descriptionController:
    //           AddProductCubit.get(context).descriptionController,
    //       pricePerUnitController:
    //           AddProductCubit.get(context).pricePerUnitController,
    //       openingQuantityController: TextEditingController(),
    //       barCodeController: TextEditingController(),
    //       brandController: AddProductCubit.get(context).brandController,
    //       isLoading: state is AddProductLoading,
    //       onPressed: () => AddProductCubit.get(context).addProduct(),
    //       onChangedCategory: (category) =>
    //           AddProductCubit.get(context).onChangeCategory(category),
    //       category: AddProductCubit.get(context).category,
    //       onChangedUnit: (unit) {},
    //       unit: null,
    //       onChangedBranch: (branch) => () {},
    //       branch: null,
    //       onInitialQuntitySubmit: null,
    //       taxes: AddProductCubit.get(context).taxes,
    //       onChangedTaxes: AddProductCubit.get(context).onChangeTaxes,
    //       productType: AddProductCubit.get(context).productType,
    //       onChangedProductType:
    //           AddProductCubit.get(context).onChangeProductType,
    //       callInInit: () {
    //         AddProductCubit.get(context).addProductUnits();
    //       },
    //       isEdit: false,
    //       imageUrl: null,
    //     );
    //   },
    // );
  }
}

class AddProductTabletAndDesktopBody extends StatelessWidget {
  const AddProductTabletAndDesktopBody({super.key, required this.state});
  final AddProductState state;
  @override
  Widget build(BuildContext context) {
    return AddProductMobileBody(state: state);
  }
}
