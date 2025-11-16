import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/core/widget/custom_reset_drop_down_button.dart';
import 'package:pos_app/core/widget/image_manager_view.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/view/widget/custom_drop_down_branch.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/view/widget/custom_drop_down_category.dart';
import 'package:pos_app/features/products/data/model/product_type.dart';
import 'package:pos_app/features/products/data/model/update_product_model.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/view/widget/custom_drop_down_taxes.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/view/widget/custom_drop_down_unit.dart';
import 'package:pos_app/generated/l10n.dart';

// ignore: must_be_immutable
class ProductDataBuilder extends StatefulWidget {
  ProductDataBuilder({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.pricePerUnitController,
    required this.openingQuantityController,
    required this.isLoading,
    required this.onPressed,
    this.imageUrl,
    required this.isEdit,
    required this.onSelectedImage,
    required this.autovalidateMode,
    required this.onChangedCategory,
    this.category,
    required this.onChangedUnit,
    this.unit,
    required this.onChangedBranch,
    this.branch,
    this.onInitialQuntitySubmit,
    required this.barCodeController,
    required this.brandController,
    required this.onChangedTaxes,
    this.taxes,
    required this.onChangedProductType,
    this.productType,
    required this.callInInit,
    this.productUnits = const [],
    this.branchQuantities = const [],
    this.addProductUnit,
    this.baseCost = 0,
    this.onChangeCost,
    this.changeMinPriceWithoutTaxes,
    this.changeSalePriceWithoutTax,
    this.changeMinPriceWithTaxes,
    this.changeSalePriceWithTax,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController pricePerUnitController;
  final TextEditingController openingQuantityController;
  final TextEditingController barCodeController;
  final TextEditingController brandController;
  final bool isLoading;
  final void Function() onPressed;
  final void Function(CategoryModel?) onChangedCategory;
  final CategoryModel? category;
  final void Function(UnitModel?) onChangedUnit;
  final UnitModel? unit;
  final void Function(BrancheModel?) onChangedBranch;
  final BrancheModel? branch;
  final void Function(TaxesModel?) onChangedTaxes;
  final TaxesModel? taxes;
  final void Function(ProductType?) onChangedProductType;
  final ProductType? productType;
  final void Function(XFile) onSelectedImage;
  final bool isEdit;
  final String? imageUrl;
  final AutovalidateMode? autovalidateMode;
  final void Function(String)? onInitialQuntitySubmit;
  final void Function() callInInit;

  List<ProductUnits> productUnits;
  List<List<BranchQuantity>> branchQuantities;
  final void Function()? addProductUnit;
  final void Function(int index, {bool changeCostToAll})? onChangeCost;
  final void Function(ProductUnits productUnit)? changeMinPriceWithoutTaxes;
  final void Function(ProductUnits productUnit)? changeMinPriceWithTaxes;
  final void Function(ProductUnits productUnit)? changeSalePriceWithoutTax;
  final void Function(ProductUnits productUnit)? changeSalePriceWithTax;
  double baseCost;

  @override
  State<ProductDataBuilder> createState() => _ProductDataBuilderState();
}

class _ProductDataBuilderState extends State<ProductDataBuilder> {
  @override
  void initState() {
    widget.callInInit();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: widget.autovalidateMode,
      child: Padding(
        padding: AppPaddings.defaultView,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageManagerView(
              onSelected: widget.onSelectedImage,
              imageUrl: widget.imageUrl,
            ),
            SizedBox(
              height: 10,
            ),
            CustomFormField(
              controller: widget.nameController,
              labelText: S.of(context).name,
              validator: (value) =>
                  MyFormValidators.validateRequired(value, context: context),
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 20,
            ),
            CustomDropDownCategory(
              value: widget.category,
              onChangedCategory: widget.onChangedCategory,
            ),
            SizedBox(
              height: 20,
            ),
            // CustomDropDownUnit(
            //   value: widget.unit,
            //   onChanged: widget.onChangedUnit,
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // CustomFormField(
            //   controller: widget.pricePerUnitController,
            //   labelText: S.of(context).pricePerUnit,
            //   keyboardType: TextInputType.text,
            //   validator: (value) =>
            //       MyFormValidators.validateDoublePrice(value, context: context),
            // ),
            // SizedBox(
            //   height: 20,
            // ),

            // Product Type
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
              value: widget.productType,
              items: AppConstant.producttype(context),
              validator: (value) =>
                  MyFormValidators.validateTypeRequired<ProductType>(
                value,
                context: context,
              ),
              onChanged: (value) {
                widget.onChangedProductType(value);
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
            Visibility(
              visible:
                  widget.productType != null && widget.productType!.id != 2,
              child: Column(
                children: [
                  // CustomFormField(
                  //   enabled: widget.productType != null &&
                  //       widget.productType!.id != 2,
                  //   controller: widget.openingQuantityController,
                  //   labelText: S.of(context).initialQuantity,
                  //   keyboardType: TextInputType.text,
                  //   onFieldSubmitted: widget.onInitialQuntitySubmit,
                  //   validator: (value) => MyFormValidators.validateInteger(
                  //     value,
                  //     context: context,
                  //     validate: widget.productType != null &&
                  //         widget.productType!.id != 2 &&
                  //         widget.branch != null,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),

                  // CustomDropdown<BrancheModel>(
                  //   hint: S.of(context).selectBranch,
                  //   search: true,
                  //   compareFn: (item1, item2) {
                  //     if (item1.name == null ||
                  //         item2.name == null ||
                  //         item1.name!.isEmpty ||
                  //         item2.name!.isEmpty) {
                  //       return false;
                  //     } else {
                  //       return (item1.name!
                  //               .toLowerCase()
                  //               .contains(item2.name!.toLowerCase()) ||
                  //           item2.name!
                  //               .toLowerCase()
                  //               .contains(item1.name!.toLowerCase()));
                  //     }
                  //   },
                  //   enabled: widget.openingQuantityController.text.isNotEmpty &&
                  //       int.tryParse(widget.openingQuantityController.text) !=
                  //           null &&
                  //       int.parse(widget.openingQuantityController.text) > 0,
                  //   value: widget.branch,
                  //   items: CustomUserHiveBox.getUser().branches ?? [],
                  //   filterFn: (item, filter) {
                  //     return item.name!
                  //         .toLowerCase()
                  //         .contains(filter.toLowerCase());
                  //   },
                  //   onChanged: (BrancheModel? branch) {
                  //     if (widget.category != null) {
                  //       widget.onChangedBranch(branch);
                  //     }
                  //   },
                  //   builder: (BrancheModel? branch) {
                  //     if (branch != null) {
                  //       return Text(
                  //         branch.name ?? S.of(context).noName,
                  //         style: AppFontStyle.formText(
                  //           context: context,
                  //         ),
                  //       );
                  //     } else {
                  //       return SizedBox();
                  //     }
                  //   },
                  // ),
                  // BlocProvider.value(
                  //   value: MyServiceLocator.getSingleton<SearchBranchCubit>(),
                  //   child: Builder(builder: (context) {
                  //     return CustomDropdown<BrancheModel>(
                  //       // search: true,
                  //       enabled: branchSelectEnable(),
                  //       hint: S.of(context).selectBranch,
                  //       compareFn: (item1, item2) {
                  //         if (item1.name == null ||
                  //             item1.name!.isEmpty ||
                  //             item2.name!.isEmpty) {
                  //           return false;
                  //         } else {
                  //           return (item1.name!
                  //                   .toLowerCase()
                  //                   .contains(item2.name!.toLowerCase()) ||
                  //               item2.name!
                  //                   .toLowerCase()
                  //                   .contains(item1.name!.toLowerCase()));
                  //         }
                  //       },
                  //       value: widget.branch,
                  //       items: SearchBranchCubit.get(context).searchBranches,
                  //       validator: (value) =>
                  //           MyFormValidators.validateTypeRequired<BrancheModel>(
                  //         value,
                  //         isRequired: branchSelectEnable() &&
                  //             widget.openingQuantityController.text.isNotEmpty,
                  //         context: context,
                  //       ),
                  //       filterFn: (item, filter) {
                  //         return item.name!
                  //             .toLowerCase()
                  //             .contains(filter.toLowerCase());
                  //       },
                  //       containerBuilder: (p0, p1) {
                  //         return Column(
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: CustomFormField(
                  //                 hintText: S.of(context).searchBranch,
                  //                 controller: TextEditingController(
                  //                     text:
                  //                         SearchBranchCubit.get(context).query),
                  //                 onChanged: (value) =>
                  //                     SearchBranchCubit.get(context)
                  //                         .onChangeSearch(
                  //                   value,
                  //                 ),
                  //               ),
                  //             ),
                  //             Expanded(
                  //               child: SearchBranchBuilder(
                  //                 name: widget.branch?.name ?? '',
                  //                 child: p1,
                  //                 onTap: (p0) {
                  //                   widget.onChangedBranch(p0);
                  //                   Navigator.of(context).pop();
                  //                 },
                  //               ),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //       onChanged: (p0) {},
                  //       builder: (BrancheModel? branch) {
                  //         if (branch != null) {
                  //           return Text(
                  //             branch.name ?? S.of(context).noName,
                  //             style: AppFontStyle.formText(
                  //               context: context,
                  //             ),
                  //           );
                  //         } else {
                  //           return SizedBox();
                  //         }
                  //       },
                  //     );
                  //   }),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                ],
              ),
            ),

            // CustomFormField(
            //   controller: widget.barCodeController,
            //   labelText: S.of(context).barcode,
            //   keyboardType: TextInputType.text,
            //   // validator: (value) =>
            //   //     MyFormValidators.validateRequired(value, context: context),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            CustomFormField(
              controller: widget.brandController,
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
                    value: widget.taxes,
                    onChange: widget.onChangedTaxes,
                  ),
                ),
                CustomResetDropDownButton(
                  onPressed: () {
                    widget.onChangedTaxes(null);
                  },
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),
            CustomFormField(
              controller: widget.descriptionController,
              labelText: S.of(context).description,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomTextBtn(
                  text: "Add",
                  textColor: AppColors.primary,
                  onPressed: (widget.addProductUnit != null
                      ? () {
                          widget.addProductUnit!();
                        }
                      : null),
                ),
              ],
            ),

            Builder(builder: (context) {
              // if(widget.baseCost != 0 ){
              //   productUnit.costPriceController?.text =
              //   ((int.tryParse(productUnit.factoryController?.text ?? '') ?? 0) * (widget.baseCost)).toString();
              // }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(color: Colors.grey),
                  // decoration: const BoxDecoration(color: Colors.black12),
                  columns: const [
                    DataColumn(label: Text('Unit Name')),
                    DataColumn(label: Text('Factory')),
                    DataColumn(label: Text('Cost Price')),
                    DataColumn(label: Text('Min Sale Price Without Tax')),
                    DataColumn(label: Text('Min Sale Price With Tax')),
                    DataColumn(label: Text('Sale Price Without Tax')),
                    DataColumn(label: Text('Sale Price With Tax')),
                    DataColumn(label: Text('BarCode')),
                    DataColumn(label: Text('Scale BarCode')),
                    DataColumn(label: Text('Quantity')),
                    // DataColumn(label: Text('remove')),
                  ],
                  rows: List.generate(widget.productUnits.length, (index) {
                    return customRow(
                      context,
                      index: index,
                      productUnit: widget.productUnits[index],
                      branchQuantities: widget.branchQuantities[index],
                    );
                  }),
                ),
              );
            }),
            SizedBox(
              height: 20,
            ),
            Builder(builder: (context) {
              if (widget.isLoading) {
                return const CustomLoading();
              }
              return CustomFilledBtn(
                  text: widget.isEdit ? S.of(context).edit : S.of(context).add,
                  onPressed: widget.onPressed);
            }),
          ],
        ),
      ),
    );
  }

  DataRow customRow(
    BuildContext context, {
    required int index,
    required ProductUnits productUnit,
    required List<BranchQuantity> branchQuantities,
  }) {
    return DataRow(
      cells: [
        DataCell(
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: SizedBox(
                width: 150,
                child: CustomDropDownUnit(
                  value: productUnit.unit,
                  onChanged: (unit) {
                    debugPrint("OnChangeUnit");
                    setState(() {
                      productUnit.unit = unit;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        DataCell(customTextFormFieldTable(
          hintText: "Factory",
          enabled: index == 0 ? false : true,
          initialValue: index == 0 ? "1" : null,
          validator: (value) => MyFormValidators.validateInteger(value,
              context: context, validate: false),
          controller: index == 0 ? null : productUnit.factoryController!,
          onChanged: index == 0
              ? null
              : (p0) {
                  setState(() {
                    productUnit.costPriceController?.text = ((int.tryParse(
                                    productUnit.factoryController?.text ??
                                        '') ??
                                0) *
                            (widget.baseCost))
                        .toString();
                  });
                },
        )),
        DataCell(customTextFormFieldTable(
            hintText: "cost price",
            validator: (value) => MyFormValidators.validateDoublePrice(value,
                context: context, validateEmpty: false),
            controller: productUnit.costPriceController!,
            onChanged: (p0) {},
            onFieldSubmitted: (value) {
              if (widget.onChangeCost != null) {
                widget.onChangeCost!(index);
              }
            })),
        DataCell(customTextFormFieldTable(
          hintText: "min price without tax",
          validator: (value) => MyFormValidators.validateDoublePrice(
            value,
            context: context,
            haveMin: true,
            min: double.tryParse(productUnit.costPriceController?.text ?? ''),
          ),
          controller: productUnit.minPriceWithoutTaxController!,
          onChanged: (p0) {
            debugPrint("onChangeMinPriceWithoutTaxes");
            if (widget.changeMinPriceWithoutTaxes != null) {
              debugPrint("onChangeMinPriceWithoutTaxes");
              widget.changeMinPriceWithoutTaxes!(productUnit);
            }
          },
        )),
        DataCell(customTextFormFieldTable(
          hintText: "min price with tax",
          // TODO : remove have min bool to allow lower price
          validator: (value) => MyFormValidators.validateDoublePrice(
            value,
            context: context,
            haveMin: true,
            min: double.tryParse(
                productUnit.minPriceWithoutTaxController?.text ?? ''),
          ),
          controller: productUnit.minPriceWithTaxController,
          onChanged: (p0) {
            if (widget.changeMinPriceWithTaxes != null) {
              widget.changeMinPriceWithTaxes!(productUnit);
            }
          },
        )),
        DataCell(customTextFormFieldTable(
          hintText: "sale price without tax",
          validator: (value) => MyFormValidators.validateDoublePrice(
            value,
            context: context,
            haveMin: true,
            min: double.tryParse(
                productUnit.minPriceWithoutTaxController?.text ?? ''),
          ),
          controller: productUnit.salePriceWithoutTaxController!,
          onChanged: (p0) {
            if (widget.changeSalePriceWithoutTax != null) {
              widget.changeSalePriceWithoutTax!(productUnit);
            }
          },
        )),
        DataCell(customTextFormFieldTable(
          hintText: "sale price with tax",
          validator: (value) => MyFormValidators.validateDoublePrice(
            value,
            context: context,
            haveMin: true,
            min: double.tryParse(
                productUnit.salePriceWithoutTaxController?.text ?? ''),
          ),
          controller: productUnit.salePriceWithTaxController!,
          onChanged: (p0) {
            if (widget.changeSalePriceWithTax != null) {
              widget.changeSalePriceWithTax!(productUnit);
            }
          },
        )),
        DataCell(customTextFormFieldTable(
          hintText: "barCode",
          validator: (value) =>
              MyFormValidators.validateInteger(value, context: context),
          controller: productUnit.barCodeController!,
          onChanged: (p0) {},
        )),
        DataCell(customTextFormFieldTable(
          hintText: "scale barcode",
          validator: (value) =>
              MyFormValidators.validateInteger(value, context: context),
          controller: productUnit.scaleBarcodeController!,
          onChanged: (p0) {},
        )),
        DataCell(
          CustomTextBtn(
            text: "Add Quantity",
            textColor: widget.productType?.id == 1
                ? AppColors.primary
                : AppColors.grey,
            onPressed: widget.productType?.id == 1
                ? () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return StatefulBuilder(
                          builder: (ctx, setState) => AlertDialog(
                            title: Column(
                              spacing: 10,
                              children: [
                                Text("Add Quantity"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomTextBtn(
                                      text: "Add",
                                      textColor: AppColors.primary,
                                      onPressed: () {
                                        setState(() {
                                          branchQuantities.add(
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
                                  branchQuantities.length,
                                  (index) {
                                    return Row(
                                      spacing: 5,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CustomDropDownBranch(
                                              value: branchQuantities[index]
                                                  .branch,
                                              onChanged: (value) {
                                                setState(() {
                                                  branchQuantities[index]
                                                      .branch = value;
                                                });
                                              }),
                                        ),
                                        Expanded(
                                          child: CustomFormField(
                                            hintText: "Quantity",
                                            controller: branchQuantities[index]
                                                .quantityController,
                                            validator: (value) =>
                                                MyFormValidators
                                                    .validateInteger(value,
                                                        context: context),
                                            onChanged: (p0) {},
                                          ),
                                        ),
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
                                    text: "Cancel",
                                    textColor: AppColors.primary,
                                    onPressed: () => Navigator.pop(ctx),
                                  ),
                                  CustomTextBtn(
                                    text: "Save",
                                    textColor: AppColors.primary,
                                    onPressed: () {
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
                  }
                : null,
          ),
        ),
        // DataCell(
        //   CustomTextBtn(
        //     text: "Remove",
        //     onPressed: () {
        //       setState(
        //         () {
        //           productUnit = ProductUnits(
        //             factoryController: TextEditingController(),
        //             costPriceController: TextEditingController(),
        //             barCodeController: TextEditingController(),
        //             scaleBarcodeController: TextEditingController(),
        //             minPriceWithoutTaxController: TextEditingController(),
        //             salePriceWithoutTaxController: TextEditingController(),
        //             salePriceWithTaxController: TextEditingController(),
        //           );

        //           branchQuantities = [];
        //         },
        //       );
        //     },
        //   ),
        // ),
      ],
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

  bool branchSelectEnable() =>
      // widget.openingQuantityController.text.isNotEmpty &&
      // int.tryParse(widget.openingQuantityController.text) != null &&
      // int.parse(widget.openingQuantityController.text) > 0 &&
      widget.productType != null && widget.productType!.id != 2;
}

/*
CustomFormField(
                controller: phoneController,
                labelText: S.of(context).phone,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    MyFormValidators.validatePhone(value, context: context),
              ),
              SizedBox(
                height: 20,
              ),
              CustomFormField(
                controller: addressController,
                labelText: S.of(context).address,
                keyboardType: TextInputType.streetAddress,
              ),
              SizedBox(
                height: 20,
              ),
*/
