import 'dart:io';

import 'package:video_thumbnail/video_thumbnail.dart';

Future<String> generateVideoThumbnail(File? file) async {
  if (file == null) {
    throw ArgumentError('File cannot be null.');
  }

  final thumbnail = await VideoThumbnail.thumbnailFile(
    video: file.path,
    thumbnailPath: file.path,
    imageFormat: ImageFormat.JPEG,
    maxWidth: 50,
    quality: 25,
  );

  print('thumbnail: $thumbnail');

  if (thumbnail != null) {
    return thumbnail;
  } else {
    // Handle the case where the thumbnail is null
    throw Exception('Failed to generate video thumbnail.');
  }
}
