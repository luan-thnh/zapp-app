import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

class GalleryModel {
  AssetType type;
  Future<File?> file;
  bool isSelected;

  GalleryModel({required this.type, required this.file, this.isSelected = false});
}
