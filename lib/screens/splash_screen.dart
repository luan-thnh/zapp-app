import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/services/auth/auth_gate.dart';
import 'package:messenger/theme/colors_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Size mq = MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthGate()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Image.asset(
                ImageUrls.zappLogo,
                width: 86,
              ),
            ),
            const Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    'from',
                    style: TextStyle(color: ColorsTheme.grey, fontSize: 12),
                  ),
                  Image(
                    image: AssetImage(ImageUrls.metaLogo),
                    width: 58,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
