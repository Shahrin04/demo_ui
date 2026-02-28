import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<CustomAlertAction>? actions;

  const CustomAlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions = const <CustomAlertAction>[],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      title: title,
      backgroundColor: Colors.white.withValues(alpha: .8),
      content: SizedBox(
        height: 100,
        child: Center(child: SingleChildScrollView(child: content)),
      ),
      actions: actions,
    );
  }
}

class CustomAlertAction extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onPressed;
  const CustomAlertAction({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: child);
  }
}
