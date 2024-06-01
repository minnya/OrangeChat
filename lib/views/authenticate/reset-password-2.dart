import 'package:orange_chat/components/commons/custom_container.dart';
import 'package:orange_chat/tools/validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_html/html.dart' as html;

class ResetPasswordPage2 extends StatefulWidget {
  const ResetPasswordPage2({super.key});

  @override
  State<ResetPasswordPage2> createState() => _ResetPasswordPage2State();
}

class _ResetPasswordPage2State extends State<ResetPasswordPage2> {
  final TextEditingController _controller = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomContainer(
          direction: Direction.HORIZONTAL,
          height: 200,
          padding: const EdgeInsets.symmetric(vertical: 64),
          children: [
            Image.asset(
              "assets/images/foreground.png",
            ),
            // const SizedBox(width: 20,),
            Text(
              "Orange",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 36, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor,),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: const [],
      ),
      body: CustomContainer(
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.background,
          children: [
        CustomContainer(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(16.0),
          constraints: const BoxConstraints(maxWidth: 448),
          children: [
            const Text(
              'Reset Your Password',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter a new password to reset the password on your account. We'll ask for this whenever you log in.",
              style: TextStyle(fontSize: 14, ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _controller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: (){
                    _isObscure = !_isObscure;
                    setState(() {});
                }, icon: Icon(_isObscure?Icons.visibility_off:Icons.visibility))
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _isObscure,
              validator: (value)=>validatePassword(value),
            ),
            const SizedBox(height: 24),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              validator: (value){
                if(value!=_controller.text){
                  return "password doesn't match";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async{
                final GoTrueClient client = Supabase.instance.client.auth;
                String authCode = Uri
                    .parse(html.window.location.href)
                    .queryParameters['code']!;
                print(authCode);
                // final AuthSessionUrlResponse result = await client
                //     .exchangeCodeForSession(authCode);
                // print(result.session.user.id);
                final UserResponse res = await client.updateUser(
                    UserAttributes(password: _controller.text));
                print(res.user!.id);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                // primary: Colors.green,
              ),
              child: Center(
                child: Text('Reset Password', style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 16),),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
