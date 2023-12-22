import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/layouts/appbar_layout.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/utils/connect_internet_util.dart';
import 'package:messenger/widgets/circular_progress_gradient.dart';
import 'package:messenger/widgets/list_chat_user.dart';
import 'package:messenger/widgets/search_button_widget.dart';
import 'package:messenger/widgets/slide_friends_widget.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatUserModel> list = [];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBarLayout(
        avatarUrl: ImageUrls.avatarDefault,
        iconFirst: FaIcon(
          FontAwesomeIcons.camera,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        title: 'Chat',
      ),
      body: StreamBuilder(
        stream: authService.findAllUsers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const CircularProgressGradient();

            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;

              list = data?.map((e) => ChatUserModel.fromJson(e.data())).toList() ?? [];

              return ConnectInternetUtil(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SearchButtonWidget(),
                    SlideFriendsWidget(list: list),
                    const SizedBox(height: 8),
                    ListChatUser(list: list),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
