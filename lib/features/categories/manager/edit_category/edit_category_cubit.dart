// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
// ignore: unnecessary_import
import 'package:meta/meta.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/data/repo/category_repo.dart';

part 'edit_category_state.dart';

class EditCategoryCubit extends Cubit<EditCategoryState> {
  EditCategoryCubit(this.repo, this.categoryModel)
      : super(EditCategoryInitial()) {
    nameController = TextEditingController(text: categoryModel.name);
    descriptionController =
        TextEditingController(text: categoryModel.description);
  }

  static EditCategoryCubit get(context) => BlocProvider.of(context);

  final CategoryRepo repo;
  final CategoryModel categoryModel;

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  XFile? image;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  Future<void> onTap() async {
    emit(EditCategoryLoading());

    if (formKey.currentState!.validate()) {
      var resposne = await repo.updateCategory(
          category: CategoryModel.createWithoutId(
        id: categoryModel.id,
        name: nameController.text,
        description: descriptionController.text,
        image: image == null ? null : File(image!.path),
      ));

      resposne.fold(
        (error) => emit(EditCategoryFailing(errMessage: error)),
        (r) => emit(EditCategorySuccess(
          category: r,
        )),
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(EditCategoryUnValidate());
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
  void emit(EditCategoryState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
