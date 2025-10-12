import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/is_mobile.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_expansion_tile.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/features/selling_point/view/widget/custom_body_of_price.dart';
import 'package:pos_app/features/selling_point/view/widget/custom_body_of_product_card.dart';
import 'package:pos_app/features/selling_point/view/widget/custom_drop_down_discount_and_customer_selling_point.dart';
import 'package:pos_app/features/selling_point/view/widget/custom_order_type_body.dart';
import 'package:pos_app/features/selling_point/view/widget/custom_paid_text_form_field.dart';
import 'package:pos_app/features/selling_point/view/widget/custom_payment_method_body.dart';
import 'package:pos_app/features/selling_point/view/widget/custom_selling_point_card_button.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CustomSellingPointCardBody extends StatelessWidget {
  const CustomSellingPointCardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getSingleton<SellingPointProductCubit>(),
      child: SafeArea(
        child: Padding(
          padding: isMobile(context: context)
              ? AppPaddings.defaultView
              : EdgeInsets.symmetric(
                  horizontal: AppPaddingSizes.defaultViewH,
                  // vertical: isMobile(context: context)
                  //     ? 0.0
                  //     : AppPaddingSizes.defaultViewV,
                ),
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                Expanded(
                  child: KeyboardVisibilityBuilder(
                      builder: (context, isKeyboardVisible) {
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              BlocBuilder<SellingPointProductCubit,
                                  SellingPointProductState>(
                                builder: (context, state) {
                                  return CustomDropDownDiscountAndCustomerSellingPoint();
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(),
                              SizedBox(
                                height: 5,
                              ),
                              CustomOrderTypeBody(),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(),
                              SizedBox(
                                height: 5,
                              ),
                              CustomPaymentMethodBody(),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(),

                              // Details Of Price
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: BlocBuilder<SellingPointProductCubit,
                                        SellingPointProductState>(
                                      builder: (context, state) {
                                        return CustomExpansionTile(
                                          title: Text(
                                            S.of(context).price,
                                            style: AppFontStyle.appBarTitle(
                                                context: context),
                                          ),
                                          subTitle: Text(
                                            SellingPointProductCubit.get(
                                                    context)
                                                .roundTotolPrice()
                                                .toString(),
                                            style:
                                                AppFontStyle.appBarTitleSmall(
                                              context: context,
                                            ),
                                          ),
                                          children: [
                                            CustomBodyOfPrice(),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(child: CustomPaidTextFormField()),
                                ],
                              ),

                              Divider(),
                              // Product
                              BlocBuilder<SellingPointProductCubit,
                                  SellingPointProductState>(
                                builder: (context, state) {
                                  return CustomExpansionTile(
                                    initiallyExpanded: true,
                                    title: Text(
                                      SellingPointProductCubit.get(context)
                                              .products
                                              .isNotEmpty
                                          ? "${SellingPointProductCubit.get(context).products.length} ${S.of(context).products}"
                                          : S.of(context).products,
                                      style: AppFontStyle.appBarTitle(
                                          context: context),
                                    ),
                                    children: [
                                      CustomBodyOfProductCard(),
                                    ],
                                  );
                                },
                              ),

                              Divider(),
                              SizedBox(
                                height: 20,
                              ),
                              isKeyboardVisible
                                  ? Column(
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        CustomSellingPointCardButtons(),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(
                                      height: 50,
                                    )
                            ],
                          ),
                        ),
                        if (!isKeyboardVisible)
                          Positioned(
                            bottom: 10,
                            right: 0,
                            left: 0,
                            child: CustomSellingPointCardButtons(),
                          ),
                      ],
                    );
                  }),
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
