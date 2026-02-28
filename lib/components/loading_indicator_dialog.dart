import 'dart:developer' as d;
import 'package:demo_ui/components/custom_alert_dialog.dart';
import 'package:demo_ui/components/spinner.dart';
import 'package:demo_ui/config/theme_config.dart';
import 'package:flutter/material.dart';

class LoadingIndicatorDialog {
  void show(BuildContext context, String? title) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: Text(
            title ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Center(child: Spinner(color: bgColor)),
        );
      },
    );
  }

  void dismiss(BuildContext context) {
    try {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      d.log("[Error::LoadingIndicatorDialog::dismiss]", error: e);
    }
  }
}
