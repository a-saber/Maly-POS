import 'dart:async';

import 'package:async_searchable_dropdown/async_searchable_dropdown.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_decoration.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final FutureOr<List<T>> Function(String, LoadProps?)? itemsFunction;
  final void Function(T?) onChanged;
  final String? hint;
  final bool isExpanded;
  final String? Function(T?)? validator;
  final bool search;
  final bool Function(T, T)? compareFn;
  final Widget Function(T?) builder;
  final bool Function(T, String)? filterFn;
  final bool enabled;
  final Widget Function(BuildContext, Widget)? containerBuilder;
  final void Function(String)? onChangedInTextField;
  final Widget? prefixIcon;
  const CustomDropdown(
      {super.key,
      required this.value,
      required this.items,
      required this.onChanged,
      this.hint,
      this.isExpanded = true,
      this.validator,
      this.search = false,
      this.compareFn,
      required this.builder,
      this.enabled = true,
      this.filterFn,
      this.containerBuilder,
      this.onChangedInTextField,
      this.itemsFunction,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      compareFn: compareFn,
      selectedItem: value,
      filterFn: filterFn,
      enabled: enabled,
      items: itemsFunction ?? (filter, infiniteScrollProps) => items,
      decoratorProps: DropDownDecoratorProps(
        baseStyle: AppFontStyle.formText(
          context: context,
        ),
        decoration: AppDecoration.inputDecoration(
            prefixIcon: prefixIcon,
            labelText: hint ?? S.of(context).selectanitem,
            context: context),
      ),

      popupProps: PopupProps.menu(
          itemBuilder: (context, item, isSelected, x) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: builder(item),
            );
          },
          containerBuilder: containerBuilder,
          showSearchBox: search,
          searchFieldProps: TextFieldProps(
            onChanged: onChangedInTextField,
            decoration: AppDecoration.inputDecoration(
              context: context,
              labelText: S.of(context).search,
            ),
          ),
          fit: FlexFit.loose,
          constraints: BoxConstraints()),
      dropdownBuilder: (context, selectedItem) => builder(selectedItem),
      onChanged: onChanged,
      validator: validator,
      //style: AppTextStyles.formText(),
    );
  }
}

class CustomSearchDropDown<T extends Object> extends StatelessWidget {
  final String? hint;
  final T? value;
  final Future<List<T>?> Function(String?) remoteItems;
  final void Function(T?)? onChanged;
  final String Function(T) itemLabelFormatter;
  final Widget? prefixIcon;

  const CustomSearchDropDown(
      {super.key,
      this.hint,
      this.value,
      required this.remoteItems,
      this.onChanged,
      required this.itemLabelFormatter,
      this.prefixIcon});
  @override
  Widget build(BuildContext context) {
    return SearchableDropdown<T>(
      value: value,
      inputDecoration: AppDecoration.inputDecoration(
          prefixIcon: prefixIcon,
          labelText: hint ?? S.of(context).selectanitem,
          context: context),
      remoteItems: remoteItems,
      itemLabelFormatter: itemLabelFormatter,
      onChanged: onChanged,
    );
  }
}
