part of 'delete_category_cubit.dart';

@immutable
sealed class DeleteCategoryState {}

final class DeleteCategoryInitial extends DeleteCategoryState {}

final class DeleteCategoryLoading extends DeleteCategoryState {}

final class DeleteCategorySuccess extends DeleteCategoryState {
  final int id;
  DeleteCategorySuccess({required this.id});
}

final class DeleteCategoryFailing extends DeleteCategoryState {
  final ApiResponse errMessage;
  DeleteCategoryFailing(this.errMessage);
}
