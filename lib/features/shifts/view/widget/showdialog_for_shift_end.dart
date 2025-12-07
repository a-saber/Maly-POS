import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/formate_date_time.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/extensions.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/shifts/data/model/end_shift_model.dart';
import 'package:pos_app/generated/l10n.dart';

Future<void> showDialogForShiftEnd(BuildContext context,
    {required EndShiftModel shift}) async {
  await showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).shiftDetails,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "${S.of(context).startAt}: ${getLocalTimeFormate(shift.shift?.startAt ?? '-')}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).endAt}: ${getLocalTimeFormate(shift.shift?.endAt ?? '-')}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).user}: ${(shift.shift?.user?.name ?? '-')}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).branch}: ${(shift.shift?.branch?.name ?? '-')}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).openingQuantity}: ${(double.tryParse(shift.shift?.openingQuantity??'0')?.toStringAsFixed(1) ?? '-')}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).discountTotal}: ${(shift.shift?.discountTotal ?? '-').toAmount()}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).taxestotal}: ${(shift.shift?.taxTotal ?? '-').toAmount()}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).cashTotal}: ${(shift.shift?.cashTotal ?? '-').toAmount()}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).onlineTotal}: ${(shift.shift?.onlineTotal ?? '-').toAmount()}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
            Text(
              "${S.of(context).total}: ${(shift.shift?.totalAfterTax ?? '-').toAmount()}",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomTextBtn(
                text: S.of(context).print,
                onPressed: () {
                  // TODO : Print
                },
              ),
              CustomTextBtn(
                text: S.of(context).details,
                onPressed: () {
                  Navigator.pop(context);
                  if (shift.shift?.id == null) {
                    CustomPopUp.callMyToast(
                      context: context,
                      massage: S.of(context).notFoundShift,
                      state: PopUpState.ERROR,
                    );
                    return;
                  }
                  Navigator.pushNamed(
                    context,
                    AppRoutes.shiftDetails,
                    arguments: shift.shift?.id,
                  );
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
