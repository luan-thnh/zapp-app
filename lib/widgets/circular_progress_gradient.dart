import 'package:flutter/material.dart';
import 'package:messenger/theme/colors_theme.dart';

class CircularProgressGradient extends StatefulWidget {
  const CircularProgressGradient({Key? key}) : super(key: key);

  @override
  State<CircularProgressGradient> createState() => _CircularProgressGradientState();
}

class _CircularProgressGradientState extends State<CircularProgressGradient> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: animationController.drive(ColorTween(begin: ColorsTheme.pink, end: ColorsTheme.purple)),
        ),
      ),
    );
  }
}
