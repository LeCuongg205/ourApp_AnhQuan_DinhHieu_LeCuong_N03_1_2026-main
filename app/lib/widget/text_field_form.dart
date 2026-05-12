import 'package:flutter/material.dart';

// Reusable search field widget that calls onChanged as user types.
///Parent can handle debounce/filtering via a controller.
class TextFieldForm extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final IconData? prefixIcon;
  final bool autofocus;

  const TextFieldForm({
    Key? key,
    required this.controller,
    this.onChanged,
    this.hintText = 'Tìm kiếm...',
    this.prefixIcon = Icons.search,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
