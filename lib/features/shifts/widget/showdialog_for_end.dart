import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/branch/view/widget/custom_drop_down_branch.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_cubit.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_state.dart';
import 'package:pos_app/features/shifts/widget/show_toast.dart';

Future<void> showEndShiftDialog(BuildContext context) async {
  final branchesCubit = GetAllBranchesCubit.get(context);
  BrancheModel? selectedBranch;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: branchesCubit),
          BlocProvider.value(value: ShiftCubit.get(context)),
        ],
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: const Text("End Shift"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDropDownBranch(
                    value: selectedBranch,
                    onChanged: (v) {
                      setState(() {
                        selectedBranch = v;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                CustomTextBtn(
                  onPressed: () => Navigator.pop(ctx),
                  text: "Cancel",
                ),
                BlocConsumer<ShiftCubit, ShiftState>(
                  listener: (context, state) async {
                    if (state is ShiftEnded) {
                    
                      Navigator.of(ctx).pop();

                      final shift = state.shifts.isNotEmpty ? state.shifts.first : null;
                      final summary = state.endShiftModel?.summary;

                     
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogCtx) {
                          return AlertDialog(
                            title: const Text("Shift Ended"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (shift != null) ...[
                                  Text("Shift ID: ${shift.id ?? '-'}"),
                                  Text("User: ${shift.user?.name ?? '-'}"),
                                  Text("Branch: ${shift.branch?.name ?? '-'}"),
                                  Text("Orders Count: ${shift.ordersCount ?? 0}"),
                                ],
                                const SizedBox(height: 8),
                                if (summary != null) ...[
                                  Text("Subtotal: ${summary.subtotal ?? '0'}"),
                                  Text("Discount: ${summary.discountTotal ?? '0'}"),
                                  Text("Total After Discount: ${summary.totalAfterDiscount ?? '0'}"),
                                  Text("Cash Total: ${summary.cashTotal ?? '0'}"),
                                  Text("Online Total: ${summary.onlineTotal ?? '0'}"),
                                ],
                              ],
                            ),
                            actions: [
                              CustomFilledBtn(
                                text: "Print",
                                onPressed: () {
                                 
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
                    if (state is ShiftLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (selectedBranch == null) {
                          showTopToast(
                            ctx,
                            "Please select a branch",
                          );
                          return;
                        }

                        ShiftCubit.get(ctx).endShift(branchId: selectedBranch!.id!);
                      },
                      child: const Text("End"),
                    );
                  },
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
