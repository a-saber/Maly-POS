// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pos_app/core/helper/printer_helper.dart';
// import 'package:pos_app/core/utils/app_padding.dart';
// import 'package:pos_app/core/widget/custom_app_bar.dart';
// import 'package:pos_app/core/widget/custom_btn.dart';
// import 'package:pos_app/core/widget/custom_checkbox.dart';
// import 'package:pos_app/core/widget/custom_drop_down.dart';
// import 'package:pos_app/core/widget/custom_form_field.dart';
// import 'package:pos_app/features/categories/data/model/category_model.dart';
// import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';
// import 'package:pos_app/features/printer/manager/add_printers/add_printers_cubit.dart';
// import 'package:pos_app/features/printer/manager/add_printers/add_printers_state.dart';
// import 'package:pos_app/features/printer/manager/details_printer/printer_details_cubit.dart';
// import 'package:pos_app/features/printer/manager/details_printer/printer_details_state.dart';
// import 'package:pos_app/core/helper/my_service_locator.dart';
// import 'package:pos_app/features/printer/widget/print_item.dart';
// import 'package:pos_app/generated/l10n.dart';
// import 'package:pos_app/features/printer/data/model/post_printers_model.dart';

// class PrinterDetailsView extends StatelessWidget {
//   final DiscoveredPrinter discoveredPrinter;

//   const PrinterDetailsView({super.key, required this.discoveredPrinter});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => PrinterDetailsCubit()..init()),
//         BlocProvider(
//             create: (_) =>
//                 MyServiceLocator.getSingleton<GetCategoryCubit>()..init()),
//         BlocProvider(
//             create: (_) => AddPrinterCubit(MyServiceLocator.getSingleton())),
//       ],
//       child: BlocBuilder<PrinterDetailsCubit, PrinterDetailsState>(
//         builder: (context, state) {
//           final cubit = PrinterDetailsCubit.get(context);
//           final categoriesCubit = GetCategoryCubit.get(context);
//           final addCubit = AddPrinterCubit.get(context);

//           return Scaffold(
//             appBar: CustomAppBar(title: S.of(context).printerDetails),
//             body: Padding(
//               padding: AppPaddings.defaultView,
//               child: Form(
//                 key: addCubit.formKey,
//                 autovalidateMode: addCubit.autovalidateMode,
//                 child: ListView(
//                   children: [
//                     _PrinterHeader(printer: discoveredPrinter, addCubit: addCubit),
//                     const SizedBox(height: 20),
//                     _PrinterOptions(cubit: cubit),
//                     if (cubit.printCategories)
//                       _CategorySection(
//                         cubit: cubit,
//                         categories: categoriesCubit.categories,
//                       ),
//                     const SizedBox(height: 20),
//                     BlocConsumer<AddPrinterCubit, AddPrinterState>(
//                       listener: (context, state) {
//                         if (state is AddPrinterSuccess) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Printer added successfully"),
//                               backgroundColor: Colors.green,
//                             ),
//                           );
//                           cubit.init();
//                         } else if (state is AddPrinterFail) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(state.errMessage),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                         }
//                       },
//                       builder: (context, state) {
//                         return CustomFilledBtn(
//                           text: S.of(context).done,
//                           onPressed: () async {
//                             final detailsCubit =
//                                 PrinterDetailsCubit.get(context);
//                             final categoriesList = detailsCubit.categoryRows
//                                 .where((row) => row.category != null)
//                                 .map((row) {
//                               final copies =
//                                   int.tryParse(row.copiesCount.text.trim()) ??
//                                       1;
//                               return Categories(
//                                 id: row.category!.id,
//                                 pivot: Pivot(
//                                   categoryId: row.category!.id,
//                                   printReceiptCount: copies,
//                                 ),
//                               );
//                             }).toList();

//                             await addCubit.addPrinterWithCategories(
//                                 context,
//                                 categoriesList,
//                                 detailsCubit.automatic,
//                                 detailsCubit.printReceipt,
//                                 detailsCubit.receiptCopies);
//                           },
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class _PrinterHeader extends StatelessWidget {
//   final DiscoveredPrinter printer;
//   final AddPrinterCubit addCubit;
//   const _PrinterHeader({required this.printer, required this.addCubit});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         PrinterItem(printer: printer),
//         const SizedBox(height: 16),
//         CustomFormField(
//           controller: AddPrinterCubit.get(context).printerNameController,
//           labelText: S.of(context).name,
//         ),
//       ],
//     );
//   }
// }

// class _PrinterOptions extends StatelessWidget {
//   final PrinterDetailsCubit cubit;

//   const _PrinterOptions({required this.cubit});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         BlocBuilder<PrinterDetailsCubit, PrinterDetailsState>(
//           builder: (_, state) => CustomCheckbox(
//             title: S.of(context).automatic,
//             value: cubit.automatic,
//             onChanged: (v) => cubit.toggleAutomatic(v ?? false),
//           ),
//         ),
//         BlocBuilder<PrinterDetailsCubit, PrinterDetailsState>(
//           builder: (_, state) => CustomCheckbox(
//             title: S.of(context).printreceipt,
//             value: cubit.printReceipt,
//             onChanged: (v) => cubit.togglePrintReceipt(v ?? false),
//           ),
//         ),
//         BlocBuilder<PrinterDetailsCubit, PrinterDetailsState>(
//           builder: (_, state) => CustomCheckbox(
//             title: S.of(context).printCategories,
//             value: cubit.printCategories,
//             onChanged: (v) => cubit.togglePrintCategories(v ?? false),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _CategorySection extends StatelessWidget {
//   final PrinterDetailsCubit cubit;
//   final List<CategoryModel> categories;

//   const _CategorySection({required this.cubit, required this.categories});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _CategoryHeader(onAdd: cubit.addCategoryRow),
//         const SizedBox(height: 8),
//         Column(
//           children: List.generate(cubit.categoryRows.length, (index) {
//             return _CategoryRow(
//                 index: index, cubit: cubit, categories: categories);
//           }),
//         ),
//       ],
//     );
//   }
// }

// class _CategoryHeader extends StatelessWidget {
//   final VoidCallback onAdd;

//   const _CategoryHeader({required this.onAdd});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(S.of(context).chooseCategory,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//         IconButton(
//             icon: const Icon(Icons.add, color: Colors.blue), onPressed: onAdd),
//       ],
//     );
//   }
// }

// class _CategoryRow extends StatelessWidget {
//   final int index;
//   final PrinterDetailsCubit cubit;
//   final List<CategoryModel> categories;

//   const _CategoryRow(
//       {required this.index, required this.cubit, required this.categories});

//   @override
//   Widget build(BuildContext context) {
//     final row = cubit.categoryRows[index];
//     final controller = row.copiesCount;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: CustomDropdown<CategoryModel>(
//               value: row.category,
//               items: categories,
//               onChanged: (value) {
//                 cubit.categoryRows[index].category = value;
//                 cubit.onChangeCategory(value);
//               },
//               compareFn: (a, b) => a.id == b.id,
//               builder: (item) =>
//                   Text(item?.name ?? '', style: const TextStyle(fontSize: 16)),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             flex: 1,
//             child: Stack(
//               alignment: Alignment.centerRight,
//               children: [
//                 CustomFormField(
//                   controller: controller,
//                   labelText: S.of(context).copiesCount,
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) {
//                     cubit.categoryRows[index].copiesCount.text = value;
//                     cubit.emit(PrinterDetailsUpdated());
//                   },
//                 ),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_drop_up),
//                       onPressed: () => cubit.incrementCopies(controller),
//                       constraints: const BoxConstraints(),
//                       padding: EdgeInsets.zero,
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.arrow_drop_down),
//                       onPressed: () => cubit.decrementCopies(controller),
//                       constraints: const BoxConstraints(),
//                       padding: EdgeInsets.zero,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 8),
//           if (cubit.categoryRows.length > 1)
//             IconButton(
//               icon: const Icon(Icons.close, color: Colors.red),
//               onPressed: () => cubit.removeCategoryRow(index),
//             ),
//         ],
//       ),
//     );
//   }
// }
