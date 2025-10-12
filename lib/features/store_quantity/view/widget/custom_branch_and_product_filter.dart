import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/widget/custom_reset_drop_down_button.dart';
import 'package:pos_app/features/branch/view/widget/custom_drop_down_branch.dart';
import 'package:pos_app/features/products/view/widget/custom_drop_down_product.dart';
import 'package:pos_app/features/store_quantity/manager/store_quantity_cubit/store_quantity_cubit.dart';

class CustomBranchAndProductFilter extends StatelessWidget {
  const CustomBranchAndProductFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreQuantityCubit, StoreQuantityState>(
      builder: (context, state) {
        return Column(
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: CustomDropDownBranch(
                    value: StoreQuantityCubit.get(context).branch,
                    onChanged: StoreQuantityCubit.get(context).changeBranch,
                  ),
                ),
                CustomResetDropDownButton(
                  onPressed: () =>
                      StoreQuantityCubit.get(context).resetBranch(),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: CustomDropDownProduct(
                    onChange: StoreQuantityCubit.get(context).changeProduct,
                    value: StoreQuantityCubit.get(context).product,
                  ),
                ),
                CustomResetDropDownButton(
                  onPressed: () =>
                      StoreQuantityCubit.get(context).resetProduct(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
