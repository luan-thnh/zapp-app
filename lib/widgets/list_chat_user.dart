import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/utils/refresh_indicator_util.dart';

class ListChatUser extends StatelessWidget {
  List<ChatUserModel> list;
  ListChatUser({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicatorUtil(
      child: ListView(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        children: list.map((item) => ItemChatUser(user: item)).toList(),
      ),
    );
  }
}

class ItemChatUser extends StatelessWidget {
  final ChatUserModel user;
  const ItemChatUser({super.key, required this.user});

  void _showModalBottomSheet(BuildContext context) async {
    late Size mq = MediaQuery.of(context).size;

    List<Map<String, dynamic>> sheetList = [
      {
        "icon": FaIcon(
          FontAwesomeIcons.trash,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        "title": Text('Delete', style: Theme.of(context).textTheme.bodyText1)
      },
      {
        "icon": FaIcon(
          FontAwesomeIcons.solidBellSlash,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        "title": Text('Turn off', style: Theme.of(context).textTheme.bodyText1)
      },
      {
        "icon": FaIcon(
          FontAwesomeIcons.userGroup,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        "title": Text('Create a chat group with ${user.lastName} ${user.firstName}', maxLines: 1, style: Theme.of(context).textTheme.bodyText1)
      },
      {
        "icon": Icon(
          Icons.bubble_chart_rounded,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        "title": Text('Open the chat bubble', style: Theme.of(context).textTheme.bodyText1)
      },
      {
        "icon": Icon(
          Icons.mark_email_unread_rounded,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        "title": Text('Mark as unread', style: Theme.of(context).textTheme.bodyText1)
      },
      {
        "icon": FaIcon(
          FontAwesomeIcons.circleMinus,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        "title": Text('Block', style: Theme.of(context).textTheme.bodyText1)
      },
    ];

    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: mq.height * 0.5,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
            ),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 12,
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(color: ColorsTheme.grey, borderRadius: BorderRadius.circular(999)),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: sheetList.map((item) {
                    return Card(
                      elevation: 0,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: ListTile(
                        onTap: () {},
                        leading: item['icon'],
                        title: item['title'],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    late Size mq = MediaQuery.of(context).size;

    return Column(
      children: [
        Card(
          elevation: 0,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListTile(
            onLongPress: () {
              _showModalBottomSheet(context);
            },
            leading: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: user.isOnline ? Border.all(width: 2, color: ColorsTheme.primary) : null,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9999),
                    child: Image.network(
                      user.avatar,
                      fit: BoxFit.cover,
                      width: 42,
                      height: 42,
                    ),
                  ),
                ),
                if (user.isOnline)
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color: ColorsTheme.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: ColorsTheme.green,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ))
              ],
            ),
            title: Text(
              '${user.lastName} ${user.firstName}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            subtitle: Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: mq.width * 0.45,
                  ),
                  child: Text(
                    user.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TypographyTheme.text2(color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
                Text(
                  " · 23:42",
                  overflow: TextOverflow.ellipsis,
                  style: TypographyTheme.text2(color: Theme.of(context).colorScheme.inversePrimary),
                )
              ],
            ),
            trailing: const FaIcon(
              FontAwesomeIcons.solidCircleCheck,
              size: 14,
              color: ColorsTheme.greyLight,
            ),
          ),
        ),
      ],
    );
  }
}
