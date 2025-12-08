import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/extensions.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/features/shifts/data/model/getshift.dart';
import 'package:pos_app/generated/l10n.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key, required this.order});
  final OrderData order;
  @override
  Widget build(BuildContext context) {
    final double spacingBetweenCard = 16;
    final double spacingBetweenRowInCard = 3;
    final double paddingCard = 10.0;
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).orderDetails),
      body: SafeArea(
        child: Padding(

          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customCardTitle(context, title: S.of(context).orderDetails),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(paddingCard),
                        child: Column(
                          spacing: spacingBetweenRowInCard,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _row(S.of(context).orderId,
                                order.id?.toString() ?? "-"),
                            _row(S.of(context).subTotal,
                                order.subtotal?.toAmount() ?? "-"),
                            _row(S.of(context).discount,
                                order.discountTotal?.toAmount() ?? "-"),
                            _row(S.of(context).totalAfterDiscount,
                                order.totalAfterDiscount?.toAmount() ?? "-"),
                            _row(S.of(context).tax,
                                order.taxTotal?.toAmount() ?? "-"),
                            _row(S.of(context).totalAfterTax,
                                order.totalAfterTax?.toAmount() ?? "-"),
                            _row(S.of(context).paymentmethod,
                                order.paymentMethod ?? "-"),
                            _row(S.of(context).orderType, order.orderType ?? "-"),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customCardTitle(context, title: S.of(context).userInfo),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(paddingCard),
                        child: Column(
                          spacing: spacingBetweenRowInCard,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _row(S.of(context).name, order.user?.name ?? "-"),
                            _row(S.of(context).email, order.user?.email ?? "-"),
                            _row(S.of(context).phone, order.user?.phone ?? "-"),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customCardTitle(context, title: S.of(context).branch),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(paddingCard),
                        child: Column(
                          spacing: spacingBetweenRowInCard,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _row(S.of(context).name, order.branch?.name ?? "-"),
                            _row(S.of(context).email, order.branch?.email ?? "-"),
                            _row(S.of(context).phone, order.branch?.phone ?? "-"),
                            _row(S.of(context).address,
                                order.branch?.address ?? "-"),
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
                child: customCardTitle(context, title: S.of(context).products),
              ),
              SliverGrid.builder(
                itemCount: order.saleProducts?.length ?? 0,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 900,
                  mainAxisExtent: 110,
                  childAspectRatio: 4 / 1,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: paddingCard),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 50,
                          children: [
                            Expanded(
                              child: _row(
                                S.of(context).id,
                                order.saleProducts?[index].product?.id
                                        ?.toString() ??
                                    '-',
                              ),
                            ),
                            Expanded(
                              child: _row(
                                S.of(context).type,
                                order.saleProducts?[index].product?.type ?? '-',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 50,
                          children: [
                            Expanded(
                              child: _row(
                                S.of(context).name,
                                order.saleProducts?[index].product?.name
                                        ?.toString() ??
                                    '-',
                              ),
                            ),
                            Expanded(
                              child: _row(
                                S.of(context).brand,
                                order.saleProducts?[index].product?.brand
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
                                S.of(context).price,
                                order.saleProducts?[index].price.toAmount()?.toString() ?? '-',
                              ),
                            ),
                            Expanded(
                              child: _row(
                                S.of(context).priceAfterTax,
                                order.saleProducts?[index].lineTotalAfterTax
                                          ?.toString().toAmount() ??
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
                                  S.of(context).Quantity,
                                  order.saleProducts?[index].quantity
                                          ?.toString() ??
                                      '-',
                                ),
                              ),
                              Expanded(
                                child: _row(
                                  S.of(context).description,
                                  order.saleProducts?[index].product
                                          ?.description ??
                                      '-',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: spacingBetweenCard,
                ),
              ),
            ],
          ),
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
