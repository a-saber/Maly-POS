import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_app/core/utils/app_colors.dart';

class CustomPaymentKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  final bool allowDecimal;
  final FocusNode? focusNode;
  final VoidCallback? onEnterPressed;

  const CustomPaymentKeyboard({
    super.key,
    required this.controller,
    required this.onChanged,
    this.allowDecimal = true,
    this.focusNode,
    this.onEnterPressed,
  });

  @override
  State<CustomPaymentKeyboard> createState() => _CustomPaymentKeyboardState();
}

class _CustomPaymentKeyboardState extends State<CustomPaymentKeyboard> {
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _internalFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _onKeyPressed(String value) {
    final currentText = widget.controller.text;
    
    debugPrint('🔑 Key pressed: $value, allowDecimal: ${widget.allowDecimal}');
    
    if (value == 'C') {
      widget.controller.text = '0';
    } else if (value == '⌫') {
      if (currentText.isNotEmpty && currentText != '0') {
        final newText = currentText.substring(0, currentText.length - 1);
        widget.controller.text = newText.isEmpty ? '0' : newText;
      }
    } else if (value == '.') {
      // ✅ لو مش مسموح بالأرقام العشرية، ارجع
      if (!widget.allowDecimal) {
        debugPrint('❌ Decimal not allowed');
        return;
      }
      
      // ✅ لو النص فاضي أو صفر، حط "0."
      if (currentText == '0' || currentText.isEmpty) {
        widget.controller.text = '0.';
        debugPrint('✅ Added: 0.');
      } 
      // ✅ لو مفيش نقطة قبل كده، ضيف النقطة
      else if (!currentText.contains('.')) {
        widget.controller.text = currentText + '.';
        debugPrint('✅ Added decimal point');
      } else {
        debugPrint('⚠️ Already has decimal point');
      }
    } else if (value == 'ENTER') {
      if (widget.onEnterPressed != null) {
        widget.onEnterPressed!();
      }
      return; 
    } else {
      // ✅ إضافة رقم عادي
      if (currentText == '0') {
        widget.controller.text = value;
      } else {
        widget.controller.text = currentText + value;
      }
    }
    
    widget.onChanged();
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
    debugPrint('🎨 Building keyboard with allowDecimal: ${widget.allowDecimal}');
    
    return Focus(
      focusNode: _internalFocusNode,
      autofocus: true,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyDownEvent) {
          final key = event.logicalKey;
          
          if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
            _onKeyPressed('ENTER');
            return KeyEventResult.handled;
          }
          else if (key == LogicalKeyboardKey.digit0 || key == LogicalKeyboardKey.numpad0) {
            _onKeyPressed('0');
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit1 || key == LogicalKeyboardKey.numpad1) {
            _onKeyPressed('1');
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit2 || key == LogicalKeyboardKey.numpad2) {
            _onKeyPressed('2');
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit3 || key == LogicalKeyboardKey.numpad3) {
            _onKeyPressed('3');
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit4 || key == LogicalKeyboardKey.numpad4) {
            _onKeyPressed('4');
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit5 || key == LogicalKeyboardKey.numpad5) {
            _onKeyPressed('5');
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit6 || key == LogicalKeyboardKey.numpad6) {
            _onKeyPressed('6');
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit7 || key == LogicalKeyboardKey.numpad7) {
            _onKeyPressed('7');
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit8 || key == LogicalKeyboardKey.numpad8) {
            _onKeyPressed('8');
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit9 || key == LogicalKeyboardKey.numpad9) {
            _onKeyPressed('9');
            return KeyEventResult.handled;
          }
          // ✅ لو مسموح بالأرقام العشرية، اسمح بالنقطة
          else if (key == LogicalKeyboardKey.period || key == LogicalKeyboardKey.numpadDecimal) {
            if (widget.allowDecimal) {
              _onKeyPressed('.');
              return KeyEventResult.handled;
            }
          }
          else if (key == LogicalKeyboardKey.backspace) {
            _onKeyPressed('⌫');
            return KeyEventResult.handled;
          }
          else if (key == LogicalKeyboardKey.delete || key == LogicalKeyboardKey.escape) {
            _onKeyPressed('C');
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: () => _internalFocusNode.requestFocus(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
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
                  // ✅ هنا النقطة - تظهر فقط لو allowDecimal = true
                  widget.allowDecimal
                      ? _buildKey('.', isSpecial: true)
                      : _buildKey('00'), // ✅ أو حط زرار تاني بدلها
                  _buildKey('0'),
                  _buildKey('⌫', isSpecial: true),
                ],
              ),
              Row(
                children: [
                  _buildKey('C', isSpecial: true),
                  if (widget.onEnterPressed != null)
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ElevatedButton(
                          onPressed: () => _onKeyPressed('ENTER'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: AppColors.primary,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, size: 20),
                              SizedBox(width: 4),
                              Text(
                                'تطبيق',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}