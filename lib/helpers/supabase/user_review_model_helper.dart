import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/models/supabase/rooms.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserReviewModelHelper {
  SupabaseClient client = Supabase.instance.client;
  String uid = AuthHelper().getUID();

  //　送信処理
  Future<bool> submit(
      {required RoomModel roomModel, required int score}) async {
    final result = await client.from("chat_review").insert([
      {
        "room": roomModel.roomId,
        "reviewer": uid,
        "reviewee": roomModel.userId,
        "score": score
      }
    ]).select("*");
    return result.isNotEmpty;
  }
}
