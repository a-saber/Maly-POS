import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'image_manager_state.dart';

class ImageManagerCubit extends Cubit<ImageManagerState> {
  static ImageManagerCubit get(context) => BlocProvider.of(context);
  ImageManagerCubit() : super(ImageManagerInit());

  Future selectImage({required ImageSource source}) async {
    final ImagePicker picker = ImagePicker();
    XFile? selectedImage = await picker.pickImage(source: source);
    if (selectedImage != null) {
      emit(ImageManagerSelectImage(selectedImage));
    }
  }
}
