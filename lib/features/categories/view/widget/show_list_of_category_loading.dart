import 'package:flutter/material.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/features/categories/view/widget/custom_card_loading.dart';

class ShowListOfCategoryLaoding extends StatelessWidget {
  const ShowListOfCategoryLaoding({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGridViewCard(
      itemBuilder: (context, index) {
        return CustomCardCategoryLaoding();
      },
      itemCount: AppConstant.numberOfCardLoading,
    );
  }
}
