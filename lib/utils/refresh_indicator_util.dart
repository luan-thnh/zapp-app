import 'package:flutter/material.dart';
import 'package:messenger/theme/colors_theme.dart';

class RefreshIndicatorUtil extends StatelessWidget {
  final Widget child;

  const RefreshIndicatorUtil({Key? key, required this.child}) : super(key: key);

  Future<void> _handleRefresh() {
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      edgeOffset: 0,
      color: ColorsTheme.primary,
      backgroundColor: ColorsTheme.white,
      child: child,
    );
  }
}
