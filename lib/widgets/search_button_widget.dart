import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';

class SearchButtonWidget extends StatelessWidget {
  final Function()? onPressed;
  const SearchButtonWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          primary: ColorsTheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        child: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.search,
              color: ColorsTheme.blackGray,
              size: 16,
            ),
            const SizedBox(width: 16),
            Text(
              'Search',
              style: TypographyTheme.text1(color: ColorsTheme.blackGray),
            )
          ],
        ),
      ),
    );
  }
}
