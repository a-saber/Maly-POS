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
import 'package:pos_app/features/products/view/widget/product_data_builder.dart';
import 'package:pos_app/features/units/view/widget/custom_drop_down_unit.dart';
import 'package:pos_app/generated/l10n.dart';

import '../../../core/helper/my_form_validators.dart';
import '../../../core/utils/app_padding.dart';
import '../../../core/widget/custom_drop_down.dart';
import '../../../core/widget/custom_loading.dart';
import '../../../core/widget/custom_reset_drop_down_button.dart';
import '../../../core/widget/image_manager_view.dart';
import '../../branch/view/widget/custom_drop_down_branch.dart';
import '../../categories/view/widget/custom_drop_down_category.dart';
import '../../taxes/view/widget/custom_drop_down_taxes.dart';
import '../data/model/product_type.dart';

class AddProductDataView2 extends StatelessWidget {
  const AddProductDataView2({super.key});

  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<AddProductCubit, AddProductState>(
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
        return Form(
          key: cubit.formKey,
          autovalidateMode: cubit.autovalidateMode,
          child: Padding(
            padding: AppPaddings.defaultView,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
              [
                ImageManagerView(
                  onSelected:  (image) => AddProductCubit.get(context).image = image,
                  imageUrl: null,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomFormField(
                  controller: cubit.nameController,
                  labelText: S.of(context).name,
                  validator: (value) =>
                      MyFormValidators.validateRequired(value, context: context),
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
                    Text('الوحدات',style: AppFontStyle.formText(context: context),),
                    CustomTextBtn(
                      text: "Add",
                      textColor: AppColors.primary,
                      onPressed: cubit.addProductUnits,
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowHeight: 80,
                    border: TableBorder.all(color: Colors.grey),
                    // decoration: const BoxDecoration(color: Colors.black12),
                    columns: const [
                      DataColumn(label: Text('حذف')),
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
                    ],
                    rows: List.generate(cubit.productUnits.length, (index) {
                      return DataRow(
                        cells: [
                          // remove
                          DataCell(
                            CustomTextBtn(
                              text: "حذف",
                              textColor: AppColors.grey,
                              onPressed: index == 0? null: ()=>cubit.removeProductUnit(index: index),
                            ),
                          ),
                          // unit
                          DataCell(
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: SizedBox(
                                  width: 150,
                                  child: CustomDropDownUnit(
                                    value: cubit.productUnits[index].unit,
                                    onChanged: (unit) {
                                      if(unit != null) {
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
                            enabled: index != 0 ,
                            validator: (value) => MyFormValidators.validateInteger(
                              value,
                              context: context,
                              validate: false
                            ),
                            controller: cubit.productUnits[index].factoryController,
                            onChanged: index == 0
                                ? null
                                : (p0) {
                              // setState(() {
                              //   productUnit.costPriceController?.text = ((int.tryParse(
                              //       productUnit.factoryController?.text ??
                              //           '') ??
                              //       0) *
                              //       (widget.baseCost))
                              //       .toString();
                              // });
                            },
                          )),
                          DataCell(customTextFormFieldTable(
                              hintText: "سعر التكلفة",
                              validator: (value) => MyFormValidators.validateDoublePrice(value,
                                  context: context, validateEmpty: false),
                              controller: cubit.productUnits[index].costPriceController,
                              onChanged: (p0) {},
                              onFieldSubmitted: (value) {
                                // if (widget.onChangeCost != null) {
                                //   widget.onChangeCost!(index);
                                // }
                              }
                              )),
                          DataCell(customTextFormFieldTable(
                            hintText: "اقل سعر بيع",
                            validator: (value) => MyFormValidators.validateDoublePrice(
                              value,
                              context: context,
                              haveMin: true,
                              min: double.tryParse(cubit.productUnits[index].costPriceController?.text ?? ''),
                            ),
                            controller: cubit.productUnits[index].minPriceWithoutTaxController,
                            onChanged: (p0) {
                              // debugPrint("onChangeMinPriceWithoutTaxes");
                              // if (widget.changeMinPriceWithoutTaxes != null) {
                              //   debugPrint("onChangeMinPriceWithoutTaxes");
                              //   widget.changeMinPriceWithoutTaxes!(productUnit);
                              // }
                            },
                          )),
                          DataCell(customTextFormFieldTable(
                            hintText: "اقل سعر بيع بالضريبة",
                            // TODO : remove have min bool to allow lower price
                            validator: (value) => MyFormValidators.validateDoublePrice(
                              value,
                              context: context,
                              haveMin: true,
                              min: double.tryParse(
                                  cubit.productUnits[index].minPriceWithoutTaxController?.text ?? ''),
                            ),
                            controller: cubit.productUnits[index].minPriceWithTaxController,
                            onChanged: (p0) {
                              // if (widget.changeMinPriceWithTaxes != null) {
                              //   widget.changeMinPriceWithTaxes!(productUnit);
                              // }
                            },
                          )),
                          DataCell(customTextFormFieldTable(
                            hintText: "سعر البيع",
                            validator: (value) => MyFormValidators.validateDoublePrice(
                              value,
                              context: context,
                              haveMin: true,
                              min: double.tryParse(
                                  cubit.productUnits[index].minPriceWithoutTaxController?.text ?? ''),
                            ),
                            controller: cubit.productUnits[index].salePriceWithoutTaxController,
                            onChanged: (p0) {
                              // if (widget.changeSalePriceWithoutTax != null) {
                              //   widget.changeSalePriceWithoutTax!(productUnit);
                              // }
                            },
                          )),
                          DataCell(customTextFormFieldTable(
                            hintText: "سعر البيع بالضريبة",
                            validator: (value) => MyFormValidators.validateDoublePrice(
                              value,
                              context: context,
                              haveMin: true,
                              min: double.tryParse(
                                  cubit.productUnits[index].salePriceWithoutTaxController?.text ?? ''),
                            ),
                            controller: cubit.productUnits[index].salePriceWithTaxController,
                            onChanged: (p0) {
                              // if (widget.changeSalePriceWithTax != null) {
                              //   widget.changeSalePriceWithTax!(productUnit);
                              // }
                            },
                          )),
                          DataCell(customTextFormFieldTable(
                            hintText: "الباركود",
                            validator: (value) =>
                                MyFormValidators.validateInteger(value, context: context),
                            controller: cubit.productUnits[index].barCodeController,
                            onChanged: (p0) {},
                          )),
                          DataCell(customTextFormFieldTable(
                            hintText: "باركود الميزان",
                            validator: (value) =>
                                MyFormValidators.validateInteger(value, context: context),
                            controller: cubit.productUnits[index].scaleBarcodeController,
                            onChanged: (p0) {},
                          )),
                          DataCell(
                            CustomTextBtn(
                              text: "اضافة كمية",
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    List<BranchQuantity> tempBranchQuantities = cubit.productUnits[index].branchQty.isEmpty?
                                        [
                                      BranchQuantity(
                                        branchId: null,
                                        branch: null,
                                        qunantity: 0,
                                        quantityController:
                                        TextEditingController(),
                                      ),
                                    ]: List.from(cubit.productUnits[index].branchQty);
                                    return StatefulBuilder(
                                      builder: (ctx, setState) => AlertDialog(
                                        title: Column(
                                          spacing: 10,
                                          children: [
                                            Text("اضافة كمية افتتاحية"),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                CustomTextBtn(
                                                  text: "اضافة",
                                                  textColor: AppColors.primary,
                                                  onPressed: () {
                                                    setState(() {
                                                      tempBranchQuantities.add(
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
                                                      child: CustomDropDownBranch(
                                                          value: tempBranchQuantities[index]
                                                              .branch,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              tempBranchQuantities[index]
                                                                  .branch =BrancheModel(
                                                                  id: value?.id,
                                                                  name: value?.name,
                                                                  address: value?.address, phone: value?.phone,
                                                                  email: value?.email,
                                                                  createdAt: value?.createdAt,
                                                                  updatedAt: value?.updatedAt,
                                                                  pivot: value?.pivot);
                                                            });
                                                          }),
                                                    ),
                                                    Expanded(
                                                      child: CustomFormField(
                                                        hintText: "الكمية",
                                                        controller: TextEditingController.fromValue(tempBranchQuantities[index]
                                                            .quantityController.value) ,
                                                        validator: (value) =>
                                                            MyFormValidators
                                                                .validateInteger(value,
                                                                context: context),
                                                        onChanged: (p0) {},
                                                      ),
                                                    ),
                                                    IconButton(onPressed: (){
                                                      setState(() {
                                                        tempBranchQuantities.removeAt(index);
                                                      });
                                                    }, icon: Icon(Icons.cancel_outlined))
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              CustomTextBtn(
                                                text: "اغلاق",
                                                textColor: AppColors.primary,
                                                onPressed: () => Navigator.pop(ctx),
                                              ),
                                              CustomTextBtn(
                                                text: "حفظ",
                                                textColor: AppColors.primary,
                                                onPressed: () {
                                                  cubit.assignBranchQty(index: index, branchQuantities: tempBranchQuantities);
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

                        ],
                      );
                    }),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Builder(builder: (context) {
                  if (state is AddProductLoading) {
                    return const CustomLoading();
                  }
                  return CustomFilledBtn(
                      text: S.of(context).add,
                      onPressed: cubit.addProduct
                  );
                }),
              ],
            ),
          )
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
      create: (context) =>
          AddProductCubit(MyServiceLocator.getSingleton<ProductsRepo>()),
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).addProduct),
        body: BlocConsumer<AddProductCubit, AddProductState>(
          listener: (context, state) {
            if (state is AddProductSuccess) {
              //  TODO : Will Add Update Product Moel Selling Point
              // GetAllProductsCubit.get(context).addProduct(state.product);
              // TODO : Will Give Update Product Model Selling Point
              // MyServiceLocator.getSingleton<SellingPointCubit>()
              //     .addProduct(state.product);
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
              desktop: MyCustomScrollView(
                  child: AddProductTabletAndDesktopBody(state: state)),
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
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: AppConstant.formExpandedTableandMobile,
          child: AddProductMobileBody(state: state),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
