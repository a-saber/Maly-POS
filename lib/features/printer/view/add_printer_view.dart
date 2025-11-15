import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/helper/printer_helper.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_checkbox.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/features/printer/data/model/printer_model.dart';
import 'package:pos_app/features/printer/manager/printer_data_cubit/printer_data_cubit.dart';
import 'package:pos_app/features/printer/widget/print_item.dart';
import 'package:pos_app/generated/l10n.dart';
import '../../../core/api/api_response.dart';
import '../data/repo/printer_repo.dart';
import '../manager/printer_data_cubit/printer_data_state.dart';
import '../manager/scan_printer/scan_printer_cubit.dart';
import '../widget/custom_delete_printer_dialog.dart';

class EditPrinterView extends StatelessWidget {
  const EditPrinterView({super.key, required this.printerModel});
  final PrinterModel printerModel;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                MyServiceLocator.getSingleton<GetCategoryCubit>()..init()),
        BlocProvider(
            create: (_) => PrinterDataCubit(
                MyServiceLocator.getSingleton<PrinterRepo>(),
                printerModel: printerModel)),
      ],
      child: BlocConsumer<PrinterDataCubit, PrinterDataState>(
        listenWhen: (previous, current) =>
            current is PrinterDataSuccessState ||
            current is PrinterDataErrorState,
        listener: (context, state) {
          if (state is PrinterDataSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Printer updated successfully"),
                backgroundColor: Colors.green,
              ),
            );
            MyServiceLocator.getSingleton<GetCategoryCubit>().init();
            MyServiceLocator.getSingleton<GetPrintersCubit>()
                .fetchPrintersFromApi(isFresh: true);
            Navigator.pop(context);
          } else if (state is PrinterDataErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.mounted
                      ? mapStatusCodeToMessage(context, state.errMessage)
                      : 'error',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = PrinterDataCubit.get(context);
          final categoriesCubit = GetCategoryCubit.get(context);
          print("Product Mode ${printerModel.toJson([])}");
          print("Product Mode ${printerModel.fromscan}");

          return Scaffold(
            appBar: CustomAppBar(
              title: S.of(context).printerDetails,
              actions: [
                CustomTextBtn(
                  text: S.of(context).delete,
                  onPressed: () async {
                    await showDeletePrinterConfirmDialog(
                      context: context,
                      printer: printerModel,
                      goBack: true,
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: AppPaddings.defaultView,
              child: Form(
                key: cubit.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  children: [
                    (printerModel.discoveredPrinter != null)
                        ? _PrinterHeader(
                            printer: printerModel.discoveredPrinter!,
                            cubit: cubit)
                        : _printerIpHeader(cubit: cubit, context: context),
                    const SizedBox(height: 20),
                    _PrinterOptions(cubit: cubit),
                    if (cubit.printCategories)
                      _CategorySection(
                        cubit: cubit,
                        categories: categoriesCubit.categories,
                      ),
                    const SizedBox(height: 20),
                    state is PrinterDataLoadingState
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustomFilledBtn(
                            text: S.of(context).done,
                            onPressed: () => cubit.editPrinter(),
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    CustomFilledBtn(
                        text: S.of(context).testPrint,
                        onPressed: () async {
                          if (printerModel.discoveredPrinter != null) {
                            await PrinterHelper()
                                .printTest(printerModel.discoveredPrinter!);
                          }
                        })
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _printerIpHeader(
    {required PrinterDataCubit cubit, required BuildContext context}) {
  return Column(
    children: [
      CustomFormField(
          controller: cubit.ipController,
          labelText: "Printer IP",
          validator: (v) => MyFormValidators.validateIP(v, context: context)),
      const SizedBox(height: 16),
      CustomFormField(
        controller: cubit.printerName,
        labelText: S.of(context).name,
      ),
    ],
  );
}

class AddPrinterView extends StatelessWidget {
  final DiscoveredPrinter discoveredPrinter;

  const AddPrinterView({super.key, required this.discoveredPrinter});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                MyServiceLocator.getSingleton<GetCategoryCubit>()..init()),
        BlocProvider(
            create: (_) => PrinterDataCubit(
                MyServiceLocator.getSingleton<PrinterRepo>(),
                discoveredPrinter: discoveredPrinter)),
      ],
      child: BlocConsumer<PrinterDataCubit, PrinterDataState>(
        listenWhen: (previous, current) =>
            current is PrinterDataSuccessState ||
            current is PrinterDataErrorState,
        listener: (context, state) {
          if (state is PrinterDataSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Printer added successfully"),
                backgroundColor: Colors.green,
              ),
            );
            MyServiceLocator.getSingleton<GetCategoryCubit>().init();
            MyServiceLocator.getSingleton<GetPrintersCubit>()
                .fetchPrintersFromApi(isFresh: true);
            Navigator.pop(context);
          } else if (state is PrinterDataErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.mounted
                    ? mapStatusCodeToMessage(context, state.errMessage)
                    : 'error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = PrinterDataCubit.get(context);
          final categoriesCubit = GetCategoryCubit.get(context);

          return Scaffold(
            appBar: CustomAppBar(
              title: S.of(context).printerDetails,
            ),
            body: Padding(
              padding: AppPaddings.defaultView,
              child: Form(
                key: cubit.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  children: [
                    _PrinterHeader(printer: discoveredPrinter, cubit: cubit),
                    const SizedBox(height: 20),
                    _PrinterOptions(cubit: cubit),
                    if (cubit.printCategories)
                      _CategorySection(
                        cubit: cubit,
                        categories: categoriesCubit.categories,
                      ),
                    const SizedBox(height: 20),
                    state is PrinterDataLoadingState
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustomFilledBtn(
                            text: S.of(context).done,
                            onPressed: () => cubit.addPrinter(),
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    CustomFilledBtn(
                        text: S.of(context).testPrint,
                        onPressed: () async =>
                            await PrinterHelper().printTest(discoveredPrinter))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PrinterHeader extends StatelessWidget {
  final DiscoveredPrinter printer;
  final PrinterDataCubit cubit;
  const _PrinterHeader({required this.printer, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrinterItem(printer: printer),
        const SizedBox(height: 16),
        CustomFormField(
          controller: PrinterDataCubit.get(context).printerName,
          labelText: S.of(context).name,
        ),
      ],
    );
  }
}

final List<String> paperSizes = ["80mm", "58mm", "72mm"];

class _PrinterOptions extends StatelessWidget {
  final PrinterDataCubit cubit;

  const _PrinterOptions({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropdown<String>(
          // hint: S.of(context).selectpapersize ,
          hint: "Select Paper Size",
          value: cubit.paperSize,
          items: paperSizes,
          onChanged: (value) => cubit.changePaperSize(value),
          builder: (item) => Text(
            item ?? '',
            style: const TextStyle(fontSize: 16),
          ),
          validator: (value) =>
              MyFormValidators.validateRequired(value, context: context),
        ),
        SizedBox(height: 16),
        CustomFormField(
          controller: PrinterDataCubit.get(context).printReceiptController,
          labelText: S.of(context).printReceipt,
          validator: (value) =>
              MyFormValidators.validateInteger(value, context: context),
        ),
        BlocBuilder<PrinterDataCubit, PrinterDataState>(
          builder: (_, state) => CustomCheckbox(
            title: S.of(context).automatic,
            value: cubit.automatic,
            onChanged: (v) => cubit.toggleAutomatic(v ?? false),
          ),
        ),
        BlocBuilder<PrinterDataCubit, PrinterDataState>(
          builder: (_, state) => CustomCheckbox(
            title: S.of(context).printCategories,
            value: cubit.printCategories,
            onChanged: (v) => cubit.togglePrintCategories(v ?? false),
          ),
        ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  final PrinterDataCubit cubit;
  final List<CategoryModel> categories;

  const _CategorySection({required this.cubit, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CategoryHeader(onAdd: cubit.addCategoryRow),
        const SizedBox(height: 8),
        Column(
          children: List.generate(cubit.categoryRows.length, (index) {
            return _CategoryRow(
                index: index, cubit: cubit, categories: categories);
          }),
        ),
      ],
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final VoidCallback onAdd;

  const _CategoryHeader({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(S.of(context).chooseCategory,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        IconButton(
            icon: const Icon(Icons.add, color: Colors.blue), onPressed: onAdd),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final int index;
  final PrinterDataCubit cubit;
  final List<CategoryModel> categories;

  const _CategoryRow(
      {required this.index, required this.cubit, required this.categories});

  @override
  Widget build(BuildContext context) {
    final row = cubit.categoryRows[index];
    final controller = row.copiesCount;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: CustomDropdown<CategoryModel>(
              value: row.category,
              items: categories,
              onChanged: (value) {
                if (value != null) {
                  cubit.categoryRows[index].category = value;
                  cubit.assignCategories(index: index, model: value);
                }
              },
              compareFn: (a, b) => a.id == b.id,
              builder: (item) =>
                  Text(item?.name ?? '', style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                CustomFormField(
                  controller: controller,
                  labelText: S.of(context).copiesCount,
                  keyboardType: TextInputType.number,
                  validator: (value) => MyFormValidators.validateInteger(
                    value,
                    context: context,
                  ),
                  // onChanged: (value) {
                  //   cubit.categoryRows[index].copiesCount.text = value;
                  //   cubit.emit(PrinterDetailsUpdated());
                  // },
                ),
                // Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     IconButton(
                //       icon: const Icon(Icons.arrow_drop_up),
                //       onPressed: () => cubit.incrementCopies(controller),
                //       constraints: const BoxConstraints(),
                //       padding: EdgeInsets.zero,
                //     ),
                //     IconButton(
                //       icon: const Icon(Icons.arrow_drop_down),
                //       onPressed: () => cubit.decrementCopies(controller),
                //       constraints: const BoxConstraints(),
                //       padding: EdgeInsets.zero,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (cubit.categoryRows.length > 1)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => cubit.removeCategoryRow(index),
            ),
        ],
      ),
    );
  }
}
