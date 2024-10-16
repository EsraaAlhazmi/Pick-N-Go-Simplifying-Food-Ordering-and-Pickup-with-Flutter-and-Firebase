import 'package:flutter/material.dart';

import '../constants/color.dart';

class SecondaryButton extends StatelessWidget {
  final Widget? child;
  final double? width;
  final Function()? onPressed;
  const SecondaryButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kSecondaryColor,
        minimumSize: Size(width!, 50),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
