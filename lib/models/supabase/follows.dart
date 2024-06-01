
// catsテーブルの定義
import 'package:orange_chat/models/supabase/users.dart';

class FollowModel{
  UserModel user;
  DateTime createdAt;

  FollowModel({
    required this.user,
    required this.createdAt,
  });

  factory FollowModel.fromMap(
       Map<String, dynamic> userMap,
      ) {
    return FollowModel(
        user: UserModel.fromMap(userMap),
        createdAt: DateTime.parse(userMap['created_at']));
  }

  Map<String, dynamic> toFirestore() {
    return {
      "user": 0,
      "created_at": DateTime.now().millisecond,
    };
  }
}