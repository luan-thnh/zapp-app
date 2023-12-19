import 'package:messenger/screens/call_screen.dart';
import 'package:messenger/screens/login_screen.dart';
import 'package:messenger/screens/people_screen.dart';
import 'package:messenger/screens/register_screen.dart';
import 'package:messenger/screens/splash_screen.dart';
import 'package:messenger/screens/story_screen.dart';

var routersConfig = {
  '//': (context) => const SplashScreen(),
  '/login': (context) => const LoginScreen(),
  '/people': (context) => const PeopleScreen(),
  '/story': (context) => const StoryScreen(),
  '/call': (context) => const CallScreen(),
  '/register': (context) => const RegisterScreen(),
};
