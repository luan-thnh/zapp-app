import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/api/apis.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/screens/activeStatus_screen.dart';
import 'package:messenger/screens/dark_mode_screen.dart';
import 'package:messenger/screens/userName_screen.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/widgets/avatar_widget.dart';
import 'package:messenger/widgets/icon_button_widget.dart';
import 'package:provider/provider.dart';
import '../theme/typography_theme.dart';
import '../utils/dialogs_util.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Size mq;

  bool isDark = false;
  bool isSwitched = false;
  String? _image;

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
    mq = MediaQuery.of(context).size;

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
            'Me',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        body: StreamBuilder(
            stream: APIs.fireStore.collection('users').doc(authService.user.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                ChatUserModel currentUser = ChatUserModel.fromJson(snapshot.data!.data()!);

                List<Map<String, List<Map<String, dynamic>>>> activeList = [
                  {
                    "Profile": [
                      {
                        "icon": const IconButtonWidget(
                          icon: Icon(Icons.dark_mode_sharp, color: Colors.white, size: 23),
                          bgColor: ColorsTheme.black,
                        ),
                        "title": Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dark mode', style: Theme.of(context).textTheme.bodyLarge),
                            Text(
                              'off',
                              style: TypographyTheme.text3(),
                            ),
                          ],
                        ),
                        "onTap": () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DarkModeScreen(),
                            ),
                          );
                        }
                      },
                      {
                        "icon": const IconButtonWidget(
                          icon: Icon(Icons.ac_unit_rounded, color: Colors.white, size: 23),
                          bgColor: ColorsTheme.green,
                        ),
                        "title": Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Active Status', style: Theme.of(context).textTheme.bodyLarge),
                            currentUser.isOnline ? Text('on', style: TypographyTheme.text3()) : Text('off', style: TypographyTheme.text3()),
                          ],
                        ),
                        "onTap": () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ActiveStatusScreen()));
                        }
                      },
                      {
                        "icon": const IconButtonWidget(
                          icon: FaIcon(FontAwesomeIcons.at, color: ColorsTheme.white, size: 23),
                          bgColor: ColorsTheme.red,
                        ),
                        "title": Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Username', style: Theme.of(context).textTheme.bodyLarge),
                            Text('m.me/${currentUser.username}', style: TypographyTheme.text3()),
                          ],
                        ),
                        "onTap": () {
                          _showBottomUser(currentUser);
                        }
                      },
                    ]
                  },
                  {
                    "For families": [
                      {
                        "icon": const IconButtonWidget(
                          icon: FaIcon(FontAwesomeIcons.userGroup, size: 16, color: ColorsTheme.white),
                          bgColor: ColorsTheme.blue,
                        ),
                        "title": Text('Supervise', style: Theme.of(context).textTheme.bodyLarge),
                        "onTap": () {}
                      },
                    ]
                  },
                  {
                    "Service": [
                      {
                        "icon": const IconButtonWidget(
                          icon: FaIcon(FontAwesomeIcons.suitcase, size: 19, color: ColorsTheme.white),
                          bgColor: ColorsTheme.green,
                        ),
                        "title": Text('Orders', style: Theme.of(context).textTheme.bodyLarge),
                        "onTap": () {}
                      }
                    ]
                  },
                  {
                    "Options": [
                      {
                        "icon": const IconButtonWidget(
                          icon: Icon(Icons.person, color: Colors.white, size: 26),
                          bgColor: ColorsTheme.purple,
                        ),
                        "title": Text('Avatar', style: Theme.of(context).textTheme.bodyLarge),
                        "onTap": () {}
                      },
                      {
                        "icon": const IconButtonWidget(
                          icon: FaIcon(FontAwesomeIcons.solidBell, color: ColorsTheme.white, size: 21),
                          bgColor: ColorsTheme.purple,
                        ),
                        "title": Text('Notifications and sounds', style: Theme.of(context).textTheme.bodyLarge),
                        "onTap": () {}
                      },
                      {
                        "icon": const IconButtonWidget(
                          icon: FaIcon(FontAwesomeIcons.houseLock, size: 18, color: ColorsTheme.white),
                          bgColor: Colors.lightBlueAccent,
                        ),
                        "title": Text('Privacy and safety', style: Theme.of(context).textTheme.bodyLarge),
                        "onTap": () {}
                      },
                      {
                        "icon": const IconButtonWidget(
                          icon: FaIcon(FontAwesomeIcons.shield, size: 21, color: ColorsTheme.white),
                          bgColor: ColorsTheme.blueDark,
                        ),
                        "title": Text('Data saver', style: Theme.of(context).textTheme.bodyLarge),
                        "onTap": () {}
                      },
                      {
                        "icon": const IconButtonWidget(
                          icon: FaIcon(FontAwesomeIcons.solidImage, size: 18, color: ColorsTheme.white),
                          bgColor: ColorsTheme.purple,
                        ),
                        "title": Text('Photos & media', style: Theme.of(context).textTheme.bodyLarge),
                        "onTap": () {}
                      },
                      {
                        "icon": const IconButtonWidget(
                          icon: FaIcon(FontAwesomeIcons.solidMessage, size: 18, color: ColorsTheme.white),
                          bgColor: ColorsTheme.green,
                        ),
                        "title": Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Chat bubbles', style: Theme.of(context).textTheme.bodyLarge),
                            Transform.scale(
                              scale: 0.6,
                              child: CupertinoSwitch(
                                value: isSwitched,
                                onChanged: (value) => {
                                  setState(() {
                                    isSwitched = value;
                                  }),
                                },
                                activeColor: ColorsTheme.primary,
                              ),
                            )
                          ],
                        ),
                        "onTap": () {
                          setState(() {
                            isSwitched = !isSwitched;
                          });
                        }
                      },
                      {
                        "icon": const IconButtonWidget(
                          icon: FaIcon(FontAwesomeIcons.download, size: 19, color: ColorsTheme.white),
                          bgColor: Colors.lightBlueAccent,
                        ),
                        "title": Text('Update', style: Theme.of(context).textTheme.bodyLarge),
                        "onTap": () {}
                      },
                    ]
                  },
                  {
                    "Safety": [
                      {
                        "icon": const IconButtonWidget(
                          icon: FaIcon(FontAwesomeIcons.triangleExclamation, color: Colors.white, size: 21),
                          bgColor: ColorsTheme.red,
                        ),
                        "title": Text('Report a disciplinary incident', style: Theme.of(context).textTheme.bodyLarge),
                        "onTap": () {}
                      },
                      {
                        "icon": const IconButtonWidget(
                          icon: FaIcon(FontAwesomeIcons.solidCircleQuestion, color: Colors.white, size: 21),
                          bgColor: Colors.lightBlueAccent,
                        ),
                        "title": Text('Help', style: Theme.of(context).textTheme.bodyLarge),
                        "onTap": () {}
                      },
                      {
                        "icon": const IconButtonWidget(
                          icon: FaIcon(FontAwesomeIcons.solidFileLines, color: Colors.white, size: 21),
                          bgColor: ColorsTheme.grey,
                        ),
                        "title": Text('Legal & policy', style: Theme.of(context).textTheme.bodyLarge),
                        "onTap": () {}
                      },
                    ]
                  },
                ];
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(mq.height * .1),
                                  child: Image.file(File(_image!), width: mq.height * .12, height: mq.height * .12, fit: BoxFit.cover))
                              : AvatarWidget(
                                  width: mq.height * .12,
                                  height: mq.height * .12,
                                  avatarUrl: currentUser.avatar,
                                ),
                          Positioned(
                            bottom: -5,
                            right: -5,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: IconButtonWidget(
                                onPressed: () {
                                  _showBottomSheet();
                                },
                                bgColor: Theme.of(context).colorScheme.secondary,
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Text(
                            '${currentUser.firstName} ${currentUser.lastName}',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'Write a description',
                            style: TextStyle(color: ColorsTheme.primary),
                          )),
                      const SizedBox(
                        height: 35,
                      ),
                      Column(
                        children: activeList.map((itemActive) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Text(itemActive.keys.first, style: TypographyTheme.text1(color: ColorsTheme.grey)),
                              ),
                              Column(
                                children: itemActive.values.first.map((item) {
                                  return Card(
                                    elevation: 0,
                                    child: ListTile(
                                      onTap: item['onTap'],
                                      leading: item['icon'],
                                      title: item['title'],
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60, bottom: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                              image: const AssetImage(ImageUrls.metaLogo),
                              width: mq.width * 0.15,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Account Center',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Manage account settings and connected experiences across Meta technologies',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.solidUser,
                                  color: ColorsTheme.black,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Personal information',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.shield,
                                  color: ColorsTheme.black,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  'Passwords and security',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text(
                                  'View information in the financial center',
                                  style: TextStyle(color: ColorsTheme.blue),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            }));
  }

  void _showBottomUser(user) {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return Container(
            constraints: BoxConstraints(maxHeight: mq.height * 0.5),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
            )),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: mq.height * .01, bottom: mq.height * .07),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: ColorsTheme.grey, borderRadius: BorderRadius.circular(999)),
                      child: const SizedBox(
                        width: 32,
                        height: 3,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      elevation: 0,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: ListTile(
                        title: Text(
                          style: Theme.of(context).textTheme.bodyLarge,
                          'm.me/${user.username}',
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => UserNameScreen(
                                        user: user,
                                      )));
                        },
                        leading: const Icon(
                          Icons.person,
                          size: 30,
                          color: ColorsTheme.blackGray,
                        ),
                        title: Text(
                          'Edit your username',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      child: ListTile(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: user.userName)).then((value) {
                            Navigator.pop(context);
                            DialogsUtil.showSnackBar(context, 'UserName Copied!', true);
                          });
                        },
                        leading: const Icon(
                          Icons.copy,
                          size: 25,
                          color: ColorsTheme.blackGray,
                        ),
                        title: Text(
                          'Copy link',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  void _showBottomSheet() {
    final authService = Provider.of<AuthService>(context, listen: false);

    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return Container(
            constraints: BoxConstraints(maxHeight: mq.height * 0.5),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
            )),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: mq.height * .01, bottom: mq.height * .07),
              children: [
                //buttons
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: ColorsTheme.grey, borderRadius: BorderRadius.circular(999)),
                      child: const SizedBox(
                        width: 32,
                        height: 3,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //pick from gallery button
                    Card(
                      elevation: 0,
                      child: ListTile(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();

                          // Pick an image
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                          if (image != null) {
                            setState(() {
                              _image = image.path;
                            });
                            authService.updateProfilePicture(File(_image!));
                            // for hiding bottom sheet
                            Navigator.pop(context);
                          }
                        },
                        leading: const Icon(
                          Icons.image,
                          size: 25,
                          color: ColorsTheme.blackGray,
                        ),
                        title: Text(
                          'Choose a profile picture',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      child: ListTile(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();

                            // Pick an image
                            final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                            if (image != null) {
                              setState(() {
                                _image = image.path;
                              });

                              authService.updateProfilePicture(File(_image!));

                              // for hiding bottom sheet
                              Navigator.pop(context);
                            }
                          },
                          leading: const Icon(
                            Icons.camera_alt,
                            size: 25,
                            color: ColorsTheme.blackGray,
                          ),
                          title: Text(
                            'Take a profile picture',
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
