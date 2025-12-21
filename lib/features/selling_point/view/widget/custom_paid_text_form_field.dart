import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/helper/payment_helper.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/features/selling_point/view/widget/customkeyboard.dart';
import 'package:pos_app/generated/l10n.dart';
String translateNearpayError(BuildContext context, String error) {
  final cleanError = error.trim().toLowerCase();
  
  if (cleanError.contains("you can't call method (purchase) before initialize")) {
    return "خطأ غير متوقع: لا يمكنك استدعاء طريقة (الشراء) قبل التهيئة";
  }
  return S.of(context).unexpectedErrorYouCantCallMethodPurchaseBeforeInitialize;
}
 
class CustomPaidTextFormField extends StatelessWidget {
  const CustomPaidTextFormField({super.key});

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
                final sellingCubit = SellingPointProductCubit.get(context);
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: MyServiceLocator.getSingleton<
                        SellingPointProductCubit>(),
                    child: DynamicPaidDialog(
                      enableNearPay: sellingCubit.enableNearpay,
                    ),
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

class DynamicPaidDialog extends StatefulWidget {
  final bool? enableNearPay;
  const DynamicPaidDialog({super.key, this.enableNearPay});
  @override
  State<DynamicPaidDialog> createState() => DynamicPaidDialogState();
}

class DynamicPaidDialogState extends State<DynamicPaidDialog> {
  late double totalPrice;
  Map<int, TextEditingController> paymentControllers = {};
  Map<int, TextEditingController> referenceControllers = {};
  late TextEditingController remainingController;
  TextEditingController? activeController;

  Map<int, int> _getPaymentMethodMapping() {
    return {
      1: 1,
      2: 2,
      3: 3,
      4: 4,
      5: 5,
      6: 6,
      7: 7,
      8: 8,
      9: 9,
      10: 10,
      11: 11,
      12: 12,
      13: 13,
      14: 14,
      15: 15,
      16: 16,
      17: 17,
      18: 18,
      19: 19,
      20: 20,
      21: 21,
      22: 22,
      23: 23,
    };
  }

  @override
  void initState() {
    super.initState();
    final cubit = SellingPointProductCubit.get(context);
    totalPrice = cubit.totalPrice();
    remainingController = TextEditingController(text: '0.00');

    if (cubit.availablePaymentMethods.isEmpty) {
      cubit.loadPaymentMethods();
    } else {
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    final cubit = SellingPointProductCubit.get(context);

    for (var method in cubit.availablePaymentMethods) {
      paymentControllers[method.id!] = TextEditingController(text: '');
      paymentControllers[method.id!]!.addListener(_calculateRemaining);

      if (method.requiresReference == 1) {
        referenceControllers[method.id!] = TextEditingController(text: '');
      }
    }

    activeController = paymentControllers.values.first;
  }

  @override
  void dispose() {
    for (var controller in paymentControllers.values) {
      controller.removeListener(_calculateRemaining);
      controller.dispose();
    }
    for (var controller in referenceControllers.values) {
      controller.dispose();
    }
    remainingController.dispose();
    super.dispose();
  }

  void _calculateRemaining() {
    if (!mounted) return;

    double totalPaid = 0.0;
    for (var controller in paymentControllers.values) {
      double amount = double.tryParse(controller.text) ?? 0.0;

      totalPaid += double.parse(amount.toStringAsFixed(2));
    }

    double remaining = 0.0;

    int usedMethods = paymentControllers.values
        .where((c) => (double.tryParse(c.text) ?? 0.0) > 0)
        .length;

    if (usedMethods == 1 && totalPaid > totalPrice) {
      remaining = totalPaid - totalPrice;
    }

    setState(() {
      remainingController.text = remaining.toStringAsFixed(2);
    });
  }

  void onFieldTap(TextEditingController controller) {
    activeController = controller;
    setState(() {});
  }

  void autoFillRemaining(int paymentMethodId) {
    double currentValue =
        double.tryParse(paymentControllers[paymentMethodId]!.text) ?? 0.0;
    if (currentValue != 0.0) return;

    double totalPaid = 0.0;
    for (var entry in paymentControllers.entries) {
      if (entry.key != paymentMethodId) {
        totalPaid += double.tryParse(entry.value.text) ?? 0.0;
      }
    }

    double remaining = totalPrice - totalPaid;
    if (remaining > 0) {
      paymentControllers[paymentMethodId]!.text = remaining.toStringAsFixed(2);
      setState(() {});
    }
  }

  void fillFullAmount(int paymentMethodId) {
    paymentControllers[paymentMethodId]!.text = totalPrice.toStringAsFixed(2);

    for (var entry in paymentControllers.entries) {
      if (entry.key != paymentMethodId) {
        entry.value.text = '';
      }
    }

    setState(() {});
  }

  double _getDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return screenWidth * 0.9;
    } else if (screenWidth < 1200) {
      return 500;
    } else {
      return 600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: getDialogWidth(context),
        child: BlocBuilder<SellingPointProductCubit, SellingPointProductState>(
          builder: (context, state) {
            final cubit = SellingPointProductCubit.get(context);

            if (state is SellingPointProductLoading &&
                cubit.availablePaymentMethods.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is SellingPointProductPaymentMethodsLoaded &&
                paymentControllers.isEmpty) {
              _initializeControllers();
            }

            if (isMobile) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(context),
                          SizedBox(height: 15),
                          ..._buildPaymentFields(cubit),
                          CustomFormField(
                            controller: remainingController,
                            labelText: S.of(context).remainingAmount,
                            enabled: false,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    if (activeController != null)
                      CustomPaymentKeyboard(
                        controller: activeController!,
                        onChanged: _calculateRemaining,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildActionButtons(context),
                    ),
                  ],
                ),
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (activeController != null)
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: AppColors.grey.shade50,
                      border: Border(
                        right: BorderSide(
                          color: AppColors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        CustomPaymentKeyboard(
                          controller: activeController!,
                          onChanged: _calculateRemaining,
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: _buildActionButtons(context),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 20, 24, 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(context),
                          SizedBox(height: 15),
                          ..._buildPaymentFields(cubit),
                          CustomFormField(
                            controller: remainingController,
                            labelText: S.of(context).remainingAmount,
                            enabled: false,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).paid,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "${totalPrice.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPaymentFields(SellingPointProductCubit cubit) {
    return cubit.availablePaymentMethods.map((method) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onFieldTap(paymentControllers[method.id!]!);
                    autoFillRemaining(method.id!);
                  },
                  child: CustomFormField(
                    controller: paymentControllers[method.id!]!,
                    labelText: method.name ?? 'طريقة دفع',
                    enabled: true,
                    keyboardType: TextInputType.none,
                    onTap: () {
                      onFieldTap(paymentControllers[method.id!]!);
                      autoFillRemaining(method.id!);
                    },
                    suffixIcon: method.isNearpay == 1
                        ? Icon(Icons.contactless, color: AppColors.primary)
                        : null,
                  ),
                ),
              ),
              SizedBox(width: 8),
              CustomTextBtn(
                textColor: AppColors.primary,
                text: method.name ?? 'دفع',
                onPressed: () => fillFullAmount(method.id!),
              ),
            ],
          ),
          if (method.requiresReference == 1) ...[
            SizedBox(height: 10),
            CustomFormField(
              controller: referenceControllers[method.id!]!,
              labelText: 'رقم المرجع (${method.name})',
              enabled: true,
              prefixIcon: Icon(Icons.receipt_long, color: AppColors.primary),
            ),
          ],
          SizedBox(height: 15),
        ],
      );
    }).toList();
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocListener<SellingPointProductCubit, SellingPointProductState>(
          listener: (context, state) {
            if (state is SellingPointProductChangePaidFailing) {
              CustomPopUp.callMyToast(
                context: context,
                massage: S.of(context).priceShoudBeBiggerThanOrEqualTotalPrice,
                state: PopUpState.ERROR,
              );
            }
          },
          child: ElevatedButton(
            onPressed: () => _handleSave(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              S.of(context).savechanges,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            side: BorderSide(color: Colors.grey.shade400),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  double getDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return screenWidth * 0.9;
    } else if (screenWidth < 1200) {
      return 700;
    } else {
      return 900;
    }
  }

  void _handleSave(BuildContext context) async {
    final cubit = SellingPointProductCubit.get(context);

    Map<int, double> amounts = {};
    double totalPaid = 0.0;

    for (var entry in paymentControllers.entries) {
      double amount = double.tryParse(entry.value.text) ?? 0.0;
      if (amount > 0) {
        amounts[entry.key] = double.parse(amount.toStringAsFixed(2));
        totalPaid += amounts[entry.key]!;
      }
    }

    debugPrint(' Original IDs from UI: ${amounts.keys.toList()}');

    if (amounts.isEmpty) {
      CustomPopUp.callMyToast(
        context: context,
        massage: 'يرجى إدخال مبلغ في إحدى طرق الدفع على الأقل',
        state: PopUpState.ERROR,
      );
      return;
    }

    List<int> nearpayMethods = [];
    for (var methodId in amounts.keys) {
      final method =
          cubit.availablePaymentMethods.firstWhere((m) => m.id == methodId);
      if (method.isNearpay == 1) {
        nearpayMethods.add(methodId);
      }
    }

    Map<int, String> originalReferences = {};
    if (nearpayMethods.isNotEmpty) {
      for (var methodId in nearpayMethods) {
        final method =
            cubit.availablePaymentMethods.firstWhere((m) => m.id == methodId);
        double amount = amounts[methodId]!;

        try {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => WillPopScope(
              onWillPop: () async => false,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 16),
                      Text(
                        'جاري الدفع عبر ${method.name}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'المبلغ: ${amount.toStringAsFixed(2)} ريال',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

          debugPrint(
              ' Attempting payment via ${method.name}: ${amount.toStringAsFixed(2)} SAR');
          if (widget.enableNearPay != true) {
            CustomPopUp.callMyToast(
              context: context,
              massage: 'ميزة Nearpay غير مفعلة\nيرجى تفعيلها من إعدادات المتجر',
              state: PopUpState.ERROR,
            );
            return ;
          }
          var madaResponse = await PaymentHelper.addTransaction(amount: amount);

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          bool paymentSuccess = false;

          madaResponse.fold(
            (error) {
              debugPrint(' Payment failed: $error');
              final translatedError = translateNearpayError(context, error); 
              CustomPopUp.callMyToast(
                context: context,
                massage: 'فشل الدفع عبر ${method.name}\n$translatedError',
                state: PopUpState.ERROR,
              );
            },
            (response) {
              debugPrint(' Payment successful via ${method.name}');
              debugPrint(' Transaction UUID: ${response.transaction_uuid}');

              originalReferences[methodId] = response.transaction_uuid ?? '';
              paymentSuccess = true;
              CustomPopUp.callMyToast(
                context: context,
                massage:
                    ' تم الدفع بنجاح عبر ${method.name}\nالمبلغ: ${amount.toStringAsFixed(2)} ريال',
                state: PopUpState.SUCCESS,
              );
            },
          );

          if (!paymentSuccess) {
            return;
          }
        } catch (e) {
          debugPrint(' Exception during payment: $e');
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          CustomPopUp.callMyToast(
            context: context,
            massage: 'حدث خطأ أثناء الدفع\n$e',
            state: PopUpState.ERROR,
          );
          return;
        }
      }
    }

    for (var method in cubit.availablePaymentMethods) {
      if (method.requiresReference == 1 && amounts.containsKey(method.id)) {
        if (method.isNearpay != 1) {
          String? reference = referenceControllers[method.id!]?.text;
          if (reference == null || reference.trim().isEmpty) {
            CustomPopUp.callMyToast(
              context: context,
              massage: 'يرجى إدخال رقم المرجع لـ ${method.name}',
              state: PopUpState.ERROR,
            );
            return;
          }
          originalReferences[method.id!] = reference;
        }
      }
    }

    int usedMethods = amounts.length;

    if (usedMethods == 1) {
      if (double.parse(totalPaid.toStringAsFixed(2)) <
          double.parse(totalPrice.toStringAsFixed(2))) {
        CustomPopUp.callMyToast(
          context: context,
          massage:
              'المبلغ المدفوع (${totalPaid.toStringAsFixed(2)}) أقل من المطلوب (${totalPrice.toStringAsFixed(2)})',
          state: PopUpState.ERROR,
        );
        return;
      }
    } else if (usedMethods > 1) {
      if (double.parse(totalPaid.toStringAsFixed(2)) <
          double.parse(totalPrice.toStringAsFixed(2))) {
        CustomPopUp.callMyToast(
          context: context,
          massage:
              'إجمالي المدفوعات (${totalPaid.toStringAsFixed(2)}) أقل من المطلوب (${totalPrice.toStringAsFixed(2)})',
          state: PopUpState.ERROR,
        );
        return;
      }

      if (totalPaid > totalPrice) {
        CustomPopUp.callMyToast(
          context: context,
          massage:
              'عند الدفع بأكثر من طريقة، المجموع يجب أن يساوي (${totalPrice.toStringAsFixed(2)}) بالظبط',
          state: PopUpState.ERROR,
        );
        return;
      }
    }

    Map<int, int> mapping = _getPaymentMethodMapping();
    Map<int, double> mappedAmounts = {};
    Map<int, String> mappedReferences = {};

    debugPrint(' Mapping: $mapping');

    for (var entry in amounts.entries) {
      int correctId = mapping[entry.key] ?? entry.key;
      mappedAmounts[correctId] = entry.value;

      if (originalReferences.containsKey(entry.key)) {
        mappedReferences[correctId] = originalReferences[entry.key]!;
      }

      debugPrint(
          '   Mapping ${entry.key} -> $correctId (amount: ${entry.value})');
    }

    debugPrint(' Mapped IDs to send to API: ${mappedAmounts.keys.toList()}');
    debugPrint(' Mapped Amounts: $mappedAmounts');
    debugPrint(' Mapped References: $mappedReferences');

    cubit.selectedPaymentAmounts = mappedAmounts;
    cubit.paymentReferences = mappedReferences;

    cubit.changePaid(
      totalPaid.toStringAsFixed(2),
      paymentAmounts: mappedAmounts,
    );

    Navigator.pop(context);
    if (nearpayMethods.isNotEmpty) {
      debugPrint(' Auto-completing sale after successful Nearpay payment...');
      await Future.delayed(Duration(milliseconds: 300));
      cubit.confirmPayment();
    }
  }
}
