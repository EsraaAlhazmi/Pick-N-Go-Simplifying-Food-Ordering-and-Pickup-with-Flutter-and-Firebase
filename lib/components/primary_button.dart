import 'package:flutter/material.dart';

import '../constants/color.dart';

class PrimaryButton extends StatelessWidget {
  final Widget? child;
  final double? width;

  final Function()? onPressed;
  const PrimaryButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width!, 50),
        backgroundColor: kPrimaryColor,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
