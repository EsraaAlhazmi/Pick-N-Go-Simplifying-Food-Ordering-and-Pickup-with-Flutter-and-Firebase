import 'package:flutter/material.dart';

class MyTimeLine extends StatelessWidget {
  final Color? color;
  final Color? iconColor;
  final IconData? icon;

  const MyTimeLine(
      {super.key, this.color, this.icon, this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: Icon(
        icon,
        color: Colors.orange,
        size: 40,
      ),
    );
  }
}
