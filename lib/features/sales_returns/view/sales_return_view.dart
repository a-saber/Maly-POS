import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/is_mobile.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/features/sales_returns/data/model/sales_return_model.dart';
import 'package:pos_app/features/sales_returns/manager/get_sales_return_cubit/get_sales_return_cubit.dart';
import 'package:pos_app/features/sales_returns/manager/sales_return_filter_cubit/sales_return_filter_cubit.dart';
import 'package:pos_app/features/sales_returns/view/widget/cubit_sales_return_build.dart';
import 'package:pos_app/features/sales_returns/view/widget/custom_filter_sales_return_drawer.dart';
import 'package:pos_app/features/sales_returns/view/widget/sales_return_item_build.dart';
import 'package:pos_app/generated/l10n.dart';

class SalesReturnView extends StatefulWidget {
  const SalesReturnView({super.key});

  @override
  State<SalesReturnView> createState() => _SalesReturnViewState();
}

class _SalesReturnViewState extends State<SalesReturnView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    MyServiceLocator.getIt<GetSalesReturnCubit>().reset();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesReturnFilterCubit(),
      child: Scaffold(
        key: isMobile(context: context) ? scaffoldKey : null,
        appBar: CustomAppBar(
          leading: BackButton(),
          title: S.of(context).salesReturn,
          actions: isMobile(context: context)
              ? [
                  IconButton(
                    onPressed: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    icon: Icon(
                      Icons.tune_outlined,
                    ),
                  )
                ]
              : [],
        ),
        drawer: isMobile(context: context)
            ? Drawer(
                child: Padding(
                  padding: AppPaddings.defaultView,
                  child: CustomFilterSalesReturnDrawer(),
                ),
              )
            : null,
        body: CustomRefreshIndicator(
          onRefresh: () async {
            GetSalesReturnCubit.get(context).getSalesReturn();
          },
          child: CustomLayoutBuilder(
            mobile: Padding(
              padding: AppPaddings.defaultView,
              child: CustomSalesReturnMobileBody(),
            ),
            tablet: Padding(
              padding: AppPaddings.defaultView,
              child: CustomSalesReturnTabletAndDesktopBody(),
            ),
            desktop: Padding(
              padding: AppPaddings.defaultView,
              child: CustomSalesReturnTabletAndDesktopBody(),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSalesReturnMobileBody extends StatelessWidget {
  const CustomSalesReturnMobileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CubitSalesReturnBuild(
      salesReturnLoading: (context) => CustomGridViewCard(
        widthOfCard: 450,
        heightOfCard: getResponsiveSize(context, size: 250),
        itemBuilder: (context, index) => SalesReturnItemLoadingBuild(),
        itemCount: AppConstant.numberOfCardLoading,
      ),
      salesReturnBuild:
          (BuildContext context, List<SalesReturnModel> salesReturn) {
        return CustomGridViewCard(
          widthOfCard: 450,
          heightOfCard: getResponsiveSize(context, size: 250),
          controller: GetSalesReturnCubit.get(context).scrollController,
          canLaoding: GetSalesReturnCubit.get(context).canLoading(),
          itemBuilder: (BuildContext context, int index) {
            return SalesReturnItemBuild(
              salesReturnModel: salesReturn[index],
            );
          },
          itemCount: salesReturn.length,
        );
      },
    );
  }
}

class CustomSalesReturnTabletAndDesktopBody extends StatelessWidget {
  const CustomSalesReturnTabletAndDesktopBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      // spacing: DeviceSize.getWidth(context: context) * 0.02,
      children: [
        Expanded(child: CustomFilterSalesReturnDrawer()),
        VerticalDivider(),
        Expanded(flex: 2, child: CustomSalesReturnMobileBody()),
      ],
    );
  }
}
