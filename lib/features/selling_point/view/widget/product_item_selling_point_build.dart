import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_cach_network_image.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_cubit/selling_point_cubit.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:redacted/redacted.dart';

class ProductItemSellingPointBuild extends StatelessWidget {
  const ProductItemSellingPointBuild({
    super.key,
    required this.product,
  });

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return BlocListener<SellingPointProductCubit, SellingPointProductState>(
      listener: (context, state) {
        if (state is SellingPointProductAddingFailingProduct) {
          CustomPopUp.callMyToast(
            context: context,
            massage: S.of(context).noQuantity,
            state: PopUpState.ERROR,
          );
        }
      },
      child: InkWell(
        onTap: () => SellingPointProductCubit.get(context).addProduct(product),
        child: Container(
          width: 150,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.grey),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: getResponsiveSize(context, size: 5),
            children: [
              CustomCachedNetworkImage(
                imageUrl: product.imageUrl,
                // borderRadius: BorderRadius.circular(15),
                imageBuilder: (imageProvider) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover)),
                ),
                width: getResponsiveSize(context, size: 120),
                height: getResponsiveSize(context, size: 120),
              ),
              TextHighlight(
                text: product.name ??
                    S
                        .of(context)
                        .noName, // You need to pass the string you want the highlights
                words: {
                  SellingPointCubit.get(context).query: HighlightedWord(
                    textStyle: AppFontStyle.itemssmallTitle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      context: context,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                    ),
                  ),
                }, // Your dictionary words
                textStyle: AppFontStyle.itemssmallTitle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  context: context,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              // Text(
              //   name,
              //   style: AppFontStyle.itemssmallTitle(
              //     context: context,
              //     fontWeight: FontWeight.w500,
              //     color: Colors.black,
              //   ),
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              //   textAlign: TextAlign.center,
              // ),
              Text(
                "${product.price}",
                style: AppFontStyle.itemssmallTitle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  context: context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemBuildLoading extends StatelessWidget {
  const ItemBuildLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.grey),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.grey,
            width: getResponsiveSize(context, size: 120),
            height: getResponsiveSize(context, size: 120),
          ),
          SizedBox(
            height: getResponsiveSize(context, size: 5),
          ),
          Container(
            width: double.infinity,
            height: getResponsiveSize(context, size: 20),
            color: Colors.grey,
          ).redacted(
            context: context,
            redact: true,
            configuration: RedactedConfiguration(
              animationDuration: const Duration(milliseconds: 800), //default
            ),
          ),
          SizedBox(
            height: getResponsiveSize(context, size: 3),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: double.infinity,
              height: getResponsiveSize(context, size: 20),
              color: Colors.grey,
            ).redacted(
              context: context,
              redact: true,
              configuration: RedactedConfiguration(
                animationDuration: const Duration(milliseconds: 800), //default
              ),
            ),
          ),
          SizedBox(
            height: getResponsiveSize(context, size: 5),
          ),
          Text(
            "\$ 22.5",
            style: AppFontStyle.itemssmallTitle(
              context: context,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ).redacted(
            context: context,
            redact: true,
            configuration: RedactedConfiguration(
              animationDuration: const Duration(milliseconds: 800), //default
            ),
          ),
        ],
      ),
    );
  }
}
