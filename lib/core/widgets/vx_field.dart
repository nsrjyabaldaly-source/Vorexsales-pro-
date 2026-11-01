import 'package:flutter/material.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';

class VxField extends StatelessWidget {
  const VxField({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: VxColors.mist400),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class VxTextField extends StatelessWidget {
  const VxTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.onChanged,
    this.maxLines = 1,
    this.height = 44,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final double height;

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLines: obscure ? 1 : maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      cursorColor: VxColors.cyan,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        filled: true,
        fillColor: VxColors.white05,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: maxLines > 1 ? 12 : 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VxRadii.input),
          borderSide: const BorderSide(color: VxColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VxRadii.input),
          borderSide: const BorderSide(color: VxColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VxRadii.input),
          borderSide: BorderSide(color: VxColors.cyan.withValues(alpha: 0.5)),
        ),
      ),
    );
    if (maxLines > 1) return field;
    return SizedBox(height: height, child: field);
  }
}
