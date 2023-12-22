import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/api/apis.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import '../theme/typography_theme.dart';

class UserNameScreen extends StatefulWidget {
  final ChatUserModel user;

  const UserNameScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  late TextEditingController _userNameController;
  bool isChange = false;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();

    _userNameController.text = widget.user.username;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            'UserName',
            style: TypographyTheme.heading3(),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  if (isChange) {
                    await APIs.fireStore.collection('users').doc(widget.user.id).update({
                      'username': _userNameController.text,
                    });

                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'SAVE',
                  style: TypographyTheme.heading4(color: isChange ? ColorsTheme.primary : ColorsTheme.grey),
                ))
          ],
        ),
        body: StreamBuilder(
          stream: APIs.fireStore.collection('users').doc(authService.user.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              ChatUserModel currentUser = ChatUserModel.fromJson(snapshot.data!.data()!);

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: ColorsTheme.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _userNameController,
                        maxLength: 30,
                        onChanged: (value) {
                          setState(() {
                            isChange = true;
                          });
                        },
                        decoration: InputDecoration(
                          counterText: '${_userNameController.text.length}/30',
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Your username will become part of the custom link. With this link, people can go to your Facebook profile or contact you on Zapp.',
                        style: TypographyTheme.text3(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Need help?',
                              style: TypographyTheme.text3(),
                            ),
                            TextSpan(
                              text: ' See tips for choosing a username.',
                              style: TypographyTheme.text3(
                                color: ColorsTheme.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ));
  }
}
