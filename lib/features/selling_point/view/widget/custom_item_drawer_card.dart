import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_cach_network_image.dart';
import 'package:pos_app/features/selling_point/data/model/product_selling_model.dart';
import 'package:pos_app/features/selling_point/view/widget/customkeyboard.dart';
import 'package:pos_app/generated/l10n.dart';

import '../../../../core/helper/my_form_validators.dart';
import '../../../../core/widget/custom_form_field.dart';

class CustomItemDrawerCard extends StatefulWidget {
  const CustomItemDrawerCard({
    super.key,
    this.onTapAdd,
    this.onTapRemove,
    this.onTapDelete,
    required this.product,
    this.onChangePrice,
    this.onToggleShowEditPrice,
    this.onTapQuantity,
    this.onChangeQuantity,
    this.onChangeTotal,
  });
  final ProductSellingModel product;
  final void Function()? onTapAdd;
  final void Function()? onTapRemove;
  final void Function()? onTapDelete;
  final VoidCallback? onChangePrice;
  final VoidCallback? onToggleShowEditPrice;
  final VoidCallback? onTapQuantity;
  final VoidCallback? onChangeQuantity;
  final VoidCallback? onChangeTotal;

  @override
  State<CustomItemDrawerCard> createState() => _CustomItemDrawerCardState();
}

class _CustomItemDrawerCardState extends State<CustomItemDrawerCard> {
  Timer? _debounce;

  late TextEditingController quantityController;
  late TextEditingController unitPriceWithTaxController;
  late TextEditingController totalController;
  TextEditingController? displayPriceController;

  double actualUnitPriceWithTax = 0.0;
  double actualTotal = 0.0;

  @override
  void initState() {
    super.initState();

    double priceWithoutTax =
        double.tryParse(widget.product.priceController.text) ?? 0.0;

    if (_productHasTax()) {
      actualUnitPriceWithTax = priceWithoutTax * 1.15;
    } else {
      actualUnitPriceWithTax = priceWithoutTax;
    }

    actualTotal = actualUnitPriceWithTax * widget.product.count;

    quantityController = TextEditingController(
      text: widget.product.count.toString(),
    );

    unitPriceWithTaxController = TextEditingController(
      text: actualUnitPriceWithTax.toStringAsFixed(2),
    );

    totalController = TextEditingController(
      text: actualTotal.toStringAsFixed(2),
    );

    displayPriceController = TextEditingController(
      text: priceWithoutTax.toStringAsFixed(2),
    );
  }

  @override
  void didUpdateWidget(CustomItemDrawerCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.product.count != widget.product.count) {
      quantityController.text = widget.product.count.toString();

      double priceWithoutTax =
          double.tryParse(widget.product.priceController.text) ?? 0.0;

      if (_productHasTax()) {
        actualUnitPriceWithTax = priceWithoutTax * 1.15;
      } else {
        actualUnitPriceWithTax = priceWithoutTax;
      }

      actualTotal = actualUnitPriceWithTax * widget.product.count;
      totalController.text = actualTotal.toStringAsFixed(2);
      unitPriceWithTaxController.text =
          actualUnitPriceWithTax.toStringAsFixed(2);
    }

    if (oldWidget.product.priceController.text !=
        widget.product.priceController.text) {
      double priceWithoutTax =
          double.tryParse(widget.product.priceController.text) ?? 0.0;

      displayPriceController?.text = priceWithoutTax.toStringAsFixed(2);

      if (_productHasTax()) {
        actualUnitPriceWithTax = priceWithoutTax * 1.15;
      } else {
        actualUnitPriceWithTax = priceWithoutTax;
      }

      unitPriceWithTaxController.text =
          actualUnitPriceWithTax.toStringAsFixed(2);

      actualTotal = actualUnitPriceWithTax * widget.product.count;
      totalController.text = actualTotal.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    quantityController.dispose();
    unitPriceWithTaxController.dispose();
    totalController.dispose();
    displayPriceController?.dispose();
    super.dispose();
  }

  bool _productHasTax() {
    return widget.product.product.tax != null;
  }

  void _showKeyboardDialog({
    required TextEditingController controller,
    required String title,
    required bool allowDecimal,
    required Function() onUpdate,
  }) {
    // نبدأ بقيمة فاضية عشان المستخدم يكتب من الأول
    final tempController = TextEditingController(text: '');
    bool isFirstInput = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
              minWidth: 280,
            ),
            child: IntrinsicWidth(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    // نعرض القيمة الحالية للمستخدم
                    Text(
                      'القيمة الحالية: ${controller.text}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16),
                    CustomFormField(
                      controller: tempController,
                      keyboardType: TextInputType.none,
                    ),
                    SizedBox(height: 16),
                    CustomPaymentKeyboard(
                      controller: tempController,
                      onChanged: () {
                        setDialogState(() {
                          // نشيل الصفر الأول لما يبدأ الكتابة
                          if (isFirstInput &&
                              tempController.text.startsWith('0') &&
                              tempController.text.length > 1) {
                            tempController.text =
                                tempController.text.substring(1);
                            tempController.selection =
                                TextSelection.fromPosition(
                              TextPosition(offset: tempController.text.length),
                            );
                          }
                          if (tempController.text.isNotEmpty &&
                              tempController.text != '0') {
                            isFirstInput = false;
                          }
                        });
                      },
                      allowDecimal: allowDecimal,
                      onEnterPressed: () {
                        // نتأكد إن القيمة مش فاضية وصحيحة
                        String value = tempController.text.trim();
                        if (value.isEmpty || value == '0') {
                          // لو فاضي أو صفر، نقفل من غير تغيير
                          Navigator.pop(context);
                          return;
                        }

                        // للكمية: نتأكد إنها رقم صحيح
                        if (!allowDecimal) {
                          int? intValue = int.tryParse(value);
                          if (intValue != null && intValue > 0) {
                            controller.text = value;
                            Navigator.pop(context);
                            onUpdate();
                          } else {
                            // قيمة غير صحيحة للكمية
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('يجب إدخال كمية صحيحة أكبر من صفر'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          // للسعر: نتأكد إنه رقم
                          double? doubleValue = double.tryParse(value);
                          if (doubleValue != null && doubleValue > 0) {
                            controller.text = value;
                            Navigator.pop(context);
                            onUpdate();
                          } else {
                            // قيمة غير صحيحة للسعر
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('يجب إدخال قيمة صحيحة أكبر من صفر'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    ).then((_) {
      // لو قفل الـ dialog من غير ما يدوس Enter
      tempController.dispose();
    });
  }

  void _updateFromUnitPriceWithTax() {
    double inputPriceWithTax =
        double.tryParse(unitPriceWithTaxController.text) ?? 0.0;
    int quantity = int.tryParse(quantityController.text) ?? 1;

    actualUnitPriceWithTax = inputPriceWithTax;

    double priceWithoutTax;
    if (_productHasTax()) {
      priceWithoutTax = actualUnitPriceWithTax / 1.15;
    } else {
      priceWithoutTax = actualUnitPriceWithTax;
    }

    widget.product.priceController.text = priceWithoutTax.toStringAsFixed(10);
    displayPriceController?.text = priceWithoutTax.toStringAsFixed(2);

    actualTotal = actualUnitPriceWithTax * quantity;
    totalController.text = actualTotal.toStringAsFixed(2);

    setState(() {});

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 600), () {
      widget.onChangePrice?.call();
    });
  }

  void _updateFromTotal() {
    double inputTotal = double.tryParse(totalController.text) ?? 0.0;
    int quantity = int.tryParse(quantityController.text) ?? 1;

    if (quantity > 0) {
      actualTotal = inputTotal;

      actualUnitPriceWithTax = actualTotal / quantity;
      unitPriceWithTaxController.text =
          actualUnitPriceWithTax.toStringAsFixed(2);

      double priceWithoutTax;
      if (_productHasTax()) {
        priceWithoutTax = actualUnitPriceWithTax / 1.15;
      } else {
        priceWithoutTax = actualUnitPriceWithTax;
      }

      widget.product.priceController.text = priceWithoutTax.toStringAsFixed(10);
      displayPriceController?.text = priceWithoutTax.toStringAsFixed(2);

      if (_debounce?.isActive ?? false) {
        _debounce!.cancel();
      }

      _debounce = Timer(const Duration(milliseconds: 600), () {
        setState(() {});
        widget.onChangeTotal?.call();
      });
    }
  }

  void _updateFromQuantity() {
    int? quantity = int.tryParse(quantityController.text);

    if (quantity == null || quantity <= 0) {
      quantityController.text = widget.product.count.toString();
      return;
    }
    widget.product.count = quantity;

    double priceWithoutTax =
        double.tryParse(widget.product.priceController.text) ?? 0.0;

    actualUnitPriceWithTax =
        _productHasTax() ? priceWithoutTax * 1.15 : priceWithoutTax;

    actualTotal = actualUnitPriceWithTax * quantity;

    totalController.text = actualTotal.toStringAsFixed(2);
    unitPriceWithTaxController.text = actualUnitPriceWithTax.toStringAsFixed(2);

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () {
      widget.onChangeQuantity?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (quantityController.text != widget.product.count.toString()) {
      quantityController.text = widget.product.count.toString();

      double priceWithoutTax =
          double.tryParse(widget.product.priceController.text) ?? 0.0;

      if (_productHasTax()) {
        actualUnitPriceWithTax = priceWithoutTax * 1.15;
      } else {
        actualUnitPriceWithTax = priceWithoutTax;
      }

      actualTotal = actualUnitPriceWithTax * widget.product.count;
      totalController.text = actualTotal.toStringAsFixed(2);
      unitPriceWithTaxController.text =
          actualUnitPriceWithTax.toStringAsFixed(2);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomCachedNetworkImage(
                      imageUrl: widget.product.product.imageUrl,
                      borderRadius: BorderRadius.circular(15),
                      imageBuilder: (imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.product.name ?? S.of(context).noName,
                            style: AppFontStyle.itemsSubTitle(
                              context: context,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          if (widget.product.productUnit?.unit?.name != null)
                            Text(
                              widget.product.productUnit!.unit!.name!,
                              style: AppFontStyle.itemsSubTitle(
                                context: context,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // استبدل الـ Row الخاص بالكمية بالكود ده:

                // استبدل الـ Row الخاص بالكمية بالكود ده:

                Row(
                  children: [
                    Text(
                      'الكمية:',
                      style: AppFontStyle.itemsSubTitle(
                        context: context,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      
                      ),
                    ),
                    SizedBox(
                      width: 43, 
                      child: GestureDetector(
                        onTap: () {
                          _showKeyboardDialog(
                              controller: quantityController,
                              title: 'الكمية',
                              allowDecimal: false,
                              onUpdate: _updateFromQuantity);
                        },
                        child: AbsorbPointer(
                          child: CustomFormField(
                            controller: quantityController,
                            keyboardType: TextInputType.none,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'مطلوب';
                              }
                              final qty = int.tryParse(value);
                              if (qty == null || qty <= 0) {
                                return 'رقم غير صحيح';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8), // مسافة بين الـ field والأزرار
                    InkWell(
                      onTap: widget.onTapAdd,
                      child: Container(
                        padding: EdgeInsets.all(5), // قللنا من 6 لـ 5
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15, // قللنا من 16 لـ 15
                        ),
                      ),
                    ),
                    SizedBox(width: 3), // قللنا من 4 لـ 3
                    InkWell(
                      onTap: widget.onTapRemove,
                      child: Container(
                        padding: EdgeInsets.all(5), // قللنا من 6 لـ 5
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 15, // قللنا من 16 لـ 15
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          SizedBox(width: 16),

          // القسم الأيمن - الأسعار والحذف
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // صف الأسعار
                Row(
                  children: [
                    // السعر بدون ضريبة
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            _showKeyboardDialog(
                              controller: displayPriceController ??
                                  widget.product.priceController,
                              title: 'السعر',
                              allowDecimal: true,
                              onUpdate: () {
                                double? newPrice = double.tryParse(
                                    displayPriceController?.text ??
                                        widget.product.priceController.text);
                                if (newPrice != null) {
                                  widget.product.priceController.text =
                                      newPrice.toStringAsFixed(10);
                                  displayPriceController?.text =
                                      newPrice.toStringAsFixed(2);

                                  if (_productHasTax()) {
                                    actualUnitPriceWithTax = newPrice * 1.15;
                                  } else {
                                    actualUnitPriceWithTax = newPrice;
                                  }
                                  unitPriceWithTaxController.text =
                                      actualUnitPriceWithTax.toStringAsFixed(2);

                                  actualTotal = actualUnitPriceWithTax *
                                      widget.product.count;
                                  totalController.text =
                                      actualTotal.toStringAsFixed(2);

                                  setState(() {});

                                  if (_debounce?.isActive ?? false) {
                                    _debounce!.cancel();
                                  }

                                  _debounce = Timer(
                                      const Duration(milliseconds: 600), () {
                                    widget.onChangePrice?.call();
                                  });
                                }
                              },
                            );
                          },
                          child: AbsorbPointer(
                            child: Form(
                              key: widget.product.formKey,
                              child: CustomFormField(
                                controller: displayPriceController ??
                                    widget.product.priceController,
                                keyboardType: TextInputType.none,
                                validator: (value) =>
                                    MyFormValidators.validateDoublePrice(
                                  value,
                                  context: context,
                                  haveMin: true,
                                  min: widget.product.minPrice,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            _showKeyboardDialog(
                              controller: unitPriceWithTaxController,
                              title: 'السعر بالضريبة',
                              allowDecimal: true,
                              onUpdate: _updateFromUnitPriceWithTax,
                            );
                          },
                          child: AbsorbPointer(
                            child: CustomFormField(
                              controller: unitPriceWithTaxController,
                              keyboardType: TextInputType.none,
                              validator: (value) =>
                                  MyFormValidators.validateDoublePrice(
                                value,
                                context: context,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            _showKeyboardDialog(
                              controller: totalController,
                              title: 'الإجمالي',
                              allowDecimal: true,
                              onUpdate: _updateFromTotal,
                            );
                          },
                          child: AbsorbPointer(
                            child: CustomFormField(
                              controller: totalController,
                              keyboardType: TextInputType.none,
                              validator: (value) =>
                                  MyFormValidators.validateDoublePrice(
                                value,
                                context: context,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 19),

                Row(
                  children: [
                    Spacer(flex: 2),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: widget.onTapDelete,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.error,
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget منفصل للـ Quantity Dialog
class _QuantityDialogContent extends StatefulWidget {
  final int currentQuantity;
  final Function(int) onQuantityChanged;

  const _QuantityDialogContent({
    required this.currentQuantity,
    required this.onQuantityChanged,
  });

  @override
  State<_QuantityDialogContent> createState() => _QuantityDialogContentState();
}

class _QuantityDialogContentState extends State<_QuantityDialogContent> {
  late TextEditingController _controller;
  bool _isFirstInput = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyQuantity() {
    final text = _controller.text.trim();
    if (text.isEmpty || text == '0') {
      Navigator.of(context).pop();
      return;
    }

    final quantity = int.tryParse(text);
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الكمية يجب أن تكون أكبر من صفر'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onQuantityChanged(quantity);
    Navigator.of(context).pop();
  }

  void _handleInput() {
    setState(() {
      String text = _controller.text;

      if (_isFirstInput && text.startsWith('0') && text.length > 1) {
        _controller.text = text.substring(1);
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        _isFirstInput = false;
      } else if (text.isNotEmpty && text != '0') {
        _isFirstInput = false;
      } else if (text.isEmpty) {
        _isFirstInput = true;
        _controller.text = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الكمية',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close),
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'القيمة الحالية: ${widget.currentQuantity}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Text(
              _controller.text.isEmpty ? '' : _controller.text,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          CustomPaymentKeyboard(
            controller: _controller,
            allowDecimal: false,
            onChanged: _handleInput,
            onEnterPressed: _applyQuantity,
          ),
        ],
      ),
    );
  }
}
