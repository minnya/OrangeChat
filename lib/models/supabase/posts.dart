
import 'dart:convert';

import 'package:orange_chat/const/variables.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/models/supabase/users.dart';


// catsテーブルの定義
class PostModel {
  int id;
  String message;
  DateTime createdAt;
  List<String>? imageUrls;
  int likeCount = 0;
  int commentCount = 0;
  bool liked = false;
  UserModel user;

  PostModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.imageUrls,
    required this.likeCount,
    required this.commentCount,
    required this.user,
  });

  factory PostModel.fromMap(
    Map<String, dynamic> data) {

    return PostModel(
      id: data["post_id"],
      message: data['message'],
      imageUrls: data['image_urls']!=null?jsonDecode(data['image_urls']).cast<String>():null,
      likeCount: data["count_likes"],
      commentCount: data["count_comments"],
      createdAt: DateTime.parse(data['created_at']),
      user: UserModel.fromMap(data),
    );
  }

  Map<String, dynamic> toMap(String message, List<String>? imageUrls) {
    return {
      "owner": AuthHelper().getUID(),
      "message": message,
      "image_urls": imageUrls,
    };
  }
}
