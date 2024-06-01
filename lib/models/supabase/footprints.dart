

import 'package:orange_chat/models/supabase/users.dart';

class FootprintModel{
  late UserModel user;
  DateTime createdAt;
  DateTime updatedAt;

  FootprintModel({
    required this.user,
    required this.createdAt,
    required this.updatedAt
  });

  factory FootprintModel.fromMap(
      Map<String, dynamic> footprintMap,
      ) {
    return FootprintModel(
        user: UserModel.fromMap(footprintMap),
        createdAt: DateTime.parse(footprintMap['created_at']),
      updatedAt: DateTime.parse(footprintMap["updated_at"]),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "user": null,
    };
  }
}