import 'package:flutter/material.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/screens/home_screen.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/utils/dialogs_util.dart';
import 'package:messenger/utils/validate_field_util.dart';
import 'package:messenger/widgets/button_widget.dart';
import 'package:messenger/widgets/input_control_widget.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Size mq;
  late TextEditingController _phoneNumberOrEmailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _phoneNumberOrEmailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignInWithGoogle() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    DialogsUtil.showProgressBar(context);

    try {
      authService.signInWithGoogle().then((user) {
        Navigator.pop(context);
        if (user != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      });
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  void _handleSignInWithFacebook() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    DialogsUtil.showProgressBar(context);

    try {
      authService.signInWithFacebook().then((user) {
        Navigator.pop(context);

        if (user != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      });
    } catch (e) {
      // Handle the specific exception, e.g., print or show an error message.
      print("Google Sign-In Error: $e");
    }
  }

  void _handleSignInWithEmailPassword() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    DialogsUtil.showProgressBar(context);

    try {
      await authService
          .signInWithEmailAndPassword(_phoneNumberOrEmailController.text.trim(),
              _passwordController.text.trim())
          .then((user) {
        Navigator.pop(context);

        if (user != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      });
    } catch (e) {
      print("Email/Password Sign-In Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

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
                          borderColor: Colors.transparent,
                          validator: ValidateFieldUtil.validatePassword,
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {},
                          child: Text('Forgot password?',
                              style: TypographyTheme.heading5(
                                  color: ColorsTheme.primary)),
                        ),
                        const SizedBox(height: 24),
                        ButtonWidget(
                          disable: false,
                          text: 'Login',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _handleSignInWithEmailPassword();
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(height: 1, color: Colors.grey.shade300),
                            Positioned(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: const BoxDecoration(
                                  color: ColorsTheme.white,
                                ),
                                child: const Text('Or',
                                    style: TextStyle(color: ColorsTheme.black)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ButtonWidget(
                          disable: false,
                          text: 'Sign up with Google',
                          icon: Image.asset(ImageUrls.googleIcon, width: 24),
                          bgColor: ColorsTheme.light,
                          textColor: ColorsTheme.black,
                          onPressed: _handleSignInWithGoogle,
                        ),
                        const SizedBox(height: 8),
                        ButtonWidget(
                          disable: false,
                          text: 'Sign up with Facebook',
                          icon: Image.asset(ImageUrls.facebookIcon, width: 24),
                          bgColor: ColorsTheme.light,
                          textColor: ColorsTheme.black,
                          onPressed: _handleSignInWithFacebook,
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
