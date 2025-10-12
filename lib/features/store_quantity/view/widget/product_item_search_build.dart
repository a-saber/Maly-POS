import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_cach_network_image.dart';
import 'package:pos_app/features/store_quantity/data/model/store_quantity_product_model.dart';
import 'package:pos_app/features/store_quantity/manager/store_quantity_cubit/store_quantity_cubit.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:redacted/redacted.dart';

class ProductItemSearchBuild extends StatelessWidget {
  const ProductItemSearchBuild(
      {super.key, required this.storeQuantityProductModel});

  final StoreQuantityProductModel storeQuantityProductModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(25),
              blurRadius: 7,
              blurStyle: BlurStyle.outer,
            ),
          ]),
      child: Row(
        children: [
          CustomCachedNetworkImage(
            imageUrl: storeQuantityProductModel.product?.imageUrl,
            borderRadius: BorderRadius.circular(15),
            imageBuilder: (imageProvider) => Container(
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover)),
            ),
            width: 75,
            height: 75,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextHighlight(
                      text: storeQuantityProductModel.product?.name ??
                          S
                              .of(context)
                              .noName, // You need to pass the string you want the highlights
                      words: {
                        StoreQuantityCubit.get(context).query: HighlightedWord(
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                          ),
                        ),
                      }, // Your dictionary words
                      textStyle: AppFontStyle.itemsTitle(
                        context: context,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    // Text(
                    //   filterDataModel.product?.name ?? S.of(context).noName,
                    //   style: AppFontStyle.itemsTitle(
                    //     context: context,
                    //     color: AppColors.black,
                    //   ),
                    // ),
                    Text(
                      "${storeQuantityProductModel.quantity?.toString() ?? '0'} items",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.itemssmallTitle(
                        context: context,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${storeQuantityProductModel.product?.price ?? S.of(context).notdeterminedprice} per ${S.of(context).unit}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.itemsSubTitle(
                    context: context,
                    color: AppColors.black,
                  ),
                ),
                // Text(
                //   "${product.group.name}",
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                //   style: AppFontStyle.itemsSubTitle(
                //     context: context,
                //     color: AppColors.black,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItemSearchLoading extends StatelessWidget {
  const ProductItemSearchLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(25),
              blurRadius: 7,
              blurStyle: BlurStyle.outer,
            ),
          ]),
      child: Row(
        children: [
          Container(
            width: 75,
            height: 75,
            color: Colors.grey,
          ).redacted(
            context: context,
            redact: true,
            configuration: RedactedConfiguration(
              animationDuration: const Duration(milliseconds: 800), //default
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "name : name",
                      style: AppFontStyle.itemsTitle(
                        context: context,
                        color: AppColors.black,
                      ),
                    ).redacted(
                      context: context,
                      redact: true,
                      configuration: RedactedConfiguration(
                        animationDuration:
                            const Duration(milliseconds: 800), //default
                      ),
                    ),
                    Text(
                      "10 items",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).redacted(
                      context: context,
                      redact: true,
                      configuration: RedactedConfiguration(
                        animationDuration:
                            const Duration(milliseconds: 800), //default
                      ),
                    ),
                  ],
                ),
                Text(
                  "price: 100 per unit",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ).redacted(
                  context: context,
                  redact: true,
                  configuration: RedactedConfiguration(
                    animationDuration:
                        const Duration(milliseconds: 800), //default
                  ),
                ),
                // Text(
                //   "category",
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                // ).redacted(
                //   context: context,
                //   redact: true,
                //   configuration: RedactedConfiguration(
                //     animationDuration:
                //         const Duration(milliseconds: 800), //default
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
