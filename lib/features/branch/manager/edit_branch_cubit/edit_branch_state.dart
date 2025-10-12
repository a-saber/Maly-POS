part of 'edit_branch_cubit.dart';

@immutable
sealed class EditBranchState {}

final class EditBranchInitial extends EditBranchState {}

final class EditBranchLoading extends EditBranchState {}

final class EditBranchSuccess extends EditBranchState {
  final BrancheModel branch;
  EditBranchSuccess({required this.branch});
}

final class EditBranchFailing extends EditBranchState {
  final ApiResponse errMessage;
  EditBranchFailing({required this.errMessage});
}

final class EditBranchUnVaild extends EditBranchState {}
