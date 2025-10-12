import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/sales/data/model/sort_model.dart';
import 'package:pos_app/features/store_move/data/model/type_of_movement_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

part 'filter_store_move_state.dart';

class FilterStoreMoveCubit extends Cubit<FilterStoreMoveState> {
  FilterStoreMoveCubit() : super(FilterStoreMoveInitial());

  static FilterStoreMoveCubit get(context) => BlocProvider.of(context);

  CategoryModel? category;
  ProductModel? product;
  UnitModel? unit;
  UserModel? user;
  BrancheModel? branch;
  TypeOfMovementModel? typeOfmove;
  DateTime? startDate;
  DateTime? endDate;
  SortModel? sort;
  SortByModel? sortBy;
  TextEditingController quantityMinController = TextEditingController();
  TextEditingController quantityMaxController = TextEditingController();

  void changeCategory(CategoryModel? newCategory) {
    if (category == null || category?.id != newCategory?.id) {
      category = newCategory;
      emit(FilterStoreMoveChangeItem());
    }
  }

  void changeProduct(ProductModel? newProduct) {
    if (product == null || product?.id != newProduct?.id) {
      product = newProduct;
      emit(FilterStoreMoveChangeItem());
    }
  }

  void changeUnit(UnitModel? newUnit) {
    if (unit == null || unit?.id != newUnit?.id) {
      unit = newUnit;
      emit(FilterStoreMoveChangeItem());
    }
  }

  void changeUser(UserModel? newUser) {
    if (user == null || user?.id != newUser?.id) {
      user = newUser;
      emit(FilterStoreMoveChangeItem());
    }
  }

  void changeBranch(BrancheModel? newBranch) {
    if (branch == null || branch?.id != newBranch?.id) {
      branch = newBranch;
      emit(FilterStoreMoveChangeItem());
    }
  }

  void changeTypeOfmove(TypeOfMovementModel? newTypeOfmove) {
    if (typeOfmove == null || typeOfmove?.id != newTypeOfmove?.id) {
      typeOfmove = newTypeOfmove;
      emit(FilterStoreMoveChangeItem());
    }
  }

  void changeStartDate(DateTime? newStartDate) {
    if (startDate == null || startDate != newStartDate) {
      startDate = newStartDate;
      emit(FilterStoreMoveChangeItem());
    }
  }

  void changeEndDate(DateTime? newEndDate) {
    if (endDate == null || endDate != newEndDate) {
      endDate = newEndDate;
      emit(FilterStoreMoveChangeItem());
    }
  }

  void changeSort(SortModel? newSort) {
    if (sort == null || sort?.id != newSort?.id) {
      sort = newSort;
      emit(FilterStoreMoveChangeItem());
    }
  }

  void changeSortBy(SortByModel? newSortBy) {
    if (sortBy == null || sortBy?.id != newSortBy?.id) {
      sortBy = newSortBy;
      emit(FilterStoreMoveChangeItem());
    }
  }

  bool notValidateSortAndSortBy() {
    if ((sort == null && sortBy != null) ||
        ((sort != null && sortBy == null))) {
      return true;
    }
    return false;
  }

  bool notValidateDate() {
    if ((startDate == null && endDate != null) ||
        (startDate != null && endDate == null)) {
      return true;
    }
    return false;
  }

  bool notValidateQuantity() {
    if ((quantityMinController.text.isEmpty &&
            quantityMaxController.text.isNotEmpty) ||
        (quantityMinController.text.isNotEmpty &&
            quantityMaxController.text.isEmpty) ||
        (quantityMinController.text.isNotEmpty &&
            quantityMaxController.text.isNotEmpty &&
            (int.tryParse(quantityMinController.text) ?? 0) >
                (int.tryParse(quantityMaxController.text) ?? -1))) {
      return true;
    }
    return false;
  }
}
