import 'package:flutter/cupertino.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/models/supabase/score.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/supabase/users.dart';

class ScoreModelHelper {
  final BuildContext? context;
  // DbHelperをinstance化する
  SupabaseClient client = Supabase.instance.client;
  String uid = AuthHelper().getUID();

  ScoreModelHelper({this.context});

  // ユーザーデータを全件取得
  Future<ScoreModel> get(UserModel userModel) async {
    // ユーザー一覧取得クエリ
    final result = await client
        .from("view_score")
        .select("*")
        .eq("id", userModel.id)
        .maybeSingle();
    final scoreModel = ScoreModel.fromMap(result!);
    ;
    return scoreModel;
  }
}
