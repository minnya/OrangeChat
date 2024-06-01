
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../views/authenticate/register.dart';
import '../../views/authenticate/sign-in.dart';

void showUrgeLoginDialog(BuildContext context) {
  showDialog(
      context: context, builder: (BuildContext context) => UrgeLoginDialog());
}

class UrgeLoginDialog extends StatelessWidget {
  const UrgeLoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("Please register before using this feature"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => RegisterPage()));
          },
          child: Text('Register'),
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SignInPage()));
          },
          child: Text('Login'),
        ),
      ],
    );
  }
}
