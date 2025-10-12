import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/device_size.dart';
import 'package:pos_app/core/helper/is_arabic.dart';
import 'package:pos_app/core/manager/language_control/language_control_cubit.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/my_custom_scroll_view.dart';
import 'package:pos_app/generated/l10n.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).settings),
      body: MyCustomScrollView(
        child: Padding(
          padding: AppPaddings.defaultView,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  S.of(context).language,
                  style: AppFontStyle.formText(context: context),
                ),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  width: DeviceSize.getWidth(context: context) * 0.28,
                  // height: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child:
                        BlocBuilder<LanguageControlCubit, LanguageControlState>(
                      builder: (context, state) {
                        return DropdownButton<String>(
                          value: isArabic() ? 'ar' : 'en',
                          dropdownColor: AppColors.white,
                          underline: SizedBox(),
                          isExpanded: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text(
                                S.of(context).English,
                                style: AppFontStyle.dropDown(context: context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'ar',
                              child: Text(
                                S.of(context).Arabic,
                                style: AppFontStyle.dropDown(context: context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          onChanged: (value) =>
                              LanguageControlCubit.get(context).changeLanguage(
                            language: value,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
