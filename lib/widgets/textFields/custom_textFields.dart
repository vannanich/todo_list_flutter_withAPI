import 'package:flutter/material.dart';

class custom_textfield extends StatelessWidget {
  final String hintText;
  final IconData prefix;
  final TextEditingController controller;
  final IconData? suffix;

  const custom_textfield({
    super.key,
    required this.hintText,
    required this.prefix,
    required this.controller,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefix),
        suffix: Icon(suffix),
        border: OutlineInputBorder(borderRadius: .circular(20)),
      ),
    );
  }
}
