part of 'delete_branch_cubit.dart';

@immutable
sealed class DeleteBranchState {}

final class DeleteBranchInitial extends DeleteBranchState {}

final class DeleteBranchLoading extends DeleteBranchState {}

final class DeleteBranchSuccess extends DeleteBranchState {
  final int id;
  DeleteBranchSuccess({required this.id});
}

final class DeleteBranchFailing extends DeleteBranchState {
  final ApiResponse errMessage;
  DeleteBranchFailing({required this.errMessage});
}
