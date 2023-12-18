import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messenger/services/provider/gallery_controller.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:provider/provider.dart';

class GalleryItemWidget extends StatefulWidget {
  final String path;
  const GalleryItemWidget({super.key, required this.path});

  @override
  State<GalleryItemWidget> createState() => _GalleryItemWidgetState();
}

class _GalleryItemWidgetState extends State<GalleryItemWidget> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final galleryController = context.watch<GalleryController>();

    return InkWell(
      onTap: () {
        setState(() => _isChecked = !_isChecked);
        // galleryController.toggleGallery(widget.path);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: ColorsTheme.greyLight,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200), // Adjust the duration as needed
              opacity: _isChecked ? 0.6 : 1.0,
              child: Image.file(
                File(widget.path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          if (_isChecked)
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorsTheme.blue,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${1}',
                style: TypographyTheme.text1(color: ColorsTheme.white),
              ),
            ),
        ],
      ),
    );
  }
}

class GalleryExampleItem {
  GalleryExampleItem({
    required this.id,
    required this.resource,
    this.isSvg = false,
  });

  final String id;
  final String resource;
  final bool isSvg;
}

class GalleryExampleItemThumbnail extends StatelessWidget {
  const GalleryExampleItemThumbnail({
    Key? key,
    required this.galleryExampleItem,
    required this.onTap,
  }) : super(key: key);

  final GalleryExampleItem galleryExampleItem;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryExampleItem.id,
          child: Image.network(galleryExampleItem.resource, height: 300.0),
        ),
      ),
    );
  }
}

List<GalleryExampleItem> galleryItems = <GalleryExampleItem>[
  GalleryExampleItem(
    id: "tag1",
    resource: "https://source.unsplash.com/random/50?gallery&sig=1.jpg",
  ),
  GalleryExampleItem(
    id: "tag3",
    resource: "https://source.unsplash.com/random/50?gallery&sig=2.jpg",
  ),
  GalleryExampleItem(
    id: "tag4",
    resource: "https://source.unsplash.com/random/50?gallery&sig=3.jp",
  ),
];
