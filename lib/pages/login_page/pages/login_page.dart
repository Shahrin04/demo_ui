import 'dart:developer' as d;
import 'package:demo_ui/components/custom_elevated_button.dart';
import 'package:demo_ui/components/custom_snack_bar.dart';
import 'package:demo_ui/components/custom_text_field.dart';
import 'package:demo_ui/components/loading_indicator_dialog.dart';
import 'package:demo_ui/config/strings.dart';
import 'package:demo_ui/config/theme_config.dart';
import 'package:demo_ui/models/user_model.dart';
import 'package:demo_ui/providers/user_provider.dart';
import 'package:demo_ui/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late ApiService apiService;
  late UserProvider userProvider;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode userNameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
    apiService = ApiService();
  }

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    passwordController.dispose();
    userNameFocus.dispose();
    passwordFocus.dispose();
  }

  Future<void> loginAction(double width, BuildContext context) async {
    try {
      LoadingIndicatorDialog().show(context, 'Loading...');
      await Future.delayed(const Duration(seconds: 1));
      FocusScope.of(context).requestFocus(FocusNode());
      if (_formKey.currentState!.validate()) {
        ApiResponse response = await apiService.login(
          userNameController.text,
          passwordController.text,
        );

        if (response.data != null && mounted) {
          setState(() {
            loading = true;
          });
          SharedPreferences pref = await SharedPreferences.getInstance();
          String token = response.data['token'];
          await pref.setString(LOGGED_TOKEN, token);

          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.customSnackBar(
                snackContext: context,
                isMobile: width < 700,
                width: width,
                color: greenColor,
                msg: 'Login Successful',
                second: 3,
              ),
            );
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.customSnackBar(
              snackContext: context,
              isMobile: width < 700,
              width: width,
              color: redColor,
              msg: 'No User Found',
              second: 3,
            ),
          );
        }
      }
      LoadingIndicatorDialog().dismiss(context);
    } on Exception catch (e) {
      String msg = "Error::LoginPage::loginAction: ${e.toString()}";
      d.log(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: width > 700 ? 600 : null,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            top: 45,
                          ),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'User Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  CustomTextField(
                                    controller: userNameController,
                                    focusNode: userNameFocus,
                                    textInputAction: TextInputAction.next,
                                    hintText: 'Your Name',
                                    maxLength: 11,
                                    obscureCharacter: '*',
                                    onFieldSubmit: (_) {
                                      if (!passwordFocus.hasFocus &&
                                          passwordFocus.canRequestFocus) {
                                        FocusScope.of(
                                          context,
                                        ).requestFocus(passwordFocus);
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Password',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  CustomTextField(
                                    suffixVisibilityIcon: true,
                                    obscured: true,
                                    controller: passwordController,
                                    focusNode: passwordFocus,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    hintText: 'Your Password',
                                    obscureCharacter: '*',
                                    onFieldSubmit: (_) async {
                                      await loginAction(width, context);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 200,
                          child: CustomElevatedButton(
                            text: 'Login',
                            bgColor: bgColor,
                            onPressed: () async {
                              await loginAction(width, context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
