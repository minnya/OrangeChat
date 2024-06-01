import 'dart:io';

import 'package:orange_chat/models/supabase/place.dart';
import 'package:orange_chat/models/supabase/users.dart';
import 'package:flutter/cupertino.dart';

class EditUserModel extends ChangeNotifier {
  final id;
  String name;
  String? iconUrl;
  File? uploadFile;
  String? age;
  String? gender;
  String? description;
  PlaceModel placeModel;

  EditUserModel({
    required this.id,
    required this.name,
    required this.iconUrl,
    this.uploadFile,
    required this.age,
    required this.gender,
    required this.placeModel,
    required this.description,
  });

  ImageProvider? getImage() {
    if (uploadFile != null) {
      return FileImage(uploadFile!);
    } else if (iconUrl != null) {
      return NetworkImage(iconUrl!);
    } else {
      return null;
    }
  }

  UserModel toUserModel() {
    return UserModel(id: id,
        name: name,
        iconUrl: iconUrl,
        age: age,
        gender: gender,
        country: placeModel.country,
        prefecture: placeModel.prefecture,
        description: description,
        postCount: 0,
        followingCount: 0,
        followerCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
  }
}
