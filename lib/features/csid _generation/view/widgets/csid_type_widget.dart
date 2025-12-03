
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_font_style.dart';

class CsidTypeWidget extends StatelessWidget {
  const CsidTypeWidget({super.key,  this.isSelect =false, this.onTap, this.title});
 final bool isSelect ;
 final VoidCallback ?onTap;
 final String ?title;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(

                border: Border.all(color:isSelect? AppColors.primary:AppColors.grey, width: 1.5),
                shape: BoxShape.circle
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child:isSelect?  Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                      shape: BoxShape.circle
                  )):null,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
           title??'',
            textAlign: TextAlign.start,
            style: AppFontStyle.itemsTitle(
              context: context,
              color: AppColors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),


        ],
      ),
    );
  }
}
