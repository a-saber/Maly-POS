import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/core/widget/custom_reset_drop_down_button.dart';
import 'package:pos_app/core/widget/image_manager_view.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/manager/search_branch_cubit/search_branch_cubit.dart';
import 'package:pos_app/features/branch/view/widget/search_branch_builder.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/view/widget/custom_drop_down_category.dart';
import 'package:pos_app/features/products/data/model/product_type.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/view/widget/custom_drop_down_taxes.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/view/widget/custom_drop_down_unit.dart';
import 'package:pos_app/generated/l10n.dart';

class ProductDataBuilder extends StatefulWidget {
  const ProductDataBuilder({
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
            CustomDropDownUnit(
              value: widget.unit,
              onChanged: widget.onChangedUnit,
            ),
            SizedBox(
              height: 20,
            ),
            CustomFormField(
              controller: widget.pricePerUnitController,
              labelText: S.of(context).pricePerUnit,
              keyboardType: TextInputType.text,
              validator: (value) =>
                  MyFormValidators.validateDoublePrice(value, context: context),
            ),
            SizedBox(
              height: 20,
            ),

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
                  CustomFormField(
                    enabled: widget.productType != null &&
                        widget.productType!.id != 2,
                    controller: widget.openingQuantityController,
                    labelText: S.of(context).initialQuantity,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: widget.onInitialQuntitySubmit,
                    validator: (value) => MyFormValidators.validateInteger(
                      value,
                      context: context,
                      validate: widget.productType != null &&
                          widget.productType!.id != 2 &&
                          widget.branch != null,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

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
                  BlocProvider.value(
                    value: MyServiceLocator.getSingleton<SearchBranchCubit>(),
                    child: Builder(builder: (context) {
                      return CustomDropdown<BrancheModel>(
                        // search: true,
                        enabled: branchSelectEnable(),
                        hint: S.of(context).selectBranch,
                        compareFn: (item1, item2) {
                          if (item1.name == null ||
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
                        value: widget.branch,
                        items: SearchBranchCubit.get(context).searchBranches,
                        validator: (value) =>
                            MyFormValidators.validateTypeRequired<BrancheModel>(
                          value,
                          isRequired: branchSelectEnable() &&
                              widget.openingQuantityController.text.isNotEmpty,
                          context: context,
                        ),
                        filterFn: (item, filter) {
                          return item.name!
                              .toLowerCase()
                              .contains(filter.toLowerCase());
                        },
                        containerBuilder: (p0, p1) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomFormField(
                                  hintText: S.of(context).searchBranch,
                                  controller: TextEditingController(
                                      text:
                                          SearchBranchCubit.get(context).query),
                                  onChanged: (value) =>
                                      SearchBranchCubit.get(context)
                                          .onChangeSearch(
                                    value,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SearchBranchBuilder(
                                  name: widget.branch?.name ?? '',
                                  child: p1,
                                  onTap: (p0) {
                                    widget.onChangedBranch(p0);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                        onChanged: (p0) {},
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
                    }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),

            CustomFormField(
              controller: widget.barCodeController,
              labelText: S.of(context).barcode,
              keyboardType: TextInputType.text,
              // validator: (value) =>
              //     MyFormValidators.validateRequired(value, context: context),
            ),
            SizedBox(
              height: 20,
            ),
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
