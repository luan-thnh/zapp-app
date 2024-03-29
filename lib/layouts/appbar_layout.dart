import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/api/apis.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/screens/account_screen.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/widgets/avatar_widget.dart';
import 'package:messenger/widgets/circular_progress_gradient.dart';
import 'package:messenger/widgets/icon_button_widget.dart';
import 'package:provider/provider.dart';

class AppBarLayout extends StatelessWidget implements PreferredSizeWidget {
  final num? quantityNotify;
  final String avatarUrl;
  final String title;
  final Widget iconFirst;
  final bool isIconEdit;
  final Function()? onTapAvatar;
  final Function()? onPressedIcon;

  const AppBarLayout({
    Key? key,
    this.quantityNotify,
    required this.avatarUrl,
    required this.title,
    required this.iconFirst,
    this.onTapAvatar,
    this.onPressedIcon,
    this.isIconEdit = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: StreamBuilder(
        stream: APIs.fireStore.collection('users').doc(authService.user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            ChatUserModel currentUser = ChatUserModel.fromJson(snapshot.data!.data()!);

            return Container(
              margin: const EdgeInsets.only(top: 24),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen()));
                            },
                            child: AvatarWidget(avatarUrl: currentUser.avatar, width: 48, height: 48),
                          ),
                          if (quantityNotify != null)
                            Positioned(
                              top: 5,
                              right: -10,
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  color: ColorsTheme.white,
                                  borderRadius: BorderRadius.circular(9999), // Adjusted border radius
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: ColorsTheme.red,
                                    borderRadius: BorderRadius.circular(9999), // Adjusted border radius
                                  ),
                                  child: Text(
                                    '$quantityNotify+',
                                    style: const TextStyle(color: ColorsTheme.white, fontWeight: FontWeight.w700, fontSize: 8),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Text(title, style: Theme.of(context).textTheme.displaySmall)
                    ],
                  ),
                  Row(
                    children: [
                      IconButtonWidget(
                        onPressed: onPressedIcon,
                        icon: iconFirst,
                        size: 42,
                        bgColor: Theme.of(context).colorScheme.secondary,
                      ),
                      if (isIconEdit) const SizedBox(width: 12),
                      if (isIconEdit)
                        IconButtonWidget(
                          onPressed: () {},
                          size: 42,
                          icon: FaIcon(
                            FontAwesomeIcons.solidPenToSquare,
                            color: Theme.of(context).iconTheme.color,
                            size: 20,
                          ),
                          bgColor: Theme.of(context).colorScheme.secondary,
                        )
                    ],
                  ),
                ],
              ),
            );
          }
          return Container();

          // Ví dụ: print(currentUser.firstName);
        },
      ),
    );
  }
}
