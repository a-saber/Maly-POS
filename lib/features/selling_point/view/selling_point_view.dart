import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/is_mobile.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/features/selling_point/view/widget/select_branch_selling_point.dart';
import 'package:pos_app/features/selling_point/view/widget/selling_point_mobile_body.dart';
import 'package:pos_app/features/selling_point/view/widget/selling_point_tablet_desktop_body.dart';
import 'package:pos_app/generated/l10n.dart';

class SellingPointView extends StatefulWidget {
  const SellingPointView({super.key});

  @override
  State<SellingPointView> createState() => _SellingPointViewState();
}

class _SellingPointViewState extends State<SellingPointView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectBranch(
        context: context,
      );
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //  = scaffoldKey;
    return BlocProvider.value(
      value: MyServiceLocator.getSingleton<SellingPointProductCubit>()
        ..initThePaymentOrderAndTypeOfTakeOrder(context: context),
      child: Builder(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: true,

          appBar: isMobile(context: context)
              ? CustomAppBar(
                  automaticallyImplyLeading: false,
                  title: S.of(context).sellingPoint,
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      size: getResponsiveSize(context, size: 25),
                    ),
                  ),
                  actions: [
                    SizedBox.shrink(),
                  ],
                )
              : null,

          floatingActionButton: isMobile(context: context)
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, AppRoutes.sellingPointCardView);
                  },
                  child: BlocBuilder<SellingPointProductCubit,
                      SellingPointProductState>(
                    buildWhen: (previous, current) {
                      return current is SellingPointProductAddingProduct ||
                          current is SellingPointProductRemoveProduct ||
                          current is SellingPointProductResetProduct;
                    },
                    builder: (context, state) {
                      return Stack(
                        clipBehavior: Clip.none,
                        textDirection: TextDirection.rtl,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: getResponsiveSize(context, size: 30),
                          ),
                          SellingPointProductCubit.get(context)
                                  .products
                                  .isNotEmpty
                              ? Positioned(
                                  top: -4,
                                  right: -4,
                                  child: Container(
                                    height:
                                        getResponsiveSize(context, size: 20),
                                    width: getResponsiveSize(context, size: 20),
                                    // padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        SellingPointProductCubit.get(context)
                                                    .products
                                                    .length <=
                                                99
                                            ? SellingPointProductCubit.get(
                                                    context)
                                                .products
                                                .length
                                                .toString()
                                            : "99+",
                                        style: AppFontStyle.s10(
                                          context: context,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      );
                    },
                  ),
                )
              : null,

          endDrawerEnableOpenDragGesture:
              false, // not allow drawer to open when scroll in case arabic
          drawerEnableOpenDragGesture:
              false, // not allow drawer to open when scroll englishs
          body: SafeArea(
            child: CustomLayoutBuilder(
              mobile: SellingPointMobileBody(),
              tablet: SellingPointTabletDesktopBody(),
              desktop: SellingPointTabletDesktopBody(),
            ),
          ),
        );
      }),
    );
  }
}
