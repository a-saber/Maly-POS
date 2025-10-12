import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/branch/data/repo/branches_repo.dart';

part 'delete_branch_state.dart';

class DeleteBranchCubit extends Cubit<DeleteBranchState> {
  DeleteBranchCubit(this.repo) : super(DeleteBranchInitial());

  static DeleteBranchCubit get(context) => BlocProvider.of(context);

  final BranchesRepo repo;

  Future<void> deleteBranch({required BrancheModel branch}) async {
    emit(DeleteBranchLoading());
    final result = await repo.deleteBranch(
      branch: branch,
    );
    result.fold(
      (errMessage) => emit(DeleteBranchFailing(errMessage: errMessage)),
      (r) => emit(DeleteBranchSuccess(id: r)),
    );
  }

  @override
  void emit(DeleteBranchState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
