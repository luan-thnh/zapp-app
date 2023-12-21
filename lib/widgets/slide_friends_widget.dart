import 'package:flutter/material.dart';
import 'package:messenger/api/apis.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/widgets/avatar_widget.dart';

class SlideFriendsWidget extends StatelessWidget {
  List<ChatUserModel> list;
  SlideFriendsWidget({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    bool filterIsOnline(ChatUserModel user) {
      return user.isOnline == true;
    }

    List<ChatUserModel> filteredList = list.where(filterIsOnline).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(color: ColorsTheme.light, borderRadius: BorderRadius.circular(9999)),
                    child: const Icon(
                      Icons.video_call_rounded,
                      size: 32,
                      color: ColorsTheme.blackGray,
                    ),
                  ),
                  const SizedBox(
                    width: 65,
                    child: Text(
                      'Create Room',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            );
          }

          return SlideFriendItem(
            title: filteredList[index - 1].firstName,
            imageUrl: filteredList[index - 1].avatar,
          );
        },
      ),
    );
  }
}

class SlideFriendItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  const SlideFriendItem({super.key, required this.imageUrl, required this.title});

  void _showPopupMenu(BuildContext context, Offset tapPosition) async {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(tapPosition & const Size(40, 40), Offset.zero & overlay.size),
      color: ColorsTheme.white,
      surfaceTintColor: ColorsTheme.white,
      shadowColor: ColorsTheme.light,
      elevation: .6,
      items: [
        PopupMenuItem(
          child: Text(
            "View personal page",
            style: TypographyTheme.text2(),
          ),
        ),
        PopupMenuItem(
          child: Text(
            "Share contact information",
            style: TypographyTheme.text2(),
          ),
        ),
        PopupMenuItem(
          child: Text(
            "Hide contacts",
            style: TypographyTheme.text2(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: GestureDetector(
        onLongPress: () {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final tapPosition = renderBox.localToGlobal(const Offset(0, 56));
          _showPopupMenu(context, tapPosition);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                AvatarWidget(
                  width: 56,
                  height: 56,
                  avatarUrl: imageUrl,
                ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: ColorsTheme.white,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: ColorsTheme.green,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                    ))
              ],
            ),
            Text(title, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
