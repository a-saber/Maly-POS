import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_cubit.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_state.dart';
import 'package:pos_app/features/shifts/widget/show_toast.dart';
import 'package:pos_app/features/shifts/widget/showdialog_for_shift.dart';
import 'package:pos_app/generated/l10n.dart';

class ShiftsView extends StatelessWidget {
  const ShiftsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllBranchesCubit(MyServiceLocator.getIt()),
        ),
        BlocProvider(
          create: (context) => ShiftCubit(MyServiceLocator.getIt())..init(),
        ),
      ],

      // Fetch shifts on init
      child: const _ShiftsViewBody(),
    );
  }
}

class _ShiftsViewBody extends StatelessWidget {
  const _ShiftsViewBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShiftCubit, ShiftState>(
      listener: (context, state) {
        if (state is ShiftError) {
          showTopToast(
            Navigator.of(context, rootNavigator: true).context,
            state.message,
          );
        } else if (state is ShiftStarted) {
          showTopToast(
            Navigator.of(context, rootNavigator: true).context,
            state.message,
          );
        } else if (state is ShiftEnded) {
          showTopToast(
            Navigator.of(context, rootNavigator: true).context,
            state.message,
          );
        } else if (state is ShiftSuccessWithData) {
          final cubit = ShiftCubit.get(context);
          cubit.printShiftsCountByBranch();
        }
      },
      builder: (context, state) {
        final isLoading = state is ShiftLoading;
        final cubit = ShiftCubit.get(context);
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            appBar: CustomAppBar(
              title: S.of(context).shifts,
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    final branchesCubit = GetAllBranchesCubit.get(context);
                    final shiftCubit = ShiftCubit.get(context);

                    showShiftFilterDialog(
                      context,
                      branchesCubit: branchesCubit,
                      shiftCubit: shiftCubit,
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: state is ShiftSuccessWithData && state.shifts.isNotEmpty
                  ? ListView.builder(
                      controller: cubit.scrollController,
                      itemCount:
                          cubit.shifts.length + (cubit.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < cubit.shifts.length) {
                          final shift = cubit.shifts[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.shiftDetails,
                                  arguments: shift.id!,
                                );
                              },
                              title: Text(
                                "${S.of(context).shiftNumber}: ${shift.id}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${S.of(context).startAt}: ${shift.startAt ?? '-'}"),
                                  Text(
                                      "${S.of(context).endAt}: ${shift.endAt ?? '-'}"),
                                  Text(
                                      "${S.of(context).ordersCount}: ${shift.ordersCount ?? 0}"),
                                  Text(
                                      "${S.of(context).branch}: ${shift.branch?.name ?? '-'}"),
                                  Text(
                                      "${S.of(context).user}: ${shift.user?.name ?? '-'}"),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    )
                  : const Center(
                      child: Text("No shifts available."),
                    ),
            ),
          ),
        );
      },
    );
  }
}
