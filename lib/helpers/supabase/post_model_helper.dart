import 'dart:convert';

import 'package:orange_chat/components/commons/show_dialog.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/helpers/supabase/user_model_helper.dart';
import 'package:orange_chat/models/supabase/posts.dart';
import 'package:orange_chat/models/supabase/users.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostModelHelper {
  final BuildContext context;
  SupabaseClient client = Supabase.instance.client;
  String uid = AuthHelper().getUID();

  PostModelHelper({required this.context});

  // 投稿を全件取得する
  Future<List<PostModel>> getAll({UserModel? userModel, PostModel? postModel, String keyword = "", required String tableName}) async {
    // ユーザーデータを取得
    PostgrestFilterBuilder<PostgrestList> postQuery =
        client.from(tableName).select("*");

    if(userModel!=null){
      postQuery = postQuery.match({"id": userModel.id});
    }

    // 検索
    if(keyword.isNotEmpty){
      postQuery = postQuery.textSearch("message", keyword.replaceAll(" ", " & "), type: TextSearchType.plain, config: "simple");
    }

    List<Map<String, dynamic>> posts = await postQuery
        .not("id", "in", await UserModelHelper().getBlocks()); // Blockしたユーザーの投稿を除外

    List<PostModel> postList = posts.map((postMap) {
      return PostModel.fromMap(postMap);
    }).toList();

    // 自分がlikeしているかを判別
    List likeList = (await client.from("post_likes").select("*").eq("user", uid)).map((map) => map["post"]).toList();
    for (PostModel post in postList) {
      post.liked = likeList.contains(post.id);
    }
    return postList;
  }

  Future<bool> putPost({required String message, List<String>? imageUrls}) async{
    try {
      final result = await client.from('posts').insert({
        'owner': uid,
        'message': message,
        "image_urls": jsonEncode(imageUrls),
      }).select();
      if(!context.mounted) return false;
      await showOKDialog(context: context, message: "Post has been uploaded");
      return result.isNotEmpty;
    }catch(e){
      print(e.toString());
      showOKDialog(context: context, message: "Something went wrong");
     return false;
    }
  }

  Future<void> deletePost({required PostModel postModel}) async{
    await client.from("posts").delete().match({"id": postModel.id});
  }

  // Likeを追加する
  Future<bool> putLike(int postId) async {
    final result = await client.from('post_likes').insert({'user': uid, 'post': postId}).select("*");
    return result.isNotEmpty;
  }

  // Likeを削除する
  Future<void> deleteLike(int postId) async {
    await client.from('post_likes').delete().match({'user': uid, 'post': postId});
  }


}
