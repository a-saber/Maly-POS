import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/features/csid%20_generation/view/widgets/copy_item_widget.dart';
import 'package:pos_app/features/csid%20_generation/view/widgets/csid_type_widget.dart';

import '../../../core/helper/is_mobile.dart';
import '../../../core/helper/my_form_validators.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_font_style.dart';
import '../../../core/utils/app_padding.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../core/widget/custom_drop_down.dart';
import '../../../core/widget/custom_form_field.dart';
import '../../../core/widget/cutsom_layout_builder.dart';
import '../../../core/widget/my_custom_scroll_view.dart';
import '../../../generated/l10n.dart';
import '../manager/cubit/csid_generation_setting_cubit.dart';

class ScidGenerationView extends StatelessWidget {
  const ScidGenerationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScidGenerationCubit, ScidGenerationState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: S.of(context).ZakatAndTaxAuthority,
          ),
          body: SafeArea(
            child: CustomLayoutBuilder(
              mobile: Padding(
                padding: AppPaddings.defaultView,
                child: MyCustomScrollView(
                  child: CustomShopSettingBodyMobile(
                    state: state,
                  ),
                ),
              ),
              tablet: Padding(
             padding: AppPaddings.defaultView,
                child: MyCustomScrollView(
                  child: CustomShopSettingBodyMobile(
                    state: state,
                  ),
                ),
              ),
              desktop: Padding(
                padding: AppPaddings.defaultView,
                child: MyCustomScrollView(
                  child: CustomShopSettingBodyMobile(
                    state: state,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomShopSettingBodyMobile extends StatelessWidget {
  const CustomShopSettingBodyMobile({
    super.key,
    required this.state,
  });
  final ScidGenerationState state;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: ScidGenerationCubit.get(context).formKey,
      autovalidateMode: ScidGenerationCubit.get(context).autovalidateMode,
      child: Column(
        spacing: 20,
        children: [

          Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: isMobile(context: context) ? Axis.vertical : Axis.horizontal,
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            children: [

              Flexible(
                flex: 2,
               // fit: isMobile(context: context) ? FlexFit.loose : FlexFit.tight,
                child: CustomFormField(
                  controller: ScidGenerationCubit.get(context).otpController,
                  validator: (value) => MyFormValidators.validateRequired(
                    value,
                    context: context,
                    fieldName: S.of(context).otp,
                  ),
                  hintText: S.of(context).otp,
                  labelText: S.of(context).otp,
                  keyboardType: TextInputType.number,
                ),
              ),
              Flexible(
                flex: 1,

                //   fit: isMobile(context: context) ? FlexFit.loose : FlexFit.tight,
                child: CsidTypeWidget(title: S.of(context).production ,
                  isSelect: ScidGenerationCubit.get(context).csidType==CsidType.production,
                  onTap: (){
                    ScidGenerationCubit.get(context).changeCsidType(type: CsidType.production);
                  },

                ),
              ),
              Flexible(
                flex: 1,

                //   fit: isMobile(context: context) ? FlexFit.loose : FlexFit.tight,
                child: CsidTypeWidget(title: S.of(context).simulation ,
                  isSelect: ScidGenerationCubit.get(context).csidType==CsidType.simulation,
                  onTap: (){
                    ScidGenerationCubit.get(context).changeCsidType(type: CsidType.simulation);
                  },
                ),
              ),
              Flexible(
                flex: 1,

                //   fit: isMobile(context: context) ? FlexFit.loose : FlexFit.tight,
                child: CsidTypeWidget(title: S.of(context).developer ,
                  isSelect:ScidGenerationCubit.get(context).csidType==CsidType.development,
                    onTap: (){
                      ScidGenerationCubit.get(context).changeCsidType(type: CsidType.development);
                    },
                ),
              ),


            ],
          ),

          Flex(
            direction: isMobile(context: context) ? Axis.vertical : Axis.horizontal,
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 1,
                // fit: isMobile(context: context) ? FlexFit.loose : FlexFit.tight,
                child:  CustomFormField(
                  controller: ScidGenerationCubit.get(context).commonNameController,
                  hintText: S.of(context).commonName,
                  labelText: S.of(context).commonName,
                  validator: (value) => MyFormValidators.validateInteger(value,
                      context: context, validate: false),
                  keyboardType: TextInputType.text,
                ),
              ),
              Flexible(
                flex: 1,

                //   fit: isMobile(context: context) ? FlexFit.loose : FlexFit.tight,
                child: CustomDropdown<String>(
                  // hint: S.of(context).selectpapersize ,
                  hint: S.of(context).userName,
                  value:ScidGenerationCubit.get(context).userName,
                  items: ScidGenerationCubit.get(context).userNames,
                  onChanged: (value) => ScidGenerationCubit.get(context).changePaperSize(value),
                  builder: (item) => Text(
                    item ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  validator: (value) =>
                      MyFormValidators.validateRequired(value, context: context),
                ),
              ),
            ],
          ),
          Stack(
                  alignment: Alignment.centerRight,

                  children: [
                    CustomFormField(
                      controller: ScidGenerationCubit.get(context).serialNumberController,
                      hintText: S.of(context).serialNumber,
                      labelText: S.of(context).serialNumber,
                      enabled: false,

                      validator: (value) => MyFormValidators.validateInteger(value, context: context, validate: false),
                      keyboardType: TextInputType.number,
                    ),
                    PositionedDirectional(
                      end: 10,
                        child: IconButton(onPressed: () {
                          ScidGenerationCubit.get(context).onTapGenerate();
                        },icon: Icon(Icons.refresh)))
                  ],
                ),
          CustomFormField(
            controller: ScidGenerationCubit.get(context).taxNoController,
            hintText: S.of(context).taxNo,
            labelText: S.of(context).taxNo,
            validator: (value) => MyFormValidators.validateInteger(value,
                context: context, validate: false),
            keyboardType: TextInputType.text,
          ),
          CustomFormField(
            controller: ScidGenerationCubit.get(context).organizationNameController,
            hintText: S.of(context).organizationName,
            labelText: S.of(context).organizationName,
            validator: (value) => MyFormValidators.validateInteger(value,
                context: context, validate: false),
            keyboardType: TextInputType.text,
          ),
          CustomFormField(
            controller: ScidGenerationCubit.get(context).organizationUnitNameController,
            hintText: S.of(context).organizationUnitName,
            labelText: S.of(context).organizationUnitName,
            validator: (value) => MyFormValidators.validateInteger(value,
                context: context, validate: false),
            keyboardType: TextInputType.text,
          ),
          CustomFormField(
            controller: ScidGenerationCubit.get(context).countryNameController,
            hintText: S.of(context).countryName,
            labelText: S.of(context).countryName,
            validator: (value) => MyFormValidators.validateInteger(value,
                context: context, validate: false),
            keyboardType: TextInputType.text,
          ),
          CustomDropdown<String>(

            hint: S.of(context).invoiceType,
            value:ScidGenerationCubit.get(context).invoiceType,
            items: ScidGenerationCubit.get(context).invoiceTypes,
            onChanged: (value) => ScidGenerationCubit.get(context).changeInvoiceType(value),
            builder: (item) => Text(
              item ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            validator: (value) =>
                MyFormValidators.validateRequired(value, context: context),
          ),
          CustomFormField(
            controller: ScidGenerationCubit.get(context).locationController,
            hintText: S.of(context).location,
            labelText: S.of(context).location,
            validator: (value) => MyFormValidators.validateInteger(value,
                context: context, validate: false),
            keyboardType: TextInputType.text,
          ),
          CustomFormField(
            controller: ScidGenerationCubit.get(context).industryController,
            hintText: S.of(context).industry,
            labelText: S.of(context).industry,
            validator: (value) => MyFormValidators.validateInteger(value,
                context: context, validate: false),
            keyboardType: TextInputType.text,
          ),
          Container(
            width: 400,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.success,
              border:
              Border.all(color: AppColors.success, width: 1.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              S.of(context).createCsid,
              textAlign: TextAlign.center,
              style: AppFontStyle.itemsSubTitle(
                context: context,
                color: AppColors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          CopyItemWidget(
            hint:S.of(context).csr ,
          ) ,
          CopyItemWidget(
            hint:S.of(context).privateKey ,
          ) ,
          CopyItemWidget(
            hint:S.of(context).publicKey ,
          ) ,
          CopyItemWidget(
            hint:S.of(context).secretKey ,
          ) ,
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}