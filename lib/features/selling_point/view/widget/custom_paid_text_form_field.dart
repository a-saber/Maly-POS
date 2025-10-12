import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_form_validators.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
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
            return Form(
              key: SellingPointProductCubit.get(context).formKey,
              autovalidateMode:
                  SellingPointProductCubit.get(context).autovalidateMode,
              child: CustomFormField(
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
