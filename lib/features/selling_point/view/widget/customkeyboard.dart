import 'package:flutter/material.dart';
import 'package:pos_app/core/utils/app_colors.dart';

class CustomPaymentKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const CustomPaymentKeyboard({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  void _onKeyPressed(String value) {
    final currentText = controller.text;
    
    if (value == 'C') {
      // Clear
      controller.text = '';
    } else if (value == '⌫') {
      // Backspace
      if (currentText.isNotEmpty) {
        controller.text = currentText.substring(0, currentText.length - 1);
      }
    } else if (value == '.') {

      if (currentText.isEmpty) {
        controller.text = '0.';
      } 
      else if (!currentText.contains('.')) {
        controller.text = currentText + '.';
      }
    } else {
    
      if (currentText.isEmpty) {
        controller.text = value;
      } else {
        controller.text = currentText + value;
      }
    }
    
    onChanged();
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
            foregroundColor: isSpecial 
                ? AppColors.primary 
                : AppColors.black,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isSpecial 
                    ? AppColors.primary 
                    : Colors.grey.shade300,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
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
            ],
          ),
        ],
      ),
    );
  }
}