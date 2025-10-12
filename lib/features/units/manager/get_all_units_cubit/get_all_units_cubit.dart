import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/data/repo/units_repo.dart';

part 'get_all_units_state.dart';

class GetAllUnitsCubit extends Cubit<GetAllUnitsState> {
  GetAllUnitsCubit(this.repo) : super(GetAllUnitsInitial());

  static GetAllUnitsCubit get(context) => BlocProvider.of(context);

  final UnitsRepo repo;

  ScrollController scrollController = ScrollController();
  List<UnitModel> units = [];

  bool canLoading() => repo.getUnitModel?.nextPageUrl != null;
  bool isFirstTimeGetData() => repo.getUnitModel == null;

  void init() {
    if (isFirstTimeGetData()) {
      getUnits();
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (canLoading()) {
          getPaginationUnits();
        }
      }
    });
  }

  bool ifScrollNotFillScreen() {
    if (!scrollController.hasClients) return false;
    return scrollController.position.maxScrollExtent == 0;
  }

  void ifNotFillScreen() {
    if (canLoading()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ifScrollNotFillScreen()) {
          Future.delayed(
              const Duration(seconds: AppConstant.callPaginationSeconds), () {
            log("getPaginationPermissions");
            // ignore: use_build_context_synchronously
            getPaginationUnits();
          });
        }
      });
    }
  }

  void getUnits() async {
    emit(GetAllUnitsLoading());
    final result = await repo.getUnits(isRefresh: true);
    result.fold(
      (errMessage) => emit(GetAllUnitsFailing(errMessage: errMessage)),
      (r) {
        units = r;
        ifNotFillScreen();
        emit(GetAllUnitsSuccess());
      },
    );
  }

  void getPaginationUnits() async {
    final result = await repo.getUnits();
    result.fold(
      (errMessage) =>
          emit(GetAllUnitsPaginationFailing(errMessage: errMessage)),
      (r) {
        units.addAll(r);
        ifNotFillScreen();
        emit(GetAllUnitsSuccess());
      },
    );
  }

  void addUnits(UnitModel unit) {
    if (!canLoading()) {
      units.add(unit);
      emit(GetAllUnitsSuccess());
    }
  }

  void deleteUnits(int id) {
    units.removeWhere((element) => element.id == id);
    emit(GetAllUnitsSuccess());
  }

  void updateUnits(UnitModel unit) {
    units[units.indexWhere((element) => element.id == unit.id)] = unit;
    emit(GetAllUnitsSuccess());
  }

  @override
  void emit(GetAllUnitsState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }

  void reset() {
    units = [];
    repo.reset();
  }
}
