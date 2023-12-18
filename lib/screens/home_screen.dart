import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/layouts/appbar_layout.dart';
import 'package:messenger/layouts/navigator_layout.dart';
import 'package:messenger/screens/call_screen.dart';
import 'package:messenger/screens/chat_screen.dart';
import 'package:messenger/screens/onboarding_screen.dart';
import 'package:messenger/screens/people_screen.dart';
import 'package:messenger/screens/story_screen.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/services/provider/sound_controller.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/utils/dialogs_util.dart';
import 'package:messenger/widgets/button_widget.dart';
import 'package:messenger/widgets/circular_progress_gradient.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  List pages = [const ChatScreen(), const CallScreen(), const PeopleScreen(), const StoryScreen()];

  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;

    _requestPermission();

    final authService = Provider.of<AuthService>(context, listen: false);

    authService.getSelfInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (authService.user != null) {
        if (message.toString().contains('resume')) authService.updateActiveStatus(true);
        if (message.toString().contains('pause')) authService.updateActiveStatus(false);
      }
      return Future.value(message);
    });

    Provider.of<SoundController>(context, listen: false).initAudio();
  }

  Future<void> _requestPermission() async {
    await Permission.phone.request();
    await Permission.camera.request();
    await Permission.location.request();
    await Permission.microphone.request();
    await Permission.photos.request();
    await Permission.videos.request();
    await PhotoManager.requestPermissionExtend();
  }

  void onTapNavigatorBar(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigatorLayout(
        currentIndex: currentIndex,
        onTapNavigatorBar: onTapNavigatorBar,
      ),
    );
  }
}
