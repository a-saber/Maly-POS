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
      controller.text = '0.00';
    } else if (value == '⌫') {
      // Backspace
      if (currentText.isNotEmpty && currentText != '0.00') {
        String numOnly = currentText.replaceAll('.', '');
        
        if (numOnly.length > 1) {
          numOnly = numOnly.substring(0, numOnly.length - 1);
        } else {
          controller.text = '0.00';
          onChanged();
          return;
        }
        
        // Format with decimal
        if (numOnly == '0') {
          controller.text = '0.00';
        } else if (numOnly.length == 1) {
          controller.text = '0.0$numOnly';
        } else if (numOnly.length == 2) {
          controller.text = '0.$numOnly';
        } else {
          int decimalPos = numOnly.length - 2;
          controller.text = '${numOnly.substring(0, decimalPos)}.${numOnly.substring(decimalPos)}';
        }
      }
    }  else {
  // Number pressed
  String numOnly = currentText.replaceAll('.', '');


  numOnly = numOnly.replaceFirst(RegExp(r'^0+'), '');


  numOnly = numOnly.isEmpty ? value : numOnly + value;

  // Format with decimal
  if (numOnly.length == 1) {
    controller.text = '0.0$numOnly';
  } else if (numOnly.length == 2) {
    controller.text = '0.$numOnly';
  } else {
    int decimalPos = numOnly.length - 2;
    controller.text =
        '${numOnly.substring(0, decimalPos)}.${numOnly.substring(decimalPos)}';
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
              _buildKey('C', isSpecial: true),
              _buildKey('0'),
              _buildKey('⌫', isSpecial: true),
            ],
          ),
        ],
      ),
    );
  }
}