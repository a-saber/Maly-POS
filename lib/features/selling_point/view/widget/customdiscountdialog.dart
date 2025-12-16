import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/data/model/discount_type.dart';

class CustomDiscountDialog extends StatefulWidget {
  final DiscountModel? currentDiscount;
  
  const CustomDiscountDialog({
    super.key,
    this.currentDiscount,
  });

  @override
  State<CustomDiscountDialog> createState() => _CustomDiscountDialogState();
}

class _CustomDiscountDialogState extends State<CustomDiscountDialog> {
  final TextEditingController _discountController = TextEditingController();
  late DiscountType? _selectedType;

  @override
  void initState() {
    super.initState();
    // لو في خصم حالي، حمله في الـ dialog
    if (widget.currentDiscount != null && widget.currentDiscount!.id == -1) {
      _discountController.text = widget.currentDiscount!.value ?? '';
      _selectedType = widget.currentDiscount!.type;
    } else {
      _selectedType = DiscountType.fixed;
    }
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  void _onKeyPressed(String value) {
    final currentText = _discountController.text;

    if (value == 'C') {
      _discountController.text = '';
    } else if (value == '⌫') {
      if (currentText.isNotEmpty) {
        _discountController.text =
            currentText.substring(0, currentText.length - 1);
      }
    } else if (value == '.') {
      if (currentText.isEmpty) {
        _discountController.text = '0.';
      } else if (!currentText.contains('.')) {
        _discountController.text = currentText + '.';
      }
    } else if (value == '%') {
      setState(() {
        _selectedType = _selectedType == DiscountType.fixed
            ? DiscountType.percentage
            : DiscountType.fixed;
      });
    } else {
      if (currentText.isEmpty) {
        _discountController.text = value;
      } else {
        _discountController.text = currentText + value;
      }
    }

    setState(() {});
  }

  Widget _buildKey(String label, {bool isSpecial = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onKeyPressed(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSpecial
                ? AppColors.primary.withOpacity(0.1)
                : Colors.white,
            foregroundColor: isSpecial ? AppColors.primary : AppColors.black,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isSpecial ? AppColors.primary : Colors.grey.shade300,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: isSpecial ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _applyDiscount() {
    final value = _discountController.text.trim();
    if (value.isEmpty || double.tryParse(value) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى إدخال قيمة صحيحة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final discount = DiscountModel(
      id: -1,
      title: 'خصم مخصص',
      type: _selectedType,
      value: value,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    Navigator.of(context).pop(discount);
  }

  @override
  Widget build(BuildContext context) {
    bool hasCurrentDiscount = widget.currentDiscount != null && 
                              widget.currentDiscount!.id == -1;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'خصم مخصص',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    if (hasCurrentDiscount)
                      Text(
                        'تعديل الخصم الحالي',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close),
                  color: Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 20),

            // Discount Type Toggle
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedType = DiscountType.fixed;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedType == DiscountType.fixed
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'خصم ثابت',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _selectedType == DiscountType.fixed
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedType = DiscountType.percentage;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedType == DiscountType.percentage
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'نسبة مئوية',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _selectedType == DiscountType.percentage
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Input Field
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _discountController.text.isEmpty
                          ? '0'
                          : _discountController.text,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    _selectedType == DiscountType.percentage ? '%' : 'ريال',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Custom Keyboard
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      _buildKey('1'),
                      _buildKey('2'),
                      _buildKey('3'),
                    ],
                  ),
                  Row(
                    children: [
                      _buildKey('4'),
                      _buildKey('5'),
                      _buildKey('6'),
                    ],
                  ),
                  Row(
                    children: [
                      _buildKey('7'),
                      _buildKey('8'),
                      _buildKey('9'),
                    ],
                  ),
                  Row(
                    children: [
                      _buildKey('.', isSpecial: true),
                      _buildKey('0'),
                      _buildKey('⌫', isSpecial: true),
                    ],
                  ),
                  Row(
                    children: [
                      _buildKey('C', isSpecial: true),
                      _buildKey('%', isSpecial: true),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Buttons Row
            Row(
              spacing: 10,
              children: [
          
                if (hasCurrentDiscount)
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop('DELETE');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.red, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 4),
                          Text(
                            'حذف',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Apply Button
                Expanded(
                  flex: hasCurrentDiscount ? 2 : 1,
                  child: ElevatedButton(
                    onPressed: _applyDiscount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      hasCurrentDiscount ? 'تحديث الخصم' : 'تطبيق الخصم',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}