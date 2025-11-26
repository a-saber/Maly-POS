import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_cach_network_image.dart';
import 'package:pos_app/features/selling_point/data/model/product_selling_model.dart';
import 'package:pos_app/generated/l10n.dart';

import '../../../../core/helper/my_form_validators.dart';
import '../../../../core/widget/custom_btn.dart';
import '../../../../core/widget/custom_form_field.dart';

class CustomItemDrawerCard extends StatelessWidget {
  const CustomItemDrawerCard({
    super.key,
    this.onTapAdd,
    this.onTapRemove,
    this.onTapDelete,
    required this.product, this.onChangePrice,
    this.onToggleShowEditPrice,
  });
  final ProductSellingModel product;
  final void Function()? onTapAdd;
  final void Function()? onTapRemove;
  final void Function()? onTapDelete;
  final VoidCallback? onChangePrice;
  final VoidCallback? onToggleShowEditPrice;
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
                          '${product.product.name ?? S.of(context).noName} ${product.productUnit?.unit?.name ?? ''}',
                          style: AppFontStyle.itemsSubTitle(
                            context: context,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${product?.currentPrice.toStringAsFixed(2)}",
                              style: AppFontStyle.s12(
                                context: context,
                                color: AppColors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                           const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: onToggleShowEditPrice,

                              child: Icon(
                                Icons.edit,
                                color: AppColors.black,
                                size: 15,
                              ),
                            )
                          ],
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
                (product.currentPrice * product.count).toStringAsFixed(2),
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
                flex: 4,
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
        if(product.showEditPrice)...
        [
        const SizedBox(
          height: 10,
        ),
        Row(

          children: [
            Expanded(
              flex: 3,


              child: LayoutBuilder(
                  builder: (context, constraints) {
                  return Form(
                    key: product.formKey,
                    child: CustomFormField(
                      controller: product.priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) => MyFormValidators.validateDoublePrice(
                        value,
                        context: context,
                        haveMin: true,
                        min: product.minPrice,
                      ),
                    ),
                  );
                }
              ),
            ),
            // CustomTextBtn(
            //   text: "Save",
            //   textColor: AppColors.primary,
            //   onPressed: (){
            //
            //       // Defer setState to after the current frame
            //       WidgetsBinding.instance.addPostFrameCallback((_) {
            //
            //           onChangePrice!();
            //
            //       });
            //
            //   },
            // ),
           const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: (){

                  // Defer setState to after the current frame
                  WidgetsBinding.instance.addPostFrameCallback((_) {

                    onChangePrice!();

                  });

                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    border:
                    Border.all(color: AppColors.success, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    S.of(context).save,
                    textAlign: TextAlign.center,
                    style: AppFontStyle.itemsSubTitle(
                      context: context,
                      color: AppColors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
          ],
        )
        ],


      ],
    );
  }
}
