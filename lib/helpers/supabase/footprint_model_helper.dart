
import 'package:orange_chat/models/supabase/footprints.dart';
import 'package:orange_chat/models/supabase/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth_helper.dart';

class FootprintModelHelper {
  final uid = AuthHelper().getUID();
  final client = Supabase.instance.client;

  Future<List<FootprintModel>> getAllFootprints(BuildContext context) async {
    List<Map<String, dynamic>> footPrints = await client.from("view_footprinted_list")
    .select("*")
    .eq("my_id", uid)
    .neq("id", uid)
    .order("updated_at");

    List<FootprintModel> footprintList = footPrints.map((map) => FootprintModel.fromMap(map)).toList();

    // 自分がfollowしているかを判別
    List followingList = (await client.from("view_following_list").select("*")
        .eq("my_id", uid)).map((map) => map["id"]).toList();
    for (FootprintModel footprint in footprintList) {
      footprint.user.following = followingList.contains(footprint.user.id);
    }
    
    return footprintList;
  }

  Future<List<FootprintModel>> getAllMyFootprints(BuildContext context) async {
    List<Map<String, dynamic>> footPrints = await client.from("view_footprint_list")
        .select("*")
        .eq("my_id", uid)
        .neq("id", uid)
        .order("updated_at");
    List<FootprintModel> footprintList = footPrints.map((map) => FootprintModel.fromMap(map)).toList();

    // 自分がfollowしているかを判別
    List followingList = (await client.from("view_following_list").select("*")
        .eq("my_id", uid)).map((map) => map["id"]).toList();
    for (FootprintModel footprint in footprintList) {
      footprint.user.following = followingList.contains(footprint.user.id);
    }

    return footprintList;
  }

  Future<void> putFootPrint(UserModel userModel) async{
    if(uid==userModel.id) return ; // 自分には足あとを残さない
    await client.from("footprints")
        .upsert({
      "user": uid,
      "footprinted_user": userModel.id
    });
  }
}
