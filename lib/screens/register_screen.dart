import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/screens/home_screen.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/utils/dialogs_util.dart';
import 'package:messenger/utils/validate_field_util.dart';
import 'package:messenger/widgets/button_widget.dart';
import 'package:messenger/widgets/input_control_widget.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late Size mq;
  late TextEditingController _phoneNumberOrEmailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _rePasswordController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _phoneNumberOrEmailController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void handleSignUpWithEmailAndPassword() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    DialogsUtil.showProgressBar(context);

    try {
      await InternetAddress.lookup('google.com');

      await authService
          .signUpWithEmailAndPassword(
            _phoneNumberOrEmailController.text.trim(),
            _passwordController.text.trim(),
          )
          .then((user) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen())));
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
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InputControlWidget(
                                controller: _firstNameController,
                                obscureText: false,
                                hintText: 'First name',
                                validator: ValidateFieldUtil.validateFirstName,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: InputControlWidget(
                                controller: _lastNameController,
                                obscureText: false,
                                hintText: 'Last name',
                                validator: ValidateFieldUtil.validateLastName,
                              ),
                            ),
                          ],
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
                          hintText: 'Re-enter Password',
                          obscureText: true,
                          borderColor: Colors.transparent,
                          validator: (p0) => validationError,
                        ),
                        const SizedBox(height: 24),
                        ButtonWidget(
                          disable: false,
                          text: 'Create New Account',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              handleSignUpWithEmailAndPassword();
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
