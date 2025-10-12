import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/features/selling_point/view/widget/custom_body_of_items.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomBodyOfProductCard extends StatelessWidget {
  const CustomBodyOfProductCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  S.of(context).item,
                  style: AppFontStyle.itemsSubTitle(
                    context: context,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
                child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                S.of(context).quantity,
                style: AppFontStyle.itemsSubTitle(
                  context: context,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            )),
            Expanded(
                child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                S.of(context).price,
                style: AppFontStyle.itemsSubTitle(
                  context: context,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )),
          ],
        ),
        Divider(
          color: AppColors.grey,
        ),
        SizedBox(
          height: 10,
        ),
        CustomBodyOfItems(),
      ],
    );
  }
}
