import 'package:messenger/screens/home_screen.dart';
import 'package:messenger/screens/login_screen.dart';
import 'package:messenger/screens/register_screen.dart';
import 'package:messenger/screens/splash_screen.dart';

var routersConfig = {
  '//': (context) => const SplashScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen()
};
