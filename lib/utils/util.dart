
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

Stream<Uint8List> getVideoThumbnails(XFile? file) async* {
  Uint8List? _bytes = await VideoThumbnail.thumbnailData(
    imageFormat: ImageFormat.JPEG,
    video: file?.path ?? '',
    timeMs: 0,
  );
  if (_bytes != null) {
    yield _bytes;
  }
}



List<List<double>> filterList = [
  noFilter,
  greyScale,
  sepia,
  filter1,
];

const noFilter = [
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0
];

const sepia = [
  0.39,
  0.769,
  0.189,
  0.0,
  0.0,
  0.349,
  0.686,
  0.168,
  0.0,
  0.0,
  0.272,
  0.534,
  0.131,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0
];

const greyScale = [
  0.2126,
  0.7152,
  0.0722,
  0.0,
  0.0,
  0.2126,
  0.7152,
  0.0722,
  0.0,
  0.0,
  0.2126,
  0.7152,
  0.0722,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0
];

const filter1 = [
  1.1,
  0.2,
  0.2,
  0.0,
  0.0,
  0.0,
  1.1,
  0.2,
  0.0,
  0.0,
  0.2,
  0.0,
  1.1,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.1,
  0.0
];


