import 'package:flutter/cupertino.dart';
import 'package:orange_chat/const/variables.dart';
import 'package:orange_chat/models/supabase/edit_users.dart';
import 'package:orange_chat/models/supabase/place.dart';
import 'package:uuid/uuid.dart';

class UserModel extends ChangeNotifier {
  final id;
  String name;
  String? iconUrl;
  String? age;
  String? gender;
  String? country;
  String? prefecture;
  String? description;
  int postCount;
  int followerCount;
  int followingCount;
  bool following = false;
  DateTime createdAt;
  DateTime updatedAt;
  double score;

  UserModel({
    required this.id,
    required this.name,
    this.iconUrl,
    this.age,
    this.gender,
    this.country,
    this.prefecture,
    this.description,
    this.postCount = 0,
    this.followingCount = 0,
    this.followerCount = 0,
    this.score = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(
    Map<String, dynamic> data,
  ) {
    return UserModel(
      id: data["id"],
      name: data['name'],
      iconUrl: data['icon_url'] == null
          ? null
          : "${ConstVariables.SUPABASE_HOSTNAME}${data['icon_url']}",
      age: data['age'],
      gender: data["gender"],
      country: data["country"],
      prefecture: data["prefecture"],
      description: data["description"],
      postCount: data["count_posts"] ?? 0,
      followerCount: data["count_followers"] ?? 0,
      followingCount: data["count_followings"] ?? 0,
      score: (data["score"] ?? 0).toDouble(),
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data["updated_at"]),
    );
  }

  EditUserModel toEditModel() {
    return EditUserModel(
      id: id,
      name: name,
      iconUrl: iconUrl,
      age: age,
      gender: gender,
      placeModel: PlaceModel(country: country, prefecture: prefecture),
      description: description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "icon_url": iconUrl?.replaceAll(ConstVariables.SUPABASE_HOSTNAME, ""),
      "age": age,
      "gender": gender,
      "country": country,
      "prefecture": prefecture,
      "description": description,
    };
  }

  static UserModel createEmpty() {
    return UserModel(
        id: Uuid().v4(), // invalid uuid
        name: "",
        iconUrl: null,
        age: "",
        gender: "",
        country: "",
        prefecture: "",
        description: "",
        postCount: 0,
        followingCount: 0,
        followerCount: 0,
        score: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
  }
}
