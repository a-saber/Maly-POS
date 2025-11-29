import 'package:flutter/material.dart';

import '../../../../core/helper/my_form_validators.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_font_style.dart';
import '../../../../core/widget/custom_form_field.dart';
import '../../../../generated/l10n.dart';
import '../../manager/cubit/csid_generation_setting_cubit.dart';

class CopyItemWidget extends StatelessWidget {
  const CopyItemWidget({super.key, this.controller, this.hint, this.onTap});
  final TextEditingController ?controller;
  final String ?hint;
  final VoidCallback ?onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(

            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.grey,
            //  border://Border.all(color: AppColors.success, width: 1.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child:  Center(
              child: Text(
                S.of(context).copy,
                textAlign: TextAlign.start,
                style: AppFontStyle.itemsSubTitle(
                  context: context,
                  color: AppColors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      const SizedBox(
        width: 10,
      ),

      Expanded(
        child: CustomFormField(
          controller: controller,
          hintText: hint,
          labelText: hint,
          enabled: false,
          validator: (value) => MyFormValidators.validateInteger(value,
              context: context, validate: false),
          keyboardType: TextInputType.text,
        ),
      )
      ],
    );
  }
}
