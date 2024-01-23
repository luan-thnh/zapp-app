import 'package:flutter/material.dart';
import 'package:messenger/api/apis.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/screens/chatting_screen.dart';
import 'package:messenger/screens/profile_screen.dart';
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
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Icon(
                      Icons.video_call_rounded,
                      size: 32,
                      color: Theme.of(context).iconTheme.color,
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
            user: filteredList[index - 1],
          );
        },
      ),
    );
  }
}

class SlideFriendItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final ChatUserModel user;
  const SlideFriendItem({super.key, required this.imageUrl, required this.title, required this.user});

  void _showPopupMenu(BuildContext context, Offset tapPosition) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(tapPosition & const Size(40, 40), Offset.zero & overlay.size),
      color: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      shadowColor: Theme.of(context).colorScheme.secondary,
      elevation: .6,
      items: [
        PopupMenuItem(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileScreen(user: user)));
          },
          child: Text(
            "View personal page",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        PopupMenuItem(
          child: Text(
            "Share contact information",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        PopupMenuItem(
          child: Text(
            "Hide contacts",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = true;

    return SizedBox(
      width: 70,
      child: GestureDetector(
        onLongPress: () {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final tapPosition = renderBox.localToGlobal(const Offset(0, 56));
          _showPopupMenu(context, tapPosition);
        },
        onTap: () async {
          if (isButtonEnabled) {
            isButtonEnabled = false;
            await Future.delayed(const Duration(seconds: 1));

            if (!context.mounted) return;

            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChattingScreen(user: user)));

            isButtonEnabled = true;
          }
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
                        color: Theme.of(context).scaffoldBackgroundColor,
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
