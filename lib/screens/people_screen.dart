import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/layouts/appbar_layout.dart';
import 'package:messenger/layouts/navigator_layout.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/utils/connect_internet_util.dart';
import 'package:messenger/widgets/circular_progress_gradient.dart';
import 'package:provider/provider.dart';

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
      appBar: const AppBarLayout(
        avatarUrl: ImageUrls.avatarDefault,
        iconFirst: FaIcon(
          FontAwesomeIcons.solidAddressBook,
          color: ColorsTheme.black,
          size: 20,
        ),
        title: 'People',
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(color: ColorsTheme.white),
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

                countIsOnline = list.where((item) => item.isOnline == true).length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
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
                                style: TypographyTheme.text2(color: ColorsTheme.black),
                              ),
                            ),
                          );
                        },
                        // children: doubledList.map((item) {
                        //   return Card(
                        //     elevation: 0,
                        //     color: Colors.transparent,
                        //     margin: EdgeInsets.zero,
                        //     child: ListTile(
                        //       onTap: () {},
                        //       contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                        //       leading: Stack(clipBehavior: Clip.none, children: [
                        //         ClipRRect(
                        //           borderRadius: BorderRadius.circular(50),
                        //           child: Image(
                        //             image: NetworkImage(item.avatar.isNotEmpty ? item.avatar : ImageUrls.avatarDefault),
                        //             width: 42,
                        //             height: 42,
                        //             fit: BoxFit.cover,
                        //           ),
                        //         ),
                        //         Positioned(
                        //           bottom: -5,
                        //           right: 0,
                        //           child: Container(
                        //             height: 16,
                        //             width: 16,
                        //             padding: const EdgeInsets.all(3),
                        //             decoration: const BoxDecoration(shape: BoxShape.circle, color: ColorsTheme.white),
                        //             child: Container(
                        //               decoration: const BoxDecoration(
                        //                 shape: BoxShape.circle,
                        //                 color: ColorsTheme.green,
                        //               ),
                        //             ),
                        //           ),
                        //         )
                        //       ]),
                        //       title: Text(
                        //         item.firstName + item.lastName ?? '',
                        //         style: TypographyTheme.text2(color: ColorsTheme.black),
                        //       ),
                        //     ),
                        //   );
                        // }).toList(),
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
