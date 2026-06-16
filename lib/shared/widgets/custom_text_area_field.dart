import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/constants/app_colors.dart';

class CustomTextAreaField extends StatelessWidget {
  final String? initialValue;
  final int maxLines;
  final int? maxLength;
  final Function(String) onChanged;
  final String hintText;
  final String? Function(String?)? validator;

  const CustomTextAreaField({
    super.key,
    this.initialValue,
    this.maxLines = 5,
    this.maxLength,
    required this.onChanged,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        maxLines: maxLines,
        maxLength: maxLength,
        style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.hintText,
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          counterText: '', // hide default counter
        ),
        validator: validator,
      ),
    );
  }
}