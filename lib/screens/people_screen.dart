import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/layouts/appbar_layout.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/screens/contacts_screen.dart';
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
          iconFirst: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsScreen()));
            },
            child: FaIcon(
              FontAwesomeIcons.solidAddressBook,
              color: Theme.of(context).iconTheme.color,
              size: 20,
            ),
          ),
          title: 'People',
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: StreamBuilder(
              stream: authService.getMyUsersId(),

              //get id of only known users
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());

                  //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder(
                      stream: authService.getAllUsers(snapshot.data?.docs.map((e) => e.id).toList() ?? []),
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
                                            style: Theme.of(context).textTheme.displayMedium,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'You"ll see when  others are active here. You can also invite more friends  to join Messenger.',
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ButtonWidget(
                                            text: 'INVITE PEOPLE',
                                            disable: false,
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsScreen()));
                                            },
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
                                          onLongPress: () {
                                            _showBottomSheet(item);
                                          },
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
                                            style: Theme.of(context).textTheme.bodyMedium,
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
                    );
                }
              }),
        ));
  }

  void _showBottomSheet(ChatUserModel user) {
    final authService = Provider.of<AuthService>(context, listen: false);
    Size mq = MediaQuery.of(context).size;
    bool isAdd = false;

    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: mq.height * .45,
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
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: Image.network(
                          user.avatar,
                          fit: BoxFit.cover,
                          width: mq.width * .25,
                          height: mq.width * .25,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${user.lastName} ${user.firstName}',
                        style: TypographyTheme.heading1(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.inversePrimary),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        user.description,
                        style: TypographyTheme.text2(color: Theme.of(context).colorScheme.inversePrimary),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    authService.unFriend(user.id).then((value) => Navigator.pop(context));
                                  });
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: ColorsTheme.white, backgroundColor: ColorsTheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    minimumSize: Size(mq.width, 50)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.person_remove),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Unfriend',
                                      style: TypographyTheme.heading5(color: ColorsTheme.white),
                                    ),
                                  ],
                                ),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                    foregroundColor: ColorsTheme.white, backgroundColor: ColorsTheme.greyLight,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    minimumSize: Size(mq.width, 50)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.person),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Profile',
                                      style: TypographyTheme.heading5(color: ColorsTheme.white),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
