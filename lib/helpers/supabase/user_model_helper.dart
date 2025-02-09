import 'package:orange_chat/components/commons/show_dialog.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/helpers/supabase/footprint_model_helper.dart';
import 'package:orange_chat/models/supabase/filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/supabase/users.dart';

class UserModelHelper {
  final BuildContext? context;
  // DbHelperをinstance化する
  SupabaseClient client = Supabase.instance.client;
  String uid = AuthHelper().getUID();

  UserModelHelper({this.context});

  // ユーザーデータを全件取得
  Future<List<UserModel>> getAll() async {
    // フィルター条件を取得
    FilterModel filterModel = await FilterModel.load();

    // ユーザー一覧取得クエリ
    PostgrestFilterBuilder<List<Map<String, dynamic>>> builder = client
        .from("view_user_list")
        .select("*")
        .neq("id", uid)
        .not("id", "in", await getBlocks() // ブロックしたユーザーを除外
    );
    if(filterModel.getFilterString().isNotEmpty){
      builder = builder.or("and(${filterModel.getFilterString()})");
    }
    PostgrestList userPostgrestList = await builder.order("updated_at",ascending: false).limit(100);

    List<UserModel> userList =
        userPostgrestList.map((userMap) => UserModel.fromMap(userMap)).toList();

    return userList;
  }

  // 特定ユーザーのデータを取得
  Future<UserModel> get(String userId) async {
    PostgrestList postgresMapList =
        await client.from("view_profile").select("*").eq("id", userId);

    // ユーザーを取得できない場合は空のユーザーを返す
    if(postgresMapList.isEmpty){
      return UserModel.createEmpty();
    }

    PostgrestMap postgresMap = postgresMapList.first;
    UserModel userModel = UserModel.fromMap(postgresMap);

    // フォロー状況を確認
    List<Map<String, dynamic>> follows = await client
        .from("view_following_list")
        .select("*")
        .match({"my_id": uid, "id": userId});
    userModel.following = follows.isNotEmpty;

    // footprintを残す
    if(AuthHelper().isSignedIn()) {
      await FootprintModelHelper().putFootPrint(userModel);
    }
    print(userModel.toMap());
    return userModel;
  }

  Future<bool> update(UserModel editUserModel) async{
    try {
      print(editUserModel.toMap());
      PostgrestList userModels = await client.from("users")
          .update(editUserModel.toMap())
          .match({"id": uid})
          .select();
      await showOKDialog(context: context!, message: "Profile has been updated");
      return userModels.isNotEmpty;
    }catch(e){
      if(!context!.mounted) return false;
      await showOKDialog(context: context!, message: e.toString());
      return false;
    }
  }
  
  // ブロックしたユーザーを取得
  Future<List> getBlocks() async{
    return (await client.from("block_users").select("*").eq("user", uid)).map((e) => e["blocked_user"]).toList();
  }

  Future<List<UserModel>> getBlockedUsers() async{
    return (await client.from("view_block_user_list").select("*").eq("my_id", uid)).map((e) => UserModel.fromMap(e)).toList();
  }

  // ユーザーをブロックに追加
  Future<bool> putBlock({required UserModel userModel}) async{
    final result = await client.from("block_users")
        .insert({
      "user": uid,
      "blocked_user": userModel.id})
        .select("*");
    return result.isNotEmpty;
  }

  Future<bool> deleteBlock({required UserModel userModel}) async{
    final result = await client.from("block_users").delete()
        .match({
      "user": uid,
      "blocked_user":userModel.id})
        .select("*");
    return result.isNotEmpty;
  }
}
