import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';

part 'filter_store_quantity_state.dart';

class FilterStoreQuantityCubit extends Cubit<FilterStoreQuantityState> {
  FilterStoreQuantityCubit() : super(FilterStoreQuantityInitial());

  static FilterStoreQuantityCubit get(context) => BlocProvider.of(context);

  CategoryModel? category;
  UnitModel? unit;
  TextEditingController rangePrice = TextEditingController();
  TextEditingController rangeQuantity = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  double? minPrice;
  double? maxPrice;
  int? minQuantity;
  int? maxQuantity;

  void changeCategory(CategoryModel? category) {
    this.category = category;
    emit(FilterStoreQuantityChangeCategory());
  }

  void changeUnit(UnitModel? unit) {
    this.unit = unit;
    emit(FilterStoreQuantityChangeUnit());
  }

  void onTap() {
    if (formKey.currentState!.validate()) {
      if (rangePrice.text.isNotEmpty) {
        extractRangeOfPrice(rangePrice.text);
      } else {
        minPrice = null;
        maxPrice = null;
      }
      if (rangeQuantity.text.isNotEmpty) {
        extractIntegerRangeToVars(rangeQuantity.text);
      } else {
        minQuantity = null;
        maxQuantity = null;
      }

      emit(FilterStoreQuantitySuccess());
    } else {
      autovalidateMode = AutovalidateMode.always;
      emit(FilterStoreQuantityUnValidate());
    }
  }

  void extractRangeOfPrice(String value) {
    final rangeRegex =
        RegExp(r'^\s*([\d]+(?:\.\d+)?)\s*-\s*([\d]+(?:\.\d+)?)\s*$');
    final match = rangeRegex.firstMatch(value.trim());

    if (match != null) {
      minPrice = double.parse(match.group(1)!);
      maxPrice = double.parse(match.group(2)!);
    }
  }

  void extractIntegerRangeToVars(String value) {
    final rangeRegex = RegExp(r'^\s*(\d+)\s*-\s*(\d+)\s*$');
    final match = rangeRegex.firstMatch(value.trim());

    if (match != null) {
      minQuantity = int.parse(match.group(1)!);
      maxQuantity = int.parse(match.group(2)!);
    }
  }
}
