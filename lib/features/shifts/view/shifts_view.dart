import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_cubit.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_state.dart';
import 'package:pos_app/generated/l10n.dart';

class ShiftsView extends StatelessWidget {
  const ShiftsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShiftCubit(MyServiceLocator.getIt())
        ..fetchShifts(), // Fetch shifts on init
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is ShiftSuccess && state is! ShiftSuccessWithData) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
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
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: state is ShiftSuccessWithData && state.shifts.isNotEmpty
                  ? ListView.builder(

                      controller: cubit.scrollController, 
                      itemCount: state.shifts.length,
                      itemBuilder: (context, index) {
                        final shift = state.shifts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              "Shift ID: ${shift.id}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Start: ${shift.startAt ?? '-'}"),
                                Text("End: ${shift.endAt ?? '-'}"),
                                Text("Orders: ${shift.ordersCount ?? 0}"),
                                Text("Branch: ${shift.branch?.name ?? '-'}"),
                                Text("User: ${shift.user?.name ?? '-'}"),
                              ],
                            ),
                          ),
                        );
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
