import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/widget/custom_empty_view.dart';
import 'package:pos_app/core/widget/custom_error_view.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/store_move/data/model/store_movement_data.dart';
import 'package:pos_app/features/store_move/manager/store_move_cubit/store_move_cubit.dart';

class StoreMoveCubitBuild extends StatelessWidget {
  const StoreMoveCubitBuild({
    super.key,
    required this.storeMovementLoading,
    required this.storeMovementBuild,
  });
  final Function(BuildContext) storeMovementLoading;
  final Function(BuildContext, List<StoreMovementData>) storeMovementBuild;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreMoveCubit, StoreMoveState>(
      listener: (context, state) {
        if (state is StoreMoveFailingPagination) {
          if (context.mounted) {
            CustomPopUp.callMyToast(
                context: context,
                massage: mapStatusCodeToMessage(context, state.errMessage),
                state: PopUpState.ERROR);
          }
        }
      },
      builder: (context, state) {
        if (state is StoreMoveFailing) {
          return CustomError(
            error: context.mounted
                ? mapStatusCodeToMessage(context, state.errMessage)
                : 'error',
            onPressed: () => StoreMoveCubit.get(context).getAllData(),
          );
        } else if (state is StoreMoveLoading) {
          return storeMovementLoading(context);
        }
        if (StoreMoveCubit.get(context).storeMoveList.isEmpty) {
          return CustomEmptyView(
            onPressed: () => StoreMoveCubit.get(context).getAllData(),
          );
        }
        return storeMovementBuild(
            context, StoreMoveCubit.get(context).storeMoveList);
      },
    );
  }
}
