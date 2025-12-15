import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/extensions.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_font_style.dart';
import '../../../../generated/l10n.dart';
import '../../data/model/store_quantity_product_model.dart';

class CustomUnitQuantityDialog extends StatelessWidget {
  const CustomUnitQuantityDialog({super.key, this.model});
  final StoreQuantityProductModel?model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width/2,


        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                BoxContainer(text: S.of(context).unit,).expand,
                BoxContainer(text: S.of(context).quantity,).expand,
              ],
            ),
            ...model?.product?.productUnits?.map((e) =>  Row(
              children: [
                BoxContainer(text: e.unit?.name,).expand,
                BoxContainer(text: "${e.quantity ?? 0}",).expand,
              ],
            )).toList()??[],
            Row(
              children: [
                BoxContainer(text: S.of(context).totalQuantityForBaseUnit,).expand,
                BoxContainer(text:model?.quantityInBaseUnit.toString(),).expand,
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(

              child: ElevatedButton(

                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text(S.of(context).cancel),
              ),
            )


          ],
        ),
      ),
    );
  }
}
class BoxContainer extends StatelessWidget {
  const BoxContainer({super.key, this.text});
  final String ?text;


  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
       border: Border.all(color: AppColors.black)


      ),

      child: Center(
        child: Text(

          "${text}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppFontStyle.itemsTitle(
            context: context,
            color: AppColors.darkBlue,
          ),
        ),

      ),

    );
  }
}

