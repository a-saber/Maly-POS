import 'package:image_picker/image_picker.dart';

abstract class ImageManagerState {}

class ImageManagerInit extends ImageManagerState {}

class ImageManagerSelectImage extends ImageManagerState {
  XFile image;
  ImageManagerSelectImage(this.image);
}
