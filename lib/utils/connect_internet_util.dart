import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/widgets/circular_progress_gradient.dart';

class ConnectInternetUtil extends StatelessWidget {
  final Widget child;

  const ConnectInternetUtil({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
        if (snapshot.hasData) {
          ConnectivityResult? result = snapshot.data;

          return SingleChildScrollView(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  if (result == ConnectivityResult.none)
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(
                        'Waiting for connection...',
                        style: TypographyTheme.text3(color: ColorsTheme.red),
                      ),
                    ),
                  child
                ],
              ),
            ),
          );
        }

        return const Center(
          child: CircularProgressGradient(),
        );
      },
    );
  }
}
