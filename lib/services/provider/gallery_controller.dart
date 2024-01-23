import 'dart:async';

import 'package:flutter/material.dart';

class GalleryController extends ChangeNotifier {
  static final GalleryController _instance = GalleryController._internal();

  static GalleryController get instance => _instance;

  GalleryController._internal();

  final List<String> _galleryList = [];

  List<String> get galleryList => _galleryList;

  void toggleGallery(url) {
    if (_galleryList.contains(url)) _galleryList.remove(url);
    if (!_galleryList.contains(url)) _galleryList.add(url);
    notifyListeners();
  }
}
