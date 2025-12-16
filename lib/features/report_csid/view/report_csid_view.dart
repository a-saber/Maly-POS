import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/utils/extensions.dart';
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
import '../manager/cubit/rebort_csid_state.dart';
import '../manager/cubit/report_csid_cubit.dart';

class ReportScidView extends StatelessWidget {
  const ReportScidView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportScidCubit, ReportScidState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: S.of(context).reportZakatAndTax,

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
  final ReportScidState state;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: !isMobile(context: context)  ? 0.95 : 1.0,
      child: Form(
        key: ReportScidCubit.get(context).formKey,
        autovalidateMode: ReportScidCubit.get(context).autovalidateMode,
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min, // ✅ ADD THIS
          crossAxisAlignment: isMobile(context: context)?CrossAxisAlignment.start: CrossAxisAlignment.end,
          children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
               ElevatedButton(

                 onPressed: (){
                   Navigator.pop(context);
                 },
                 child: Text(S.of(context).sendToZakat),
               )
             ],
           ),
            Flex(
              direction: isMobile(context: context) ? Axis.vertical : Axis.horizontal,
              spacing: 20,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex:1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap:() {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),


                          ).then((onValue){
                            if(onValue!=null) ReportScidCubit.get(context).setFromDate(onValue);

                          });

                        },
                        child: CustomFormField(
                          controller: ReportScidCubit.get(context).fromDateController,
                          validator: (value) => MyFormValidators.validateRequired(
                            value,
                            context: context,
                            fieldName: S.of(context).from,
                          ),
                          enabled: false,
                          hintText: S.of(context).from,
                          labelText: S.of(context).from,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: AppColors.darkBlue,
                          ),

                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap:() {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),


                          ).then((onValue){
                            if(onValue!=null) ReportScidCubit.get(context).setToDate(onValue);

                          });
                          ;

                        },
                        child: CustomFormField(
                          controller: ReportScidCubit.get(context).toDateController,
                          enabled: false,
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: AppColors.darkBlue,
                          ),
                          validator: (value) => MyFormValidators.validateRequired(
                            value,
                            context: context,
                            fieldName: S.of(context).to,
                          ),
                          hintText: S.of(context).to,
                          labelText: S.of(context).to,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),

                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomDropdown<String>(
                        hint: S.of(context).userName,
                        value: ReportScidCubit.get(context).userName,
                        items: ReportScidCubit.get(context).userNames,
                        onChanged: (value) => ReportScidCubit.get(context).changePaperSize(value),
                        builder: (item) => Text(
                          item ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                        validator: (value) =>
                            MyFormValidators.validateRequired(value, context: context),
                      ),
                      SizedBox(height: 20),

                      Flex(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        direction: isMobile(context: context) ? Axis.vertical : Axis.horizontal,
                        spacing: 20,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CsidTypeWidget(
                            title: S.of(context).all,
                            isSelect: ReportScidCubit.get(context).csidType == CsidType.all,
                            onTap: () {
                              ReportScidCubit.get(context).changeCsidType(type: CsidType.all);
                            },
                          ),
                          CsidTypeWidget(
                            title: S.of(context).withInvoices,
                            isSelect: ReportScidCubit.get(context).csidType == CsidType.withInvoices,
                            onTap: () {
                              ReportScidCubit.get(context).changeCsidType(type: CsidType.withInvoices);
                            },
                          ),
                          CsidTypeWidget(
                            title: S.of(context).withoutInvoices,
                            isSelect: ReportScidCubit.get(context).csidType == CsidType.withoutInvoices,
                            onTap: () {
                              ReportScidCubit.get(context).changeCsidType(type: CsidType.withoutInvoices);
                            },
                          ),


                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),
          // ✅ FIXED: Remove Flexible wrapper and use LayoutBuilder
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height:( MediaQuery.sizeOf(context).height/1.8), // ✅ Fixed height for DataTable
                  width: constraints.maxWidth,
                  child: Builder(
                    builder: (context) {
                      final ScrollController controller = ScrollController();

                      return Scrollbar(
                        controller: controller,
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            dataRowHeight: 80,
                            border: TableBorder.all(color: Colors.grey,width: 2),
                            sortColumnIndex: 0,

                            columns:  [
                              DataColumn(label: Text(S.of(context).invoiceNumber,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,

                                  )
                              ),

                              ),
                              DataColumn(label: Text(S.of(context).invoiceDate,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,
                                  )
                              ),),
                              DataColumn(label: Text(S.of(context).invoiceXML,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,
                                  )
                              )),
                              DataColumn(label: Text(S.of(context).sendStatus,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,
                                  )
                              )),
                              DataColumn(label: Text(S.of(context).sendCode,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,
                                  )
                              )),
                              DataColumn(label: Text(S.of(context).sent,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,
                                  )
                              )),
                              DataColumn(label: Text(S.of(context).sendError,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,
                                  )
                              )),
                              DataColumn(label: Text(S.of(context).total,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,
                                  )
                              )),
                              DataColumn(label: Text(S.of(context).totalAfterTax,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,
                                  )
                              )),
                              DataColumn(label: Text(S.of(context).taxTotal,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,
                                  )
                              )),
                              DataColumn(label: Text(S.of(context).invoiceType,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,
                                  )
                              )),
                              DataColumn(label: Text(S.of(context).simplifiedInvoice,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,
                                  )
                              )),
                              DataColumn(label: Text(S.of(context).invoiceDate,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,
                                  )
                              )),
                              DataColumn(label: Text(S.of(context).userCode,
                                  style: AppFontStyle.itemsTitle(
                                    context: context,
                                    color: AppColors.darkBlue,
                                  )
                              )),
                            ],
                            rows: List.generate(
                              3,
                                  (index) {
                                return DataRow(
                                  cells: List.generate(
                                    14,
                                        (cellIndex) => DataCell(
                                      Center(
                                        child: SizedBox(
                                          width: 150,
                                          child: Text(
                                            "الوحدة",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppFontStyle.itemsTitle(
                                              context: context,
                                              color: AppColors.darkBlue,
                                            ),

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            Flex(
              crossAxisAlignment: CrossAxisAlignment.start,
              direction: isMobile(context: context) ? Axis.vertical : Axis.horizontal,
              spacing: 20,
              mainAxisSize: MainAxisSize.min, // Add this!
              children: [
                // Remove Flexible, just use the Text widgets directly
                Text(
                  "${S.of(context).sales} *",
                  style: AppFontStyle.itemsTitle(
                    context: context,
                    color: AppColors.darkBlue,
                  ),
                ),
                Text(
                  "${S.of(context).totalBeforeTax}: 1233232",
                  style: AppFontStyle.itemsTitle(
                    context: context,
                    color: AppColors.darkBlue,
                  ),
                ),
                Text(
                  "${S.of(context).totalaftertax}: 1233232",
                  style: AppFontStyle.itemsTitle(
                    context: context,
                    color: AppColors.darkBlue,
                  ),
                ),
                Text(
                  "${S.of(context).taxestotal}: 1233232",
                  style: AppFontStyle.itemsTitle(
                    context: context,
                    color: AppColors.darkBlue,
                  ),
                ),
                // Remove the empty SizedBox with flex: 3
              ],
            ),
            Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: isMobile(context: context) ? Axis.vertical : Axis.horizontal,
            spacing: 20,
            mainAxisSize: MainAxisSize.min, // Add this!
            children: [
              // Remove Flexible, just use the Text widgets directly
              Text(
                "${S.of(context).returnsTotal} *",
                style: AppFontStyle.itemsTitle(
                  context: context,
                  color: AppColors.darkBlue,
                ),
              ),
              Text(
                "${S.of(context).totalBeforeTax}: 1233232",
                style: AppFontStyle.itemsTitle(
                  context: context,
                  color: AppColors.darkBlue,
                ),
              ),
              Text(
                "${S.of(context).totalaftertax}: 1233232",
                style: AppFontStyle.itemsTitle(
                  context: context,
                  color: AppColors.darkBlue,
                ),
              ),
              Text(
                "${S.of(context).taxestotal}: 1233232",
                style: AppFontStyle.itemsTitle(
                  context: context,
                  color: AppColors.darkBlue,
                ),
              ),
              // Remove the empty SizedBox with flex: 3
            ],
          ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}