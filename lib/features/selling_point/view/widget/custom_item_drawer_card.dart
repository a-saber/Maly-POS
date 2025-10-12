import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_cach_network_image.dart';
import 'package:pos_app/features/selling_point/data/model/product_selling_model.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomItemDrawerCard extends StatelessWidget {
  const CustomItemDrawerCard({
    super.key,
    this.onTapAdd,
    this.onTapRemove,
    this.onTapDelete,
    required this.product,
  });
  final ProductSellingModel product;
  final void Function()? onTapAdd;
  final void Function()? onTapRemove;
  final void Function()? onTapDelete;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CustomCachedNetworkImage(
                    imageUrl: product.product.imageUrl,
                    borderRadius: BorderRadius.circular(15),
                    imageBuilder: (imageProvider) => Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.product.name ?? S.of(context).noName,
                          style: AppFontStyle.itemsSubTitle(
                            context: context,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "${product.product.price}",
                          style: AppFontStyle.s12(
                            context: context,
                            color: AppColors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColors.darkBlue,
                      ),
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          product.count.toString(),
                          style: AppFontStyle.itemsSubTitle(
                            context: context,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                '${product.totalPrice()}',
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
          ],
        ),
        Row(
          children: [
            Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    InkWell(
                      onTap: onTapAdd,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onTapRemove,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(
                child: Align(
              alignment: AlignmentDirectional.center,
              child: InkWell(
                onTap: onTapDelete,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: Icon(
                    Icons.delete,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
              ),
            ))
          ],
        ),
      ],
    );
  }
}
