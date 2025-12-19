import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/features/paymentmethods/data/models/paymentmodel.dart';
import 'package:pos_app/features/selling_point/view/widget/custom_paid_text_form_field.dart';

class CustomPaymentMethodBody extends StatefulWidget {
  const CustomPaymentMethodBody({super.key});

  @override
  State<CustomPaymentMethodBody> createState() => _CustomPaymentMethodBodyState();
}

class _CustomPaymentMethodBodyState extends State<CustomPaymentMethodBody> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellingPointProductCubit, SellingPointProductState>(
      builder: (context, state) {
        final cubit = SellingPointProductCubit.get(context);

        if (cubit.availablePaymentMethods.isEmpty && state is! SellingPointProductLoading) {
          cubit.loadPaymentMethods();
        }

        if (state is SellingPointProductLoading && cubit.availablePaymentMethods.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        return Column(
          children: [
            // Header with toggle button
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'طرق الدفع',
                      style: AppFontStyle.itemsSubTitle(
                        context: context,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: AppColors.black,
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 10),
            
            // Payment methods - shown/hidden based on _isExpanded
            if (_isExpanded)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ...cubit.availablePaymentMethods.map((method) {
                    bool isSelected = cubit.selectedPaymentAmounts.length == 1 &&
                        cubit.selectedPaymentAmounts.containsKey(method.id);

                    return InkWell(
                      onTap: () => _handleSinglePayment(context, cubit, method),
                      child: CustomCardPaymentMethod(
                        icon: _getPaymentIcon(method),
                        title: method.name ?? 'طريقة دفع',
                        isActive: isSelected,
                      ),
                    );
                  }),

                  InkWell(
                    onTap: () => _openMixPaymentDialog(context),
                    child: CustomCardPaymentMethod(
                      icon: Icons.app_shortcut,
                      title: 'ميكس',
                      isActive: cubit.selectedPaymentAmounts.length > 1,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  IconData _getPaymentIcon(PaymentMethodSalesModel method) {
    if (method.isNearpay == 1) {
      return Icons.contactless;
    }
    
    final name = method.name?.toLowerCase() ?? '';
    
    if (name.contains('كاش') || name.contains('نقد')) {
      return Icons.money;
    } else if (name.contains('مدى') || name.contains('بطاقة')) {
      return Icons.credit_card;
    } else if (name.contains('تحويل') || name.contains('بنك')) {
      return Icons.account_balance;
    } else if (name.contains('محفظة')) {
      return Icons.wallet;
    } else if (name.contains('اونلاين')) {
      return Icons.language;
    }
    
    return Icons.payment;
  }

  void _handleSinglePayment(
    BuildContext context,
    SellingPointProductCubit cubit,
    PaymentMethodSalesModel method,
  ) async {
    double totalPrice = cubit.totalPrice();
    
    cubit.selectedPaymentAmounts.clear();
    cubit.paymentReferences.clear();
    cubit.selectedPaymentAmounts[method.id!] = totalPrice;
    bool continuePayment = true;  
    print(' 1. ----- $continuePayment -------');
    if (method.isNearpay == 1) {
      cubit.changePaid(
        totalPrice.toStringAsFixed(2),
        paymentAmounts: cubit.selectedPaymentAmounts,
      );

      debugPrint(' Starting Nearpay payment for ${method.name}...');

      String? erorr = await cubit.processNearpayPayment(
        amount: totalPrice,
        paymentMethodId: method.id!,
        context: context,
      );
    print(' 5. ${erorr == null} ${erorr.toString()} ----- $continuePayment -------');

      if (erorr != null) {
        // debugPrint(' Payment failed: $erorr');
    print(' 4. ----- $continuePayment -------');

        continuePayment = false;
    print(' 3. ----- $continuePayment -------');

      }
    }

    print(' 2. ----- $continuePayment -------');

    if (continuePayment) {
      cubit.changePaid(
        totalPrice.toStringAsFixed(2),
        paymentAmounts: cubit.selectedPaymentAmounts,
      );
      print(' Starting payment for 123 ${method.name}...');
      cubit.confirmPayment();
    }
  }

  void _openMixPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: SellingPointProductCubit.get(context),
        child: DynamicPaidDialog(),
      ),
    );
  }
}

class CustomCardPaymentMethod extends StatelessWidget {
  const CustomCardPaymentMethod({
    super.key,
    required this.icon,
    required this.title,
    required this.isActive,
    this.color,
  });

  final IconData icon;
  final String title;
  final bool isActive;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: isActive 
                ? (color ?? AppColors.primary).withOpacity(0.1) 
                : Colors.white,
            border: Border.all(
              color: isActive 
                  ? (color ?? AppColors.primary) 
                  : AppColors.grey,
              width: isActive ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: (color ?? AppColors.primary).withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive 
                    ? (color ?? AppColors.primary) 
                    : AppColors.grey.shade700,
                size: 28,
              ),
              SizedBox(height: 5),
              Text(
                title,
                style: AppFontStyle.itemssmallTitle(
                  context: context,
                  color: isActive 
                      ? (color ?? AppColors.primary) 
                      : AppColors.black,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (isActive)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              decoration: BoxDecoration(
                color: color ?? AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.check,
                color: AppColors.white,
                size: 12,
              ),
            ),
          ),
      ],
    );
  }
}