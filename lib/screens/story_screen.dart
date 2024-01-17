import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/layouts/appbar_layout.dart';
import 'package:messenger/layouts/navigator_layout.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late TextEditingController _searchContro;
  List<Map<String, String>> story = [
    {'image': ImageUrls.story_1, 'title': 'Ngọc Huyền'},
    {'image': ImageUrls.story_2, 'title': 'Đoàn Đại Hưng'},
    {'image': ImageUrls.story_3, 'title': 'Phạm Thủy'},
    {'image': ImageUrls.story_4, 'title': 'Tiên Trần'},
    {'image': ImageUrls.story_5, 'title': 'Thành Luân'},
    {'image': ImageUrls.story_6, 'title': 'Hoàng Phúc'},
    {'image': ImageUrls.story_7, 'title': 'Hải Nam'},
    {'image': ImageUrls.story_8, 'title': 'Kim Xuyến'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarLayout(
        avatarUrl: ImageUrls.avatarDefault,
        isIconEdit: false,
        iconFirst: FaIcon(
          FontAwesomeIcons.film,
          color: ColorsTheme.black,
          size: 20,
        ),
        title: 'Story',
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Active (184)',
                      style: TypographyTheme.heading5(color: ColorsTheme.blackGray),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Stories (21)',
                          style: TypographyTheme.heading4(color: ColorsTheme.black),
                          textAlign: TextAlign.center,
                        ))),
              ],
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: story.map((item) {
                  return Card(
                    elevation: 0,
                    child: ListTile(
                      onTap: () {},
                      leading: Stack(clipBehavior: Clip.none, children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            image: AssetImage(item['image']!),
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ]),
                    ),
                  );
                }).toList()),
          ],
        ),
      ),
    );
  }
}
