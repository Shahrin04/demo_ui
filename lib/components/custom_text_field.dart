import 'package:demo_ui/config/theme_config.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? obscureCharacter;
  final int? maxLength;
  final String? levelText;
  final Widget? prefixIcon;
  final bool clearText;
  final bool suffixVisibilityIcon;
  final String? hintText;
  final String? errorText;
  final bool? obscured;
  final int? maxLine;
  final bool? readOnly;
  final double? verticalPadding;
  final ValueChanged? onFieldSubmit;
  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.onFieldSubmit,
    this.verticalPadding,
    this.textInputAction,
    this.clearText = false,
    this.prefixIcon,
    this.keyboardType,
    this.obscureCharacter,
    this.maxLength,
    this.levelText,
    this.suffixVisibilityIcon = false,
    this.hintText,
    this.errorText,
    this.obscured,
    this.maxLine,
    this.readOnly = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late ThemeData theme;
  bool obscure = false;
  @override
  void initState() {
    super.initState();
    obscure = widget.obscured ?? false;
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return TextFormField(
      maxLines: widget.maxLine ?? 1,
      textAlignVertical: obscure
          ? TextAlignVertical.bottom
          : TextAlignVertical.center,
      controller: widget.controller,
      focusNode: widget.focusNode ?? FocusNode(),
      readOnly: widget.readOnly!,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      obscuringCharacter: widget.obscureCharacter!,
      obscureText: obscure,
      maxLength: widget.maxLength,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: widget.verticalPadding ?? 18,
        ),
        errorText: widget.errorText,
        errorStyle: TextStyle(
          fontSize: 15,
          color: Colors.red,
          fontWeight: FontWeight.w400,
        ),
        fillColor: theme.cardColor,
        isDense: true,
        filled: true,
        counterText: "",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: borderColor,
            width: 1.3,
            style: BorderStyle.solid,
          ),
        ),
        labelStyle: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: greyColor,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixVisibilityIcon
            ? obscure
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          obscure = !obscure;
                        });
                      },
                      splashRadius: 1,
                      icon: const Icon(
                        Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                    )
                  : !widget.clearText
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          obscure = !obscure;
                        });
                      },
                      splashRadius: 1,
                      icon: Icon(Icons.visibility_outlined),
                    )
                  : IconButton(
                      onPressed: () {
                        widget.controller?.clear();
                        if (widget.focusNode != null &&
                            widget.focusNode!.canRequestFocus) {
                          FocusScope.of(
                            context,
                          ).requestFocus(widget.focusNode!);
                        }
                        setState(() {});
                      },
                      splashRadius: 1,
                      icon: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                theme.primaryColor,
                            width: 1.5, 
                          ),
                        ),
                        child: Icon(Icons.close, color: theme.primaryColor),
                      ),
                    )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return Validation(
            value: value,
            levelText: widget.hintText,
            context: context,
          ).emptyCheck();
        } else {
          return Validation(
            value: value.toString(),
            levelText: widget.hintText.toString(),
            context: context,
          ).checkValidation(context);
        }
      },
      onFieldSubmitted: widget.onFieldSubmit,
    );
  }
}

class Validation {
  String? value;
  String? levelText;
  BuildContext? context;

  Validation({this.value, this.levelText, this.context});

  String emptyCheck() {
    return "$levelText";
  }

  String? checkValidation(BuildContext context) {
    if (levelText == 'Phone Number') {
      if (value!.length != 11) {
        return 'Mobile Length Error';
      } else if (double.tryParse(value!) == null) {
        return 'Data Type Error';
      }
    }

    if (value!.length < 4) {
      return 'Minimum 4 digit is required';
    } else if (value!.length > 30) {
      return 'Maximum limit reached';
    }

    return null;
  }
}
