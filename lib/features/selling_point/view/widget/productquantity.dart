import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/features/selling_point/view/widget/customkeyboard.dart';

class ProductQuantityDialog extends StatefulWidget {
  final int currentQuantity;
  final Function(int) onQuantityChanged;

  const ProductQuantityDialog({
    super.key,
    required this.currentQuantity,
    required this.onQuantityChanged,
  });

  @override
  State<ProductQuantityDialog> createState() => _ProductQuantityDialogState();
}

class _ProductQuantityDialogState extends State<ProductQuantityDialog> {
  late TextEditingController _controller;
  bool _isFirstInput = true;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyQuantity() {
    final quantity = int.tryParse(_controller.text) ?? widget.currentQuantity;
    if (quantity <= 0) {
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
      }
     
      else if (text.isNotEmpty && text != '0') {
        _isFirstInput = false;
      }
      
      else if (text.isEmpty) {
        _isFirstInput = true;
        _controller.text = '0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تحديد الكمية',
                  style: TextStyle(
                    fontSize: 24,
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
            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Text(
                _controller.text.isEmpty ? '0' : _controller.text,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),

            CustomPaymentKeyboard(
              controller: _controller,
              allowDecimal: false,
              onChanged: _handleInput, 
              onEnterPressed: _applyQuantity,
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _applyQuantity,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تطبيق',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}