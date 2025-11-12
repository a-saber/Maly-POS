import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/branch/view/widget/custom_drop_down_branch.dart';
import 'package:pos_app/features/shifts/manager/shift_cubit/shift_cubit.dart';
import 'package:pos_app/features/shifts/manager/shift_cubit/shift_state.dart';

Future<void> showStartShiftDialog(BuildContext context,
    {GetAllBranchesCubit? branchescubit,
    ShiftCubit? shiftcubit,
    BrancheModel? currentBranch}) async {
  final branchesCubit = branchescubit ?? GetAllBranchesCubit.get(context);
  final shiftCubit = shiftcubit ?? ShiftCubit.get(context);

  final TextEditingController cashController = TextEditingController();
  BrancheModel? selectedBranch;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      selectedBranch = currentBranch;
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: branchesCubit),
          BlocProvider.value(value: shiftCubit),
        ],
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: const Text("Start Shift"),
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
                  const SizedBox(height: 12),
                  CustomFormField(
                    controller: cashController,
                    keyboardType: TextInputType.number,
                    labelText: "Cash",
                    validator: (value) => MyFormValidators.validateDecimalOrInt(
                        value,
                        context: ctx),
                  ),
                ],
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
                        if (selectedBranch == null) return;

                        ShiftCubit.get(ctx).startShift(
                          branchId: selectedBranch!.id!,
                          cash: double.tryParse(cashController.text) ?? 0.0,
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
