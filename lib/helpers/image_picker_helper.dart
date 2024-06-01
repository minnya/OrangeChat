import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  Future<File?> getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if(pickedFile==null) return null;
    else return File(pickedFile.path);
  }

  Future<File?> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile==null) return null;
    else return File(pickedFile!.path);
  }
}
