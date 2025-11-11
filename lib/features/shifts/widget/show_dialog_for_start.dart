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
import 'package:pos_app/generated/l10n.dart';

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
            return BlocConsumer<ShiftCubit, ShiftState>(
              listener: (context, state) async {
                if (state is ShiftStarted) {
                  Navigator.of(ctx).pop();

                  final shift = state.shift;
                  await showDialog(
                    context: context,
                    builder: (dialogCtx) {
                      return AlertDialog(
                        title:  Text(S.of(context).shiftStarted),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (shift != null) ...[
                              Text("${S.of(context).shiftNumber}: ${shift.id ?? '-'}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text("${S.of(context).user}: ${shift.user?.name ?? '-'}"),
                              Text("${S.of(context).branch}: ${shift.branch?.name ?? '-'}"),
                              Text(
                                  "${S.of(context).openingQuantity}: ${shift.openingQuantity ?? 0}"),
                              Text("${S.of(context).startAt}: ${shift.startAt ?? '-'}"),
                            ],
                          ],
                        ),
                        actions: [
                          CustomFilledBtn(
                            text: S.of(context).ok,
                            onPressed: () => Navigator.pop(dialogCtx),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              builder: (ctx, state) {
                return AlertDialog(
                  title:  Text(S.of(context).startShift),
                  content: Form(
                    key: shiftCubit.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomDropDownBranch(
                          value: selectedBranch,
                          onChanged: (v) => setState(() => selectedBranch = v),
                        ),
                        const SizedBox(height: 12),
                        CustomFormField(
                          controller: shiftCubit.cashController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          labelText: S.of(context).cash,
                          validator: (value) => MyFormValidators.validateDouble(
                              value,
                              context: ctx),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    CustomTextBtn(
                      onPressed: () => Navigator.pop(ctx),
                      text: S.of(context).cancel,
                    ),
                    if (state is ShiftLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () {
                          final isFormValid =
                              shiftCubit.formKey.currentState!.validate();
                          final isBranchSelected = selectedBranch != null;

                          if (!isFormValid || !isBranchSelected) {
                            if (!isBranchSelected) {
                              showTopToast(ctx, S.of( context).pleaseSelectBranch);
                            }
                            return;
                          }

                          final cash =
                              double.tryParse(shiftCubit.cashController.text);
                          if (cash == null || cash < 0) {
                            showTopToast(ctx, S.of( context).pleaseEnterValidCash);
                            return;
                          }

                          shiftCubit.startShift(
                            branchId: selectedBranch!.id!,
                            cash: cash,
                          );
                        },
                        child:  Text(S.of(context).startShift),
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
