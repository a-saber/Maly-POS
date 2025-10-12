import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_drop_down.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/clients/manager/search_client/search_client_cubit.dart';
import 'package:pos_app/features/clients/view/widget/search_client_build.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomDropDownClient extends StatelessWidget {
  const CustomDropDownClient({
    super.key,
    this.value,
    required this.onChanged,
    this.prefixIcon,
  });
  final CustomerModel? value;
  final Function(CustomerModel?) onChanged;
  final Widget? prefixIcon;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MyServiceLocator.getIt<SearchClientCubit>(),
      child: Builder(builder: (context) {
        return CustomDropdown<CustomerModel>(
          prefixIcon: prefixIcon,
          // search: true,
          hint: S.of(context).selectClient,
          compareFn: (item1, item2) {
            if (item1.name == null ||
                item1.name!.isEmpty ||
                item2.name!.isEmpty) {
              return false;
            } else {
              return (item1.name!
                      .toLowerCase()
                      .contains(item2.name!.toLowerCase()) ||
                  item2.name!
                      .toLowerCase()
                      .contains(item1.name!.toLowerCase()));
            }
          },
          value: value,
          items: SearchClientCubit.get(context).clients,
          filterFn: (item, filter) {
            return item.name!.toLowerCase().contains(filter.toLowerCase());
          },
          containerBuilder: (p0, p1) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomFormField(
                    hintText: S.of(context).searchClient,
                    controller: TextEditingController(
                        text: SearchClientCubit.get(context).query),
                    onChanged: (value) =>
                        SearchClientCubit.get(context).onSearchChanged(
                      value,
                    ),
                  ),
                ),
                Expanded(
                  child: SearchClientBuild(
                    name: value?.name ?? '',
                    child: p1,
                    onTap: (p0) {
                      onChanged(p0);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
          onChanged: (p0) {},
          builder: (CustomerModel? customer) {
            if (customer != null) {
              return Text(
                customer.name ?? S.of(context).noName,
                style: AppFontStyle.formText(
                  context: context,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            } else {
              return SizedBox();
            }
          },
        );
      }),
    );
  }
}
