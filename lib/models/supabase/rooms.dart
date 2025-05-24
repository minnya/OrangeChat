import 'package:flutter/cupertino.dart';
import 'package:orange_chat/const/variables.dart';

// catsテーブルの定義
class RoomModel with ChangeNotifier {
  int roomId;
  String name;
  String? lastMessage;
  String userId;
  String? imageUrl;
  int countUnread = 0;
  DateTime createdAt;

  RoomModel({
    required this.roomId,
    required this.lastMessage,
    required this.userId,
    required this.name,
    required this.countUnread,
    this.imageUrl,
    required this.createdAt,
  });

  factory RoomModel.fromMap(Map<String, dynamic> roomMap) {
    return RoomModel(
      roomId: int.tryParse(roomMap["room_id"].toString()) ?? 0,
      userId: roomMap["member_id"],
      lastMessage: roomMap["last_message"],
      name: roomMap["room_name"],
      countUnread: int.tryParse(roomMap["count_unread"].toString()) ?? 0,
      imageUrl: roomMap["image_url"] == null
          ? null
          : "${ConstVariables.SUPABASE_HOSTNAME}${roomMap["image_url"].toString()}",
      createdAt: DateTime.parse(roomMap["created_at"]),
    );
  }

  void setRoomId(int roomId) {
    this.roomId = roomId;
    notifyListeners();
  }

  Map<String, dynamic> toSnapshot() {
    return {
      "lastMessageId": lastMessage,
      "user": userId,
    };
  }
}
