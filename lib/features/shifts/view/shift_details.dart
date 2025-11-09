import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_cubit.dart';
import 'package:pos_app/features/home/manager/cubit/shift_cubit/shift_state.dart';
import 'package:pos_app/generated/l10n.dart';

class ShiftDetailsView extends StatefulWidget {
  final int shiftId;
  const ShiftDetailsView({super.key, required this.shiftId});

  @override
  State<ShiftDetailsView> createState() => _ShiftDetailsViewState();
}

class _ShiftDetailsViewState extends State<ShiftDetailsView> {
  @override
  Widget build(BuildContext context) {
    final cubit = MyServiceLocator.getSingleton<ShiftCubit>();

    // Fetch details
    cubit.fetchShiftDetails(widget.shiftId);
    final scrollController = cubit.shiftDetailsScrollController;
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).shiftDetails, 
        ),
        body: BlocBuilder<ShiftCubit, ShiftState>(
          builder: (context, state) {
            if (state is ShiftDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ShiftDetailsSuccess) {
              final shift = state.shiftDetails.shift!;
              final summary = state.shiftDetails.summary;
              final orders = cubit.shiftOrders;
                print("ORDERS DATA: $orders");
              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: orders.length + 5, 
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Card(
                      child: ListTile(
                        title: Text("${S.of(context).shiftNumber} : ${widget.shiftId}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${S.of(context).startAt}: ${shift.startAt ?? '-'}"),
                            Text("${S.of(context).endAt}: ${shift.endAt ?? '-'}"),
                            Text("${S.of(context).openingQuantity}: ${shift.openingQuantity ?? 0}"),
                            Text("${S.of(context).ordersCount}: ${shift.ordersCount ?? 0}"),
                          ],
                        ),
                      ),
                    );
                  } else if (index == 1) {
                    return const SizedBox(height: 12);
                  } else if (index == 2) {
                    return Card(
                      child: ListTile(
                        title: Text(S.of(context).branch),
                        subtitle: Text(shift.branch?.name ?? "-"),
                      ),
                    );
                  } else if (index == 3) {
                    return Card(
                      child: ListTile(
                        title: Text(S.of(context).user),
                        subtitle: Text(shift.user?.name ?? "-"),
                      ),
                    );
                  } else if (index == 4) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(S.of(context).summary,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                _row("${S.of(context).total}:", summary?.subtotal),
                                _row("${S.of(context).discount}:", summary?.discountTotal),
                                _row("${S.of(context).totalAfterDiscount}:", summary?.totalAfterDiscount),
                                _row("${S.of(context).tax}:", summary?.taxTotal),
                                _row("${S.of(context).totalAfterTax}:", summary?.totalAfterTax),
                                _row("${S.of(context).cash}:", summary?.cashTotal),
                                _row("${S.of(context).online}:", summary?.onlineTotal),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(S.of(context).orders,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                      ],
                    );
                  } else {
                    final order = orders[index - 5];
                    return Card(
                      child: Table(
                        border: TableBorder.all(color: Colors.grey),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: Colors.black12),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text("Order #", style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text("Total", style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text("Created At", style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(order["id"]?.toString() ?? "-"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(order["total_after_tax"] != null ? double.tryParse(order["total_after_tax"].toString())?.toStringAsFixed(2) ?? "-" : "-"),

                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(order["created_at"]?.toString() ?? "-"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            }

            return Center(child: Text(S.of(context).somethingWentWrong));
          },
        ),
      ),
    );
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value ?? "-", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
