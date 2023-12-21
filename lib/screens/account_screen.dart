import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/screens/home_screen.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/utils/dialogs_util.dart';
import 'package:messenger/utils/validate_field_util.dart';
import 'package:messenger/widgets/avatar_widget.dart';
import 'package:messenger/widgets/button_widget.dart';
import 'package:messenger/widgets/input_control_widget.dart';
import 'package:provider/provider.dart';
import '../theme/typography_theme.dart';

final _formKey = GlobalKey<FormState>();

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Size mq;

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
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            height: mq.height,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(mq.height * .1),
                              child: Image.file(File(_image!), width: mq.height * .2, height: mq.height * .2, fit: BoxFit.cover))
                          : AvatarWidget(
                              width: mq.height * .2,
                              height: mq.height * .2,
                              avatarUrl: ImageUrls.avatarDefault,
                            ),
                      Positioned(
                        bottom: 160,
                        right: -10,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: const Icon(Icons.edit, color: Colors.blue),
                        ),
                      )
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
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: mq.height * .01, bottom: mq.height * .07, left: 20, right: 20),
            children: [
              //buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(color: ColorsTheme.lightDark, borderRadius: BorderRadius.circular(999)),
                    child: const SizedBox(
                      width: 40,
                      height: 5,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //pick from gallery button
                  InkWell(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(9999), color: const Color(0xff393A3C)),
                          child: const Padding(
                            padding: EdgeInsets.all(9.0),
                            child: Icon(
                              Icons.image,
                              size: 24,
                              color: ColorsTheme.lightDark,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Choose a profile picture',
                          style: TypographyTheme.heading3(color: ColorsTheme.lightDark),
                        )
                      ],
                    ),
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
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                  //take picture from camera button
                  InkWell(
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
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(9999), color: const Color(0xff393A3C)),
                            child: const Padding(
                              padding: EdgeInsets.all(9.0),
                              child: Icon(
                                Icons.camera_alt,
                                size: 24,
                                color: ColorsTheme.lightDark,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Take a profile picture',
                            style: TypographyTheme.heading3(color: ColorsTheme.lightDark),
                          )
                        ],
                      )),
                ],
              )
            ],
          );
        });
  }
}
