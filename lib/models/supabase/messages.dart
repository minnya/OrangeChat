
import 'package:orange_chat/const/variables.dart';

import '../../helpers/auth_helper.dart';

// catsテーブルの定義
class MessageModel{
  int id;
  String? content;
  String receiverId;
  int roomId;
  String senderId;
  bool? read;
  String? imageUrl;
  DateTime? createdAt;

  MessageModel({
    required this.id,
    this.content,
    this.imageUrl,
    required this.receiverId,
    required this.roomId,
    required this.senderId,
    this.read,
    this.createdAt,
  });

  factory MessageModel.fromMap(
      Map<String, dynamic> messageMap,
      ) {
    return MessageModel(
      id: messageMap["id"],
      content: messageMap["message"],
      imageUrl: messageMap["image_url"].toString().isEmpty || messageMap["image_url"]==null?null
          :"${ConstVariables.SUPABASE_HOSTNAME}${messageMap["image_url"]}",
      roomId: messageMap["room"],
      senderId: messageMap["sender"],
      receiverId: messageMap["receiver"],
      read: messageMap["is_read"],
      createdAt: DateTime.parse(messageMap["created_at"]),
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      "content": content,
      "receiverId": receiverId,
      "roomId": roomId,
      "senderId": AuthHelper().getUID(),
      "read": false,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };
  }
}