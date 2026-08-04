import 'package:flutter/material.dart';

/// حقل إدخال رقمي موحّد الشكل، مع تحقق (validation) بسيط قابل للتخصيص.
class LabeledInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? suffixText;
  final bool allowNegative;
  final bool isPercentage;

  const LabeledInputField({
    super.key,
    required this.label,
    required this.controller,
    this.suffixText,
    this.allowNegative = false,
    this.isPercentage = false,
  });

  String? _validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'من فضلك أدخل قيمة';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'أدخل رقمًا صحيحًا';
    }
    if (!allowNegative && number < 0) {
      return 'القيمة لازم تكون أكبر من أو تساوي صفر';
    }
    if (isPercentage && (number < 0 || number > 100)) {
      return 'أدخل نسبة بين 0 و 100';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffixText,
        ),
        validator: _validate,
      ),
    );
  }
}
