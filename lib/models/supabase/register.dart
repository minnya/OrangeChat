import 'package:orange_chat/models/supabase/edit_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class RegisterModel extends ChangeNotifier {
  String? username;
  String? email;
  String? password;
  String? confirmCode;

  RegisterModel({
    this.username,
    this.email,
    this.password,
    this.confirmCode
  });
}
