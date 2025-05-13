import 'package:flutter/material.dart';

class DebugOutline extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? width;

  const DebugOutline({
    super.key,
    required this.child,
    this.color = Colors.red,
    this.width = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: color ?? Colors.red,
          width: width ?? 1.0,
        ),
      ),
      child: child,
    );
  }
}
