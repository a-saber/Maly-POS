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
        SizedBox(
          height: 10,
        ),
        BlocBuilder<SellingPointProductCubit, SellingPointProductState>(
          builder: (context, state) {
            return InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => BlocProvider.value(
                          value: MyServiceLocator.getSingleton<
                              SellingPointProductCubit>(),
                          child: BlocBuilder<SellingPointProductCubit,
                              SellingPointProductState>(
                            builder: (context, state) {
                              double? value = double.tryParse(
                                  SellingPointProductCubit.get(context)
                                      .paidController
                                      .text);
                              String changeValue =
                                  SellingPointProductCubit.get(context)
                                      .paidController
                                      .text;
                              return AlertDialog(
                                content: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child:
                                      // Form(
                                      //   key: SellingPointProductCubit.get(context)
                                      //       .formKey,
                                      //   autovalidateMode:
                                      //       SellingPointProductCubit.get(context)
                                      //           .autovalidateMode,
                                      //   child:
                                      CustomFormField(
                                    initialValue: value?.toString() ?? "",
                                    labelText: S.of(context).paid,
                                    validator: (value) =>
                                        MyFormValidators.validateDoublePrice(
                                      value,
                                      context: context,
                                    ),
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    onChanged: (p0) {
                                      changeValue = p0;
                                      // SellingPointProductCubit.get(context)
                                      //     .changePaid(p0);
                                    },
                                  ),
                                ),
                                // ),
                                actions: [
                                  Row(
                                    children: [
                                      BlocListener<SellingPointProductCubit,
                                          SellingPointProductState>(
                                        listener: (context, state) {
                                          if (state
                                              is SellingPointProductChangePaidFailing) {
                                            CustomPopUp.callMyToast(
                                                context: context,
                                                massage: S
                                                    .of(context)
                                                    .priceShoudBeBiggerThanOrEqualTotalPrice,
                                                state: PopUpState.ERROR);
                                          }
                                        },
                                        child: CustomTextBtn(
                                          textColor: AppColors.primary,
                                          text: S.of(context).savechanges,
                                          onPressed: () {
                                            SellingPointProductCubit.get(
                                                    context)
                                                .changePaid(
                                              (double.tryParse(changeValue) ??
                                                      0.0)
                                                  .toString(),
                                            );
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      CustomTextBtn(
                                        text: S.of(context).cancel,
                                        onPressed: () {
                                          SellingPointProductCubit.get(context)
                                              .changePaid(
                                                  value?.toString() ?? "");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ));
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
                onChanged: (p0) {
                  SellingPointProductCubit.get(context).changePaid(p0);
                },
              ),
            );
          },
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
