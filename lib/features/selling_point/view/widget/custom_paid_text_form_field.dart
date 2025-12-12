import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomPaidTextFormField extends StatelessWidget {
  const CustomPaidTextFormField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 10),
        BlocBuilder<SellingPointProductCubit, SellingPointProductState>(
          builder: (context, state) {
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: MyServiceLocator.getSingleton<
                        SellingPointProductCubit>(),
                    child: _PaidDialog(),
                  ),
                );
              },
              child: CustomFormField(
                enabled: false,
                controller:
                    SellingPointProductCubit.get(context).paidController,
                labelText: S.of(context).paid,
                validator: (value) => MyFormValidators.validateDoublePrice(
                  value,
                  context: context,
                ),
                keyboardType: TextInputType.number,
              ),
            );
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class _PaidDialog extends StatefulWidget {
  @override
  State<_PaidDialog> createState() => _PaidDialogState();
}

class _PaidDialogState extends State<_PaidDialog> {
  late TextEditingController cashController;
  late TextEditingController remainingController;
  late TextEditingController madaController;
  late TextEditingController onlineController;
  late double totalPrice;

  @override
  void initState() {
    super.initState();
    final cubit = SellingPointProductCubit.get(context);
    totalPrice = cubit.totalPrice();

    double currentPaid = double.tryParse(cubit.paidController.text) ?? 0.0;    
    cashController = TextEditingController(
      text: currentPaid > 0 ? currentPaid.toStringAsFixed(2) : '0.00'
    );
    madaController = TextEditingController(text: '0.00');
    onlineController = TextEditingController(text: '0.00');
    
    double remaining = currentPaid > totalPrice ? currentPaid - totalPrice : totalPrice - currentPaid;
    remainingController = TextEditingController(
      text: remaining.toStringAsFixed(2)
    );
  }

  @override
  void dispose() {
    cashController.dispose();
    remainingController.dispose();
    madaController.dispose();
    onlineController.dispose();
    super.dispose();
  }

  // Auto fill the remaining amount when tapping on a field
  void autoFillRemaining(TextEditingController controller) {
    double currentValue = double.tryParse(controller.text) ?? 0.0;
    if (currentValue != 0.0) {
      return;
    }

    double cash = double.tryParse(cashController.text) ?? 0.0;
    double mada = double.tryParse(madaController.text) ?? 0.0;
    double online = double.tryParse(onlineController.text) ?? 0.0;

    double paid = cash + mada + online;
    double remaining = totalPrice - paid;

    if (remaining > 0) {
      setState(() {
        controller.text = remaining.toStringAsFixed(2);
        updateRemaining();
      });
    }
  }

  // Fill the entire amount in one field and zero out others
  void fillFullAmount(TextEditingController targetController) {
    setState(() {
      targetController.text = totalPrice.toStringAsFixed(2);

      // Zero out other fields
      if (targetController != cashController) {
        cashController.text = '0.00';
      }
      if (targetController != madaController) {
        madaController.text = '0.00';
      }
      if (targetController != onlineController) {
        onlineController.text = '0.00';
      }

      updateRemaining();
    });
  }

  double calculateRemaining() {
    double cash = double.tryParse(cashController.text) ?? 0.0;
    double mada = double.tryParse(madaController.text) ?? 0.0;
    double online = double.tryParse(onlineController.text) ?? 0.0;

    if (mada == 0.0 && online == 0.0) {
      return cash > totalPrice ? cash - totalPrice : 0.0;
    } else {
      return 0.0;
    }
  }

  void updateRemaining() {
    setState(() {
      remainingController.text = calculateRemaining().toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.of(context).cashTotal,
                style: TextStyle(fontSize: 16, color: AppColors.black)),
            SizedBox(
              height: 10,
            ),
            Text(
              "${totalPrice.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 14, color: AppColors.black),
            ),
            SizedBox(
              height: 5,
            ),
            // Cash Field with Button
            Row(
              children: [
                Expanded(
                  child: CustomFormField(
                    controller: cashController,
                    labelText: S.of(context).cash,
                    validator: (value) => MyFormValidators.validateDoublePrice(
                      value,
                      context: context,
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      updateRemaining();
                    },
                    onTap: () {
                      autoFillRemaining(cashController);
                    },
                  ),
                ),
                SizedBox(width: 8),
                CustomTextBtn(
                  textColor: AppColors.primary,
                  text: S.of(context).paid,
                  onPressed: () {
                    fillFullAmount(cashController);
                  },
                ),
              ],
            ),
            SizedBox(height: 15),

            // Remaining Amount Field
            CustomFormField(
              controller: remainingController,
              labelText: S.of(context).remainingAmount,
              enabled: false,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15),

            // Mada Field with Button
            Row(
              children: [
                Expanded(
                  child: CustomFormField(
                    controller: madaController,
                    labelText: S.of(context).mada,
                    validator: (value) => MyFormValidators.validateDoublePrice(
                      value,
                      context: context,
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      updateRemaining();
                    },
                    onTap: () {
                      autoFillRemaining(madaController);
                    },
                  ),
                ),
                SizedBox(width: 8),
                CustomTextBtn(
                  textColor: AppColors.primary,
                  text: S.of(context).mada,
                  onPressed: () {
                    fillFullAmount(madaController);
                  },
                ),
              ],
            ),
            SizedBox(height: 15),

            // Online Field with Button
            Row(
              children: [
                Expanded(
                  child: CustomFormField(
                    controller: onlineController,
                    labelText: S.of(context).online,
                    validator: (value) => MyFormValidators.validateDoublePrice(
                      value,
                      context: context,
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      updateRemaining();
                    },
                    onTap: () {
                      autoFillRemaining(onlineController);
                    },
                  ),
                ),
                SizedBox(width: 8),
                CustomTextBtn(
                  textColor: AppColors.primary,
                  text: S.of(context).online,
                  onPressed: () {
                    fillFullAmount(onlineController);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            BlocListener<SellingPointProductCubit, SellingPointProductState>(
              listener: (context, state) {
                if (state is SellingPointProductChangePaidFailing) {
                  CustomPopUp.callMyToast(
                    context: context,
                    massage:
                        S.of(context).priceShoudBeBiggerThanOrEqualTotalPrice,
                    state: PopUpState.ERROR,
                  );
                }
              },
              child: CustomTextBtn(
                textColor: AppColors.primary,
                text: S.of(context).savechanges,
                onPressed: () {
                  final cash = double.tryParse(cashController.text) ?? 0.0;
                  final mada = double.tryParse(madaController.text) ?? 0.0;
                  final online = double.tryParse(onlineController.text) ?? 0.0;
                  final total = cash + mada + online;

                  bool isCashOnly = (mada == 0.0 && online == 0.0);

                  if (isCashOnly) {
                    if (cash < totalPrice) {
                      CustomPopUp.callMyToast(
                        context: context,
                        massage:
                            'المبلغ المدفوع (${cash.toStringAsFixed(2)}) أقل من المطلوب (${totalPrice.toStringAsFixed(2)})',
                        state: PopUpState.ERROR,
                      );
                      return;
                    }
                  } else {
                    if (total < totalPrice) {
                      CustomPopUp.callMyToast(
                        context: context,
                        massage:
                            'إجمالي المدفوعات (${total.toStringAsFixed(2)}) أقل من المطلوب (${totalPrice.toStringAsFixed(2)})',
                        state: PopUpState.ERROR,
                      );
                      return;
                    }

                    if (total > totalPrice) {
                      CustomPopUp.callMyToast(
                        context: context,
                        massage:
                            'عند الدفع بأكثر من طريقة، المجموع يجب أن يساوي (${totalPrice.toStringAsFixed(2)}) بالظبط',
                        state: PopUpState.ERROR,
                      );
                      return;
                    }
                  }
                  SellingPointProductCubit.get(context).changePaid(
                    total.toStringAsFixed(2),
                    mada: mada,
                    online: online,
                  );
                  Navigator.pop(context);
                },
              ),
            ),
            CustomTextBtn(
              text: S.of(context).cancel,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}