import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/layouts/appbar_layout.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/utils/connect_internet_util.dart';
import 'package:messenger/widgets/list_chat_user.dart';
import 'package:messenger/widgets/search_button_widget.dart';
import 'package:messenger/widgets/slide_friends_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/button_widget.dart';
import 'contacts_screen.dart';

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

                  //get only those user, who's ids are provided
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(child: CircularProgressIndicator());

                      //if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;

                        list = data?.map((e) => ChatUserModel.fromJson(e.data())).toList() ?? [];
                        list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

                        if (list.isNotEmpty) {
                          return ConnectInternetUtil(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SearchButtonWidget(),
                                SlideFriendsWidget(list: list),
                                const SizedBox(height: 8),
                                ListChatUser(list: list, listDoc: data),
                              ],
                            ),
                          );
                        } else {
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
                    }
                  });
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                _addChatUserDialog();
              },
              child: const Icon(Icons.add_comment_rounded),
            ),
          ],
        ),
      ),
    );
  }

  _addChatUserDialog() {
    String email = '';
    final authService = Provider.of<AuthService>(context, listen: false);

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 16)),
                ),

                //add button
                MaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    if (email.isNotEmpty) {
                      await authService.addChatUser(email);
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                )
              ],
            ));
  }
}
