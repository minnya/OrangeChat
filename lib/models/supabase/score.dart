// catsテーブルの定義

import 'package:orange_chat/models/supabase/users.dart';

class ScoreModel {
  int blockUsers;
  int blockPosts;
  double chatReviewGood;
  double chatReviewOkay;
  double chatReviewBad;
  double replayRate;
  double postReviewGood;
  double postReviewBad;
  double commentReviewGood;
  double commentReviewBad;
  double profileCompleteness;
  UserModel user;

  ScoreModel({
    required this.blockUsers,
    required this.blockPosts,
    required this.chatReviewGood,
    required this.chatReviewOkay,
    required this.chatReviewBad,
    required this.replayRate,
    required this.postReviewGood,
    required this.postReviewBad,
    required this.commentReviewGood,
    required this.commentReviewBad,
    required this.profileCompleteness,
    required this.user,
  });

  factory ScoreModel.fromMap(Map<String, dynamic> data) {
    return ScoreModel(
      blockUsers: data["block_users"],
      blockPosts: data["block_posts"],
      chatReviewGood: data["chat_review_good"].toDouble(),
      chatReviewOkay: data["chat_review_okay"].toDouble(),
      chatReviewBad: data["chat_review_bad"].toDouble(),
      replayRate: (data["count_unread"] + data["count_read"]) == 0
          ? 0
          : data["count_read"] / (data["count_unread"] + data["count_read"]),
      postReviewGood: data["post_review_good"].toDouble(),
      postReviewBad: data["post_review_bad"].toDouble(),
      commentReviewGood: data["comment_review_good"].toDouble(),
      commentReviewBad: data["comment_review_bad"].toDouble(),
      profileCompleteness: data["profile_completeness"].toDouble(),
      user: UserModel.fromMap(data),
    );
  }
}
