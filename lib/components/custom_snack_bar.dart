import 'package:demo_ui/config/theme_config.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar customSnackBar({
    required BuildContext snackContext,
    required bool isMobile,
    required double width,
    required Color color,
    required String msg,
    int second = 2,
  }) {
    return SnackBar(
      duration: Duration(seconds: second),
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? width * 0.08 : width * 0.2,
        vertical: isMobile ? 10 : 20,
      ),
      content: Row(
        children: [
          Icon(
            color == redColor ? Icons.remove_circle : Icons.done_rounded,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              msg,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0.3,
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
