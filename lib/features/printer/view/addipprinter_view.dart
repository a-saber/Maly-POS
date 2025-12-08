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
import 'package:pos_app/features/printer/data/repo/printer_repo.dart';
import 'package:pos_app/features/printer/manager/printer_data_cubit/printer_data_cubit.dart';
import 'package:pos_app/features/printer/manager/scan_printer/scan_printer_cubit.dart';
import 'package:pos_app/generated/l10n.dart';
import '../manager/printer_data_cubit/printer_data_state.dart';

class AddIpPrinterView extends StatelessWidget {
  const AddIpPrinterView({
    super.key,
  });
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
          ),
        ),
        BlocProvider(
            create: (_) =>
                MyServiceLocator.getSingleton<GetCategoryCubit>()..init()),
        // BlocProvider(create: (_) => PrinterDataCubit(MyServiceLocator.getSingleton<PrinterRepo>())),
      ],
      child: BlocConsumer<PrinterDataCubit, PrinterDataState>(
        listener: (context, state) {
          if (state is PrinterDataSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Printer added successfully"),
                  backgroundColor: Colors.green),
            );
            MyServiceLocator.getSingleton<GetCategoryCubit>().init();
            MyServiceLocator.getSingleton<GetPrintersCubit>()
                .fetchPrintersFromApi(isFresh: true);
            Navigator.pop(context);
          } else if (state is PrinterDataErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("erorr"), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final cubit = PrinterDataCubit.get(context);
          final categoriesCubit = GetCategoryCubit.get(context);

          return Scaffold(
            appBar: CustomAppBar(title: S.of(context).printerDetails),
            body: Padding(
              padding: AppPaddings.defaultView,
              child: Form(
                key: cubit.formKey,
                child: ListView(
                  children: [
                    CustomFormField(
                        controller: cubit.ipController,
                        labelText: "Printer IP",
                        validator: (v) =>
                            MyFormValidators.validateIP(v, context: context)),
                    const SizedBox(height: 16),
                    CustomFormField(
                      controller: cubit.printerName,
                      labelText: S.of(context).name,
                    ),
                    const SizedBox(height: 20),
                    _PrinterOptions(cubit: cubit),
                    if (cubit.printCategories)
                      _CategorySection(
                          cubit: cubit, categories: categoriesCubit.categories),
                    const SizedBox(height: 20),
                    state is PrinterDataLoadingState
                        ? Center(child: CircularProgressIndicator())
                        : CustomFilledBtn(
                            text: S.of(context).done,
                            onPressed: () => cubit.addPrinter(fromScan: false),
                          ),
                    const SizedBox(height: 30),
                    CustomFilledBtn(
                      text: S.of(context).testPrint,
                      onPressed: () async => PrinterHelper().printTestByIp(
                        cubit.ipController.text,
                        paperSize: cubit.paperSize.replaceAll('mm', ''),
                      ),
                    ),
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

class _PrinterOptions extends StatelessWidget {
  final PrinterDataCubit cubit;
  const _PrinterOptions({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropdown<String>(
          value: cubit.paperSize,
          items: cubit.paperSizes,
          onChanged: cubit.changePaperSize,
          builder: (item) =>
              Text(item ?? '', style: const TextStyle(fontSize: 16)),
          validator: (value) =>
              MyFormValidators.validateRequired(value, context: context),
        ),
        CustomDropdown<String>(
          value: cubit.paperSize,
          items: cubit.paperSizes,
          onChanged: cubit.changePaperSize,
          builder: (item) =>
              Text(item ?? '', style: const TextStyle(fontSize: 16)),
          validator: (value) =>
              MyFormValidators.validateRequired(value, context: context),
        ),

        const SizedBox(height: 16),
        CustomFormField(
          controller: cubit.printReceiptController,
          labelText: S.of(context).printReceipt,
          validator: (value) =>
              MyFormValidators.validateInteger(value, context: context),
        ),
        const SizedBox(height: 8),
        CustomCheckbox(
          title: S.of(context).automatic,
          value: cubit.automatic,
          onChanged: (v) => cubit.toggleAutomatic(v ?? false),
        ),
        CustomCheckbox(
          title: S.of(context).printCategories,
          value: cubit.printCategories,
          onChanged: (v) => cubit.togglePrintCategories(v ?? false),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context).chooseCategory,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: cubit.addCategoryRow),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: List.generate(cubit.categoryRows.length, (index) {
            final row = cubit.categoryRows[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomDropdown<CategoryModel>(
                      value: row.category,
                      items: categories,
                      compareFn: (a, b) => a.id == b.id,
                      onChanged: (value) =>
                          cubit.assignCategories(model: value!, index: index),
                      builder: (item) => Text(item?.name ?? ''),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomFormField(
                      controller: row.copiesCount,
                      labelText: S.of(context).copiesCount,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          MyFormValidators.validateInteger(v, context: context),
                    ),
                  ),
                  if (cubit.categoryRows.length > 1)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => cubit.removeCategoryRow(index),
                    )
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
