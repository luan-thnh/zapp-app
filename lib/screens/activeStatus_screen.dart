import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/api/apis.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import '../theme/typography_theme.dart';

class ActiveStatusScreen extends StatefulWidget {
  const ActiveStatusScreen({Key? key}) : super(key: key);

  @override
  State<ActiveStatusScreen> createState() => _ActiveStatusScreenState();
}

class _ActiveStatusScreenState extends State<ActiveStatusScreen> {
  bool isActive = true;
  bool isActive_Friend = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
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
            'Active Status',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        body: StreamBuilder(
          stream: APIs.fireStore.collection('users').doc(authService.user.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              ChatUserModel currentUser = ChatUserModel.fromJson(snapshot.data!.data()!);
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Show when you're active", style: Theme.of(context).textTheme.bodyText2),
                          Transform.scale(
                            scale: 0.6,
                            child: CupertinoSwitch(
                              value: isActive,
                              onChanged: (value) {
                                setState(() {
                                  isActive = value;
                                });
                              },
                              activeColor: ColorsTheme.primary,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "Your friends and connections can see when you've been active or recently active on this profile. You can also see this information about them. If you want to change this setting, turn it off every time you use Zapp so that your activity status is no longer visible.",
                              style: TypographyTheme.text3(),
                            ),
                            TextSpan(
                              text: ' Learn more.',
                              style: TypographyTheme.text3(
                                color: ColorsTheme.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'You can still use our service if you turn off activity.',
                        style: TypographyTheme.text3(),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Show up when you're active together", style: Theme.of(context).textTheme.bodyText2),
                          Transform.scale(
                            scale: 0.6,
                            child: CupertinoSwitch(
                              value: isActive_Friend,
                              onChanged: (value) {
                                setState(() {
                                  isActive_Friend = value;
                                });
                              },
                              activeColor: ColorsTheme.primary,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "Your friends and connections can see when you're active with them on Zapp. You can also see when they're active with you. For example, they can see when friends are active together in a chat.",
                              style: TypographyTheme.text3(),
                            ),
                            TextSpan(
                              text: ' Learn more.',
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
