import 'package:flutter/material.dart';
import 'package:pos_app/features/selling_point/view/widget/custom_selling_point_card_body.dart';

class SellingPointCardView extends StatelessWidget {
  const SellingPointCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const CustomSellingPointCardBody(),
    );
  }
}
