import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/screens/home_screen.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/utils/dialogs_util.dart';
import 'package:messenger/widgets/button_widget.dart';
import 'package:messenger/widgets/gradient_text.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
      // Handle the specific exception, e.g., print or show an error message.
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
      print("Facebook Sign-In Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(image: AssetImage(ImageUrls.zappLogo), width: 125),
                const SizedBox(height: 28),
                Text('Welcome to ',
                    textAlign: TextAlign.center,
                    style: TypographyTheme.heading1()),
                GradientText(
                  'Zapp',
                  style: TypographyTheme.headingBig(),
                  gradient: const LinearGradient(
                      colors: [ColorsTheme.purple, ColorsTheme.pink]),
                ),
                const SizedBox(height: 14),
                Text(
                  'Connect with friend, discover new communities, and share your life with others.',
                  textAlign: TextAlign.center,
                  style: TypographyTheme.text2(color: ColorsTheme.grey),
                ),
                const SizedBox(height: 32),
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
                  icon: Image.asset(
                    ImageUrls.facebookIcon,
                    width: 24,
                  ),
                  bgColor: ColorsTheme.light,
                  textColor: ColorsTheme.black,
                  onPressed: _handleSignInWithFacebook,
                ),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(height: 1, color: Colors.grey.shade300),
                    Positioned(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: const BoxDecoration(
                          color: ColorsTheme.white,
                        ),
                        child: const Text(
                          'Or',
                          style: TextStyle(color: ColorsTheme.black),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ButtonWidget(
                  disable: false,
                  text: 'Create an Account',
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                ),
                const SizedBox(height: 42),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: ColorsTheme.primary),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
