import 'dart:io';

// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages, unnecessary_import
import 'package:meta/meta.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/data/repo/category_repo.dart';

part 'add_gategory_state.dart';

class AddCategoryCubit extends Cubit<AddCategoryState> {
  AddCategoryCubit(this.repo) : super(AddCategoryInitial());

  static AddCategoryCubit get(context) => BlocProvider.of(context);

  final CategoryRepo repo;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  XFile? image;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  void onTap() async {
    emit(AddCategoryLoading());

    if (formKey.currentState!.validate()) {
      var response = await repo.addCategory(
        category: CategoryModel.createWithoutId(
          name: nameController.text,
          description: descriptionController.text,
          image: image == null ? null : File(image!.path),
        ),
      );

      response.fold(
          (l) => emit(AddCategoryFailing(errMessage: l)),
          (ifRight) => emit(AddCategorySuccess(
                category: ifRight,
              )));
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(AddCategoryUnValidateInput());
    }
  }

  void onSelectImage(XFile newImage) {
    image = newImage;
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    return super.close();
  }

  @override
  void emit(AddCategoryState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
