import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/branch/view/widget/custom_drop_down_branch.dart';
import 'package:pos_app/features/shifts/manager/shift_cubit/shift_cubit.dart';
import 'package:pos_app/features/shifts/manager/shift_cubit/shift_state.dart';

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
        child: StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            title: const Text("End Shift"),
            content: CustomDropDownBranch(
              value: selectedBranch,
              onChanged: (v) {
                setState(() {
                  selectedBranch = v;
                });
              },
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

                      ShiftCubit.get(ctx).endShift(
                        branchId: selectedBranch!.id!,
                      );

                      Navigator.pop(ctx);
                    },
                    child: const Text("End"),
                  );
                },
              ),
            ],
          );
        }),
      );
    },
  );
}
