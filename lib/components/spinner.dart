import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  final double? radius;
  final Color? color;

  const Spinner({super.key, this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (radius ?? 15) * 2,
      height: (radius ?? 15) * 2,
      child: Center(
        child: CircularProgressIndicator(color: color, strokeWidth: 5),
      ),
    );
  }
}
