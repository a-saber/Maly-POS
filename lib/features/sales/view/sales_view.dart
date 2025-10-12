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
import 'package:pos_app/features/sales/data/model/sales_model.dart';
import 'package:pos_app/features/sales/manager/get_sales_cubit/get_sales_cubit.dart';
import 'package:pos_app/features/sales/manager/sales_filter_cubit/sales_filter_cubit.dart';
import 'package:pos_app/features/sales/view/widget/cubit_sales_build.dart';
import 'package:pos_app/features/sales/view/widget/custom_sales_filter_drawer.dart';
import 'package:pos_app/features/sales/view/widget/sales_item_build.dart';
import 'package:pos_app/generated/l10n.dart';

class SalesView extends StatefulWidget {
  const SalesView({super.key});

  @override
  State<SalesView> createState() => _SalesViewState();
}

class _SalesViewState extends State<SalesView> {
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
    MyServiceLocator.getIt<GetSalesCubit>().reset();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesFilterCubit(),
      child: Scaffold(
        key: isMobile(context: context) ? scaffoldKey : null,
        appBar: CustomAppBar(
          title: S.of(context).sales,
          leading: BackButton(),
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
                  child: CustomSalesFilterDrawer(),
                ),
              )
            : null,
        body: CustomRefreshIndicator(
          onRefresh: () async {
            GetSalesCubit.get(context).getSales();
          },
          child: CustomLayoutBuilder(
            mobile: Padding(
              padding: AppPaddings.defaultView,
              child: CustomSalesMobileBody(),
            ),
            tablet: Padding(
                padding: AppPaddings.defaultView,
                child: CustomSalesTabletAndDesktopBody()),
            desktop: Padding(
              padding: AppPaddings.defaultView,
              child: CustomSalesTabletAndDesktopBody(),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSalesMobileBody extends StatelessWidget {
  const CustomSalesMobileBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CubitSalesBuild(
      salesLoading: (context) => CustomGridViewCard(
        widthOfCard: 450,
        heightOfCard: getResponsiveSize(context, size: 250),
        itemBuilder: (context, index) => SalesItemLoadingBuild(),
        itemCount: AppConstant.numberOfCardLoading,
      ),
      salesBuild: (BuildContext context, List<SalesModel> sales) {
        return CustomGridViewCard(
          widthOfCard: 450,
          heightOfCard: getResponsiveSize(context, size: 250),
          controller: GetSalesCubit.get(context).scrollController,
          canLaoding: GetSalesCubit.get(context).canLoading(),
          itemBuilder: (BuildContext context, int index) {
            return SalesItemBuild(
              salesModel: sales[index],
            );
          },
          itemCount: sales.length,
        );
      },
    );
  }
}

class CustomSalesTabletAndDesktopBody extends StatelessWidget {
  const CustomSalesTabletAndDesktopBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      // spacing: DeviceSize.getWidth(context: context) * 0.02,
      children: [
        Expanded(child: CustomSalesFilterDrawer()),
        VerticalDivider(),
        Expanded(flex: 2, child: CustomSalesMobileBody()),
      ],
    );
  }
}
