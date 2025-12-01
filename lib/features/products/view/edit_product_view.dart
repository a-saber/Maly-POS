import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_helper.dart';
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

/// EDIT PRODUCT VIEW WRAPPER
class EditProductView extends StatelessWidget {
  final ProductModel product;
  const EditProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    final apiHelper = ApiHelper(dio: dio);

    return BlocProvider(
      create: (context) => EditProductCubit(
        repo: ProductsRepo(api: apiHelper),
        unitsRepo: UnitsRepo(api: apiHelper),
        categoryRepo: CategoryRepo(api: apiHelper),
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
              Navigator.pop(context);
            } else if (state is EditProductFailing) {
              if (context.mounted) {
                CustomPopUp.callMyToast(
                    context: context,
                    massage: state.errMessage,
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

/// MOBILE BODY
class EditProductMobileBody extends StatelessWidget {
  final EditProductState state;
  const EditProductMobileBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return EditProductDataView();
  }
}

/// TABLET & DESKTOP BODY
class EditProductTabletAndDesktopBody extends StatelessWidget {
  final EditProductState state;
  const EditProductTabletAndDesktopBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return EditProductMobileBody(state: state); // إعادة استخدام نفس موبايل
  }
}

/// DATA VIEW
class EditProductDataView extends StatefulWidget {
  const EditProductDataView({super.key});

  @override
  State<EditProductDataView> createState() => _EditProductDataViewState();
}

class _EditProductDataViewState extends State<EditProductDataView> {
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
                    onPressed: cubit.editProduct,
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
              DataCell(SizedBox(
                width: 150,
                child: CustomDropDownUnit(
                  value: unit.unit,
                  onChanged: (value) {
                    if (value != null)
                      cubit.onUnitChangedd(unitModel: value, index: index);
                  },
                ),
              )),
              DataCell(_customTextFormFieldTable(
                hintText: "المعامل",
                enabled: index != 0,
                validator: (value) =>
                    MyFormValidators.validateDouble(value, context: context),
                controller: unit.factoryController,
                onChanged: (value) => cubit.updateUnitPrices(index),
              )),
              DataCell(_customTextFormFieldTable(
                hintText: "سعر التكلفة",
                controller: unit.costPriceController,
                validator: (value) =>
                    MyFormValidators.validateDouble(value, context: context),
                onChanged: (value) {
                  if (index == 0) cubit.onChangeCost(0);
                },
              )),
              DataCell(_customTextFormFieldTable(
                hintText: "اقل سعر بيع",
                controller: unit.minPriceWithoutTaxController,
                validator: (value) =>
                    MyFormValidators.validateDouble(value, context: context),
                onChanged: (value) => cubit.onChangeMinPriceWithoutTax(
                    index: index, newValue: value),
              )),
              DataCell(_customTextFormFieldTable(
                hintText: "اقل سعر بيع بالضريبة",
                controller: unit.minPriceWithTaxController,
                validator: (value) =>
                    MyFormValidators.validateDouble(value, context: context),
                onChanged: (value) => cubit.onChangeMinPriceWithTax(
                    index: index, newValue: value),
              )),
              DataCell(_customTextFormFieldTable(
                hintText: "سعر البيع",
                controller: unit.salePriceWithoutTaxController,
                validator: (value) =>
                    MyFormValidators.validateDouble(value, context: context),
                onChanged: (value) =>
                    cubit.onChangeSalePrice(index: index, newValue: value),
              )),
              DataCell(_customTextFormFieldTable(
                hintText: "سعر البيع بالضريبة",
                controller: unit.salePriceWithTaxController,
                validator: (value) =>
                    MyFormValidators.validateDouble(value, context: context),
                onChanged: (value) => cubit.onChangeSalePriceWithTax(
                    index: index, newValue: value),
              )),
              DataCell(_customTextFormFieldTable(
                hintText: "الباركود",
                controller: unit.barCodeController,
                validator: (value) =>
                    MyFormValidators.validateRequired(value, context: context),
                onChanged: (value) {},
              )),
              DataCell(_customTextFormFieldTable(
                hintText: "باركود الميزان",
                controller: unit.scaleBarcodeController,
                validator: (value) =>
                    MyFormValidators.validateRequired(value, context: context),
                onChanged: (value) {},
              )),
              DataCell(
                CustomTextBtn(
                  text: "اضافة كمية",
                  
                  onPressed: index == 0
                      ? null
                      :
                   () {
                    
                    showDialog(
                      context: context,
                      builder: (ctx) {
                    
                        List<BranchQuantity> tempBranchQuantities = [];
                        if (cubit.productUnits[index].branchQty.isNotEmpty) {
                          for (var bq in cubit.productUnits[index].branchQty) {
                            tempBranchQuantities.add(BranchQuantity.from(bq));
                          }
                        } else {
                        
                          tempBranchQuantities.add(
                            BranchQuantity(
                              branchId: null,
                              branch: null,
                              qunantity: 0,
                              quantityController:
                                  TextEditingController(text: "0"),
                            ),
                          );
                        }

                        return StatefulBuilder(
                          builder: (ctx, setState) => AlertDialog(
                            title: Column(
                              mainAxisSize: MainAxisSize.min,
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
                                                  TextEditingController(
                                                      text: "0"),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                ...List.generate(
                                  tempBranchQuantities.length,
                                  (i) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CustomDropDownBranch(
                                              value: tempBranchQuantities[i]
                                                  .branch,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value != null) {
                                                    tempBranchQuantities[i]
                                                        .branch = value;
                                                  }
                                                });
                                              }),
                                        ),
                                        Expanded(
                                          child: CustomFormField(
                                            hintText: "الكمية",
                                            controller: tempBranchQuantities[i]
                                                .quantityController,
                                            validator: (value) =>
                                                MyFormValidators
                                                    .validateInteger(value,
                                                        context: context),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              tempBranchQuantities.removeAt(i);
                                            });
                                          },
                                          icon: Icon(Icons.cancel_outlined),
                                        )
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
                                      for (var bq in tempBranchQuantities) {
                                        bq.qunantity = int.tryParse(
                                                bq.quantityController.text) ??
                                            0;
                                        bq.branchId = bq.branch?.id;
                                      }

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
              DataCell(IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: index == 0
                    ? null
                    : () => cubit.removeProductUnit(index: index),
              )),
            ]);
          }),
        ),
      ),
    );
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
          onChanged: onChanged,
        ),
      ),
    );
  }
}
