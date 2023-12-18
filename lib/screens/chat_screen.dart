import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/layouts/appbar_layout.dart';
import 'package:messenger/screens/onboarding_screen.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/utils/dialogs_util.dart';
import 'package:messenger/widgets/button_widget.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void handleSignOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    DialogsUtil.showProgressBar(context);

    try {
      authService.signOut().then((value) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          (route) => false,
        );
      });
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarLayout(
        avatarUrl: ImageUrls.avatarDefault,
        iconFirst: FaIcon(
          FontAwesomeIcons.camera,
          color: ColorsTheme.black,
          size: 20,
        ),
        title: 'Chat',
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Home Screen',
              style: TypographyTheme.heading2(),
            ),
            const SizedBox(height: 32),
            ButtonWidget(
              text: 'Logout',
              bgColor: ColorsTheme.primary,
              textColor: ColorsTheme.white,
              disable: false,
              onPressed: handleSignOut,
            )
          ],
        ),
      ),
    );
  }
}
