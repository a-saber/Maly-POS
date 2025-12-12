import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/utils/app_padding.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/core/widget/custom_btn.dart';
import 'package:pos_app/core/widget/custom_form_field.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/core/widget/custom_pop_up.dart';
import 'package:pos_app/core/widget/cutsom_layout_builder.dart';
import 'package:pos_app/core/widget/custom_refresh_indicator.dart';
import 'package:pos_app/features/paymentmethods/data/models/paymentmethodmodel.dart';
import 'package:pos_app/features/paymentmethods/data/repo/repo.dart';
import 'package:pos_app/features/paymentmethods/manager/cubit/paymentscubit.dart';
import 'package:pos_app/features/paymentmethods/manager/state/paymentsstate.dart';

class PaymentMethodsViews extends StatelessWidget {
  const PaymentMethodsViews({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentMethodsCubit(
        MyServiceLocator.getSingleton<PaymentMethodsRepo>(),
      )..getPaymentMethods(isFresh: true),
      child: Scaffold(
        appBar: CustomAppBar(title: 'طرق الدفع'),
        body: BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
          listener: (context, state) {
            if (state is AddPaymentMethodSuccess) {
              CustomPopUp.callMyToast(
                context: context,
                massage: 'تم إضافة طريقة الدفع بنجاح',
                state: PopUpState.SUCCESS,
              );
            } else if (state is UpdatePaymentMethodSuccess) {
              CustomPopUp.callMyToast(
                context: context,
                massage: 'تم تحديث طريقة الدفع بنجاح',
                state: PopUpState.SUCCESS,
              );
            } else if (state is DeletePaymentMethodSuccess) {
              CustomPopUp.callMyToast(
                context: context,
                massage: 'تم حذف طريقة الدفع بنجاح',
                state: PopUpState.SUCCESS,
              );
            } else if (state is PaymentMethodsFailure) {
              CustomPopUp.callMyToast(
                context: context,
                massage: state.errMessage,
                state: PopUpState.ERROR,
              );
            }
          },
          builder: (context, state) {
            return CustomLayoutBuilder(
              mobile: PaymentMethodsDataView(state: state),
              tablet: PaymentMethodsDataView(state: state),
              desktop: PaymentMethodsDataView(state: state),
            );
          },
        ),
      ),
    );
  }
}

class PaymentMethodsDataView extends StatefulWidget {
  final PaymentMethodsState state;
  const PaymentMethodsDataView({super.key, required this.state});

  @override
  State<PaymentMethodsDataView> createState() => _PaymentMethodsDataViewState();
}

class _PaymentMethodsDataViewState extends State<PaymentMethodsDataView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _isActive = true;
  bool _requiresReference = false;
  PaymentMethodsModel? _editingPaymentMethod;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !PaymentMethodsCubit.get(context).isLoadingMore) {
      PaymentMethodsCubit.get(context).getPaymentMethods();
    }
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _isActive = true;
      _requiresReference = false;
      _editingPaymentMethod = null;
      _showForm = false;
    });
  }

  void _editPaymentMethod(PaymentMethodsModel paymentMethod) {
    setState(() {
      _editingPaymentMethod = paymentMethod;
      _nameController.text = paymentMethod.name ?? '';
      _isActive = paymentMethod.isActive == 1;
      _requiresReference = paymentMethod.requiresReference == 1;
      _showForm = true;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final cubit = PaymentMethodsCubit.get(context);
      
      if (_editingPaymentMethod == null) {
        cubit.addPaymentMethod(
          name: _nameController.text,
          isActive: _isActive ? 1 : 0,
          requiresReference: _requiresReference ? 1 : 0,
        );
      } else {
        final updatedPaymentMethod = PaymentMethodsModel(
          id: _editingPaymentMethod!.id,
          name: _nameController.text,
          isActive: _isActive ? 1 : 0,
          requiresReference: _requiresReference ? 1 : 0,
          createdAt: _editingPaymentMethod!.createdAt,
          updatedAt: DateTime.now().toString(),
        );
        cubit.updatePaymentMethod(paymentMethod: updatedPaymentMethod);
      }
      
      _resetForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
      builder: (context, state) {
        final cubit = PaymentMethodsCubit.get(context);

        if (state is PaymentMethodsLoading && cubit.paymentMethods.isEmpty) {
          return const Center(child: CustomLoading());
        }

        return CustomRefreshIndicator(
          onRefresh: () async => cubit.getPaymentMethods(isFresh: true),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: AppPaddings.defaultView,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // زر إظهار/إخفاء الفورم
                  CustomFilledBtn(
                    text: _showForm
                        ? 'إخفاء النموذج'
                        : 'إضافة طريقة دفع جديدة',
                    onPressed: () {
                      setState(() {
                        if (_showForm) {
                          _resetForm();
                        } else {
                          _showForm = true;
                        }
                      });
                    },
                  ),
                  
                  // الفورم
                  if (_showForm) ...[
                    const SizedBox(height: 20),
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                _editingPaymentMethod == null
                                    ? 'إضافة طريقة دفع جديدة'
                                    : 'تعديل طريقة الدفع',
                                style: AppFontStyle.formText(context: context).copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              CustomFormField(
                                controller: _nameController,
                                labelText: 'اسم طريقة الدفع',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'هذا الحقل مطلوب';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 15),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'الحالة',
                                    style: AppFontStyle.formText(context: context),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _isActive ? 'نشط' : 'غير نشط',
                                        style: TextStyle(
                                          color: _isActive ? Colors.green : Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Switch(
                                        value: _isActive,
                                        activeColor: AppColors.primary,
                                        onChanged: (value) {
                                          setState(() {
                                            _isActive = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'يتطلب مرجع',
                                    style: AppFontStyle.formText(context: context),
                                  ),
                                  Switch(
                                    value: _requiresReference,
                                    activeColor: AppColors.primary,
                                    onChanged: (value) {
                                      setState(() {
                                        _requiresReference = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomFilledBtn(
                                      text: _editingPaymentMethod == null
                                          ? 'إضافة'
                                          : 'تحديث',
                                      onPressed: _submitForm,
                                    ),
                                  ),
                                  if (_editingPaymentMethod != null) ...[
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomTextBtn(
                                        text: 'إلغاء',
                                        textColor: Colors.grey.shade700,
                                        onPressed: _resetForm,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 20),
                  
                  // القائمة
                  if (cubit.paymentMethods.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'لا توجد طرق دفع. اضغط على "إضافة طريقة دفع جديدة" لإضافة طريقة جديدة',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cubit.paymentMethods.length +
                          (state is PaymentMethodsLoadingMore ? 1 : 0),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        if (index == cubit.paymentMethods.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CustomLoading(),
                            ),
                          );
                        }

                        final paymentMethod = cubit.paymentMethods[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.payment,
                                color: AppColors.primary,
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    paymentMethod.name!,
                                    style:
                                        AppFontStyle.formText(context: context)
                                            .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: paymentMethod.isActive == 1
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    paymentMethod.isActive == 1
                                        ? 'نشط'
                                        : 'غير نشط',
                                    style: TextStyle(
                                      color: paymentMethod.isActive == 1
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: paymentMethod.requiresReference == 1
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          size: 14,
                                          color: Colors.orange,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'يتطلب مرجع',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: AppColors.primary,
                                  onPressed: () {
                                    _editPaymentMethod(paymentMethod);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    _showDeleteConfirmation(
                                      context,
                                      cubit,
                                      paymentMethod,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    PaymentMethodsCubit cubit,
    PaymentMethodsModel paymentMethod,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'تأكيد الحذف',
          style: AppFontStyle.formText(context: context).copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text(
          'هل أنت متأكد من حذف طريقة الدفع "${paymentMethod.name}"؟',
          style: AppFontStyle.formText(context: context),
        ),
        actions: [
          CustomTextBtn(
            text: 'إلغاء',
            textColor: Colors.grey.shade700,
            onPressed: () => Navigator.pop(ctx),
          ),
          const SizedBox(width: 10),
          CustomTextBtn(
            text: 'حذف',
            textColor: Colors.red,
            onPressed: () {
              cubit.deletePaymentMethod(paymentMethod.id!);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}