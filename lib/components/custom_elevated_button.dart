import 'package:demo_ui/config/theme_config.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color? bgColor;
  final VoidCallback? onPressed;
  const CustomElevatedButton({
    super.key,
    required this.text,
    this.bgColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8),
          backgroundColor: bgColor ?? borderColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
