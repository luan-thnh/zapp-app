import 'package:flutter/material.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/widgets/avatar_widget.dart';
import 'package:messenger/widgets/icon_button_widget.dart';

class AppBarLayout extends StatelessWidget implements PreferredSizeWidget {
  final num? quantityNotify;
  final String avatarUrl;
  final String title;
  final Icon iconFirst;
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
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(85);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                      onTap: onTapAvatar,
                      child: AvatarWidget(avatarUrl: avatarUrl, width: 52, height: 52),
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
                Text(title, style: TypographyTheme.heading2())
              ],
            ),
            Row(
              children: [
                IconButtonWidget(
                  onPressed: onPressedIcon,
                  icon: iconFirst,
                  bgColor: ColorsTheme.light,
                ),
                const SizedBox(width: 12),
                IconButtonWidget(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.mode_edit_outline_rounded,
                    color: ColorsTheme.black,
                  ),
                  bgColor: ColorsTheme.light,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
