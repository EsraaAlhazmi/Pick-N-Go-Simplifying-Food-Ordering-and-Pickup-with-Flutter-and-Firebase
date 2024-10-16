import 'package:flutter/material.dart';
import 'package:pickapp/constants/color.dart';

class TextFormFildeBorder extends StatelessWidget {
  final String? hintText;
  final Widget? prefixIcon;
  final bool? isBorder;
  final bool isPassword;
  final bool readOnly;
  final bool enabled;
  final Color? fillColor;
  final String? initialValue;
  final Widget? label;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final String? Function(String? value)? onSaved;
  final String? Function(String? value)? onChanged;
  final Function()? onTap;

  const TextFormFildeBorder({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.isBorder = true,
    this.isPassword = false,
    this.fillColor = Colors.white,
    this.label,
    this.validator,
    this.controller,
    this.onSaved,
    this.onChanged,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.initialValue,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          readOnly: readOnly,
          enabled: enabled,
          onSaved: onSaved,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          obscureText: isPassword,
          cursorColor: kPrimaryColor,
          controller: controller,
          decoration: InputDecoration(
            label: label,
            prefixIconColor: kPrimaryColor,
            labelStyle: const TextStyle(color: kSecondaryColor),
            filled: true,
            fillColor: fillColor,
            prefixIcon: prefixIcon,
            hintText: hintText,
            border: isBorder == true
                ? const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  )
                : null,
            focusedBorder: isBorder == true
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor))
                : const UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor)),
          )),
    );
  }
}
