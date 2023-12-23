import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/screens/registerInfo_screen.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/utils/dialogs_util.dart';
import 'package:messenger/utils/validate_field_util.dart';
import 'package:messenger/widgets/button_widget.dart';
import 'package:messenger/widgets/input_control_widget.dart';
import 'package:provider/provider.dart';

import '../theme/typography_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late Size mq;
  late TextEditingController _phoneNumberOrEmailController;
  late TextEditingController _rePasswordController;
  late TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phoneNumberOrEmailController = TextEditingController();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _handleSignUpWithEmailAndPassword() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    DialogsUtil.showProgressBar(context);

    try {
      authService
          .signUpWithEmailAndPassword(
              _phoneNumberOrEmailController.text, _passwordController.text)
          .then((user) async {
        if (user != null) {
          await authService
              .createUserEmail(_phoneNumberOrEmailController.text)
              .then((value) {
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const RegisterInfoScreen()));
          });
        }
      }).catchError(
        (error) {
          Navigator.pop(context);
          DialogsUtil.showSnackBar(context, 'Account already exists!', false);
        },
      );
    } catch (e) {
      print('Something Went Wrong (Check Internet!)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    String? validationError = ValidateFieldUtil.validateRePassword(
        _rePasswordController.text, _passwordController.text);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          height: mq.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Image(
                  image: const AssetImage(
                    ImageUrls.zappLogo,
                  ),
                  width: mq.width * .35,
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create an account',
                          style: TypographyTheme.heading1(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        InputControlWidget(
                          controller: _phoneNumberOrEmailController,
                          obscureText: false,
                          hintText: 'Phone Number or Email',
                          validator:
                              ValidateFieldUtil.validatePhoneNumberOrEmail,
                        ),
                        InputControlWidget(
                          controller: _passwordController,
                          hintText: 'Password',
                          obscureText: true,
                          validator: ValidateFieldUtil.validatePassword,
                        ),
                        InputControlWidget(
                          controller: _rePasswordController,
                          hintText: 'Confirm Password',
                          obscureText: true,
                          borderColor: Colors.transparent,
                          validator: (p0) => validationError,
                        ),
                        const SizedBox(height: 24),
                        ButtonWidget(
                          disable: false,
                          text: 'Next',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _handleSignUpWithEmailAndPassword();
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
