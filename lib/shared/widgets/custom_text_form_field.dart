import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final void Function(String) onChanged; 
  final String hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.onChanged,  
    required this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    required this.inputFormatters,
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
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 15, color: Color(0xFF212121)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 15),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: const Color(0xFF9E9E9E), size: 22)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        inputFormatters: inputFormatters,
        validator: validator,
      ),
    );
  }
}
