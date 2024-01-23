import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:messenger/constants/validate.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/models/message_model.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/services/provider/sound_controller.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/utils/format_date_util.dart';
import 'package:messenger/widgets/avatar_widget.dart';
import 'package:messenger/widgets/hero_photo_widget.dart';
import 'package:provider/provider.dart';

class MessageCard extends StatefulWidget {
  final ChatUserModel user;
  final MessageModel message, messageFirst, messageLast;
  final bool hasMessage;
  final List<String> historyTime;
  final File? imageUrl;
  const MessageCard(
      {super.key,
      required this.message,
      required this.user,
      required this.messageFirst,
      required this.messageLast,
      required this.historyTime,
      required this.hasMessage,
      this.imageUrl});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final String? _fromAvatar = widget.user.avatar;
    bool _isContainsIcon = widget.message.message.contains(Validate.emojiRegex);
    bool _checkLastMessage = widget.message.sent == widget.messageLast.sent;
    bool _checkFirstMessage = widget.message.sent == widget.messageFirst.sent;

    return authService.user.uid == widget.message.fromId
        ? _toMessage(_fromAvatar, _checkLastMessage, _checkFirstMessage, _isContainsIcon)
        : _fromMessage(_fromAvatar, _checkLastMessage, _checkFirstMessage, _isContainsIcon);
  }

  Widget _fromMessage(_fromAvatar, _checkLastMessage, _checkFirstMessage, _isContainsIcon) {
    Size mq = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context, listen: false);

    if (widget.message.read.isEmpty) {
      authService.updateMessageReadStatus(widget.message);
    }

    return Column(
      children: [
        if (widget.historyTime.contains(widget.message.sent))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              FormatDateUtil.getLastMessageTime(context, widget.message.sent),
              style: TypographyTheme.text2(color: ColorsTheme.grey),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: mq.width * .03),
              child: _checkLastMessage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Image.network(
                        _fromAvatar,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const SizedBox(width: 32, height: 32),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: mq.width * (_isContainsIcon || Type.image == widget.message.type ? 0 : .04),
                  vertical: mq.height * (_isContainsIcon ? 0 : 0.008)),
              margin: EdgeInsets.symmetric(vertical: mq.width * .004),
              decoration: BoxDecoration(
                color: _isContainsIcon || Type.image == widget.message.type ? Colors.transparent : ColorsTheme.light,
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(24),
                  topLeft: Radius.circular(_checkFirstMessage ? 24 : 8),
                  bottomLeft: Radius.circular(_checkLastMessage ? 24 : 8),
                  bottomRight: const Radius.circular(24),
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: mq.width * .65),
                child: TypeMessage(
                  message: widget.message,
                  isContainsIcon: _isContainsIcon,
                  isTo: false,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _toMessage(_fromAvatar, _checkLastMessage, _checkFirstMessage, _isContainsIcon) {
    Size mq = MediaQuery.of(context).size;
    MessageModel? _lastReadMessage;
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder(
      stream: authService.getLastReadMessage(widget.user),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list = data?.where((e) => e['read'] != '').map((e) => MessageModel.fromJson(e.data())).toList() ?? [];

        if (list.isNotEmpty) _lastReadMessage = list.last;

        return Column(
          children: [
            if (widget.historyTime.contains(widget.message.sent))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  FormatDateUtil.getLastMessageTime(context, widget.message.sent),
                  style: TypographyTheme.text2(color: ColorsTheme.grey),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.symmetric(
                      horizontal: mq.width * (_isContainsIcon || Type.image == widget.message.type ? 0 : .04),
                      vertical: mq.height * (_isContainsIcon ? 0 : 0.008)),
                  margin: EdgeInsets.symmetric(vertical: mq.width * 0.004),
                  decoration: BoxDecoration(
                    color: _isContainsIcon || widget.message.type == Type.image ? Colors.transparent : ColorsTheme.primary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(_checkFirstMessage ? 24 : 8),
                      topLeft: const Radius.circular(24),
                      bottomLeft: const Radius.circular(24),
                      bottomRight: Radius.circular(_checkLastMessage ? 24 : 8),
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: mq.width * .65,
                    ),
                    child: TypeMessage(
                      message: widget.message,
                      isContainsIcon: _isContainsIcon,
                      isTo: true,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: mq.width * .03),
                  child: _lastReadMessage != null && _lastReadMessage!.read == widget.message.read
                      ? AvatarWidget(
                          width: 14,
                          height: 14,
                          avatarUrl: _fromAvatar,
                        )
                      : widget.message.read.isEmpty
                          ? FaIcon(
                              widget.user.isOnline ? FontAwesomeIcons.solidCircleCheck : FontAwesomeIcons.circleCheck,
                              size: 14,
                              color: ColorsTheme.primary,
                            )
                          : const SizedBox(width: 14, height: 14),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class TypeMessage extends StatefulWidget {
  final MessageModel message;
  final bool isTo, isContainsIcon;
  const TypeMessage({super.key, required this.message, required this.isTo, required this.isContainsIcon});

  @override
  State<TypeMessage> createState() => _TypeMessageState();
}

class _TypeMessageState extends State<TypeMessage> {
  bool isPlaying = false;
  late Duration remainingDuration;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 0), () {});
    remainingDuration = parseDuration(widget.message.duration);
  }

  Duration parseDuration(String durationString) {
    List<String> parts = durationString!.split(":");
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2].split(".")[0]),
      milliseconds: int.parse(parts[2].split(".")[1]),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startCountdown() {
    const oneSecond = Duration(seconds: 1);

    timer = Timer.periodic(oneSecond, (Timer timer) {
      if (remainingDuration.inSeconds > 0) {
        setState(() {
          remainingDuration -= oneSecond;
        });
      } else {
        setState(() {
          isPlaying = false;
          timer.cancel();
          remainingDuration = parseDuration(widget.message.duration);
        });
      }
    });
  }

  void togglePlayback(soundController) {
    if (isPlaying) {
      soundController.playSound(widget.message.message);
      startCountdown();
    } else {
      soundController.stopSound();
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    final soundController = context.watch<SoundController>();

    // TEXT
    if (widget.message.type == Type.text) {
      return Text(
        widget.message.message,
        textAlign: widget.isContainsIcon ? (widget.isTo ? TextAlign.end : TextAlign.start) : TextAlign.start,
        style: widget.isContainsIcon
            ? const TextStyle(fontSize: 24, letterSpacing: 0)
            : TypographyTheme.text1(color: widget.isTo ? ColorsTheme.white : ColorsTheme.black),
      );
    }

    // IMAGE
    if (widget.message.type == Type.image) {
      return Center(
          child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HeroPhotoWidget(
                imageProvider: NetworkImage(
                  widget.message.message,
                ),
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Hero(
            tag: "someTag",
            child: Image.network(
              widget.message.message,
              loadingBuilder: (_, child, chunk) => chunk != null
                  ? CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ColorsTheme.primary.withOpacity(.6),
                    )
                  : child,
            ),
          ),
        ),
      ));
      // return SizedBox(
      //   width: 300,
      //   height: 300,
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(10),
      //     child: GalleryExampleItemThumbnail(
      //       galleryExampleItem: galleryItems[0],
      //       onTap: () {
      //         open(context, 0);
      //       },
      //     ),
      // child: PhotoView(
      //   imageProvider: NetworkImage(widget.message.message),
      //
      // ),
      // child: CachedNetworkImage(
      //   imageUrl: widget.message.message,
      //   fit: BoxFit.cover,
      //   placeholder: (context, url) {
      //     return Container(
      //       color: ColorsTheme.light,
      //       height: mq.height * .4,
      //       child: Center(
      //         child: Stack(
      //           alignment: Alignment.center,
      //           children: [
      //             const FaIcon(
      //               FontAwesomeIcons.image,
      //               color: ColorsTheme.lightDark,
      //               size: 70,
      //             ),
      //             Positioned(
      //                 child: CircularProgressIndicator(
      //               strokeWidth: 2,
      //               color: ColorsTheme.primary.withOpacity(.6),
      //             ))
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      //   errorWidget: (context, url, error) => const FaIcon(
      //     FontAwesomeIcons.image,
      //     size: 70,
      //   ),
      // ),
      // ),
      // );
    }

    // AUDIO
    if (widget.message.type == Type.audio) {
      return InkWell(
        onTap: () {
          setState(() {
            isPlaying = !isPlaying;
          });

          togglePlayback(soundController);
        },
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play, color: ColorsTheme.white, size: 18),
              const SizedBox(width: 16),
              const SizedBox(
                width: 18,
                height: 18,
                child: LoadingIndicator(
                  indicatorType: Indicator.lineScalePulseOutRapid,
                  colors: [ColorsTheme.white],
                  strokeWidth: 2,
                  backgroundColor: Colors.transparent,
                  pathBackgroundColor: ColorsTheme.white,
                ),
              ),
              const SizedBox(width: 2),
              const SizedBox(
                width: 18,
                height: 18,
                child: LoadingIndicator(
                  indicatorType: Indicator.lineScalePulseOutRapid,
                  colors: [ColorsTheme.white],
                  strokeWidth: 2,
                  backgroundColor: Colors.transparent,
                  pathBackgroundColor: ColorsTheme.white,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${FormatDateUtil.formatDurationTime(remainingDuration)}',
                style: TypographyTheme.text3(color: ColorsTheme.white),
              )
            ],
          ),
        ),
      );
    }

    return Container();
  }
}
