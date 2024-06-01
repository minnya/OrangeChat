import 'package:orange_chat/components/commons/show_dialog.dart';
import 'package:orange_chat/components/register/input_confirm.dart';
import 'package:orange_chat/components/register/input_email.dart';
import 'package:orange_chat/components/register/input_password.dart';
import 'package:orange_chat/components/register/input_username.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/main.dart';
import 'package:orange_chat/models/supabase/register.dart';
import 'package:flutter/material.dart';

import '../../bottom_nav.dart';
import '../../components/commons/base_page_presenter.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterModel registerModel = RegisterModel();

    return Scaffold(
      body: BasePagePresenter(pages: [
        // emailの入力画面
        BasePageModel(
            title: 'Enter email address',
            description: '',
            widget: InputEmail(
              registerModel: registerModel,
            ),
            function: () async {
              bool result = await showOKCancelDialog(context: context, message: "We will send confirmation email to your address",);
              if(result == false) return false;

              result = await AuthHelper().sendResetEmail(registerModel);

              return result;
              },
        ),

        // 確認コードの入力画面
        BasePageModel(
            title: 'Enter confirmation code',
            description:
            'Enter the confirmation code we sent to ${registerModel.email}.',
            widget: InputConfirm(
              registerModel: registerModel,
            ),
            function: () async {
              final bool result = await AuthHelper().verify(registerModel);

              if(!context.mounted) return false;
              await showOKDialog(context: context, message: "Your email has been confirmed.");

              return result;
            },
        ),

        // パスワードの入力画面
        BasePageModel(
            title: 'Reset your password',
            description: 'We can remember the password, so you won\'t need to enter it on your device.',
            widget: InputPassword(
              registerModel: registerModel,
            ),
            function: () async {
              final bool result = await AuthHelper(context: context).resetPassword(registerModel);

              if(result == false || !context.mounted) return false;
              await showOKDialog(context: context, message: "Password has been updated successfully");

              if(result == false || !context.mounted) return false;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyApp()));

              return result;
            },
        ),
      ]),
    );
  }
}
