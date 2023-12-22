import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/layouts/appbar_layout.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/widgets/button_widget.dart';
import 'package:messenger/widgets/circular_progress_gradient.dart';
import 'package:provider/provider.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  List<ChatUserModel> list = [];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBarLayout(
        avatarUrl: ImageUrls.avatarDefault,
        isIconEdit: false,
        iconFirst: FaIcon(
          FontAwesomeIcons.film,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        title: 'Story',
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: StreamBuilder(
          stream: authService.findAllUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const CircularProgressGradient();

              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;

                list = [];

                if (list.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Share a Story',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Share photo, video, and more for 24 hours. When you and your friends  share stories, they'll show up here",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const ButtonWidget(text: 'ADD STORY', disable: false),
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                );
            }
          },
        ),
      ),
    );
  }
}
