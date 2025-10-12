import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/data/repo/category_repo.dart';

part 'get_category_state.dart';

class GetCategoryCubit extends Cubit<GetCategoryState> {
  GetCategoryCubit(this.categoryRepo) : super(GetCategoryInitial());

  static GetCategoryCubit get(context) => BlocProvider.of(context);

  final CategoryRepo categoryRepo;

  late ScrollController scrollController;

  List<CategoryModel> categories = [];

  bool canLoading() => categoryRepo.getCategory?.nextPageUrl != null;
  bool isFirtsTime() => categoryRepo.getCategory == null;

  void init() {
    if (isFirtsTime()) {
      getCategories();
    }

    scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getPaginationCategories();
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
            log("getPaginationCategories");
            // ignore: use_build_context_synchronously
            getPaginationCategories();
          });
        }
      });
    }
  }

  Future<void> getCategories() async {
    emit(GetCategoryLoading());
    // await Future.delayed(Duration(seconds: 10));
    final result = await categoryRepo.getCategories(
      isRefresh: true,
    );
    result.fold(
      (l) => emit(GetCategoryError(l)),
      (r) {
        categories = r;
        ifNotFillScreen();
        emit(GetCategorySuccess());
      },
    );
  }

  void getPaginationCategories() async {
    final result = await categoryRepo.getCategories();
    result.fold(
      (l) => emit(GetPaginationCategoryError(l)),
      (r) {
        categories.addAll(r);
        ifNotFillScreen();
        emit(GetCategorySuccess());
      },
    );
  }

  void addCategory(CategoryModel category) {
    if (!canLoading()) {
      categories.add(category);
      emit(GetCategorySuccess());
    }
  }

  void deleteCategory(int id) {
    categories.removeWhere((element) => element.id == id);
    emit(GetCategorySuccess());
  }

  void updateCategory(CategoryModel category) {
    categories[categories.indexWhere((element) => element.id == category.id)] =
        category;
    emit(GetCategorySuccess());
  }

  void reset() {
    categories = [];
    categoryRepo.resetCategories();
  }

  @override
  void emit(GetCategoryState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  void resetController() {
    scrollController.dispose();
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
