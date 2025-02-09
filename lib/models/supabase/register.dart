import 'package:flutter/cupertino.dart';

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
