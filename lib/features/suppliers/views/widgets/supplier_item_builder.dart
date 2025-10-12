import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/my_copy_clipboard.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/features/suppliers/data/models/supplier_model.dart';
import 'package:redacted/redacted.dart';
import 'delete_supplier_confirm_dialog.dart';

class SupplierItemBuilder extends StatelessWidget {
  const SupplierItemBuilder({super.key, required this.supplier});

  final SupplierModel supplier;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.editSupplier,
            arguments: supplier);
      },
      onLongPress: () {
        myCopyToClipboard(context, supplier.phone.toString());
      },
      child: Dismissible(
        onDismissed: (direction) {
          // print("object");
        },
        confirmDismiss: (direction) async {
          return await showDeleteSupplierConfirmDialog(
            context: context,
            supplier: supplier,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // CustomCachedNetworkImage(
              //   imageUrl: supplier.imagePath ??
              //       'https://www.hitsa.com.au/wp-content/uploads/types-of-chefs.jpg',
              //   borderRadius: BorderRadius.circular(15),
              //   imageBuilder: (imageProvider) => Container(
              //     decoration: BoxDecoration(
              //         image: DecorationImage(
              //             image: imageProvider, fit: BoxFit.cover)),
              //   ),
              //   width: 75,
              //   height: 75,
              // ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      supplier.name ?? '',
                      style: AppFontStyle.itemsTitle(
                        context: context,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (supplier.phone != null && supplier.phone!.isNotEmpty)
                      Text(
                        supplier.phone ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (supplier.address != null &&
                        supplier.address!.isNotEmpty)
                      Text(
                        supplier.address ?? '',
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

class CardSupplierLoading extends StatelessWidget {
  const CardSupplierLoading({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.grey,
            width: 75,
            height: 75,
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
                "supplier",
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
              Text("supplier.p").redacted(
                context: context,
                redact: true,
                configuration: RedactedConfiguration(
                  animationDuration:
                      const Duration(milliseconds: 800), //default
                ),
              ),
              Text("supplier.a").redacted(
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
