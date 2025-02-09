import 'package:orange_chat/components/commons/show_dialog.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/models/supabase/posts.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/supabase/comments.dart';

class CommentModelHelper {
  final BuildContext context;
  SupabaseClient client = Supabase.instance.client;
  String uid = AuthHelper().getUID();

  CommentModelHelper({required this.context});

  // 投稿を全件取得する
  Future<List<CommentModel>> getAll({required PostModel postModel}) async {
    // ユーザーデータを取得
    PostgrestFilterBuilder<PostgrestList> commentQuery =
        client.from('view_comment_list').select("*").match({"mentioned_post":postModel.id}).isFilter("mentioned_comment", null);

    List<Map<String, dynamic>> comments = await commentQuery
        // .not("owner", "in", await UserModelHelper().getBlocks()) // Blockしたユーザーの投稿を除外
        .order("created_at", ascending: false);

    List<CommentModel> commentList = comments.map((commentMap) {
      return CommentModel.fromMap(commentMap);
    }).toList();

    // 自分がlikeしているかを判別
    List likeList = (await client.from("comment_likes").select("*").eq("user", uid)).map((map) => map["comment"]).toList();
    for (CommentModel comment in commentList) {
      comment.liked = likeList.contains(comment.id);
    }
    // 自分がdislikeしているかを判別
    List dislikeList = (await client.from("comment_dislikes").select("*").eq("user", uid)).map((map) => map["comment"]).toList();
    for (CommentModel comment in commentList) {
      comment.disliked = dislikeList.contains(comment.id);
    }

    return commentList;
  }

  // 投稿を全件取得する
  Future<List<CommentModel>> getAllReplies({required CommentModel commentModel}) async {
    // ユーザーデータを取得
    PostgrestFilterBuilder<PostgrestList> commentQuery =
    client.from('view_comment_list').select("*").match({"mentioned_comment":commentModel.id});

    List<Map<String, dynamic>> comments = await commentQuery
        .order("created_at", ascending: false);

    List<CommentModel> commentList = comments.map((commentMap) {
      return CommentModel.fromMap(commentMap);
    }).toList();

    // 自分がlikeしているかを判別
    List likeList = (await client.from("comment_likes").select("*").eq("user", uid)).map((map) => map["comment"]).toList();
    for (CommentModel comment in commentList) {
      comment.liked = likeList.contains(comment.id);
    }
    // 自分がdislikeしているかを判別
    List dislikeList = (await client.from("comment_dislikes").select("*").eq("user", uid)).map((map) => map["comment"]).toList();
    for (CommentModel comment in commentList) {
      comment.disliked = dislikeList.contains(comment.id);
    }

    return commentList;
  }

  Future<bool> putComment({required String message, required int mentionedPostId, int? mentionedCommentId, String? mentionedUserId}) async{
    try {
      final result = await client.from('comments').insert({
        'owner': uid,
        'message': message,
        "mentioned_post": mentionedPostId,
        "mentioned_comment": mentionedCommentId,
        "mentioned_user": mentionedUserId,
      }).select();
      if(!context.mounted) return false;
      // await showOKDialog(context: context, message: "Comment has been submitted");
      return result.isNotEmpty;
    }catch(e){
      print(e.toString());
      showOKDialog(context: context, message: "Something went wrong");
     return false;
    }
  }

  Future<void> deleteComment({required CommentModel commentModel})async {
    await client.from("comments").delete().match({"id": commentModel.id});
  }

  // Likeを追加する
  Future<bool> putLike(int commentId) async {
    final result = await client.from('comment_likes').insert({'user': uid, 'comment': commentId}).select("*");
    return result.isNotEmpty;
  }

  // Likeを削除する
  Future<void> deleteLike(int commentId) async {
    await client.from('comment_likes').delete().match({'user': uid, 'comment': commentId});
  }

  // Dislikeを追加する
  Future<bool> putDislike(int commentId) async {
    final result = await client.from('comment_dislikes').insert({'user': uid, 'comment': commentId,}).select("*");
    return result.isNotEmpty;
  }

  // Dislikeを削除する
  Future<void> deleteDislike(int commentId) async {
    await client.from('comment_dislikes').delete().match({'user': uid, 'comment': commentId,});
  }
}
