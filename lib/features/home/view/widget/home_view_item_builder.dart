import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/generated/l10n.dart';

class HomeViewItemBuilder extends StatelessWidget {
  const HomeViewItemBuilder({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.pageRoute,
    this.canAccess = false,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String pageRoute;
  final bool canAccess;

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    double _w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        if (canAccess) {
          Navigator.pushNamed(
            context,
            pageRoute,
          );
        } else {
          CustomPopUp.callMyToast(
            context: context,
            massage: S.of(context).notallowtoaccessthisscreen,
            state: PopUpState.WARNING,
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          top: _w > 800 ? _w / 70 : _w / 30,
          bottom: _w > 800 ? _w / 70 : _w / 30,
          left: _w > 800 ? _w / 60 : _w / 40,
          right: _w > 800 ? _w / 60 : _w / 40,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(25),
              blurRadius: 7,
              blurStyle: BlurStyle.outer,
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(),
            Container(
              height: _w > 800 ? 50 : _w / 8,
              width: _w > 800 ? 50 : _w / 8,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(77),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary.withAlpha(230),
              ),
            ),
            Text(
              title,
              maxLines: 4,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withAlpha(179),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
