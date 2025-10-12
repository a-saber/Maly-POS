import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/my_copy_clipboard.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/clients/view/widget/show_delete_client_confirm_dialog.dart';
import 'package:redacted/redacted.dart';

class ClientItemBuilder extends StatelessWidget {
  const ClientItemBuilder({super.key, required this.client});

  final CustomerModel client;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.editClient,
          arguments: client,
        );
      },
      onLongPress: () {
        myCopyToClipboard(context, client.phone.toString());
      },
      child: Dismissible(
        onDismissed: (direction) {
          // print("object");
        },
        confirmDismiss: (direction) async {
          return await showDeleteClientConfirmDialog(
            context: context,
            client: client,
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
              //   imageUrl: client.imagePath ??
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
                      client.name ?? '',
                      style: AppFontStyle.itemsTitle(
                        context: context,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (client.phone != null && client.phone!.isNotEmpty)
                      Text(
                        client.phone ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (client.address != null && client.address!.isNotEmpty)
                      Text(
                        client.address ?? '',
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

class ClientItemLoading extends StatelessWidget {
  const ClientItemLoading({super.key});

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
          // Container(
          //   width: 75,
          //   height: 75,
          //   color: Colors.grey,
          // ).redacted(
          //   context: context,
          //   redact: true,
          //   configuration: RedactedConfiguration(
          //     animationDuration: const Duration(milliseconds: 800), //default
          //   ),
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
                  "client",
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
                Text("client.pho").redacted(
                  context: context,
                  redact: true,
                  configuration: RedactedConfiguration(
                    animationDuration:
                        const Duration(milliseconds: 800), //default
                  ),
                ),
                Text("client.addre").redacted(
                  context: context,
                  redact: true,
                  configuration: RedactedConfiguration(
                    animationDuration:
                        const Duration(milliseconds: 800), //default
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
