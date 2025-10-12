import 'package:flutter/material.dart';
import 'package:pos_app/core/constant/device_size.dart';

class CustomGridViewCard extends StatelessWidget {
  const CustomGridViewCard({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.heightOfCard,
    this.controller,
    this.canLaoding = false,
    this.widthOfCard,
  });

  final Widget? Function(BuildContext, int) itemBuilder;
  final int? itemCount;
  final double? heightOfCard;
  final ScrollController? controller;
  final bool canLaoding;
  final double? widthOfCard;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverGrid.builder(
          // shrinkWrap: true,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                ((DeviceSize.getWidth(context: context)) / (widthOfCard ?? 250))
                    .floor()
                    .clamp(1, 5),
            crossAxisSpacing: 10,
            mainAxisSpacing: 0,
            mainAxisExtent:
                heightOfCard ?? MediaQuery.of(context).textScaler.scale(100),
            // childAspectRatio: (widthOfCard ?? 250) /
            //     (heightOfCard ?? MediaQuery.of(context).textScaler.scale(100)),
          ),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        ),
        SliverToBoxAdapter(
          child: canLaoding
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.sizeOf(context).height * 0.05),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
