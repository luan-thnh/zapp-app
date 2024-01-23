import 'package:flutter/material.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/widgets/avatar_widget.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final double coverHeight = 240;
  final double profileHeight = 144;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: ColorsTheme.primary,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent(),
          SizedBox(
            height: 20,
          ),
          buildListFriend(),
          SizedBox(
            height: 10,
          ),
          buildListFriends(),
          SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }

  Widget buildTop() {
    final top = coverHeight - profileHeight / 3;
    final bottom = profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: 150.0,
          // Other Positioned properties
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 20),
            child: buildProfileImage(),
          ),
        ),
      ],
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.user.firstName} ${widget.user.lastName}  ',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          // username
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 20,
              ),
              SizedBox(width: 4), // Add some spacing between the icon and the text
              Text(
                '${widget.user.username} ',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          // date of birth
          Row(
            children: [
              Icon(
                Icons.date_range,
                size: 20,
              ),
              SizedBox(width: 4), // Add some spacing between the icon and the text
              Text(
                '01/01/2002',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          // gender
          Row(
            children: [
              Icon(
                Icons.transgender,
                size: 20,
              ),
              SizedBox(width: 4), // Add some spacing between the icon and the text
              Text(
                'Female ',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          // Button add friend ,messenger
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FilledButton.tonal(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Friend',
                        style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 4),
              Container(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorsTheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Chat',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FilledButton.tonal(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.more_horiz_outlined,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ],
                  ),
                ),
              ),
              // Add more widgets or rows here if needed
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.network(
          'https://th.bing.com/th/id/R.6af6fd9c37f0de4abb34ea0fd20acce3?rik=55mqMmrTutVR0Q&pid=ImgRaw&r=0',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage() => Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.tertiary,
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(70),
        ),
        child: AvatarWidget(
          width: 136, // Nếu muốn giữ khoảng trắng của viền
          height: 136, // Nếu muốn giữ khoảng trắng của viền
          avatarUrl: '${widget.user.avatar}',
        ),
      );
  Widget buildListFriend() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 12),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
              color: ColorsTheme.grey,
            ))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Friends',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '12 mutual friends',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      );
  Widget buildListFriends() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), // Set your desired border radius here
                      color: Colors.grey, // You can set a placeholder color if the image fails to load
                    ),
                    child: Image.network(
                      'https://demoda.vn/wp-content/uploads/2022/02/anh-anh-da-den-cuoi.jpg',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Text(
                    'Anh Da den',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), // Set your desired border radius here
                      color: Colors.grey, // You can set a placeholder color if the image fails to load
                    ),
                    child: Image.network(
                      'https://demoda.vn/wp-content/uploads/2022/02/anh-anh-da-den-cuoi.jpg',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Text(
                    'Anh Da den',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), // Set your desired border radius here
                      color: Colors.grey, // You can set a placeholder color if the image fails to load
                    ),
                    child: Image.network(
                      'https://demoda.vn/wp-content/uploads/2022/02/anh-anh-da-den-cuoi.jpg',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Text(
                    'Anh Da den',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), // Set your desired border radius here
                      color: Colors.grey, // You can set a placeholder color if the image fails to load
                    ),
                    child: Image.network(
                      'https://demoda.vn/wp-content/uploads/2022/02/anh-anh-da-den-cuoi.jpg',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Text(
                    'Anh Da den',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), // Set your desired border radius here
                      color: Colors.grey, // You can set a placeholder color if the image fails to load
                    ),
                    child: Image.network(
                      'https://demoda.vn/wp-content/uploads/2022/02/anh-anh-da-den-cuoi.jpg',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Text(
                    'Anh Da den',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), // Set your desired border radius here
                      color: Colors.grey, // You can set a placeholder color if the image fails to load
                    ),
                    child: Image.network(
                      'https://demoda.vn/wp-content/uploads/2022/02/anh-anh-da-den-cuoi.jpg',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Text(
                    'Anh Da den',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}
