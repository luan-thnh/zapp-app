import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/main.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/models/message_model.dart';
import 'package:messenger/screens/chatting_screen.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/utils/format_date_util.dart';
import 'package:messenger/utils/refresh_indicator_util.dart';
import 'package:messenger/widgets/avatar_widget.dart';
import 'package:provider/provider.dart';

class ListChatUser extends StatelessWidget {
  List<ChatUserModel> list;
  List<QueryDocumentSnapshot>? listDoc;
  ListChatUser({super.key, required this.list, required this.listDoc});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicatorUtil(
      child: ListView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ItemChatUser(user: list[index], userDoc: listDoc![index]);
        },
      ),
    );
  }
}

class ItemChatUser extends StatefulWidget {
  final ChatUserModel user;
  final DocumentSnapshot userDoc;
  const ItemChatUser({super.key, required this.user, required this.userDoc});

  @override
  State<ItemChatUser> createState() => _ItemChatUserState();
}

class _ItemChatUserState extends State<ItemChatUser> {
  MessageModel? _message;
  void _showModalBottomSheet(BuildContext context) async {
    late Size mq = MediaQuery.of(context).size;

    List<Map<String, dynamic>> sheetList = [
      {
        "icon": FaIcon(
          FontAwesomeIcons.trash,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        "title": Text('Delete', style: Theme.of(context).textTheme.bodyLarge)
      },
      {
        "icon": FaIcon(
          FontAwesomeIcons.solidBellSlash,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        "title": Text('Turn off', style: Theme.of(context).textTheme.bodyLarge)
      },
      {
        "icon": FaIcon(
          FontAwesomeIcons.userGroup,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        "title": Text('Create a chat group with ${widget.user.lastName} ${widget.user.firstName}',
            maxLines: 1, style: Theme.of(context).textTheme.bodyLarge)
      },
      {
        "icon": Icon(
          Icons.bubble_chart_rounded,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        "title": Text('Open the chat bubble', style: Theme.of(context).textTheme.bodyLarge)
      },
      {
        "icon": Icon(
          Icons.mark_email_unread_rounded,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        "title": Text('Mark as unread', style: Theme.of(context).textTheme.bodyLarge)
      },
      {
        "icon": FaIcon(
          FontAwesomeIcons.circleMinus,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        "title": Text('Block', style: Theme.of(context).textTheme.bodyLarge)
      },
    ];

    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: mq.height * (isThreeButtonNavigation ? 0.5 : .7),
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
                  decoration: BoxDecoration(
                    color: ColorsTheme.grey,
                    borderRadius: BorderRadius.circular(999),
                  ),
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
    final authService = Provider.of<AuthService>(context, listen: false);
    bool isButtonEnabled = true;

    bool handleCheckUnread(MessageModel message) {
      return message.read.isEmpty && message.fromId != authService.user.uid;
    }

    String getMessageText() {
      if (_message != null) {
        String userName = _message!.toId == widget.user.id ? 'You' : widget.user.lastName;

        if (_message!.type == Type.image) {
          return '$userName have sent 1 photo';
        } else if (_message!.type == Type.audio) {
          return '$userName have sent 1 file';
        } else {
          String userText = _message!.toId == widget.user.id ? 'You: ' : '';
          return '$userText${_message!.message}';
        }
      } else {
        return widget.user.description;
      }
    }

    return StreamBuilder(
      stream: authService.getLastMessage(widget.user),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list = data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];

        if (list.isNotEmpty) _message = list[0];

        return Column(
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              child: ListTile(
                onLongPress: () {
                  _showModalBottomSheet(context);
                },
                onTap: () async {
                  if (isButtonEnabled) {
                    isButtonEnabled = false;
                    await Future.delayed(const Duration(seconds: 1));

                    if (!context.mounted) return;

                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChattingScreen(user: widget.user)));

                    isButtonEnabled = true;
                  }
                },
                leading: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: widget.user.isOnline ? Border.all(width: 2, color: ColorsTheme.primary) : null,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: Image.network(
                          widget.user.avatar ?? ImageUrls.avatarDefault,
                          fit: BoxFit.cover,
                          width: 42,
                          height: 42,
                        ),
                      ),
                    ),
                    if (widget.user.isOnline)
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
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
                  '${widget.user.lastName} ${widget.user.firstName}',
                  style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontWeight: _message == null
                          ? null
                          : handleCheckUnread(_message!)
                              ? FontWeight.w500
                              : FontWeight.normal),
                ),
                subtitle: Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: mq.width * 0.45,
                      ),
                      child: Text(
                        getMessageText(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: _message == null
                                ? null
                                : handleCheckUnread(_message!)
                                    ? FontWeight.w500
                                    : FontWeight.normal),
                      ),
                    ),
                    Text(
                      " · ${_message != null ? FormatDateUtil.formatDuration(_message!.sent) : ''}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: _message == null
                              ? null
                              : handleCheckUnread(_message!)
                                  ? FontWeight.w600
                                  : FontWeight.normal),
                    )
                  ],
                ),
                trailing: () {
                  if (_message != null && _message!.toId == widget.user.id) {
                    if (_message!.read.isNotEmpty) {
                      return AvatarWidget(
                        width: 18,
                        height: 18,
                        avatarUrl: widget.user.avatar,
                      );
                    } else if (_message!.read.isEmpty) {
                      return FaIcon(
                        widget.user.isOnline ? FontAwesomeIcons.solidCircleCheck : FontAwesomeIcons.circleCheck,
                        size: 14,
                        color: ColorsTheme.greyLight,
                      );
                    }
                  }
                  return const SizedBox();
                }(),
              ),
            ),
          ],
        );
      },
    );
  }
}
