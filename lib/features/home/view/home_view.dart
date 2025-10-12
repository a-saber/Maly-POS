import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/features/home/manager/cubit/home_cubit.dart';
import 'package:pos_app/features/home/view/widget/custom_drawer.dart';
import 'package:pos_app/generated/l10n.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  int getColumnCount(context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 6;
    if (width >= 1000) return 5;
    if (width >= 800) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int columnCount = getColumnCount(context);
    return BlocProvider.value(
      value: MyServiceLocator.getIt<HomeCubit>()..init(),
      child: Builder(builder: (context) {
        return BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeFailing) {
              if (context.mounted) {
                CustomPopUp.callMyToast(
                  context: context,
                  massage: mapStatusCodeToMessage(context, state.errMessage),
                  state: PopUpState.ERROR,
                );
              }
            }
          },
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state is HomeLoading,
              child: Scaffold(
                key: scaffoldKey,
                appBar: CustomAppBar(
                  title: S.of(context).home,
                  leading: IconButton(
                    onPressed: () async {
                      scaffoldKey.currentState!.openDrawer();
                    },
                    icon: const Icon(Icons.grid_view_rounded),
                  ),
                ),
                drawer: CustomDrawer(
                  scaffoldKey: scaffoldKey,
                ),
                body: ListView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    AnimationLimiter(
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(15),
                        crossAxisCount: columnCount,
                        children: List.generate(
                          AppConstant.gridItems(context: context).length,
                          (int index) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: Duration(seconds: 1),
                              columnCount: columnCount,
                              child: ScaleAnimation(
                                duration: Duration(seconds: 2),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: FadeInAnimation(
                                  child: AppConstant.gridItems(
                                      context: context)[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
