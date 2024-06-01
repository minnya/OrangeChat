import 'package:orange_chat/components/commons/base_page_presenter.dart';
import 'package:orange_chat/components/commons/show_dialog.dart';
import 'package:orange_chat/components/register/input_confirm.dart';
import 'package:orange_chat/components/register/input_email.dart';
import 'package:orange_chat/components/register/input_password.dart';
import 'package:orange_chat/components/register/input_username.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/main.dart';
import 'package:orange_chat/models/supabase/register.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
            function: () async{return true;}
        ),

        // ユーザー名の入力画面
        BasePageModel(
            title: 'Create username',
            description:
                'Choose a username for your new account. You can always change it later.',
            widget: InputUsername(
              registerModel: registerModel,
            ),
            function: () async{return true;}
        ),

        // パスワードの入力画面
        BasePageModel(
            title: 'Create a password',
            description:
                'We can remember the password, so you won\'t need to enter it on your device.',
            widget: InputPassword(
              registerModel: registerModel,
            ),
            function: () async{
              bool result = await showOKCancelDialog(context: context, message: "We will send confirmation to your email");

              if(result == false) return false;
              result = await AuthHelper(context: context).create(registerModel);

              return result;
            },
        ),

        BasePageModel(
            title: 'Enter confirmation code',
            description:
                'Enter the confirmation code we sent to ${registerModel.email}.',
            widget: InputConfirm(
              registerModel: registerModel,
            ),
            function: () async {
              bool result = await AuthHelper(context: context).verify(registerModel);

              if(result == false || !context.mounted) return false;
              result = await showOKDialog(context: context, message: "Account has been Created.");

              if(result==false || !context.mounted) return false;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const MyApp()));
              return result;
            },
        ),
      ]),
    );
  }
}
