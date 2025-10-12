part of 'add_gategory_cubit.dart';

@immutable
sealed class AddCategoryState {}

final class AddCategoryInitial extends AddCategoryState {}

final class AddCategoryLoading extends AddCategoryState {}

final class AddCategoryUnValidateInput extends AddCategoryState {}

final class AddCategorySuccess extends AddCategoryState {
  final CategoryModel category;

  AddCategorySuccess({required this.category});
}

final class AddCategoryFailing extends AddCategoryState {
  final ApiResponse errMessage;

  AddCategoryFailing({required this.errMessage});
}
