

import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/models/supabase/users.dart';


// catsテーブルの定義
class CommentModel {
  int id;
  int mentionedPostId;
  int? mentionedCommentId;
  String? mentionedUserId;
  String? mentionedUserName;
  String ownerId;
  String ownerName;
  String? ownerIconUrl;
  String message;
  DateTime createdAt;
  int likeCount = 0;
  int dislikeCount = 0;
  int replyCount = 0;
  bool liked = false;
  bool disliked = false;

  CommentModel({
    required this.id,
    required this.mentionedPostId,
    this.mentionedCommentId,
    this.mentionedUserId,
    this.mentionedUserName,
    required this.ownerId,
    required this.ownerName,
    this.ownerIconUrl,
    required this.message,
    required this.createdAt,
    required this.likeCount,
    required this.dislikeCount,
    required this.replyCount,
  });

  factory CommentModel.fromMap(
    Map<String, dynamic> data) {
    return CommentModel(
      id: data["id"],
      mentionedPostId: data["mentioned_post"],
      mentionedCommentId: data["mentioned_comment"],
      mentionedUserId: data["mentioned_user_id"],
      mentionedUserName: data["mentioned_user_name"]??"",
      ownerId: data["owner_id"],
      ownerName: data["owner_name"],
      ownerIconUrl: data["owner_icon_url"],
      message: data['message'],
      likeCount: data["count_likes"],
      dislikeCount: data["count_dislikes"],
      replyCount: data["count_replies"],
      createdAt: DateTime.parse(data['created_at']),
    );
  }

  Map<String, dynamic> toMap(String message) {
    return {
      "owner": AuthHelper().getUID(),
      "message": message,
    };
  }
}
