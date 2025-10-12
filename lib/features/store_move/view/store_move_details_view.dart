import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/formate_date_time.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/features/store_move/data/model/store_movement_data.dart';
import 'package:pos_app/generated/l10n.dart';

class StoreMoveDetailsView extends StatelessWidget {
  const StoreMoveDetailsView({super.key, required this.storeMove});
  final StoreMovementData storeMove;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).storeMoveDetails),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPaddings.defaultView,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              storeMove.product?.imageUrl != null
                  ? CachedNetworkImage(
                      height: 200,
                      width: double.infinity,
                      imageUrl: storeMove.product!.imageUrl!,
                    )
                  : SizedBox.shrink(),

              SizedBox(
                height: 15,
              ),

              /// Product name
              Text(
                storeMove.product?.name ?? S.of(context).noName,
                style: AppFontStyle.appBarTitle(context: context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const Divider(thickness: 1),

              /// Movement info

              textRow(
                S.of(context).branch,
                storeMove.branch?.name ?? "-",
                context: context,
              ),
              textRow(
                S.of(context).user,
                storeMove.user?.name ?? "-",
                context: context,
              ),
              textRow(
                S.of(context).movementType,
                storeMove.movementType ?? '-',
                context: context,
              ),
              textRow(
                S.of(context).Quantity,
                storeMove.quantity.toString(),
                context: context,
              ),
              // textRow(
              //   S.of(context).referenceType,
              //   storeMove.referenceType ?? "-",
              //   context: context,
              // ),
              // textRow("Reference ID", storeMove.referenceId.toString()),
              textRow(
                S.of(context).createdAt,
                storeMove.createdAt == null
                    ? "-"
                    : getLocalTimeFormate(storeMove.createdAt!),
                context: context,
              ),
              textRow(
                S.of(context).UpdatedAt,
                storeMove.updatedAt == null
                    ? "-"
                    : getLocalTimeFormate(storeMove.updatedAt!),
                context: context,
              ),

              /// Product details
              sectionTitle(
                S.of(context).productDetails,
                context: context,
              ),
              // textRow("Category ID",
              //     storeMove.product?.categoryId.toString() ?? "-"),
              textRow(
                S.of(context).type,
                storeMove.product?.type ?? "-",
                context: context,
              ),
              // textRow("Unit ID", storeMove.product?.unitId.toString() ?? "-"),
              textRow(
                S.of(context).description,
                storeMove.product?.description ?? "-",
                context: context,
              ),
              // textRow("Barcode", storeMove.product?.barcode ?? "-"),
              textRow(
                S.of(context).brand,
                storeMove.product?.brand ?? "-",
                context: context,
              ),
              textRow(
                S.of(context).price,
                "${storeMove.product?.price ?? '0'} \$",
                context: context,
              ),
              textRow(
                S.of(context).priceAfterTax,
                "${storeMove.product?.priceAfterTax} \$",
                context: context,
              ),

              /// Reference details
              if (storeMove.reference != null) ...[
                sectionTitle(
                  S.of(context).referenceDetails,
                  context: context,
                ),
                // textRow("Reference ID", storeMove.reference!.id.toString()),
                // textRow("Sale ID", storeMove.reference!.saleId.toString()),
                textRow(
                  S.of(context).Quantity,
                  storeMove.reference!.quantity.toString(),
                  context: context,
                ),
                textRow(
                  S.of(context).price,
                  "${storeMove.reference!.price} \$",
                  context: context,
                ),
                textRow(
                  S.of(context).lineTotalAfterTax,
                  storeMove.reference!.lineTotalAfterTax ?? "-",
                  context: context,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title, {required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFontStyle.itemsTitle(
              context: context,
              color: AppColors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }

  Widget textRow(String label, String value, {required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            "$label:",
            style: AppFontStyle.itemsSubTitle(
              context: context,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Text(
              " $value",
              style: AppFontStyle.itemsSubTitle(
                context: context,
                color: AppColors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
