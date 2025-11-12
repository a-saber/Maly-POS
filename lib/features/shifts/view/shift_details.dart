import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/helper/formate_date_time.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/shifts/manager/shift_cubit/shift_cubit.dart';
import 'package:pos_app/features/shifts/manager/shift_cubit/shift_state.dart';
import 'package:pos_app/features/shifts/manager/shift_order_pagination_cubit/shift_order_pagination_cubit.dart';
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
    final double paddingCard = 10.0;
    final double spacingBetweenCard = 16;
    // final double spacingBetweenColumn = 16;
    final double spacingBetweenRowInCard = 3;

    // Fetch details
    cubit.fetchShiftDetails(widget.shiftId);
    // final scrollController = cubit.shiftDetailsScrollController;
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).shiftDetails,
        ),
        body: BlocBuilder<ShiftCubit, ShiftState>(
          builder: (context, state) {
            if (state is ShiftDetailsLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ShiftDetailsError) {
              return Center(child: Text(state.message));
            }

            if (state is ShiftDetailsSuccess) {
              final shift = state.shiftDetails.shift!;
              final summary = state.shiftDetails.summary;
              final orders = cubit.shiftOrders;
              // final shop = state.shiftDetails.settings;
              debugPrint("ORDERS DATA: $orders");

              return BlocProvider(
                create: (context) => ShiftOrderPaginationCubit(
                  repo: MyServiceLocator.getIt(),
                  dataforshift: state.shiftDetails.data!,
                  orderData: state.shiftDetails.data!.data ?? [],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customCardTitle(context,
                                title: S.of(context).shiftDetails),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(paddingCard),
                                child: Column(
                                  spacing: spacingBetweenRowInCard,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _row(S.of(context).shiftNumber,
                                        widget.shiftId.toString()),
                                    _row(
                                        S.of(context).openingQuantity,
                                        (shift.openingQuantity ?? 0)
                                            .toString()),
                                    _row(S.of(context).ordersCount,
                                        (shift.ordersCount ?? 0).toString()),
                                    _row(S.of(context).startAt,
                                        (shift.startAt ?? '-').toString()),
                                    _row(
                                        S.of(context).endAt, shift.endAt ?? '-')
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: spacingBetweenCard,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          spacing: spacingBetweenRowInCard,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customCardTitle(context,
                                title: S.of(context).userInfo),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(paddingCard),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _row(
                                      S.of(context).name,
                                      shift.user?.name ?? '-',
                                    ),
                                    _row(
                                      S.of(context).branch,
                                      shift.branch?.name ?? '-',
                                    ),
                                    _row(
                                      S.of(context).email,
                                      shift.user?.email ?? '-',
                                    ),
                                    _row(
                                      S.of(context).phone,
                                      shift.user?.phone ?? '-',
                                    ),
                                    _row(
                                      S.of(context).address,
                                      shift.user?.address ?? '-',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: spacingBetweenCard,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          spacing: spacingBetweenRowInCard,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customCardTitle(context,
                                title: S.of(context).summary),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(paddingCard),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _row(
                                      S.of(context).subTotal,
                                      summary?.subtotal ?? '-',
                                    ),
                                    _row(
                                      S.of(context).discountTotal,
                                      summary?.discountTotal ?? '-',
                                    ),
                                    _row(
                                      S.of(context).totalAfterDiscount,
                                      summary?.totalAfterDiscount ?? '-',
                                    ),
                                    _row(
                                      S.of(context).taxestotal,
                                      summary?.taxTotal ?? '-',
                                    ),
                                    _row(
                                      S.of(context).totalAfterTax,
                                      summary?.totalAfterTax ?? '-',
                                    ),
                                    _row(
                                      S.of(context).cashTotal,
                                      summary?.cashTotal ?? '-',
                                    ),
                                    _row(
                                      S.of(context).onlineTotal,
                                      summary?.onlineTotal ?? '-',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: spacingBetweenCard,
                      // ),
                      // Column(
                      //   spacing: spacingBetweenRowInCard,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     customCardTitle(context, title: S.of(context).shop),
                      //     Card(
                      //       child: Padding(
                      //         padding: EdgeInsets.all(paddingCard),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             _row(
                      //               S.of(context).name,
                      //               shop?.shopName ?? '-',
                      //             ),
                      //             _row(
                      //               S.of(context).address,
                      //               shop?.address ?? '-',
                      //             ),
                      //             _row(
                      //               S.of(context).phone,
                      //               shop?.phone ?? '-',
                      //             ),
                      //             _row(
                      //               S.of(context).email,
                      //               shop?.email ?? '-',
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: spacingBetweenCard,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: customCardTitle(context,
                            title: S.of(context).orders),
                      ),
                      BlocBuilder<ShiftOrderPaginationCubit,
                          ShiftOrderPaginationState>(
                        builder: (context, state) {
                          return SliverGrid.builder(
                            itemCount: ShiftOrderPaginationCubit.get(context)
                                .orderData
                                .length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 800,
                                    mainAxisExtent: 100,
                                    childAspectRatio: 4 / 1),
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: EdgeInsets.all(paddingCard),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        spacing: 50,
                                        children: [
                                          Expanded(
                                            child: _row(
                                              S.of(context).id,
                                              ShiftOrderPaginationCubit.get(
                                                          context)
                                                      .orderData[index]
                                                      .id
                                                      ?.toString() ??
                                                  '-',
                                            ),
                                          ),
                                          Expanded(
                                            child: _row(
                                              S.of(context).date,
                                              getLocalTimeFormate(
                                                ShiftOrderPaginationCubit.get(
                                                            context)
                                                        .orderData[index]
                                                        .createdAt
                                                        ?.toString() ??
                                                    '-',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        spacing: 50,
                                        children: [
                                          Expanded(
                                            child: _row(
                                              S.of(context).user,
                                              ShiftOrderPaginationCubit.get(
                                                          context)
                                                      .orderData[index]
                                                      .user
                                                      ?.name
                                                      ?.toString() ??
                                                  '-',
                                            ),
                                          ),
                                          Expanded(
                                            child: _row(
                                              S.of(context).branch,
                                              ShiftOrderPaginationCubit.get(
                                                          context)
                                                      .orderData[index]
                                                      .branch
                                                      ?.name
                                                      ?.toString() ??
                                                  '-',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        spacing: 50,
                                        children: [
                                          Expanded(
                                            child: _row(
                                              S.of(context).total,
                                              ShiftOrderPaginationCubit.get(
                                                          context)
                                                      .orderData[index]
                                                      .totalAfterTax
                                                      ?.toString() ??
                                                  '-',
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                CustomTextBtn(
                                                  textColor: AppColors.primary,
                                                  text: S.of(context).details,
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      AppRoutes
                                                          .orderDetailsView,
                                                      arguments:
                                                          ShiftOrderPaginationCubit
                                                                  .get(context)
                                                              .orderData[index],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(
                              height: spacingBetweenCard,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BlocConsumer<ShiftOrderPaginationCubit,
                                    ShiftOrderPaginationState>(
                                  listener: (context, state) {
                                    if (state
                                        is ShiftOrderPaginationErrorState) {
                                      CustomPopUp.callMyToast(
                                        context: context,
                                        massage: mapStatusCodeToMessage(
                                            context, state.message),
                                        state: PopUpState.ERROR,
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    return state
                                            is ShiftOrderPaginationLoadingState
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.primary,
                                            ),
                                          )
                                        : CustomTextBtn(
                                            textColor:
                                                ShiftOrderPaginationCubit.get(
                                                            context)
                                                        .noMoreData()
                                                    ? Colors.grey
                                                    : AppColors.primary,
                                            text: S.of(context).showMore,
                                            onPressed:
                                                ShiftOrderPaginationCubit.get(
                                                            context)
                                                        .noMoreData()
                                                    ? null
                                                    : () {
                                                        ShiftOrderPaginationCubit
                                                                .get(context)
                                                            .getOrderPagination();
                                                      },
                                          );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: spacingBetweenCard,
                            ),
                          ],
                        ),
                      ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     SizedBox(
                      //       height: spacingBetweenCard,
                      //     ),

                      //     ...state.shiftDetails.data?.data
                      //             ?.map((order) => Column(
                      //                   children: [

                      //                   ],
                      //                 ))
                      //             .toList() ??
                      //         [],
                      //   ],
                      // ),
                    ],

                    //   } else if (index == 1) {
                    //     return const SizedBox(height: 12);
                    //   } else if (index == 2) {
                    //     return Card(
                    //       child: ListTile(
                    //         title: Text(S.of(context).branch),
                    //         subtitle: Text(shift.branch?.name ?? "-"),
                    //       ),
                    //     );
                    //   } else if (index == 3) {
                    //     return Card(
                    //       child: ListTile(
                    //         title: Text(S.of(context).user),
                    //         subtitle: Text(shift.user?.name ?? "-"),
                    //       ),
                    //     );
                    //   } else if (index == 4) {
                    //     return Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const SizedBox(height: 16),
                    //         Text(S.of(context).summary,
                    //             style: const TextStyle(
                    //                 fontWeight: FontWeight.bold, fontSize: 16)),
                    //         const SizedBox(height: 8),
                    //         Card(
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(12),
                    //             child: Column(
                    //               children: [
                    //                 _row("${S.of(context).total}:",
                    //                     summary?.subtotal),
                    //                 _row("${S.of(context).discount}:",
                    //                     summary?.discountTotal),
                    //                 _row("${S.of(context).totalAfterDiscount}:",
                    //                     summary?.totalAfterDiscount),
                    //                 _row(
                    //                     "${S.of(context).tax}:", summary?.taxTotal),
                    //                 _row("${S.of(context).totalAfterTax}:",
                    //                     summary?.totalAfterTax),
                    //                 _row("${S.of(context).cash}:",
                    //                     summary?.cashTotal),
                    //                 _row("${S.of(context).online}:",
                    //                     summary?.onlineTotal),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //         const SizedBox(height: 24),
                    //         Text(S.of(context).orders,
                    //             style: const TextStyle(
                    //                 fontWeight: FontWeight.bold, fontSize: 16)),
                    //         const SizedBox(height: 8),
                    //       ],
                    //     );
                    //   } else {
                    //     final order = orders[index - 5];
                    //     return Card(
                    //       child: Table(
                    //         border: TableBorder.all(color: Colors.grey),
                    //         columnWidths: const {
                    //           0: FlexColumnWidth(2),
                    //           1: FlexColumnWidth(1),
                    //           2: FlexColumnWidth(2),
                    //         },
                    //         children: [
                    //           TableRow(
                    //             decoration:
                    //                 const BoxDecoration(color: Colors.black12),
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8),
                    //                 child: Text("Order #",
                    //                     style: const TextStyle(
                    //                         fontWeight: FontWeight.bold)),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8),
                    //                 child: Text("Total",
                    //                     style: const TextStyle(
                    //                         fontWeight: FontWeight.bold)),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8),
                    //                 child: Text("Created At",
                    //                     style: const TextStyle(
                    //                         fontWeight: FontWeight.bold)),
                    //               ),
                    //             ],
                    //           ),
                    //           TableRow(
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8),
                    //                 child: Text(order["id"]?.toString() ?? "-"),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8),
                    //                 child: Text(order["total_after_tax"] != null
                    //                     ? double.tryParse(order["total_after_tax"]
                    //                                 .toString())
                    //                             ?.toStringAsFixed(2) ??
                    //                         "-"
                    //                     : "-"),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8),
                    //                 child: Text(
                    //                     order["created_at"]?.toString() ?? "-"),
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     );
                    //   }
                    // },
                  ),
                ),
              );
            }

            return Center(child: Text(S.of(context).somethingWentWrong));
          },
        ),
      ),
    );
  }

  Text customCardTitle(BuildContext context, {required String title}) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _row(String label, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: Text(
            value ?? "-",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
