import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/expense_categories/data/model/expense_categories_model.dart';
import 'package:pos_app/features/expense_categories/data/repo/expense_categories_repo.dart';

part 'get_expense_categories_state.dart';

class GetExpenseCategoriesCubit extends Cubit<GetExpenseCategoriesState> {
  GetExpenseCategoriesCubit(this.repo) : super(GetExpenseCategoriesInitial());

  static GetExpenseCategoriesCubit get(context) => BlocProvider.of(context);

  final ExpenseCategoriesRepo repo;
  List<ExpenseCategoriesModel> expenseCategories = [];

  ScrollController scrollController = ScrollController();

  bool canLoading() => repo.getExpenseCategoriesModel?.nextPageUrl != null;
  bool firstTimeGetData() => repo.getExpenseCategoriesModel == null;

  void init() {
    if (firstTimeGetData()) {
      getExpenseCategories();
    }
    scrollController.addListener(() {
      if (canLoading() &&
          scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
        getPaginationExpenseCategories();
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
            getPaginationExpenseCategories();
          });
        }
      });
    }
  }

  void getExpenseCategories() async {
    emit(GetExpenseCategoriesLoading());

    //  : Remove Wait
    // await Future.delayed(const Duration(seconds: 10));
    var result = await repo.getExpenseCategories(
      isRefresh: true,
    );
    result.fold((l) => emit(GetExpenseCategoriesFailing(errMessage: l)),
        (expanses) {
      expenseCategories = expanses;
      ifNotFillScreen();
      emit(GetExpenseCategoriesSuccess());
    });
  }

  void getPaginationExpenseCategories() async {
    var result = await repo.getExpenseCategories();
    result
        .fold((l) => emit(GetExpenseCategoriesPaginationFailing(errMessage: l)),
            (expanses) {
      expenseCategories.addAll(expanses);
      ifNotFillScreen();
      emit(GetExpenseCategoriesSuccess());
    });
  }

  void addExpenseCategories(
      {required ExpenseCategoriesModel expenseCategories}) {
    if (!canLoading()) {
      this.expenseCategories.add(expenseCategories);
      emit(GetExpenseCategoriesSuccess());
    }
  }

  void updateExpenseCategories({required ExpenseCategoriesModel expense}) {
    expenseCategories[expenseCategories
        .indexWhere((element) => element.id == expense.id)] = expense;
    emit(GetExpenseCategoriesSuccess());
  }

  void deleteExpenseCategories({required int id}) {
    expenseCategories.removeWhere((element) => element.id == id);
    emit(GetExpenseCategoriesSuccess());
  }

  void reset() {
    expenseCategories = [];
    repo.reset();
  }

  @override
  void emit(GetExpenseCategoriesState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
