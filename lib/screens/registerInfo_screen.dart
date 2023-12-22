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

class RegisterInfoScreen extends StatefulWidget {
  const RegisterInfoScreen({Key? key}) : super(key: key);

  @override
  State<RegisterInfoScreen> createState() => _RegisterInfoScreenState();
}

class _RegisterInfoScreenState extends State<RegisterInfoScreen> {
  late Size mq;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _birthdayController;
  late TextEditingController _descriptionController;
  late String _gender;
  String? _image;

  @override
  void initState() {
    super.initState();
    _birthdayController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _descriptionController = TextEditingController();

    _gender = 'Male';
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  final DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2024),
      helpText: 'Select My Birthday',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(primaryColor: ColorsTheme.primary),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _birthdayController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: InputControlWidget(
                                  controller: _firstNameController,
                                  obscureText: false,
                                  hintText: 'First name',
                                  validator: ValidateFieldUtil.validateFirstName,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputControlWidget(
                                  controller: _lastNameController,
                                  obscureText: false,
                                  hintText: 'Last name',
                                  validator: ValidateFieldUtil.validateLastName,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'My birthday:',
                            style: TypographyTheme.heading4(),
                          ),
                          InputControlWidget(
                            controller: _birthdayController,
                            obscureText: false,
                            hintText: 'dd/mm/yyyy',
                            validator: ValidateFieldUtil.validateBirthday,
                            onTap: () => _selectDate(context),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'My Gender:',
                            style: TypographyTheme.heading4(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                value: 'Male',
                                groupValue: _gender,
                                activeColor: ColorsTheme.primary,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value.toString();
                                    // authService.me.gender = value.toString();
                                  });
                                },
                              ),
                              const Text(
                                'Male',
                                style: TextStyle(fontSize: 17),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Radio(
                                value: 'Female',
                                groupValue: _gender,
                                activeColor: ColorsTheme.primary,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value.toString();
                                    // authService.me.gender = value.toString();
                                  });
                                },
                              ),
                              const Text(
                                'Female',
                                style: TextStyle(fontSize: 17),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Radio(
                                value: 'Other',
                                groupValue: _gender,
                                activeColor: ColorsTheme.primary,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value.toString();
                                    // authService.me.gender = value.toString();
                                  });
                                },
                              ),
                              const Text(
                                'Other',
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          ButtonWidget(
                            disable: false,
                            text: 'Create New Account',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                authService
                                    .updateUserInfo(_firstNameController.text, _lastNameController.text, _birthdayController.text, _gender)
                                    .then((value) {
                                  DialogsUtil.showSnackBar(context, 'Profile Updated Successfully!', true);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _showBottomSheet() {
    final authService = Provider.of<AuthService>(context, listen: false);

    showModalBottomSheet(
        context: context,
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
                    SizedBox(
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
                        leading: Icon(
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
                          leading: Icon(
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
