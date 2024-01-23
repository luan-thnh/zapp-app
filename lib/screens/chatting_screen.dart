import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:messenger/api/apis.dart';
import 'package:messenger/main.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/models/message_model.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:messenger/services/provider/gallery_controller.dart';
import 'package:messenger/services/provider/sound_controller.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/utils/format_date_util.dart';
import 'package:messenger/utils/group_messages_util.dart';
import 'package:messenger/widgets/avatar_widget.dart';
import 'package:messenger/widgets/gallery_item_widget.dart';
import 'package:messenger/widgets/gradient_text.dart';
import 'package:messenger/widgets/icon_button_widget.dart';
import 'package:messenger/widgets/message_card.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ChattingScreen extends StatefulWidget {
  final ChatUserModel user;
  const ChattingScreen({super.key, required this.user});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  bool _isInputFocused = false;
  bool _hasMessage = false;
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  List<MessageModel> _messages = [];
  List<GroupedMessages> _groupedMessages = [];
  List<String> _historyTime = [];
  bool showEmoji = false;
  bool showPhotos = false;
  bool isUploading = false;
  Emoji emojiMain = const Emoji('like', '👍');
  File? imageUrl;
  List<AssetEntity> _imageList = [];

  @override
  void initState() {
    super.initState();

    _requestPermissionAndLoadImages();

    _focusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        scrollToBottom();
      });
    });
  }

  Future<void> _requestPermissionAndLoadImages() async {
    PermissionStatus status = await Permission.photos.status;

    if (status.isGranted) {
      await _loadImages();
    } else if (status.isDenied || status.isRestricted) {
      bool showRationale = await Permission.photos.shouldShowRequestRationale;

      if (showRationale) {}

      PermissionState requestResult = await PhotoManager.requestPermissionExtend();

      if (requestResult.isAuth) {
        await _loadImages();
      }
    } else if (status.isPermanentlyDenied) {}
  }

  Future<void> _loadImages() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    if (albums.isNotEmpty) {
      List<AssetEntity> images = await albums[0].getAssetListRange(start: 0, end: albums[0].assetCount);
      setState(() {
        _imageList = images;
      });
    }
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() => _isInputFocused = _focusNode.hasFocus);
    }
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final SoundController soundController = context.watch();
    Size mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (showEmoji) setState(() => showEmoji = !showEmoji);
        if (showPhotos) setState(() => showPhotos = !showPhotos);
      },
      child: WillPopScope(
        onWillPop: () {
          if (showEmoji) {
            setState(() => showEmoji = !showEmoji);
            return Future.value(false);
          }

          if (showPhotos) {
            setState(() => showPhotos = !showPhotos);
            return Future.value(false);
          }

          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          body: Container(
            margin: EdgeInsets.only(bottom: !isThreeButtonNavigation && !showEmoji ? 32 : 0),
            child: Stack(
              children: [
                SizedBox(
                  height: mq.height * (showPhotos ? (isThreeButtonNavigation ? .63 : .61) : 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: authService.findAllMessages(widget.user),
                          builder: (context, snapshot) {
                            final data = snapshot.data?.docs;

                            _messages = data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];

                            if (_messages.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AvatarWidget(width: mq.width * .3, height: mq.width * .3, avatarUrl: widget.user.avatar),
                                    const SizedBox(height: 16),
                                    Text('${widget.user.firstName} ${widget.user.lastName}', style: Theme.of(context).textTheme.displayMedium),
                                    GradientText(
                                      'Zapp',
                                      style: TypographyTheme.heading4(),
                                      gradient: const LinearGradient(colors: [ColorsTheme.purple, ColorsTheme.pink]),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: mq.width * .6,
                                      child: Text(
                                        'Let\'s start sharing interesting stories together',
                                        textAlign: TextAlign.center,
                                        style: TypographyTheme.text2(color: ColorsTheme.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            _groupedMessages.clear();
                            _groupedMessages = GroupMessagesUtil.group(_messages);

                            _historyTime.clear();
                            _historyTime = GroupMessagesUtil.historyTime(_messages);
                            return Container(
                              alignment: Alignment.bottomCenter,
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: _groupedMessages.length + 2,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    // This is the index for the new widget
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 32),
                                        AvatarWidget(width: mq.width * .3, height: mq.width * .3, avatarUrl: widget.user.avatar),
                                        const SizedBox(height: 16),
                                        Text('${widget.user.firstName} ${widget.user.lastName}', style: Theme.of(context).textTheme.displayMedium),
                                        GradientText(
                                          'Zapp',
                                          style: TypographyTheme.heading4(),
                                          gradient: const LinearGradient(colors: [ColorsTheme.purple, ColorsTheme.pink]),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: mq.width * .6,
                                          child: Text(
                                            'Let\'s start sharing interesting stories together',
                                            textAlign: TextAlign.center,
                                            style: TypographyTheme.text2(color: ColorsTheme.grey),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (index < _groupedMessages.length + 1) {
                                    // This is for your existing messages
                                    GroupedMessages group = _groupedMessages[index - 1];
                                    MessageModel messageFirst = group.messages.first;
                                    MessageModel messageLast = group.messages.last;

                                    return Column(
                                      children: group.messages
                                          .map(
                                            (message) => MessageCard(
                                              message: message,
                                              messageFirst: messageFirst,
                                              messageLast: messageLast,
                                              historyTime: _historyTime,
                                              hasMessage: _hasMessage,
                                              imageUrl: imageUrl,
                                              user: widget.user,
                                            ),
                                          )
                                          .toList(),
                                    );
                                  } else {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        if (isUploading)
                                          Transform.scale(
                                            scale: .3,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                                              child: const CircularProgressIndicator(
                                                strokeWidth: 3,
                                                color: ColorsTheme.primary,
                                              ),
                                            ),
                                          ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            if (_hasMessage && authService.user.uid == widget.user.id)
                                              Container(
                                                margin: EdgeInsets.symmetric(horizontal: mq.width * .03),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(999),
                                                  child: Image.network(
                                                    widget.user.avatar,
                                                    width: 32,
                                                    height: 32,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            if (_hasMessage && authService.user.uid == widget.user.id)
                                              SizedBox(
                                                width: 24,
                                                child: LoadingIndicator(
                                                  indicatorType: Indicator.ballPulse,
                                                  colors: [ColorsTheme.black.withOpacity(.4)],
                                                  strokeWidth: 5,
                                                  backgroundColor: Colors.transparent,
                                                  pathBackgroundColor: ColorsTheme.black,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),

                      // display chat input
                      Offstage(
                        offstage: soundController.isRecording,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: _chatInput(),
                        ),
                      ),

                      // show voice record
                      Offstage(
                        offstage: !soundController.isRecording,
                        child: _voiceRecord(),
                      ),

                      // show emoji picker
                      Offstage(
                        offstage: !showEmoji,
                        child: SizedBox(
                          height: mq.height * .35,
                          child: EmojiPicker(
                            textEditingController: _textEditingController,
                            onEmojiSelected: (Category? category, Emoji emoji) {
                              setState(() {
                                _hasMessage = true;
                                _isInputFocused = true;
                              });
                            },
                            config: Config(
                              columns: 7,
                              emojiSizeMax: 28 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
                              bgColor: Theme.of(context).scaffoldBackgroundColor,
                              initCategory: Category.SMILEYS,
                              indicatorColor: ColorsTheme.primary,
                              iconColorSelected: ColorsTheme.primary,
                            ),
                          ),
                        ),
                      ),

                      // // show list image
                      // Offstage(
                      //   offstage: false,
                      //   child: _listImages(),
                      // )
                    ],
                  ),
                ),
                Offstage(
                  offstage: !showPhotos,
                  child: _listImages(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    final authService = Provider.of<AuthService>(context, listen: false);
    late Size mq = MediaQuery.of(context).size;

    return FutureBuilder(
      future: authService.messageExists(widget.user),
      builder: (context, snapshot) {
        bool messageExists = snapshot.data ?? false;

        return StreamBuilder(
          stream: authService.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list = data?.map((e) => ChatUserModel.fromJson(e.data())).toList() ?? [];

            return Container(
              margin: const EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_rounded, color: ColorsTheme.primary),
                      ),
                      if (messageExists)
                        Stack(
                          children: [
                            AvatarWidget(avatarUrl: list.isNotEmpty ? list[0].avatar : widget.user.avatar, width: 48, height: 48),
                            if (widget.user.isOnline)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: ColorsTheme.green,
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      if (messageExists) const SizedBox(width: 8),
                      if (messageExists)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: mq.width * .3),
                              child: Text(
                                list.isNotEmpty ? list[0].firstName : widget.user.firstName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Theme.of(context).iconTheme.color, fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                            Text(
                              list.isNotEmpty
                                  ? list[0].isOnline
                                      ? 'Online'
                                      : FormatDateUtil.formatDuration(list[0].lastActive)
                                  : FormatDateUtil.formatDuration(widget.user.lastActive),
                              style: TypographyTheme.text3(),
                            )
                          ],
                        ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(9999),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const FaIcon(FontAwesomeIcons.phone, color: ColorsTheme.primary, size: 20),
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        borderRadius: BorderRadius.circular(9999),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const FaIcon(FontAwesomeIcons.video, color: ColorsTheme.primary, size: 20),
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        borderRadius: BorderRadius.circular(9999),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const FaIcon(FontAwesomeIcons.circleInfo, color: ColorsTheme.primary, size: 20),
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(width: 12),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _chatInput() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final SoundController soundController = context.watch();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isInputFocused)
            IconButtonWidget(
              icon: const FaIcon(FontAwesomeIcons.angleRight, color: ColorsTheme.primary, size: 20),
              size: 38,
              onPressed: () {
                setState(() {
                  _isInputFocused = false;
                });
              },
            ),
          Visibility(
            visible: !_isInputFocused,
            child: Row(
              children: [
                IconButtonWidget(
                  icon: const FaIcon(FontAwesomeIcons.circlePlus, color: ColorsTheme.primary, size: 20),
                  size: 42,
                  onPressed: () {},
                ),
                IconButtonWidget(
                  icon: const FaIcon(FontAwesomeIcons.camera, color: ColorsTheme.primary, size: 20),
                  size: 42,
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    // Pick an image
                    XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
                    if (image != null) {
                      imageUrl = File(image.path);

                      setState(() => isUploading = false);
                      await authService.sendChatImage(widget.user, File(image.path));
                      setState(() => isUploading = true);
                    }
                  },
                ),
                IconButtonWidget(
                  icon: const FaIcon(FontAwesomeIcons.image, color: ColorsTheme.primary, size: 20),
                  size: 42,
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final List<XFile> images = await picker.pickMultiImage(imageQuality: 100);

                    for (var image in images) {
                      setState(() => isUploading = true);
                      await authService.sendChatImage(widget.user, File(image.path));
                      setState(() => isUploading = false);
                    }
                  },
                ),
                InkWell(
                  onTap: soundController.recordAudio,
                  borderRadius: BorderRadius.circular(999),
                  child: GestureDetector(
                    onTap: soundController.recordAudio,
                    onLongPress: soundController.recordAudio,
                    onLongPressEnd: (details) async {
                      Duration duration = soundController.recordDuration;
                      String? audioUrl = await soundController.stopAudio();

                      if (audioUrl != null) {
                        setState(() => isUploading = true);
                        await authService.sendAudioMessage(widget.user, audioUrl, duration);
                        setState(() => isUploading = false);
                      }
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      child: const FaIcon(FontAwesomeIcons.microphone, color: ColorsTheme.primary, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      maxLines: _isInputFocused ? 5 : 1,
                      minLines: 1,
                      style: const TextStyle(fontSize: 16),
                      controller: _textEditingController,
                      cursorColor: Theme.of(context).colorScheme.inversePrimary,
                      decoration: InputDecoration(
                        hintText: 'Aa${_isInputFocused ? '...' : ''}',
                        isDense: true,
                        contentPadding: const EdgeInsets.only(top: 4, right: 12, bottom: 8, left: 12),
                        border: InputBorder.none,
                        hintStyle: const TextStyle(color: ColorsTheme.grey, fontWeight: FontWeight.w400),
                      ),
                      onTap: () {
                        if (showEmoji) setState(() => showEmoji = !showEmoji);
                        if (showPhotos) setState(() => showPhotos = !showPhotos);
                        setState(() => _isInputFocused = FocusScope.of(context).hasFocus);
                        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                      },
                      focusNode: _focusNode,
                      onChanged: (text) {
                        bool newHasMessage = text.isNotEmpty;
                        bool newIsInputFocused = newHasMessage || _focusNode.hasFocus;

                        if (newHasMessage != _hasMessage || newIsInputFocused != _isInputFocused) {
                          setState(() {
                            _hasMessage = newHasMessage;
                            _isInputFocused = newIsInputFocused;
                          });
                        }
                      },
                    ),
                  ),
                  IconButtonWidget(
                    icon: const FaIcon(FontAwesomeIcons.solidFaceSmile, color: ColorsTheme.primary, size: 20),
                    size: 38,
                    onPressed: () {
                      setState(() {
                        showEmoji = !showEmoji;
                        FocusScope.of(context).unfocus();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          IconButtonWidget(
            icon: _hasMessage
                ? const FaIcon(FontAwesomeIcons.solidPaperPlane, color: ColorsTheme.primary, size: 20)
                : const FaIcon(FontAwesomeIcons.solidThumbsUp, color: ColorsTheme.primary, size: 20),
            size: 42,
            onPressed: () async {
              if (_hasMessage) {
                await authService.sendMessage(widget.user, _textEditingController.text.trim(), Type.text, null);
                _textEditingController.text = '';
                setState(() {
                  _hasMessage = false;
                  _isInputFocused = false;
                });
              } else {
                await authService.sendMessage(widget.user, emojiMain.name, Type.text, null);
              }

              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
          ),
        ],
      ),
    );
  }

  Widget _voiceRecord() {
    final soundController = context.watch<SoundController>();
    final authService = Provider.of<AuthService>(context, listen: false);

    Widget loadingIndicator = const SizedBox(
      height: 16,
      child: LoadingIndicator(
        indicatorType: Indicator.lineScale,
        colors: [Colors.white],
        strokeWidth: 2,
        backgroundColor: Colors.transparent,
        pathBackgroundColor: Colors.black,
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onLongPress: () async {
              Duration duration = soundController.recordDuration;
              String? audioUrl = await soundController.stopAudio();

              if (audioUrl != null) {
                setState(() => isUploading = true);
                await authService.sendAudioMessage(widget.user, audioUrl, duration);
                setState(() => isUploading = false);
              }
            },
            child: const IconButtonWidget(
              icon: FaIcon(
                FontAwesomeIcons.trash,
                size: 20,
                color: ColorsTheme.primary,
              ),
              size: 32,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(color: ColorsTheme.primary, borderRadius: BorderRadius.circular(999)),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.circlePause,
                  color: ColorsTheme.white,
                  size: 16,
                ),
                const SizedBox(width: 12),
                Row(
                  children: List.generate(18, (index) => index % 2 == 0 ? loadingIndicator : const SizedBox(width: 2)),
                ),
                const SizedBox(width: 12),
                Text(
                  soundController.audioTime,
                  style: TypographyTheme.text3(color: ColorsTheme.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listImages() {
    return DraggableScrollableSheet(
      initialChildSize: .3,
      minChildSize: .3,
      builder: (BuildContext context, ScrollController scrollController) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 12),
              color: ColorsTheme.white,
              child: GridView.count(
                controller: scrollController,
                primary: false,
                padding: EdgeInsets.zero,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                crossAxisCount: 3,
                children: _imageList
                    .map(
                      (image) => FutureBuilder(
                        future: image.file,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Shimmer.fromColors(
                              baseColor: ColorsTheme.grey,
                              highlightColor: ColorsTheme.greyLight,
                              child: const SizedBox(
                                width: 50,
                                height: 50,
                              ),
                            );
                          }

                          if (snapshot.connectionState == ConnectionState.done) {
                            if (image.type == AssetType.image) {
                              return GalleryItemWidget(path: snapshot.data!.path);
                            } else if (image.type == AssetType.video) {
                              return Container();
                            } else {
                              return Container();
                            }
                          }

                          return Container(
                            height: 20,
                            width: 100,
                            color: Colors.yellow,
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            Positioned(
              child: Container(
                width: 35,
                height: 4,
                decoration: BoxDecoration(
                  color: ColorsTheme.black.withOpacity(.4),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(9),
                    topLeft: Radius.circular(9),
                    bottomLeft: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
