
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_cach_network_image.dart';

import 'package:pos_app/generated/l10n.dart';

import '../../../../core/widget/custom_pop_up.dart';
import '../../../products/data/model/product_model.dart';
import '../../manager/selling_point_product_cubit/selling_point_product_cubit.dart';

class CustomProductUnitDialog extends StatelessWidget {
  const CustomProductUnitDialog({
    super.key,


    required this.product,
  });
  final ProductModel product;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getResponsiveSize(context, size: 500),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 30,
          ),

          ...?product.productUnits?.map((element)=> InkWell(
            onTap: (){
              SellingPointProductCubit.get(context).addProduct(product: product,productUnit:element );
              Navigator.pop(context);
            },
            child: Padding(

              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          CustomCachedNetworkImage(
                            imageUrl: product.imageUrl,
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
                            child:  Text(
                              "${ product.name ?? S.of(context).noName} ${element.unit?.name??''}",
                              style: AppFontStyle.itemsSubTitle(
                                context: context,
                                color: AppColors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        double.tryParse( element.salePriceWithTax??'0')?.toStringAsFixed(2)??'',
                        style: AppFontStyle.itemsSubTitle(
                          context: context,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  ],
                ),
              ),
            ),
          )).toList(),
           const SizedBox(
             height: 30,
           )

        ],
      ),
    );
  }
}