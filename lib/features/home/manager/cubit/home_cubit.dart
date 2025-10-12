import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/home/data/repo/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.repo) : super(HomeInitial());
  final HomeRepo repo;
  static HomeCubit get(context) => BlocProvider.of(context);

  void init() {
    getUser();
  }

  void getUser() async {
    emit(HomeLoading());
    var response = await repo.getUsers();
    response.fold((errMessage) => emit(HomeFailing(errMessage: errMessage)),
        (users) {
      emit(HomeSuccess());
    });
  }
}
