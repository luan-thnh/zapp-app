import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:messenger/api/apis.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/widgets/circular_progress_gradient.dart';
import 'package:messenger/widgets/search_button_widget.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<ChatUserModel> list = [];
  List<ChatUserModel> listFriend = [];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    Size mq = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          title: Text(
            'Contacts',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        body: StreamBuilder(
            stream: authService.getMyUsersId(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressGradient(),
                  );

                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: authService.getSuggestUsers(snapshot.data?.docs.map((e) => e.id).toList() ?? [], APIs.firebaseAuth.currentUser!.uid),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const CircularProgressGradient();

                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;

                          list = data?.map((e) => ChatUserModel.fromJson(e.data())).toList() ?? [];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SearchButtonWidget(),
                              StreamBuilder(
                                  stream: authService.getResquestFriendId(),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                      case ConnectionState.none:
                                        return const Center(
                                          child: CircularProgressGradient(),
                                        );

                                      case ConnectionState.active:
                                      case ConnectionState.done:
                                        return StreamBuilder(
                                            stream: authService.getAllUsers(snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                                            builder: (context, snapshot) {
                                              switch (snapshot.connectionState) {
                                                case ConnectionState.waiting:
                                                case ConnectionState.none:
                                                  return const Center(child: CircularProgressIndicator());

                                                //if some or all data is loaded then show it
                                                case ConnectionState.active:
                                                case ConnectionState.done:
                                                  final data = snapshot.data?.docs;
                                                  listFriend = data?.map((e) => ChatUserModel.fromJson(e.data())).toList() ?? [];

                                                  if (listFriend.isNotEmpty) {
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 20),
                                                          child: Text(
                                                            'Friend requests',
                                                            style: TypographyTheme.text2(color: ColorsTheme.grey),
                                                          ),
                                                        ),
                                                        Column(
                                                          children: listFriend
                                                              .map((user) => Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Theme.of(context).scaffoldBackgroundColor,
                                                                    ),
                                                                    margin: const EdgeInsets.only(left: 20, bottom: 10),
                                                                    child: Row(
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius: BorderRadius.circular(9999),
                                                                          child: Image.network(
                                                                            user.avatar,
                                                                            fit: BoxFit.cover,
                                                                            width: 42,
                                                                            height: 42,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              '${user.lastName} ${user.firstName}',
                                                                              style: TypographyTheme.heading4(
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Theme.of(context).colorScheme.inversePrimary),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: 120,
                                                                                  height: 35,
                                                                                  child: TextButton(
                                                                                    onPressed: () {
                                                                                      authService.addChatUser(user.id);
                                                                                    },
                                                                                    style: TextButton.styleFrom(
                                                                                        primary: ColorsTheme.white,
                                                                                        backgroundColor: ColorsTheme.primary,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(16.0),
                                                                                        ),
                                                                                        minimumSize: Size(mq.width, 50)),
                                                                                    child: Text(
                                                                                      'Accept',
                                                                                      style: TypographyTheme.heading5(color: ColorsTheme.white),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 15,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 120,
                                                                                  height: 35,
                                                                                  child: TextButton(
                                                                                    onPressed: () {
                                                                                      authService.deleteChatUser(user.id);
                                                                                    },
                                                                                    style: TextButton.styleFrom(
                                                                                        primary: ColorsTheme.white,
                                                                                        backgroundColor: ColorsTheme.greyLight,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(16.0),
                                                                                        ),
                                                                                        minimumSize: Size(mq.width, 50),
                                                                                        padding: EdgeInsets.zero),
                                                                                    child: Text(
                                                                                      'Delete',
                                                                                      style: TypographyTheme.heading5(color: ColorsTheme.white),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ))
                                                              .toList(),
                                                        )
                                                      ],
                                                    );
                                                  } else {
                                                    return const SizedBox();
                                                  }
                                              }
                                            });
                                    }
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Suggest',
                                  style: TypographyTheme.text2(color: ColorsTheme.grey),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Expanded(
                                child: GroupedListView(
                                  elements: list,
                                  groupBy: (item) => item.lastName[0].toUpperCase(),
                                  groupComparator: (value1, value2) => value1.compareTo(value2),
                                  itemComparator: (item1, item2) => item1.lastName.compareTo(item2.lastName),
                                  order: GroupedListOrder.ASC,
                                  useStickyGroupSeparators: true,
                                  groupSeparatorBuilder: (String value) => Container(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      value,
                                      style: TypographyTheme.text2(color: ColorsTheme.grey),
                                    ),
                                  ),
                                  itemBuilder: (context, item) {
                                    return ItemUser(user: item);
                                  },
                                ),
                              ),
                            ],
                          );
                      }
                    },
                  );
              }
              ;
            }));
  }
}

class ItemUser extends StatefulWidget {
  final ChatUserModel user;
  const ItemUser({super.key, required this.user});

  @override
  State<ItemUser> createState() => _ItemUserState();
}

class _ItemUserState extends State<ItemUser> {
  bool isAdd = true;

  void _showModalBottomSheet(BuildContext context) async {
    late Size mq = MediaQuery.of(context).size;

    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        final authService = Provider.of<AuthService>(context, listen: false);

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
                        widget.user.avatar,
                        fit: BoxFit.cover,
                        width: mq.width * .25,
                        height: mq.width * .25,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.user.lastName} ${widget.user.firstName}',
                      style: TypographyTheme.heading2(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.user.description,
                      style: TypographyTheme.text2(color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Expanded(
                                child: isAdd
                                    ? TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isAdd = !isAdd;
                                          });
                                          authService.acceptFriendRequest(widget.user.id, false).then((value) => Navigator.pop(context));
                                        },
                                        style: TextButton.styleFrom(
                                            primary: ColorsTheme.white,
                                            backgroundColor: ColorsTheme.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            minimumSize: Size(mq.width, 50)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.person_add),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Add friend',
                                              style: TypographyTheme.heading5(color: ColorsTheme.white),
                                            ),
                                          ],
                                        ),
                                      )
                                    : TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isAdd = !isAdd;
                                            authService.acceptFriendRequest(widget.user.id, true).then((value) => Navigator.pop(context));
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                            primary: ColorsTheme.white,
                                            backgroundColor: ColorsTheme.greyLight,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            minimumSize: Size(mq.width, 50)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.person_remove_alt_1_rounded),
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
                                  primary: ColorsTheme.white,
                                  backgroundColor: ColorsTheme.greyLight,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    late Size mq = MediaQuery.of(context).size;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListTile(
        onLongPress: () {
          _showModalBottomSheet(context);
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: Image.network(
            widget.user.avatar,
            fit: BoxFit.cover,
            width: 42,
            height: 42,
          ),
        ),
        title: Text(
          '${widget.user.lastName} ${widget.user.firstName}',
          style: TypographyTheme.heading4(fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.inversePrimary),
        ),
        subtitle: Container(
          constraints: BoxConstraints(
            maxWidth: mq.width * 0.45,
          ),
          child: Text(
            widget.user.email,
            style: TypographyTheme.text2(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
      ),
    );
  }
}
