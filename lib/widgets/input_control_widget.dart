import 'package:flutter/material.dart';
import 'package:messenger/theme/colors_theme.dart';

class InputControlWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color borderColor;
  final Function()? onTap;
  final String? Function(String?)? validator;

  const InputControlWidget(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.onTap,
      this.validator,
      this.borderColor = ColorsTheme.greyLight});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: Theme.of(context).iconTheme.color,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: ColorsTheme.greyLight, fontSize: 16, fontWeight: FontWeight.normal),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.0),
        ),
      ),
      validator: validator,
    );
  }
}
