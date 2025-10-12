part of 'add_branch_cubit.dart';

@immutable
sealed class AddBranchState {}

final class AddBranchInitial extends AddBranchState {}

final class AddBranchLoading extends AddBranchState {}

final class AddBranchSuccess extends AddBranchState {
  final BrancheModel branch;
  AddBranchSuccess({required this.branch});
}

final class AddBranchFailing extends AddBranchState {
  final ApiResponse errMessage;
  AddBranchFailing({required this.errMessage});
}

final class AddBranchUnVaild extends AddBranchState {}
