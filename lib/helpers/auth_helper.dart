import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:orange_chat/components/commons/show_dialog.dart';
import 'package:orange_chat/const/variables.dart';
import 'package:orange_chat/models/supabase/register.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AuthHelper {
  final SupabaseClient client = Supabase.instance.client;
  final BuildContext? context;

  AuthHelper({this.context});

  bool isUserSignedIn() {
    GoTrueClient auth = Supabase.instance.client.auth;
    User? user = auth.currentUser;
    return user != null;
  }

  Future<bool> create(RegisterModel registerModel) async {
    try {
      print(registerModel.email);
      print(registerModel.password);
      final AuthResponse res = await client.auth.signUp(
          email: registerModel.email!,
          password: registerModel.password!,
          emailRedirectTo: '${ConstVariables.APP_HOSTNAME}/#/email-verified',
          data: {"name": registerModel.username!});
      final Session? session = res.session;
      final User? user = res.user;
      return user != null;
    } catch (e) {
      AuthException authException = e as AuthException;
      await showOKDialog(context: context!, message: authException.message);
      return false;
    }
  }

  Future<bool> verify(RegisterModel registerModel) async {
    try {
      final AuthResponse res = await client.auth.verifyOTP(
          token: registerModel.confirmCode!,
          type: OtpType.email,
          email: registerModel.email);
      print(res);
      final Session? session = res.session;
      final User? user = res.user;
      return user != null;
    } on AuthException catch (e) {
      await showOKDialog(context: context!, message: e.message);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> sendResetEmail(RegisterModel registerModel) async {
    try {
      print("${ConstVariables.APP_HOSTNAME}/#/reset-password");
      client.auth.resetPasswordForEmail(registerModel.email!,
          redirectTo: "${ConstVariables.APP_HOSTNAME}/#/reset-password");
      return true;
    } catch (e) {
      AuthException authException = e as AuthException;
      await showOKDialog(context: context!, message: authException.message);
      return false;
    }
  }

  Future<bool> resetPassword(RegisterModel registerModel) async {
    try {
      final UserResponse res = await client.auth.updateUser(
        UserAttributes(password: registerModel.password),
      );
      final User? user = res.user;
      return user != null;
    } catch (e) {
      AuthException authException = e as AuthException;
      if (!context!.mounted) return false;
      await showOKDialog(context: context!, message: authException.message);
      return false;
    }
  }

  Future<bool> login(String loginUserEmail, String loginUserPassword) async {
    try {
      await client.auth.signInWithPassword(
        email: loginUserEmail,
        password: loginUserPassword,
      );
      return true;
    } catch (e) {
      AuthException authException = e as AuthException;
      await showOKDialog(context: context!, message: authException.message);
      return false;
    }
  }

  String getUID() {
    User? user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      String invalidUuid = const Uuid().v4();
      return invalidUuid;
    } else {
      return user.id;
    }
  }

  bool isSignedIn() {
    return client.auth.currentUser != null;
  }

  void logout() {
    Supabase.instance.client.auth.signOut();
    showOKDialog(context: context!, message: "Successfully logged out");
  }

  Future<bool> delete({required BuildContext context}) async {
    bool choice = await showOKCancelDialog(
        context: context,
        message: "Are you sure you want to delete your account permanently?");
    if (choice == false) return false;
    try {
      FunctionResponse response =
          await client.functions.invoke("delete_user", body: {});
      if (response.status == 200) {
        await showOKDialog(
            context: context, message: "User has been successfully deleted.");
        client.auth.signOut();
      } else {
        showOKCancelDialog(context: context, message: "Something went wrong");
      }
    } on FunctionException catch (e) {
      print(e.details);
    }
    return true;
  }
}
