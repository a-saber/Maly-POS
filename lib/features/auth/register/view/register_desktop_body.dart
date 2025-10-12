import 'package:flutter/widgets.dart';
import 'package:pos_app/core/constant/device_size.dart';
import 'package:pos_app/core/helper/is_arabic.dart';
import 'package:pos_app/core/utils/app_asset.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/features/auth/register/view/register_mobile_body.dart';

class RegisterDesktopBody extends StatelessWidget {
  const RegisterDesktopBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: isArabic() ? TextDirection.ltr : TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Container(
              color: AppColors.scaffoldBackground,
              alignment: Alignment.center,
              child: Image.asset(
                ImagesAsset.logo,
                width: DeviceSize.getWidth(context: context) * 0.35,
                // height: DeviceSize.getHeight(context: context) * 0.38,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
        const Expanded(
          child: RegisterMobileBody(),
        ),
      ],
    );
  }
}
