part of 'edit_category_cubit.dart';

@immutable
sealed class EditCategoryState {}

final class EditCategoryInitial extends EditCategoryState {}

final class EditCategoryLoading extends EditCategoryState {}

final class EditCategorySuccess extends EditCategoryState {
  final CategoryModel category;

  EditCategorySuccess({required this.category});
}

final class EditCategoryUnValidate extends EditCategoryState {}

final class EditCategoryFailing extends EditCategoryState {
  final ApiResponse errMessage;

  EditCategoryFailing({required this.errMessage});
}
