import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/models/supabase/follows.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/supabase/users.dart';

class FollowModelHelper {
  // DbHelperをinstance化する
  final client = Supabase.instance.client;
  final uid = AuthHelper().getUID();

  Future<List<FollowModel>> getAllFollowers(String userId) async {
    List<Map<String, dynamic>> followers =
        await client.from("view_follower_list").select("*").eq("my_id", userId);

    List<FollowModel> followerList = followers.map((map) => FollowModel.fromMap(map)).toList();

    // 自分がfollowしているかを判別
    List followingList = (await client.from("view_following_list").select("*")
        .eq("my_id", uid)).map((map) => map["id"]).toList();
    for (FollowModel follower in followerList) {
      follower.user.following = followingList.contains(follower.user.id);
    }

    return followerList;
  }

  Future<List<FollowModel>> getAllFollowings(String userId) async {
    List<Map<String, dynamic>> followings = await client
        .from("view_following_list")
        .select("*")
        .eq("my_id", userId);

    List<FollowModel> followingList = followings.map((map) => FollowModel.fromMap(map)).toList();

    followingList.forEach((following) {
      following.user.following=true;
    });

    return followingList;
  }

  Future<void> putFollow(UserModel userModel) async {
    await client
        .from("follows")
        .insert({"following": uid, "follower": userModel.id});
  }

  Future<void> deleteFollow(UserModel userModel) async {
    await client
        .from("follows")
        .delete()
        .match({"following": uid, "follower": userModel.id});
  }
}
