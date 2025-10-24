import 'package:flutter/material.dart';
import 'package:orange_chat/components/commons/review_dialog.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/helpers/supabase/room_model_helper.dart';
import 'package:orange_chat/models/supabase/messages.dart';
import 'package:orange_chat/models/supabase/rooms.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageModelHelper {
  SupabaseClient client = Supabase.instance.client;
  String uid = AuthHelper().getUID();
  RoomModel roomModel;
  BuildContext context;
  late Stream<List<MessageModel>> messageStream;
  MessageModelHelper({required this.context, required this.roomModel}) {
    messageStream = client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq("room", roomModel.roomId)
        .order("created_at", ascending: false)
        .map((maps) => maps.map((map) => MessageModel.fromMap(map)).toList());
  }
  Stream<List<MessageModel>> streamMessageList(RoomModel roomModel) {
    print("setStream: ${roomModel.roomId}");
    return client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq("room", roomModel.roomId)
        .order("created_at", ascending: false)
        .map((maps) => maps.map((map) => MessageModel.fromMap(map)).toList());
  }

  //　送信処理
  Future<bool> submit({String? message, String? imageUrl}) async {
    // 特定のメッセージ回数になったら、相手を評価するダイアログを表示する
    final messages = await messageStream.first;
    if (messages.where((msg) => msg.senderId == uid).toList().length == 50) {
      final result =
          await showReviewDialog(context: context, roomModel: roomModel);
      if (!result) return false;
    }
    // roomModelのroomIdが0の場合は、roomがないので作成する
    if (roomModel.roomId == 0) {
      roomModel.setRoomId(
          await RoomModelHelper().createRoom(userId: roomModel.userId));
    }
    // メッセージを送信する
    final result = await client.from("chat_messages").insert([
      {
        "sender": uid,
        "receiver": roomModel.userId,
        "room": roomModel.roomId,
        "message": message,
        "image_url": imageUrl,
      }
    ]).select("*");
    return result.isNotEmpty;
  }

  // 既読処理
  Future<List<MessageModel>> updateRead(List<MessageModel> messageList) async {
    print("roomID: ${roomModel.roomId}");
    print("uid: $uid");
    final result = await client
        .from("chat_messages")
        .update({'is_read': true}).match({
      "room": roomModel.roomId,
      "receiver": uid,
      "is_read": false
    }).select("*");
    return messageList;
  }
}
