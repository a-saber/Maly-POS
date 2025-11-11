import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/branch/view/widget/custom_drop_down_branch.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_cubit.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_state.dart';

Future<void> showShiftFilterDialog(
  BuildContext context, {
  required GetAllBranchesCubit branchesCubit,
  required ShiftCubit shiftCubit,
}) async {
  BrancheModel? selectedBranch;
  DateTime? startDate;
  DateTime? endDate;

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
            return AlertDialog(
              title: const Text("Filter Shifts"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Branch Dropdown (Optional)
                    CustomDropDownBranch(
                      value: selectedBranch,
                      onChanged: (v) => setState(() => selectedBranch = v),
                    ),
                    const SizedBox(height: 12),

                    // User Dropdown (Optional)
                   CustomFormField(
                     controller: shiftCubit.useridController,
                     labelText: "User",
                     keyboardType: TextInputType.number,
                   ),
                    const SizedBox(height: 12),

                    // Start Date (Optional)
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: ctx,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) setState(() => startDate = date);
                      },
                      child: Text(
                        startDate != null
                            ? "Start: ${startDate!.toLocal()}".split(' ')[0]
                            : "Select Start Date",
                      ),
                    ),
                    const SizedBox(height: 8),

                    // End Date (Optional)
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: ctx,
                          initialDate: endDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) setState(() => endDate = date);
                      },
                      child: Text(
                        endDate != null
                            ? "End: ${endDate!.toLocal()}".split(' ')[0]
                            : "Select End Date",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                CustomTextBtn(
                  onPressed: () => Navigator.pop(ctx),
                  text: "Cancel",
                ),
                BlocBuilder<ShiftCubit, ShiftState>(
                  builder: (ctx, state) {
                    if (state is ShiftLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        shiftCubit.filterShifts(
                          userId: shiftCubit.useridController.text.isNotEmpty ? int.parse(shiftCubit.useridController.text) : null,
                          branchId: selectedBranch?.id,
                          startAt: startDate,
                          endAt: endDate,
                        );
                        Navigator.pop(ctx);
                      },
                      child: const Text("Apply"),
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
