import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/layouts/appbar_layout.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/widgets/circular_progress_gradient.dart';
import 'package:provider/provider.dart';

import '../widgets/button_widget.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  List<ChatUserModel> list = [];
  List<ChatUserModel> doubledList = [];
  int countIsOnline = 0;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarLayout(
        avatarUrl: ImageUrls.avatarDefault,
        iconFirst: FaIcon(
          FontAwesomeIcons.solidAddressBook,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        title: 'People',
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

                list = data?.map((e) => ChatUserModel.fromJson(e.data())).toList() ?? [];

                if (list.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(
                                'No Active People',
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'You"ll see when  others are active here. You can also invite more friends  to join Messenger.',
                                style: Theme.of(context).textTheme.bodyText2,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const ButtonWidget(
                                text: 'INVITE PEOPLE',
                                disable: false,
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                countIsOnline = list.where((item) => item.isOnline == true).length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Text(
                        'Đang hoạt động ($countIsOnline)',
                        textAlign: TextAlign.start,
                        style: TypographyTheme.text2(color: ColorsTheme.grey),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          ChatUserModel item = list[index];

                          return Card(
                            elevation: 0,
                            color: Colors.transparent,
                            margin: EdgeInsets.zero,
                            child: ListTile(
                              onTap: () {},
                              contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 24),
                              leading: Stack(clipBehavior: Clip.none, children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image(
                                    image: NetworkImage(item.avatar.isNotEmpty ? item.avatar : ImageUrls.avatarDefault),
                                    width: 42,
                                    height: 42,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: -5,
                                  right: 0,
                                  child: Container(
                                    height: 16,
                                    width: 16,
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: ColorsTheme.white),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorsTheme.green,
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                              title: Text(
                                '${item.firstName} ${item.lastName}' ?? '',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
