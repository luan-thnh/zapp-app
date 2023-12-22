import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/widgets/avatar_widget.dart';
import 'package:messenger/widgets/icon_button_widget.dart';
import 'package:provider/provider.dart';
import '../theme/typography_theme.dart';

class AccountScreen extends StatefulWidget {
  final ChatUserModel user;
  const AccountScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Size mq;

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
              children: [Text('Dark mode', style: TypographyTheme.text1()), Text('off', style: TypographyTheme.text3())],
            ),
            "onTap": () {}
          },
          {
            "icon": const IconButtonWidget(
              icon: Icon(Icons.ac_unit_rounded, color: Colors.white, size: 23),
              bgColor: ColorsTheme.green,
            ),
            "title": Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Active Status', style: TypographyTheme.text1()),
                widget.user.isOnline ? Text('on', style: TypographyTheme.text3()) : Text('off', style: TypographyTheme.text3()),
              ],
            ),
            "onTap": () {}
          },
          {
            "icon": const IconButtonWidget(
              icon: FaIcon(FontAwesomeIcons.at, color: ColorsTheme.white, size: 23),
              bgColor: ColorsTheme.red,
            ),
            "title": Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username', style: TypographyTheme.text1()),
                Text('m.me/${widget.user.username}', style: TypographyTheme.text3()),
              ],
            ),
            "onTap": () {}
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
            "title": Text('Supervise', style: TypographyTheme.text1()),
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
            "title": Text('Orders', style: TypographyTheme.text1()),
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
            "title": Text('Avatar', style: TypographyTheme.text1()),
            "onTap": () {}
          },
          {
            "icon": const IconButtonWidget(
              icon: FaIcon(FontAwesomeIcons.solidBell, color: ColorsTheme.white, size: 21),
              bgColor: ColorsTheme.purple,
            ),
            "title": Text('Notifications and sounds', style: TypographyTheme.text1()),
            "onTap": () {}
          },
          {
            "icon": const IconButtonWidget(
              icon: FaIcon(FontAwesomeIcons.houseLock, size: 18, color: ColorsTheme.white),
              bgColor: Colors.lightBlueAccent,
            ),
            "title": Text('Privacy and safety', style: TypographyTheme.text1()),
            "onTap": () {}
          },
          {
            "icon": const IconButtonWidget(
              icon: FaIcon(FontAwesomeIcons.shield, size: 21, color: ColorsTheme.white),
              bgColor: ColorsTheme.blueDark,
            ),
            "title": Text('Data saver', style: TypographyTheme.text1()),
            "onTap": () {}
          },
          {
            "icon": const IconButtonWidget(
              icon: FaIcon(FontAwesomeIcons.solidImage, size: 18, color: ColorsTheme.white),
              bgColor: ColorsTheme.purple,
            ),
            "title": Text('Photos & media', style: TypographyTheme.text1()),
            "onTap": () {}
          },
          {
            "icon": const IconButtonWidget(
              icon: FaIcon(FontAwesomeIcons.solidMessage, size: 18, color: ColorsTheme.white),
              bgColor: ColorsTheme.green,
            ),
            "title": Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Chat bubbles', style: TypographyTheme.text1()),
                  Switch(
                      value: isSwitched,
                      onChanged: (value) => {
                            setState(() {
                              isSwitched = value;
                            }),
                          },
                      activeColor: ColorsTheme.white,
                      activeTrackColor: ColorsTheme.primary,
                      inactiveThumbColor: ColorsTheme.grey,
                      inactiveTrackColor: ColorsTheme.white),
                ],
              ),
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
            "title": Text('Update', style: TypographyTheme.text1()),
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
            "title": Text('Report a disciplinary incident', style: TypographyTheme.text1()),
            "onTap": () {}
          },
          {
            "icon": const IconButtonWidget(
              icon: FaIcon(FontAwesomeIcons.solidCircleQuestion, color: Colors.white, size: 21),
              bgColor: Colors.lightBlueAccent,
            ),
            "title": Text('Help', style: TypographyTheme.text1()),
            "onTap": () {}
          },
          {
            "icon": const IconButtonWidget(
              icon: FaIcon(FontAwesomeIcons.solidFileLines, color: Colors.white, size: 21),
              bgColor: ColorsTheme.grey,
            ),
            "title": Text('Legal & policy', style: TypographyTheme.text1()),
            "onTap": () {}
          },
        ]
      },
    ];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            color: ColorsTheme.white,
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
                            avatarUrl: widget.user.avatar,
                          ),
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: Container(
                        padding: const EdgeInsets.all(0.1),
                        decoration: BoxDecoration(color: ColorsTheme.white, borderRadius: BorderRadius.circular(999)),
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: const CircleBorder(),
                          color: const Color(0xF8F3F3FF),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
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
                Text(
                  widget.user.username,
                  style: TypographyTheme.heading1(),
                ),
                TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Write a description',
                      style: TextStyle(color: ColorsTheme.blue),
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
                              color: Colors.white,
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
                        style: TypographyTheme.heading4(),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Manage account settings and connected experiences across Meta technologies',
                        style: TypographyTheme.text2(),
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
                            style: TypographyTheme.text2(),
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
                            style: TypographyTheme.text2(),
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
                Expanded(
                  flex: 5,
                  child: Container(),
                )
              ],
            ),
          ),
        ));
  }

  void _showBottomSheet() {
    final authService = Provider.of<AuthService>(context, listen: false);

    showModalBottomSheet(
        backgroundColor: const Color(0xff242527),
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return Container(
            constraints: BoxConstraints(maxHeight: mq.height * 0.5),
            decoration: const BoxDecoration(
                color: ColorsTheme.white,
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
                      color: ColorsTheme.white,
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
                          style: TypographyTheme.text1(),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      color: ColorsTheme.white,
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
                            style: TypographyTheme.text1(),
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
