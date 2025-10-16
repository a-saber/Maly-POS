import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_checkbox.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';
import 'package:pos_app/features/printer/manager/details_printer/printer_details_cubit.dart';
import 'package:pos_app/features/printer/manager/details_printer/printer_details_state.dart';
import 'package:pos_app/features/printer/widget/print_item.dart';
import 'package:pos_app/core/helper/printer_helper.dart';
import 'package:pos_app/generated/l10n.dart';

class PrinterDetailsView extends StatelessWidget {
  final DiscoveredPrinter printer;

  const PrinterDetailsView({super.key, required this.printer});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PrinterDetailsCubit()..init()),
         BlocProvider(create: (_) => MyServiceLocator.getSingleton<GetCategoryCubit>()..init()),
      ],
      child: BlocBuilder<PrinterDetailsCubit, PrinterDetailsState>(
        builder: (context, state) {
          final cubit = PrinterDetailsCubit.get(context);
          final categoriesCubit = GetCategoryCubit.get(context);

          return Scaffold(
            appBar: CustomAppBar(title: S.of(context).printerDetails),
            body: Padding(
              padding: AppPaddings.defaultView,
              child: ListView(
                children: [
                  _PrinterHeader(printer: printer),
                  const SizedBox(height: 20),
                  _PrinterOptions(cubit: cubit),
                  if (cubit.printCategories)
                    _CategorySection(
                      cubit: cubit,
                      categories: categoriesCubit.categories,
                    ),
                  const SizedBox(height: 20),
                  CustomFilledBtn(
                    text: S.of(context).done,
                    onPressed: () {
                      // handle save
                    },
                  ),
                ],
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

  const _PrinterHeader({required this.printer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrinterItem(printer: printer),
        const SizedBox(height: 16),
        CustomFormField(
          controller: TextEditingController(
            text: printer.device.name ?? 'Unknown',
          ),
          labelText: S.of(context).name,
          validator: (value) =>
              MyFormValidators.validateRequired(value, context: context),
          keyboardType: TextInputType.name,
        ),
      ],
    );
  }
}

class _PrinterOptions extends StatelessWidget {
  final PrinterDetailsCubit cubit;

  const _PrinterOptions({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCheckbox(
          title: S.of(context).automatic,
          value: cubit.automatic,
          onChanged: (value) => cubit.toggleAutomatic(value ?? false),
        ),
        CustomCheckbox(
          title: S.of(context).printreceipt,
          value: cubit.printReceipt,
          onChanged: (value) => cubit.togglePrintReceipt(value ?? false),
        ),
        CustomCheckbox(
          title: S.of(context).printCategories,
          value: cubit.printCategories,
          onChanged: (value) => cubit.togglePrintCategories(value ?? false),
        ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  final PrinterDetailsCubit cubit;
  final List<CategoryModel> categories;

  const _CategorySection({
    required this.cubit,
    required this.categories,
  });

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
              index: index,
              cubit: cubit,
              categories: categories,
            );
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
        Text(
          S.of(context).chooseCategory,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.green),
          onPressed: onAdd,
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final int index;
  final PrinterDetailsCubit cubit;
  final List<CategoryModel> categories;

  const _CategoryRow({
    required this.index,
    required this.cubit,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final row = cubit.categoryRows[index];
    final controller = row.copiesCount ?? TextEditingController(text: '1');

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
                cubit.categoryRows[index].category = value;
                cubit.onChangeCategory(value);
              },
              compareFn: (item, selectedItem) => item.id == selectedItem.id,
              builder: (item) => Text(
                item?.name ?? '',
                style: const TextStyle(fontSize: 16),
              ),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter copy count';
                    }
                    final number = int.tryParse(value);
                    if (number == null || number < 1) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_drop_up),
                      onPressed: () => cubit.incrementCopies(controller),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_drop_down),
                      onPressed: () => cubit.decrementCopies(controller),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
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
