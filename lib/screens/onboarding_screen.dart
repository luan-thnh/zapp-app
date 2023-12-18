import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/screens/home_screen.dart';
import 'package:messenger/screens/register_screen.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/utils/connect_internet_util.dart';
import 'package:messenger/utils/dialogs_util.dart';
import 'package:messenger/utils/theme_switch_ulti.dart';
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

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
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

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      });
    } catch (e) {
      // Handle the specific exception, e.g., print or show an error message.
      print("Google Sign-In Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ConnectInternetUtil(
        child: Container(
          padding: const EdgeInsets.all(24),
          color: Theme.of(context).scaffoldBackgroundColor,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage(ImageUrls.zappLogo), width: 125),
              const SizedBox(height: 28),
              Text('Welcome to ', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge),
              GradientText(
                'Zapp',
                style: TypographyTheme.headingBig(),
                gradient: const LinearGradient(colors: [ColorsTheme.purple, ColorsTheme.pink]),
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
                bgColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.tertiary,
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
                bgColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.tertiary,
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
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Text(
                        'Or',
                        style: Theme.of(context).textTheme.bodyMedium,
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
                  Text('Already have an account?', style: Theme.of(context).textTheme.bodyMedium),
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
      ),
    );
  }
}
