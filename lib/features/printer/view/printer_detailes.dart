import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_checkbox.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
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
    return BlocProvider(
      create: (context) => PrinterDetailsCubit()..init(),
      child: BlocBuilder<PrinterDetailsCubit, PrinterDetailsState>(
        builder: (context, state) {
          final cubit = PrinterDetailsCubit.get(context); 

          return Scaffold(
            appBar: CustomAppBar(title: S.of(context).printerDetails),
            body: Padding(
              padding: AppPaddings.defaultView,
              child: ListView(
                children: [
                  _buildPrinterHeader(context, cubit),
                  const SizedBox(height: 20),
                  _buildPrinterOptions(context, cubit),
                  if (cubit.printCategories)
                    _buildCategorySection(context, cubit),
                  const SizedBox(height: 20),
                  CustomFilledBtn(
                    text: S.of(context).done,
                    onPressed: () {
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
  Widget _buildPrinterHeader(BuildContext context, PrinterDetailsCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrinterItem(printer: printer),
        const SizedBox(height: 16),
        CustomFormField(
          controller:
              TextEditingController(text: printer.device.name ?? 'Unknown'),
          labelText: S.of(context).name,
          validator: (value) =>
              MyFormValidators.validateRequired(value, context: context),
          keyboardType: TextInputType.name,
        ),
      ],
    );
  }

  Widget _buildPrinterOptions(
      BuildContext context, PrinterDetailsCubit cubit) {
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

  Widget _buildCategorySection(
      BuildContext context, PrinterDetailsCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).chooseCategory,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.green),
              onPressed: cubit.addCategoryRow,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: List.generate(cubit.categoryRows.length, (index) {
            final row = cubit.categoryRows[index];
            final controller =
                row['copiesController'] as TextEditingController;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomDropdown<String>(
                      value: row['category'],
                      items: cubit.categories,
                      onChanged: (value) =>
                          cubit.updateCategory(index, value),
                      builder: (item) => Text(
                        item ?? "",
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
                              onPressed: () =>
                                  cubit.incrementCopies(controller),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_drop_down),
                              onPressed: () =>
                                  cubit.decrementCopies(controller),
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
          }),
        ),
      ],
    );
  }
}
