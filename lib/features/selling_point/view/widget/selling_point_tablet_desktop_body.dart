import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/features/selling_point/view/widget/custom_selling_point_card_body.dart';
import 'package:pos_app/features/selling_point/view/widget/selling_point_mobile_body.dart';
import 'package:pos_app/generated/l10n.dart';

class SellingPointTabletDesktopBody extends StatelessWidget {
  const SellingPointTabletDesktopBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getResponsiveSize(context, size: 10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.ltr,
        children:
            // isArabic()
            //     ? [
            //         Expanded(child: CustomSellingPointDrawer()),
            //         Expanded(flex: 2, child: SellingPointMobileBody()),
            //       ].reversed.toList()
            //     :
            [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: CustomSellingPointCardBody(),
          )),
          Expanded(
              flex: 2,
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back,
                            size: getResponsiveSize(context, size: 25),
                          ),
                        ),
                        Text(
                          S.of(context).sellingPoint,
                          style:
                              AppFontStyle.authTitle(context: context).copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(child: SellingPointMobileBody()),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
