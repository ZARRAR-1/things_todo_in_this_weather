import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    required this.controller,
  }) : super(key: key);
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextEditingController controller;

  final Color primaryColor = Colors.white;
  final Color primaryTextColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 3,
        child: TextField(
          enableSuggestions: true,
          controller: controller,
          style: buildSetTextStyle(),
          obscureText: obscureText,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: primaryTextColor,
          decoration: InputDecoration(
            filled: true,
            fillColor: primaryColor,
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 17),
            hintStyle: buildSetTextStyle(),
            prefixIcon: Icon(prefixIcon, color: Colors.black),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  dynamic buildSetTextStyle() =>
      TextStyle(color: primaryTextColor, fontSize: 15);
}
