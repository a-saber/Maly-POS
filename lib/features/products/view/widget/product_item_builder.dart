import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/my_copy_clipboard.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_cach_network_image.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/view/widget/show_delete_product_confirm_dialog.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:redacted/redacted.dart';

class ProductItemBuilder extends StatelessWidget {
  const ProductItemBuilder({super.key, required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.editProduct,
          arguments: product,
        );
      },
      onLongPress: () {
        myCopyToClipboard(context, product.name.toString());
      },
      child: Dismissible(
        onDismissed: (direction) {},
        confirmDismiss: (direction) async {
          return await showDeleteProductConfirmDialog(
            context: context,
            product: product,
          );
        },
        key: UniqueKey(),
        child: Container(
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
                imageUrl: product.imageUrl,
                borderRadius: BorderRadius.circular(15),
                imageBuilder: (imageProvider) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover)),
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
                    Text(
                      product.name ?? S.of(context).noName,
                      style: AppFontStyle.itemsTitle(
                        context: context,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Text(
                    //   product.categoryId.name ?? '',
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    Text(
                      product.unit?.name ?? S.of(context).noUnitName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCardLoading extends StatelessWidget {
  const ProductCardLoading({super.key});

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "user.name",
                style: AppFontStyle.itemsTitle(context: context),
              ).redacted(
                context: context,
                redact: true,
                configuration: RedactedConfiguration(
                  animationDuration:
                      const Duration(milliseconds: 800), //default
                ),
              ),
              Text(
                "descriptiondescription",
              ).redacted(
                context: context,
                redact: true,
                configuration: RedactedConfiguration(
                  animationDuration:
                      const Duration(milliseconds: 800), //default
                ),
              ),
              Text(
                "Category",
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
        ],
      ),
    );
  }
}
