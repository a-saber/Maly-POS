part of 'get_all_branches_cubit.dart';

@immutable
sealed class GetAllBranchesState {}

final class GetAllBranchesInitial extends GetAllBranchesState {}

final class GetAllBranchesLoading extends GetAllBranchesState {}

final class GetAllBranchesSuccess extends GetAllBranchesState {}

final class GetAllBranchesFailing extends GetAllBranchesState {
  final ApiResponse errMessage;
  GetAllBranchesFailing({required this.errMessage});
}

final class GetBranchesPaginationFailing extends GetAllBranchesState {
  final ApiResponse errMessage;
  GetBranchesPaginationFailing({required this.errMessage});
}
