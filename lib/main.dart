import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/configs/firebase_config.dart';
import 'package:messenger/configs/routes_config.dart';
import 'package:messenger/layouts/navigator_layout.dart';
import 'package:messenger/screens/splash_screen.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/services/provider/theme_provider.dart';
import 'package:messenger/services/provider/gallery_controller.dart';
import 'package:messenger/services/provider/sound_controller.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:provider/provider.dart';

late bool isThreeButtonNavigation;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (value) async {
      await FirebaseConfig.initializeFirebase();
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AuthService()),
            ChangeNotifierProvider(create: (context) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => SoundController.instance),
            ChangeNotifierProvider(create: (_) => GalleryController.instance),
          ],
          child: const MyApp(),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    isThreeButtonNavigation = MediaQuery.of(context).padding.bottom == 0 && Theme.of(context).platform == TargetPlatform.android;

    return MaterialApp(
      title: 'Zapp',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ColorsTheme.lightTheme,
      darkTheme: ColorsTheme.darkTheme,
      initialRoute: '/',
      routes: routersConfig,
      home: const SplashScreen(),
    );
  }
}
