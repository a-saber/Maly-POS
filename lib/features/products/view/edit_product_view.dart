import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
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
import 'package:pos_app/features/categories/data/repo/category_repo.dart';
import 'package:pos_app/features/categories/view/widget/custom_drop_down_category.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/data/model/product_type.dart';
import 'package:pos_app/features/products/data/model/update_product_model.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';
import 'package:pos_app/features/products/manager/edit_product_cubit/edit_product_cubit.dart';
import 'package:pos_app/features/taxes/view/widget/custom_drop_down_taxes.dart';
import 'package:pos_app/features/units/data/repo/units_repo.dart';
import 'package:pos_app/features/units/view/widget/custom_drop_down_unit.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/generated/l10n.dart';

class EditProductView extends StatelessWidget {
  final ProductModel product;
  const EditProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProductCubit(
        repo: MyServiceLocator.getSingleton<ProductsRepo>(),
        unitsRepo: MyServiceLocator.getSingleton<UnitsRepo>(),
        categoryRepo: MyServiceLocator.getSingleton<CategoryRepo>(),
        product: product,
      ),
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).editProduct),
        body: BlocConsumer<EditProductCubit, EditProductState>(
          listener: (context, state) {
            if (state is EditProductSuccess) {
              CustomPopUp.callMyToast(
                  context: context,
                  massage: S.of(context).updatedSuccess,
                  state: PopUpState.SUCCESS);

              Navigator.pop(context, state.product);
            } else if (state is EditProductFailing) {
              if (context.mounted) {
                String errorMessage = state.errMessage.toString();
                if (errorMessage.contains(
                    "Service type products cannot have stock quantities")) {
                  errorMessage =
                      "منتجات الخدمة لا يمكن أن يكون لها كميات مخزنية";
                }
                if (errorMessage.contains("The min sale price at unit") &&
                    errorMessage.contains("must be ≥ cost price")) {
                  errorMessage =
                      "الحد الأدنى لسعر البيع يجب أن يكون أكبر من أو يساوي سعر التكلفة";
                }
                CustomPopUp.callMyToast(
                    context: context,
                    massage: errorMessage,
                    state: PopUpState.ERROR);
              }
            } else if (state is UpdateProductUnitsCostWarning) {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text(
                        "The New Cost Of Simple Unit is ${state.myCost / state.factory}"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(S.of(context).cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(S.of(context).done),
                      ),
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            return CustomLayoutBuilder(
              mobile: MyCustomScrollView(
                  child: EditProductMobileBody(state: state)),
              tablet: MyCustomScrollView(
                  child: EditProductTabletAndDesktopBody(state: state)),
              desktop: MyCustomScrollView(
                  child: EditProductTabletAndDesktopBody(state: state)),
            );
          },
        ),
      ),
    );
  }
}

class EditProductMobileBody extends StatelessWidget {
  final EditProductState state;
  const EditProductMobileBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return EditProductDataView();
  }
}

class EditProductTabletAndDesktopBody extends StatelessWidget {
  final EditProductState state;
  const EditProductTabletAndDesktopBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return EditProductMobileBody(state: state);
  }
}

class EditProductDataView extends StatefulWidget {
  const EditProductDataView({super.key});

  @override
  State<EditProductDataView> createState() => _EditProductDataViewState();
}

class _EditProductDataViewState extends State<EditProductDataView> {
  bool isSwitchOn = true;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      EditProductCubit.get(context).init(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProductCubit, EditProductState>(
      builder: (context, state) {
        final cubit = EditProductCubit.get(context);
        if (state is EditProductInitializing) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          padding: AppPaddings.defaultView,
          child: Form(
            key: cubit.formKey,
            autovalidateMode: cubit.autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'متاح للبيع',
                      style: AppFontStyle.formText(context: context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          cubit.isavailable == 1 ? 'متاح' : 'غير متاح',
                          style: TextStyle(
                            color: cubit.isavailable == 1
                                ? Colors.green
                                : Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        Switch(
                          value: cubit.isavailable == 1,
                          activeColor: AppColors.primary,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey.shade300,
                          onChanged: (value) {
                            cubit.onChangeAvailability(value);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ImageManagerView(
                  onSelected: (image) => cubit.image = image,
                  imageUrl: cubit.product.imageUrl,
                ),
                const SizedBox(height: 10),
                CustomFormField(
                  controller: cubit.nameController,
                  labelText: S.of(context).name,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  controller: cubit.descriptionController,
                  labelText: S.of(context).description,
                ),
                const SizedBox(height: 20),
                CustomDropDownCategory(
                  value: cubit.category,
                  onChangedCategory: (category) =>
                      cubit.onChangeCategory(category),
                ),
                const SizedBox(height: 20),
                CustomDropdown<ProductType>(
                  search: true,
                  hint: S.of(context).selectProductType,
                  value: cubit.productType,
                  items: AppConstant.producttype(context),
                  compareFn: (item1, item2) =>
                      item1.name
                          .toLowerCase()
                          .contains(item2.name.toLowerCase()) ||
                      item2.name
                          .toLowerCase()
                          .contains(item1.name.toLowerCase()),
                  onChanged: (value) => cubit.onChangeProductType(value),
                  builder: (productType) => productType != null
                      ? Text(productType.name,
                          style: AppFontStyle.formText(context: context))
                      : const SizedBox(),
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  controller: cubit.brandController,
                  labelText: S.of(context).brand,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropDownTaxes(
                        value: cubit.taxes,
                        onChange: cubit.onChangeTaxes,
                      ),
                    ),
                    CustomResetDropDownButton(
                        onPressed: () => cubit.onChangeTaxes(null)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الوحدات',
                        style: AppFontStyle.formText(context: context)),
                    CustomTextBtn(
                      text: "اضافة",
                      textColor: AppColors.primary,
                      onPressed: cubit.addProductUnits,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildUnitsTable(cubit),
                const SizedBox(height: 20),
                if (cubit.state is EditProductLoading)
                  const CustomLoading()
                else
                  CustomFilledBtn(
                    text: S.of(context).update,
                    onPressed: () {
                      cubit.editProduct(context);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUnitsTable(EditProductCubit cubit) {
    final controller = ScrollController();
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
          rows: List.generate(cubit.productUnits.length, (index) {
            final unit = cubit.productUnits[index];

            return DataRow(cells: [
              DataCell(
                SizedBox(
                  width: 150,
                  child: CustomDropDownUnit(
                    value: unit.unit,
                    onChanged: (value) {
                      if (value != null) {
                        cubit.onUnitChangedd(unitModel: value, index: index);
                      }
                    },
                  ),
                ),
              ),
              DataCell(_customTextFormFieldTable(
                  hintText: "المعامل",
                  validator: (value) => null,
                  controller: unit.factoryController,
                  onChanged: (value) => cubit.updateUnitPrices(index))),
              DataCell(_customTextFormFieldTable(
                hintText: "سعر التكلفة",
                enabled: index==0,
                validator: (value) => MyFormValidators.validateDouble(value, context: context),
                controller: unit.costPriceController,
                onChanged: (value) => cubit.onChangeCost(index),
              )),
              DataCell(_customTextFormFieldTable(
                hintText: "اقل سعر بيع",
                enabled: true,
                validator: (value) => MyFormValidators.validateDouble(value, context: context),
                controller: unit.minPriceWithoutTaxController,
                onChanged: (value) => cubit.onChangeMinPriceWithoutTax(
                    index: index, newValue: value),
              )),
              DataCell(_customTextFormFieldTable(
                hintText: "اقل سعر بيع بالضريبة",
                enabled: true,
                validator: (value) =>
                    MyFormValidators.validateDouble(value, context: context),
                controller: unit.minPriceWithTaxController,
                onChanged: (value) => cubit.onChangeMinPriceWithTax(
                    index: index, newValue: value),
              )),
              DataCell(
                _customTextFormFieldTable(
                    hintText: "سعر البيع",
                    enabled: true,
                    validator: (value) => MyFormValidators.validateDouble(value,
                        context: context),
                    controller: unit.salePriceWithoutTaxController,
                    onChanged: (value) {
                      if (cubit.productUnits[index]
                              .salePriceWithoutTaxController!.text !=
                          value) {
                        cubit.productUnits[index].salePriceWithoutTaxController!
                            .text = value;}
                      cubit.onChangeSalePrice(index);
                    /*  if (index == 0&&cubit.productUnits.length>1) {
                        cubit.onChangeCost(0);
                      }*/
                    }),
              ),
              DataCell(_customTextFormFieldTable(
                  hintText: "سعر البيع بالضريبة",
                  enabled: true,
                  validator: (value) =>
                      MyFormValidators.validateDouble(value, context: context),
                  controller: unit.salePriceWithTaxController,
                  onChanged: (value) {
                    if (cubit.productUnits[index].salePriceWithTaxController!.text != value) {
                      cubit.productUnits[index].salePriceWithTaxController!.text = value;
                    }
                    cubit.changeSalePriceWithTax(index);
                    // if (index == 0&&cubit.productUnits.length>1) {
                    //   cubit.onChangeCost(0);
                    // }
                  })),
              DataCell(_customTextFormFieldTable(
                hintText: "الباركود",
                enabled: true,
                validator: (value) => null,
                controller: unit.barCodeController,
              )),
              DataCell(_customTextFormFieldTable(
                hintText: "باركود الميزان",
                enabled: false,
                validator: (value) => null,
                controller: unit.scaleBarcodeController,
              )),
              DataCell(
                ///todo stop with out condition
                /* isExistingUnit
                    ? Tooltip(
                        message: 'لا يمكن تعديل الوحدات الموجودة مسبقاً',
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'لا يمكن التعديل',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    :*/
                CustomTextBtn(
                  text: "اضافة كمية",
                  textColor: AppColors.primary,
                  onPressed: () {
                    _showAddQuantityDialog(context, cubit, index);
                  },
                ),
              ),
              DataCell(IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: cubit.productUnits.length > 1
                    ? () {
                        cubit.removeNewUnit(index);
                      }
                    : null,
              )),
            ]);
          }),
        ),
      ),
    );
  }

  void _showAddQuantityDialog(
      BuildContext context, EditProductCubit cubit, int index) {
    showDialog(
      context: context,
      builder: (ctx) {
        List<BranchQuantity> tempBranchQuantities = [];
        for (int i = 0; i < cubit.productUnits[index].branchQty.length; i++) {
          tempBranchQuantities
              .add(BranchQuantity.from(cubit.productUnits[index].branchQty[i]));
        }

        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "اضافة كمية افتتاحية",
                  style: AppFontStyle.formText(context: context).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
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
                              quantityController: TextEditingController(),
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tempBranchQuantities.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'لا توجد كميات. اضغط على "اضافة" لإضافة كمية جديدة',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      ...List.generate(
                        tempBranchQuantities.length,
                        (branchIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CustomDropDownBranch(
                                        value: tempBranchQuantities[branchIndex]
                                            .branch,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              tempBranchQuantities[branchIndex]
                                                      .branch =
                                                  BrancheModel.from(value);
                                              tempBranchQuantities[branchIndex]
                                                  .branchId = value.id;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomFormField(
                                        hintText: "الكمية",
                                        controller:
                                            tempBranchQuantities[branchIndex]
                                                .quantityController,
                                        validator: (value) =>
                                            MyFormValidators.validateInteger(
                                                value,
                                                context: context),
                                        onChanged: (value) {
                                          tempBranchQuantities[branchIndex]
                                                  .qunantity =
                                              int.tryParse(value) ?? 0;
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          tempBranchQuantities
                                              .removeAt(branchIndex);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomTextBtn(
                    text: "اغلاق",
                    textColor: Colors.grey.shade700,
                    onPressed: () => Navigator.pop(ctx),
                  ),
                  const SizedBox(width: 10),
                  CustomTextBtn(
                    text: "حفظ",
                    textColor: AppColors.primary,
                    onPressed: () {
                      bool isValid = true;
                      Set<int?> branchIds = {};

                      for (var bq in tempBranchQuantities) {
                        if (bq.branch == null ||
                            bq.quantityController.text.isEmpty) {
                          isValid = false;
                          CustomPopUp.callMyToast(
                            context: context,
                            massage:
                                'الرجاء اختيار الفرع وإدخال الكمية لجميع الصفوف',
                            state: PopUpState.ERROR,
                          );
                          break;
                        }

                        if (branchIds.contains(bq.branch?.id)) {
                          isValid = false;
                          CustomPopUp.callMyToast(
                            context: context,
                            massage: 'لا يمكن تكرار نفس الفرع',
                            state: PopUpState.ERROR,
                          );
                          break;
                        }
                        branchIds.add(bq.branch?.id);
                      }

                      if (isValid) {
                        for (var bq in tempBranchQuantities) {
                          bq.qunantity =
                              int.tryParse(bq.quantityController.text) ?? 0;
                          bq.branchId = bq.branch?.id;
                        }

                        cubit.assignBranchQty(
                            index: index,
                            branchQuantities: tempBranchQuantities);
                        Navigator.pop(ctx);

                        CustomPopUp.callMyToast(
                          context: context,
                          massage: 'تم حفظ الكميات بنجاح',
                          state: PopUpState.SUCCESS,
                        );
                      }
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
}

Padding _customTextFormFieldTable({
  required String hintText,
  required TextEditingController? controller,
  required String? Function(String?)? validator,
  void Function(String)? onChanged,
  bool enabled = true,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: SizedBox(
      width: 150,
      child: CustomFormField(
        controller: controller,
        hintText: hintText,
        enabled: enabled,
        onChanged: enabled ? onChanged : null,
      ),
    ),
  );
}
