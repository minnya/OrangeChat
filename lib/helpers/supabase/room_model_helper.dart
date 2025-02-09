import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/helpers/supabase/user_model_helper.dart';
import 'package:orange_chat/models/supabase/rooms.dart';
import 'package:orange_chat/models/supabase/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomModelHelper {
  final uid = AuthHelper().getUID();
  SupabaseClient client = Supabase.instance.client;

  // 自分当てのメッセージが来たらRoomを更新できるように監視する
  void subscribeMessageChange(void Function(PostgresChangePayload) callback) {
    client
        .channel("public:chat_messages")
        .onPostgresChanges( //相手からのmessageをsubscribe
            event: PostgresChangeEvent.all,
            schema: "public",
            table: "chat_messages",
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: "receiver",
                value: uid),
            callback: callback)
        .onPostgresChanges( //自分からのメッセージをsubscribe
            event: PostgresChangeEvent.all,
            schema: "public",
            table: "chat_messages",
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: "sender",
                value: uid),
            callback: callback)
        .subscribe();
  }

  void unsubscribe(){
    client.channel("public:chat_message");
  }

  // Room一覧を取得する
  Future<List<RoomModel>> getRoomList() async {
    List<Map<String, dynamic>> roomListMap =
        await client.from('view_room_list').select("*")
            .eq("user_id", uid)
            .not("member_id", "in", await UserModelHelper().getBlocks()
        );
    return roomListMap.map((map) => RoomModel.fromMap(map)).toList();
  }

  Future<int> createRoom({required String userId}) async {
    // 空のchatroomを作成
    PostgrestMap newRoom =
        await client.from('chat_rooms').insert({}).select("*").single();

    // chat_entryを自分の分と相手の分作成
    List<Map<String, dynamic>> result =
        await client.from("chat_entries").insert([
      {"user": uid, "room": newRoom["id"]},
      {"user": userId, "room": newRoom["id"]},
    ]).select("*");

    return newRoom["id"];
  }

  Future<RoomModel> getRoom(UserModel userModel) async {
    List<Map<String, dynamic>> rooms = await client
        .from("view_chat_entries")
        .select("*")
        .eq("user_id", uid)
        .eq("member_id", userModel.id);

    // roomが存在しない場合は0を返す
    int roomId = 0;
    if(rooms.isNotEmpty){
      roomId = rooms.first["room_id"];
    }


    //必要なのはroomIDだけ
    RoomModel roomModel = RoomModel(
        roomId: roomId,
        lastMessage: "",
        userId: userModel.id,
        name: userModel.name,
        countUnread: 0,
        createdAt: DateTime.now());

    return roomModel;
  }
}
