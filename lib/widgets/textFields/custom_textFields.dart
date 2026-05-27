import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isMultiline;
  final FocusNode? focusNode;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isMultiline = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: isMultiline ? 5 : 1,
      maxLines: isMultiline ? 10 : 1,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: .circular(20)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        )
      ),
    );
  }
}
