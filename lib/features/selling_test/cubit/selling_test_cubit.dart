import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/features/selling_test/cubit/selling_test_state.dart';
import 'package:pos_app/features/selling_test/data/models/selling_test_model.dart';
import 'package:pos_app/features/selling_test/data/repo/selling_test_repo.dart';

import '../../../core/api/api_helper.dart';

class SellingTestCubit extends Cubit<SellingTestState>{
  SellingTestCubit() : super(SellingTestInitial());
  static SellingTestCubit get(context) => BlocProvider.of(context);
  var searchController = TextEditingController();
  SellingTestRepo sellingTestRepo = SellingTestRepo(api: MyServiceLocator.getSingleton<ApiHelper>());
  List<SellingTestModel> sellingTestModels = [];

  getData({
    required int branchId,
    required int categoryId,
    String search = '',
})async
  {
    emit(SellingTestLoading());
    var response = await sellingTestRepo.getData(
        branchId: branchId,
        categoryId: categoryId,
        search: search
    );
    sellingTestModels = response;
    emit(SellingTestSuccess());
  }
}