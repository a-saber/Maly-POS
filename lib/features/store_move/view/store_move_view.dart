import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/is_mobile.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_grid_view_card.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/features/store_move/manager/filter_store_move_cubit/filter_store_move_cubit.dart';
import 'package:pos_app/features/store_move/manager/store_move_cubit/store_move_cubit.dart';
import 'package:pos_app/features/store_move/view/widget/cutsom_store_move_drawer.dart';
import 'package:pos_app/features/store_move/view/widget/store_move_cubit_build.dart';
import 'package:pos_app/features/store_move/view/widget/store_move_item_build.dart';
import 'package:pos_app/generated/l10n.dart';

class StoreMoveView extends StatefulWidget {
  const StoreMoveView({super.key});

  @override
  State<StoreMoveView> createState() => _StoreMoveViewState();
}

class _StoreMoveViewState extends State<StoreMoveView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  late StoreMoveCubit storeMoveCubit;

  @override
  void didChangeDependencies() {
    storeMoveCubit = StoreMoveCubit.get(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    storeMoveCubit.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterStoreMoveCubit(),
      child: Scaffold(
        key: isMobile(context: context) ? scaffoldKey : null,
        appBar: CustomAppBar(
          leading: BackButton(),
          title: S.of(context).storeMove,
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
                  child: CutsomStoreMoveDrawer(),
                ),
              )
            : null,
        body: CustomRefreshIndicator(
          onRefresh: () async {
            StoreMoveCubit.get(context).getAllData();
          },
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: CustomFormField(
                  controller: TextEditingController(
                    text: StoreMoveCubit.get(context).query,
                  ),
                  onChanged: (value) =>
                      StoreMoveCubit.get(context).onSearchChanged(
                    value,
                  ),
                  suffixIcon: Icon(Icons.search),
                  hintText: S.of(context).search,
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              Expanded(
                child: CustomLayoutBuilder(
                    mobile: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: CustomStoreMoveMobileBody(),
                    ),
                    tablet: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: CustomSoreMoveTabletAndDesktopBody(),
                    ),
                    desktop: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: CustomSoreMoveTabletAndDesktopBody(),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomStoreMoveMobileBody extends StatelessWidget {
  const CustomStoreMoveMobileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreMoveCubitBuild(
      storeMovementLoading: (context) => CustomGridViewCard(
        widthOfCard: 450,
        heightOfCard: getResponsiveSize(context, size: 140),
        itemBuilder: (BuildContext context, int index) {
          return StoreMoveItemBuildLoading();
        },
        itemCount: AppConstant.numberOfCardLoading,
      ),
      storeMovementBuild: (context, data) {
        return CustomGridViewCard(
          widthOfCard: 450,
          heightOfCard: getResponsiveSize(context, size: 140),
          controller: StoreMoveCubit.get(context).scrollController,
          canLaoding: StoreMoveCubit.get(context).canLoading(),
          itemBuilder: (BuildContext context, int index) {
            return StoreMoveItemBuild(
              storeMove: data[index],
            );
          },
          itemCount: data.length,
        );
      },
    );
  }
}

class CustomSoreMoveTabletAndDesktopBody extends StatelessWidget {
  const CustomSoreMoveTabletAndDesktopBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      // spacing: DeviceSize.getWidth(context: context) * 0.02,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: CutsomStoreMoveDrawer(),
          ),
        ),
        VerticalDivider(),
        Expanded(flex: 2, child: CustomStoreMoveMobileBody()),
      ],
    );
  }
}
