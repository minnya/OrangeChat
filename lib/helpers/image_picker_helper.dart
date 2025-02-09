import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImagePickerHelper {
  Future<File?> getImageFromCamera() async {
    if(!await getCameraPermission()){
      return null;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if(pickedFile==null) {
      return null;
    } else {
      return File(pickedFile.path);
    }
  }

  Future<File?> getImageFromGallery() async {
    if(!await getStoragePermission()){
      return null;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile==null) {
      return null;
    } else {
      return File(pickedFile.path);
    }
  }

  Future<bool> getCameraPermission() async{
    PermissionStatus permissionStatus = await Permission.camera.status;
    if(permissionStatus.isGranted){
      return true;
    }else if(permissionStatus.isDenied){
      PermissionStatus status = await Permission.camera.request();
      if(status.isGranted){
        return true;
      }else{
        Fluttertoast.showToast(
          msg: "Camera permission is required",
          toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
          gravity: ToastGravity.BOTTOM, // 位置（TOP, CENTER, BOTTOM）
        );
        return false;
      }
    }
    return false;
  }

  Future<bool> getStoragePermission() async{
    PermissionStatus permissionStatus = await Permission.photos.status;
    if(permissionStatus.isGranted){
      return true;
    }else if(permissionStatus.isDenied){
      PermissionStatus status = await Permission.photos.request();
      if(status.isGranted){
        return true;
      }else{
        Fluttertoast.showToast(
          msg: "Storage permission is required",
          toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
          gravity: ToastGravity.BOTTOM, // 位置（TOP, CENTER, BOTTOM）
        );
        return false;
      }

    }
    return false;
  }
}
