import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/data/repo/category_repo.dart';

part 'delete_category_state.dart';

class DeleteCategoryCubit extends Cubit<DeleteCategoryState> {
  DeleteCategoryCubit(this.repo) : super(DeleteCategoryInitial());

  static DeleteCategoryCubit get(context) => BlocProvider.of(context);

  final CategoryRepo repo;

  Future<void> deleteCategory({required CategoryModel category}) async {
    emit(DeleteCategoryLoading());
    final result = await repo.deleteCategory(
      category: category,
    );
    result.fold(
      (l) => emit(DeleteCategoryFailing(l)),
      (r) => emit(DeleteCategorySuccess(
        id: r,
      )),
    );
  }

  @override
  void emit(DeleteCategoryState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
