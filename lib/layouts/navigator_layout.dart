import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/main.dart';
import 'package:messenger/theme/colors_theme.dart';

class NavigatorLayout extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTapNavigatorBar;
  const NavigatorLayout({super.key, required this.currentIndex, this.onTapNavigatorBar});

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;

    return Container(
      height: mq.height * (isThreeButtonNavigation ? .08 : .13),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: ColorsTheme.primary,
        unselectedItemColor: Theme.of(context).iconTheme.color,
        currentIndex: currentIndex,
        onTap: onTapNavigatorBar,
        items: const [
          BottomNavigationBarItem(
            icon: Badge(
              label: Text(
                '2',
                style: TextStyle(color: ColorsTheme.white),
              ),
              child: FaIcon(
                FontAwesomeIcons.solidComment,
              ),
            ),
            label: 'Chat',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.video,
            ),
            label: 'Call',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.userGroup,
            ),
            label: 'People',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.film,
            ),
            label: 'Story',
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
