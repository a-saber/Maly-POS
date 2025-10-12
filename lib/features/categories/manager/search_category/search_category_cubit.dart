import 'dart:async';
import 'dart:developer';

// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/data/repo/category_repo.dart';

part 'search_category_state.dart';

class SearchCategoryCubit extends Cubit<SearchCategoryState> {
  SearchCategoryCubit({required this.repo}) : super(SearchCategoryInitial());

  static SearchCategoryCubit get(context) => BlocProvider.of(context);

  final CategoryRepo repo;
  List<CategoryModel> categories = [];
  String query = "";

  ScrollController scrollController = ScrollController();

  bool canLoading() => repo.getCategorySearch?.nextPageUrl != null;

  bool isFirstTimeGetData() => repo.getCategorySearch == null;

  void init() {
    if (isFirstTimeGetData()) {
      getSearchCategories(
        search: null,
      );
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          canLoading() &&
          !_paginationLoading) {
        getPaginationCategories();
      }
    });
  }

  Timer? _debounce;

  void onChangeSearch({String? query}) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
        const Duration(milliseconds: AppConstant.debouncingMillSeconds), () {
      log("onChangeSearch");
      this.query = query ?? "";
      getSearchCategories(
        search: query,
      );
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

  void getSearchCategories({
    required String? search,
  }) async {
    emit(SearchCategoryLoading());
    final result = await repo.searchCategory(
      search: search,
      isNewSearch: true,
    );
    result.fold(
      (l) => emit(SearchCategoryFailing(errMessage: l)),
      (r) {
        categories = r;
        ifNotFillScreen();
        emit(SearchCategorySuccess());
      },
    );
  }

  bool _paginationLoading = false;

  void getPaginationCategories() async {
    if (_paginationLoading) return;
    _paginationLoading = true;
    final result = await repo.searchCategory(
      search: null,
    );
    result.fold(
      (l) => emit(SearchCategoryFailing(errMessage: l)),
      (r) {
        categories.addAll(r);
        _paginationLoading = false;
        ifNotFillScreen();
        emit(SearchCategorySuccess());
      },
    );
  }

  void reset() {
    // categories = [];
    // repo.resetSearch();
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    _debounce?.cancel();
    return super.close();
  }
}
