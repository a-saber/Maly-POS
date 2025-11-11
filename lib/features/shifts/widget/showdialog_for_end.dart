import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/branch/view/widget/custom_drop_down_branch.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_cubit.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_state.dart';
import 'package:pos_app/features/shifts/widget/show_toast.dart';
import 'package:pos_app/generated/l10n.dart';

Future<void> showEndShiftDialog(BuildContext context) async {
  final branchesCubit = GetAllBranchesCubit.get(context);
  final shiftCubit = ShiftCubit.get(context);
  BrancheModel? selectedBranch;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: branchesCubit),
          BlocProvider.value(value: shiftCubit),
        ],
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return BlocConsumer<ShiftCubit, ShiftState>(
              listener: (context, state) async {
                print(" State: ${state.runtimeType}"); 
                
                if (state is ShiftError) {
                  showTopToast(context, state.message);
                }
                
                if (state is ShiftEnded) {
                  print(" ShiftEnded detected!"); 
                  
                  Navigator.of(ctx).pop(); 

                  final shift = state.endShiftModel?.shift;
                  final summary = state.endShiftModel?.summary;

                  print("Shift: ${shift?.id}");
                  print("Summary: ${summary?.totalAfterTax}");

                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogCtx) {
                      return AlertDialog(
                        title:  Text(S.of( context).shiftEnded),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (shift != null) ...[
                                Text("${S.of( context).shiftNumber}: #${shift.id ?? '-'}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const Divider(height: 16),
                                Text("${S.of( context).user}: ${shift.user?.name ?? '-'}"),
                                Text("${S.of( context).branch}: ${shift.branch?.name ?? '-'}"),
                                Text("${S.of( context).startAt}: ${shift.startAt ?? '-'}"),
                                Text("${S.of( context).endAt}: ${shift.endAt ?? '-'}"),
                                Text("${S.of( context).ordersCount}: ${shift.ordersCount ?? 0}"),
                                const Divider(height: 16),
                              ],
                              if (summary != null) ...[
                                 Text(" ${S.of(context).summary}:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                                const SizedBox(height: 8),
                                _buildSummaryRow("${S.of(context).subtotal}", summary.subtotal),
                                _buildSummaryRow("${S.of(context).discount}", summary.discountTotal),
                                _buildSummaryRow("${S.of(context).totalAfterDiscount}",
                                    summary.totalAfterDiscount),
                                _buildSummaryRow("  ${S.of(context).tax}", summary.taxTotal),
                                _buildSummaryRow(
                                    " ${S.of(context).totalAfterTax}", summary.totalAfterTax,
                                    isTotal: true),
                                const Divider(height: 12),
                                _buildSummaryRow("${S.of(context).cash}", summary.cashTotal),
                                _buildSummaryRow(" ${S.of(context).online}", summary.onlineTotal),
                              ] else ...[
                               Text(S.of(  context).ordersCount),
                              ],
                            ],
                          ),
                        ),
                        actions: [
                          CustomTextBtn(
                            text: S.of( context).close,
                            onPressed: () => Navigator.pop(dialogCtx),
                          ),
                          CustomFilledBtn(
                            text: S.of( context).print,
                            onPressed: () {
                              // TODO: Implement print
                              Navigator.pop(dialogCtx);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              builder: (ctx, state) {
                return AlertDialog(
                  title:  Text(S.of( context).endShift),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Text(
                        S.of( context).pleaseSelectBranch,
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      CustomDropDownBranch(
                        value: selectedBranch,
                        onChanged: (v) => setState(() => selectedBranch = v),
                      ),
                    ],
                  ),
                  actions: [
                    CustomTextBtn(
                      onPressed: () => Navigator.pop(ctx),
                      text: S.of( context).cancel,
                    ),
                    if (state is ShiftLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () {
                          if (selectedBranch == null) {
                            showTopToast(ctx, S.of( context).pleaseSelectBranch);
                            return;
                          }

                          print(" Calling endShift..."); 
                          shiftCubit.endShift(branchId: selectedBranch!.id!);
                        },
                        child:  Text(S.of( context).endShift),
                      ),
                  ],
                );
              },
            );
          },
        ),
      );
    },
  );
}

Widget _buildSummaryRow(String label, String? value, {bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(value ?? '0',
            style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
      ],
    ),
  );
}