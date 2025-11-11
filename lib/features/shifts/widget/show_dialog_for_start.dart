import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/branch/view/widget/custom_drop_down_branch.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_cubit.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_state.dart';
import 'package:pos_app/features/shifts/widget/show_toast.dart';

Future<void> showStartShiftDialog(BuildContext context) async {
  final branchesCubit = GetAllBranchesCubit.get(context);
  final shiftCubit = ShiftCubit.get(context);

  BrancheModel? selectedBranch;
  shiftCubit.cashController.text = "0.0";

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
              title: const Text("Start Shift"),
              content: Form(
                key: shiftCubit.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Branch Dropdown
                    CustomDropDownBranch(
                      value: selectedBranch,
                      onChanged: (v) => setState(() => selectedBranch = v),
                    ),
                    const SizedBox(height: 12),

                    // Cash input
                    CustomFormField(
                      controller: shiftCubit.cashController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      labelText: "Cash",
                      
                      validator: (value) =>
                          MyFormValidators.validateDouble(value, context: ctx),
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
                        final isFormValid =
                            shiftCubit.formKey.currentState!.validate();
                        final isBranchSelected = selectedBranch != null;

                        if (!isFormValid || !isBranchSelected) {
                          if (!isBranchSelected) {
                            showTopToast(
                              Navigator.of(ctx).context,
                              "Please select a branch",
                            );
                          }
                          return;
                        }
                        final cash =
                            double.tryParse(shiftCubit.cashController.text);
                        if (cash == null|| cash <= 0) return;
                        shiftCubit.startShift(
                          branchId: selectedBranch!.id!,
                          cash: cash,
                        );

                        Navigator.pop(ctx);
                      },
                      child: const Text("Start"),
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
